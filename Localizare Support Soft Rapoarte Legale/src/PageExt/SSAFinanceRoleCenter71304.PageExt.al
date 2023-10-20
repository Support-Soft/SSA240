pageextension 71304 "SSA Finance Role Center71304" extends "Finance Manager Role Center"
{
    actions
    {
        addlast("SSA Checking")
        {
            action("SSA GLAccountTrialBalance")
            {
                Caption = 'GL Account Trial Balance';
                Image = "Report";
                RunObject = report "SSA GL Acc. Det. Trial Bal.";
                ToolTip = 'Executes the GL Account Trial Balance action.';
                ApplicationArea = All;
            }
            action("SSA TrialBalance5equalities")
            {
                Caption = 'Trial Balance (5 equalities)';
                Image = "Report";
                RunObject = report "SSA Trial Balance (5 eq.)";
                ToolTip = 'Executes the Trial Balance (5 equalities) action.';
                ApplicationArea = All;
            }
        }
    }
}