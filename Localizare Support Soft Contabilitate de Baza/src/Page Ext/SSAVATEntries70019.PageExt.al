pageextension 70019 "SSA VAT Entries70019" extends "VAT Entries"
{
    // SSA973 SSCAT 06.09.2019 39.Rapoarte legale- Localizare Declaratia 394
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
            field("SSA Tip Partener"; Rec."SSA Tip Partener")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Tip Partener field.';
            }
            field("SSA Realized Amount"; Rec."SSA Realized Amount")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Realized Amount field.';
            }
            field("SSA Realized Base"; Rec."SSA Realized Base")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Realized Base field.';
            }
        }
    }
}
