pageextension 70024 "SSA Sales Credit Memo70024" extends "Sales Credit Memo"
{
    // SSA973 SSCAT 06.09.2019 39.Rapoarte legale- Localizare Declaratia 394
    // SSA968 SSCAT 04.10.2019 34.Funct. Operatiuni triunghiulare, delivery, cod registru comertului, numar comanda client
    layout
    {
        addafter("Applies-to ID")
        {
            field("SSA Customer Order No."; Rec."SSA Customer Order No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Customer Order No. field.';
            }
        }
        addafter("EU 3-Party Trade")
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
