tableextension 70029 "SSA DetailedVendLedgEntry70029" extends "Detailed Vendor Ledg. Entry"
{
    // SSA960 SSCAT 17.06.2019 26.Funct. reevaluare solduri valutare
    fields
    {
        field(70000; "SSA Vendor Posting Group"; Code[20])
        {
            Caption = 'Vendor Posting Group';
            DataClassification = ToBeClassified;
            Description = 'SSA960';
            TableRelation = "Vendor Posting Group";
        }
    }
}

