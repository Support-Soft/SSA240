tableextension 70060 "SSA PostedAssemblyHeader70060" extends "Posted Assembly Header"
{
    // SSA938 SSCAT 16.06.2019 4.Funct. business posting group obligatoriu la transferuri si asamblari
    fields
    {
        field(70000; "SSA Gen. Bus. Posting Group"; Code[20])
        {
            Caption = 'Gen. Bus. Posting Group';
            DataClassification = ToBeClassified;
            Description = 'SSA938';
            TableRelation = "Gen. Business Posting Group";
        }
    }
}

