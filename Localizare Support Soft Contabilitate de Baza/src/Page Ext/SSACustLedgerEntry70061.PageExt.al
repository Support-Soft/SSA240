pageextension 70061 "SSA Cust. Ledger Entry 70061" extends "Customer Ledger Entries"
{
    layout
    {
        addlast(Control1)
        {
            field("SSA Stare Factura"; Rec."SSA Stare Factura")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Stare Factura field.';
            }
        }
    }
}