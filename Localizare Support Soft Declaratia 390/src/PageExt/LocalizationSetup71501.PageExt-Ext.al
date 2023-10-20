pageextension 71501 "SSA Localization Setup 71501" extends "SSA Localization Setup"
{
    layout
    {
        addlast(content)
        {
            group("SSA VIES")
            {
                Caption = 'VIES';
                field("SSA VIES Declaration Nos."; Rec."SSA VIES Declaration Nos.")
                {
                    ApplicationArea = All;
                }
                field("SSA Municipality No."; Rec."SSA Municipality No.")
                {
                    ApplicationArea = All;
                }
                field("SSA Street"; Rec."SSA Street")
                {
                    ApplicationArea = All;
                }
                field("SSA House No."; Rec."SSA House No.")
                {
                    ApplicationArea = All;
                }
                field("SSA Apartment No."; Rec."SSa Apartment No.")
                {
                    ApplicationArea = All;
                }
                field("SSA Tax Office Number"; Rec."SSA Tax Office Number")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}