table 70507 "SSA Payment Line"
{
    // SSM729 SSCAT 21.06.2018 Nr.crt.76-Limita valorica pentru instrumente de plata neincasate- fin
    // SSM845 SSCAT 25.07.2018 meeting financiar 200718

    Caption = 'Payment Line';

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';
            TableRelation = "SSA Payment Header";
        }
        field(2; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(3; Amount; Decimal)
        {
            Caption = 'Amount';

            trigger OnValidate()
            var
                CurrExchRate: Record "Currency Exchange Rate";
            begin
                //SSM729>>
                CALCFIELDS("Suma Aplicata");
                if "Suma Aplicata" <> 0 then
                    ERROR('Acest IP trebuie dezaplicat');
                //SM729<<
                if ((Amount > 0) and (not Correction)) or
                   ((Amount < 0) and Correction) then begin
                    "Debit Amount" := Amount;
                    "Credit Amount" := 0
                end else begin
                    "Debit Amount" := 0;
                    "Credit Amount" := -Amount;
                end;
                if "Currency Code" = '' then
                    "Amount (LCY)" := Amount
                else
                    "Amount (LCY)" := ROUND(
                      CurrExchRate.ExchangeAmtFCYToLCY(
                        "Posting Date", "Currency Code",
                        Amount, "Currency Factor"));
                //IF (Rec.Amount <> xRec.Amount) THEN
                //  PaymentToleranceMgt.PmtTolPaymentLine(Rec);

                //SSM729>>
                VALIDATE("Status Aplicare", "Status Aplicare"::Neaplicat);
                //SSM729<<
            end;
        }
        field(4; "Account Type"; Option)
        {
            Caption = 'Account Type';
            OptionCaption = 'G/L Account,Customer,Vendor,Bank Account,Fixed Asset';
            OptionMembers = "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset";

            trigger OnValidate()
            begin
                UpdateEntry;
            end;
        }
        field(5; "Account No."; Code[20])
        {
            Caption = 'Account No.';
            TableRelation = if ("Account Type" = const("G/L Account")) "G/L Account" else
            if ("Account Type" = const(Customer)) Customer else
            if ("Account Type" = const(Vendor)) Vendor else
            if ("Account Type" = const("Bank Account")) "Bank Account" else
            if ("Account Type" = const("Fixed Asset")) "Fixed Asset";

            trigger OnValidate()
            begin
                UpdateEntry;
                CALCFIELDS("Customer Name");
            end;
        }
        field(6; "Posting Group"; Code[10])
        {
            Caption = 'Posting Group';
            Editable = false;
            TableRelation = if ("Account Type" = const(Customer)) "Customer Posting Group" else
            if ("Account Type" = const(Vendor)) "Vendor Posting Group" else
            if ("Account Type" = const("Fixed Asset")) "FA Posting Group";
        }
        field(7; "Copied To No."; Code[20])
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
            TableRelation = if ("Acc. Type last entry Debit" = const("G/L Account")) "G/L Account" else
            if ("Acc. Type last entry Debit" = const(Customer)) Customer else
            if ("Acc. Type last entry Debit" = const(Vendor)) Vendor else
            if ("Acc. Type last entry Debit" = const("Bank Account")) "Bank Account" else
            if ("Acc. Type last entry Debit" = const("Fixed Asset")) "Fixed Asset";
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
            TableRelation = if ("Acc. Type last entry Credit" = const("G/L Account")) "G/L Account" else
            if ("Acc. Type last entry Credit" = const(Customer)) Customer else
            if ("Acc. Type last entry Credit" = const(Vendor)) Vendor else
            if ("Acc. Type last entry Credit" = const("Bank Account")) "Bank Account" else
            if ("Acc. Type last entry Credit" = const("Fixed Asset")) "Fixed Asset";
        }
        field(14; "P. Group Last Entry Debit"; Code[20])
        {
            Caption = 'P. Group Last Entry Debit';
            Editable = false;
        }
        field(15; "P. Group Last Entry Credit"; Code[20])
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
            TableRelation = "SSA Payment Status".Line where("Payment Class" = field("Payment Class"));

            trigger OnValidate()
            var
                PaymentStatus: Record "SSA Payment Status";
            begin
                PaymentStatus.GET("Payment Class", "Status No.");
                "Payment in progress" := PaymentStatus."Payment in progress";
                "Payment Finished" := PaymentStatus."Payment Finished";
                if PaymentStatus."Payment Finished" then
                    "Payment Date" := "Posting Date";
                "Payment Finished" := PaymentStatus."Canceled/Refused";
                "Canceled/Refused" := PaymentStatus."Canceled/Refused";
            end;
        }
        field(18; "Status Name"; Text[50])
        {
            CalcFormula = lookup("SSA Payment Status".Name where("Payment Class" = field("Payment Class"), Line = field("Status No.")));
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
            TableRelation = if ("Account Type" = const(Customer)) "Customer Bank Account".Code where("Customer No." = field("Account No.")) else
            if ("Account Type" = const(Vendor)) "Vendor Bank Account".Code where("Vendor No." = field("Account No."));

            trigger OnValidate()
            begin
                if "Bank Account" <> '' then begin
                    if "Account Type" = "Account Type"::Customer then begin
                        CustomerBank.GET("Account No.", "Bank Account");
                        "Bank Branch No." := CustomerBank."Bank Branch No.";
                        "Bank Account No." := CustomerBank."Bank Account No.";
                        "Bank Account No." := CustomerBank.IBAN;
                        "Agency Code" := CustomerBank."SSA Agency";
                        "Bank Account Name" := CustomerBank.Name;
                        "RIB Key" := CustomerBank."SSA RIB Key";
                        "RIB Checked" := Check("Bank Branch No.", "Agency Code", "Bank Account No.", "RIB Key");
                        "Bank City" := CustomerBank.City;
                    end else
                        if "Account Type" = "Account Type"::Vendor then begin
                            VendorBank.GET("Account No.", "Bank Account");
                            "Bank Branch No." := VendorBank."Bank Branch No.";
                            "Bank Account No." := VendorBank."Bank Account No.";
                            "Bank Account No." := VendorBank.IBAN;
                            "Agency Code" := VendorBank."SSA Agency";
                            "Bank Account Name" := VendorBank.Name;
                            "RIB Key" := VendorBank."SSA RIB Key";
                            "RIB Checked" := Check("Bank Branch No.", "Agency Code", "Bank Account No.", "RIB Key");
                            "Bank City" := VendorBank.City;
                        end;
                end else
                    InitBankAccount;
            end;
        }
        field(26; "Bank Branch No."; Text[20])
        {
            Caption = 'Bank Branch No.';

            trigger OnValidate()
            begin
                "RIB Checked" := Check("Bank Branch No.", "Agency Code", "Bank Account No.", "RIB Key");
            end;
        }
        field(27; "Bank Account No."; Text[30])
        {
            Caption = 'Bank Account No.';

            trigger OnValidate()
            begin
                "RIB Checked" := Check("Bank Branch No.", "Agency Code", "Bank Account No.", "RIB Key");

                CompanyInfo.CheckIBAN("Bank Account No.");
            end;
        }
        field(28; "Agency Code"; Text[20])
        {
            Caption = 'Agency Code';

            trigger OnValidate()
            begin
                "RIB Checked" := Check("Bank Branch No.", "Agency Code", "Bank Account No.", "RIB Key");
            end;
        }
        field(29; "RIB Key"; Integer)
        {
            Caption = 'RIB Key';

            trigger OnValidate()
            begin
                "RIB Checked" := Check("Bank Branch No.", "Agency Code", "Bank Account No.", "RIB Key");
            end;
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

            trigger OnValidate()
            begin
                GetCurrency;
                "Debit Amount" := ROUND("Debit Amount", Currency."Amount Rounding Precision");
                Correction := "Debit Amount" < 0;
                VALIDATE(Amount, "Debit Amount");
            end;
        }
        field(34; "Credit Amount"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            BlankZero = true;
            Caption = 'Credit Amount';

            trigger OnValidate()
            begin
                GetCurrency;
                "Credit Amount" := ROUND("Credit Amount", Currency."Amount Rounding Precision");
                Correction := "Credit Amount" < 0;
                VALIDATE(Amount, -"Credit Amount");
            end;
        }
        field(35; "Applies-to ID"; Code[50])
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

            trigger OnValidate()
            begin
                VALIDATE(Amount);
            end;
        }
        field(39; "Bank Account Name"; Text[30])
        {
            Caption = 'Bank Account Name';
        }
        field(40; "Payment Address Code"; Code[10])
        {
            Caption = 'Payment Address Code';
            TableRelation = "SSA Payment Address".Code where("Account Type" = field("Account Type"), "Account No." = field("Account No."));
        }
        field(41; "Applies-to Doc. Type"; Option)
        {
            Caption = 'Applies-to Doc. Type';
            OptionCaption = ' ,Payment,Invoice,Credit Memo,Finance Charge Memo,Reminder';
            OptionMembers = " ",Payment,Invoice,"Credit Memo","Finance Charge Memo",Reminder;

            trigger OnValidate()
            begin
                if "Applies-to Doc. Type" <> xRec."Applies-to Doc. Type" then
                    VALIDATE("Applies-to Doc. No.", '');
            end;
        }
        field(42; "Applies-to Doc. No."; Code[20])
        {
            Caption = 'Applies-to Doc. No.';

            trigger OnLookup()
            begin
                xRec.Amount := Amount;
                xRec."Currency Code" := "Currency Code";
                xRec."Posting Date" := "Posting Date";

                //GetAccTypeAndNo(Rec,AccType,AccNo);
                CLEAR(CustLedgEntry);
                CLEAR(VendLedgEntry);

                case "Account Type" of
                    "Account Type"::Customer:
                        LookUpAppliesToDocCust("Account No.");
                    "Account Type"::Vendor:
                        LookUpAppliesToDocVend("Account No.");
                end;
                //SetJournalLineFieldsFromApplication;

                //IF xRec.Amount <> 0 THEN
                // IF NOT PaymentToleranceMgt.PmtTolGenJnl(Rec) THEN
                //  EXIT;
            end;

            trigger OnValidate()
            var
                CLE: Record "Cust. Ledger Entry";
            begin
                //SSM729>>
                CALCFIELDS("Suma Aplicata");
                if "Suma Aplicata" <> 0 then
                    ERROR('Acest IP trebuie dezaplicat');
                if "Applies-to Doc. No." <> '' then begin
                    PaymentLine.RESET;
                    PaymentLine.SETRANGE("No.", "No.");
                    PaymentLine.SETFILTER("Line No.", '<>%1', "Line No.");
                    PaymentLine.SETRANGE("Applies-to Doc. No.", "Applies-to Doc. No.");
                    if not PaymentLine.ISEMPTY then
                        ERROR('Exista documentul aplicat pe alta linie');

                    CLE.SETCURRENTKEY("Document No.");
                    CLE.SETRANGE("Document No.", "Applies-to Doc. No.");
                    CLE.SETRANGE("Document Type", "Applies-to Doc. Type");
                    CLE.SETRANGE("Customer No.", "Account No.");
                    CLE.SETRANGE(Open, true);
                    if CLE.FINDFIRST then begin
                        CLE.CALCFIELDS("Remaining Amount", "SSA Applied Amount CEC/BO");
                        if ((CLE."Remaining Amount" - CLE."SSA Applied Amount CEC/BO") < (-Amount)) then
                            ERROR('Suma de aplicat este mai mare decat suma neacoperita');
                    end;
                end;
                //SSM729<<
                if "Applies-to Doc. No." <> xRec."Applies-to Doc. No." then
                    ClearCustVendApplnEntry;

                //IF ("Applies-to Doc. No." = '') AND (xRec."Applies-to Doc. No." <> '') THEN BEGIN
                // PaymentToleranceMgt.DelPmtTolApllnDocNo(Rec,xRec."Applies-to Doc. No.");

                // TempGenJnlLine := Rec;

                if "Account Type" = "Account Type"::Customer then begin
                    CustLedgEntry.SETCURRENTKEY("Document No.");
                    CustLedgEntry.SETRANGE("Document No.", xRec."Applies-to Doc. No.");
                    // IF NOT (xRec."Applies-to Doc. Type" = "Document Type"::" ") THEN
                    CustLedgEntry.SETRANGE("Document Type", "Applies-to Doc. Type");
                    CustLedgEntry.SETRANGE("Customer No.", "Account No.");
                    CustLedgEntry.SETRANGE(Open, true);
                    if CustLedgEntry.FINDFIRST then begin
                        //SSM729>>
                        CustLedgEntry.CALCFIELDS("Remaining Amount", "SSA Applied Amount CEC/BO");
                        if ((CustLedgEntry."Remaining Amount" - CustLedgEntry."SSA Applied Amount CEC/BO") < (-Amount)) and
                          ("Applies-to Doc. No." <> '')
                        then
                            ERROR('Suma de aplicat este mai mare decat suma neacoperita');
                        //SSM729<<
                        if CustLedgEntry."Amount to Apply" <> 0 then begin
                            CustLedgEntry."Amount to Apply" := 0;
                            CODEUNIT.RUN(CODEUNIT::"Cust. Entry-Edit", CustLedgEntry);
                        end;
                    end;
                end else
                    if "Account Type" = "Account Type"::Vendor then begin
                        VendLedgEntry.SETCURRENTKEY("Document No.");
                        VendLedgEntry.SETRANGE("Document No.", xRec."Applies-to Doc. No.");
                        //IF NOT (xRec."Applies-to Doc. Type" = "Document Type"::" ") THEN
                        VendLedgEntry.SETRANGE("Document Type", Rec."Applies-to Doc. Type");
                        VendLedgEntry.SETRANGE("Vendor No.", "Account No.");
                        VendLedgEntry.SETRANGE(Open, true);
                        if VendLedgEntry.FINDFIRST then begin
                            if VendLedgEntry."Amount to Apply" <> 0 then begin
                                VendLedgEntry."Amount to Apply" := 0;
                                CODEUNIT.RUN(CODEUNIT::"Vend. Entry-Edit", VendLedgEntry);
                            end;
                        end;
                    end;

                if ("Applies-to Doc. No." <> xRec."Applies-to Doc. No.") and (Amount <> 0) then begin
                    // IF xRec."Applies-to Doc. No." <> '' THEN
                    //  PaymentToleranceMgt.DelPmtTolApllnDocNo(Rec,xRec."Applies-to Doc. No.");
                    //SetApplyToAmount;
                    //PaymentToleranceMgt.PmtTolGenJnl(Rec);
                    //xRec.ClearAppliedGenJnlLine;
                end;

                case "Account Type" of
                    "Account Type"::Customer:
                        GetCustLedgerEntry;
                    "Account Type"::Vendor:
                        GetVendLedgerEntry;
                end;

                ValidateApplyRequirements(Rec);

                VALIDATE("Status Aplicare", "Status Aplicare"::Neaplicat);//SSM729
            end;
        }
        field(43; "External Document No."; Code[20])
        {
            Caption = 'External Document No.';
        }
        field(44; "Amount (LCY)"; Decimal)
        {
            Caption = 'Amount (LCY)';
            Editable = false;
        }
        field(45; "Drawee Reference"; Text[20])
        {
            Caption = 'Drawee Reference';
        }
        field(46; "Bank City"; Text[30])
        {
            Caption = 'Bank Account City';
        }
        field(47; Marked; Boolean)
        {
            Caption = 'Marked';
            Editable = false;
        }
        field(48; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
            Editable = false;
        }
        field(50; "Payment in progress"; Boolean)
        {
            Caption = 'Payment in progress';
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
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1));
        }
        field(50020; "Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            Description = 'SSM729';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2));
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
                DimensionSetup;//SSM729
            end;
        }
        field(50040; "Status Aplicare"; Option)
        {
            Description = 'SSM729';
            OptionMembers = " ",Aplicat,Neaplicat;
        }
        field(50050; "Suma Aplicata"; Decimal)
        {
            CalcFormula = sum("SSA Pmt. Tools AppLedg. Entry".Amount where("Payment Document No." = field("No."), "Payment Document Line No." = field("Line No.")));
            Description = 'SSM729';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50060; "Vendor Name"; Text[100])
        {
            CalcFormula = lookup(Vendor.Name where("No." = field("Account No.")));
            Caption = 'Nume Furnizor';
            Description = 'SSM845';
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
        field(45007654; "Customer Name"; Text[100])
        {
            CalcFormula = lookup(Customer.Name where("No." = field("Account No.")));
            Caption = 'Customer Name';
            Editable = false;
            FieldClass = FlowField;
        }
        field(45007655; "Receving Date"; Date)
        {
            Caption = 'Receving Date';
        }
        field(45007656; "Sending Date to Bank"; Date)
        {
            Caption = 'Sending Date to Bank';
        }
        field(45007657; "Payment Date"; Date)
        {
            Caption = 'Payment Date';
        }
        field(45007658; Girat; Boolean)
        {
            CalcFormula = lookup("SSA Payment Header".Girat where("No." = field("No.")));
            FieldClass = FlowField;
        }
        field(45007659; "Centru Responsabilitate fisa"; Code[20])
        {
            CalcFormula = lookup(Customer."Responsibility Center" where("No." = field("Account No.")));
            FieldClass = FlowField;
        }
        field(45007660; "Nume Emitent (Girat)"; Text[50])
        {
        }
        field(45007661; "Banca Emitent (Girat)"; Text[50])
        {
        }
        field(45007662; "IBAN Emitent (Girat)"; Text[30])
        {

            trigger OnValidate()
            begin
                CompanyInfo.CheckIBAN("IBAN Emitent (Girat)");
            end;
        }
        field(45007663; "Cashed Amount"; Decimal)
        {
            Caption = 'Cashed Amount';

            trigger OnValidate()
            var
                CurrExchRate: Record "Currency Exchange Rate";
            begin
                if ((Amount > 0) and (not Correction)) or
                   ((Amount < 0) and Correction) then begin
                    "Debit Amount" := Amount;
                    "Credit Amount" := 0
                end else begin
                    "Debit Amount" := 0;
                    "Credit Amount" := -Amount;
                end;
                if "Currency Code" = '' then
                    "Amount (LCY)" := Amount
                else
                    "Amount (LCY)" := ROUND(
                      CurrExchRate.ExchangeAmtFCYToLCY(
                        "Posting Date", "Currency Code",
                        Amount, "Currency Factor"));
                //IF (Rec.Amount <> xRec.Amount) THEN
                // PaymentToleranceMgt.PmtTolPaymentLine(Rec);
            end;
        }
        field(45007664; "Nr. Extras"; Code[20])
        {
        }
    }

    keys
    {
        key(Key1; "No.", "Line No.")
        {
            SumIndexFields = Amount, "Cashed Amount";
        }
        key(Key2; "Copied To No.", "Copied To Line")
        {
        }
        key(Key3; "Account Type", "Account No.", "Copied To Line", "Payment in progress")
        {
            SumIndexFields = "Amount (LCY)";
        }
        key(Key4; "No.", "Account No.", "Bank Branch No.", "Agency Code", "Bank Account No.", "Payment Address Code")
        {
        }
        key(Key5; "Posting Date", "Document ID")
        {
        }
        key(Key6; "Due Date")
        {
        }
        key(Key7; "Applies-to Doc. Type", "Applies-to Doc. No.")
        {
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "No.", "Document ID", "Drawee Reference", Amount)
        {
        }
    }

    trigger OnDelete()
    var
        PaymentHeader: Record "SSA Payment Header";
        PaymentApply: Codeunit "SSA Payment-Apply";
    begin
        if "Copied To No." <> '' then
            ERROR(Text001);
        DimensionDelete;
        PaymentApply.DeleteApply(Rec);

        //SSM729>>
        PaymentHeader.GET("No.");
        PaymentHeader.CALCFIELDS("Suma Aplicata");
        if (PaymentHeader."Suma Aplicata" <> 0) or (Amount <> 0) then
            ERROR(Text50002);
        //SSM729<<

        if PaymentHeader."Status No." > 0 then
            PaymentManagement.CreazaLiniiAplicare(PaymentHeader, false, "Line No.");
    end;

    trigger OnInsert()
    var
        Statement: Record "SSA Payment Header";
    begin
        Statement.GET("No.");
        "Payment Class" := Statement."Payment Class";
        if (Statement."Currency Code" <> "Currency Code") and IsCopy then
            ERROR(Text000);
        "Currency Code" := Statement."Currency Code";
        "Currency Factor" := Statement."Currency Factor";
        "Posting Date" := Statement."Posting Date";
        "Dimension Set ID" := Statement."Dimension Set ID"; //SSM729
        VALIDATE(Amount);
        VALIDATE("Status No.");
        UpdateEntry;
    end;

    var
        Text000: Label 'You cannot use different currencies on the same payment header.';
        Text001: Label 'Delete not allowed';
        Currency: Record Currency;
        CustomerBank: Record "Customer Bank Account";
        VendorBank: Record "Vendor Bank Account";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        PaymentClass: Record "SSA Payment Class";
        Customer: Record Customer;
        Vendor: Record Vendor;
        DefaultDimension: Record "Default Dimension";
        PaymentToleranceMgt: Codeunit "Payment Tolerance Management";
        CompanyInfo: Record "Company Information";
        Coding: Label 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
        Uncoding: Label '12345678912345678923456789';
        CustEntrySetApplID: Codeunit "Cust. Entry-SetAppl.ID";
        VendEntrySetApplID: Codeunit "Vend. Entry-SetAppl.ID";
        CustLedgEntry: Record "Cust. Ledger Entry";
        VendLedgEntry: Record "Vendor Ledger Entry";
        Text003: Label 'The %1 in the %2 will be changed from %3 to %4.\Do you want to continue?';
        Text005: Label 'The update has been interrupted to respect the warning.';
        Text009: Label 'LCY';
        NotExistErr: Label 'Document No. %1 does not exist or is already closed.';
        FromCurrencyCode: Code[10];
        ToCurrencyCode: Code[10];
        SourceCode: Code[10];
        DimMgt: Codeunit DimensionManagement;
        CurrencyCode: Code[10];
        Text015: Label 'You are not allowed to apply and post an entry to an entry with an earlier posting date.\\Instead, post %1 %2 and then apply it to %3 %4.';
        Text50001: Label 'Nu puteti aplica %1 cu %2 in linie jurnal %3! Incercati sa aplicati %1 cu %1!';
        Text50002: Label 'Line cannot be deleted because amout aplied is different than 0.';
        PaymentManagement: Codeunit "SSA Payment Management";
        PaymentLine: Record "SSA Payment Line";

    procedure SetUpNewLine(LastGenJnlLine: Record "SSA Payment Line"; BottomLine: Boolean)
    var
        Statement: Record "SSA Payment Header";
    begin
        "Account Type" := LastGenJnlLine."Account Type";
        if "No." <> '' then begin
            Statement.GET("No.");
            PaymentClass.GET(Statement."Payment Class");
            if PaymentClass."Line No. Series" = '' then
                "Document ID" := Statement."No."
            else
                if "Document ID" = '' then
                    if BottomLine then
                        "Document ID" := INCSTR(LastGenJnlLine."Document ID")
                    else
                        "Document ID" := NoSeriesMgt.GetNextNo(PaymentClass."Line No. Series", "Posting Date", false);
        end;
        "Due Date" := Statement."Posting Date";
    end;

    procedure ShowDimensions()
    begin
        /*IF "Line No." <> 0 THEN BEGIN
          TESTFIELD("No.");
          DocDim.SETRANGE("Table ID",DATABASE::"Payment Line");
          DocDim.SETRANGE("Document Type",DocDim."Document Type"::" ");
          DocDim.SETRANGE("Document No.","No.");
          DocDim.SETRANGE("Line No.","Line No.");
          DocDimensions.SETTABLEVIEW(DocDim);
          DocDimensions.RUNMODAL;
        END;  */

    end;

    procedure GetCurrency()
    var
        Header: Record "SSA Payment Header";
    begin
        Header.GET("No.");
        if Header."Currency Code" = '' then begin
            CLEAR(Currency);
            Currency.InitRoundingPrecision;
        end else begin
            Currency.GET(Header."Currency Code");
        end;
    end;

    procedure InitBankAccount()
    begin
        "Bank Account" := '';
        "Bank Branch No." := '';
        "Bank Account No." := '';
        "Agency Code" := '';
        "RIB Key" := 0;
        "RIB Checked" := false;
        "Bank Account Name" := '';
        "Bank City" := '';
    end;

    procedure DimensionSetup()
    var
        DimManagt: Codeunit DimensionManagement;
    begin
        /*//SSM729 original
        IF "Line No." <> 0 THEN BEGIN
          CLEAR(DefaultDimension);
          DefaultDimension.SETRANGE("Table ID", DimManagt.TypeToTableID1("Account Type"));
          DimensionCreate;
        END;
        */
        CreateDim(DimMgt.TypeToTableID1("Account Type"), "Account No.", DATABASE::"Salesperson/Purchaser", "Salesperson/Purchaser Code");
        //SSM729<<

    end;

    procedure DimensionCreate()
    begin
        /*DefaultDimension.SETRANGE("No.", "Account No.");
        IF DefaultDimension.FIND('-') THEN REPEAT
          WITH DocumentDimension DO BEGIN
            "Table ID" := DATABASE::"Payment Line";
            "Document Type" := DocumentDimension."Document Type"::" ";
            "Document No." := Rec."No.";
            "Line No." := Rec."Line No.";
            "Dimension Code" := DefaultDimension."Dimension Code";
            "Dimension Value Code" := DefaultDimension."Dimension Value Code";
            INSERT;
          END;
        UNTIL DefaultDimension.NEXT = 0;
        
        HeaderDimension.SETRANGE("Table ID", DATABASE::"SSA Payment Header");
        HeaderDimension.SETRANGE("Document Type", HeaderDimension."Document Type"::" ");
        HeaderDimension.SETRANGE("Document No.", "No.");
        HeaderDimension.SETRANGE("Line No.", 0);
        IF HeaderDimension.FIND('-') THEN
          REPEAT
            WITH DocumentDimension DO BEGIN
              "Table ID" := DATABASE::"Payment Line";
              "Document Type" := "Document Type"::" ";
              "Document No." := Rec."No.";
              "Line No." := Rec."Line No.";
              "Dimension Code" := HeaderDimension."Dimension Code";
              "Dimension Value Code" := HeaderDimension."Dimension Value Code";
              IF NOT MODIFY THEN
                INSERT(TRUE);
            END;
          UNTIL HeaderDimension.NEXT = 0;
          */

    end;

    procedure DimensionDelete()
    begin
        /*DocumentDimension.SETRANGE("Table ID", DATABASE::"Payment Line");
        DocumentDimension.SETRANGE("Document Type", DocumentDimension."Document Type"::" ");
        DocumentDimension.SETRANGE("Document No.", "No.");
        DocumentDimension.SETRANGE("Line No.", "Line No.");
        DocumentDimension.DELETEALL;   */

    end;

    procedure UpdateDueDate(DocumentDate: Date)
    var
        PaymentTerms: Record "Payment Terms";
        PaymentHeader: Record "SSA Payment Header";
    begin
        if "Status No." > 0 then
            exit;
        if DocumentDate = 0D then begin
            PaymentHeader.GET("No.");
            DocumentDate := PaymentHeader."Posting Date";
            if DocumentDate = 0D then
                exit;
        end;
        CLEAR(PaymentTerms);
        if "Account Type" = "Account Type"::Customer then begin
            if "Account No." <> '' then begin
                Customer.GET("Account No.");
                /*IF NOT PaymentTerms.GET(Customer."Payment Terms Code") THEN
                  "Due Date" := PaymentHeader."Posting Date";*/
            end
        end else
            if "Account Type" = "Account Type"::Vendor then begin
                if "Account No." <> '' then begin
                    Vendor.GET("Account No.");
                    /*IF NOT PaymentTerms.GET(Vendor."Payment Terms Code") THEN
                      "Due Date" := PaymentHeader."Posting Date";*/
                end;
            end;
        if PaymentTerms.Code <> '' then
            "Due Date" := CALCDATE(PaymentTerms."Due Date Calculation", DocumentDate);

    end;

    procedure UpdateEntry()
    var
        PaymentAddress: Record "SSA Payment Address";
        GLAccount: Record "G/L Account";
        BankAccount: Record "Bank Account";
        FixedAsset: Record "Fixed Asset";
    begin
        if (xRec."Line No." <> 0) and ("Account Type" <> xRec."Account Type") then begin
            "Account No." := '';
            InitBankAccount;
            "Due Date" := 0D;
            DimensionDelete;
        end;
        if "Account No." = '' then
            exit;
        if (xRec."Line No." = "Line No.") and (xRec."Account No." <> '') and ("Account No." <> xRec."Account No.") then begin
            InitBankAccount;
            DimensionDelete;
        end;
        if (xRec."Line No." = "Line No.") and (xRec."Account Type" = "Account Type") and (xRec."Account No." = "Account No.") then
            exit;
        case "Account Type" of
            "Account Type"::"G/L Account":
                begin
                    GLAccount.GET("Account No.");
                    GLAccount.TESTFIELD("Account Type", GLAccount."Account Type"::Posting);
                    GLAccount.TESTFIELD(Blocked, false);
                end;
            "Account Type"::Customer:
                begin
                    Customer.GET("Account No.");
                    //SSM729 Customer.TESTFIELD(Blocked, Customer.Blocked ::" ");
                    if Customer."SSA Default Bank Account Code" <> '' then
                        VALIDATE("Bank Account", Customer."SSA Default Bank Account Code");
                    //SSM729>>
                    VALIDATE("Salesperson/Purchaser Code", Customer."Salesperson Code");
                    //SSM729<<
                    UpdateDueDate(0D);
                end;
            "Account Type"::Vendor:
                begin
                    Vendor.GET("Account No.");
                    Vendor.TESTFIELD(Blocked, Vendor.Blocked::" ");
                    if Vendor."SSA Default Bank Account Code" <> '' then
                        VALIDATE("Bank Account", Vendor."SSA Default Bank Account Code");
                    //SSM729>>
                    VALIDATE("Salesperson/Purchaser Code", Vendor."Purchaser Code");
                    //SSM729<<
                    UpdateDueDate(0D);
                end;
            "Account Type"::"Bank Account":
                begin
                    BankAccount.GET("Account No.");
                    BankAccount.TESTFIELD(Blocked, false);
                end;
            "Account Type"::"Fixed Asset":
                begin
                    FixedAsset.GET("Account No.");
                    FixedAsset.TESTFIELD(Blocked, false);
                end;
        end;
        DimensionSetup;
        PaymentAddress.SETRANGE("Account Type", "Account Type");
        PaymentAddress.SETRANGE("Account No.", "Account No.");
        PaymentAddress.SETRANGE("Default value", true);
        if PaymentAddress.FIND('-') then
            "Payment Address Code" := PaymentAddress.Code
        else
            "Payment Address Code" := '';
    end;

    procedure Check(Bank: Text[20]; Agency: Text[20]; Account: Text[30]; RIBKey: Integer): Boolean
    var
        LongAccountNum: Code[30];
        Index: Integer;
        Remaining: Integer;
    begin
        if not ((STRLEN(Bank) = 5) and
               (STRLEN(Agency) = 5) and
               (STRLEN(Account) = 11) and
               (RIBKey < 100)) then
            exit(false);

        LongAccountNum := Bank + Agency + Account + CONVERTSTR(FORMAT(RIBKey, 2), ' ', '0');
        LongAccountNum := CONVERTSTR(LongAccountNum, Coding, Uncoding);

        Remaining := 0;
        for Index := 1 to 23 do
            Remaining := (Remaining * 10 + (LongAccountNum[Index] - '0')) mod 97;

        exit(Remaining = 0);
    end;

    procedure ClearCustVendApplnEntry()
    var
        TempCustLedgEntry: Record "Cust. Ledger Entry";
        TempVendLedgEntry: Record "Vendor Ledger Entry";
        CustEntryEdit: Codeunit "Cust. Entry-Edit";
        VendEntryEdit: Codeunit "Vend. Entry-Edit";
        AccType: Option "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset";
        AccNo: Code[20];
    begin
        case "Account Type" of
            "Account Type"::Customer:
                if xRec."Applies-to ID" <> '' then begin
                    if FindFirstCustLedgEntryWithAppliesToID(AccNo, xRec."Applies-to ID") then begin
                        ClearCustApplnEntryFields;
                        CustEntrySetApplID.SetApplId(CustLedgEntry, TempCustLedgEntry, '');
                    end
                end else
                    if xRec."Applies-to Doc. No." <> '' then
                        if FindFirstCustLedgEntryWithAppliesToDocNo(AccNo, xRec."Applies-to Doc. No.") then begin
                            ClearCustApplnEntryFields;
                            CustEntryEdit.RUN(CustLedgEntry);
                        end;
            "Account Type"::Vendor:
                if xRec."Applies-to ID" <> '' then begin
                    if FindFirstVendLedgEntryWithAppliesToID(AccNo, xRec."Applies-to ID") then begin
                        ClearVendApplnEntryFields;
                        VendEntrySetApplID.SetApplId(VendLedgEntry, TempVendLedgEntry, '');
                    end
                end else
                    if xRec."Applies-to Doc. No." <> '' then
                        if FindFirstVendLedgEntryWithAppliesToDocNo(AccNo, xRec."Applies-to Doc. No.") then begin
                            ClearVendApplnEntryFields;
                            VendEntryEdit.RUN(VendLedgEntry);
                        end;
        end;
    end;

    local procedure FindFirstCustLedgEntryWithAppliesToID(AccNo: Code[20]; AppliesToID: Code[50]): Boolean
    begin
        CustLedgEntry.RESET;
        CustLedgEntry.SETCURRENTKEY("Customer No.", "Applies-to ID", Open);
        CustLedgEntry.SETRANGE("Customer No.", AccNo);
        CustLedgEntry.SETRANGE("Applies-to ID", AppliesToID);
        CustLedgEntry.SETRANGE(Open, true);
        exit(CustLedgEntry.FINDFIRST)
    end;

    local procedure ClearCustApplnEntryFields()
    begin
        CustLedgEntry."Accepted Pmt. Disc. Tolerance" := false;
        CustLedgEntry."Accepted Payment Tolerance" := 0;
        CustLedgEntry."Amount to Apply" := 0;
    end;

    local procedure ClearVendApplnEntryFields()
    begin
        VendLedgEntry."Accepted Pmt. Disc. Tolerance" := false;
        VendLedgEntry."Accepted Payment Tolerance" := 0;
        VendLedgEntry."Amount to Apply" := 0;
    end;

    local procedure FindFirstCustLedgEntryWithAppliesToDocNo(AccNo: Code[20]; AppliestoDocNo: Code[20]): Boolean
    begin
        CustLedgEntry.RESET;
        CustLedgEntry.SETCURRENTKEY("Document No.");
        CustLedgEntry.SETRANGE("Document No.", AppliestoDocNo);
        CustLedgEntry.SETRANGE("Document Type", "Applies-to Doc. Type");
        CustLedgEntry.SETRANGE("Customer No.", AccNo);
        CustLedgEntry.SETRANGE(Open, true);
        exit(CustLedgEntry.FINDFIRST)
    end;

    local procedure FindFirstVendLedgEntryWithAppliesToID(AccNo: Code[20]; AppliesToID: Code[50]): Boolean
    begin
        VendLedgEntry.RESET;
        VendLedgEntry.SETCURRENTKEY("Vendor No.", "Applies-to ID", Open);
        VendLedgEntry.SETRANGE("Vendor No.", AccNo);
        VendLedgEntry.SETRANGE("Applies-to ID", AppliesToID);
        VendLedgEntry.SETRANGE(Open, true);
        exit(VendLedgEntry.FINDFIRST)
    end;

    local procedure FindFirstVendLedgEntryWithAppliesToDocNo(AccNo: Code[20]; AppliestoDocNo: Code[20]): Boolean
    begin
        VendLedgEntry.RESET;
        VendLedgEntry.SETCURRENTKEY("Document No.");
        VendLedgEntry.SETRANGE("Document No.", AppliestoDocNo);
        VendLedgEntry.SETRANGE("Document Type", "Applies-to Doc. Type");
        VendLedgEntry.SETRANGE("Vendor No.", AccNo);
        VendLedgEntry.SETRANGE(Open, true);
        exit(VendLedgEntry.FINDFIRST)
    end;

    procedure GetCustLedgerEntry()
    begin
        if ("Account Type" = "Account Type"::Customer) and ("Account No." = '') and
           ("Applies-to Doc. No." <> '') and (Amount = 0)
        then begin
            CustLedgEntry.RESET;
            CustLedgEntry.SETRANGE("Document No.", "Applies-to Doc. No.");
            CustLedgEntry.SETRANGE(Open, true);
            if not CustLedgEntry.FINDFIRST then
                ERROR(NotExistErr, "Applies-to Doc. No.");

            VALIDATE("Account No.", CustLedgEntry."Customer No.");
            CustLedgEntry.CALCFIELDS("Remaining Amount");

            if "Posting Date" <= CustLedgEntry."Pmt. Discount Date" then
                Amount := -(CustLedgEntry."Remaining Amount" - CustLedgEntry."Remaining Pmt. Disc. Possible")
            else
                Amount := -CustLedgEntry."Remaining Amount";

            if "Currency Code" <> CustLedgEntry."Currency Code" then begin
                FromCurrencyCode := GetShowCurrencyCode("Currency Code");
                ToCurrencyCode := GetShowCurrencyCode(CustLedgEntry."Currency Code");
                if not
                   CONFIRM(
                     Text003, true,
                     FIELDCAPTION("Currency Code"), TABLECAPTION, FromCurrencyCode,
                     ToCurrencyCode)
                then
                    ERROR(Text005);
                VALIDATE("Currency Code", CustLedgEntry."Currency Code");
            end;

            "Applies-to Doc. Type" := CustLedgEntry."Document Type";
            "Applies-to Doc. No." := CustLedgEntry."Document No.";
            "Applies-to ID" := '';
            if ("Applies-to Doc. Type" = "Applies-to Doc. Type"::Invoice)
            then
                "External Document No." := CustLedgEntry."External Document No.";

            /*GenJnlBatch.GET("Journal Template Name","Journal Batch Name");
            IF GenJnlBatch."Bal. Account No." <> '' THEN BEGIN
              "Bal. Account Type" := GenJnlBatch."Bal. Account Type";
              VALIDATE("Bal. Account No.",GenJnlBatch."Bal. Account No.");
            END ELSE*/
            VALIDATE(Amount);
        end;

    end;

    procedure GetVendLedgerEntry()
    begin
        if ("Account Type" = "Account Type"::Vendor) and ("Account No." = '') and
           ("Applies-to Doc. No." <> '') and (Amount = 0)
        then begin
            VendLedgEntry.RESET;
            VendLedgEntry.SETRANGE("Document No.", "Applies-to Doc. No.");
            VendLedgEntry.SETRANGE(Open, true);
            if not VendLedgEntry.FINDFIRST then
                ERROR(NotExistErr, "Applies-to Doc. No.");

            VALIDATE("Account No.", VendLedgEntry."Vendor No.");
            VendLedgEntry.CALCFIELDS("Remaining Amount");

            if "Posting Date" <= VendLedgEntry."Pmt. Discount Date" then
                Amount := -(CustLedgEntry."Remaining Amount" - VendLedgEntry."Remaining Pmt. Disc. Possible")
            else
                Amount := -VendLedgEntry."Remaining Amount";

            if "Currency Code" <> VendLedgEntry."Currency Code" then begin
                FromCurrencyCode := GetShowCurrencyCode("Currency Code");
                ToCurrencyCode := GetShowCurrencyCode(CustLedgEntry."Currency Code");
                if not
                   CONFIRM(
                     Text003,
                     true, FIELDCAPTION("Currency Code"), TABLECAPTION, FromCurrencyCode, ToCurrencyCode)
                then
                    ERROR(Text005);
                VALIDATE("Currency Code", VendLedgEntry."Currency Code");
            end;

            "Applies-to Doc. Type" := VendLedgEntry."Document Type";
            "Applies-to Doc. No." := VendLedgEntry."Document No.";
            "Applies-to ID" := '';
            if ("Applies-to Doc. Type" = "Applies-to Doc. Type"::Invoice)
            then
                "External Document No." := VendLedgEntry."External Document No.";

            /* GenJnlBatch.GET("Journal Template Name","Journal Batch Name");
             IF GenJnlBatch."Bal. Account No." <> '' THEN BEGIN
               "Bal. Account Type" := GenJnlBatch."Bal. Account Type";
               VALIDATE("Bal. Account No.",GenJnlBatch."Bal. Account No.");
             END ELSE      */
            VALIDATE(Amount);
        end;

    end;

    procedure GetShowCurrencyCode(CurrencyCode: Code[10]): Code[10]
    begin
        if CurrencyCode <> '' then
            exit(CurrencyCode);

        exit(Text009);
    end;

    procedure ValidateApplyRequirements(TempGenJnlLine: Record "SSA Payment Line" temporary)
    var
        ExchAccGLJnlLine: Codeunit "Exchange Acc. G/L Journal Line";
    begin

        if TempGenJnlLine."Account Type" = TempGenJnlLine."Account Type"::Customer then begin
            if TempGenJnlLine."Applies-to ID" <> '' then begin
                CustLedgEntry.SETCURRENTKEY("Customer No.", "Applies-to ID", Open);
                CustLedgEntry.SETRANGE("Customer No.", TempGenJnlLine."Account No.");
                CustLedgEntry.SETRANGE("Applies-to ID", TempGenJnlLine."Applies-to ID");
                CustLedgEntry.SETRANGE(Open, true);
                if CustLedgEntry.FIND('-') then
                    repeat
                        if TempGenJnlLine."Posting Date" < CustLedgEntry."Posting Date" then
                            ERROR(
                              Text015, '', TempGenJnlLine."No.",
                              CustLedgEntry."Document Type", CustLedgEntry."Document No.");
                        //ma>> verificare intre grupe diferite
                        if (CustLedgEntry."Customer Posting Group" <> TempGenJnlLine."Posting Group") and (CustLedgEntry."Customer Posting Group" <> '') then
                            ERROR(Text50001, TempGenJnlLine."Posting Group", CustLedgEntry."Customer Posting Group", "Line No.");
                    //ma<<
                    until CustLedgEntry.NEXT = 0;
            end else
                if TempGenJnlLine."Applies-to Doc. No." <> '' then begin
                    CustLedgEntry.SETCURRENTKEY("Document No.");
                    CustLedgEntry.SETRANGE("Document No.", TempGenJnlLine."Applies-to Doc. No.");
                    if TempGenJnlLine."Applies-to Doc. Type" <> TempGenJnlLine."Applies-to Doc. Type"::" " then
                        CustLedgEntry.SETRANGE("Document Type", TempGenJnlLine."Applies-to Doc. Type");
                    CustLedgEntry.SETRANGE("Customer No.", TempGenJnlLine."Account No.");
                    CustLedgEntry.SETRANGE(Open, true);
                    if CustLedgEntry.FIND('-') then begin
                        if TempGenJnlLine."Posting Date" < CustLedgEntry."Posting Date" then
                            ERROR(
                              Text015, '', TempGenJnlLine."No.",
                              CustLedgEntry."Document Type", CustLedgEntry."Document No.");
                        //ma>> verificare intre grupe diferite
                        if TempGenJnlLine."Posting Group" <> '' then //SSM729
                            if (CustLedgEntry."Customer Posting Group" <> TempGenJnlLine."Posting Group") and (CustLedgEntry."Customer Posting Group" <> '') then
                                ERROR(Text50001, TempGenJnlLine."Posting Group", CustLedgEntry."Customer Posting Group", "Line No.");
                        //ma<<
                    end;
                end;
        end else
            if TempGenJnlLine."Account Type" = TempGenJnlLine."Account Type"::Vendor then
                if TempGenJnlLine."Applies-to ID" <> '' then begin
                    VendLedgEntry.SETCURRENTKEY("Vendor No.", "Applies-to ID", Open);
                    VendLedgEntry.SETRANGE("Vendor No.", TempGenJnlLine."Account No.");
                    VendLedgEntry.SETRANGE("Applies-to ID", TempGenJnlLine."Applies-to ID");
                    VendLedgEntry.SETRANGE(Open, true);
                    repeat
                        if TempGenJnlLine."Posting Date" < VendLedgEntry."Posting Date" then
                            ERROR(
                              Text015, '', TempGenJnlLine."No.",
                              VendLedgEntry."Document Type", VendLedgEntry."Document No.");
                        //ma>> verificare intre grupe diferite
                        if (VendLedgEntry."Vendor Posting Group" <> TempGenJnlLine."Posting Group") and (VendLedgEntry."Vendor Posting Group" <> '') then
                            ERROR(Text50001, TempGenJnlLine."Posting Group", VendLedgEntry."Vendor Posting Group", "Line No.");
                    //ma<<
                    until VendLedgEntry.NEXT = 0;
                    if VendLedgEntry.FIND('-') then
                        ;
                end else
                    if TempGenJnlLine."Applies-to Doc. No." <> '' then begin
                        VendLedgEntry.SETCURRENTKEY("Document No.");
                        VendLedgEntry.SETRANGE("Document No.", TempGenJnlLine."Applies-to Doc. No.");
                        if TempGenJnlLine."Applies-to Doc. Type" <> TempGenJnlLine."Applies-to Doc. Type"::" " then
                            VendLedgEntry.SETRANGE("Document Type", TempGenJnlLine."Applies-to Doc. Type");
                        VendLedgEntry.SETRANGE("Vendor No.", TempGenJnlLine."Account No.");
                        VendLedgEntry.SETRANGE(Open, true);
                        if VendLedgEntry.FIND('-') then begin
                            if TempGenJnlLine."Posting Date" < VendLedgEntry."Posting Date" then
                                ERROR(
                                  Text015, '', TempGenJnlLine."No.",
                                  VendLedgEntry."Document Type", VendLedgEntry."Document No.");
                            //ma>> verificare intre grupe diferite
                            if (VendLedgEntry."Vendor Posting Group" <> TempGenJnlLine."Posting Group") and (VendLedgEntry."Vendor Posting Group" <> '') then
                                ERROR(Text50001, TempGenJnlLine."Posting Group", VendLedgEntry."Vendor Posting Group", "Line No.");
                            //ma<<
                        end;
                    end;
    end;

    procedure LookUpAppliesToDocCust(AccNo: Code[20])
    var
        ApplyCustEntries: Page "Apply Customer Entries";
        GenJnlLine: Record "Gen. Journal Line";
    begin
        CLEAR(CustLedgEntry);
        CustLedgEntry.SETCURRENTKEY("Customer No.", Open, Positive, "Due Date");
        if AccNo <> '' then
            CustLedgEntry.SETRANGE("Customer No.", AccNo);
        CustLedgEntry.SETRANGE(Open, true);
        if "Applies-to Doc. No." <> '' then begin
            CustLedgEntry.SETRANGE("Document Type", "Applies-to Doc. Type");
            CustLedgEntry.SETRANGE("Document No.", "Applies-to Doc. No.");
            if CustLedgEntry.ISEMPTY then begin
                CustLedgEntry.SETRANGE("Document Type");
                CustLedgEntry.SETRANGE("Document No.");
            end;
        end;
        if "Applies-to ID" <> '' then begin
            CustLedgEntry.SETRANGE("Applies-to ID", "Applies-to ID");
            if CustLedgEntry.ISEMPTY then
                CustLedgEntry.SETRANGE("Applies-to ID");
        end;
        if "Applies-to Doc. Type" <> "Applies-to Doc. Type"::" " then begin
            CustLedgEntry.SETRANGE("Document Type", "Applies-to Doc. Type");
            if CustLedgEntry.ISEMPTY then
                CustLedgEntry.SETRANGE("Document Type");
        end;
        if Amount <> 0 then begin
            CustLedgEntry.SETRANGE(Positive, Amount < 0);
            if CustLedgEntry.ISEMPTY then
                CustLedgEntry.SETRANGE(Positive);
        end;
        GenJnlLine.INIT;
        GenJnlLine.VALIDATE("Document Type", GenJnlLine."Document Type"::Payment);
        GenJnlLine.VALIDATE("Posting Date", "Due Date");
        GenJnlLine.VALIDATE("Account Type", "Account Type");
        GenJnlLine.VALIDATE("Account No.", "Account No.");
        GenJnlLine.VALIDATE(Amount);
        ApplyCustEntries.SetGenJnlLine(GenJnlLine, GenJnlLine.FIELDNO("Applies-to Doc. No."));
        ApplyCustEntries.SETTABLEVIEW(CustLedgEntry);
        ApplyCustEntries.SETRECORD(CustLedgEntry);
        ApplyCustEntries.LOOKUPMODE(true);
        if ApplyCustEntries.RUNMODAL = ACTION::LookupOK then begin
            ApplyCustEntries.GETRECORD(CustLedgEntry);
            //SetAmountWithCustLedgEntry;
            "Applies-to Doc. Type" := CustLedgEntry."Document Type";
            //SSM729>>
            //  "Applies-to Doc. No." := CustLedgEntry."Document No.";
            VALIDATE("Applies-to Doc. No.", CustLedgEntry."Document No.");
            //SSM729<<
            "Posting Group" := CustLedgEntry."Customer Posting Group"; //ma copiaza grupa de pe factura
            "Applies-to ID" := '';
        end;
    end;

    procedure LookUpAppliesToDocVend(AccNo: Code[20])
    var
        ApplyVendEntries: Page "Apply Vendor Entries";
        GenJnlLine: Record "Gen. Journal Line";
    begin
        CLEAR(VendLedgEntry);
        VendLedgEntry.SETCURRENTKEY("Vendor No.", Open, Positive, "Due Date");
        if AccNo <> '' then
            VendLedgEntry.SETRANGE("Vendor No.", AccNo);
        VendLedgEntry.SETRANGE(Open, true);
        if "Applies-to Doc. No." <> '' then begin
            VendLedgEntry.SETRANGE("Document Type", "Applies-to Doc. Type");
            VendLedgEntry.SETRANGE("Document No.", "Applies-to Doc. No.");
            if VendLedgEntry.ISEMPTY then begin
                VendLedgEntry.SETRANGE("Document Type");
                VendLedgEntry.SETRANGE("Document No.");
            end;
        end;
        if "Applies-to ID" <> '' then begin
            VendLedgEntry.SETRANGE("Applies-to ID", "Applies-to ID");
            if VendLedgEntry.ISEMPTY then
                VendLedgEntry.SETRANGE("Applies-to ID");
        end;
        if "Applies-to Doc. Type" <> "Applies-to Doc. Type"::" " then begin
            VendLedgEntry.SETRANGE("Document Type", "Applies-to Doc. Type");
            if VendLedgEntry.ISEMPTY then
                VendLedgEntry.SETRANGE("Document Type");
        end;
        if "Applies-to Doc. No." <> '' then begin
            VendLedgEntry.SETRANGE("Document No.", "Applies-to Doc. No.");
            if VendLedgEntry.ISEMPTY then
                VendLedgEntry.SETRANGE("Document No.");
        end;
        if Amount <> 0 then begin
            VendLedgEntry.SETRANGE(Positive, Amount < 0);
            if VendLedgEntry.ISEMPTY then;
            VendLedgEntry.SETRANGE(Positive);
        end;
        GenJnlLine.INIT;
        GenJnlLine.VALIDATE("Document Type", GenJnlLine."Document Type"::Payment);
        GenJnlLine.VALIDATE("Posting Date", "Due Date");
        GenJnlLine.VALIDATE("Account Type", "Account Type");
        GenJnlLine.VALIDATE("Account No.", "Account No.");
        GenJnlLine.VALIDATE(Amount);

        ApplyVendEntries.SetGenJnlLine(GenJnlLine, GenJnlLine.FIELDNO("Applies-to Doc. No."));
        ApplyVendEntries.SETTABLEVIEW(VendLedgEntry);
        ApplyVendEntries.SETRECORD(VendLedgEntry);
        ApplyVendEntries.LOOKUPMODE(true);
        if ApplyVendEntries.RUNMODAL = ACTION::LookupOK then begin
            ApplyVendEntries.GETRECORD(VendLedgEntry);
            //SetAmountWithVendLedgEntry;
            "Applies-to Doc. Type" := VendLedgEntry."Document Type";
            //SSM729>>
            //  "Applies-to Doc. No." := VendLedgEntry."Document No.";
            VALIDATE("Applies-to Doc. No.", VendLedgEntry."Document No.");
            //SSM729<<
            "Posting Group" := VendLedgEntry."Vendor Posting Group"; //ma copiaza grupa de pe facturas
            "Applies-to ID" := '';
        end;
    end;

    procedure CreateDim(Type1: Integer; No1: Code[20]; Type2: Integer; No2: Code[20])
    var
        TableID: array[10] of Integer;
        No: array[10] of Code[20];
        DimMgt: Codeunit DimensionManagement;
        OldDimSetID: Integer;
    begin
        //SSM729>>
        GetSourceCode(Rec, SourceCode);
        TableID[1] := Type1;
        No[1] := No1;
        TableID[2] := Type2;
        No[2] := No2;
        "Shortcut Dimension 1 Code" := '';
        "Shortcut Dimension 2 Code" := '';
        OldDimSetID := "Dimension Set ID";
        "Dimension Set ID" :=
          DimMgt.GetDefaultDimID(TableID, No, SourceCode, "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code", 0, 0);
        //SSM729<<
    end;

    procedure GetSourceCode(PaymentLine: Record "SSA Payment Line"; var SourceCode_Local: Code[10])
    var
        PaymentHeader: Record "SSA Payment Header";
        PaymentManagement: Codeunit "SSA Payment Management";
    begin
        //SSM729>>
        if PaymentHeader.GET(PaymentLine."No.") then begin
            if PaymentHeader."Source Code" <> '' then begin
                PaymentManagement.TestSourceCode(PaymentHeader."Source Code");
                SourceCode_Local := PaymentHeader."Source Code";
            end
        end;
        //SSM729<<
    end;
}

