pageextension 70003 "SSA Exch.RateAdjmt.Reg.70003" extends "Exchange Rate Adjmt. Register"
{
    layout
    {
        addafter("Adjusted Amt. (Add.-Curr.)")
        {
            field("SSA Source Type"; Rec."SSA Source Type")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Source Type field.';
            }
            field("SSA Source No."; Rec."SSA Source No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Source No. field.';
            }
        }
    }
}
