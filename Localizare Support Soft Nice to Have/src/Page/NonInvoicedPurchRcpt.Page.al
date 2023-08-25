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
                field("Buy-from Vendor No."; "Buy-from Vendor No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Order Address Code"; "Order Address Code")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                }
                field("Buy-from Vendor Name"; "Buy-from Vendor Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Buy-from Post Code"; "Buy-from Post Code")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                }
                field("Buy-from Country/Region Code"; "Buy-from Country/Region Code")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                }
                field("Buy-from Contact"; "Buy-from Contact")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                }
                field("Pay-to Vendor No."; "Pay-to Vendor No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                }
                field("Pay-to Name"; "Pay-to Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                }
                field("Pay-to Post Code"; "Pay-to Post Code")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                }
                field("Pay-to Country/Region Code"; "Pay-to Country/Region Code")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                }
                field("Pay-to Contact"; "Pay-to Contact")
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
                field("Purchaser Code"; "Purchaser Code")
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
                field("Location Code"; "Location Code")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = true;
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
                    RunObject = Page "Posted Purchase Receipt";
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
                    RunObject = Page "Purchase Receipt Statistics";
                    RunPageLink = "No." = field("No.");
                    ShortCutKey = 'F7';
                }
                action("Co&mments")
                {
                    ApplicationArea = All;
                    Caption = 'Co&mments';
                    Image = ViewComments;
                    RunObject = Page "Purch. Comment Sheet";
                    RunPageLink = "Document Type" = const(Receipt),
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
                        PurchSetup.Get;

                        if InvPostingDate = 0D then
                            Error(Text004);

                        if not Confirm(Text000, false) then
                            exit;

                        if not NonInvoicedPurchRcpt.Find('-') then
                            Error(Text002);

                        if (InvPostingDate > CalcDate(Text001, "Posting Date")) then
                            if not Confirm(Text003, false, CalcDate(Text001, "Posting Date")) then
                                exit;

                        PurchRcptLine.SetRange("Document No.", "No.");
                        if PurchRcptLine.Find('-') then
                            repeat
                                if PurchRcptLine."Qty. Rcd. Not Invoiced" > 0 then begin
                                    PurchLine.Get(PurchLine."Document Type"::Order, PurchRcptLine."Order No.", PurchRcptLine."Order Line No.");
                                    PurchLine.Validate("Qty. to Invoice", PurchRcptLine."Qty. Rcd. Not Invoiced");
                                    PurchLine.Modify;
                                end;
                            until PurchRcptLine.Next = 0;

                        with PurchHeader do begin
                            Get(PurchHeader."Document Type"::Order, "Order No.");
                            Validate("Posting Date", InvPostingDate);
                            Receive := false;
                            Invoice := true;
                            PurchPost.Run(PurchHeader);
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
                        PurchSetup.Get;

                        if InvPostingDate = 0D then
                            Error(Text004);

                        if not Confirm(Text000, false) then
                            exit;

                        if not NonInvoicedPurchRcpt.Find('-') then
                            Error(Text002);

                        if (InvPostingDate > CalcDate(Text001, "Posting Date")) then
                            if not Confirm(Text003, false, CalcDate(Text001, "Posting Date")) then
                                exit;

                        PurchRcptLine.SetRange("Document No.", "No.");
                        if PurchRcptLine.Find('-') then
                            repeat
                                if PurchRcptLine."Qty. Rcd. Not Invoiced" > 0 then begin
                                    PurchLine.Get(PurchLine."Document Type"::Order, PurchRcptLine."Order No.", PurchRcptLine."Order Line No.");
                                    PurchLine.Validate("Qty. to Invoice", PurchRcptLine."Qty. Rcd. Not Invoiced");
                                    PurchLine.Modify;
                                end;
                            until PurchRcptLine.Next = 0;

                        with PurchHeader do begin
                            Get(PurchHeader."Document Type"::Order, "Order No.");
                            Validate("Posting Date", InvPostingDate);
                            Receive := false;
                            Invoice := true;
                            PurchPost.Run(PurchHeader);
                            Rec.Delete;

                            if "Last Posting No." = '' then
                                PurchInvHeader."No." := "No."
                            else
                                PurchInvHeader."No." := "Last Posting No.";
                            PurchInvHeader.SetRecFilter;
                        end;

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

                    trigger OnAction()
                    begin
                        Clear(SugNonInvPurchRcpt);
                        SugNonInvPurchRcpt.RunModal;
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
        Text001: Label '<CM+15D>';
        Text002: Label 'There is nothing to post.';
        Text003: Label 'The specified invoice posting date is overdue already. Do you still want to post the invoice?';
        Text004: Label 'Please enter the posting date.';
}

