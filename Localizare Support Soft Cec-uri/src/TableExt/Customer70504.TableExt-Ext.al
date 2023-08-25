tableextension 70504 "SSA Customer 70504" extends Customer //18
{
    fields
    {
        field(70500; "SSA Default Bank Account Code"; Code[20])
        {
            Caption = 'Default Bank Account No.';
            TableRelation = "Customer Bank Account".Code where("Customer No." = field("No."));
        }
    }
}