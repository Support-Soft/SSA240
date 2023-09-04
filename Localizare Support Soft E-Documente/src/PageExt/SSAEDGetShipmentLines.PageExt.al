pageextension 72014 "SSAEDGet Shipment Lines" extends "Get Shipment Lines"
{
    layout
    {
        addlast(Control1)
        {
            field("SSAEDProdus cu Risc"; Rec."SSAEDProdus cu Risc")
            {
                ApplicationArea = All;
                ToolTip = 'Produs cu risc';
            }
        }

    }
}