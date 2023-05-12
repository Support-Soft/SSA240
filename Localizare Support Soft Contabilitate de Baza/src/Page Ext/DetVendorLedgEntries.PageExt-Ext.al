pageextension 70060 "SSA Det. Vendor Ledg. Entries" extends "Detailed Vendor Ledg. Entries"
{
    layout
    {
        addlast(Control1)
        {
            field("SSA Vendor Posting Group"; "SSA Vendor Posting Group")
            {
                ApplicationArea = All;
            }
        }
    }
}