tableextension 70003 "SSA Sales Cr.Memo Header70003" extends "Sales Cr.Memo Header"
{
    // SSA936 SSCAT 16.06.2019 2.Funct. anulare/stornare automata de documente (vanzare, cumparare)
    // SSA973 SSCAT 06.09.2019 39.Rapoarte legale- Localizare Declaratia 394
    // SSA968 SSCAT 04.10.2019 34.Funct. Operatiuni triunghiulare, delivery, cod registru comertului, numar comanda client
    fields
    {
        field(70000; "SSA Tip Document D394"; Option)
        {
            Caption = 'Tip Document D394';
            DataClassification = ToBeClassified;
            Description = 'SSA973';
            OptionCaption = ' ,Factura Fiscala,Bon Fiscal,Factura Simplificata,Borderou,File Carnet,Contract,Alte Documente';
            OptionMembers = " ","Factura Fiscala","Bon Fiscal","Factura Simplificata",Borderou,"File Carnet",Contract,"Alte Documente";
        }
        field(70001; "SSA Stare Factura"; Option)
        {
            Caption = 'Stare Factura';
            DataClassification = ToBeClassified;
            Description = 'SSA973';
            OptionCaption = ' ,0-Factura Emisa,1-Factura Stornata,2-Factura Anulata,3-Autofactura,4-In calidate de beneficiar in numele furnizorului';
            OptionMembers = " ","0-Factura Emisa","1-Factura Stornata","2-Factura Anulata","3-Autofactura","4-In calidate de beneficiar in numele furnizorului";
        }
        field(70002; "SSA Commerce Trade No."; Code[20])
        {
            Caption = 'Commerce Trade No.';
            DataClassification = ToBeClassified;
            Description = 'SSA968';
        }
        field(70003; "SSA Customer Order No."; Code[35])
        {
            Caption = 'Customer Order No.';
            DataClassification = ToBeClassified;
            Description = 'SSA968';
        }
        field(70004; "SSA Delivery Contact No."; Code[20])
        {
            Caption = 'Delivery Contact No.';
            DataClassification = ToBeClassified;
            Description = 'SSA968';
            TableRelation = Contact;
        }
        field(70100; "SSA Cancelling Type"; Option)
        {
            Caption = 'Cancelling Type';
            DataClassification = ToBeClassified;
            Description = 'SSA936';
            OptionCaption = ' ,Cancel,Correct';
            OptionMembers = " ",Cancel,Correct;
        }
    }
}

