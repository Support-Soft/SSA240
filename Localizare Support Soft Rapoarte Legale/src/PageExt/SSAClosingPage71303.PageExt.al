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
                RunObject = report "SSA GL Acc. Det. Trial Bal.";
                ApplicationArea = All;
                ToolTip = 'Executes the GL Account Trial Balance action.';
            }
            action("<Action1000000029>")
            {
                Caption = 'Trial Balance (5 equalities)';
                Image = "Report";
                Promoted = true;
                PromotedCategory = Category8;
                PromotedIsBig = true;
                RunObject = report "SSA Trial Balance (5 eq.)";
                ApplicationArea = All;
                ToolTip = 'Executes the Trial Balance (5 equalities) action.';
            }
        }
    }
}