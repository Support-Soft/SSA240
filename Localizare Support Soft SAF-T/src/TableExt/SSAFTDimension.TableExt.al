tableextension 71900 "SSAFTDimension" extends Dimension
{
    fields
    {
        field(71900; "SSAFTSAFT Export"; boolean)
        {
            Caption = 'SAFT Export';
            DataClassification = CustomerContent;
        }
        field(71910; "SSAFTSAFT Analysis Type"; Code[20])
        {
            Caption = 'SAFT Analysis Type';
            DataClassification = CustomerContent;
        }

    }

}