tableextension 72000 "SSAEDPayment Method" extends "Payment Method"
{
    fields
    {
        field(72000; "SSAEDEFactura ID"; Code[10])
        {
            Caption = 'EFactura ID';
            DataClassification = CustomerContent;
            Description = 'SSM1997';
        }
    }
}

