tableextension 70027 "SSA DetailedCustLedgEntry70027" extends "Detailed Cust. Ledg. Entry"
{
    // SSA960 SSCAT 17.06.2019 26.Funct. reevaluare solduri valutare
    fields
    {
        field(70000; "SSA Customer Posting Group"; Code[20])
        {
            Caption = 'Customer Posting Group';
            DataClassification = ToBeClassified;
            Description = 'SSA960';
            TableRelation = "Customer Posting Group";
        }
    }
}

