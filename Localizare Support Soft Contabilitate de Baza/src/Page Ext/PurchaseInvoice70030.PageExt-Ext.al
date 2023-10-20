pageextension 70030 "SSA Purchase Invoice70030" extends "Purchase Invoice"
{
    // SSA973 SSCAT 06.09.2019 39.Rapoarte legale- Localizare Declaratia 394
    // SSA946 SSCAT 26.09.2019 12.Funct. functionalitate DVI la achizitii
    // SSA947 SSCAT 10.01.2019 13.Funct. “TVA la incasare”
    layout
    {
        addafter("Vendor Invoice No.")
        {
            field("SSA Custom Invoice No."; Rec."SSA Custom Invoice No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Custom Invoice No. field.';
            }
        }
        addafter("On Hold")
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
            field("SSA VAT to Pay"; Rec."SSA VAT to Pay")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the VAT to pay field.';
            }
        }
    }
}
