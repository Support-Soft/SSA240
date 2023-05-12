pageextension 70050 "SSA Return Receipt Lines" extends "Return Receipt Lines" //6667
{
    layout
    {
        addlast(Control1)
        {
            field("SSA Gen. Prod. Posting Group"; "Gen. Prod. Posting Group")
            {
                ApplicationArea = All;
                Editable = false;
                Style = Strong;
            }
        }
    }

    actions
    {
    }
}