pageextension 70051 "SSA Posted Trans. Shpt. Lines" extends "Posted Transfer Shipment Lines" //5758
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