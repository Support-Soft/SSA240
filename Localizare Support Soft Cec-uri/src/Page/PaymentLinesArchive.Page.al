page 70522 "SSA Payment Lines Archive"
{
    Caption = 'Payment Lines Archive';
    Editable = false;
    PageType = ListPart;
    SourceTable = "SSA Payment Line Archive";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field("Account Type"; "Account Type")
                {
                    ApplicationArea = All;
                }
                field("Account No."; "Account No.")
                {
                    ApplicationArea = All;
                }
                field("Document ID"; "Document ID")
                {
                    ApplicationArea = All;
                }
                field("External Document No."; "External Document No.")
                {
                    ApplicationArea = All;
                }
                field("Drawee Reference"; "Drawee Reference")
                {
                    ApplicationArea = All;
                }
                field("Posting Group"; "Posting Group")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Due Date"; "Due Date")
                {
                    ApplicationArea = All;
                }
                field("Debit Amount"; "Debit Amount")
                {
                    ApplicationArea = All;
                }
                field("Credit Amount"; "Credit Amount")
                {
                    ApplicationArea = All;
                }
                field(Amount; Amount)
                {
                    ApplicationArea = All;
                }
                field("Bank Account"; "Bank Account")
                {
                    ApplicationArea = All;
                }
                field("Acceptation Code"; "Acceptation Code")
                {
                    ApplicationArea = All;
                }
                field("Payment Address Code"; "Payment Address Code")
                {
                    ApplicationArea = All;
                }
                field("Bank Branch No."; "Bank Branch No.")
                {
                    ApplicationArea = All;
                }
                field("Agency Code"; "Agency Code")
                {
                    ApplicationArea = All;
                }
                field("Bank Account No."; "Bank Account No.")
                {
                    ApplicationArea = All;
                }
                field("Bank Account Name"; "Bank Account Name")
                {
                    ApplicationArea = All;
                }
                field("Bank City"; "Bank City")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("RIB Key"; "RIB Key")
                {
                    ApplicationArea = All;
                }
                field("RIB Checked"; "RIB Checked")
                {
                    ApplicationArea = All;
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
                    ShortCutKey = 'Shift+F7';

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
                    ShortCutKey = 'Ctrl+F7';

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
                    ShortCutKey = 'Shift+Ctrl+D';

                    trigger OnAction()
                    begin
                        //This functionality was copied from page #45007688. Unsupported part was commented. Please check it.
                        /*CurrPage.Lines.FORM.*/
                        ShowDimensions;

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
        Header: Record "SSA Payment Header";
        Status: Record "SSA Payment Status";
        [InDataSet]
        "Account No.Emphasize": Boolean;

    procedure ShowAccount()
    var
        GenJnlLine: Record "Gen. Journal Line";
    begin
        GenJnlLine."Account Type" := "Account Type";
        GenJnlLine."Account No." := "Account No.";
        CODEUNIT.Run(CODEUNIT::"Gen. Jnl.-Show Card", GenJnlLine);
    end;

    procedure ShowEntries()
    var
        GenJnlLine: Record "Gen. Journal Line";
    begin
        GenJnlLine."Account Type" := "Account Type";
        GenJnlLine."Account No." := "Account No.";
        CODEUNIT.Run(CODEUNIT::"Gen. Jnl.-Show Entries", GenJnlLine);
    end;

    local procedure AccountNoOnFormat()
    begin
        if "Copied To No." <> '' then
            "Account No.Emphasize" := true;
    end;
}

