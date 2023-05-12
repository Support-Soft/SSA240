table 70506 "SSA Payment Header"
{
    // SSM729 SSCAT 21.06.2018 Nr.crt.76-Limita valorica pentru instrumente de plata neincasate- fin
    // SSM845 SSCAT 25.07.2018 meeting financiar 200718
    // SSM872 SSCAT 06.09.2018 Minuta financiar 30.08.2018
    // HD819  SSCAT 03.10.2018 modificari 170918

    Caption = 'Payment Header';
    PasteIsValid = false;

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';
            Editable = false;

            trigger OnValidate()
            begin
                IF "No." <> xRec."No." THEN BEGIN
                    Process := GetProcess;
                    NoSeriesMgt.TestManual(Process."Header No. Series");
                    "No. Series" := '';
                END;
            end;
        }
        field(2; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
            TableRelation = Currency;

            trigger OnValidate()
            var
                PaymentLine: Record "SSA Payment Line";
                CompanyBank: Record "Bank Account";
            begin
                IF "Account Type" = "Account Type"::"Bank Account" THEN
                    IF CompanyBank.GET("Account No.") THEN
                        IF CompanyBank."Currency Code" <> '' THEN
                            ERROR(Text008, CompanyBank."Currency Code");

                IF CurrFieldNo <> FIELDNO("Currency Code") THEN
                    UpdateCurrencyFactor
                ELSE BEGIN
                    IF "Currency Code" <> xRec."Currency Code" THEN BEGIN
                        PaymentLine.SETRANGE("No.", "No.");
                        IF PaymentLine.FIND('-') THEN
                            ERROR(Text002);
                        UpdateCurrencyFactor;
                    END ELSE
                        IF "Currency Code" <> '' THEN BEGIN
                            UpdateCurrencyFactor;
                            IF "Currency Factor" <> xRec."Currency Factor" THEN
                                ConfirmUpdateCurrencyFactor;
                        END;
                END;
                IF "Currency Code" <> xRec."Currency Code" THEN BEGIN
                    PaymentLine.INIT;
                    PaymentLine.SETRANGE("No.", "No.");
                    PaymentLine.MODIFYALL("Currency Code", "Currency Code");
                    PaymentLine.MODIFYALL("Currency Factor", "Currency Factor");
                END;
            end;
        }
        field(3; "Currency Factor"; Decimal)
        {
            Caption = 'Currency Factor';
            DecimalPlaces = 0 : 15;

            trigger OnValidate()
            var
                PaymentLine: Record "SSA Payment Line";
            begin
                PaymentLine.SETRANGE("No.", "No.");
                PaymentLine.MODIFYALL("Currency Factor", "Currency Factor");
            end;
        }
        field(4; "Posting Date"; Date)
        {
            Caption = 'Posting Date';

            trigger OnValidate()
            begin
                IF "Posting Date" <> xRec."Posting Date" THEN BEGIN
                    CLEAR(RegLine);
                    RegLine.SETRANGE("No.", "No.");
                    RegLine.MODIFYALL("Posting Date", "Posting Date");
                END;
            end;
        }
        field(5; "Document Date"; Date)
        {
            Caption = 'Document Date';

            trigger OnValidate()
            begin
                IF "Document Date" <> xRec."Document Date" THEN BEGIN
                    CLEAR(RegLine);
                    RegLine.SETRANGE("No.", "No.");
                    IF RegLine.FIND('-') THEN
                        REPEAT
                            RegLine.UpdateDueDate("Document Date");
                        UNTIL RegLine.NEXT = 0;
                END;
            end;
        }
        field(6; "Payment Class"; Text[30])
        {
            Caption = 'Payment Class';
            TableRelation = "SSA Payment Class";

            trigger OnValidate()
            begin
                VALIDATE("Status No.");
            end;
        }
        field(7; "Status No."; Integer)
        {
            Caption = 'Status';
            TableRelation = "SSA Payment Status".Line WHERE("Payment Class" = FIELD("Payment Class"));

            trigger OnValidate()
            var
                PaymentStep: Record "SSA Payment Step";
                PaymentStatus: Record "SSA Payment Status";
            begin
                PaymentStep.SETRANGE("Payment Class", "Payment Class");
                PaymentStep.SETFILTER("Next Status", '>%1', "Status No.");
                PaymentStep.SETRANGE(PaymentStep."Action Type", PaymentStep."Action Type"::Ledger);
                IF PaymentStep.FIND('-') THEN
                    "Source Code" := PaymentStep."Source Code";
                PaymentStatus.GET("Payment Class", "Status No.");
                "Archiving authorized" := PaymentStatus."Archiving authorized";
            end;
        }
        field(8; "Status Name"; Text[50])
        {
            CalcFormula = Lookup("SSA Payment Status".Name WHERE("Payment Class" = FIELD("Payment Class"), Line = FIELD("Status No.")));
            Caption = 'Status Name';
            Editable = false;
            FieldClass = FlowField;
        }
        field(9; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Shortcut Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));

            trigger OnLookup()
            begin
                LookupShortcutDimCode(1, "Shortcut Dimension 1 Code");
            end;

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(1, "Shortcut Dimension 1 Code");
                MODIFY;
            end;
        }
        field(10; "Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));

            trigger OnLookup()
            begin
                LookupShortcutDimCode(2, "Shortcut Dimension 2 Code");
            end;

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(2, "Shortcut Dimension 2 Code");
                MODIFY;
            end;
        }
        field(11; "Payment Class Name"; Text[50])
        {
            CalcFormula = Lookup("SSA Payment Class".Name WHERE(Code = FIELD("Payment Class")));
            Caption = 'Payment Class Name';
            Editable = false;
            FieldClass = FlowField;
        }
        field(12; "No. Series"; Code[20])
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

            trigger OnValidate()
            begin
                IF "Account Type" <> xRec."Account Type" THEN BEGIN
                    VALIDATE("Account No.", '');
                    DimensionDelete;
                END;
            end;
        }
        field(15; "Account No."; Code[20])
        {
            Caption = 'Account No.';
            TableRelation = IF ("Account Type" = CONST("G/L Account")) "G/L Account" ELSE
            IF ("Account Type" = CONST(Customer)) Customer ELSE
            IF ("Account Type" = CONST(Vendor)) Vendor ELSE
            IF ("Account Type" = CONST("Bank Account")) "Bank Account" ELSE
            IF ("Account Type" = CONST("Fixed Asset")) "Fixed Asset";

            trigger OnValidate()
            begin
                IF "Account No." <> xRec."Account No." THEN BEGIN
                    DimensionDelete;
                    IF "Account No." <> '' THEN
                        DimensionSetup;
                END;
                IF "Account Type" = "Account Type"::"Bank Account" THEN BEGIN
                    IF CompanyBank.GET("Account No.") THEN BEGIN
                        IF "Currency Code" = '' THEN
                            IF CompanyBank."Currency Code" <> '' THEN
                                ERROR(Text006);
                        IF "Currency Code" <> '' THEN
                            IF (CompanyBank."Currency Code" <> "Currency Code") AND (CompanyBank."Currency Code" <> '') THEN
                                ERROR(Text007, "Currency Code");
                        "Bank Branch No." := CompanyBank."Bank Branch No.";
                        "Bank Account No." := CompanyBank."Bank Account No.";
                        "Bank Account No." := CompanyBank.IBAN;
                        "Agency Code" := CompanyBank."SSA Agency";
                        "RIB Key" := CompanyBank."SSA RIB Key";
                        "RIB Checked" := CompanyBank."SSA RIB Checked";
                        "Bank Name" := CompanyBank."Search Name";
                        "Bank Post Code" := CompanyBank."Post Code";
                        "Bank City" := CompanyBank.City;
                        "Bank Name 2" := CompanyBank."Name 2";
                        "Bank Address" := CompanyBank.Address;
                        "Bank Address 2" := CompanyBank."Address 2";
                        "From payment No." := CompanyBank."SSA From Payment No.";
                    END ELSE
                        InitBankAccount;
                END ELSE
                    InitBankAccount;


                //SSM729>>
                CASE "Account Type" OF
                    "Account Type"::Customer:
                        CreateDim(
                          DATABASE::Customer, "Account No.");
                    "Account Type"::Vendor:
                        CreateDim(
                          DATABASE::Vendor, "Account No.");
                    "Account Type"::"Fixed Asset":
                        CreateDim(
                          DATABASE::"Fixed Asset", "Account No.");
                    "Account Type"::"G/L Account":
                        CreateDim(
                          DATABASE::"G/L Account", "Account No.");
                    "Account Type"::"Bank Account":
                        CreateDim(
                          DATABASE::"Bank Account", "Account No.");
                END;
                //SSM729<<
            end;
        }
        field(16; "Amount (LCY)"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("SSA Payment Line"."Amount (LCY)" WHERE("No." = FIELD("No.")));
            Caption = 'Total Amount (LCY)';
            Editable = false;

        }
        field(17; Amount; Decimal)
        {
            CalcFormula = Sum("SSA Payment Line".Amount WHERE("No." = FIELD("No.")));
            Caption = 'Amount';
            Editable = false;
            FieldClass = FlowField;
        }
        field(18; "Bank Branch No."; Text[20])
        {
            Caption = 'Bank Branch No.';

            trigger OnValidate()
            begin
                "RIB Checked" := Check("Bank Branch No.", "Agency Code", "Bank Account No.", "RIB Key");
            end;
        }
        field(19; "Bank Account No."; Text[30])
        {
            Caption = 'Bank Account No.';

            trigger OnValidate()
            begin
                "RIB Checked" := Check("Bank Branch No.", "Agency Code", "Bank Account No.", "RIB Key");
            end;
        }
        field(20; "Agency Code"; Text[20])
        {
            Caption = 'Agency Code';

            trigger OnValidate()
            begin
                "RIB Checked" := Check("Bank Branch No.", "Agency Code", "Bank Account No.", "RIB Key");
            end;
        }
        field(21; "RIB Key"; Integer)
        {
            Caption = 'RIB Key';

            trigger OnValidate()
            begin
                "RIB Checked" := Check("Bank Branch No.", "Agency Code", "Bank Account No.", "RIB Key");
            end;
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

            trigger OnLookup()
            begin
                //PostCode.LookUpPostCode("Bank City","Bank Post Code",TRUE);
            end;

            trigger OnValidate()
            begin
                //PostCode.ValidatePostCode("Bank City","Bank Post Code");
            end;
        }
        field(25; "Bank City"; Text[30])
        {
            Caption = 'Bank City';

            trigger OnLookup()
            begin
                //PostCode.LookUpPostCode("Bank City","Bank Post Code",TRUE);
            end;

            trigger OnValidate()
            begin
                //PostCode.ValidatePostCode("Bank City","Bank Post Code");
            end;
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
            Caption = 'Country/Region Code';
            TableRelation = "Country/Region";
        }
        field(32; "From payment No."; Code[6])
        {
            Caption = 'From payment No.';
            Numeric = true;
        }
        field(40; Parameter; Boolean)
        {
            Caption = 'Parameter';
            Editable = false;
        }
        field(41; "Nb of lines"; Integer)
        {
            CalcFormula = Count("SSA Payment Line" WHERE("No." = FIELD("No.")));
            Caption = 'Nb of lines';
            Editable = false;
            FieldClass = FlowField;
        }
        field(42; "Lines not Posted"; Integer)
        {
            CalcFormula = Count("SSA Payment Line" WHERE("No." = FIELD("No."), Posted = CONST(false)));
            Caption = 'Lines not Posted';
            Editable = false;
            FieldClass = FlowField;
        }
        field(43; "Archiving authorized"; Boolean)
        {
            CalcFormula = Lookup("SSA Payment Status"."Archiving authorized" WHERE("Payment Class" = FIELD("Payment Class"), Line = FIELD("Status No.")));
            Caption = 'Archiving authorized';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50000; "Payment Series"; Code[20])
        {
            Caption = 'Payment Series';
            Description = 'SSM729';
        }
        field(50010; "Payment Number"; Code[20])
        {
            Caption = 'Payment Number';
            Description = 'SSM729';
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
            CalcFormula = Exist("SSA Payment Line" WHERE("No." = FIELD("No."), "Status Aplicare" = FILTER(Neaplicat | ' ')));
            Description = 'SSM729';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50050; "Suma Aplicata"; Decimal)
        {
            CalcFormula = Sum("SSA Pmt. Tools AppLedg. Entry".Amount WHERE("Payment Document No." = FIELD("No.")));
            Description = 'SSM729';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50060; "Line Account No."; Code[20])
        {
            CalcFormula = Lookup("SSA Payment Line"."Account No." WHERE("No." = FIELD("No.")));
            Caption = 'Line Account No.';
            Description = 'SSM729';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50070; "Line Account Type"; Option)
        {
            CalcFormula = Lookup("SSA Payment Line"."Account Type" WHERE("No." = FIELD("No.")));
            Caption = 'Line Account Type';
            Description = 'SSM729';
            Editable = false;
            FieldClass = FlowField;
            OptionCaption = 'G/L Account,Customer,Vendor,Bank Account,Fixed Asset';
            OptionMembers = "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset";

            trigger OnValidate()
            begin
                IF "Account Type" <> xRec."Account Type" THEN BEGIN
                    VALIDATE("Account No.", '');
                    DimensionDelete;
                END;
            end;
        }
        field(50080; "Customer Name"; Text[100])
        {
            CalcFormula = Lookup(Customer.Name WHERE("No." = FIELD("Line Account No.")));
            Caption = 'Customer Name';
            Description = 'SSM845';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50090; "Vendor Name"; Text[100])
        {
            CalcFormula = Lookup(Vendor.Name WHERE("No." = FIELD("Line Account No.")));
            Caption = 'Vendor Name';
            Description = 'SSM845';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50100; "Due Date"; Date)
        {
            CalcFormula = Min("SSA Payment Line"."Due Date" WHERE("No." = FIELD("No.")));
            Caption = 'Due Date';
            Description = 'HD819';
            Editable = false;
            FieldClass = FlowField;
        }
        field(45007654; Girat; Boolean)
        {
            Caption = 'Endorsed';
        }
        field(45007655; "Cashed Amount"; Decimal)
        {
            CalcFormula = Sum("SSA Payment Line"."Cashed Amount" WHERE("No." = FIELD("No.")));
            Caption = 'Cashed Amount';
            Editable = false;
            FieldClass = FlowField;
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
        key(Key3; "Payment Series", "Payment Number")
        {
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "No.", "Status Name", "Payment Series", "Payment Number", "Amount (LCY)")
        {
        }
    }

    trigger OnDelete()
    begin
        IF "Status No." > 0 THEN
            ERROR(Text000);

        RegLine.SETRANGE(RegLine."No.", "No.");
        RegLine.SETFILTER("Copied To No.", '<>''''');
        IF RegLine.FIND('-') THEN
            ERROR(Text000);
        RegLine.SETRANGE("Copied To No.");
        RegLine.DELETEALL(TRUE);
    end;

    trigger OnInsert()
    begin
        IF "No." = '' THEN BEGIN
            IF PAGE.RUNMODAL(PAGE::"SSA Payment Class List", GetProcess) = ACTION::LookupOK THEN
                Process := GetProcess;
            Process.TESTFIELD("Header No. Series");
            NoSeriesMgt.InitSeries(Process."Header No. Series", xRec."No. Series", 0D, "No.", "No. Series");
            VALIDATE("Payment Class", Process.Code);
        END;
        InitHeader;
    end;

    var
        Text000: Label 'Deleting not allowed';
        Text001: Label 'There is no line to treat';
        Text002: Label 'You cannot modify Currency Code because the Payment Header contains lines';
        Text003: Label 'Payment';
        ReglHeader: Record "SSA Payment Header";
        GetProcess: Record "SSA Payment Class";
        CurrExchRate: Record "Currency Exchange Rate";
        RegLine: Record "SSA Payment Line";
        CompanyBank: Record "Bank Account";
        PostCode: Record "Post Code";
        DefaultDimension: Record "Default Dimension";
        Process: Record "SSA Payment Class";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        DimManagement: Codeunit DimensionManagement;
        DimMgt: Codeunit DimensionManagement;
        ListeProcess: Page "SSA Payment Class List";
        CurrencyDate: Date;
        Text004: Label 'You have changed a dimension.\\';
        Text005: Label 'Do you want to update the lines?';
        ConfirmDialog: Boolean;
        DoOperation: Boolean;
        Text006: Label 'The document''s currency code is the LCY Code.\\You can only choose a bank which currency code is the LCY Code.';
        Text007: Label 'The document''s currency code is %1.\\You can only choose a bank which currency code is %1 or the LCY Code.';
        Text008: Label 'Your bank''s currency code is %1.\\You must change the bank account code before modifying the currency code.';
        Coding: Label 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
        Uncoding: Label '12345678912345678923456789';
        Text50000: Label 'Your identification is set up to process from %1 %2 only.';
        Text50002: Label 'You may have changed a dimension.\\Do you want to update the lines?';

    procedure LookupShortcutDimCode(FieldNo: Integer; var ShortcutDimCode: Code[20])
    begin
        DimManagement.LookupDimValueCode(FieldNo, ShortcutDimCode);
        /*IF "No." <> '' THEN
          DimManagement.SaveDocDim(
            DATABASE::"SSA Payment Header",6,"No.",0,FieldNo,ShortcutDimCode)
        ELSE
          DimManagement.SaveTempDim(FieldNo,ShortcutDimCode);
         */

    end;

    procedure ValidateShortcutDimCode(FieldNo: Integer; var ShortcutDimCode: Code[20])
    var
        OldDimSetID: Integer;
    begin
        OldDimSetID := "Dimension Set ID";
        DimMgt.ValidateShortcutDimValues(FieldNo, ShortcutDimCode, "Dimension Set ID");
        IF "No." <> '' THEN
            MODIFY;

        IF OldDimSetID <> "Dimension Set ID" THEN BEGIN
            MODIFY;
            IF PaymentLinesExist THEN
                UpdateAllLineDim("Dimension Set ID", OldDimSetID);
        END;
    end;

    procedure AssistEdit(OldReglHeader: Record "SSA Payment Header"): Boolean
    begin
        WITH ReglHeader DO BEGIN
            ReglHeader := Rec;
            Process := GetProcess;

            Process.TESTFIELD("Header No. Series");
            IF NoSeriesMgt.SelectSeries(Process."Header No. Series", OldReglHeader."No. Series", "No. Series") THEN BEGIN
                Process := GetProcess;

                Process.TESTFIELD("Header No. Series");
                NoSeriesMgt.SetSeries("No.");
                Rec := ReglHeader;
                EXIT(TRUE);
            END;
        END;
    end;

    local procedure UpdateCurrencyFactor()
    begin
        IF "Currency Code" <> '' THEN BEGIN
            CurrencyDate := WORKDATE;
            "Currency Factor" := CurrExchRate.ExchangeRate(CurrencyDate, "Currency Code");
        END ELSE
            "Currency Factor" := 1;
    end;

    local procedure ConfirmUpdateCurrencyFactor()
    begin
        /*IF HideValidationDialog THEN
          Confirmed := TRUE
        ELSE
        
          Confirmed := CONFIRM(Text021,FALSE);
        IF Confirmed THEN
          VALIDATE("Currency Factor")
        ELSE
        */
        "Currency Factor" := xRec."Currency Factor";

    end;

    procedure InitBankAccount()
    begin
        "Bank Branch No." := '';
        "Bank Account No." := '';
        "Agency Code" := '';
        "RIB Key" := 0;
        "RIB Checked" := FALSE;
        "Bank Name" := '';
        "Bank Post Code" := '';
        "Bank City" := '';
        "Bank Name 2" := '';
        "Bank Address" := '';
        "Bank Address 2" := '';
        "Bank Contact" := '';
        "Bank County" := '';
        "Bank Country/Region Code" := '';
        "From payment No." := '';
    end;

    procedure TestNbOfLines()
    begin
        CALCFIELDS("Nb of lines");
        IF "Nb of lines" = 0 THEN
            ERROR(Text001);
    end;

    procedure InitHeader()
    var
        CompanyInformation: Record "Company Information";
    begin
        "Posting Date" := WORKDATE;
        "Document Date" := WORKDATE;
        VALIDATE("Account Type", "Account Type"::"Bank Account");
        /*
        CompanyInformation.GET;
        VALIDATE("Account No.", CompanyInformation."Default Bank Account No.");
        */

    end;

    procedure DimensionSetup()
    var
        PaymentManagement: Codeunit "SSA Payment Management";
    begin
        CLEAR(DefaultDimension);
        DimensionCreate;
    end;

    procedure DimensionCreate()
    var
        TableID: array[10] of Integer;
        No: array[10] of Code[20];
        PaymentManagement: Codeunit "SSA Payment Management";
    begin
        /*TableID[1] := DimManagement.TypeToTableID1("Account Type");
        No[1] := "Account No.";
        "Shortcut Dimension 1 Code" := '';
        "Shortcut Dimension 2 Code" := '';
        DimManagement.GetDefaultDim(
          TableID,No,"Source Code",
          "Shortcut Dimension 1 Code","Shortcut Dimension 2 Code");
        IF "No." <> '' THEN
          DimManagement.UpdateDocDefaultDim(
            DATABASE::"SSA Payment Header",6,"No.",0,
            "Shortcut Dimension 1 Code","Shortcut Dimension 2 Code");
        
        DocumentDimension.SETRANGE("Table ID",DATABASE::"SSA Payment Header");
        DocumentDimension.SETRANGE("Document Type",DocumentDimension."Document Type"::" ");
        DocumentDimension.SETRANGE("Document No.","No.");
        IF DocumentDimension.FIND('-') THEN
          REPEAT
            UpdateLineDim(DocumentDimension);
            ConfirmDialog := FALSE;
          UNTIL DocumentDimension.NEXT = 0;    */

    end;

    procedure DimensionDelete()
    begin
        /*ConfirmDialog := TRUE;
        WITH DocumentDimension DO BEGIN
          SETRANGE("Table ID", DATABASE::"SSA Payment Header");
          SETRANGE("Document Type", DocumentDimension."Document Type"::" ");
          SETRANGE("Document No.", "No.");
          SETRANGE("Line No.", 0);
          IF FIND('-') THEN
            REPEAT
              Rec.DeleteLineDim(DocumentDimension);
              ConfirmDialog := FALSE;
              DELETE;
            UNTIL NEXT = 0;
        END;
        "Shortcut Dimension 1 Code" := '';
        "Shortcut Dimension 2 Code" := '';
        */

    end;

    procedure DeleteLineDim()
    begin
        /*RegLine.SETRANGE("No.","No.");
        IF NOT RegLine.FIND('-') THEN
          EXIT;
        IF ConfirmDialog THEN
          DoOperation := CONFIRM(Text004+Text005);
        WITH DeleteDocDim DO BEGIN
          SETRANGE("Table ID",DATABASE::"Payment Line");
          SETRANGE("Document Type",DocumentDimension."Document Type");
          SETRANGE("Document No.",DocumentDimension."Document No.");
          SETRANGE("Dimension Code",DocumentDimension."Dimension Code");
          IF DoOperation AND FIND('-') THEN
            DeleteDocDim.DELETE;
        END;*/

    end;

    procedure UpdateLineDim()
    begin
        /*RegLine.SETRANGE("No.","No.");
        IF NOT RegLine.FIND('-') THEN
          EXIT;
        IF ConfirmDialog THEN
          DoOperation := CONFIRM(Text004+Text005);
        IF DoOperation THEN
          WITH NewDocDim DO BEGIN
            "Table ID" := DATABASE::"Payment Line";
            "Document Type" := DocumentDimension."Document Type";
            "Document No." := DocumentDimension."Document No.";
            "Dimension Code" := DocumentDimension."Dimension Code";
            "Dimension Value Code" := DocumentDimension."Dimension Value Code";
            IF RegLine.FIND('-') THEN
              REPEAT
                NewDocDim."Line No." := RegLine."Line No.";
                IF NOT NewDocDim.MODIFY THEN
                  NewDocDim.INSERT(TRUE);
              UNTIL RegLine.NEXT = 0;
          END;
         */

    end;

    procedure Check(Bank: Text[20]; Agency: Text[20]; Account: Text[30]; RIBKey: Integer): Boolean
    var
        LongAccountNum: Code[30];
        Index: Integer;
        Remaining: Integer;
    begin
        IF NOT ((STRLEN(Bank) = 5) AND
               (STRLEN(Agency) = 5) AND
               (STRLEN(Account) = 11) AND
               (RIBKey < 100)) THEN
            EXIT(FALSE);

        LongAccountNum := Bank + Agency + Account + CONVERTSTR(FORMAT(RIBKey, 2), ' ', '0');
        LongAccountNum := CONVERTSTR(LongAccountNum, Coding, Uncoding);

        Remaining := 0;
        FOR Index := 1 TO 23 DO
            Remaining := (Remaining * 10 + (LongAccountNum[Index] - '0')) MOD 97;

        EXIT(Remaining = 0);
    end;

    procedure CreateDim(Type1: Integer; No1: Code[20])
    var
        SourceCodeSetup: Record "Source Code Setup";
        TableID: array[10] of Integer;
        No: array[10] of Code[20];
        OldDimSetID: Integer;
    begin
        //SSM729>>
        SourceCodeSetup.GET;
        TableID[1] := Type1;
        No[1] := No1;
        // TableID[2] := Type2;
        // No[2] := No2;

        "Shortcut Dimension 1 Code" := '';
        "Shortcut Dimension 2 Code" := '';
        OldDimSetID := "Dimension Set ID";
        "Dimension Set ID" :=
          DimMgt.GetDefaultDimID(TableID, No, SourceCodeSetup.Sales, "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code", 0, 0);

        IF (OldDimSetID <> "Dimension Set ID") AND PaymentLinesExist THEN BEGIN
            MODIFY;
            UpdateAllLineDim("Dimension Set ID", OldDimSetID);
        END;
        //SSM729<<
    end;

    procedure PaymentLinesExist(): Boolean
    var
        PaymentLine: Record "SSA Payment Line";
    begin
        //SSM729>>
        PaymentLine.RESET;
        PaymentLine.SETRANGE("No.", "No.");
        EXIT(PaymentLine.FINDFIRST);
        //SSM729<<
    end;

    local procedure UpdateAllLineDim(NewParentDimSetID: Integer; OldParentDimSetID: Integer)
    var
        PaymentLine: Record "SSA Payment Line";
        NewDimSetID: Integer;
    begin
        // Update all lines with changed dimensions.
        //SSM729>>

        IF NewParentDimSetID = OldParentDimSetID THEN
            EXIT;
        IF GUIALLOWED THEN
            IF NOT CONFIRM(Text50002) THEN
                EXIT;

        PaymentLine.RESET;
        PaymentLine.SETRANGE("No.", "No.");
        PaymentLine.LOCKTABLE;
        IF PaymentLine.FIND('-') THEN
            REPEAT
                NewDimSetID := DimMgt.GetDeltaDimSetID(PaymentLine."Dimension Set ID", NewParentDimSetID, OldParentDimSetID);
                IF PaymentLine."Dimension Set ID" <> NewDimSetID THEN BEGIN
                    PaymentLine."Dimension Set ID" := NewDimSetID;

                    DimMgt.UpdateGlobalDimFromDimSetID(
                      PaymentLine."Dimension Set ID", PaymentLine."Shortcut Dimension 1 Code", PaymentLine."Shortcut Dimension 2 Code");

                    PaymentLine.MODIFY;
                END;
            UNTIL PaymentLine.NEXT = 0;
        //SSM729<<
    end;

    procedure ShowDocDim()
    var
        OldDimSetID: Integer;
    begin
        //SSM729>>
        OldDimSetID := "Dimension Set ID";
        "Dimension Set ID" :=
          DimMgt.EditDimensionSet(
            "Dimension Set ID", STRSUBSTNO('%1', "No."),
            "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code");
        IF OldDimSetID <> "Dimension Set ID" THEN BEGIN
            MODIFY;
            IF PaymentLinesExist THEN
                UpdateAllLineDim("Dimension Set ID", OldDimSetID);
        END;
        //SSM729<<
    end;
}

