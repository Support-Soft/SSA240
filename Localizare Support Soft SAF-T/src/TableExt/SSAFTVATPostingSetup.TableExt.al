tableextension 71905 "SSAFTVAT Posting Setup" extends "VAT Posting Setup"
{
    fields
    {
        field(71900; "SSAFT Tax Code"; Code[10])
        {
            Caption = 'SAFT Tax Code';
            DataClassification = CustomerContent;
        }
        field(71901; "SSAFT Deductibilitate %"; Decimal)
        {
            Caption = 'SAFTDeductibilitate %';
            DataClassification = CustomerContent;
            MinValue = 0;
            MaxValue = 100;
        }

    }

}