pageextension 70007 "SSA PostedPurchaseInvoice70007" extends "Posted Purchase Invoice"
{
    // SSA973 SSCAT 06.09.2019 39.Rapoarte legale- Localizare Declaratia 394
    // SSA946 SSCAT 26.09.2019 12.Funct. functionalitate DVI la achizitii
    layout
    {
        addafter("Vendor Order No.")
        {
            field("SSA Custom Invoice No."; "SSA Custom Invoice No.")
            {
                Editable = false;
                ApplicationArea = All;
            }
        }
        addafter("Creditor No.")
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

