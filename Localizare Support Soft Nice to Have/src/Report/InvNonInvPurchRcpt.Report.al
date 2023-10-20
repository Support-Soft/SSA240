report 71100 "SSA Inv. Non-Inv Purch. Rcpt."
{
    Caption = 'Inv. Non-Invoiced Purch. Rcpt.';
    ProcessingOnly = true;

    dataset
    {
        dataitem("SSA Non-Invoiced Purch. Rcpt."; "SSA Non-Invoiced Purch. Rcpt.")
        {

            trigger OnAfterGetRecord()
            begin
                PurchHeader.Get(PurchHeader."Document Type"::Order, "Order No.");
                Commit;
                if CalcInvDisc then
                    CalculateInvoiceDiscount;

                PurchRcptLine.SetRange("Document No.", "No.");
                if PurchRcptLine.Find('-') then
                    repeat
                        if PurchRcptLine."Qty. Rcd. Not Invoiced" > 0 then begin
                            PurchLine.Get(PurchLine."Document Type"::Order, PurchRcptLine."Order No.", PurchRcptLine."Order Line No.");
                            PurchLine.Validate("Qty. to Invoice", PurchRcptLine."Qty. Rcd. Not Invoiced");
                            PurchLine.Modify;
                        end;
                    until PurchRcptLine.Next = 0;

                Counter := Counter + 1;
                Window.Update(1, "Buy-from Vendor No.");
                Window.Update(2, Round(Counter / CounterTotal * 10000, 1));
                PurchHeader.Validate("Posting Date", InvPostingDate);
                PurchHeader.Receive := false;
                PurchHeader.Invoice := true;
                Clear(PurchPost);
                //PurchPost.SetPostingDate(TRUE,ReplaceDocumentDate,InvPostingDate); //ES_FC
                Commit;
                if PurchPost.Run(PurchHeader) then begin
                    CounterOK := CounterOK + 1;
                    Delete;
                end;
            end;

            trigger OnPostDataItem()
            begin
                Window.Close;
                Message(Text002, CounterOK, CounterTotal);
            end;

            trigger OnPreDataItem()
            begin
                PurchSetup.Get;
                if InvPostingDate = 0D then
                    Error(Text005);
                CounterTotal := Count;
                Window.Open(Text001);
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(InvPostingDate; InvPostingDate)
                    {
                        Caption = 'Posting Date';
                        ToolTip = 'Specifies the value of the Posting Date field.';
                    }
                    field(ReplaceDocumentDate; ReplaceDocumentDate)
                    {
                        Caption = 'Replace Document Date';
                        ToolTip = 'Specifies the value of the Replace Document Date field.';
                    }
                    field(CalcInvDisc; CalcInvDisc)
                    {
                        Caption = 'Calc. Inv. Discount';
                        ToolTip = 'Specifies the value of the Calc. Inv. Discount field.';
                        trigger OnValidate()
                        begin
                            PurchSetup.Get;
                            PurchSetup.TestField("Calc. Inv. Discount", false);
                        end;
                    }
                }
            }
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
        IncDate := false;
        if NonInvoicedPurchRcpt.Find('-') then
            repeat
                if (InvPostingDate > CalcDate(Text004, NonInvoicedPurchRcpt."Posting Date"))
                  then
                    IncDate := true;
            until (NonInvoicedPurchRcpt.Next = 0) or IncDate;

        if IncDate then
            if not Confirm(Text003) then
                CurrReport.Quit;
    end;

    var
        PurchSetup: Record "Purchases & Payables Setup";
        PurchHeader: Record "Purchase Header";
        PurchLine: Record "Purchase Line";
        PurchRcptLine: Record "Purch. Rcpt. Line";
        NonInvoicedPurchRcpt: Record "SSA Non-Invoiced Purch. Rcpt.";
        PurchPost: Codeunit "Purch.-Post";
        PurchCalcDisc: Codeunit "Purch.-Calc.Discount";
        ReplaceDocumentDate: Boolean;
        ReplacePostingDate: Boolean;
        CounterTotal: Integer;
        Window: Dialog;
        Text001: Label 'Posting invoices  #1########## @2@@@@@@@@@@@@@';
        Text002: Label '%1 invoices out of a total of %2 have now been posted.';
        Counter: Integer;
        CounterOK: Integer;
        CalcInvDisc: Boolean;
        InvPostingDate: Date;
        Text003: Label 'The specified invoice posting date is already overdue for some receipts. Do you still want to post the invoices?';
        Text004: Label '<CM+15D>';
        IncDate: Boolean;
        Text005: Label 'Please enter the posting date.';

    procedure CalculateInvoiceDiscount()
    begin
        PurchLine.Reset;
        PurchLine.SetRange("Document Type", PurchHeader."Document Type");
        PurchLine.SetRange("Document No.", PurchHeader."No.");
        if PurchLine.Find('-') then
            if PurchCalcDisc.Run(PurchLine) then begin
                PurchHeader.Get(PurchHeader."Document Type", PurchHeader."No.");
                Commit;
            end;
    end;

    procedure SetPostingDate(PostingDate: Date)
    begin
        InvPostingDate := PostingDate;
    end;
}

