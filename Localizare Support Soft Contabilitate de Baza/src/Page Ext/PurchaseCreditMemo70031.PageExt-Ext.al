pageextension 70031 "SSA Purchase Credit Memo70031" extends "Purchase Credit Memo"
{
    // SSA973 SSCAT 06.09.2019 39.Rapoarte legale- Localizare Declaratia 394
    // SSA946 SSCAT 26.09.2019 12.Funct. functionalitate DVI la achizitii
    // SSA947 SSCAT 10.01.2019 13.Funct. “TVA la incasare”
    layout
    {
        addafter("Vendor Cr. Memo No.")
        {
            field("SSA Custom Invoice No."; "SSA Custom Invoice No.")
            {
                ApplicationArea = All;
            }
        }
        addafter("Location Code")
        {
            field("SSA Tip Document D394"; "SSA Tip Document D394")
            {
                ApplicationArea = All;
            }
            field("SSA Stare Factura"; "SSA Stare Factura")
            {
                ApplicationArea = All;
            }
            field("SSA VAT to Pay"; "SSA VAT to Pay")
            {
                ApplicationArea = All;
            }
        }
    }
}
