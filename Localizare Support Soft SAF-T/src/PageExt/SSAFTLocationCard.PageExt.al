pageextension 71903 "SSAFTLocation Card" extends "Location Card"
{
    layout
    {
        addlast(content)
        {
            group(SSAFT)
            {
                Caption = 'SAFT';
                field("SSAFT Do Not Export"; Rec."SSAFT Do Not Export")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the SAFT Do Not Export field.';
                }
            }
        }
    }
}