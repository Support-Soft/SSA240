codeunit 71905 "SSAFTSAFT Export Mgt."
{
    // SSM2101 SSCAT 04.01.2023 SAF-T

    TableNo = "SSAFTSAFT Export Header";

    trigger OnRun()
    begin
        StartExport(Rec);
    end;

    var
        ExportIsInProgressMsg: Label 'The export is in progress. Starting a new job cancels the current progress.\';
        LinesInProgressOrCompletedMsg: Label 'One or more export lines are in progress or completed.\';
        CancelExportIsInProgressQst: Label 'Do you want to cancel all export jobs and restart?';
        DeleteExportIsInProgressQst: Label 'Do you want to delete the export entry?';
        RestartExportLineQst: Label 'Do you want to restart the export for this line?';
        ExportIsCompletedQst: Label 'The export was completed. You can download the export result choosing the Download SAF-T File action.\';
        RestartExportQst: Label 'Do you want to restart the export to get a new SAF-T file?';
        SetStartDateTimeAsCurrentQst: Label 'The Earliest Start Date/Time field is not filled in. Do you want to proceed and start the export immediately?';
        GenerateSAFTFileImmediatelyQst: Label 'Since you did not schedule the SAF-T file generation, it will be generated immediately which can take a while. Do you want to continue?';
        NoErrorMessageErr: Label 'The generation of a SAF-T file failed but no error message was logged.';
        FilesExistsInFolderErr: Label 'One or more files exist in the folder that you want to export the SAF-T file to. Specify a folder with no files in it.';
        SAFTFileGeneratedTxt: Label 'SAF-T file generated.';
        SAFTFileNotGeneratedTxt: Label 'SAF-T file not generated.';
        ParallelSAFTFileGenerationTxt: Label 'Parallel SAF-T file generation';
        ZipArchiveFilterTxt: Label 'Zip File (*.zip)|*.zip', Locked = true;
        SAFTZipFileTxt: Label 'SAF-T Financial.zip', Locked = true;
        ZipArchiveSaveDialogTxt: Label 'Export SAF-T archive';
        NoZipFileGeneratedErr: Label 'No zip file generated.';
        NoOfJobsInProgressTxt: Label 'No of jobs in progress: %1', Comment = '%1 = number';
        JobsStartedOrFailedTxt: Label 'There are %1 jobs not started or failed', Comment = '%1 = number';
        SessionLostTxt: Label 'The task for line %1 was lost.', Comment = '%1 = number';
        NotPossibleToScheduleTxt: Label 'It is not possible to schedule the task for line %1 because the Max. No. of Jobs field contains %2.', Comment = '%1,%2 = numbers';
        ScheduleTaskForLineTxt: Label 'Schedule a task for line %1.', Comment = '%1 = number';

    local procedure StartExport(var SAFTExportHeader: Record "SSAFTSAFT Export Header")
    var
        TypeHelper: Codeunit "Type Helper";
    begin
        if not PrepareForExport(SAFTExportHeader) then
            exit;

        CreateExportLines(SAFTExportHeader);

        SAFTExportHeader.Validate(Status, SAFTExportHeader.Status::"In Progress");
        SAFTExportHeader.Validate("Execution Start Date/Time", TypeHelper.GetCurrentDateTimeInUserTimeZone);
        SAFTExportHeader.Validate("Execution End Date/Time", 0DT);
        Clear(SAFTExportHeader."SAF-T File");
        SAFTExportHeader.Modify(true);
        Commit;

        StartExportLines(SAFTExportHeader);
        SAFTExportHeader.Find;
    end;


    procedure DeleteExport(var SAFTExportHeader: Record "SSAFTSAFT Export Header")
    var
        SAFTExportLine: Record "SSAFTSAFT Export Line";
    begin
        if not CheckStatus(SAFTExportHeader.Status, DeleteExportIsInProgressQst) then
            exit;
        SAFTExportLine.SetRange(ID, SAFTExportHeader.ID);
        SAFTExportLine.SetRange(Status, SAFTExportLine.Status::"In Progress");
        if SAFTExportLine.FindSet then
            repeat
                CancelTask(SAFTExportLine);
            until SAFTExportLine.Next = 0;
        SAFTExportLine.SetRange(Status);
        SAFTExportLine.DeleteAll(true);
    end;


    procedure RestartTaskOnExportLine(var SAFTExportLine: Record "SSAFTSAFT Export Line")
    var
        SAFTExportHeader: Record "SSAFTSAFT Export Header";
        DummyNoOfJobs: Integer;
        NotBefore: DateTime;
    begin
        if not CheckLineStatusForRestart(SAFTExportLine) then
            exit;
        if not SAFTExportLine.FindSet then
            exit;

        //SSM1724 REPEAT
        SAFTExportLine.SetRange(ID, SAFTExportLine.ID);
        repeat
            CancelTask(SAFTExportLine);
            SAFTExportHeader.Get(SAFTExportLine.ID);
            NotBefore := CurrentDateTime;
            RunGenerateSAFTFileOnSingleLine(SAFTExportLine, DummyNoOfJobs, NotBefore, SAFTExportHeader);
        until SAFTExportLine.Next = 0;
        SAFTExportHeader.Find;
        UpdateExportStatus(SAFTExportHeader);
        SAFTExportLine.SetRange(ID);
        //SSM1724 UNTIL SAFTExportLine.NEXT = 0;
    end;


    procedure UpdateExportStatus(var SAFTExportHeader: Record "SSAFTSAFT Export Header")
    var
        SAFTExportLine: Record "SSAFTSAFT Export Line";
        TypeHelper: Codeunit "Type Helper";
        TotalCount: Integer;
        Status: Integer;
    begin
        if SAFTExportHeader.ID = 0 then
            exit;

        SAFTExportLine.SetRange(ID, SAFTExportHeader.ID);
        SAFTExportLine.SetRange("Export File", true); //SSM1724
        TotalCount := SAFTExportLine.Count;
        SAFTExportLine.SetRange(Status, SAFTExportLine.Status::Completed);
        if SAFTExportLine.Count = TotalCount then begin
            SAFTExportHeader.Validate(Status, SAFTExportHeader.Status::Completed);
            SAFTExportHeader.Validate("Execution End Date/Time", TypeHelper.GetCurrentDateTimeInUserTimeZone);
            SAFTExportHeader.Modify(true);
            exit;
        end;

        SAFTExportLine.SetRange(Status, SAFTExportLine.Status::Failed);
        if SAFTExportLine.IsEmpty then
            Status := SAFTExportHeader.Status::"In Progress"
        else
            Status := SAFTExportHeader.Status::Failed;

        SAFTExportHeader.Validate(Status, Status);
        SAFTExportHeader.Modify(true);
    end;


    procedure StartExportLinesNotStartedYet(SAFTExportHeader: Record "SSAFTSAFT Export Header")
    var
        SAFTExportLine: Record "SSAFTSAFT Export Line";
        NoOfJobs: Integer;
        NotBefore: DateTime;
        RunThisLine: Boolean;
    begin
        if not SAFTExportHeader."Parallel Processing" then
            exit;

        NoOfJobs := GetNoOfJobsInProgress;
        LogState(SAFTExportLine, StrSubstNo(NoOfJobsInProgressTxt, NoOfJobs));
        if NoOfJobs > SAFTExportHeader."Max No. Of Jobs" then
            exit;

        SAFTExportLine.LockTable;
        SAFTExportLine.SetRange(ID, SAFTExportHeader.ID);
        SAFTExportLine.SetRange("Export File", true); //SSM1724
        SAFTExportLine.SetFilter("No. Of Retries", '<>%1', 0);
        SAFTExportLine.SetFilter(Status, '<>%1', SAFTExportLine.Status::Completed);
        LogState(SAFTExportLine, StrSubstNo(JobsStartedOrFailedTxt, SAFTExportLine.Count));
        if not SAFTExportLine.FindSet then
            exit;

        NotBefore := CurrentDateTime;
        repeat
            RunThisLine := false;
            if SAFTExportLine.Status = SAFTExportLine.Status::"In Progress" then begin
                RunThisLine := not IsSessionActive(SAFTExportLine."Session ID");
                if RunThisLine then
                    LogState(SAFTExportLine, StrSubstNo(SessionLostTxt, SAFTExportLine."Line No."));
            end else
                RunThisLine := true;
            if RunThisLine then
                RunGenerateSAFTFileOnSingleLine(SAFTExportLine, NoOfJobs, NotBefore, SAFTExportHeader);
        until SAFTExportLine.Next = 0;
    end;


    procedure ShowActivityLog(SAFTExportLine: Record "SSAFTSAFT Export Line")
    var
        ActivityLog: Record "Activity Log";
    begin
        ActivityLog.SetRange("Record ID", SAFTExportLine.RecordId);
        PAGE.Run(PAGE::"Activity Log", ActivityLog);
    end;


    procedure ShowErrorOnExportLine(SAFTExportLine: Record "SSAFTSAFT Export Line")
    var
        ActivityLog: Record "Activity Log";
        Stream: InStream;
        ErrorMessage: Text;
    begin
        with ActivityLog do begin
            SetRange("Record ID", SAFTExportLine.RecordId);
            if not FindLast or (Status <> Status::Failed) then
                exit;
            CalcFields("Detailed Info");
            if not "Detailed Info".HasValue then
                Error(NoErrorMessageErr);
            "Detailed Info".CreateInStream(Stream);
            Stream.ReadText(ErrorMessage);
            if ErrorMessage = '' then
                Error(NoErrorMessageErr);
            Message(ErrorMessage);
        end;
    end;


    procedure LogSuccess(SAFTExportLine: Record "SSAFTSAFT Export Line")
    var
        ActivityLog: Record "Activity Log";
    begin
        ActivityLog.LogActivity(SAFTExportLine.RecordId, ActivityLog.Status::Success, '', SAFTFileGeneratedTxt, '');
    end;


    procedure LogError(SAFTExportLine: Record "SSAFTSAFT Export Line")
    var
        ActivityLog: Record "Activity Log";
        ErrorMessage: Text;
    begin
        ErrorMessage := GetLastErrorText;
        ActivityLog.LogActivity(SAFTExportLine.RecordId, ActivityLog.Status::Failed, '', SAFTFileNotGeneratedTxt, ErrorMessage);
        ActivityLog.SetDetailedInfoFromText(ErrorMessage);
    end;

    local procedure LogState(SAFTExportLine: Record "SSAFTSAFT Export Line"; Description: Text[250])
    var
        ActivityLog: Record "Activity Log";
    begin
        ActivityLog.LogActivity(SAFTExportLine.RecordId, ActivityLog.Status::Success, '', ParallelSAFTFileGenerationTxt, Description);
    end;

    local procedure StartExportLines(SAFTExportHeader: Record "SSAFTSAFT Export Header")
    var
        SAFTExportLine: Record "SSAFTSAFT Export Line";
        NoOfJobs: Integer;
        NotBefore: DateTime;
    begin
        SAFTExportLine.LockTable;
        SAFTExportLine.SetRange(ID, SAFTExportHeader.ID);
        SAFTExportLine.SetRange("Export File", true); //SSM1724
        SAFTExportLine.FindSet;
        NoOfJobs := 1;
        NotBefore := SAFTExportHeader."Earliest Start Date/Time";
        repeat
            RunGenerateSAFTFileOnSingleLine(SAFTExportLine, NoOfJobs, NotBefore, SAFTExportHeader);
        until SAFTExportLine.Next = 0;
    end;

    local procedure RunGenerateSAFTFileOnSingleLine(var SAFTExportLine: Record "SSAFTSAFT Export Line"; var NoOfJobs: Integer; var NotBefore: DateTime; SAFTExportHeader: Record "SSAFTSAFT Export Header")
    var
        DoNotScheduleTask: Boolean;
        TaskID: Guid;
    begin
        if SAFTExportHeader."Parallel Processing" and (NoOfJobs > SAFTExportHeader."Max No. Of Jobs") then begin
            LogState(
              SAFTExportLine, StrSubstNo(NotPossibleToScheduleTxt, SAFTExportLine."Line No.", NoOfJobs));
            exit;
        end;

        SAFTExportLine.Validate(Status, SAFTExportLine.Status::"In Progress");
        Clear(SAFTExportLine."SAF-T File");
        SAFTExportLine.Validate(Progress, 0);
        if SAFTExportHeader."Parallel Processing" then begin
            LogState(SAFTExportLine, StrSubstNo(ScheduleTaskForLineTxt, SAFTExportLine."Line No."));
            NotBefore += 3000; // have a delay between running jobs to avoid deadlocks
                               //OnBeforeScheduleTask(DoNotScheduleTask,TaskID);
            if DoNotScheduleTask then
                SAFTExportLine."Task ID" := TaskID
            else
                SAFTExportLine."Task ID" :=
                  TASKSCHEDULER.CreateTask(
                    CODEUNIT::"SSAFTSAFT Generate File", CODEUNIT::"SSAFTSAFT Export Error Handler", true, CompanyName,
                    NotBefore, SAFTExportLine.RecordId);
            SAFTExportLine.Modify(true);
            Commit;
            NoOfJobs += 1;
            exit;
        end;
        SAFTExportLine."Task ID" := CreateGuid;
        SAFTExportLine.Modify(true);
        Commit;

        ClearLastError;
        if not CODEUNIT.Run(CODEUNIT::"SSAFTSAFT Generate File", SAFTExportLine) then
            CODEUNIT.Run(CODEUNIT::"SSAFTSAFT Export Error Handler", SAFTExportLine);
        Commit;
    end;

    local procedure PrepareForExport(var SAFTExportHeader: Record "SSAFTSAFT Export Header"): Boolean
    var
        TempErrorMessage: Record "Error Message" temporary;
        SAFTExportCheck: Codeunit "SSAFTSAFT Export Check";
    begin
        SAFTExportCheck.RunCheck(TempErrorMessage, SAFTExportHeader);
        if TempErrorMessage.HasErrors(false) then begin
            TempErrorMessage.ShowErrorMessages(true);
            exit(false);
        end;

        if SAFTExportHeader.Status = SAFTExportHeader.Status::"In Progress" then
            if HandleConfirm(StrSubstNo('%1%2', ExportIsInProgressMsg, CancelExportIsInProgressQst)) then
                RemoveExportLines(SAFTExportHeader)
            else
                exit(false);
        if SAFTExportHeader.Status = SAFTExportHeader.Status::Completed then
            if not HandleConfirm(StrSubstNo('%1%2', ExportIsCompletedQst, RestartExportQst)) then
                exit(false);

        if SAFTExportHeader."Parallel Processing" and (SAFTExportHeader."Earliest Start Date/Time" = 0DT) then begin
            if not HandleConfirm(SetStartDateTimeAsCurrentQst) then
                exit(false);
            SAFTExportHeader."Earliest Start Date/Time" := CurrentDateTime;
        end;
        if not SAFTExportHeader."Parallel Processing" then
            if not HandleConfirm(GenerateSAFTFileImmediatelyQst) then
                exit(false);
        exit(true)
    end;

    local procedure CreateExportLines(SAFTExportHeader: Record "SSAFTSAFT Export Header")
    var
        SAFTExportLine: Record "SSAFTSAFT Export Line";
        LineNo: Integer;
        i: Integer;
        SegmentIndex: Integer;
    begin
        SAFTExportLine.SetRange(ID, SAFTExportHeader.ID);
        SAFTExportLine.DeleteAll(true);

        for i := 1 to 20 do
            InsertSAFTExportLine(
              SAFTExportLine,
              LineNo,
              SAFTExportHeader,
              i,
              '',
              SegmentIndex);
    end;

    local procedure InsertSAFTExportLine(var SAFTExportLine: Record "SSAFTSAFT Export Line"; var LineNo: Integer; SAFTExportHeader: Record "SSAFTSAFT Export Header"; _TypeOfLine: Integer; Description: Text; var _SegmentIndex: Integer)
    begin
        SAFTExportLine.Init;
        SAFTExportLine.Validate(ID, SAFTExportHeader.ID);
        LineNo += 1;
        SAFTExportLine.Validate("Line No.", LineNo);
        SAFTExportLine.Validate("Starting Date", SAFTExportHeader."Starting Date");
        SAFTExportLine.Validate("Ending Date", SAFTExportHeader."Ending Date");
        SAFTExportLine.Validate("Type of Line", _TypeOfLine);
        SAFTExportLine.Validate(Description, Format(SAFTExportLine."Type of Line"));
        SAFTExportLine."Export File" := IsValidLine(SAFTExportHeader, SAFTExportLine);
        //SSM1724>>
        if SAFTExportLine."Export File" then begin
            _SegmentIndex += 1;
            SAFTExportLine."Segment Index" := _SegmentIndex;
        end;
        //SSM1724<<
        SAFTExportLine.Insert(true);
    end;

    local procedure RemoveExportLines(var SAFTExportHeader: Record "SSAFTSAFT Export Header")
    var
        SAFTExportLine: Record "SSAFTSAFT Export Line";
    begin
        SAFTExportLine.SetRange(ID, SAFTExportHeader.ID);
        if not SAFTExportLine.FindSet then
            exit;

        repeat
            RemoveExportLine(SAFTExportLine);
        until SAFTExportLine.Next = 0;
    end;

    local procedure RemoveExportLine(var SAFTExportLine: Record "SSAFTSAFT Export Line")
    begin
        CancelTask(SAFTExportLine);
        SAFTExportLine.Delete(true);
    end;

    local procedure CancelTask(SAFTExportLine: Record "SSAFTSAFT Export Line")
    var
        DoNotCancelTask: Boolean;
    begin
        if IsNullGuid(SAFTExportLine."Task ID") then
            exit;

        //OnBeforeCancelTask(DoNotCancelTask);
        if not DoNotCancelTask then
            if TASKSCHEDULER.TaskExists(SAFTExportLine."Task ID") then
                TASKSCHEDULER.CancelTask(SAFTExportLine."Task ID");
    end;


    procedure BuildZipFilesWithAllRelatedXmlFiles(SAFTExportHeader: Record "SSAFTSAFT Export Header")
    var
        CompanyInformation: Record "Company Information";
        SAFTExportLine: Record "SSAFTSAFT Export Line";
        FileMgt: Codeunit "File Management";
        SafTXmlHelper: Codeunit "SSAFTSAFT XML Helper";
        ServerDestinationFolder: Text;
        TotalNumberOfFiles: Integer;
    begin
        CompanyInformation.Get;
        ServerDestinationFolder := FileMgt.ServerCreateTempSubDirectory;
        SAFTExportLine.SetRange(ID, SAFTExportHeader.ID);
        SAFTExportLine.SetRange("Export File", true); //SSM1724
        SAFTExportLine.FindSet;
        TotalNumberOfFiles := SAFTExportLine.Count;
        repeat
            SafTXmlHelper.ExportSAFTExportLineBlobToFile(
              SAFTExportLine,
              SafTXmlHelper.GetFilePath(
                ServerDestinationFolder, CompanyInformation."VAT Registration No.", SAFTExportLine."Created Date/Time",
                SAFTExportLine."Line No.", TotalNumberOfFiles));
        until SAFTExportLine.Next = 0;
        ZipMultipleXMLFilesInServerFolder(SAFTExportHeader, ServerDestinationFolder);
    end;


    procedure GenerateZipFileFromSavedFiles(SAFTExportHeader: Record "SSAFTSAFT Export Header")
    begin
        if not SAFTExportHeader.AllowedToExportIntoFolder then
            exit;

        SaveZipOfMultipleXMLFiles(SAFTExportHeader);
    end;


    procedure DownloadZipFileFromExportHeader(SAFTExportHeader: Record "SSAFTSAFT Export Header")
    var
        ZipFileInStream: InStream;
        FileName: Text;
    begin
        SAFTExportHeader.CalcFields("SAF-T File");
        if not SAFTExportHeader."SAF-T File".HasValue then
            Error(NoZipFileGeneratedErr);
        SAFTExportHeader."SAF-T File".CreateInStream(ZipFileInStream);
        FileName := SAFTZipFileTxt;
        DownloadFromStream(ZipFileInStream, ZipArchiveSaveDialogTxt, '', ZipArchiveFilterTxt, FileName);
    end;


    procedure ZipMultipleXMLFilesInServerFolder(var SAFTExportHeader: Record "SSAFTSAFT Export Header"; ServerDestinationFolder: Text)
    var
        TempNameValueBuffer: Record "Name/Value Buffer" temporary;
        FileMgt: Codeunit "File Management";
        ZipArchiveFile: File;
        ZipOutStream: OutStream;
        ZipInStream: InStream;
        ZipArchive: Text;
    begin
        FileMgt.GetServerDirectoryFilesListInclSubDirs(TempNameValueBuffer, ServerDestinationFolder);
        ZipArchive := FileMgt.CreateZipArchiveObject;
        TempNameValueBuffer.FindSet;
        repeat
            FileMgt.AddFileToZipArchive(TempNameValueBuffer.Name, FileMgt.GetFileName(TempNameValueBuffer.Name));
        until TempNameValueBuffer.Next = 0;
        FileMgt.CloseZipArchive;

        ZipArchiveFile.Open(ZipArchive);
        ZipArchiveFile.CreateInStream(ZipInStream);
        SAFTExportHeader."SAF-T File".CreateOutStream(ZipOutStream);
        CopyStream(ZipOutStream, ZipInStream);
        ZipArchiveFile.Close;
        SAFTExportHeader.Modify(true);

        FileMgt.GetServerDirectoryFilesListInclSubDirs(TempNameValueBuffer, ServerDestinationFolder);
        repeat
            FileMgt.DeleteServerFile(TempNameValueBuffer.Name);
        until TempNameValueBuffer.Next = 0;
    end;

    local procedure SaveZipOfMultipleXMLFiles(SAFTExportHeader: Record "SSAFTSAFT Export Header")
    var
        TempNameValueBuffer: Record "Name/Value Buffer" temporary;
        FileMgt: Codeunit "File Management";
        ZipArchiveFile: File;
        ZipClientFile: File;
        ZipOutStream: OutStream;
        ZipInStream: InStream;
        ZipArchive: Text;
    begin
        FileMgt.GetServerDirectoryFilesListInclSubDirs(TempNameValueBuffer, SAFTExportHeader."Folder Path");
        ZipArchive := FileMgt.CreateZipArchiveObject;
        TempNameValueBuffer.FindSet;
        repeat
            FileMgt.AddFileToZipArchive(TempNameValueBuffer.Name, FileMgt.GetFileName(TempNameValueBuffer.Name));
        until TempNameValueBuffer.Next = 0;
        FileMgt.CloseZipArchive;

        ZipArchiveFile.Open(ZipArchive);
        ZipArchiveFile.CreateInStream(ZipInStream);
        ZipClientFile.Create(SAFTExportHeader."Folder Path" + '\' + SAFTZipFileTxt);
        ZipClientFile.CreateOutStream(ZipOutStream);
        CopyStream(ZipOutStream, ZipInStream);
        ZipArchiveFile.Close;
        ZipClientFile.Close;
    end;


    procedure CheckNoFilesInFolder(SAFTExportHeader: Record "SSAFTSAFT Export Header"; var TempErrorMessage: Record "Error Message" temporary)
    var
        TempNameValueBuffer: Record "Name/Value Buffer" temporary;
        FileMgt: Codeunit "File Management";
    begin
        if not SAFTExportHeader.AllowedToExportIntoFolder then
            exit;

        FileMgt.GetServerDirectoryFilesListInclSubDirs(TempNameValueBuffer, SAFTExportHeader."Folder Path");
        if TempNameValueBuffer.Count <> 0 then
            TempErrorMessage.LogMessage(SAFTExportHeader, 0, TempErrorMessage."Message Type"::Error, FilesExistsInFolderErr);
    end;


    procedure SaveXMLDocToFolder(SAFTExportHeader: Record "SSAFTSAFT Export Header"; XMLDoc: XmlDocument; FileNumber: Integer): Boolean
    var
        SAFTExportLine: Record "SSAFTSAFT Export Line";
        CompanyInformation: Record "Company Information";
        SafTXmlHelper: Codeunit "SSAFTSAFT XML Helper";
        FilePath: Text;
        TotalNumberOfFiles: Integer;
    begin
        if not SAFTExportHeader.AllowedToExportIntoFolder then
            exit(false);
        SAFTExportLine.SetRange(ID, SAFTExportHeader.ID);
        TotalNumberOfFiles := SAFTExportLine.Count;
        CompanyInformation.Get;
        FilePath :=
          SafTXmlHelper.GetFilePath(
            SAFTExportHeader."Folder Path", CompanyInformation."VAT Registration No.",
            SAFTExportLine."Created Date/Time", FileNumber, TotalNumberOfFiles);
        XMLDoc.Save(FilePath);
    end;


    procedure GetAmountInfoFromGLEntry(var AmountXMLNode: Text; var Amount: Decimal; GLEntry: Record "G/L Entry")
    begin
        if GLEntry."Debit Amount" = 0 then begin
            AmountXMLNode := 'CreditAmount';
            Amount := GLEntry."Credit Amount";
        end else begin
            AmountXMLNode := 'DebitAmount';
            Amount := GLEntry."Debit Amount";
        end;
    end;


    procedure GetNotApplicationVATCode(): Code[10]
    begin
        /*//todo
        SAFTSetup.GET;
        EXIT(SAFTSetup."Not Applicable VAT Code");
        */

    end;


    procedure GetISOCurrencyCode(CurrencyCode: Code[10]): Code[10]
    var
        GeneralLedgerSetup: Record "General Ledger Setup";
        Currency: Record Currency;
    begin
        if CurrencyCode = '' then begin
            GeneralLedgerSetup.Get;
            exit(GeneralLedgerSetup."LCY Code");
        end;
        Currency.Get(CurrencyCode);
        exit(Currency."ISO Code");
    end;

    local procedure GetNoOfJobsInProgress(): Integer
    var
        ScheduledTask: Record "Scheduled Task";
    begin
        ScheduledTask.SetRange("Run Codeunit", CODEUNIT::"SSAFTSAFT Generate File");
        exit(ScheduledTask.Count);
    end;

    local procedure HandleConfirm(ConfirmText: Text): Boolean
    begin
        if not GuiAllowed then
            exit(true);
        exit(Confirm(ConfirmText, false));
    end;

    local procedure CheckStatus(Status: Option; Question: Text): Boolean
    var
        SAFTExportHeader: Record "SSAFTSAFT Export Header";
        StatusMessage: Text;
    begin
        if Status = SAFTExportHeader.Status::"In Progress" then
            StatusMessage := ExportIsInProgressMsg;
        if Status = SAFTExportHeader.Status::Completed then
            StatusMessage := ExportIsCompletedQst;
        if StatusMessage <> '' then
            exit(HandleConfirm(StatusMessage + Question));
        exit(true);
    end;

    local procedure CheckLineStatusForRestart(var SAFTExportLine: Record "SSAFTSAFT Export Line"): Boolean
    begin
        SAFTExportLine.SetFilter(Status, '%1|%2', SAFTExportLine.Status::Failed, SAFTExportLine.Status::Completed);
        if not SAFTExportLine.IsEmpty then
            exit(HandleConfirm(LinesInProgressOrCompletedMsg + RestartExportLineQst));
        exit(true);
    end;

    procedure IsValidLine(SAFTExportHeader: Record "SSAFTSAFT Export Header"; SAFTExportLine: Record "SSAFTSAFT Export Line"): Boolean
    begin
        case SAFTExportHeader."Header Comment SAFT Type" of
            SAFTExportHeader."Header Comment SAFT Type"::"L - pentru declaratii lunare",
          SAFTExportHeader."Header Comment SAFT Type"::"T - pentru declaratii trimestriale":
                if SAFTExportLine."Type of Line" in
                   [SAFTExportLine."Type of Line"::"G/L Accounts",
                   SAFTExportLine."Type of Line"::Customers,
                   SAFTExportLine."Type of Line"::Suppliers,
                   SAFTExportLine."Type of Line"::"Tax Table",
                   SAFTExportLine."Type of Line"::"UoM Table",
                   SAFTExportLine."Type of Line"::"Analysis Type Table",
                   SAFTExportLine."Type of Line"::Products,
                   SAFTExportLine."Type of Line"::"G/L Entries",
                   SAFTExportLine."Type of Line"::"Sales Invoices",
                   SAFTExportLine."Type of Line"::"Purchase Invoices",
                   SAFTExportLine."Type of Line"::Payments]
                then
                    exit(true);
            SAFTExportHeader."Header Comment SAFT Type"::"NL - nerezidenti lunar",
          SAFTExportHeader."Header Comment SAFT Type"::"NT - nerezidenti trimestrial":
                if SAFTExportLine."Type of Line" in
                   [SAFTExportLine."Type of Line"::"Tax Table",
                   SAFTExportLine."Type of Line"::"UoM Table",
                   SAFTExportLine."Type of Line"::Products,
                   SAFTExportLine."Type of Line"::"Sales Invoices",
                   SAFTExportLine."Type of Line"::"Purchase Invoices"]
                then
                    exit(true);
            SAFTExportHeader."Header Comment SAFT Type"::"C - pentru declaratii la cerere":
                if SAFTExportLine."Type of Line" in
                   [SAFTExportLine."Type of Line"::"G/L Accounts",
                   SAFTExportLine."Type of Line"::"Tax Table",
                   SAFTExportLine."Type of Line"::"UoM Table",
                   SAFTExportLine."Type of Line"::"Analysis Type Table",
                   SAFTExportLine."Type of Line"::"Movement Type Table",
                   SAFTExportLine."Type of Line"::Products,
                   SAFTExportLine."Type of Line"::"Physical Stock",
                   SAFTExportLine."Type of Line"::Owners,
                   SAFTExportLine."Type of Line"::"Movement of Goods"]
                then
                    exit(true);
            SAFTExportHeader."Header Comment SAFT Type"::"A - pentru declaratii anuale":
                if SAFTExportLine."Type of Line" in
                   [SAFTExportLine."Type of Line"::"G/L Accounts",
                   SAFTExportLine."Type of Line"::"Analysis Type Table",
                   SAFTExportLine."Type of Line"::Assets,
                   SAFTExportLine."Type of Line"::"Asset Transactions"]
                then
                    exit(true);

        end;
        exit(false);
    end;


    procedure StartExportSingleFile(var SAFTExportHeader: Record "SSAFTSAFT Export Header")
    var
        TypeHelper: Codeunit "Type Helper";
    begin
        //SSM1724>>
        if not PrepareForExport(SAFTExportHeader) then
            exit;

        CreateExportLines(SAFTExportHeader);

        SAFTExportHeader.Validate(Status, SAFTExportHeader.Status::"In Progress");
        SAFTExportHeader.Validate("Execution Start Date/Time", TypeHelper.GetCurrentDateTimeInUserTimeZone);
        SAFTExportHeader.Validate("Execution End Date/Time", 0DT);
        Clear(SAFTExportHeader."SAF-T File");
        SAFTExportHeader.Modify(true);
        Commit;

        StartExportSingleLine(SAFTExportHeader);
        SAFTExportHeader.Find;
        //SSM1724<<
    end;

    local procedure StartExportSingleLine(SAFTExportHeader: Record "SSAFTSAFT Export Header")
    var
        SSASAFTGenerateFile: Codeunit "SSAFTSAFT Generate File";
    begin
        //SSM1724>>
        SSASAFTGenerateFile.ExportSingleFile(SAFTExportHeader);
        //SSM1724<<
    end;


    procedure BuildZipFilesWithSingleXmlFile(SAFTExportHeader: Record "SSAFTSAFT Export Header")
    var
        CompanyInformation: Record "Company Information";
        SAFTExportLine: Record "SSAFTSAFT Export Line";
        FileMgt: Codeunit "File Management";
        SafTXmlHelper: Codeunit "SSAFTSAFT XML Helper";
        ServerDestinationFolder: Text;
        TotalNumberOfFiles: Integer;
    begin
        //SSM1724>>
        CompanyInformation.Get;
        ServerDestinationFolder := FileMgt.ServerCreateTempSubDirectory;
        repeat
            SafTXmlHelper.ExportSAFTExportLineBlobToFile(
              SAFTExportLine,
              SafTXmlHelper.GetFilePath(
                ServerDestinationFolder, CompanyInformation."VAT Registration No.", SAFTExportLine."Created Date/Time",
                SAFTExportLine."Line No.", TotalNumberOfFiles));
        until SAFTExportLine.Next = 0;
        ZipMultipleXMLFilesInServerFolder(SAFTExportHeader, ServerDestinationFolder);
        //SSM1724<<
    end;


    procedure SaveSingleXMLDocToFolder(SAFTExportHeader: Record "SSAFTSAFT Export Header"; XMLDoc: DotNet SSAXmlDocument): Boolean
    var
        CompanyInformation: Record "Company Information";
        SafTXmlHelper: Codeunit "SSAFTSAFT XML Helper";
        FilePath: Text;
    begin
        //SSM1724>>
        if not SAFTExportHeader.AllowedToExportIntoFolder then
            exit(false);
        CompanyInformation.Get;
        FilePath :=
          SafTXmlHelper.GetSingleFilePath(SAFTExportHeader."Folder Path", CompanyInformation."VAT Registration No.");
        XMLDoc.Save(FilePath);
        //SSM1724<<
    end;
}

