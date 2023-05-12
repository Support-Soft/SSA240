tableextension 70058 "SSA Country/Region70058" extends "Country/Region"
{
    // SSA971 SSCAT 07.10.2019 37.Funct. grupe contabilitate, grupe de tva exigibile si nexigibile pe fz. si client
    fields
    {
        field(70000; "SSA Vendor Neex. VATPstgGroup"; Code[10])
        {
            Caption = 'Vendor Neex. VAT Posting Group';
            DataClassification = ToBeClassified;
            Description = 'SSA971';
            TableRelation = "VAT Business Posting Group";
        }
        field(70001; "SSA Vendor Ex. VATPstgGroup"; Code[10])
        {
            Caption = 'Vendor Ex. VAT Posting Group';
            DataClassification = ToBeClassified;
            Description = 'SSA971';
            TableRelation = "VAT Business Posting Group";
        }
        field(70002; "SSA Cust. Neex. VATPstgGroup"; Code[10])
        {
            Caption = 'Cust. Neex. VAT Posting Group';
            DataClassification = ToBeClassified;
            Description = 'SSA971';
            TableRelation = "VAT Business Posting Group";
        }
        field(70003; "SSA Cust. Ex. VATPstgGroup"; Code[10])
        {
            Caption = 'Cust. Ex. VAT Posting Group';
            DataClassification = ToBeClassified;
            Description = 'SSA971';
            TableRelation = "VAT Business Posting Group";
        }
        field(70004; "SSA Vendor Posting Group"; Code[20])
        {
            Caption = 'Vendor Posting Group';
            DataClassification = ToBeClassified;
            Description = 'SSA971';
            TableRelation = "Vendor Posting Group";
        }
        field(70005; "SSA Customer Posting Group"; Code[20])
        {
            Caption = 'Customer Posting Group';
            DataClassification = ToBeClassified;
            Description = 'SSA971';
            TableRelation = "Customer Posting Group";
        }
        field(70006; "SSA Vendor GenBusPstgGroup"; Code[20])
        {
            Caption = 'Vendor Gen. Bus. Posting Group';
            DataClassification = ToBeClassified;
            Description = 'SSA971';
            TableRelation = "Gen. Business Posting Group";
        }
        field(70007; "SSA Cust. GenBusPostingGroup"; Code[20])
        {
            Caption = 'Vendor Gen. Bus. Posting Group';
            DataClassification = ToBeClassified;
            Description = 'SSA971';
            TableRelation = "Gen. Business Posting Group";
        }
    }
}

