table 70504 "SSA Payment Step Ledger"
{
    Caption = 'Payment Step Ledger';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Payment Class"; Text[30])
        {
            Caption = 'Payment Class';
            TableRelation = "SSA Payment Class";
        }
        field(2; Line; Integer)
        {
            Caption = 'Line';
        }
        field(3; Sign; Option)
        {
            Caption = 'Sign';
            OptionCaption = 'Debit,Credit';
            OptionMembers = Debit,Credit;
        }
        field(4; Description; Text[50])
        {
            Caption = 'Description';
        }
        field(8; "Accounting Type"; Option)
        {
            Caption = 'Accounting Type';
            OptionCaption = 'Payment Line Account,Associated G/L Account,Below Account,G/L Account / Month,G/L Account / Week,Bal. Account Previous Entry,Header Payment Account';
            OptionMembers = "Payment Line Account","Associated G/L Account","Below Account","G/L Account / Month","G/L Account / Week","Bal. Account Previous Entry","Header Payment Account";

            trigger OnValidate()
            begin
                VALIDATE(Root);
            end;
        }
        field(9; "Account Type"; Option)
        {
            Caption = 'Account Type';
            OptionCaption = 'G/L Account,Customer,Vendor,Bank Account,Fixed Asset';
            OptionMembers = "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset";
        }
        field(10; "Account No."; Code[20])
        {
            Caption = 'Account No.';
            TableRelation = if ("Account Type" = const("G/L Account")) "G/L Account" else
            if ("Account Type" = const(Customer)) Customer else
            if ("Account Type" = const(Vendor)) Vendor else
            if ("Account Type" = const("Bank Account")) "Bank Account" else
            if ("Account Type" = const("Fixed Asset")) "Fixed Asset";
            //This property is currently not supported
            //TestTableRelation = true;
            ValidateTableRelation = true;
        }
        field(11; "Customer Posting Group"; Code[10])
        {
            Caption = 'Customer Posting Group';
            TableRelation = "Customer Posting Group";
        }
        field(12; "Vendor Posting Group"; Code[10])
        {
            Caption = 'Vendor Posting Group';
            TableRelation = "Vendor Posting Group";
        }
        field(13; Root; Code[20])
        {
            Caption = 'Root';
        }
        field(14; "Detail Level"; Option)
        {
            Caption = 'Detail Level';
            OptionCaption = 'Line,Account,Due Date';
            OptionMembers = Line,Account,"Due Date";
        }
        field(16; Application; Option)
        {
            Caption = 'Application';
            OptionCaption = 'None,Applied Entry,Entry Previous Step,Memorized Entry';
            OptionMembers = "None","Applied Entry","Entry Previous Step","Memorized Entry";
        }
        field(17; "Memorize Entry"; Boolean)
        {
            Caption = 'Memorize Entry';
        }
        field(18; "Document Type"; Option)
        {
            Caption = 'Document Type';
            OptionCaption = ' ,Payment,Invoice,Credit Memo,Finance Charge Memo,Reminder';
            OptionMembers = " ",Payment,Invoice,"Credit Memo","Finance Charge Memo",Reminder;
        }
        field(19; "Document No."; Option)
        {
            Caption = 'Document No.';
            OptionCaption = 'Header No.,Document ID Line';
            OptionMembers = "Header No.","Document ID Line";
        }
    }

    keys
    {
        key(Key1; "Payment Class", Line, Sign)
        {
        }
    }

    fieldgroups
    {
    }
}
