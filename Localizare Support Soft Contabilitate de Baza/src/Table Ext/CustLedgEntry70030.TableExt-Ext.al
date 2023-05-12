tableextension 70030 "SSA Cust.LedgEntry 70030" extends "Cust. Ledger Entry"
{
    fields
    {
        field(70000; "SSA Stare Factura"; Option)
        {
            Caption = 'Stare Factura';
            DataClassification = ToBeClassified;
            Description = 'SSA973';
            OptionCaption = ' ,0-Factura Emisa,1-Factura Stornata,2-Factura Anulata,3-Autofactura,4-In calidate de beneficiar in numele furnizorului';
            OptionMembers = " ","0-Factura Emisa","1-Factura Stornata","2-Factura Anulata","3-Autofactura","4-In calidate de beneficiar in numele furnizorului";
        }
    }
}