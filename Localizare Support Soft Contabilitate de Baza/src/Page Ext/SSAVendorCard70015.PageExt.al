pageextension 70015 "SSA Vendor Card70015" extends "Vendor Card"
{
    // SSA973 SSCAT 06.09.2019 39.Rapoarte legale- Localizare Declaratia 394
    // SSA947 SSCAT 10.01.2019 13.Funct. “TVA la incasare”
    // SSA968 SSCAT 04.10.2019 34.Funct. Operatiuni triunghiulare, delivery, cod registru comertului, numar comanda client
    // SSA1197 SSCAT 26.10.2019 cont bancar TVA split
    layout
    {
        addafter(General)
        {
            group("SSA Localizare SS")
            {
                Caption = 'Loacalizare SS';
                field("SSA Tip Partener"; Rec."SSA Tip Partener")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Tip Partener field.';
                }
                field("SSA Cod Judet D394"; Rec."SSA Cod Judet D394")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Cod Judet D394 field.';
                }
                field("SSA Organization type"; Rec."SSA Organization type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Organization type field.';
                }
                field("SSA VAT to Pay"; Rec."SSA VAT to Pay")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the VAT to Pay field.';
                }
                field("SSA Commerce Trade No."; Rec."SSA Commerce Trade No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Commerce Trade No. field.';
                }
                field("SSA Not VAT Registered"; Rec."SSA Not VAT Registered")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Not VAT Registered field.';
                }
                field("SSA Split VAT"; Rec."SSA Split VAT")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Split VAT field.';
                }
                field("SSA Split VAT Bank Account No."; Rec."SSA Split VAT Bank Account No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Split VAT Bank Account No. field.';
                }
                field("SSA Preferred Bank Account Code"; Rec."Preferred Bank Account Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the vendor bank account that will be used by default on payment journal lines for export to a payment bank file.';
                }
                field("SSA Last Date Modified VAT"; Rec."SSA Last Date Modified VAT")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Last Date Modified VAT field.';
                }
                field("SSA Persoana Afiliata"; Rec."SSA Persoana Afiliata")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Persoana Afiliata field.';
                }
            }
        }
    }
}
