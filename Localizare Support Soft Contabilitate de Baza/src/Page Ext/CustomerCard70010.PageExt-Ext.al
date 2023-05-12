pageextension 70010 "SSA Customer Card 70010" extends "Customer Card"
{
    // SSA973 SSCAT 06.09.2019 39.Rapoarte legale- Localizare Declaratia 394
    // SSA968 SSCAT 04.10.2019 34.Funct. Operatiuni triunghiulare, delivery, cod registru comertului, numar comanda client
    // SSA1197 SSCAT 23.10.2019 cont bancar TVA split
    layout
    {
        addlast(Invoicing)
        {
            field("SSA Tip Partener"; "SSA Tip Partener")
            {
                ApplicationArea = All;
            }
            field("SSA Cod Judet D394"; "SSA Cod Judet D394")
            {
                ApplicationArea = All;
            }
            field("SSA Organization type"; "SSA Organization type")
            {
                ApplicationArea = All;
            }
            field("SSA Commerce Trade No."; "SSA Commerce Trade No.")
            {
                ApplicationArea = All;
            }
            field("SSA Not VAT Registered"; "SSA Not VAT Registered")
            {
                ApplicationArea = All;
            }
            field("SSA Last Date Modified VAT"; "SSA Last Date Modified VAT")
            {
                ApplicationArea = All;
                Editable = false;
            }
            field("SSA Split VAT Bank Account No."; "SSA Split VAT Bank Account No.")
            {
                ApplicationArea = All;
            }
            field("SSA Persoana Afiliata"; "SSA Persoana Afiliata")
            {
                ApplicationArea = All;
            }
        }
    }
    actions
    {
    }

}

