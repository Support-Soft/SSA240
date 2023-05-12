pageextension 70003 "SSA Exch.RateAdjmt.Reg.70003" extends "Exchange Rate Adjmt. Register"
{
    layout
    {
        addafter("Adjusted Amt. (Add.-Curr.)")
        {
            field("SSA Source Type"; "SSA Source Type")
            {
                ApplicationArea = All;
            }
            field("SSA Source No."; "SSA Source No.")
            {
                ApplicationArea = All;
            }
        }
    }
}

