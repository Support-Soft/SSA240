pageextension 70024 "SSA Sales Credit Memo70024" extends "Sales Credit Memo"
{
    // SSA973 SSCAT 06.09.2019 39.Rapoarte legale- Localizare Declaratia 394
    // SSA968 SSCAT 04.10.2019 34.Funct. Operatiuni triunghiulare, delivery, cod registru comertului, numar comanda client
    layout
    {
        addafter("Applies-to ID")
        {
            field("SSA Customer Order No."; "SSA Customer Order No.")
            {
                ApplicationArea = All;
            }
        }
        addafter("EU 3-Party Trade")
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

