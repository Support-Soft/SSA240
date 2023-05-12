pageextension 71503 "SSA Closing Page 71503" extends "SSA Closing Page"
{
    actions
    {
        addlast(navigation)
        {
            action("<Action1000000023>")
            {
                ApplicationArea = All;
                Caption = 'D390';
                Image = "Report";
                Promoted = true;
                PromotedCategory = Category7;
                PromotedIsBig = true;
                RunObject = page "SSA VIES Declarations";
            }
        }
    }
}