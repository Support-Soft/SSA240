#pragma implicitwith disable
codeunit 71906 "SSAFT Export Error Handler"
{
    // SSM2101 SSCAT 04.01.2023 SAF-T

    TableNo = "SSAFT Export Line";

    trigger OnRun()
    var
        SAFTExportHeader: Record "SSAFT Export Header";
        SAFTExportMgt: Codeunit "SSAFT Export Mgt.";
    begin
        SAFTExportMgt.LogError(Rec);
        Rec.LockTable;
        Rec.Status := Rec.Status::Failed;
        Rec.Progress := 100;
        if Rec."No. Of Retries" > 0 then
            Rec."No. Of Retries" -= 1;
        Rec.Modify(true);
        SAFTExportHeader.Get(Rec.ID);
        SAFTExportMgt.UpdateExportStatus(SAFTExportHeader);
        SAFTExportMgt.StartExportLinesNotStartedYet(SAFTExportHeader);
    end;
}

#pragma implicitwith restore

