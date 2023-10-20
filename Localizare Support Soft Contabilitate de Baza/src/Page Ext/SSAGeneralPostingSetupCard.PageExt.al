pageextension 70040 "SSA General Posting Setup Card" extends "General Posting Setup Card" //395
{
    layout
    {
        addlast(Purchases)
        {
            field("SSA Purch. Line Disc. Account"; Rec."Purch. Line Disc. Account")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the general ledger account number to which to post purchase line discount amounts with this particular combination of business group and product group.';
            }
        }
    }
}