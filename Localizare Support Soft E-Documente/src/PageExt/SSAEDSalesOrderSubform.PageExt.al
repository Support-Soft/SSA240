pageextension 72013 "SSAEDSales Order Subform" extends "Sales Order Subform"
{
    layout
    {
        addlast(Control1)
        {
            field("SSAEDProdus cu Risc"; Rec."SSAEDProdus cu Risc")
            {
                ApplicationArea = All;
                ToolTip = 'Produs cu risc';
                Editable = false;
            }
        }

    }
}