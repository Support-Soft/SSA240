pageextension 70040 "SSA General Posting Setup Card" extends "General Posting Setup Card" //395
{
    layout
    {
        addlast(Purchases)
        {
            field("SSA Purch. Line Disc. Account"; "Purch. Line Disc. Account")
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
    }
}