tableextension 70030 "SSA Cust.LedgEntry 70030" extends "Cust. Ledger Entry"
{
    fields
    {
        field(70000; "SSA Stare Factura"; Option)
        {
            Caption = 'Stare Factura';
            DataClassification = CustomerContent;
            Description = 'SSA973';
            OptionCaption = ' ,0-Factura Emisa,1-Factura Stornata,2-Factura Anulata,3-Autofactura,4-In calidate de beneficiar in numele furnizorului';
            OptionMembers = " ","0-Factura Emisa","1-Factura Stornata","2-Factura Anulata","3-Autofactura","4-In calidate de beneficiar in numele furnizorului";
        }
        field(70001; "SSA Tip Document D394"; Option)
        {
            Caption = 'Tip Document D394';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup("VAT Entry"."SSA Tip Document D394" where("Document No." = field("Document No."), "Transaction No." = field("Transaction No.")));
            OptionCaption = ' ,Factura Fiscala,Bon Fiscal,Factura Simplificata,Borderou,File Carnet,Contract,Alte Documente';
            OptionMembers = " ","Factura Fiscala","Bon Fiscal","Factura Simplificata",Borderou,"File Carnet",Contract,"Alte Documente";
        }
    }
}