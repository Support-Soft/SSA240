page 70521 "SSA Payment Headers Archive"
{
    Caption = 'Payment Headers Archive';
    Editable = false;
    PageType = Document;
    SourceTable = "SSA Payment Header Archive";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    AssistEdit = false;
                    ToolTip = 'Specifies the value of the No. field.';
                }
                field("Payment Class"; Rec."Payment Class")
                {
                    ApplicationArea = All;
                    Lookup = false;
                    ToolTip = 'Specifies the value of the Payment Class field.';
                }
                field("Payment Class Name"; Rec."Payment Class Name")
                {
                    ApplicationArea = All;
                    DrillDown = false;
                    ToolTip = 'Specifies the value of the Payment Class Name field.';
                }
                field("Status Name"; Rec."Status Name")
                {
                    ApplicationArea = All;
                    DrillDown = false;
                    ToolTip = 'Specifies the value of the Status Name field.';
                }
                field("Currency Code"; Rec."Currency Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Currency Code field.';
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Posting Date field.';
                }
                field("Document Date"; Rec."Document Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Document Date field.';
                    trigger OnValidate()
                    begin
                        DocumentDateOnAfterValidate;
                    end;
                }
                field("Amount (LCY)"; Rec."Amount (LCY)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Total Amount (LCY) field.';
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
                field("Source Code"; Rec."Source Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Source Code field.';
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Shortcut Dimension 1 Code field.';
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Shortcut Dimension 2 Code field.';
                }
                field("Account Type"; Rec."Account Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Account Type field.';
                }
                field("Account No."; Rec."Account No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Account No. field.';
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
                    ToolTip = 'Executes the Dimensions action.';
                }
                action("Header RIB")
                {
                    ApplicationArea = All;
                    Caption = 'Header RIB';
                    RunObject = page "SSA Payment Bank Archive";
                    RunPageLink = "No." = field("No.");
                    ToolTip = 'Executes the Header RIB action.';
                }
            }
            group("&Navigate")
            {
                Caption = '&Navigate';
                action(Header)
                {
                    ApplicationArea = All;
                    Caption = 'Header';
                    ToolTip = 'Executes the Header action.';
                    trigger OnAction()
                    begin
                        Navigate.SetDoc(Rec."Posting Date", Rec."No.");
                        Navigate.Run;
                    end;
                }
                action(Line)
                {
                    ApplicationArea = All;
                    Caption = 'Line';
                    ToolTip = 'Executes the Line action.';
                    trigger OnAction()
                    var
                        PaymentLineArchive: Record "SSA Payment Line Archive";
                    begin
                        CurrPage.Lines.PAGE.GetRecord(PaymentLineArchive);
                        Navigate.SetDoc(Rec."Posting Date", PaymentLineArchive."Document ID");
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
