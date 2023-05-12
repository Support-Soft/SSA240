pageextension 71303 "SSA Closing Page 71303" extends "SSA Closing Page"
{
    actions
    {
        addlast(reporting)
        {
            action("<Action1000000032>")
            {
                Caption = 'GL Account Trial Balance';
                Image = "Report";
                Promoted = true;
                PromotedCategory = Category8;
                PromotedIsBig = true;
                RunObject = Report "SSA GL Acc. Det. Trial Bal.";
            }
            action("<Action1000000029>")
            {
                Caption = 'Trial Balance (5 equalities)';
                Image = "Report";
                Promoted = true;
                PromotedCategory = Category8;
                PromotedIsBig = true;
                RunObject = Report "SSA Trial Balance (5 eq.)";
            }
        }
    }
}