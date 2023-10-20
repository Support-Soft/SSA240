table 70508 "SSA Payment Header Archive"
{
    // SSM729 SSCAT 22.06.2018 Nr.crt.76-Limita valorica pentru instrumente de plata neincasate- fin

    Caption = 'Payment Header Archive';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';
        }
        field(2; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
            TableRelation = Currency;
        }
        field(3; "Currency Factor"; Decimal)
        {
            Caption = 'Currency Factor';
            DecimalPlaces = 0 : 15;
        }
        field(4; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
        }
        field(5; "Document Date"; Date)
        {
            Caption = 'Document Date';
        }
        field(6; "Payment Class"; Text[30])
        {
            Caption = 'Payment Class';
            TableRelation = "SSA Payment Class";
        }
        field(7; "Status No."; Integer)
        {
            Caption = 'Status';
            TableRelation = "SSA Payment Status".Line where("Payment Class" = field("Payment Class"));
        }
        field(8; "Status Name"; Text[50])
        {
            CalcFormula = lookup("SSA Payment Status".Name where("Payment Class" = field("Payment Class"), Line = field("Status No.")));
            Caption = 'Status Name';
            Editable = false;
            FieldClass = FlowField;
        }
        field(9; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Shortcut Dimension 1 Code';
        }
        field(10; "Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
        }
        field(11; "Payment Class Name"; Text[50])
        {
            CalcFormula = lookup("SSA Payment Class".Name where(Code = field("Payment Class")));
            Caption = 'Payment Class Name';
            Editable = false;
            FieldClass = FlowField;
        }
        field(12; "No. Series"; Code[10])
        {
            Caption = 'No. Series';
        }
        field(13; "Source Code"; Code[10])
        {
            Caption = 'Source Code';
            TableRelation = "Source Code";
        }
        field(14; "Account Type"; Option)
        {
            Caption = 'Account Type';
            OptionCaption = 'G/L Account,Customer,Vendor,Bank Account,Fixed Asset';
            OptionMembers = "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset";
        }
        field(15; "Account No."; Code[20])
        {
            Caption = 'Account No.';
            TableRelation = if ("Account Type" = const("G/L Account")) "G/L Account" else
            if ("Account Type" = const(Customer)) Customer else
            if ("Account Type" = const(Vendor)) Vendor else
            if ("Account Type" = const("Bank Account")) "Bank Account" else
            if ("Account Type" = const("Fixed Asset")) "Fixed Asset";
        }
        field(16; "Amount (LCY)"; Decimal)
        {
            CalcFormula = sum("SSA Payment Line Archive"."Amount (LCY)" where("No." = field("No.")));
            Caption = 'Total Amount (LCY)';
            Editable = false;
            FieldClass = FlowField;
        }
        field(17; Amount; Decimal)
        {
            CalcFormula = sum("SSA Payment Line Archive".Amount where("No." = field("No.")));
            Caption = 'Amount';
            Editable = false;
            FieldClass = FlowField;
        }
        field(18; "Bank Branch No."; Text[20])
        {
            Caption = 'Bank Branch No.';
        }
        field(19; "Bank Account No."; Text[30])
        {
            Caption = 'Bank Account No.';
        }
        field(20; "Agency Code"; Text[20])
        {
            Caption = 'Agency Code';
        }
        field(21; "RIB Key"; Integer)
        {
            Caption = 'RIB Key';
        }
        field(22; "RIB Checked"; Boolean)
        {
            Caption = 'RIB Checked';
            Editable = false;
        }
        field(23; "Bank Name"; Text[100])
        {
            Caption = 'Bank Name';
        }
        field(24; "Bank Post Code"; Code[20])
        {
            Caption = 'Bank Post Code';
            TableRelation = "Post Code";
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
        field(25; "Bank City"; Text[30])
        {
            Caption = 'Bank City';
        }
        field(26; "Bank Name 2"; Text[30])
        {
            Caption = 'Bank Name 2';
        }
        field(27; "Bank Address"; Text[30])
        {
            Caption = 'Bank Address';
        }
        field(28; "Bank Address 2"; Text[30])
        {
            Caption = 'Bank Address 2';
        }
        field(29; "Bank Contact"; Text[30])
        {
            Caption = 'Bank Contact';
        }
        field(30; "Bank County"; Text[30])
        {
            Caption = 'County';
        }
        field(31; "Bank Country/Region Code"; Code[10])
        {
            Caption = 'Bank Country/Region Code';
            TableRelation = "Country/Region";
        }
        field(32; "From payment No."; Code[6])
        {
            Caption = 'From payment No.';
            Numeric = true;
        }
        field(50000; "Payment Series"; Code[20])
        {
            Caption = 'Payment Series';
            Description = 'SSM729';
            Editable = false;
        }
        field(50010; "Payment Number"; Code[20])
        {
            Caption = 'Payment Number';
            Description = 'SSM729';
            Editable = false;
        }
        field(50020; "Responsibility Center"; Code[10])
        {
            Caption = 'Responsibility Center';
            Description = 'SSM729';
            TableRelation = "Responsibility Center";

        }
        field(50030; "Dimension Set ID"; Integer)
        {
            Caption = 'Dimension Set ID';
            Description = 'SSM729';
            Editable = false;
            TableRelation = "Dimension Set Entry";
        }
        field(50040; "Status Aplicare Neaplicat"; Boolean)
        {
            CalcFormula = exist("SSA Payment Line" where("No." = field("No."), "Status Aplicare" = filter(Neaplicat | ' ')));
            Description = 'SSM729';
            Editable = false;
            FieldClass = FlowField;
            Caption = 'Status Aplicare Neaplicat';
        }
        field(50050; "Suma Aplicata"; Decimal)
        {
            CalcFormula = sum("SSA Pmt. Tools AppLedg. Entry".Amount where("Payment Document No." = field("No.")));
            Description = 'SSM729';
            Editable = false;
            FieldClass = FlowField;
            Caption = 'Suma Aplicata';
        }
    }

    keys
    {
        key(Key1; "No.")
        {
        }
        key(Key2; "Posting Date")
        {
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "No.", "Payment Class")
        {
        }
    }
}
