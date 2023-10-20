pageextension 70006 "SSA PostedSalesCreditMemo70006" extends "Posted Sales Credit Memo"
{
    // SSA973 SSCAT 06.09.2019 39.Rapoarte legale- Localizare Declaratia 394
    // SSA936 SSCAT 26.09.2019 2.Funct. anulare/stornare automata de documente (vanzare, cumparare)
    // SSA968 SSCAT 04.10.2019 34.Funct. Operatiuni triunghiulare, delivery, cod registru comertului, numar comanda client
    layout
    {
        addafter("No. Printed")
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
        modify(CancelCrMemo)
        {
            ApplicationArea = All;
            Visible = true;
            Enabled = true;
        }
    }
}
