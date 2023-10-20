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
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the No. field.';
                }
                field("Line No."; Rec."Line No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Line No. field.';
                }
                field("Document ID"; Rec."Document ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Document ID field.';
                }
                field("Currency Code"; Rec."Currency Code")
                {
                    ApplicationArea = All;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Currency Code field.';
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Amount field.';
                }
                field("Amount (LCY)"; Rec."Amount (LCY)")
                {
                    ApplicationArea = All;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Amount (LCY) field.';
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
                field("Due Date"; Rec."Due Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Due Date field.';
                }
                field("Payment Class"; Rec."Payment Class")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Payment Class field.';
                }
                field("Status Name"; Rec."Status Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Status Name field.';
                }
                field("Status No."; Rec."Status No.")
                {
                    ApplicationArea = All;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Status field.';
                }
                field("Acceptation Code"; Rec."Acceptation Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Acceptation Code field.';
                }
                field("Drawee Reference"; Rec."Drawee Reference")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Drawee Reference field.';
                }
                field("Bank Account Name"; Rec."Bank Account Name")
                {
                    ApplicationArea = All;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Bank Account Name field.';
                }
                field("Bank Branch No."; Rec."Bank Branch No.")
                {
                    ApplicationArea = All;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Bank Branch No. field.';
                }
                field("Agency Code"; Rec."Agency Code")
                {
                    ApplicationArea = All;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Agency Code field.';
                }
                field("Bank Account No."; Rec."Bank Account No.")
                {
                    ApplicationArea = All;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Bank Account No. field.';
                }
                field("RIB Key"; Rec."RIB Key")
                {
                    ApplicationArea = All;
                    Visible = false;
                    ToolTip = 'Specifies the value of the RIB Key field.';
                }
                field("Payment in progress"; Rec."Payment in progress")
                {
                    ApplicationArea = All;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Payment in progress field.';
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
                    ToolTip = 'Executes the Card action.';
                    trigger OnAction()
                    var
                        Statement: Record "SSA Payment Header";
                        StatementForm: Page "SSA Payment Headers";
                    begin
                        if Statement.Get(Rec."No.") then begin
                            Statement.SetRange("No.", Rec."No.");
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
                    ToolTip = 'Executes the Modify action.';
                    trigger OnAction()
                    var
                        PaymentLine: Record "SSA Payment Line";
                        Consult: Page "SSA Payment Line Modification";
                    begin
                        PaymentLine.Copy(Rec);
                        PaymentLine.SetRange("No.", Rec."No.");
                        PaymentLine.SetRange("Line No.", Rec."Line No.");
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
