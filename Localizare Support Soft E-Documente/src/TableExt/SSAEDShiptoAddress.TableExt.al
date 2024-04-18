tableextension 72009 "SSAEDShip-to Address" extends "Ship-to Address"
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
    }
}

