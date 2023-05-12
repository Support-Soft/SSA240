tableextension 70042 "SSA TransferShptHeader70042" extends "Transfer Shipment Header"
{
    // SSA935 SSCAT 15.06.2019 1.Funct. anulare stocuri in rosu
    // SSA938 SSCAT 16.06.2019 4.Funct. business posting group obligatoriu la transferuri si asamblari
    fields
    {
        field(70000; "SSA Correction"; Boolean)
        {
            Caption = 'Correction';
            DataClassification = ToBeClassified;
            Description = 'SSA935';
        }
        field(70001; "SSA Gen. Bus. Posting Group"; Code[20])
        {
            Caption = 'Gen. Bus. Posting Group';
            DataClassification = ToBeClassified;
            Description = 'SSA938';
            TableRelation = "Gen. Business Posting Group";
        }
    }
}

