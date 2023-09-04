tableextension 72020 "SSAEDPurch. Rcpt. Header" extends "Purch. Rcpt. Header"
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