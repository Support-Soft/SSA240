pageextension 71900 "SSAFTCompany Information" extends "Company Information"
{
    layout
    {
        addlast(content)
        {
            group(SSAFT)
            {
                Caption = 'SAFT';

                field("SSAFT Contact No."; Rec."SSAFT Contact No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the SAFT Contact No. field.';
                }
            }
        }
    }
}