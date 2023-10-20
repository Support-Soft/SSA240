pageextension 71504 "SSA Finance Role Center71504" extends "Finance Manager Role Center"
{
    actions
    {
        addlast("SSA Statements")
        {
            action("SSA D390")
            {
                ApplicationArea = All;
                Caption = 'D390';
                Image = "Report";
                RunObject = page "SSA VIES Declarations";
                ToolTip = 'Executes the D390 action.';
            }
        }
    }
}