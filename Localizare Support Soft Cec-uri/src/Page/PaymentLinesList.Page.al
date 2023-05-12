page 70516 "SSA Payment Lines List"
{
    Caption = 'Payment Lines List';
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "SSA Payment Line";

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
            group(Payment)
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
                        Statement: Record "SSA Payment Header";
                        StatementForm: Page "SSA Payment Headers";
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
        area(processing)
        {
            group("F&unctions")
            {
                Caption = 'F&unctions';
                action(Modify)
                {
                    ApplicationArea = All;
                    Caption = 'Modify';
                    Image = EditFilter;

                    trigger OnAction()
                    var
                        PaymentLine: Record "SSA Payment Line";
                        Consult: Page "SSA Payment Line Modification";
                    begin
                        PaymentLine.Copy(Rec);
                        PaymentLine.SetRange("No.", "No.");
                        PaymentLine.SetRange("Line No.", "Line No.");
                        Consult.SetTableView(PaymentLine);
                        Consult.RunModal;
                    end;
                }
            }
        }
    }

    var
        Steps: Integer;
        PayNum: Code[20];

    procedure SetSteps(Step: Integer)
    begin
        Steps := Step;
    end;

    procedure SetNumBor(N: Code[20])
    begin
        PayNum := N;
    end;

    procedure GetNumBor() N: Code[20]
    begin
        N := PayNum;
    end;

    procedure DeactivateOKButton()
    begin
        /* PS12301 start deletion
        CurrForm.OK.VISIBLE(FALSE);
        PS12301 end deletion */

    end;

    procedure SetSelection(var PaymentLine: Record "SSA Payment Line")
    begin
        CurrPage.SetSelectionFilter(PaymentLine);
    end;
}

