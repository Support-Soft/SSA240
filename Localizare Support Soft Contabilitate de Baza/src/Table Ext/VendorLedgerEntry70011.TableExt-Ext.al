tableextension 70011 "SSA Vendor Ledger Entry70011" extends "Vendor Ledger Entry"
{
    // SSA946 SSCAT 26.09.2019 12.Funct. functionalitate DVI la achizitii
    fields
    {
        field(70000; "SSA Custom Invoice No."; Code[20])
        {
            Caption = 'Custom Invoice No.';
            DataClassification = ToBeClassified;
            Description = 'SSA946';
        }
        field(70001; "SSA Stare Factura"; Option)
        {
            Caption = 'Stare Factura';
            DataClassification = ToBeClassified;
            Description = 'SSA1505';
            OptionCaption = ' ,0-Factura Emisa,1-Factura Stornata,2-Factura Anulata,3-Autofactura,4-In calidate de beneficiar in numele furnizorului';
            OptionMembers = " ","0-Factura Emisa","1-Factura Stornata","2-Factura Anulata","3-Autofactura","4-In calidate de beneficiar in numele furnizorului";
        }
        field(70002; "SSA Tip Document D394"; Option)
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

