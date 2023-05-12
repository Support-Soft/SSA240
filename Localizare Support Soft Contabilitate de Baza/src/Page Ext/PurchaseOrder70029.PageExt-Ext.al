pageextension 70029 "SSA Purchase Order70029" extends "Purchase Order"
{
    // SSA973 SSCAT 06.09.2019 39.Rapoarte legale- Localizare Declaratia 394
    // SSA946 SSCAT 26.09.2019 12.Funct. functionalitate DVI la achizitii
    layout
    {
        addafter(General)
        {
            group("SSA Localizare")
            {
                Caption = 'Localization SS';
                field("SSA Custom Invoice No."; "SSA Custom Invoice No.")
                {
                    ApplicationArea = All;
                }

                field("SSA Tip Document D394"; "SSA Tip Document D394")
                {
                    Importance = Promoted;
                    ApplicationArea = All;
                }
                field("SSA Stare Factura"; "SSA Stare Factura")
                {
                    Importance = Promoted;
                    ApplicationArea = All;
                }
            }
        }
    }
}

