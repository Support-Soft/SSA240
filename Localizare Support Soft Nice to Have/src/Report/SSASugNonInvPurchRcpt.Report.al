report 71102 "SSA Sug. Non-Inv Purch. Rcpt."
{
    Caption = 'Sug. Non-Invoiced Purch. Rcpt.';
    ProcessingOnly = true;
    ApplicationArea = All;

    dataset
    {
        dataitem("Purch. Rcpt. Header"; "Purch. Rcpt. Header")
        {
            RequestFilterFields = "Posting Date";

            trigger OnAfterGetRecord()
            begin
                if Vendor.Get("Purch. Rcpt. Header"."Pay-to Vendor No.") then
                    Country.Get(Vendor."Country/Region Code");
                if Country."EU Country/Region Code" <> '' then begin
                    PurchRcptLine.SetRange("Document No.", "No.");
                    if PurchRcptLine.Find('-') then
                        repeat
                            if PurchRcptLine."Qty. Rcd. Not Invoiced" > 0 then
                                if not (PurchRcpt.Get("No.")) then begin
                                    PurchRcpt.TransferFields("Purch. Rcpt. Header");
                                    PurchRcpt.Insert
                                end
                        until PurchRcptLine.Next = 0;
                end;
            end;
        }
    }

    requestpage
    {
        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnPreReport()
    begin
        PurchRcpt.DeleteAll;
    end;

    var
        PurchRcptLine: Record "Purch. Rcpt. Line";
        PurchRcpt: Record "SSA Non-Invoiced Purch. Rcpt.";
        Text000: Label '<CM+15D>';
        Country: Record "Country/Region";
        Vendor: Record Vendor;
}
