page 70520 "SSA Payment Bank"
{
    Caption = 'Bank Account Card';
    PageType = Card;
    SourceTable = "SSA Payment Header";

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("Bank Name"; "Bank Name")
                {
                    ApplicationArea = All;
                }
                field("Bank Address"; "Bank Address")
                {
                    ApplicationArea = All;
                }
                field("Bank Address 2"; "Bank Address 2")
                {
                    ApplicationArea = All;
                }
                field("Bank Post Code"; "Bank Post Code")
                {
                    ApplicationArea = All;
                    Caption = 'Post Code/City';
                }
                field("Bank City"; "Bank City")
                {
                    ApplicationArea = All;
                }
                field("Bank Country/Region Code"; "Bank Country/Region Code")
                {
                    ApplicationArea = All;
                }
                field("Bank Contact"; "Bank Contact")
                {
                    ApplicationArea = All;
                }
                field("Bank Branch No."; "Bank Branch No.")
                {
                    ApplicationArea = All;
                }
                field("Bank Account No."; "Bank Account No.")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
    }
}

