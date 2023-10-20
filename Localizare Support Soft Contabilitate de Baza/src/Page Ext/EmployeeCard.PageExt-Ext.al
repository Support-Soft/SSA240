pageextension 70069 "SSA Employee Card" extends "Employee Card"
{
    layout
    {
        addlast(content)
        {
            group("SSA LocalizareSS")
            {
                Caption = 'Localizare SS';
                field("SSA ID Series"; Rec."SSA ID Series")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the ID Series field.';
                }
                field("SSA ID No."; Rec."SSA ID No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the ID No. field.';
                }
            }
        }
    }
}