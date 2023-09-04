pageextension 71907 "SSAFTVAT Posting Setup" extends "VAT Posting Setup"
{
    layout
    {
        addlast(Control1)
        {

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