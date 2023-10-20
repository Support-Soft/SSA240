tableextension 70026 "SSA Payment Buffer70026" extends "Payment Buffer"
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
