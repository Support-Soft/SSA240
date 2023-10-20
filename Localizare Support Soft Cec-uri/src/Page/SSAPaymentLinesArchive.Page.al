page 70522 "SSA Payment Lines Archive"
{
    Caption = 'Payment Lines Archive';
    Editable = false;
    PageType = ListPart;
    SourceTable = "SSA Payment Line Archive";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
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
                field("Document ID"; Rec."Document ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Document ID field.';
                }
                field("External Document No."; Rec."External Document No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the External Document No. field.';
                }
                field("Drawee Reference"; Rec."Drawee Reference")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Drawee Reference field.';
                }
                field("Posting Group"; Rec."Posting Group")
                {
                    ApplicationArea = All;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Posting Group field.';
                }
                field("Due Date"; Rec."Due Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Due Date field.';
                }
                field("Debit Amount"; Rec."Debit Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Debit Amount field.';
                }
                field("Credit Amount"; Rec."Credit Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Credit Amount field.';
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Amount field.';
                }
                field("Bank Account"; Rec."Bank Account")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Bank Account field.';
                }
                field("Acceptation Code"; Rec."Acceptation Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Acceptation Code field.';
                }
                field("Payment Address Code"; Rec."Payment Address Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Payment Address Code field.';
                }
                field("Bank Branch No."; Rec."Bank Branch No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Bank Branch No. field.';
                }
                field("Agency Code"; Rec."Agency Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Agency Code field.';
                }
                field("Bank Account No."; Rec."Bank Account No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Bank Account No. field.';
                }
                field("Bank Account Name"; Rec."Bank Account Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Bank Account Name field.';
                }
                field("Bank City"; Rec."Bank City")
                {
                    ApplicationArea = All;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Bank Account City field.';
                }
                field("RIB Key"; Rec."RIB Key")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the RIB Key field.';
                }
                field("RIB Checked"; Rec."RIB Checked")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the RIB Checked field.';
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            group("A&ccount")
            {
                Caption = 'A&ccount';
                action(Card)
                {
                    ApplicationArea = All;
                    Caption = 'Card';
                    Image = EditLines;
                    ShortcutKey = 'Shift+F7';
                    ToolTip = 'Executes the Card action.';
                    trigger OnAction()
                    begin
                        //This functionality was copied from page #45007688. Unsupported part was commented. Please check it.
                        /*CurrPage.Lines.FORM.*/
                        ShowAccount;
                    end;
                }
                action("Ledger E&ntries")
                {
                    ApplicationArea = All;
                    Caption = 'Ledger E&ntries';
                    ShortcutKey = 'Ctrl+F7';
                    ToolTip = 'Executes the Ledger E&ntries action.';
                    trigger OnAction()
                    begin
                        //This functionality was copied from page #45007688. Unsupported part was commented. Please check it.
                        /*CurrPage.Lines.FORM.*/
                        ShowEntries;
                    end;
                }
            }
            group("&Line")
            {
                Caption = '&Line';
                action(Dimensions)
                {
                    ApplicationArea = All;
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    ShortcutKey = 'Shift+Ctrl+D';
                    ToolTip = 'Executes the Dimensions action.';
                    trigger OnAction()
                    begin
                        //This functionality was copied from page #45007688. Unsupported part was commented. Please check it.
                        /*CurrPage.Lines.FORM.*/
                        Rec.ShowDimensions;
                    end;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        AccountNoOnFormat;
    end;

    var

        "Account No.Emphasize": Boolean;

    procedure ShowAccount()
    var
        GenJnlLine: Record "Gen. Journal Line";
    begin
        GenJnlLine."Account Type" := Rec."Account Type";
        GenJnlLine."Account No." := Rec."Account No.";
        CODEUNIT.Run(CODEUNIT::"Gen. Jnl.-Show Card", GenJnlLine);
    end;

    procedure ShowEntries()
    var
        GenJnlLine: Record "Gen. Journal Line";
    begin
        GenJnlLine."Account Type" := Rec."Account Type";
        GenJnlLine."Account No." := Rec."Account No.";
        CODEUNIT.Run(CODEUNIT::"Gen. Jnl.-Show Entries", GenJnlLine);
    end;

    local procedure AccountNoOnFormat()
    begin
        if Rec."Copied To No." <> '' then
            "Account No.Emphasize" := true;
    end;
}
