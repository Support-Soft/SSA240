table 72002 "SSAEDE-Documents Details"
{
    Caption = 'E-Documents Details';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Log Entry No."; Integer)
        {
            Caption = 'Log Entry No.';
            DataClassification = CustomerContent;
        }
        field(10; "Line No."; Integer)
        {
            Caption = 'Line No.';
            DataClassification = CustomerContent;
        }
        field(15; "Type of Line"; Option)
        {
            Caption = 'Type of Line';
            DataClassification = CustomerContent;
            OptionMembers = " ","Invoice Line","PaymentMeans Line";
        }
        field(20; "Line ID"; Integer)
        {
            Caption = 'Line ID';
            DataClassification = CustomerContent;
        }
        field(30; Note; Text[100])
        {
            Caption = 'Note';
            DataClassification = CustomerContent;
        }
        field(40; "Invoice Quantity"; Decimal)
        {
            Caption = 'Invoice Quantity';
            DataClassification = CustomerContent;
        }
        field(50; "Unit Code"; Code[10])
        {
            Caption = 'Unit Code';
            DataClassification = CustomerContent;
        }
        field(70; "Line Amount"; Decimal)
        {
            Caption = 'Line Amount';
            DataClassification = CustomerContent;
        }
        field(80; "Currency ID"; Code[10])
        {
            Caption = 'Currency ID';
            DataClassification = CustomerContent;
        }
        field(90; "Item Description"; Text[100])
        {
            Caption = 'Item Description';
            DataClassification = CustomerContent;
        }
        field(100; "Item Name"; Text[100])
        {
            Caption = 'Item Name';
            DataClassification = CustomerContent;
        }
        field(110; "ClassifiedTaxCategory ID"; Code[10])
        {
            Caption = 'ClassifiedTaxCategory ID';
            DataClassification = CustomerContent;
        }
        field(120; "ClassifiedTaxCategory Percent"; Decimal)
        {
            Caption = 'ClassifiedTaxCategory Percent';
            DataClassification = CustomerContent;
        }
        field(130; "TaxScheme ID"; Text[30])
        {
            Caption = 'ClassifiedTaxCategory TaxScheme ID';
            DataClassification = CustomerContent;
        }
        field(140; "Price Amount"; Decimal)
        {
            Caption = 'Price Amount';
            DataClassification = CustomerContent;
        }
        field(150; "Price Currency ID"; Code[10])
        {
            Caption = 'Price Currency ID';
            DataClassification = CustomerContent;
        }
        field(160; "NAV Type"; Enum "Purchase Line Type")
        {
            Caption = 'NAV Type';
            DataClassification = CustomerContent;
        }
        field(170; "NAV No."; Code[20])
        {
            Caption = 'NAV No.';
            DataClassification = CustomerContent;
        }

    }

    keys
    {
        key(Key1; "Log Entry No.", "Line No.")
        {
            Clustered = true;
        }
    }
}