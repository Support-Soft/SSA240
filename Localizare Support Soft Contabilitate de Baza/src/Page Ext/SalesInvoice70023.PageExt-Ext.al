pageextension 70023 "SSA Sales Invoice70023" extends "Sales Invoice"
{
    // SSA973 SSCAT 06.09.2019 39.Rapoarte legale- Localizare Declaratia 394
    // SSA968 SSCAT 04.10.2019 34.Funct. Operatiuni triunghiulare, delivery, cod registru comertului, numar comanda client
    layout
    {
        addafter(General)
        {
            group("SSA Localizare SS")
            {
                Caption = 'Localizare SS';

                field("SSA Customer Order No."; Rec."SSA Customer Order No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Customer Order No. field.';
                }
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
                field("SSA Delivery Contact No."; Rec."SSA Delivery Contact No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Delivery Contact No. field.';
                }
            }
        }
    }
}