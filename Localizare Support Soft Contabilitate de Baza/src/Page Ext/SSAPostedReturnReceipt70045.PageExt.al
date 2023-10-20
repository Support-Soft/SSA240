pageextension 70045 "SSA Posted Return Receipt70045" extends "Posted Return Receipt"
{
    // SSA973 SSCAT 06.09.2019 39.Rapoarte legale- Localizare Declaratia 394
    layout
    {
        addafter("Shortcut Dimension 2 Code")
        {
            field("SSA Tip Document D394"; Rec."SSA Tip Document D394")
            {
                ApplicationArea = All;
                Editable = false;
                ToolTip = 'Specifies the value of the Tip Document D394 field.';
            }
            field("SSA Stare Factura"; Rec."SSA Stare Factura")
            {
                ApplicationArea = All;
                Editable = false;
                ToolTip = 'Specifies the value of the Stare Factura field.';
            }
        }
    }
}
