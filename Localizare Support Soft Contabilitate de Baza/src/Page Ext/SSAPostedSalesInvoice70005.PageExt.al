pageextension 70005 "SSA Posted Sales Invoice 70005" extends "Posted Sales Invoice"
{
    // SSA973 SSCAT 06.09.2019 39.Rapoarte legale- Localizare Declaratia 394
    // SSA968 SSCAT 04.10.2019 34.Funct. Operatiuni triunghiulare, delivery, cod registru comertului, numar comanda client
    layout
    {
        addafter(Closed)
        {
            field("SSA Customer Order No."; Rec."SSA Customer Order No.")
            {
                ApplicationArea = All;
                Editable = false;
                ToolTip = 'Specifies the value of the Customer Order No. field.';
            }
        }
        addafter("Payment Method Code")
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
