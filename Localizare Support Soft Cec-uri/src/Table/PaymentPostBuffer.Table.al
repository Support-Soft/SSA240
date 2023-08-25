table 70505 "SSA Payment Post. Buffer"
{
    // SSM729 SSCAT 22.06.2018 Nr.crt.76-Limita valorica pentru instrumente de plata neincasate- fin

    Caption = 'Payment Post. Buffer';

    fields
    {
        field(1; "Account Type"; Option)
        {
            Caption = 'Type';
            OptionCaption = 'G/L Account,Customer,Vendor,Bank Account,Fixed Asset';
            OptionMembers = "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset";
        }
        field(2; "Account No."; Code[20])
        {
            Caption = 'G/L Account';
            TableRelation = if ("Account Type" = const("G/L Account")) "G/L Account" else
            if ("Account Type" = const(Customer)) Customer else
            if ("Account Type" = const(Vendor)) Vendor else
            if ("Account Type" = const("Bank Account")) "Bank Account" else
            if ("Account Type" = const("Fixed Asset")) "Fixed Asset";
        }
        field(4; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
        }
        field(5; "Global Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,1,2';
            Caption = 'Global Dimension 2 Code';
        }
        field(6; "Job No."; Code[20])
        {
            Caption = 'Job No.';
        }
        field(7; Amount; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Amount';

            trigger OnValidate()
            begin
                if Amount < 0 then
                    Sens := Sens::Negative
                else
                    Sens := Sens::Positive;
            end;
        }
        field(8; "VAT Amount"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'VAT Amount';
        }
        field(9; "Line Discount Amount"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Line Discount Amount';
        }
        field(10; "Gen. Bus. Posting Group"; Code[10])
        {
            Caption = 'Gen. Bus. Posting Group';
            TableRelation = "Gen. Business Posting Group";
        }
        field(11; "Gen. Prod. Posting Group"; Code[10])
        {
            Caption = 'Gen. Prod. Posting Group';
            TableRelation = "Gen. Product Posting Group";
        }
        field(12; "VAT Calculation Type"; Option)
        {
            Caption = 'VAT Calculation Type';
            OptionCaption = 'Normal VAT,Reverse Charge VAT,Full VAT,Sales Tax';
            OptionMembers = "Normal VAT","Reverse Charge VAT","Full VAT","Sales Tax";
        }
        field(13; "Inv. Discount Amount"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Inv. Discount Amount';
        }
        field(14; "VAT Base Amount"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'VAT Base Amount';
        }
        field(15; "Line Discount Account"; Code[20])
        {
            Caption = 'Line Discount Account';
            TableRelation = "G/L Account";
        }
        field(16; "Inv. Discount Account"; Code[20])
        {
            Caption = 'Inv. Discount Account';
            TableRelation = "G/L Account";
        }
        field(17; "System-Created Entry"; Boolean)
        {
            Caption = 'System-Created Entry';
        }
        field(18; "Tax Area Code"; Code[20])
        {
            Caption = 'Tax Area Code';
            TableRelation = "Tax Area";
        }
        field(19; "Tax Liable"; Boolean)
        {
            Caption = 'Tax Liable';
        }
        field(20; "Tax Group Code"; Code[10])
        {
            Caption = 'Tax Group Code';
            TableRelation = "Tax Group";
        }
        field(21; Quantity; Decimal)
        {
            Caption = 'Quantity';
            DecimalPlaces = 1 : 5;
        }
        field(22; "Use Tax"; Boolean)
        {
            Caption = 'Use Tax';
        }
        field(23; "VAT Bus. Posting Group"; Code[10])
        {
            Caption = 'VAT Bus. Posting Group';
            TableRelation = "VAT Business Posting Group";
        }
        field(24; "VAT Prod. Posting Group"; Code[10])
        {
            Caption = 'VAT Prod. Posting Group';
            TableRelation = "VAT Product Posting Group";
        }
        field(25; "Amount (ACY)"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Amount (ACY)';
        }
        field(26; "VAT Amount (ACY)"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'VAT Amount (ACY)';
        }
        field(27; "Line Discount Amt. (ACY)"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Line Discount Amt. (ACY)';
        }
        field(28; "Inv. Discount Amt. (ACY)"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Inv. Discount Amt. (ACY)';
        }
        field(29; "VAT Base Amount (ACY)"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'VAT Base Amount (ACY)';
        }
        field(30; "Dimension Entry No."; Integer)
        {
            Caption = 'Dimension Entry No.';
        }
        field(31; "VAT Difference"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'VAT Difference';
        }
        field(32; "VAT %"; Decimal)
        {
            Caption = 'VAT %';
            DecimalPlaces = 1 : 1;
        }
        field(33; "GL Entry No."; Integer)
        {
            Caption = 'GL Entry No.';
        }
        field(34; "Applies-to Doc. Type"; Option)
        {
            Caption = 'Applies-to Doc. Type';
            OptionCaption = ' ,Payment,Invoice,Credit Memo,Finance Charge Memo,Reminder';
            OptionMembers = " ",Payment,Invoice,"Credit Memo","Finance Charge Memo",Reminder;
        }
        field(35; "Applies-to Doc. No."; Code[20])
        {
            Caption = 'Applies-to Doc. No.';
        }
        field(36; "Amount (LCY)"; Decimal)
        {
            Caption = 'Amount (LCY)';
        }
        field(37; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
        }
        field(38; "Currency Factor"; Decimal)
        {
            Caption = 'Currency Factor';
        }
        field(63; "External Document No."; Code[20])
        {
            Caption = 'External Document No.';
        }
        field(78; "Source Type"; Option)
        {
            Caption = 'Source Type';
            OptionCaption = ' ,Customer,Vendor,Bank Account,Fixed Asset';
            OptionMembers = " ",Customer,Vendor,"Bank Account","Fixed Asset";
        }
        field(79; "Source No."; Code[20])
        {
            Caption = 'Source No.';
            TableRelation = if ("Source Type" = const(Customer)) Customer else
            if ("Source Type" = const(Vendor)) Vendor else
            if ("Source Type" = const("Bank Account")) "Bank Account" else
            if ("Source Type" = const("Fixed Asset")) "Fixed Asset";
        }
        field(90; "Auxiliary Entry No."; Integer)
        {
            Caption = 'Auxiliary Entry No.';
        }
        field(200; Sens; Option)
        {
            Caption = 'Sens';
            OptionCaption = 'Negative,Positive';
            OptionMembers = Negative,Positive;
        }
        field(5600; "FA Posting Date"; Date)
        {
            Caption = 'FA Posting Date';
        }
        field(5601; "FA Posting Type"; Option)
        {
            Caption = 'FA Posting Type';
            OptionCaption = ' ,Acquisition Cost,Maintenance';
            OptionMembers = " ","Acquisition Cost",Maintenance;
        }
        field(5602; "Depreciation Book Code"; Code[10])
        {
            Caption = 'Depreciation Book Code';
            TableRelation = "Depreciation Book";
        }
        field(5603; "Salvage Value"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Salvage Value';
        }
        field(5605; "Depr. until FA Posting Date"; Boolean)
        {
            Caption = 'Depr. until FA Posting Date';
        }
        field(5606; "Depr. Acquisition Cost"; Boolean)
        {
            Caption = 'Depr. Acquisition Cost';
        }
        field(5609; "Maintenance Code"; Code[10])
        {
            Caption = 'Maintenance Code';
            TableRelation = Maintenance;
        }
        field(5610; "Insurance No."; Code[20])
        {
            Caption = 'Insurance No.';
            TableRelation = Insurance;
        }
        field(5611; "Budgeted FA No."; Code[20])
        {
            Caption = 'Budgeted FA No.';
            TableRelation = "Fixed Asset";
        }
        field(5612; "Duplicate in Depreciation Book"; Code[10])
        {
            Caption = 'Duplicate in Depreciation Book';
            TableRelation = "Depreciation Book";
        }
        field(5613; "Use Duplication List"; Boolean)
        {
            Caption = 'Use Duplication List';
        }
        field(5614; "Fixed Asset Line No."; Integer)
        {
            Caption = 'Fixed Asset Line No.';
        }
        field(5615; "FA Discount Account"; Code[20])
        {
            Caption = 'FA Discount Account';
            TableRelation = "G/L Account";
        }
        field(5616; "Payment Line No."; Integer)
        {
            Caption = 'Payment Line No.';
        }
        field(5617; "Posting group"; Code[20])
        {
            Caption = 'Posting group';
        }
        field(5618; "Applies-to ID"; Code[20])
        {
            Caption = 'Applies-to ID';
        }
        field(5619; "Due Date"; Date)
        {
            Caption = 'Due Date';
        }
        field(5620; "Document Type"; Option)
        {
            Caption = 'Document Type';
            OptionCaption = ' ,Payment,Invoice,Credit Memo,Finance Charge Memo,Reminder';
            OptionMembers = " ",Payment,Invoice,"Credit Memo","Finance Charge Memo",Reminder;
        }
        field(5621; "Document No."; Code[20])
        {
            Caption = 'Document No.';
        }
        field(5622; Description; Text[100])
        {
            Caption = 'Description';
        }
        field(5623; Correction; Boolean)
        {
            Caption = 'Correction';
        }
        field(5624; "Header Document No."; Code[20])
        {
            Caption = 'Header Document No.';
        }
        field(5625; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(50000; "Salesperson/Purchaser Code"; Code[10])
        {
            Caption = 'Salesperson/Purchaser Code';
            Description = 'SSM729';
            TableRelation = "Salesperson/Purchaser";

            trigger OnValidate()
            var
                ApprovalEntry: Record "Approval Entry";
            begin
            end;
        }
        field(50010; "Dimension Set ID"; Integer)
        {
            Caption = 'Dimension Set ID';
            Description = 'SSM729';
            Editable = false;
            TableRelation = "Dimension Set Entry";
        }
        field(50020; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Shortcut Dimension 1 Code';
            Description = 'SSM729';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1));
        }
        field(50030; "Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            Description = 'SSM729';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2));
        }
    }

    keys
    {
        key(Key1; "Account Type", "Account No.", "Gen. Bus. Posting Group", "Gen. Prod. Posting Group", "VAT Bus. Posting Group", "VAT Prod. Posting Group", "Use Tax", "Job No.", "Fixed Asset Line No.", "Payment Line No.", "Posting group", "Applies-to ID", "Due Date", Sens, "Currency Code", "Auxiliary Entry No.")
        {
        }
        key(Key2; "Document No.")
        {
        }
    }

    fieldgroups
    {
    }
}

