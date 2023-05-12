pageextension 71501 "SSA Localization Setup 71501" extends "SSA Localization Setup"
{
    layout
    {
        addlast(content)
        {
            group("SSA VIES")
            {
                Caption = 'VIES';
                field("SSA VIES Declaration Nos."; "SSA VIES Declaration Nos.")
                {
                    ApplicationArea = All;
                }
                field("SSA Municipality No."; "SSA Municipality No.")
                {
                    ApplicationArea = All;
                }
                field("SSA Street"; "SSA Street")
                {
                    ApplicationArea = All;
                }
                field("SSA House No."; "SSA House No.")
                {
                    ApplicationArea = All;
                }
                field("SSA Apartment No."; "SSa Apartment No.")
                {
                    ApplicationArea = All;
                }
                field("SSA Tax Office Number"; "SSA Tax Office Number")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}