pageextension 70023 "SSA Sales Invoice70023" extends "Sales Invoice"
{
    // SSA973 SSCAT 06.09.2019 39.Rapoarte legale- Localizare Declaratia 394
    // SSA968 SSCAT 04.10.2019 34.Funct. Operatiuni triunghiulare, delivery, cod registru comertului, numar comanda client
    layout
    {
        addafter(General)
        {
            group("SSA Localizare SS")
            {
                Caption = 'Localizare SS';

                field("SSA Customer Order No."; "SSA Customer Order No.")
                {
                    ApplicationArea = All;
                }

                field("SSA Tip Document D394"; "SSA Tip Document D394")
                {
                    ApplicationArea = All;
                }
                field("SSA Stare Factura"; "SSA Stare Factura")
                {
                    ApplicationArea = All;
                }

                field("SSA Delivery Contact No."; "SSA Delivery Contact No.")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}