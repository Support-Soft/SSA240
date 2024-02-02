pageextension 70074 "SSA Posted Invt. Shipments" extends "Posted Invt. Shipments"
{
    layout
    {
        addlast(Control1)
        {
            field("SSA Sell-to Customer No."; Rec."SSA Sell-to Customer No.")
            {
                ApplicationArea = All;
                ToolTip = 'The Sell-to Customer No. field is used to specify the customer number of the customer who is to receive the shipment.';
            }
            field("SSA Sell-to Customer Name"; Rec."SSA Sell-to Customer Name")
            {
                ApplicationArea = All;
                ToolTip = 'The Sell-to Customer Name field is used to specify the name of the customer who is to receive the shipment.';
            }
        }
    }
}