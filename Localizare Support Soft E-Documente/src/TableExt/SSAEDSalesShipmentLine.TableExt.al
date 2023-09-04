tableextension 72002 "SSAEDSales Shipment Line" extends "Sales Shipment Line"
{
    fields
    {
        field(72000; "SSAEDProdus cu Risc"; Boolean)
        {
            Caption = 'Produs cu Risc';
            DataClassification = CustomerContent;
            Description = 'SSM1997';
        }
    }
}

