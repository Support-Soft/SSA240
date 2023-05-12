tableextension 71500 "SSA Localization Setup 71500" extends "SSA Localization Setup"
{
    // SSA974 SSCAT 11.10.2019 40.Rapoarte legale-Declaratia 390

    Caption = 'Localization Setup';

    fields
    {
        field(71501; "SSA VIES Declaration Nos."; Code[10])
        {
            Caption = 'VIES Declaration Nos.';
            DataClassification = ToBeClassified;
            Description = 'SSA974';
            TableRelation = "No. Series";
        }
        field(71506; "SSA Municipality No."; Text[30])
        {
            Caption = 'Municipality No.';
            DataClassification = ToBeClassified;
            Description = 'SSA974';
        }
        field(71507; "SSA Street"; Text[50])
        {
            Caption = 'Street';
            DataClassification = ToBeClassified;
            Description = 'SSA974';
        }
        field(71508; "SSA House No."; Text[30])
        {
            Caption = 'House No.';
            DataClassification = ToBeClassified;
            Description = 'SSA974';
        }
        field(71509; "SSA Apartment No."; Text[30])
        {
            Caption = 'Apartment No.';
            DataClassification = ToBeClassified;
            Description = 'SSA974';
        }
        field(71510; "SSA Tax Office Number"; Code[20])
        {
            Caption = 'Tax Office Number';
            DataClassification = ToBeClassified;
            Description = 'SSA974';
        }
        field(71511; "SSA ANAF Logo"; BLOB)
        {
            Caption = 'ANAF Logo';
            DataClassification = ToBeClassified;
            Description = 'SSA974';
            SubType = Bitmap;
        }
        field(71512; "SSA Sector"; Text[30])
        {
            Caption = 'Sector';
            DataClassification = ToBeClassified;
            Description = 'SSA974';
        }
        field(71513; "SSA Building"; Text[30])
        {
            Caption = 'Building';
            DataClassification = ToBeClassified;
            Description = 'SSA974';
        }
        field(71514; "SSA Unit"; Text[30])
        {
            Caption = 'Unit';
            DataClassification = ToBeClassified;
            Description = 'SSA974';
        }
        field(71515; "SSA Floor"; Text[30])
        {
            Caption = 'Floor';
            DataClassification = ToBeClassified;
            Description = 'SSA974';
        }
    }
}

