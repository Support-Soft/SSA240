pageextension 70010 "SSA Customer Card 70010" extends "Customer Card"
{
    // SSA973 SSCAT 06.09.2019 39.Rapoarte legale- Localizare Declaratia 394
    // SSA968 SSCAT 04.10.2019 34.Funct. Operatiuni triunghiulare, delivery, cod registru comertului, numar comanda client
    // SSA1197 SSCAT 23.10.2019 cont bancar TVA split
    layout
    {
        addlast(Invoicing)
        {
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
            field("SSA Last Date Modified VAT"; Rec."SSA Last Date Modified VAT")
            {
                ApplicationArea = All;
                Editable = false;
                ToolTip = 'Specifies the value of the Last Date Modified VAT field.';
            }
            field("SSA Split VAT Bank Account No."; Rec."SSA Split VAT Bank Account No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Split VAT Bank Account No. field.';
            }
            field("SSA Persoana Afiliata"; Rec."SSA Persoana Afiliata")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Persoana Afiliata field.';
            }
        }
    }
}
