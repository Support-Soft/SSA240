tableextension 70072 "SSA Vendor Payment Buffer70072" extends "Vendor Payment Buffer"
{
    // SSA969 SSCAT 07.10.2019 35.Funct. Posting group
    fields
    {
        field(70000; "SSA Vendor Posting Group"; Code[20])
        {
            Caption = 'Vendor Posting Group';
            DataClassification = CustomerContent;
            Description = 'SSA969';
            TableRelation = "Vendor Posting Group";
        }
    }
}
