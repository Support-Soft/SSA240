pageextension 71903 "SSAFTLocation Card" extends "Location Card"
{
    layout
    {
        addlast(content)
        {
            group(SSAFTSAFT)
            {
                Caption = 'SAFT';
                field("SSAFTSAFT Do Not Export"; Rec."SSAFTSAFT Do Not Export")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the SAFT Do Not Export field.';
                }
            }
        }
    }
}