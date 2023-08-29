pageextension 71900 "SSAFTCompany Information" extends "Company Information"
{
    layout
    {
        addlast(content)
        {
            group(SSAFTSAFT)
            {
                Caption = 'SAFT';

                field("SSAFTSAFT Contact No."; Rec."SSAFTSAFT Contact No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the SAFT Contact No. field.';
                }
            }
        }
    }
}