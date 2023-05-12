pageextension 70008 "SSA PostedPurchCreditMemo70008" extends "Posted Purchase Credit Memo"
{
    // SSA973 SSCAT 06.09.2019 39.Rapoarte legale- Localizare Declaratia 394
    // SSA936 SSCAT 26.09.2019 2.Funct. anulare/stornare automata de documente (vanzare, cumparare)
    // SSA946 SSCAT 26.09.2019 12.Funct. functionalitate DVI la achizitii
    layout
    {
        addafter("Vendor Cr. Memo No.")
        {
            field("SSA Custom Invoice No."; "SSA Custom Invoice No.")
            {
                ApplicationArea = All;
                Editable = false;
            }
        }
        addafter("Applies-to Doc. No.")
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

