report 71101 "SSA Inv. Non-Inv Sales Shpt."
{
    Caption = 'Inv. Non-Invoiced Sales Shpt.';
    ProcessingOnly = true;
    ApplicationArea = All;

    dataset
    {
        dataitem("SSA Non-Invoiced Sales Ship"; "SSA Non-Invoiced Sales Ship")
        {
            trigger OnAfterGetRecord()
            begin
                SalesHeader.Get(SalesHeader."Document Type"::Order, "Order No.");
                Commit;
                if CalcInvDisc then
                    CalculateInvoiceDiscount;

                SalesShipmentLine.SetRange("Document No.", "No.");
                if SalesShipmentLine.Find('-') then
                    repeat
                        if SalesShipmentLine."Qty. Shipped Not Invoiced" > 0 then begin
                            SalesLine.Get(SalesLine."Document Type"::Order, SalesShipmentLine."Order No.", SalesShipmentLine."Order Line No.");
                            SalesLine.Validate("Qty. to Invoice", SalesShipmentLine."Qty. Shipped Not Invoiced");
                            SalesLine.Modify;
                        end;
                    until SalesShipmentLine.Next = 0;

                Counter := Counter + 1;
                Window.Update(1, "No.");
                Window.Update(2, Round(Counter / CounterTotal * 10000, 1));
                SalesHeader.Ship := false;
                SalesHeader.Invoice := true;
                SalesHeader.Validate("Posting Date", InvPostingDate);
                Clear(SalesPost);
                //SalesPost.SetPostingDate(TRUE,ReplaceDocumentDate,InvPostingDate);
                Commit;
                if SalesPost.Run(SalesHeader) then begin
                    CounterOK := CounterOK + 1;
                    Delete;
                    if MarkedOnly then
                        Mark(false);
                end;
            end;

            trigger OnPostDataItem()
            begin
                Window.Close;
                Message(Text002, CounterOK, CounterTotal);
            end;

            trigger OnPreDataItem()
            begin
                if (InvPostingDate = 0D) then
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
                        ApplicationArea = All;
                    }
                    field(ReplaceDocumentDate; ReplaceDocumentDate)
                    {
                        Caption = 'Replace Document Date';
                        ToolTip = 'Specifies the value of the Replace Document Date field.';
                        ApplicationArea = All;
                    }
                    field(CalcInvDisc; CalcInvDisc)
                    {
                        Caption = 'Calc. Inv. Discount';
                        ToolTip = 'Specifies the value of the Calc. Inv. Discount field.';
                        ApplicationArea = All;
                        trigger OnValidate()
                        begin
                            SalesSetup.Get;
                            SalesSetup.TestField("Calc. Inv. Discount", false);
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
        if NonInvoicedSalesShip.Find('-') then
            repeat
                if (InvPostingDate > CalcDate(Text004, NonInvoicedSalesShip."Posting Date"))
                  then
                    IncDate := true;
            until (NonInvoicedSalesShip.Next = 0) or IncDate;

        if IncDate then
            if not Confirm(Text003) then
                CurrReport.Quit;
    end;

    var
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
        SalesSetup: Record "Sales & Receivables Setup";
        SalesShipmentLine: Record "Sales Shipment Line";
        NonInvoicedSalesShip: Record "SSA Non-Invoiced Sales Ship";
        SalesCalcDisc: Codeunit "Sales-Calc. Discount";
        SalesPost: Codeunit "Sales-Post";
        Window: Dialog;
        CounterTotal: Integer;
        Counter: Integer;
        CounterOK: Integer;
        ReplaceDocumentDate: Boolean;
        CalcInvDisc: Boolean;
        InvPostingDate: Date;
        IncDate: Boolean;
        Text001: Label 'Posting invoices  #1########## @2@@@@@@@@@@@@@';
        Text002: Label '%1 invoices out of a total of %2 have now been posted.';
        Text003: Label 'The specified invoice posting date is already overdue for some shipments. Do you still want to post the invoices?';
        Text004: Label '<CM+15D>', Locked = true;
        Text005: Label 'Please enter the posting date.';

    procedure CalculateInvoiceDiscount()
    begin
        SalesLine.Reset;
        SalesLine.SetRange("Document Type", SalesHeader."Document Type");
        SalesLine.SetRange("Document No.", SalesHeader."No.");
        if SalesLine.Find('-') then
            if SalesCalcDisc.Run(SalesLine) then begin
                SalesHeader.Get(SalesHeader."Document Type", SalesHeader."No.");
                Commit;
            end;
    end;

    procedure SetPostingDate(PostingDate: Date)
    begin
        InvPostingDate := PostingDate;
    end;
}
