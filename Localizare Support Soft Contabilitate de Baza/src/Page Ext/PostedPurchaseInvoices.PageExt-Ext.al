pageextension 70064 "SSA Posted Purchase Invoices" extends "Posted Purchase Invoices"
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