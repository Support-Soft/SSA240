pageextension 72015 "SSAEDWhse. Shipment Subform" extends "Whse. Shipment Subform"
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