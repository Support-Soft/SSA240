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
                ToolTip = 'Specifies the value of the Invoice Posting Date field.';
            }
            repeater(Control1390052)
            {
                ShowCaption = false;
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Posting Date field.';
                }
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the value of the No. field.';
                }
                field("Order No."; Rec."Order No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Order No. field.';
                }
                field("Sell-to Customer No."; Rec."Sell-to Customer No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Sell-to Customer No. field.';
                }
                field("Sell-to Customer Name"; Rec."Sell-to Customer Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Sell-to Customer Name field.';
                }
                field("Sell-to Post Code"; Rec."Sell-to Post Code")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Sell-to Post Code field.';
                }
                field("Sell-to Country/Region Code"; Rec."Sell-to Country/Region Code")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Sell-to Country/Region Code field.';
                }
                field("Sell-to Contact"; Rec."Sell-to Contact")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Sell-to Contact field.';
                }
                field("Bill-to Customer No."; Rec."Bill-to Customer No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Bill-to Customer No. field.';
                }
                field("Bill-to Name"; Rec."Bill-to Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Bill-to Name field.';
                }
                field("Bill-to Post Code"; Rec."Bill-to Post Code")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Bill-to Post Code field.';
                }
                field("Bill-to Country/Region Code"; Rec."Bill-to Country/Region Code")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Bill-to Country/Region Code field.';
                }
                field("Bill-to Contact"; Rec."Bill-to Contact")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Bill-to Contact field.';
                }
                field("Ship-to Code"; Rec."Ship-to Code")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Ship-to Code field.';
                }
                field("Ship-to Name"; Rec."Ship-to Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Ship-to Name field.';
                }
                field("Ship-to Post Code"; Rec."Ship-to Post Code")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Ship-to Post Code field.';
                }
                field("Ship-to Country/Region Code"; Rec."Ship-to Country/Region Code")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Ship-to Country/Region Code field.';
                }
                field("Ship-to Contact"; Rec."Ship-to Contact")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Ship-to Contact field.';
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Shortcut Dimension 1 Code field.';
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Shortcut Dimension 2 Code field.';
                }
                field("Currency Code"; Rec."Currency Code")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Currency Code field.';
                }
                field("Location Code"; Rec."Location Code")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Location Code field.';
                }
                field("Salesperson Code"; Rec."Salesperson Code")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Salesperson Code field.';
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
                    RunObject = page "Posted Sales Shipment";
                    RunPageLink = "No." = field("No.");
                    ShortcutKey = 'Shift+F7';
                    ToolTip = 'Executes the Card action.';
                }
                action(Statistics)
                {
                    ApplicationArea = All;
                    Caption = 'Statistics';
                    Image = Statistics;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = page "Sales Shipment Statistics";
                    RunPageLink = "No." = field("No.");
                    ShortcutKey = 'F7';
                    ToolTip = 'Executes the Statistics action.';
                }
                action("Co&mments")
                {
                    ApplicationArea = All;
                    Caption = 'Co&mments';
                    Image = ViewComments;
                    RunObject = page "Sales Comment Sheet";
                    RunPageLink = "Document Type" = const(Shipment),
                                  "No." = field("No.");
                    ToolTip = 'Executes the Co&mments action.';
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
                    ShortcutKey = 'F9';
                    ToolTip = 'Executes the P&ost action.';
                    trigger OnAction()
                    begin
                        if InvPostingDate = 0D then
                            Error(Text004);

                        if not Confirm(Text000, false) then
                            exit;

                        if not NonInvoicedSalesShipment.Find('-') then
                            Error(Text002);

                        if (InvPostingDate > CalcDate(Text001, Rec."Posting Date")) then
                            if not Confirm(Text003, false, CalcDate(Text001, Rec."Posting Date")) then
                                exit;

                        SalesShipmentLine.SetRange("Document No.", Rec."No.");
                        if SalesShipmentLine.Find('-') then
                            repeat
                                if SalesShipmentLine."Qty. Shipped Not Invoiced" > 0 then begin
                                    SalesLine.Get(SalesLine."Document Type"::Order, SalesShipmentLine."Order No.", SalesShipmentLine."Order Line No.");
                                    SalesLine.Validate("Qty. to Invoice", SalesShipmentLine."Qty. Shipped Not Invoiced");
                                    SalesLine.Modify;
                                end;
                            until SalesShipmentLine.Next = 0;

                        SalesHeader.Get(SalesHeader."Document Type"::Order, Rec."Order No.");
                        SalesHeader.Validate("Posting Date", InvPostingDate);
                        SalesHeader.Ship := false;
                        SalesHeader.Invoice := true;
                        //SalesPost.SetPostingDate(TRUE,FALSE,"Posting Date");
                        SalesPost.Run(SalesHeader);
                        Rec.Delete;
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
                    ShortcutKey = 'Shift+F9';
                    ToolTip = 'Executes the Post and &Print action.';
                    trigger OnAction()
                    begin
                        if InvPostingDate = 0D then
                            Error(Text004);

                        if not Confirm(Text000, false) then
                            exit;

                        if not NonInvoicedSalesShipment.Find('-') then
                            Error(Text002);

                        if (InvPostingDate > CalcDate(Text001, Rec."Posting Date")) then
                            if not Confirm(Text003, false, CalcDate(Text001, Rec."Posting Date")) then
                                exit;

                        SalesShipmentLine.SetRange("Document No.", Rec."No.");
                        if SalesShipmentLine.Find('-') then
                            repeat
                                if SalesShipmentLine."Qty. Shipped Not Invoiced" > 0 then begin
                                    SalesLine.Get(SalesLine."Document Type"::Order, SalesShipmentLine."Order No.", SalesShipmentLine."Order Line No.");
                                    SalesLine.Validate("Qty. to Invoice", SalesShipmentLine."Qty. Shipped Not Invoiced");
                                    SalesLine.Modify;
                                end;
                            until SalesShipmentLine.Next = 0;

                        SalesHeader.Get(SalesHeader."Document Type"::Order, Rec."Order No.");
                        SalesHeader.Ship := false;
                        SalesHeader.Invoice := true;
                        SalesHeader.Validate("Posting Date", InvPostingDate);
                        //SalesPost.SetPostingDate(TRUE,FALSE,"Posting Date");
                        SalesPost.Run(SalesHeader);
                        Rec.Delete;
                        if SalesHeader."Last Posting No." = '' then
                            SalesInvoiceHeader."No." := SalesHeader."No."
                        else
                            SalesInvoiceHeader."No." := SalesHeader."Last Posting No.";
                        SalesInvoiceHeader.SetRecFilter;

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
                    ToolTip = 'Executes the Post &Batch action.';
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
                    ToolTip = 'Executes the Suggest Lines... action.';
                    trigger OnAction()
                    begin
                        Clear(SuggestSalesShpt);
                        SuggestSalesShpt.RunModal;

                        if Rec.Find('-') then
                            if WorkDate < CalcDate(Text001, Rec."Posting Date") then
                                InvPostingDate := WorkDate
                            else
                                InvPostingDate := CalcDate(Text001, Rec."Posting Date");
                    end;
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        if Rec.Find('-') then
            InvPostingDate := CalcDate(Text001, Rec."Posting Date");
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
        Text001: Label '<CM+15D>', Locked = true;
        Text002: Label 'There is nothing to post.';
        Text003: Label 'The specified invoice posting date is overdue already. Do you still want to post the invoice?';
        InvPostingDate: Date;
        Text004: Label 'Please enter the posting date.';
}
