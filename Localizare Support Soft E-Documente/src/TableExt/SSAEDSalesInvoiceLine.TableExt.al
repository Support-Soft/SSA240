tableextension 72004 "SSAEDSales Invoice Line" extends "Sales Invoice Line"
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

