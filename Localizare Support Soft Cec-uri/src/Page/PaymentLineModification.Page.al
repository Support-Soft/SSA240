page 70515 "SSA Payment Line Modification"
{
    Caption = 'Payment Line Modification';
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = Card;
    RefreshOnActivate = true;
    SourceTable = "SSA Payment Line";

    layout
    {
        area(content)
        {
            group(Control1)
            {
                ShowCaption = false;
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
                field("Due Date"; Rec."Due Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Due Date field.';
                }
                field("Acceptation Code"; Rec."Acceptation Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Acceptation Code field.';
                }
                field("Bank Account"; Rec."Bank Account")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Bank Account field.';
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
    }

    trigger OnInit()
    begin
        CurrPage.LookupMode := true;
    end;
}
