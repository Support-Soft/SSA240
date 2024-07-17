tableextension 71904 "SSAFTFA Setup" extends "FA Setup"
{
    fields
    {
        field(71900; "SSAFT Posting Group Filter"; Text[250])
        {
            Caption = 'SAFT FA Posting Group Filter', Comment = 'SAFT Filtru Grupa inreg. MF';
            DataClassification = CustomerContent;
            TableRelation = "FA Posting Group";
            ValidateTableRelation = false;
        }
    }

}