pageextension 71901 SSAFTDimensions extends Dimensions
{
    layout
    {
        addlast(content)
        {
            group(SSAFTSAFT)
            {
                Caption = 'SAFT';

                field("SSAFTSAFT Export"; Rec."SSAFTSAFT Export")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the SAFT Export field.';
                }
                field("SSAFTSAFT Analysis Type"; Rec."SSAFTSAFT Analysis Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the SAFT Analysis Type field.';
                }
            }
        }
    }
}