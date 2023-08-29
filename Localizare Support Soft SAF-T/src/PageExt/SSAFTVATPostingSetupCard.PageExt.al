pageextension 71906 "SSAFTVAT Posting Setup Card" extends "VAT Posting Setup Card"
{
    layout
    {
        addlast(content)
        {
            group(SSAFTSAFT)
            {
                Caption = 'SAFT';
                field("SSAFTSAFT Tax Code"; Rec."SSAFTSAFT Tax Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the SAFT Tax Code field.';
                }
                field("SSAFTSAFT Deductibilitate %"; Rec."SSAFTSAFT Deductibilitate %")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the SAFTDeductibilitate % field.';
                }
            }
        }
    }
}