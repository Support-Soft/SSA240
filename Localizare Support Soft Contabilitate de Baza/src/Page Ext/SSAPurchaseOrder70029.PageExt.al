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
                field("SSA Custom Invoice No."; Rec."SSA Custom Invoice No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Custom Invoice No. field.';
                }
                field("SSA Tip Document D394"; Rec."SSA Tip Document D394")
                {
                    Importance = Promoted;
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Tip Document D394 field.';
                }
                field("SSA Stare Factura"; Rec."SSA Stare Factura")
                {
                    Importance = Promoted;
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Stare Factura field.';
                }
            }
        }
    }
}
