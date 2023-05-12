pageextension 70047 "SSA Purch. Receipt Lines" extends "Purch. Receipt Lines" //5806
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
            field("SSA Vendor Invoice No."; "SSA Vendor Invoice No.")
            {
                ApplicationArea = All;
            }
            field("SSA Vendor Shipment No."; "SSA Vendor Shipment No.")
            {
                ApplicationArea = All;
            }
            field("SSA Custom Invoice No."; "SSA Custom Invoice No.")
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
    }
}