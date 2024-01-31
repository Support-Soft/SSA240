tableextension 71100 "SSA Localization Setup 71100" extends "SSA Localization Setup"
{
    fields
    {
        field(71100; "SSA VAT API URL"; Text[100])
        {
            Caption = 'VAT API URL';
            DataClassification = CustomerContent;
            Description = 'SSA966';
        }
        field(71101; "SSA VAT API URL ANAF"; Text[100])
        {
            Caption = 'VAT API URL ANAF';
            DataClassification = CustomerContent;
            Description = 'SSA966';
        }
        field(71102; "SSA Enable ANAF VAT"; Boolean)
        {
            Caption = 'Enable ANAF VAT';
            DataClassification = CustomerContent;
            Description = 'SSA966';
        }
        field(71103; "SSA VAT User Name"; Text[80])
        {
            Caption = 'VAT User Name';
            DataClassification = CustomerContent;
            Description = 'SSA966';
        }
        field(71104; "SSA VAT Password"; Text[30])
        {
            Caption = 'VAT Password';
            DataClassification = CustomerContent;
            Description = 'SSA966';
            ExtendedDatatype = Masked;
        }
        field(71105; "SSA Import BNR at LogIn"; Boolean)
        {
            Caption = 'Import BNR at LogIn';
            DataClassification = CustomerContent;
        }
    }
}