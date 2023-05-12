codeunit 70005 "SSA Int. Cons-Post + Print"
{
    // SSA937 SSCAT 16.06.2019 3.Funct. Bonuri de consum-consum intern

    TableNo = "SSAInternal Consumption Header";

    trigger OnRun()
    begin
        IntConsumptionHeader.Copy(Rec);
        Code;
        Rec := IntConsumptionHeader;
    end;

    var
        IntConsumptionHeader: Record "SSAInternal Consumption Header";
        PostedIntConsumptionHeader: Record "SSA Pstd. Int. Cons. Header";
        SSAReportSelections: Record "SSA Report Selections";
        IntConsumptionPost: Codeunit "SSA Internal Consumption Post";
        Text000: Label 'Do you want to post and print the %1?';

    local procedure "Code"()
    begin
        with IntConsumptionHeader do begin
            if not
                 Confirm(
                    Text000, false,
                    "No.")
            then
                exit;

            IntConsumptionPost.Run(IntConsumptionHeader);

            if "Last Posting No." = '' then
                PostedIntConsumptionHeader."No." := "No."
            else
                PostedIntConsumptionHeader."No." := "Last Posting No.";
            PostedIntConsumptionHeader.SetRecFilter;
            PrintReport(PostedIntConsumptionHeader, SSAReportSelections.Usage::"P.I.Cons", false);

            Commit;
        end;
    end;

    procedure PrintReport(var _PostedIntConsumptionHeader: Record "SSA Pstd. Int. Cons. Header"; _ReportUsage: Integer; _ShowReqPage: Boolean)
    begin
        SSAReportSelections.Reset;
        SSAReportSelections.SetRange(Usage, _ReportUsage);
        SSAReportSelections.Find('-');
        repeat
            SSAReportSelections.TestField("Report ID");
            REPORT.Run(SSAReportSelections."Report ID", _ShowReqPage, false, _PostedIntConsumptionHeader);
        until SSAReportSelections.Next = 0;
    end;
}

