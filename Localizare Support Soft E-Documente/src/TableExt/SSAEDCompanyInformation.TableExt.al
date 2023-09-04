tableextension 72008 "SSAEDCompany Information" extends "Company Information"
{
    fields
    {
        field(72000; SSAEDSector; Option)
        {
            Caption = 'Sector';
            DataClassification = CustomerContent;
            Description = 'SSM1997';
            OptionMembers = " ",SECTOR1,SECTOR2,SECTOR3,SECTOR4,SECTOR5,SECTOR6;
        }
    }
}