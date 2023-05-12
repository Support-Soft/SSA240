pageextension 70005 "SSA Posted Sales Invoice 70005" extends "Posted Sales Invoice"
{
    // SSA973 SSCAT 06.09.2019 39.Rapoarte legale- Localizare Declaratia 394
    // SSA968 SSCAT 04.10.2019 34.Funct. Operatiuni triunghiulare, delivery, cod registru comertului, numar comanda client
    layout
    {
        addafter(Closed)
        {
            field("SSA Customer Order No."; "SSA Customer Order No.")
            {
                ApplicationArea = All;
                Editable = false;
            }
        }
        addafter("Payment Method Code")
        {
            field("SSA Tip Document D394"; "SSA Tip Document D394")
            {
                ApplicationArea = All;
                Editable = false;
            }
            field("SSA Stare Factura"; "SSA Stare Factura")
            {
                ApplicationArea = All;
                Editable = false;
            }
        }
    }
    actions
    {
        modify(CancelInvoice)
        {
            ApplicationArea = All;
            Visible = true;
        }
        modify(CorrectInvoice)
        {
            ApplicationArea = All;
            Visible = true;
        }
    }
}

