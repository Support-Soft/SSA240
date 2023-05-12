pageextension 70019 "SSA VAT Entries70019" extends "VAT Entries"
{
    // SSA973 SSCAT 06.09.2019 39.Rapoarte legale- Localizare Declaratia 394
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
            field("SSA Tip Partener"; "SSA Tip Partener")
            {
                ApplicationArea = All;
            }
            field("SSA Realized Amount"; "SSA Realized Amount")
            {
                ApplicationArea = All;
            }
            field("SSA Realized Base"; "SSA Realized Base")
            {
                ApplicationArea = All;
            }
        }
    }
}

