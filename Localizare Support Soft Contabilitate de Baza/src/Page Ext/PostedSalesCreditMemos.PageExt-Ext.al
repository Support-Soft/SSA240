pageextension 70063 "SSA Posted Sales Credit Memos" extends "Posted Sales Credit Memos"
{
    layout
    {
        addlast(Control1)
        {
            field("SSA Tip Document D394"; Rec."SSA Tip Document D394")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Tip Document D394 field.';
            }
            field("SSA Stare Factura"; Rec."SSA Stare Factura")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Stare Factura field.';
            }
        }
    }
}