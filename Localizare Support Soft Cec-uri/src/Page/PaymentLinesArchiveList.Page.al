page 70524 "SSA Payment Lines Archive List"
{
    Caption = 'Payment Lines Archive List';
    Editable = false;
    PageType = List;
    SourceTable = "SSA Payment Line Archive";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field("No."; "No.")
                {
                    ApplicationArea = All;
                }
                field("Line No."; "Line No.")
                {
                    ApplicationArea = All;
                }
                field("Document ID"; "Document ID")
                {
                    ApplicationArea = All;
                }
                field("Currency Code"; "Currency Code")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field(Amount; Amount)
                {
                    ApplicationArea = All;
                }
                field("Amount (LCY)"; "Amount (LCY)")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Account Type"; "Account Type")
                {
                    ApplicationArea = All;
                }
                field("Account No."; "Account No.")
                {
                    ApplicationArea = All;
                }
                field("Due Date"; "Due Date")
                {
                    ApplicationArea = All;
                }
                field("Payment Class"; "Payment Class")
                {
                    ApplicationArea = All;
                }
                field("Status Name"; "Status Name")
                {
                    ApplicationArea = All;
                }
                field("Status No."; "Status No.")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Acceptation Code"; "Acceptation Code")
                {
                    ApplicationArea = All;
                }
                field("Drawee Reference"; "Drawee Reference")
                {
                    ApplicationArea = All;
                }
                field("Bank Account Name"; "Bank Account Name")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Bank Branch No."; "Bank Branch No.")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Agency Code"; "Agency Code")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Bank Account No."; "Bank Account No.")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("RIB Key"; "RIB Key")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Payment in progress"; "Payment in progress")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group(Functions)
            {
                Caption = '&Payment';
                action(Card)
                {
                    ApplicationArea = All;
                    Caption = 'Card';
                    Image = EditLines;
                    ShortCutKey = 'Shift+F7';

                    trigger OnAction()
                    var
                        Statement: Record "SSA Payment Header Archive";
                        StatementForm: Page "SSA Payment Headers Archive";
                    begin
                        if Statement.Get("No.") then begin
                            Statement.SetRange("No.", "No.");
                            StatementForm.SetTableView(Statement);
                            StatementForm.Run;
                        end;
                    end;
                }
            }
        }
    }
}

