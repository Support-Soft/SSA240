tableextension 70055 "SSA Gen. Journal Line70055" extends "Gen. Journal Line"
{
    // SSA973 SSCAT 06.09.2019 39.Rapoarte legale- Localizare Declaratia 394
    // SSA953 SSCAT 25.09.2019 19.Funct. intrastat
    // SSA946 SSCAT 26.09.2019 12.Funct. functionalitate DVI la achizitii
    // SSA1199 SSCAT 03.11.2019 1199: Jurnal de casa si de banca
    // SSA1196 SSCAT 04.11.2019 Leasing
    fields
    {
        field(70000; "SSA Tip Document D394"; Option)
        {
            Caption = 'Tip Document D394';
            DataClassification = ToBeClassified;
            Description = 'SSA973';
            OptionCaption = ' ,Factura Fiscala,Bon Fiscal,Factura Simplificata,Borderou,File Carnet,Contract,Alte Documente';
            OptionMembers = " ","Factura Fiscala","Bon Fiscal","Factura Simplificata",Borderou,"File Carnet",Contract,"Alte Documente";
        }
        field(70001; "SSA Stare Factura"; Option)
        {
            Caption = 'Stare Factura';
            DataClassification = ToBeClassified;
            Description = 'SSA973';
            OptionCaption = ' ,0-Factura Emisa,1-Factura Stornata,2-Factura Anulata,3-Autofactura,4-In calidate de beneficiar in numele furnizorului';
            OptionMembers = " ","0-Factura Emisa","1-Factura Stornata","2-Factura Anulata","3-Autofactura","4-In calidate de beneficiar in numele furnizorului";
        }
        field(70002; "SSA Tip Partener"; Option)
        {
            Caption = 'Tip Partener';
            DataClassification = ToBeClassified;
            Description = 'SSA973';
            OptionCaption = ' ,1-CUI Valid din RO si din afara inreg. in scopuri de TVA in RO,2-CNP PFA din RO sau CUI neinregistrat in scopuri de TVA,3-Fara CUI valid din UE fara RO,4-Fara CUI valid din afara UE fara RO';
            OptionMembers = " ","1-CUI Valid din RO si din afara inreg. in scopuri de TVA in RO","2-CNP PFA din RO sau CUI neinregistrat in scopuri de TVA","3-Fara CUI valid din UE fara RO","4-Fara CUI valid din afara UE fara RO";
        }
        field(70003; "SSA Transaction Type"; Code[10])
        {
            Caption = 'Transaction Type';
            DataClassification = ToBeClassified;
            Description = 'SSM953';
            TableRelation = "Transaction Type";
        }
        field(70004; "SSA Transport Method"; Code[10])
        {
            Caption = 'Transport Method';
            DataClassification = ToBeClassified;
            Description = 'SSM953';
            TableRelation = "Transport Method";
        }
        field(70005; "SSA Entry/Exit Point"; Code[10])
        {
            Caption = 'Entry/Exit Point';
            DataClassification = ToBeClassified;
            Description = 'SSM953';
            TableRelation = "Entry/Exit Point";
        }
        field(70006; "SSA Area"; Code[10])
        {
            Caption = 'Area';
            DataClassification = ToBeClassified;
            Description = 'SSM953';
            TableRelation = Area;
        }
        field(70007; "SSA Transaction Specification"; Code[10])
        {
            Caption = 'Transaction Specification';
            DataClassification = ToBeClassified;
            Description = 'SSM953';
            TableRelation = "Transaction Specification";
        }
        field(70008; "SSA Shpt. Method Code"; Code[10])
        {
            Caption = 'Shpt. Method Code';
            DataClassification = ToBeClassified;
            Description = 'SSM953';
            TableRelation = "Shipment Method";
        }
        field(70009; "SSA Custom Invoice No."; Code[20])
        {
            Caption = 'Custom Invoice No.';
            DataClassification = ToBeClassified;
            Description = 'SSA946';
        }
        field(70010; "SSA Date Filter"; Date)
        {
            Caption = 'Date Filter';
            Description = 'SSA1199';
            FieldClass = FlowFilter;
        }
        field(70011; "SSA Date Filter -1D"; Date)
        {
            Caption = 'Date Filter -1D';
            Description = 'SSA1199';
            FieldClass = FlowFilter;
        }
        field(70012; "SSA Bal Acc Balance (LCY)"; Decimal)
        {
            CalcFormula = sum("Bank Account Ledger Entry"."Amount (LCY)" where("Bank Account No." = field("Bal. Account No."),
                                                                                "Posting Date" = field("SSA Date Filter")));
            Caption = 'Bal Acc Balance (LCY)';
            Description = 'SSA1199';
            Editable = false;
            FieldClass = FlowField;
        }
        field(70013; "SSA Bal Acc Balance -1D (LCY)"; Decimal)
        {
            CalcFormula = sum("Bank Account Ledger Entry"."Amount (LCY)" where("Bank Account No." = field("Bal. Account No."),
                                                                                "Posting Date" = field("SSA Date Filter -1D")));
            Caption = 'Bal Acc Balance -1D (LCY)';
            Description = 'SSA1199';
            Editable = false;
            FieldClass = FlowField;
        }
        field(70014; "SSA Total Amount (LCY)"; Decimal)
        {
            CalcFormula = sum("Gen. Journal Line"."Amount (LCY)" where("Bal. Account No." = field("Bal. Account No."),
                                                                        "Posting Date" = field("SSA Date Filter"),
                                                                        "Journal Template Name" = field("Journal Template Name"),
                                                                        "Journal Batch Name" = field("Journal Batch Name")));
            Caption = 'Total Amount (LCY)';
            Description = 'SSA1199';
            Editable = false;
            FieldClass = FlowField;
        }
        field(70016; "SSA Debit Amount (LCY)"; Decimal)
        {
            CalcFormula = sum("Bank Account Ledger Entry"."Debit Amount (LCY)" where("Bank Account No." = field("Bal. Account No."),
                                                                                "Posting Date" = field("SSA Date Filter")));
            Caption = 'Debit Amount (LCY)';
            Description = 'SSA1199';
            Editable = false;
            FieldClass = FlowField;
        }
        field(70017; "SSA Debit Amount -1D (LCY)"; Decimal)
        {
            CalcFormula = sum("Bank Account Ledger Entry"."Debit Amount (LCY)" where("Bank Account No." = field("Bal. Account No."),
                                                                                "Posting Date" = field("SSA Date Filter -1D")));
            Caption = 'Debit Amount -1D (LCY)';
            Description = 'SSA1199';
            Editable = false;
            FieldClass = FlowField;
        }
        field(70018; "SSA Credit Amount (LCY)"; Decimal)
        {
            CalcFormula = sum("Bank Account Ledger Entry"."Credit Amount (LCY)" where("Bank Account No." = field("Bal. Account No."),
                                                                                 "Posting Date" = field("SSA Date Filter")));
            Caption = 'Credit Amount (LCY)';
            Description = 'SSA1199';
            Editable = false;
            FieldClass = FlowField;
        }
        field(70019; "SSA Credit Amount -1D (LCY)"; Decimal)
        {
            CalcFormula = sum("Bank Account Ledger Entry"."Credit Amount (LCY)" where("Bank Account No." = field("Bal. Account No."),
                                                                                 "Posting Date" = field("SSA Date Filter -1D")));
            Caption = 'Credit Amount -1D (LCY)';
            Description = 'SSA1199';
            Editable = false;
            FieldClass = FlowField;
        }
        field(70020; "SSA Posting Group"; Code[10])
        {
            Caption = 'Custom Posting Group';
            TableRelation = if ("Account Type" = const(Customer)) "Customer Posting Group" else
            if ("Account Type" = const(Vendor)) "Vendor Posting Group" else
            if ("Account Type" = const("Fixed Asset")) "FA Posting Group";
            trigger OnValidate()
            begin
                Validate("Posting Group", "SSA Posting Group");
            end;
        }
        field(70021; "SSA Total Amount"; Decimal)
        {
            CalcFormula = sum("Gen. Journal Line"."Amount" where("Bal. Account No." = field("Bal. Account No."),
                                                                        "Posting Date" = field("SSA Date Filter"),
                                                                        "Journal Template Name" = field("Journal Template Name"),
                                                                        "Journal Batch Name" = field("Journal Batch Name")));
            Caption = 'Total Amount';
            Editable = false;
            FieldClass = FlowField;
        }
        field(70023; "SSA Debit Amount"; Decimal)
        {
            CalcFormula = sum("Bank Account Ledger Entry"."Debit Amount" where("Bank Account No." = field("Bal. Account No."),
                                                                                "Posting Date" = field("SSA Date Filter")));
            Caption = 'Debit Amount';
            Editable = false;
            FieldClass = FlowField;
        }
        field(70024; "SSA Debit Amount -1D"; Decimal)
        {
            CalcFormula = sum("Bank Account Ledger Entry"."Debit Amount" where("Bank Account No." = field("Bal. Account No."),
                                                                                "Posting Date" = field("SSA Date Filter -1D")));
            Caption = 'Debit Amount -1D';
            Description = 'SSA1199';
            Editable = false;
            FieldClass = FlowField;
        }
        field(70025; "SSA Credit Amount"; Decimal)
        {
            CalcFormula = sum("Bank Account Ledger Entry"."Credit Amount" where("Bank Account No." = field("Bal. Account No."),
                                                                                 "Posting Date" = field("SSA Date Filter")));
            Caption = 'Credit Amount';
            Editable = false;
            FieldClass = FlowField;
        }
        field(70026; "SSA Credit Amount -1D"; Decimal)
        {
            CalcFormula = sum("Bank Account Ledger Entry"."Credit Amount" where("Bank Account No." = field("Bal. Account No."),
                                                                                 "Posting Date" = field("SSA Date Filter -1D")));
            Caption = 'Credit Amount -1D';
            Editable = false;
            FieldClass = FlowField;
        }
        field(70027; "SSA Distribute Non-Ded VAT"; Boolean)
        {
            Caption = 'Distribute Non-Deductible VAT';
            DataClassification = ToBeClassified;
            Description = 'SSA948';

            trigger OnValidate()
            begin
                TestField("Account Type", "Account Type"::"G/L Account");//SSA948
            end;
        }
        field(70028; "SSA Non-Ded VAT Expense Acc 1"; Code[20])
        {
            Caption = 'Non-Ded VAT Expense Account 1';
            DataClassification = ToBeClassified;
            Description = 'SSA948';
            TableRelation = "G/L Account";
        }
        field(70029; "SSA Non-Ded VAT Expense Acc 2"; Code[20])
        {
            Caption = 'Non-Ded VAT Expense Account 2';
            DataClassification = ToBeClassified;
            Description = 'SSA948';
            TableRelation = "G/L Account";
        }
        field(70030; "SSA Leasing"; Boolean)
        {
            Caption = 'Leasing';
            DataClassification = CustomerContent;
        }
        field(70031; "SSA VAT Bus. Posting Group"; Code[20])
        {
            Caption = 'VAT Bus. Posting Group Leasing';
            TableRelation = "VAT Business Posting Group";
            trigger OnValidate()
            begin
                "VAT Bus. Posting Group" := "SSA VAT Bus. Posting Group";
            end;
        }
        field(70032; "SSA VAT Prod. Posting Group"; Code[20])
        {
            Caption = 'VAT Prod. Posting Group Leasing';
            TableRelation = "VAT Product Posting Group";
            trigger OnValidate()
            begin
                "VAT Prod. Posting Group" := "SSA VAT Prod. Posting Group";
            end;
        }

    }
}