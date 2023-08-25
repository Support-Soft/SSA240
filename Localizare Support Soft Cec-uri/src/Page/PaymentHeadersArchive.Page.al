page 70521 "SSA Payment Headers Archive"
{
    Caption = 'Payment Headers Archive';
    Editable = false;
    PageType = Document;
    SourceTable = "SSA Payment Header Archive";

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("No."; "No.")
                {
                    ApplicationArea = All;
                    AssistEdit = false;
                }
                field("Payment Class"; "Payment Class")
                {
                    ApplicationArea = All;
                    Lookup = false;
                }
                field("Payment Class Name"; "Payment Class Name")
                {
                    ApplicationArea = All;
                    DrillDown = false;
                }
                field("Status Name"; "Status Name")
                {
                    ApplicationArea = All;
                    DrillDown = false;
                }
                field("Currency Code"; "Currency Code")
                {
                    ApplicationArea = All;
                }
                field("Posting Date"; "Posting Date")
                {
                    ApplicationArea = All;
                }
                field("Document Date"; "Document Date")
                {
                    ApplicationArea = All;
                    trigger OnValidate()
                    begin
                        DocumentDateOnAfterValidate;
                    end;
                }
                field("Amount (LCY)"; "Amount (LCY)")
                {
                    ApplicationArea = All;
                }
            }
            part(Lines; "SSA Payment Lines Archive")
            {
                ApplicationArea = All;
                SubPageLink = "No." = field("No.");
            }
            group(Posting)
            {
                Caption = 'Posting';
                field("Source Code"; "Source Code")
                {
                    ApplicationArea = All;
                }
                field("Shortcut Dimension 1 Code"; "Shortcut Dimension 1 Code")
                {
                    ApplicationArea = All;
                }
                field("Shortcut Dimension 2 Code"; "Shortcut Dimension 2 Code")
                {
                    ApplicationArea = All;
                }
                field("Account Type"; "Account Type")
                {
                    ApplicationArea = All;
                }
                field("Account No."; "Account No.")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Header")
            {
                Caption = '&Header';
                action(Dimensions)
                {
                    ApplicationArea = All;
                    Caption = 'Dimensions';
                    Image = Dimensions;
                }
                action("Header RIB")
                {
                    ApplicationArea = All;
                    Caption = 'Header RIB';
                    RunObject = Page "SSA Payment Bank Archive";
                    RunPageLink = "No." = field("No.");
                }
            }
            group("&Navigate")
            {
                Caption = '&Navigate';
                action(Header)
                {
                    ApplicationArea = All;
                    Caption = 'Header';

                    trigger OnAction()
                    begin
                        Navigate.SetDoc("Posting Date", "No.");
                        Navigate.Run;
                    end;
                }
                action(Line)
                {
                    ApplicationArea = All;
                    Caption = 'Line';

                    trigger OnAction()
                    var
                        PaymentLineArchive: Record "SSA Payment Line Archive";
                    begin
                        CurrPage.Lines.PAGE.GetRecord(PaymentLineArchive);
                        Navigate.SetDoc("Posting Date", PaymentLineArchive."Document ID");
                        Navigate.Run;
                    end;
                }
            }
        }
    }

    var
        Navigate: Page Navigate;

    local procedure DocumentDateOnAfterValidate()
    begin
        CurrPage.Update;
    end;
}

