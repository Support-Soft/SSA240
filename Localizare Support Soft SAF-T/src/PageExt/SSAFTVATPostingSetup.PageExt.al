pageextension 71907 "SSAFTVAT Posting Setup" extends "VAT Posting Setup"
{
    layout
    {
        addlast(Control1)
        {

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