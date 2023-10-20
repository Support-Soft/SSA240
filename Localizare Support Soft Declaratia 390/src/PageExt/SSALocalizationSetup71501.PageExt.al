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
                    ToolTip = 'Specifies the value of the VIES Declaration Nos. field.';
                }
                field("SSA Municipality No."; Rec."SSA Municipality No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Municipality No. field.';
                }
                field("SSA Street"; Rec."SSA Street")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Street field.';
                }
                field("SSA House No."; Rec."SSA House No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the House No. field.';
                }
                field("SSA Apartment No."; Rec."SSa Apartment No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Apartment No. field.';
                }
                field("SSA Tax Office Number"; Rec."SSA Tax Office Number")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Tax Office Number field.';
                }
            }
        }
    }
}