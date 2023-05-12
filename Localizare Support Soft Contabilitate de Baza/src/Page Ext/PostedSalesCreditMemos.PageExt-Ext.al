pageextension 70063 "SSA Posted Sales Credit Memos" extends "Posted Sales Credit Memos"
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