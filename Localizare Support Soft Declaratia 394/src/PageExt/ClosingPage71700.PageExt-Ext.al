pageextension 71700 "SSA Closing Page 71700" extends "SSA Closing Page"
{
    actions
    {
        addlast(navigation)
        {
            action("<Action1000000022>")
            {
                ApplicationArea = All;
                Caption = 'D394';
                Image = "Report";
                Promoted = true;
                PromotedCategory = Category7;
                PromotedIsBig = true;
                RunObject = Page "SSA Domestic Declaration List";
            }
        }
    }
}