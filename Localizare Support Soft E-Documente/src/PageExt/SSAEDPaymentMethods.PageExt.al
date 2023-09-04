pageextension 72007 "SSAEDPayment Methods" extends "Payment Methods"
{
    layout
    {
        addlast(Control1)
        {
            field("SSAEDEFactura ID"; Rec."SSAEDEFactura ID")
            {
                ToolTip = 'Factura ID';
                ApplicationArea = All;
            }
        }
    }
}

