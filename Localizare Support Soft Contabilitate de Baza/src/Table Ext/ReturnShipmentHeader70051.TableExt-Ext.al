tableextension 70051 "SSA ReturnShipmentHeader70051" extends "Return Shipment Header"
{
    // SSA973 SSCAT 06.09.2019 39.Rapoarte legale- Localizare Declaratia 394
    // SSA946 SSCAT 26.09.2019 12.Funct. functionalitate DVI la achizitii
    // SSA968 SSCAT 04.10.2019 34.Funct. Operatiuni triunghiulare, delivery, cod registru comertului, numar comanda client
    fields
    {
        field(70000; "SSA Tip Document D394"; Option)
        {
            Caption = 'Tip Document D394';
            DataClassification = CustomerContent;
            Description = 'SSA973';
            OptionCaption = ' ,Factura Fiscala,Bon Fiscal,Factura Simplificata,Borderou,File Carnet,Contract,Alte Documente';
            OptionMembers = " ","Factura Fiscala","Bon Fiscal","Factura Simplificata",Borderou,"File Carnet",Contract,"Alte Documente";
        }
        field(70001; "SSA Stare Factura"; Option)
        {
            Caption = 'Stare Factura';
            DataClassification = CustomerContent;
            Description = 'SSA973';
            OptionCaption = ' ,0-Factura Emisa,1-Factura Stornata,2-Factura Anulata,3-Autofactura,4-In calidate de beneficiar in numele furnizorului';
            OptionMembers = " ","0-Factura Emisa","1-Factura Stornata","2-Factura Anulata","3-Autofactura","4-In calidate de beneficiar in numele furnizorului";
        }
        field(70002; "SSA Custom Invoice No."; Code[20])
        {
            Caption = 'Custom Invoice No.';
            DataClassification = CustomerContent;
            Description = 'SSA946';
        }
        field(70004; "SSA Commerce Trade No."; Code[20])
        {
            Caption = 'Commerce Trade No.';
            DataClassification = CustomerContent;
            Description = 'SSA968';
        }
    }
}
