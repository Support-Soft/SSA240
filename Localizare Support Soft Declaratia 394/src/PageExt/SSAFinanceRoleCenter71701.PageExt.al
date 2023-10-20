pageextension 71701 "SSA Finance Role Center71701" extends "Finance Manager Role Center"
{
    actions
    {
        addlast("SSA Statements")
        {
            action("SSA 394")
            {
                ApplicationArea = All;
                Caption = 'D394';
                Image = "Report";
                RunObject = page "SSA Domestic Declaration List";
                ToolTip = 'Executes the D394 action.';
            }
        }
    }
}