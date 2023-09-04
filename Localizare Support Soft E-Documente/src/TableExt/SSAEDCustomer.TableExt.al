tableextension 72007 "SSAEDCustomer" extends Customer
{
    fields
    {
        field(72000; "SSAEDSector Bucuresti"; Option)
        {
            Caption = 'Sector Bucuresti';
            DataClassification = CustomerContent;
            Description = 'SSM1997';
            OptionMembers = " ",SECTOR1,SECTOR2,SECTOR3,SECTOR4,SECTOR5,SECTOR6;
        }
        field(72001; "SSAEDPrin EFactura"; Boolean)
        {
            Caption = 'Prin EFactura';
            DataClassification = CustomerContent;
            Description = 'SSM1997';
        }
    }
}

