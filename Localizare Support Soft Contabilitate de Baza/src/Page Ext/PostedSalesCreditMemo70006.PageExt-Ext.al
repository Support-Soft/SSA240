pageextension 70006 "SSA PostedSalesCreditMemo70006" extends "Posted Sales Credit Memo"
{
    // SSA973 SSCAT 06.09.2019 39.Rapoarte legale- Localizare Declaratia 394
    // SSA936 SSCAT 26.09.2019 2.Funct. anulare/stornare automata de documente (vanzare, cumparare)
    // SSA968 SSCAT 04.10.2019 34.Funct. Operatiuni triunghiulare, delivery, cod registru comertului, numar comanda client
    layout
    {
        addafter("No. Printed")
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
        modify(CancelCrMemo)
        {
            ApplicationArea = All;
            Visible = true;
            Enabled = true;
        }
    }
}

