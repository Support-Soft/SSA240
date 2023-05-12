table 70509 "SSA Payment Line Archive"
{
    // SSM729 SSCAT 22.06.2018 Nr.crt.76-Limita valorica pentru instrumente de plata neincasate- fin

    Caption = 'Payment Line Archive';

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';
            TableRelation = "SSA Payment Header Archive";
        }
        field(2; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(3; Amount; Decimal)
        {
            Caption = 'Amount';
        }
        field(4; "Account Type"; Option)
        {
            Caption = 'Account Type';
            OptionCaption = 'G/L Account,Customer,Vendor,Bank Account,Fixed Asset';
            OptionMembers = "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset";
        }
        field(5; "Account No."; Code[20])
        {
            Caption = 'Account No.';
            TableRelation = IF ("Account Type" = CONST("G/L Account")) "G/L Account" ELSE
            IF ("Account Type" = CONST(Customer)) Customer ELSE
            IF ("Account Type" = CONST(Vendor)) Vendor ELSE
            IF ("Account Type" = CONST("Bank Account")) "Bank Account" ELSE
            IF ("Account Type" = CONST("Fixed Asset")) "Fixed Asset";
        }
        field(6; "Posting Group"; Code[10])
        {
            Caption = 'Posting Group';
            Editable = true;
            TableRelation = IF ("Account Type" = CONST(Customer)) "Customer Posting Group" ELSE
            IF ("Account Type" = CONST(Vendor)) "Vendor Posting Group" ELSE
            IF ("Account Type" = CONST("Fixed Asset")) "FA Posting Group";
        }
        field(7; "Copied To No."; Code[10])
        {
            Caption = 'Copied To No.';
        }
        field(8; "Copied To Line"; Integer)
        {
            Caption = 'Copied To Line';
        }
        field(9; "Due Date"; Date)
        {
            Caption = 'Due Date';
        }
        field(10; "Acc. Type last entry Debit"; Option)
        {
            Caption = 'Acc. Type last entry Debit';
            Editable = false;
            OptionCaption = 'G/L Account,Customer,Vendor,Bank Account,Fixed Asset';
            OptionMembers = "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset";
        }
        field(11; "Acc. No. Last entry Debit"; Code[20])
        {
            Caption = 'Acc. No. Last entry Debit';
            Editable = false;
            TableRelation = IF ("Acc. Type last entry Debit" = CONST("G/L Account")) "G/L Account" ELSE
            IF ("Acc. Type last entry Debit" = CONST(Customer)) Customer ELSE
            IF ("Acc. Type last entry Debit" = CONST(Vendor)) Vendor ELSE
            IF ("Acc. Type last entry Debit" = CONST("Bank Account")) "Bank Account" ELSE
            IF ("Acc. Type last entry Debit" = CONST("Fixed Asset")) "Fixed Asset";
        }
        field(12; "Acc. Type last entry Credit"; Option)
        {
            Caption = 'Acc. Type last entry Credit';
            Editable = false;
            OptionCaption = 'G/L Account,Customer,Vendor,Bank Account,Fixed Asset';
            OptionMembers = "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset";
        }
        field(13; "Acc. No. Last entry Credit"; Code[20])
        {
            Caption = 'Acc. No. Last entry Credit';
            Editable = false;
            TableRelation = IF ("Acc. Type last entry Credit" = CONST("G/L Account")) "G/L Account" ELSE
            IF ("Acc. Type last entry Credit" = CONST(Customer)) Customer ELSE
            IF ("Acc. Type last entry Credit" = CONST(Vendor)) Vendor ELSE
            IF ("Acc. Type last entry Credit" = CONST("Bank Account")) "Bank Account" ELSE
            IF ("Acc. Type last entry Credit" = CONST("Fixed Asset")) "Fixed Asset";
        }
        field(14; "P. Group Last Entry Debit"; Code[10])
        {
            Caption = 'P. Group Last Entry Debit';
            Editable = false;
        }
        field(15; "P. Group Last Entry Credit"; Code[10])
        {
            Caption = 'P. Group Last Entry Credit';
            Editable = false;
        }
        field(16; "Payment Class"; Text[30])
        {
            Caption = 'Payment Class';
            TableRelation = "SSA Payment Class";
        }
        field(17; "Status No."; Integer)
        {
            Caption = 'Status';
            Editable = false;
            TableRelation = "SSA Payment Status".Line WHERE("Payment Class" = FIELD("Payment Class"));
        }
        field(18; "Status Name"; Text[50])
        {
            CalcFormula = Lookup("SSA Payment Status".Name WHERE("Payment Class" = FIELD("Payment Class"), Line = FIELD("Status No.")));
            Caption = 'Status Name';
            Editable = false;
            FieldClass = FlowField;
        }
        field(19; IsCopy; Boolean)
        {
            Caption = 'IsCopy';
        }
        field(20; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
            TableRelation = Currency;
        }
        field(21; "Entry No. Debit"; Integer)
        {
            Caption = 'Entry No. Debit';
            Editable = false;
        }
        field(22; "Entry No. Credit"; Integer)
        {
            Caption = 'Entry No. Credit';
            Editable = false;
        }
        field(23; "Entry No. Debit Memo"; Integer)
        {
            Caption = 'Entry No. Debit Memo';
            Editable = false;
        }
        field(24; "Entry No. Credit Memo"; Integer)
        {
            Caption = 'Entry No. Credit Memo';
            Editable = false;
        }
        field(25; "Bank Account"; Code[10])
        {
            Caption = 'Bank Account';
            TableRelation = IF ("Account Type" = CONST(Customer)) "Customer Bank Account".Code WHERE("Customer No." = FIELD("Account No.")) ELSE
            IF ("Account Type" = CONST(Vendor)) "Vendor Bank Account".Code WHERE("Vendor No." = FIELD("Account No."));
        }
        field(26; "Bank Branch No."; Text[20])
        {
            Caption = 'Bank Branch No.';
        }
        field(27; "Bank Account No."; Text[30])
        {
            Caption = 'Bank Account No.';
        }
        field(28; "Agency Code"; Text[20])
        {
            Caption = 'Agency Code';
        }
        field(29; "RIB Key"; Integer)
        {
            Caption = 'RIB Key';
        }
        field(30; "RIB Checked"; Boolean)
        {
            Caption = 'RIB Checked';
            Editable = false;
        }
        field(31; "Acceptation Code"; Option)
        {
            Caption = 'Acceptation Code';
            InitValue = No;
            OptionCaption = 'LCR,No,BOR,LCR NA';
            OptionMembers = Yes,No,BOR,"LCR NA";
        }
        field(32; "Document ID"; Code[20])
        {
            Caption = 'Document ID';
        }
        field(33; "Debit Amount"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            BlankZero = true;
            Caption = 'Debit Amount';
        }
        field(34; "Credit Amount"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            BlankZero = true;
            Caption = 'Credit Amount';
        }
        field(35; "Applies-to ID"; Code[20])
        {
            Caption = 'Applies-to ID';
        }
        field(36; "Currency Factor"; Decimal)
        {
            Caption = 'Currency Factor';
            DecimalPlaces = 0 : 15;
        }
        field(37; Posted; Boolean)
        {
            Caption = 'Posted';
        }
        field(38; Correction; Boolean)
        {
            Caption = 'Correction';
        }
        field(39; "Bank Account Name"; Text[30])
        {
            Caption = 'Bank Account Name';
        }
        field(40; "Payment Address Code"; Code[10])
        {
            Caption = 'Payment Address Code';
            TableRelation = "SSA Payment Address".Code WHERE("Account Type" = FIELD("Account Type"), "Account No." = FIELD("Account No."));
        }
        field(41; "Applies-to Doc. Type"; Option)
        {
            Caption = 'Applies-to Doc. Type';
            Editable = false;
            OptionCaption = ' ,Payment,Invoice,Credit Memo,Finance Charge Memo,Reminder';
            OptionMembers = " ",Payment,Invoice,"Credit Memo","Finance Charge Memo",Reminder;
        }
        field(42; "Applies-to Doc. No."; Code[20])
        {
            Caption = 'Applies-to Doc. No.';
            Editable = false;
        }
        field(43; "External Document No."; Code[20])
        {
            Caption = 'External Document No.';
        }
        field(44; "Amount (LCY)"; Decimal)
        {
            Caption = 'Amount (LCY)';
        }
        field(45; "Drawee Reference"; Text[10])
        {
            Caption = 'Drawee Reference';
        }
        field(46; "Bank City"; Text[30])
        {
            Caption = 'Bank Account City';
        }
        field(48; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
        }
        field(50; "Payment in progress"; Boolean)
        {
            Caption = 'Payment in progress';
            Editable = false;
        }
        field(50000; "Dimension Set ID"; Integer)
        {
            Caption = 'Dimension Set ID';
            Description = 'SSM729';
            Editable = false;
            TableRelation = "Dimension Set Entry";
        }
        field(50010; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Shortcut Dimension 1 Code';
            Description = 'SSM729';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        }
        field(50020; "Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            Description = 'SSM729';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
        }
        field(50030; "Salesperson/Purchaser Code"; Code[10])
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
        field(50040; "Status Aplicare"; Option)
        {
            Description = 'SSM729';
            OptionMembers = " ",Aplicat,Neaplicat;
        }
        field(50050; "Suma Aplicata"; Decimal)
        {
            CalcFormula = Sum("SSA Pmt. Tools AppLedg. Entry".Amount WHERE("Payment Document No." = FIELD("No."), "Payment Document Line No." = FIELD("Line No.")));
            Description = 'SSM729';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50070; "Payment Finished"; Boolean)
        {
            Caption = 'Payment Finished';
        }
        field(50080; "Canceled/Refused"; Boolean)
        {
            Caption = 'Canceled/Refused';
        }
    }

    keys
    {
        key(Key1; "No.", "Line No.")
        {
            SumIndexFields = Amount, "Amount (LCY)";
        }
        key(Key2; "Posting Date", "Document ID")
        {
        }
        key(Key3; "Account Type", "Account No.", "Copied To Line", "Payment in progress")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    var
        Statement: Record "SSA Payment Header";
        "Code": Code[20];
    begin
    end;

    procedure ShowDimensions()
    begin
        /*PostedDocDim.SETRANGE("Table ID",DATABASE::"Payment Line Archive");
        PostedDocDim.SETRANGE("Document No.","No.");
        PostedDocDim.SETRANGE("Line No.","Line No.");
        PostedDocDimensions.SETTABLEVIEW(PostedDocDim);
        PostedDocDimensions.RUNMODAL;  */

    end;
}

