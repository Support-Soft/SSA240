pageextension 71901 SSAFTDimensions extends Dimensions
{
    layout
    {
        addlast(content)
        {
            group(SSAFT)
            {
                Caption = 'SAFT';

                field("SSAFT Export"; Rec."SSAFT Export")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the SAFT Export field.';
                }
                field("SSAFT Analysis Type"; Rec."SSAFT Analysis Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the SAFT Analysis Type field.';
                }
            }
        }
    }
}