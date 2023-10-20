pageextension 70052 "SSA Sales Shipment Lines" extends "Sales Shipment Lines" //5824
{
    layout
    {
        addlast(Control1)
        {
            field("SSA Gen. Prod. Posting Group"; Rec."Gen. Prod. Posting Group")
            {
                ApplicationArea = All;
                Editable = false;
                Style = Strong;
                ToolTip = 'Specifies the value of the Gen. Prod. Posting Group field.';
            }
        }
    }
}