page 71102 "SSA Non-Invoiced Purch. Rcpt."
{
    Caption = 'Non-Invoiced Purch. Rcpt.';
    DelayedInsert = true;
    PageType = Worksheet;
    RefreshOnActivate = true;
    SourceTable = "SSA Non-Invoiced Purch. Rcpt.";
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
                field("Buy-from Vendor No."; Rec."Buy-from Vendor No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Buy-from Vendor No. field.';
                }
                field("Order Address Code"; Rec."Order Address Code")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Order Address Code field.';
                }
                field("Buy-from Vendor Name"; Rec."Buy-from Vendor Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Buy-from Vendor Name field.';
                }
                field("Buy-from Post Code"; Rec."Buy-from Post Code")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Buy-from Post Code field.';
                }
                field("Buy-from Country/Region Code"; Rec."Buy-from Country/Region Code")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Buy-from Country/Region Code field.';
                }
                field("Buy-from Contact"; Rec."Buy-from Contact")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Buy-from Contact field.';
                }
                field("Pay-to Vendor No."; Rec."Pay-to Vendor No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Pay-to Vendor No. field.';
                }
                field("Pay-to Name"; Rec."Pay-to Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Pay-to Name field.';
                }
                field("Pay-to Post Code"; Rec."Pay-to Post Code")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Pay-to Post Code field.';
                }
                field("Pay-to Country/Region Code"; Rec."Pay-to Country/Region Code")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Pay-to Country/Region Code field.';
                }
                field("Pay-to Contact"; Rec."Pay-to Contact")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Pay-to Contact field.';
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
                field("Purchaser Code"; Rec."Purchaser Code")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Purchaser Code field.';
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
                field("Location Code"; Rec."Location Code")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = true;
                    ToolTip = 'Specifies the value of the Location Code field.';
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Receipt")
            {
                Caption = '&Receipt';
                action(Card)
                {
                    ApplicationArea = All;
                    Caption = 'Card';
                    Image = EditLines;
                    RunObject = page "Posted Purchase Receipt";
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
                    RunObject = page "Purchase Receipt Statistics";
                    RunPageLink = "No." = field("No.");
                    ShortcutKey = 'F7';
                    ToolTip = 'Executes the Statistics action.';
                }
                action("Co&mments")
                {
                    ApplicationArea = All;
                    Caption = 'Co&mments';
                    Image = ViewComments;
                    RunObject = page "Purch. Comment Sheet";
                    RunPageLink = "Document Type" = const(Receipt),
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
                        PurchSetup.Get;

                        if InvPostingDate = 0D then
                            Error(Text004);

                        if not Confirm(Text000, false) then
                            exit;

                        if not NonInvoicedPurchRcpt.Find('-') then
                            Error(Text002);

                        if (InvPostingDate > CalcDate(Text001, Rec."Posting Date")) then
                            if not Confirm(Text003, false, CalcDate(Text001, Rec."Posting Date")) then
                                exit;

                        PurchRcptLine.SetRange("Document No.", Rec."No.");
                        if PurchRcptLine.Find('-') then
                            repeat
                                if PurchRcptLine."Qty. Rcd. Not Invoiced" > 0 then begin
                                    PurchLine.Get(PurchLine."Document Type"::Order, PurchRcptLine."Order No.", PurchRcptLine."Order Line No.");
                                    PurchLine.Validate("Qty. to Invoice", PurchRcptLine."Qty. Rcd. Not Invoiced");
                                    PurchLine.Modify;
                                end;
                            until PurchRcptLine.Next = 0;

                        PurchHeader.Get(PurchHeader."Document Type"::Order, Rec."Order No.");
                        PurchHeader.Validate("Posting Date", InvPostingDate);
                        PurchHeader.Receive := false;
                        PurchHeader.Invoice := true;
                        PurchPost.Run(PurchHeader);
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
                        PurchSetup.Get;

                        if InvPostingDate = 0D then
                            Error(Text004);

                        if not Confirm(Text000, false) then
                            exit;

                        if not NonInvoicedPurchRcpt.Find('-') then
                            Error(Text002);

                        if (InvPostingDate > CalcDate(Text001, Rec."Posting Date")) then
                            if not Confirm(Text003, false, CalcDate(Text001, Rec."Posting Date")) then
                                exit;

                        PurchRcptLine.SetRange("Document No.", Rec."No.");
                        if PurchRcptLine.Find('-') then
                            repeat
                                if PurchRcptLine."Qty. Rcd. Not Invoiced" > 0 then begin
                                    PurchLine.Get(PurchLine."Document Type"::Order, PurchRcptLine."Order No.", PurchRcptLine."Order Line No.");
                                    PurchLine.Validate("Qty. to Invoice", PurchRcptLine."Qty. Rcd. Not Invoiced");
                                    PurchLine.Modify;
                                end;
                            until PurchRcptLine.Next = 0;

                        PurchHeader.Get(PurchHeader."Document Type"::Order, Rec."Order No.");
                        PurchHeader.Validate("Posting Date", InvPostingDate);
                        PurchHeader.Receive := false;
                        PurchHeader.Invoice := true;
                        PurchPost.Run(PurchHeader);
                        Rec.Delete;

                        if PurchHeader."Last Posting No." = '' then
                            PurchInvHeader."No." := PurchHeader."No."
                        else
                            PurchInvHeader."No." := PurchHeader."Last Posting No.";
                        PurchInvHeader.SetRecFilter;

                        ReportSelection.Reset;
                        ReportSelection.SetRange(Usage, ReportSelection.Usage::"P.Invoice");
                        ReportSelection.Find('-');
                        repeat
                            ReportSelection.TestField("Report ID");
                            REPORT.Run(ReportSelection."Report ID", false, false, PurchInvHeader);
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
                        Clear(PostNonInvoicedPurchRcpt);
                        PostNonInvoicedPurchRcpt.SetPostingDate(InvPostingDate);
                        PostNonInvoicedPurchRcpt.RunModal;
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
                        Clear(SugNonInvPurchRcpt);
                        SugNonInvPurchRcpt.RunModal;
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
        PurchHeader: Record "Purchase Header";
        Text000: Label 'Do you want to post the invoice?';
        PurchLine: Record "Purchase Line";
        PurchRcptLine: Record "Purch. Rcpt. Line";
        PurchInvHeader: Record "Purch. Inv. Header";
        ReportSelection: Record "Report Selections";
        NonInvoicedPurchRcpt: Record "SSA Non-Invoiced Purch. Rcpt.";
        PurchSetup: Record "Purchases & Payables Setup";
        PostNonInvoicedPurchRcpt: Report "SSA Inv. Non-Inv Purch. Rcpt.";
        SugNonInvPurchRcpt: Report "SSA Sug. Non-Inv Purch. Rcpt.";
        PurchPost: Codeunit "Purch.-Post";
        InvPostingDate: Date;
        Text001: Label '<CM+15D>', Locked = true;
        Text002: Label 'There is nothing to post.';
        Text003: Label 'The specified invoice posting date is overdue already. Do you still want to post the invoice?';
        Text004: Label 'Please enter the posting date.';
}
