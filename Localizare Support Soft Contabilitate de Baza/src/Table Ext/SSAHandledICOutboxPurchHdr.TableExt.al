tableextension 70063 "Handled IC Outbox Purch. Hdr" extends "Handled IC Outbox Purch. Hdr"
{
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
    }
}