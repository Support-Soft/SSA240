tableextension 70505 "SSA Vendor 70505" extends Vendor //23
{
    fields
    {
        field(70500; "SSA Default Bank Account Code"; Code[20])
        {
            Caption = 'Default Bank Account No.';
            TableRelation = "Vendor Bank Account".Code where("Vendor No." = field("No."));
        }
    }
}