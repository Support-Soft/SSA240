tableextension 72018 "SSAEDSales Line Archive" extends "Sales Line Archive"
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

