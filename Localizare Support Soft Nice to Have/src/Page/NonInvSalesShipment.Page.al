page 71101 "SSA Non-Inv Sales Shipment"
{
    Caption = 'Non-Invoiced Sales Shipment';
    DelayedInsert = true;
    PageType = Worksheet;
    RefreshOnActivate = true;
    SourceTable = "SSA Non-Invoiced Sales Ship";
    SourceTableView = sorting("Posting Date")
                      order(descending);
    ApplicationArea = All;
    UsageCategory = Tasks;
    layout
    {
        area(content)
        {
            field(InvPostingDate; InvPostingDate)
            {
                ApplicationArea = All;
                Caption = 'Invoice Posting Date';
            }
            repeater(Control1390052)
            {
                ShowCaption = false;
                field("Posting Date"; "Posting Date")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("No."; "No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Order No."; "Order No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Sell-to Customer No."; "Sell-to Customer No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Sell-to Customer Name"; "Sell-to Customer Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Sell-to Post Code"; "Sell-to Post Code")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                }
                field("Sell-to Country/Region Code"; "Sell-to Country/Region Code")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                }
                field("Sell-to Contact"; "Sell-to Contact")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                }
                field("Bill-to Customer No."; "Bill-to Customer No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                }
                field("Bill-to Name"; "Bill-to Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                }
                field("Bill-to Post Code"; "Bill-to Post Code")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                }
                field("Bill-to Country/Region Code"; "Bill-to Country/Region Code")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                }
                field("Bill-to Contact"; "Bill-to Contact")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                }
                field("Ship-to Code"; "Ship-to Code")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                }
                field("Ship-to Name"; "Ship-to Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                }
                field("Ship-to Post Code"; "Ship-to Post Code")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                }
                field("Ship-to Country/Region Code"; "Ship-to Country/Region Code")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                }
                field("Ship-to Contact"; "Ship-to Contact")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                }
                field("Shortcut Dimension 1 Code"; "Shortcut Dimension 1 Code")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                }
                field("Shortcut Dimension 2 Code"; "Shortcut Dimension 2 Code")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                }
                field("Currency Code"; "Currency Code")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                }
                field("Location Code"; "Location Code")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Salesperson Code"; "Salesperson Code")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Shipment")
            {
                Caption = '&Shipment';
                action(Card)
                {
                    ApplicationArea = All;
                    Caption = 'Card';
                    Image = EditLines;
                    RunObject = Page "Posted Sales Shipment";
                    RunPageLink = "No." = field("No.");
                    ShortCutKey = 'Shift+F7';
                }
                action(Statistics)
                {
                    ApplicationArea = All;
                    Caption = 'Statistics';
                    Image = Statistics;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Sales Shipment Statistics";
                    RunPageLink = "No." = field("No.");
                    ShortCutKey = 'F7';
                }
                action("Co&mments")
                {
                    ApplicationArea = All;
                    Caption = 'Co&mments';
                    Image = ViewComments;
                    RunObject = Page "Sales Comment Sheet";
                    RunPageLink = "Document Type" = const(Shipment),
                                  "No." = field("No.");
                }
            }
            group("P&ost Invoices")
            {
                Caption = 'P&ost Invoices';
                action("P&ost")
                {
                    ApplicationArea = All;
                    Caption = 'P&ost';
                    Ellipsis = true;
                    Image = Post;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ShortCutKey = 'F9';

                    trigger OnAction()
                    begin
                        if InvPostingDate = 0D then
                            Error(Text004);

                        if not Confirm(Text000, false) then
                            exit;

                        if not NonInvoicedSalesShipment.Find('-') then
                            Error(Text002);

                        if (InvPostingDate > CalcDate(Text001, "Posting Date")) then
                            if not Confirm(Text003, false, CalcDate(Text001, "Posting Date")) then
                                exit;

                        SalesShipmentLine.SetRange("Document No.", "No.");
                        if SalesShipmentLine.Find('-') then
                            repeat
                                if SalesShipmentLine."Qty. Shipped Not Invoiced" > 0 then begin
                                    SalesLine.Get(SalesLine."Document Type"::Order, SalesShipmentLine."Order No.", SalesShipmentLine."Order Line No.");
                                    SalesLine.Validate("Qty. to Invoice", SalesShipmentLine."Qty. Shipped Not Invoiced");
                                    SalesLine.Modify;
                                end;
                            until SalesShipmentLine.Next = 0;

                        with SalesHeader do begin
                            Get(SalesHeader."Document Type"::Order, "Order No.");
                            Validate("Posting Date", InvPostingDate);
                            Ship := false;
                            Invoice := true;
                            //SalesPost.SetPostingDate(TRUE,FALSE,"Posting Date");
                            SalesPost.Run(SalesHeader);
                            Rec.Delete;
                        end;
                    end;
                }
                action("Post and &Print")
                {
                    ApplicationArea = All;
                    Caption = 'Post and &Print';
                    Ellipsis = true;
                    Image = PostPrint;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ShortCutKey = 'Shift+F9';

                    trigger OnAction()
                    begin
                        if InvPostingDate = 0D then
                            Error(Text004);

                        if not Confirm(Text000, false) then
                            exit;

                        if not NonInvoicedSalesShipment.Find('-') then
                            Error(Text002);

                        if (InvPostingDate > CalcDate(Text001, "Posting Date")) then
                            if not Confirm(Text003, false, CalcDate(Text001, "Posting Date")) then
                                exit;

                        SalesShipmentLine.SetRange("Document No.", "No.");
                        if SalesShipmentLine.Find('-') then
                            repeat
                                if SalesShipmentLine."Qty. Shipped Not Invoiced" > 0 then begin
                                    SalesLine.Get(SalesLine."Document Type"::Order, SalesShipmentLine."Order No.", SalesShipmentLine."Order Line No.");
                                    SalesLine.Validate("Qty. to Invoice", SalesShipmentLine."Qty. Shipped Not Invoiced");
                                    SalesLine.Modify;
                                end;
                            until SalesShipmentLine.Next = 0;

                        with SalesHeader do begin
                            Get(SalesHeader."Document Type"::Order, "Order No.");
                            Ship := false;
                            Invoice := true;
                            Validate("Posting Date", InvPostingDate);
                            //SalesPost.SetPostingDate(TRUE,FALSE,"Posting Date");
                            SalesPost.Run(SalesHeader);
                            Rec.Delete;
                            if "Last Posting No." = '' then
                                SalesInvoiceHeader."No." := "No."
                            else
                                SalesInvoiceHeader."No." := "Last Posting No.";
                            SalesInvoiceHeader.SetRecFilter;
                        end;

                        ReportSelection.Reset;
                        ReportSelection.SetRange(Usage, ReportSelection.Usage::"S.Invoice");
                        ReportSelection.Find('-');
                        repeat
                            ReportSelection.TestField("Report ID");
                            REPORT.Run(ReportSelection."Report ID", false, false, SalesInvoiceHeader);
                        until ReportSelection.Next = 0;
                    end;
                }
                action("Post &Batch")
                {
                    ApplicationArea = All;
                    Caption = 'Post &Batch';
                    Ellipsis = true;
                    Image = PostBatch;

                    trigger OnAction()
                    begin
                        Clear(PostNonInvSalesShpt);
                        PostNonInvSalesShpt.SetPostingDate(InvPostingDate);
                        PostNonInvSalesShpt.RunModal;
                        CurrPage.Update(false);
                    end;
                }
            }
        }
        area(processing)
        {
            group("F&unctions")
            {
                Caption = 'F&unctions';
                action("Suggest Lines...")
                {
                    ApplicationArea = All;
                    Caption = 'Suggest Lines...';
                    Image = MoveNegativeLines;

                    trigger OnAction()
                    begin
                        Clear(SuggestSalesShpt);
                        SuggestSalesShpt.RunModal;

                        if Find('-') then
                            if WorkDate < CalcDate(Text001, "Posting Date") then
                                InvPostingDate := WorkDate
                            else
                                InvPostingDate := CalcDate(Text001, "Posting Date");
                    end;
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        if Find('-') then
            InvPostingDate := CalcDate(Text001, "Posting Date");
    end;

    var
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
        SalesShipmentLine: Record "Sales Shipment Line";
        NonInvoicedSalesShipment: Record "SSA Non-Invoiced Sales Ship";
        SalesInvoiceHeader: Record "Sales Invoice Header";
        ReportSelection: Record "Report Selections";
        SuggestSalesShpt: Report "SSA Sug. Non-Inv Sales Shpt.";
        PostNonInvSalesShpt: Report "SSA Inv. Non-Inv Sales Shpt.";
        SalesPost: Codeunit "Sales-Post";
        Text000: Label 'Do you want to post the invoice?';
        Text001: Label '<CM+15D>';
        Text002: Label 'There is nothing to post.';
        Text003: Label 'The specified invoice posting date is overdue already. Do you still want to post the invoice?';
        InvPostingDate: Date;
        Text004: Label 'Please enter the posting date.';
}

