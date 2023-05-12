pageextension 70048 "SSA Return Shipment Lines" extends "Return Shipment Lines" //6657
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