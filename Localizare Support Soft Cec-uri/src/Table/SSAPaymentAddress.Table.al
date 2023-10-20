table 70510 "SSA Payment Address"
{
    Caption = 'Payment Addresses';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Account Type"; Option)
        {
            Caption = 'Account type';
            OptionCaption = 'G/L Account,Customer,Vendor,Bank Account,Fixed Asset';
            OptionMembers = "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset";
        }
        field(2; "Account No."; Code[20])
        {
            Caption = 'Account No.';
            TableRelation = if ("Account Type" = const(Customer)) Customer else
            if ("Account Type" = const(Vendor)) Vendor;
        }
        field(3; "Code"; Code[10])
        {
            Caption = 'Code';
        }
        field(4; Name; Text[30])
        {
            Caption = 'Name';

            trigger OnValidate()
            begin
                if ("Search Name" = UPPERCASE(xRec.Name)) or ("Search Name" = '') then
                    "Search Name" := Name;
            end;
        }
        field(5; "Search Name"; Code[30])
        {
            Caption = 'Search Name';
        }
        field(6; "Name 2"; Text[30])
        {
            Caption = 'Name 2';
        }
        field(7; Address; Text[30])
        {
            Caption = 'Address';
        }
        field(8; "Address 2"; Text[30])
        {
            Caption = 'Address 2';
        }
        field(9; "Post Code"; Code[20])
        {
            Caption = 'Post Code';
            TableRelation = "Post Code";
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;

        }
        field(10; City; Text[30])
        {
            Caption = 'City';

        }
        field(11; Contact; Text[30])
        {
            Caption = 'Contact';
        }
        field(12; "Country/Region Code"; Code[10])
        {
            Caption = 'Country/Region Code';
            TableRelation = "Country/Region";
        }
        field(13; County; Text[30])
        {
            Caption = 'County';
        }
        field(20; "Default value"; Boolean)
        {
            Caption = 'Default value';

            trigger OnValidate()
            var
                PaymentAddress: Record "SSA Payment Address";
            begin
                if "Default value" then begin
                    PaymentAddress.SETRANGE("Account Type", "Account Type");
                    PaymentAddress.SETRANGE("Account No.", "Account No.");
                    PaymentAddress.SETFILTER(Code, '<>%1', Code);
                    PaymentAddress.MODIFYALL("Default value", false, false);
                end;
            end;
        }
    }

    keys
    {
        key(Key1; "Account Type", "Account No.", "Code")
        {
        }
    }

    fieldgroups
    {
    }
}
