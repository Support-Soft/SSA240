table 70510 "SSA Payment Address"
{
    Caption = 'Payment Addresses';

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
            TableRelation = IF ("Account Type" = CONST (Customer)) Customer ELSE
            IF ("Account Type" = CONST (Vendor)) Vendor;
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
                IF ("Search Name" = UPPERCASE(xRec.Name)) OR ("Search Name" = '') THEN
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

            trigger OnLookup()
            begin
                //PostCode.LookUpPostCode(City,"Post Code",TRUE);
            end;

            trigger OnValidate()
            begin
                //PostCode.ValidatePostCode(City,"Post Code");
            end;
        }
        field(10; City; Text[30])
        {
            Caption = 'City';

            trigger OnLookup()
            begin
                //PostCode.LookUpPostCode(City,"Post Code",TRUE);
            end;

            trigger OnValidate()
            begin
                //PostCode.ValidatePostCode(City,"Post Code");
            end;
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
                IF "Default value" THEN BEGIN
                    PaymentAddress.SETRANGE("Account Type", "Account Type");
                    PaymentAddress.SETRANGE("Account No.", "Account No.");
                    PaymentAddress.SETFILTER(Code, '<>%1', Code);
                    PaymentAddress.MODIFYALL("Default value", FALSE, FALSE);
                END;
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

    var
        PostCode: Record "Post Code";
}

