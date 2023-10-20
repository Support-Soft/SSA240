pageextension 70060 "SSA Det. Vendor Ledg. Entries" extends "Detailed Vendor Ledg. Entries"
{
    layout
    {
        addlast(Control1)
        {
            field("SSA Vendor Posting Group"; Rec."SSA Vendor Posting Group")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Vendor Posting Group field.';
            }
        }
    }
}