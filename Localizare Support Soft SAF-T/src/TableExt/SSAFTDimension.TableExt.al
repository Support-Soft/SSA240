tableextension 71900 "SSAFTDimension" extends Dimension
{
    fields
    {
        field(71900; "SSAFT Export"; boolean)
        {
            Caption = 'SAFT Export';
            DataClassification = CustomerContent;
        }
        field(71910; "SSAFT Analysis Type"; Code[20])
        {
            Caption = 'SAFT Analysis Type';
            DataClassification = CustomerContent;
        }

    }

}