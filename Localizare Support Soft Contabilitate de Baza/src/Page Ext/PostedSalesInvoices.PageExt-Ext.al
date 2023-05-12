pageextension 70062 "SSA Posted Sales Invoices" extends "Posted Sales Invoices"
{
    layout
    {
        addlast(Control1)
        {
            field("SSA Tip Document D394"; "SSA Tip Document D394")
            {
                ApplicationArea = All;
            }
            field("SSA Stare Factura"; "SSA Stare Factura")
            {
                ApplicationArea = All;
            }
        }
    }

}