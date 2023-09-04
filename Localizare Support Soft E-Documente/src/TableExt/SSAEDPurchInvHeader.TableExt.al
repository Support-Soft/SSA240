tableextension 72023 "SSAEDPurch. Inv. Header" extends "Purch. Inv. Header"
{
    fields
    {
        field(72000; "SSAEDID Descarcare EFactura"; Text[30])
        {
            Caption = 'ID Descarcare EFactura';
            DataClassification = CustomerContent;
        }

    }

}