page 70525 "SSA Payment Bank Archive"
{
    Caption = 'Bank Account Card';
    Editable = false;
    PageType = Card;
    SourceTable = "SSA Payment Header Archive";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("Bank Name"; Rec."Bank Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Bank Name field.';
                }
                field("Bank Address"; Rec."Bank Address")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Bank Address field.';
                }
                field("Bank Address 2"; Rec."Bank Address 2")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Bank Address 2 field.';
                }
                field("Bank Post Code"; Rec."Bank Post Code")
                {
                    ApplicationArea = All;
                    Caption = 'Post Code/City';
                    ToolTip = 'Specifies the value of the Post Code/City field.';
                }
                field("Bank City"; Rec."Bank City")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Bank City field.';
                }
                field("Bank Country/Region Code"; Rec."Bank Country/Region Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Bank Country/Region Code field.';
                }
                field("Bank Contact"; Rec."Bank Contact")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Bank Contact field.';
                }
                field("Bank Branch No."; Rec."Bank Branch No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Bank Branch No. field.';
                }
                field("Bank Account No."; Rec."Bank Account No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Bank Account No. field.';
                }
            }
        }
    }

    actions
    {
    }
}
