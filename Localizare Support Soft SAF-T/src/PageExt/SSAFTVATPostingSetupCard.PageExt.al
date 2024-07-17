pageextension 71906 "SSAFTVAT Posting Setup Card" extends "VAT Posting Setup Card"
{
    layout
    {
        addlast(content)
        {
            group(SSAFT)
            {
                Caption = 'SAFT';
                field("SSAFT Tax Code"; Rec."SSAFT Tax Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the SAFT Tax Code field.';
                }
                field("SSAFT Deductibilitate %"; Rec."SSAFT Deductibilitate %")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the SAFTDeductibilitate % field.';
                }
            }
        }
    }
}