pageextension 70069 "SSA Employee Card" extends "Employee Card"
{
    layout
    {
        addlast(Content)
        {
            group("SSA LocalizareSS")
            {
                Caption = 'Localizare SS';
                field("SSA ID Series"; "SSA ID Series")
                {
                    ApplicationArea = All;
                }
                field("SSA ID No."; "SSA ID No.")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}