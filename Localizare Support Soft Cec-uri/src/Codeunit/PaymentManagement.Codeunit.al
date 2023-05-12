codeunit 70500 "SSA Payment Management"
{
    // SSM729 SSCAT 22.06.2018 Nr.crt.76-Limita valorica pentru instrumente de plata neincasate- fin

    Permissions = TableData "Cust. Ledger Entry" = rm,
                  TableData "Vendor Ledger Entry" = rm;

    trigger OnRun()
    begin
        CreatePaymentHeaders;
    end;

    var
        Text001: Label 'The number %1 cannot be extended to more than 20 characters.';
        Text002: Label 'One or more Acceptation Code value is ''No''';
        Text003: Label 'One or more line has an incorrect RIB code';
        Text004: Label 'No Payment Header to create';
        Text005: Label 'Ledger Posting';
        Text006: Label 'One or more Due Date value are empty';
        Text007: Label 'The action has been cancelled';
        Text008: Label 'The header RIB is not correct';

        InvPostingBuffer: array[2] of Record "SSA Payment Post. Buffer";

        CustomerPostingGroup: Record "Customer Posting Group";
        VendorPostingGroup: Record "Vendor Posting Group";
        Customer: Record Customer;
        Vendor: Record Vendor;
        N: Integer;
        Suffix: Text[2];
        CustLedgerEntry: Record "Cust. Ledger Entry";
        VendorLedgerEntry: Record "Vendor Ledger Entry";
        EntryTypeDebit: Option;
        EntryNoAccountDebit: Code[20];
        EntryPostGroupDebit: Code[20];
        EntryTypeCredit: Option;
        EntryNoAccountCredit: Code[20];
        EntryPostGroupCredit: Code[10];
        GenJnlLine: Record "Gen. Journal Line";
        GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line";
        PaymentLine: Record "SSA Payment Line";
        OldPaymentLine: Record "SSA Payment Line";
        StepLedger: Record "SSA Payment Step Ledger";
        Step: Record "SSA Payment Step";
        PaymentHeader: Record "SSA Payment Header";
        GLEntryNoTmp: Integer;
        Text011: Label 'XX';
        Text012: Label 'The Customer Posting Group %1 doesn''t exists.';
        Text013: Label 'The Vendor Posting Group %1 doesn''t exists.';
        Text014: Label 'You must put an general account no. for the customer posting group %1.';
        Text015: Label 'You must put an general account no. for the vendor posting group %1.';
        Text016: Label 'A posted line cannot be deleted.';
        Text017: Label 'The Source Code "%1" doesn''t exists.';
        HeaderAccountUsedGlobally: Boolean;
        Text018: Label 'You must precise an account no. for the Debit for the step "%1" of the payment type "%2".';
        Text019: Label 'You must precise an account no. for the Credit for the step "%1" of the payment type "%2".';
        Text020: Label 'You must precise an account no. in the Payment header.';
        Text021: Label 'The code "%1" doesn''t contain any number.';
        Text022: Label 'The status of the document "%1" does not authorize the archive.';
        Text023: Label 'Create a new Payment Header?';
        Text50000: Label 'Inregistrarea %1 a fost anulata. Trebuie sa creati storno!';

    procedure Valbord(PaymentHeaderParameter: Record "SSA Payment Header"; StepParameter: Record "SSA Payment Step")
    var
        Window: Dialog;
        PaymentHeader2: Record "SSA Payment Header";
        ActionValidated: Boolean;
        PaymentStatus: Record "SSA Payment Status";
        NewPaymentHeader: Record "SSA Payment Header";
    begin
        PaymentHeader.GET(PaymentHeaderParameter."No.");

        IF StepParameter."Verify Header RIB" AND NOT PaymentHeader."RIB Checked" THEN
            ERROR(Text008);

        PaymentLine.SETRANGE("No.", PaymentHeader."No.");
        PaymentLine.SETRANGE("Copied To No.", '');

        IF StepParameter."Acceptation Code<>No" THEN BEGIN
            PaymentLine.SETRANGE("Acceptation Code", PaymentLine."Acceptation Code"::No);
            IF PaymentLine.FIND('-') THEN
                ERROR(Text002);
            PaymentLine.SETRANGE("Acceptation Code");
        END;

        IF StepParameter."Verify Lines RIB" THEN BEGIN
            PaymentLine.SETRANGE("RIB Checked", FALSE);
            IF PaymentLine.FIND('-') THEN
                ERROR(Text003);
            PaymentLine.SETRANGE("RIB Checked");
        END;

        IF StepParameter."Verify Due Date" THEN BEGIN
            PaymentLine.SETRANGE("Due Date", 0D);
            IF PaymentLine.FIND('-') THEN
                ERROR(Text006);
            PaymentLine.SETRANGE("Due Date");
        END;

        Step.GET(StepParameter."Payment Class", StepParameter.Line);

        CASE Step."Action Type" OF
            Step."Action Type"::None:
                ActionValidated := TRUE;
            Step."Action Type"::File:
                BEGIN
                    PaymentHeader2.SETRANGE("No.", PaymentHeader."No.");
                    PaymentHeader.Parameter := FALSE;
                    PaymentHeader.MODIFY;
                    COMMIT;
                    REPORT.RUNMODAL(Step."Dataport No.", TRUE, TRUE, PaymentHeader2);
                    PaymentHeader.GET(PaymentHeaderParameter."No.");
                    ActionValidated := PaymentHeader.Parameter;
                END;
            Step."Action Type"::Report:
                BEGIN
                    REPORT.RUNMODAL(Step."Report No.", TRUE, TRUE, PaymentLine);
                    ActionValidated := TRUE;
                END;
            Step."Action Type"::Ledger:
                BEGIN
                    InvPostingBuffer[1].DELETEALL;
                    CopyAndCheckDocDimToTempDocDim;
                    Window.OPEN(
                      '#1#################################\\' +
                      Text005);
                    //SSM729>>
                    PaymentHeader.CALCFIELDS(Amount, "Suma Aplicata");
                    PaymentHeader.TESTFIELD(Amount, -PaymentHeader."Suma Aplicata");
                    //SSM729<<
                    IF PaymentLine.FIND('-') THEN
                        REPEAT
                            Window.UPDATE(1, Text005 + ' ' + PaymentLine."No." + ' ' + FORMAT(PaymentLine."Line No."));
                            OldPaymentLine := PaymentLine;
                            HeaderAccountUsedGlobally := FALSE;
                            GenerInvPostingBuffer;
                            PaymentLine."Acc. Type last entry Debit" := EntryTypeDebit;
                            PaymentLine."Acc. No. Last entry Debit" := EntryNoAccountDebit;
                            PaymentLine."P. Group Last Entry Debit" := EntryPostGroupDebit;
                            PaymentLine."Acc. Type last entry Credit" := EntryTypeCredit;
                            PaymentLine."Acc. No. Last entry Credit" := EntryNoAccountCredit;
                            PaymentLine."P. Group Last Entry Credit" := EntryPostGroupCredit;
                            PaymentLine.VALIDATE("Status No.", Step."Next Status");
                            PaymentLine.Posted := TRUE;
                            PaymentLine.MODIFY;
                        UNTIL PaymentLine.NEXT = 0;
                    Window.CLOSE;
                    GenerEntries;
                    ActionValidated := TRUE;
                END;
        END;

        IF ActionValidated THEN BEGIN
            PaymentHeader.VALIDATE("Status No.", Step."Next Status");
            PaymentHeader.MODIFY;
            PaymentLine.SETRANGE("No.", PaymentHeader."No.");
            IF PaymentLine.FINDFIRST THEN
                REPEAT
                    PaymentLine.VALIDATE("Status No.", Step."Next Status");
                    PaymentLine.MODIFY;
                UNTIL PaymentLine.NEXT = 0;
            //SSM729>>
            IF Step."Tip Detalii Aplicari" = Step."Tip Detalii Aplicari"::"Suma Aplicata" THEN
                CreazaLiniiAplicare(PaymentHeader, TRUE, 0);
            IF Step."Tip Detalii Aplicari" = Step."Tip Detalii Aplicari"::"Suma Dezaplicata" THEN
                CreazaLiniiAplicare(PaymentHeader, FALSE, 0);
            PaymentStatus.GET(PaymentHeader."Payment Class", PaymentHeader."Status No.");
            IF PaymentStatus."Auto Archive" THEN
                ArchiveDocument(PaymentHeader);

            IF PaymentStatus."Canceled/Refused" THEN BEGIN
                COMMIT;
                MESSAGE(Text50000, PaymentHeader."No.");
                NewPaymentHeader.INIT;
                NewPaymentHeader."No." := '';
                NewPaymentHeader.INSERT(TRUE);
                PAGE.RUN(PAGE::"SSA Payment Headers", NewPaymentHeader);
            END;
            //SSM729<<
        END ELSE
            MESSAGE(Text007);
    end;

    procedure UpdtBuffer()
    var
        EntryNo: Integer;
    begin
        /*IF TempDocDim.FIND('-') THEN
          REPEAT
            TempDimBuf."Table ID" := TempDocDim."Table ID";
            TempDimBuf."Dimension Code" := TempDocDim."Dimension Code";
            TempDimBuf."Dimension Value Code" := TempDocDim."Dimension Value Code";
            TempDimBuf.INSERT;
          UNTIL TempDocDim.NEXT = 0;
        EntryNo := DimBufMgt.FindDimensions(TempDimBuf);
        IF EntryNo = 0 THEN
          EntryNo := DimBufMgt.InsertDimensions(TempDimBuf);*/
        InvPostingBuffer[1]."Dimension Entry No." := EntryNo;

        InvPostingBuffer[2] := InvPostingBuffer[1];
        IF InvPostingBuffer[2].FIND THEN BEGIN
            InvPostingBuffer[2].VALIDATE(Amount, InvPostingBuffer[2].Amount + InvPostingBuffer[1].Amount);
            InvPostingBuffer[2].VALIDATE("Amount (LCY)", InvPostingBuffer[2]."Amount (LCY)" + InvPostingBuffer[1]."Amount (LCY)");
            InvPostingBuffer[2]."VAT Amount" :=
              InvPostingBuffer[2]."VAT Amount" + InvPostingBuffer[1]."VAT Amount";
            InvPostingBuffer[2]."Line Discount Amount" :=
              InvPostingBuffer[2]."Line Discount Amount" + InvPostingBuffer[1]."Line Discount Amount";
            IF InvPostingBuffer[1]."Line Discount Account" <> '' THEN
                InvPostingBuffer[2]."Line Discount Account" := InvPostingBuffer[1]."Line Discount Account";
            InvPostingBuffer[2]."Inv. Discount Amount" :=
              InvPostingBuffer[2]."Inv. Discount Amount" + InvPostingBuffer[1]."Inv. Discount Amount";
            IF InvPostingBuffer[1]."Inv. Discount Account" <> '' THEN
                InvPostingBuffer[2]."Inv. Discount Account" := InvPostingBuffer[1]."Inv. Discount Account";
            InvPostingBuffer[2]."VAT Base Amount" :=
              InvPostingBuffer[2]."VAT Base Amount" + InvPostingBuffer[1]."VAT Base Amount";
            InvPostingBuffer[2]."Amount (ACY)" :=
              InvPostingBuffer[2]."Amount (ACY)" + InvPostingBuffer[1]."Amount (ACY)";
            InvPostingBuffer[2]."VAT Amount (ACY)" :=
              InvPostingBuffer[2]."VAT Amount (ACY)" + InvPostingBuffer[1]."VAT Amount (ACY)";
            InvPostingBuffer[2]."VAT Difference" :=
              InvPostingBuffer[2]."VAT Difference" + InvPostingBuffer[1]."VAT Difference";
            InvPostingBuffer[2]."Line Discount Amt. (ACY)" :=
              InvPostingBuffer[2]."Line Discount Amt. (ACY)" +
              InvPostingBuffer[1]."Line Discount Amt. (ACY)";
            InvPostingBuffer[2]."Inv. Discount Amt. (ACY)" :=
              InvPostingBuffer[2]."Inv. Discount Amt. (ACY)" +
              InvPostingBuffer[1]."Inv. Discount Amt. (ACY)";
            InvPostingBuffer[2]."VAT Base Amount (ACY)" :=
              InvPostingBuffer[2]."VAT Base Amount (ACY)" +
              InvPostingBuffer[1]."VAT Base Amount (ACY)";
            InvPostingBuffer[2].Quantity :=
              InvPostingBuffer[2].Quantity + InvPostingBuffer[1].Quantity;
            IF NOT InvPostingBuffer[1]."System-Created Entry" THEN
                InvPostingBuffer[2]."System-Created Entry" := FALSE;
            InvPostingBuffer[2].MODIFY;
        END ELSE BEGIN
            GLEntryNoTmp += 1;
            InvPostingBuffer[1]."GL Entry No." := GLEntryNoTmp;
            InvPostingBuffer[1].INSERT;
        END;

    end;

    procedure CopyLigBor(var FromPaymentLine: Record "SSA Payment Line"; "New Step": Integer; var PayNum: Code[20])
    var
        ToBord: Record "SSA Payment Header";
        ToPaymentLine: Record "SSA Payment Line";
        Step: Record "SSA Payment Step";
        i: Integer;
        NoSeriesMgt: Codeunit NoSeriesManagement;
        Process: Record "SSA Payment Class";
        PaymentStatus: Record "SSA Payment Status";
    begin
        FromPaymentLine.MARKEDONLY(TRUE);
        IF NOT FromPaymentLine.FIND('-') THEN
            FromPaymentLine.MARKEDONLY(FALSE);
        IF FromPaymentLine.FIND('-') THEN BEGIN
            Step.GET(FromPaymentLine."Payment Class", "New Step");
            Process.GET(FromPaymentLine."Payment Class");
            IF PayNum = '' THEN
                WITH ToBord DO BEGIN
                    i := 10000;
                    NoSeriesMgt.InitSeries(Step."Header Nos. Series", "No. Series", 0D, "No.", "No. Series");
                    "Payment Class" := FromPaymentLine."Payment Class";
                    VALIDATE("Status No.", Step."Next Status");
                    PaymentStatus.GET("Payment Class", "Status No.");
                    "Archiving authorized" := PaymentStatus."Archiving authorized";
                    "Currency Code" := FromPaymentLine."Currency Code";
                    "Currency Factor" := FromPaymentLine."Currency Factor";
                    InitHeader;
                    INSERT;
                END ELSE BEGIN
                ToBord.GET(PayNum);
                ToPaymentLine.SETRANGE("No.", PayNum);
                IF ToPaymentLine.FIND('+') THEN
                    i := ToPaymentLine."Line No." + 10000
                ELSE
                    i := 10000;
            END;
            REPEAT
                ToPaymentLine.COPY(FromPaymentLine);
                ToPaymentLine."No." := ToBord."No.";
                ToPaymentLine."Line No." := i;
                ToPaymentLine.IsCopy := TRUE;
                ToPaymentLine.VALIDATE("Status No.", Step."Next Status");
                ToPaymentLine."Copied To No." := '';
                ToPaymentLine."Copied To Line" := 0;
                ToPaymentLine.Posted := FALSE;
                ToPaymentLine.INSERT(TRUE);
                FromPaymentLine."Copied To No." := ToPaymentLine."No.";
                FromPaymentLine."Copied To Line" := ToPaymentLine."Line No.";
                /*DocDim.SETRANGE("Table ID",DATABASE::"Payment Line");
                DocDim.SETRANGE("Document Type",DocDim."Document Type"::" ");
                DocDim.SETRANGE("Document No.",FromPaymentLine."No.");
                DocDim.SETRANGE("Line No.",FromPaymentLine."Line No.");
                DimManagement.MoveDocDimToDocDim(DocDim,DATABASE::"Payment Line",ToBord."No.",DocDim."Document Type"::" ",i);*/
                FromPaymentLine.MODIFY;
                i += 10000;
            UNTIL FromPaymentLine.NEXT = 0;
            PayNum := ToBord."No.";
        END;

    end;

    procedure DeleteLigBorCopy(var FromPaymentLine: Record "SSA Payment Line")
    var
        ToPaymentLine: Record "SSA Payment Line";
    begin
        FromPaymentLine.MARKEDONLY(TRUE);
        ToPaymentLine.SETCURRENTKEY("Copied To No.", "Copied To Line");

        IF FromPaymentLine.FIND('-') THEN
            IF FromPaymentLine.Posted THEN
                MESSAGE(Text016)
            ELSE
                REPEAT
                    ToPaymentLine.SETRANGE("Copied To No.", FromPaymentLine."No.");
                    ToPaymentLine.SETRANGE("Copied To Line", FromPaymentLine."Line No.");
                    ToPaymentLine.FIND('-');
                    ToPaymentLine."Copied To No." := '';
                    ToPaymentLine."Copied To Line" := 0;
                    ToPaymentLine.MODIFY;
                    FromPaymentLine.DELETE(TRUE);
                UNTIL FromPaymentLine.NEXT = 0;
    end;

    procedure GenerInvPostingBuffer()
    var
        NoSeriesMgt: Codeunit NoSeriesManagement;
        PaymentClass: Record "SSA Payment Class";
        PartnerName: text[100];
        Customer: Record Customer;
        Vendor: Record Vendor;
    begin
        StepLedger.SETRANGE("Payment Class", Step."Payment Class");
        StepLedger.SETRANGE(Line, Step.Line);

        IF StepLedger.FIND('-') THEN BEGIN
            REPEAT
                CLEAR(InvPostingBuffer[1]);
                SetPostingGroup;
                SetAccountNo;
                InvPostingBuffer[1]."System-Created Entry" := TRUE;
                IF (StepLedger.Sign = StepLedger.Sign::Debit) THEN BEGIN
                    InvPostingBuffer[1].VALIDATE(Amount, ABS(PaymentLine.Amount));
                    InvPostingBuffer[1].VALIDATE("Amount (LCY)", ABS(PaymentLine."Amount (LCY)"));
                END ELSE BEGIN
                    InvPostingBuffer[1].VALIDATE(Amount, ABS(PaymentLine.Amount) * -1);
                    InvPostingBuffer[1].VALIDATE("Amount (LCY)", ABS(PaymentLine."Amount (LCY)") * -1);
                END;
                InvPostingBuffer[1]."Currency Code" := PaymentLine."Currency Code";
                InvPostingBuffer[1]."Currency Factor" := PaymentLine."Currency Factor";
                InvPostingBuffer[1].Correction := PaymentLine.Correction XOR Step.Correction;
                IF (StepLedger."Detail Level" = StepLedger."Detail Level"::Line) THEN
                    InvPostingBuffer[1]."Payment Line No." := PaymentLine."Line No."
                ELSE
                    IF (StepLedger."Detail Level" = StepLedger."Detail Level"::"Due Date") THEN
                        InvPostingBuffer[1]."Due Date" := PaymentLine."Due Date";

                InvPostingBuffer[1]."Document Type" := StepLedger."Document Type";
                IF StepLedger."Document No." = StepLedger."Document No."::"Header No." THEN
                    InvPostingBuffer[1]."Document No." := PaymentHeader."No."
                ELSE BEGIN
                    IF (InvPostingBuffer[1].Sens = InvPostingBuffer[1].Sens::Positive) AND
                       (PaymentLine."Entry No. Debit" = 0) AND (PaymentLine."Entry No. Credit" = 0) THEN BEGIN
                        PaymentClass.GET(PaymentHeader."Payment Class");
                        IF PaymentClass."Line No. Series" = '' THEN
                            PaymentLine.TESTFIELD("Document ID", NoSeriesMgt.GetNextNo(PaymentHeader."No. Series", PaymentLine."Posting Date", FALSE))
                        ELSE
                            PaymentLine.TESTFIELD("Document ID", NoSeriesMgt.GetNextNo(PaymentClass."Line No. Series", PaymentLine."Posting Date",
                              FALSE));
                    END;
                    InvPostingBuffer[1]."Document No." := PaymentLine."Document ID";
                END;
                InvPostingBuffer[1]."Header Document No." := PaymentHeader."No.";
                IF StepLedger.Sign = StepLedger.Sign::Debit THEN BEGIN
                    EntryTypeDebit := InvPostingBuffer[1]."Account Type";
                    EntryNoAccountDebit := InvPostingBuffer[1]."Account No.";
                    EntryPostGroupDebit := InvPostingBuffer[1]."Posting group";
                END ELSE BEGIN
                    EntryTypeCredit := InvPostingBuffer[1]."Account Type";
                    EntryNoAccountCredit := InvPostingBuffer[1]."Account No.";
                    EntryPostGroupCredit := InvPostingBuffer[1]."Posting group";
                END;
                InvPostingBuffer[1]."System-Created Entry" := TRUE;
                Application;
                case PaymentLine."Account Type" of
                    PaymentLine."Account Type"::Customer:
                        begin
                            if not Customer.Get(PaymentLine."Account No.") then
                                Clear(Customer);
                            PartnerName := Customer.Name;
                        end;
                    PaymentLine."Account Type"::Vendor:
                        begin
                            if not Vendor.Get(PaymentLine."Account No.") then
                                Clear(Vendor);
                            PartnerName := Vendor.Name;
                        end;
                end;
                InvPostingBuffer[1].Description := Copystr(
                    STRSUBSTNO(
                        StepLedger.Description,
                        PaymentLine."Due Date",
                        PaymentLine."Account No.",
                        PaymentLine."Document ID") +
                        PartnerName, 1, MaxStrLen(InvPostingBuffer[1].Description));

                InvPostingBuffer[1]."Source Type" := PaymentLine."Account Type";
                InvPostingBuffer[1]."Source No." := PaymentLine."Account No.";
                InvPostingBuffer[1]."External Document No." := PaymentLine."External Document No.";
                InvPostingBuffer[1]."Global Dimension 1 Code" := PaymentHeader."Shortcut Dimension 1 Code";
                InvPostingBuffer[1]."Global Dimension 2 Code" := PaymentHeader."Shortcut Dimension 2 Code";
                /*TempDocDim.SETRANGE("Table ID",DATABASE::"Payment Line");
                TempDocDim.SETRANGE("Line No.",PaymentLine."Line No.");*/

                //SSM729>>
                InvPostingBuffer[1]."Salesperson/Purchaser Code" := PaymentLine."Salesperson/Purchaser Code";
                InvPostingBuffer[1]."Global Dimension 1 Code" := PaymentLine."Shortcut Dimension 1 Code";
                InvPostingBuffer[1]."Global Dimension 2 Code" := PaymentLine."Shortcut Dimension 2 Code";
                InvPostingBuffer[1]."Dimension Set ID" := PaymentLine."Dimension Set ID";
                //SSM729<<

                UpdtBuffer;
                IF (InvPostingBuffer[1].Amount >= 0) XOR InvPostingBuffer[1].Correction THEN
                    PaymentLine."Entry No. Debit" := InvPostingBuffer[1]."GL Entry No."
                ELSE
                    PaymentLine."Entry No. Credit" := InvPostingBuffer[1]."GL Entry No.";
            UNTIL StepLedger.NEXT = 0;
            NoSeriesMgt.SaveNoSeries;
        END;

    end;

    procedure SetPostingGroup()
    begin
        IF PaymentLine."Account Type" = PaymentLine."Account Type"::Customer THEN BEGIN
            InvPostingBuffer[1]."Posting group" := PaymentLine."Posting Group";
            IF NOT CustomerPostingGroup.GET(PaymentLine."Posting Group") THEN
                IF NOT CustomerPostingGroup.GET(StepLedger."Customer Posting Group") THEN BEGIN
                    IF StepLedger."Customer Posting Group" <> '' THEN
                        ERROR(Text012, StepLedger."Customer Posting Group");
                    Customer.GET(PaymentLine."Account No.");
                    CustomerPostingGroup.GET(Customer."Customer Posting Group");
                END
                ELSE
                    IF CustomerPostingGroup."Receivables Account" = '' THEN
                        ERROR(Text014, StepLedger."Customer Posting Group");
        END;

        IF PaymentLine."Account Type" = PaymentLine."Account Type"::Vendor THEN BEGIN
            IF NOT VendorPostingGroup.GET(PaymentLine."Posting Group") THEN
                IF NOT VendorPostingGroup.GET(StepLedger."Vendor Posting Group") THEN BEGIN
                    IF StepLedger."Customer Posting Group" <> '' THEN
                        ERROR(Text013, StepLedger."Vendor Posting Group");
                    Vendor.GET(PaymentLine."Account No.");
                    VendorPostingGroup.GET(Vendor."Vendor Posting Group");
                END
                ELSE
                    IF VendorPostingGroup."Payables Account" = '' THEN
                        ERROR(Text015, StepLedger."Vendor Posting Group");
        END;
    end;

    procedure SetAccountNo()
    begin
        CASE StepLedger."Accounting Type" OF
            StepLedger."Accounting Type"::"Payment Line Account":
                BEGIN
                    InvPostingBuffer[1]."Account Type" := PaymentLine."Account Type";
                    InvPostingBuffer[1]."Account No." := PaymentLine."Account No.";
                    IF PaymentLine."Account Type" = PaymentLine."Account Type"::Customer THEN
                        InvPostingBuffer[1]."Posting group" := CustomerPostingGroup.Code;
                    IF PaymentLine."Account Type" = PaymentLine."Account Type"::Vendor THEN
                        InvPostingBuffer[1]."Posting group" := VendorPostingGroup.Code;
                    InvPostingBuffer[1]."Line No." := PaymentLine."Line No.";
                END;
            StepLedger."Accounting Type"::"Associated G/L Account":
                BEGIN
                    InvPostingBuffer[1]."Account Type" := InvPostingBuffer[1]."Account Type"::"G/L Account";
                    IF PaymentLine."Account Type" = PaymentLine."Account Type"::Customer THEN
                        InvPostingBuffer[1]."Account No." := CustomerPostingGroup."Receivables Account"
                    ELSE
                        InvPostingBuffer[1]."Account No." := VendorPostingGroup."Payables Account";
                    InvPostingBuffer[1]."Line No." := PaymentLine."Line No.";
                END;
            StepLedger."Accounting Type"::"Below Account":
                BEGIN
                    InvPostingBuffer[1]."Account Type" := StepLedger."Account Type";
                    InvPostingBuffer[1]."Account No." := StepLedger."Account No.";
                    IF StepLedger."Account No." = '' THEN BEGIN
                        PaymentHeader.CALCFIELDS("Payment Class Name");
                        IF StepLedger.Sign = StepLedger.Sign::Debit THEN
                            ERROR(Text018, Step.Name, PaymentHeader."Payment Class Name")
                        ELSE
                            ERROR(Text019, Step.Name, PaymentHeader."Payment Class Name");
                    END;
                    IF StepLedger."Account Type" = StepLedger."Account Type"::Customer THEN
                        InvPostingBuffer[1]."Posting group" := StepLedger."Customer Posting Group"
                    ELSE
                        InvPostingBuffer[1]."Posting group" := StepLedger."Vendor Posting Group";
                    InvPostingBuffer[1]."Line No." := PaymentLine."Line No.";
                END;
            StepLedger."Accounting Type"::"G/L Account / Month":
                BEGIN
                    InvPostingBuffer[1]."Account Type" := InvPostingBuffer[1]."Account Type"::"G/L Account";
                    N := DATE2DMY(PaymentLine."Due Date", 2);
                    IF N < 10 THEN Suffix := '0' + FORMAT(N) ELSE Suffix := FORMAT(N);
                    InvPostingBuffer[1]."Account No." := StepLedger.Root + Suffix;
                    InvPostingBuffer[1]."Line No." := PaymentLine."Line No.";
                END;
            StepLedger."Accounting Type"::"G/L Account / Week":
                BEGIN
                    InvPostingBuffer[1]."Account Type" := InvPostingBuffer[1]."Account Type"::"G/L Account";
                    N := DATE2DWY(PaymentLine."Due Date", 2);
                    IF N < 10 THEN Suffix := '0' + FORMAT(N) ELSE Suffix := FORMAT(N);
                    InvPostingBuffer[1]."Account No." := StepLedger.Root + Suffix;
                    InvPostingBuffer[1]."Line No." := PaymentLine."Line No.";
                END;
            StepLedger."Accounting Type"::"Bal. Account Previous Entry":
                BEGIN
                    IF (StepLedger.Sign = StepLedger.Sign::Debit) AND NOT (PaymentLine.Correction XOR Step.Correction) THEN BEGIN
                        InvPostingBuffer[1]."Account Type" := PaymentLine."Acc. Type last entry Credit";
                        InvPostingBuffer[1]."Account No." := PaymentLine."Acc. No. Last entry Credit";
                        InvPostingBuffer[1]."Posting group" := PaymentLine."P. Group Last Entry Credit";
                    END ELSE BEGIN
                        InvPostingBuffer[1]."Account Type" := PaymentLine."Acc. Type last entry Debit";
                        InvPostingBuffer[1]."Account No." := PaymentLine."Acc. No. Last entry Debit";
                        InvPostingBuffer[1]."Posting group" := PaymentLine."P. Group Last Entry Debit";
                    END;
                    InvPostingBuffer[1]."Line No." := PaymentLine."Line No.";
                END;
            StepLedger."Accounting Type"::"Header Payment Account":
                BEGIN
                    InvPostingBuffer[1]."Account Type" := PaymentHeader."Account Type";
                    InvPostingBuffer[1]."Account No." := PaymentHeader."Account No.";
                    IF PaymentHeader."Account No." = '' THEN
                        ERROR(Text020);
                    IF StepLedger."Detail Level" = StepLedger."Detail Level"::Account THEN
                        HeaderAccountUsedGlobally := TRUE;
                    InvPostingBuffer[1]."Line No." := 0;
                END;
        END;
    end;

    procedure Application()
    begin
        IF StepLedger.Application <> StepLedger.Application::None THEN BEGIN
            IF StepLedger.Application = StepLedger.Application::"Applied Entry" THEN BEGIN
                InvPostingBuffer[1]."Applies-to Doc. Type" := PaymentLine."Applies-to Doc. Type";
                InvPostingBuffer[1]."Applies-to Doc. No." := PaymentLine."Applies-to Doc. No.";
                InvPostingBuffer[1]."Applies-to ID" := PaymentLine."Applies-to ID";
            END ELSE
                IF StepLedger.Application = StepLedger.Application::"Entry Previous Step" THEN BEGIN
                    InvPostingBuffer[1]."Applies-to ID" := PaymentLine."No." + '/' + FORMAT(PaymentLine."Line No.") + Text011;
                    IF InvPostingBuffer[1]."Account Type" = InvPostingBuffer[1]."Account Type"::Customer THEN BEGIN
                        IF (InvPostingBuffer[1].Amount < 0) XOR InvPostingBuffer[1].Correction THEN
                            CustLedgerEntry.SETRANGE("Entry No.", OldPaymentLine."Entry No. Debit")
                        ELSE
                            CustLedgerEntry.SETRANGE("Entry No.", OldPaymentLine."Entry No. Credit");
                        IF CustLedgerEntry.FIND('-') THEN BEGIN
                            CustLedgerEntry."Applies-to ID" := InvPostingBuffer[1]."Applies-to ID";
                            CustLedgerEntry.CALCFIELDS("Remaining Amount");
                            CustLedgerEntry.VALIDATE("Amount to Apply", CustLedgerEntry."Remaining Amount");
                            CustLedgerEntry.MODIFY;
                        END;
                    END ELSE
                        IF InvPostingBuffer[1]."Account Type" = InvPostingBuffer[1]."Account Type"::Vendor THEN BEGIN
                            IF (InvPostingBuffer[1].Amount < 0) XOR InvPostingBuffer[1].Correction THEN
                                VendorLedgerEntry.SETRANGE("Entry No.", OldPaymentLine."Entry No. Debit")
                            ELSE
                                VendorLedgerEntry.SETRANGE("Entry No.", OldPaymentLine."Entry No. Credit");
                            IF VendorLedgerEntry.FIND('-') THEN BEGIN
                                VendorLedgerEntry."Applies-to ID" := InvPostingBuffer[1]."Applies-to ID";
                                VendorLedgerEntry.CALCFIELDS("Remaining Amount");
                                VendorLedgerEntry.VALIDATE("Amount to Apply", VendorLedgerEntry."Remaining Amount");
                                VendorLedgerEntry.MODIFY;
                            END;
                        END;
                END ELSE
                    IF StepLedger.Application = StepLedger.Application::"Memorized Entry" THEN BEGIN
                        InvPostingBuffer[1]."Applies-to ID" := PaymentLine."No." + '/' + FORMAT(PaymentLine."Line No.") + Text011;
                        IF InvPostingBuffer[1]."Account Type" = InvPostingBuffer[1]."Account Type"::Customer THEN BEGIN
                            CustLedgerEntry.RESET;
                            IF (InvPostingBuffer[1].Amount < 0) XOR InvPostingBuffer[1].Correction THEN
                                CustLedgerEntry.SETRANGE("Entry No.", OldPaymentLine."Entry No. Debit Memo")
                            ELSE
                                CustLedgerEntry.SETRANGE("Entry No.", OldPaymentLine."Entry No. Credit Memo");
                            IF CustLedgerEntry.FIND('-') THEN BEGIN
                                CustLedgerEntry."Applies-to ID" := InvPostingBuffer[1]."Applies-to ID";
                                CustLedgerEntry.CALCFIELDS("Remaining Amount");
                                CustLedgerEntry.VALIDATE("Amount to Apply", CustLedgerEntry."Remaining Amount");
                                CustLedgerEntry.MODIFY;
                            END;
                        END ELSE
                            IF InvPostingBuffer[1]."Account Type" = InvPostingBuffer[1]."Account Type"::Vendor THEN BEGIN
                                IF (InvPostingBuffer[1].Amount < 0) XOR InvPostingBuffer[1].Correction THEN
                                    VendorLedgerEntry.SETRANGE("Entry No.", OldPaymentLine."Entry No. Debit Memo")
                                ELSE
                                    VendorLedgerEntry.SETRANGE("Entry No.", OldPaymentLine."Entry No. Credit Memo");
                                IF VendorLedgerEntry.FIND('-') THEN BEGIN
                                    VendorLedgerEntry."Applies-to ID" := InvPostingBuffer[1]."Applies-to ID";
                                    VendorLedgerEntry.CALCFIELDS("Remaining Amount");
                                    VendorLedgerEntry.VALIDATE("Amount to Apply", VendorLedgerEntry."Remaining Amount");
                                    VendorLedgerEntry.MODIFY;
                                END;
                            END;
                    END;
        END;
        InvPostingBuffer[1]."Due Date" := PaymentLine."Due Date"; // FR Payment due date
    end;

    procedure GenerEntries()
    var
        CurrExchRate: Record "Currency Exchange Rate";
        Difference: Decimal;
        Currency: Record Currency;
        Text100: Label 'Rounding on ';
    begin
        IF InvPostingBuffer[1].FIND('+') THEN
            WITH PaymentHeader DO
                REPEAT
                    GenJnlLine.INIT;
                    GenJnlLine."Posting Date" := "Posting Date";
                    GenJnlLine."Document Date" := "Document Date";
                    GenJnlLine.Description := InvPostingBuffer[1].Description;
                    GenJnlLine."Reason Code" := Step."Reason Code";
                    GenJnlLine."Document Type" := InvPostingBuffer[1]."Document Type";
                    GenJnlLine."Document No." := InvPostingBuffer[1]."Document No.";
                    GenJnlLine."Account Type" := InvPostingBuffer[1]."Account Type";
                    GenJnlLine."Account No." := InvPostingBuffer[1]."Account No.";
                    GenJnlLine."System-Created Entry" := InvPostingBuffer[1]."System-Created Entry";
                    GenJnlLine."Currency Code" := InvPostingBuffer[1]."Currency Code";
                    GenJnlLine."Currency Factor" := InvPostingBuffer[1]."Currency Factor";
                    GenJnlLine.VALIDATE(Amount, InvPostingBuffer[1].Amount);
                    GenJnlLine.Correction := InvPostingBuffer[1].Correction;
                    IF PaymentHeader."Source Code" <> '' THEN BEGIN
                        TestSourceCode(PaymentHeader."Source Code");
                        GenJnlLine."Source Code" := PaymentHeader."Source Code";
                    END ELSE BEGIN
                        Step.TESTFIELD("Source Code");
                        TestSourceCode(Step."Source Code");
                        GenJnlLine."Source Code" := Step."Source Code";
                    END;
                    GenJnlLine."Applies-to Doc. Type" := InvPostingBuffer[1]."Applies-to Doc. Type";
                    GenJnlLine."Applies-to Doc. No." := InvPostingBuffer[1]."Applies-to Doc. No.";
                    IF GenJnlLine."Applies-to Doc. No." = '' THEN
                        GenJnlLine."Applies-to ID" := InvPostingBuffer[1]."Applies-to ID";
                    GenJnlLine."Posting Group" := InvPostingBuffer[1]."Posting group";
                    GenJnlLine."Source Type" := InvPostingBuffer[1]."Source Type";
                    GenJnlLine."Source No." := InvPostingBuffer[1]."Source No.";
                    GenJnlLine."External Document No." := InvPostingBuffer[1]."External Document No.";
                    GenJnlLine."Due Date" := InvPostingBuffer[1]."Due Date";
                    GenJnlLine."Shortcut Dimension 1 Code" := InvPostingBuffer[1]."Global Dimension 1 Code";
                    GenJnlLine."Shortcut Dimension 2 Code" := InvPostingBuffer[1]."Global Dimension 2 Code";
                    /*TempJnlLineDim.DELETEALL;
                    TempDocDim.RESET;
                    TempDocDim.SETRANGE("Document Type",TempDocDim."Document Type"::" ");
                    TempDocDim.SETRANGE("Document No.",InvPostingBuffer[1]."Header Document No.");
                    TempDocDim.SETRANGE("Line No.",InvPostingBuffer[1]."Line No.");
                    IF InvPostingBuffer[1]."Line No." = 0 THEN
                      TempDocDim.SETRANGE("Table ID",DATABASE::"SSA Payment Header")
                    ELSE
                      TempDocDim.SETRANGE("Table ID",DATABASE::"Payment Line");
                    DimMgt.CopyDocDimToJnlLineDim(TempDocDim,TempJnlLineDim);*/

                    //SSM729>>
                    GenJnlLine."Salespers./Purch. Code" := InvPostingBuffer[1]."Salesperson/Purchaser Code";
                    GenJnlLine."Dimension Set ID" := InvPostingBuffer[1]."Dimension Set ID";
                    //SSM729<<
                    OnBeforePostGenJnlLine(PaymentHeader, InvPostingBuffer[1], GenJnlLine);
                    GenJnlPostLine.RunWithCheck(GenJnlLine);

                    PaymentLine.RESET;
                    PaymentLine.SETRANGE("No.", PaymentHeader."No.");
                    PaymentLine.SETRANGE("Line No.");
                    IF GenJnlLine.Amount >= 0 THEN BEGIN
                        PaymentLine.SETRANGE("Entry No. Debit", InvPostingBuffer[1]."GL Entry No.");
                        StepLedger.GET(Step."Payment Class", Step.Line, StepLedger.Sign::Debit);
                        IF StepLedger."Memorize Entry" THEN
                            PaymentLine.MODIFYALL(PaymentLine."Entry No. Debit Memo", GenJnlLine."SSA Entry No.");
                        PaymentLine.MODIFYALL("Entry No. Debit", GenJnlLine."SSA Entry No.");
                    END ELSE BEGIN
                        PaymentLine.SETRANGE("Entry No. Credit", InvPostingBuffer[1]."GL Entry No.");
                        StepLedger.GET(Step."Payment Class", Step.Line, StepLedger.Sign::Credit);
                        IF StepLedger."Memorize Entry" THEN
                            PaymentLine.MODIFYALL(PaymentLine."Entry No. Credit Memo", GenJnlLine."SSA Entry No.");
                        PaymentLine.MODIFYALL("Entry No. Credit", GenJnlLine."SSA Entry No.");
                    END;
                UNTIL InvPostingBuffer[1].NEXT(-1) = 0;

        IF HeaderAccountUsedGlobally THEN BEGIN
            PaymentHeader.CALCFIELDS(Amount, "Amount (LCY)");
            Difference := PaymentHeader."Amount (LCY)" - ROUND(CurrExchRate.ExchangeAmtFCYToLCY(PaymentHeader."Posting Date",
              PaymentHeader."Currency Code", PaymentHeader.Amount, PaymentHeader."Currency Factor"));
            IF Difference <> 0 THEN BEGIN
                GenJnlLine.INIT;
                GenJnlLine."Account Type" := GenJnlLine."Account Type"::"G/L Account";
                Currency.GET(PaymentHeader."Currency Code");
                IF Difference < 0 THEN BEGIN
                    GenJnlLine."Account No." := Currency."Unrealized Losses Acc.";
                    StepLedger.GET(Step."Payment Class", Step.Line, StepLedger.Sign::Debit);
                    GenJnlLine.VALIDATE("Debit Amount", -Difference);
                END ELSE BEGIN
                    GenJnlLine."Account No." := Currency."Unrealized Gains Acc.";
                    StepLedger.GET(Step."Payment Class", Step.Line, StepLedger.Sign::Credit);
                    GenJnlLine.VALIDATE("Credit Amount", Difference);
                END;
                GenJnlLine."Posting Date" := PaymentHeader."Posting Date";
                GenJnlLine."Document No." := PaymentHeader."No.";
                GenJnlLine.Description := Text100 + STRSUBSTNO(StepLedger.Description,
                  PaymentHeader."Document Date", '', PaymentHeader."No.");
                GenJnlLine."Shortcut Dimension 1 Code" := PaymentHeader."Shortcut Dimension 1 Code";
                GenJnlLine."Shortcut Dimension 2 Code" := PaymentHeader."Shortcut Dimension 2 Code";
                GenJnlLine."Source Code" := PaymentHeader."Source Code";
                GenJnlLine."Reason Code" := Step."Reason Code";
                GenJnlLine."Document Date" := PaymentHeader."Document Date";
                /*TempJnlLineDim.DELETEALL;
                TempDocDim.RESET;
                DimMgt.CopyDocDimToJnlLineDim(TempDocDim,TempJnlLineDim);  */
                OnBeforePostGenJnlLineRounding(PaymentHeader, GenJnlLine);
                GenJnlPostLine.RunWithCheck(GenJnlLine);
            END;
        END;

        InvPostingBuffer[1].DELETEALL;

    end;

    local procedure GetIntegerPos(No: Code[20]; var StartPos: Integer; var EndPos: Integer)
    var
        IsDigit: Boolean;
        i: Integer;
    begin
        StartPos := 0;
        EndPos := 0;
        IF No <> '' THEN BEGIN
            i := STRLEN(No);
            REPEAT
                IsDigit := No[i] IN ['0' .. '9'];
                IF IsDigit THEN BEGIN
                    IF EndPos = 0 THEN
                        EndPos := i;
                    StartPos := i;
                END;
                i := i - 1;
            UNTIL (i = 0) OR (StartPos <> 0) AND NOT IsDigit;
        END;
        IF (StartPos = 0) AND (EndPos = 0) THEN
            ERROR(Text021, No);
    end;

    procedure IncrementNoText(var No: Code[20]; IncrementByNo: Decimal)
    var
        DecimalNo: Decimal;
        StartPos: Integer;
        EndPos: Integer;
        NewNo: Text[30];
    begin
        GetIntegerPos(No, StartPos, EndPos);
        EVALUATE(DecimalNo, COPYSTR(No, StartPos, EndPos - StartPos + 1));
        NewNo := FORMAT(DecimalNo + IncrementByNo, 0, 1);
        ReplaceNoText(No, NewNo, 0, StartPos, EndPos);
    end;

    local procedure ReplaceNoText(var No: Code[20]; NewNo: Code[20]; FixedLength: Integer; StartPos: Integer; EndPos: Integer)
    var
        StartNo: Code[20];
        EndNo: Code[20];
        ZeroNo: Code[20];
        NewLength: Integer;
        OldLength: Integer;
    begin
        IF StartPos > 1 THEN
            StartNo := COPYSTR(No, 1, StartPos - 1);
        IF EndPos < STRLEN(No) THEN
            EndNo := COPYSTR(No, EndPos + 1);
        NewLength := STRLEN(NewNo);
        OldLength := EndPos - StartPos + 1;
        IF FixedLength > OldLength THEN
            OldLength := FixedLength;
        IF OldLength > NewLength THEN
            ZeroNo := PADSTR('', OldLength - NewLength, '0');
        IF STRLEN(StartNo) + STRLEN(ZeroNo) + STRLEN(NewNo) + STRLEN(EndNo) > 20 THEN
            ERROR(
              Text001,
              No);
        No := StartNo + ZeroNo + NewNo + EndNo;
    end;

    procedure CreatePaymentHeaders()
    var
        Ok: Boolean;
    begin
        Step.SETRANGE(Step."Action Type", Step."Action Type"::"Create new Document");

        IF StepSelect('', -1, Step, TRUE) THEN
            ExecuteCreatePaymtHead(Step);
    end;

    procedure ExecuteCreatePaymtHead(PaymtStep: Record "SSA Payment Step"): Code[20]
    var
        InserForm: Page "SSA Payment Lines List";
        PayNum: Code[20];
        Bor: Record "SSA Payment Header";
        StatementForm: Page "SSA Payment Headers";
    begin
        PaymentLine.SETRANGE("Payment Class", PaymtStep."Payment Class");
        PaymentLine.SETRANGE("Status No.", PaymtStep."Previous Status");
        PaymentLine.SETRANGE("Copied To No.", '');
        PaymentLine.FILTERGROUP(2);
        InserForm.SETRECORD(PaymentLine);
        InserForm.SETTABLEVIEW(PaymentLine);
        InserForm.LOOKUPMODE(TRUE);
        IF InserForm.RUNMODAL = ACTION::LookupOK THEN
            IF CONFIRM(Text023) THEN BEGIN
                InserForm.SetSelection(PaymentLine);
                CopyLigBor(PaymentLine, PaymtStep.Line, PayNum);
                IF Bor.GET(PayNum) THEN BEGIN
                    StatementForm.SETRECORD(Bor);
                    StatementForm.RUN;
                    /* PS12301 start deletion
                    InserForm.SetSteps(PaymtStep.Line);
                    InserForm.SETTABLEVIEW(PaymentLine);
                    InserForm.RUNMODAL;
                    PayNum:=InserForm.GetNumBor;
                    IF Bor.GET(PayNum) THEN BEGIN
                      StatementForm.SETRECORD(Bor);
                      StatementForm.RUN;
                    PS12301 end deletion */
                END ELSE
                    ERROR(Text004);
            END;
        EXIT(PayNum);

    end;

    procedure LinesInsert(HeaderNumber: Code[20])
    var
        Header: Record "SSA Payment Header";
        PaymentLine: Record "SSA Payment Line";
        InserForm: Page "SSA Payment Lines List";
        Step: Record "SSA Payment Step";
    begin
        Header.GET(HeaderNumber);
        IF StepSelect(Header."Payment Class", Header."Status No.", Step, FALSE) THEN BEGIN
            PaymentLine.SETRANGE("Payment Class", Header."Payment Class");
            PaymentLine.SETRANGE("Copied To No.", '');
            PaymentLine.SETFILTER("Status No.", FORMAT(Step."Previous Status"));
            PaymentLine.SETRANGE("Currency Code", Header."Currency Code");
            PaymentLine.FILTERGROUP(2);

            InserForm.SETRECORD(PaymentLine);
            InserForm.SETTABLEVIEW(PaymentLine);
            InserForm.LOOKUPMODE(TRUE);
            IF InserForm.RUNMODAL = ACTION::LookupOK THEN BEGIN
                InserForm.SetSelection(PaymentLine);
                CopyLigBor(PaymentLine, Step.Line, Header."No.");
            END;
            /*PS12301 start deletion
            InserForm.SetSteps(Step.Line);
            InserForm.SetNumBor(Header."No.");
            InserForm.SETTABLEVIEW(PaymentLine);
            InserForm.RUNMODAL;
            deletion end PS12301*/
        END;

    end;

    procedure StepSelect(Process: Text[30]; NextStatus: Integer; var Step: Record "SSA Payment Step"; CreateDocumentFilter: Boolean) OK: Boolean
    var
        Options: Text[250];
        PaymentClass: Record "SSA Payment Class";
        Choice: Integer;
        i: Integer;
    begin
        OK := FALSE;
        i := 0;
        IF Process = '' THEN BEGIN
            PaymentClass.SETRANGE(Enable, TRUE);
            IF CreateDocumentFilter THEN
                PaymentClass.SETRANGE("Is create document", TRUE);
            IF PaymentClass.FIND('-') THEN
                REPEAT
                    i += 1;
                    IF Options = '' THEN
                        Options := PaymentClass.Code
                    ELSE
                        Options := Options + ',' + PaymentClass.Code;
                UNTIL PaymentClass.NEXT = 0;
            IF i > 0 THEN
                Choice := STRMENU(Options, 1);
            i := 1;
            IF Choice > 0 THEN BEGIN
                PaymentClass.FIND('-');
                WHILE Choice > i DO BEGIN
                    i += 1;
                    PaymentClass.NEXT;
                END;
            END;
        END ELSE BEGIN
            PaymentClass.GET(Process);
            Choice := 1;
        END;
        IF Choice > 0 THEN BEGIN
            Options := '';
            Step.SETRANGE("Payment Class", PaymentClass.Code);
            Step.SETRANGE("Action Type", Step."Action Type"::"Create new Document");
            IF NextStatus > -1 THEN
                Step.SETRANGE("Next Status", NextStatus);
            i := 0;
            IF Step.FIND('-') THEN BEGIN
                i += 1;
                REPEAT
                    IF Options = '' THEN
                        Options := Step.Name
                    ELSE
                        Options := Options + ',' + Step.Name;
                UNTIL Step.NEXT = 0;
                IF i > 0 THEN BEGIN
                    Choice := STRMENU(Options, 1);
                    i := 1;
                    IF Choice > 0 THEN BEGIN
                        Step.FIND('-');
                        WHILE Choice > i DO BEGIN
                            i += 1;
                            Step.NEXT;
                        END;
                        OK := TRUE;
                    END;
                END;
            END;
        END;
    end;

    local procedure CheckDimComb(LineNo: Integer)
    begin
        /*IF NOT DimMgt.CheckDocDimComb(TempDocDim) THEN
          IF LineNo = 0 THEN
            ERROR(
              Text009,
              PaymentHeader."No.",DimMgt.GetDimCombErr)
          ELSE
            ERROR(
              Text010,
              PaymentHeader."No.",LineNo,DimMgt.GetDimCombErr);*/

    end;

    local procedure CheckDimValuePosting(LineNo: Integer)
    var
        TheSalesLine: Record "Sales Line";
        TableIDArr: array[10] of Integer;
        NumberArr: array[10] of Code[20];
    begin
        /*IF LineNo = 0 THEN BEGIN
          TableIDArr[1] := DATABASE::Customer;
          NumberArr[1] := SalesHeader."Bill-to Customer No.";
          TableIDArr[2] := DATABASE::Job;
          NumberArr[2] := SalesHeader."Job No.";
          TableIDArr[3] := DATABASE::"Salesperson/Purchaser";
          NumberArr[3] := SalesHeader."Salesperson Code";
          TableIDArr[4] := DATABASE::Campaign;
          NumberArr[4] := SalesHeader."Campaign No.";
          TableIDArr[5] := DATABASE::"Responsibility Center";
          NumberArr[5] := SalesHeader."Responsibility Center";
          IF NOT DimMgt.CheckDocDimValuePosting(TempDocDim,TableIDArr,NumberArr) THEN
            ERROR(
              Text030,
              SalesHeader."Document Type",SalesHeader."No.",DimMgt.GetDimValuePostingErr);
        END ELSE BEGIN
          TheSalesLine.GET(SalesHeader."Document Type",SalesHeader."No.",LineNo);
          TableIDArr[1] := DimMgt.TypeToTableID3(TheSalesLine.Type);
          NumberArr[1] := TheSalesLine."No.";
          TableIDArr[2] := DATABASE::Job;
          NumberArr[2] := TheSalesLine."Job No.";
          IF NOT DimMgt.CheckDocDimValuePosting(TempDocDim,TableIDArr,NumberArr) THEN
            ERROR(
              Text031,
              SalesHeader."Document Type",SalesHeader."No.",LineNo,DimMgt.GetDimValuePostingErr);
        END;
        */

    end;

    local procedure CopyAndCheckDocDimToTempDocDim()
    var
        CurrLineNo: Integer;
    begin
        /*TempDocDim.RESET;
        TempDocDim.DELETEALL;
        DocDim.SETRANGE("Table ID",DATABASE::"SSA Payment Header");
        DocDim.SETRANGE("Document Type",DocDim."Document Type"::" ");
        DocDim.SETRANGE("Document No.",PaymentHeader."No.");
        IF DocDim.FIND('-') THEN BEGIN
          REPEAT
            TempDocDim.INIT;
            TempDocDim := DocDim;
            TempDocDim.INSERT;
          UNTIL DocDim.NEXT = 0;
          TempDocDim.SETRANGE("Line No.",0);
          CheckDimComb(0);
          CheckDimValuePosting(0);
        END;
        DocDim.SETRANGE("Table ID",DATABASE::"Payment Line");
        IF DocDim.FIND('-') THEN BEGIN
          CurrLineNo := DocDim."Line No.";
          REPEAT
            IF CurrLineNo <> DocDim."Line No." THEN BEGIN
              TempDocDim.SETRANGE("Line No.",CurrLineNo);
              CheckDimComb(CurrLineNo);
              CheckDimValuePosting(CurrLineNo);
              CurrLineNo := DocDim."Line No.";
            END;
            TempDocDim.INIT;
            TempDocDim := DocDim;
            TempDocDim.INSERT;
          UNTIL DocDim.NEXT = 0;
          TempDocDim.SETRANGE("Line No.",CurrLineNo);
          CheckDimComb(CurrLineNo);
          CheckDimValuePosting(CurrLineNo);
        END;
        TempDocDim.RESET;*/

    end;

    procedure MoveOneDocDimToPostedDocDim(FromTableID: Integer; FromDocType: Integer; FromDocNo: Code[20]; FromLineNo: Integer; ToTableID: Integer; ToDocNo: Code[20]; ToLineNo: Integer)
    begin
        /*WITH FromDocDim DO BEGIN
          SETRANGE("Table ID",FromTableID);
          SETRANGE("Document Type",FromDocType);
          SETRANGE("Document No.",FromDocNo);
          IF FromLineNo <> 0 THEN
            SETRANGE("Line No.",FromLineNo);
          IF FIND('-') THEN
            REPEAT
              ToDocDim.INIT;
              ToDocDim."Table ID" := ToTableID;
              ToDocDim."Document No." := ToDocNo;
              ToDocDim."Document Type":= ToDocDim."Document Type"::" ";
              ToDocDim."Line No." := ToLineNo;
              ToDocDim."Dimension Code" := "Dimension Code";
              ToDocDim."Dimension Value Code" := "Dimension Value Code";
              ToDocDim.INSERT;
            UNTIL NEXT = 0;
        END;   */

    end;

    procedure TestSourceCode("Code": Code[10])
    var
        SourceCode: Record "Source Code";
    begin
        IF NOT SourceCode.GET(Code) THEN
            ERROR(Text017, Code);
    end;

    procedure PaymentAddr(var AddrArray: array[8] of Text[50]; PaymentAddress: Record "SSA Payment Address")
    var
        FormatAddress: Codeunit "Format Address";
    begin
        WITH PaymentAddress DO
            FormatAddress.FormatAddr(
              AddrArray, Name, "Name 2", Contact, Address, "Address 2",
              City, "Post Code", County, "Country/Region Code");
    end;

    procedure PaymentBankAcc(var AddrArray: array[8] of Text[50]; BankAcc: Record "SSA Payment Header")
    var
        FormatAddress: Codeunit "Format Address";
    begin
        WITH BankAcc DO
            FormatAddress.FormatAddr(
              AddrArray, "Bank Name", "Bank Name 2", "Bank Contact", "Bank Address", "Bank Address 2",
              "Bank City", "Bank Post Code", "Bank County", "Bank Country/Region Code");
    end;

    procedure ArchiveDocument(Document: Record "SSA Payment Header")
    var
        ArchiveHeader: Record "SSA Payment Header Archive";
        ArchiveLine: Record "SSA Payment Line Archive";
        PaymentLine: Record "SSA Payment Line";
        DimensionManagement: Codeunit DimensionManagement;
        DocType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order"," ";
    begin
        Document.CALCFIELDS("Archiving authorized");
        IF NOT Document."Archiving authorized" THEN
            ERROR(Text022, Document."No.");
        ArchiveHeader.TRANSFERFIELDS(Document);
        ArchiveHeader.INSERT;
        Document.DELETE;
        /*
        DocumentDimension.SETRANGE("Table ID", DATABASE::"SSA Payment Header");
        DocumentDimension.SETRANGE("Document Type", DocumentDimension."Document Type"::" ");
        DocumentDimension.SETRANGE("Document No.", Document."No.");
        DocumentDimension.SETRANGE("Line No.", 0);
        DimensionManagement.MoveDocDimToPostedDocDim(DocumentDimension, DATABASE::"Payment Header Archive", Document."No.");
        DimensionManagement.DeleteDocDim(DATABASE::"SSA Payment Header", DocType::" ", Document."No.", 0);
        */
        PaymentLine.SETRANGE("No.", Document."No.");
        IF PaymentLine.FIND('-') THEN
            REPEAT
                ArchiveLine.TRANSFERFIELDS(PaymentLine);
                ArchiveLine.INSERT;
                PaymentLine.DELETE;
            /*
            DocumentDimension.SETRANGE("Table ID", DATABASE::"Payment Line");
            DocumentDimension.SETRANGE("Document Type", DocumentDimension."Document Type"::" ");
            DocumentDimension.SETRANGE("Document No.", Document."No.");
            DocumentDimension.SETRANGE("Line No.", PaymentLine."Line No.");
            DimensionManagement.MoveDocDimToPostedDocDim(DocumentDimension, DATABASE::"Payment Line Archive", Document."No.");
            DimensionManagement.DeleteDocDim(DATABASE::"Payment Line", DocType::" ", Document."No.", PaymentLine."Line No.");
            */
            UNTIL PaymentLine.NEXT = 0;

    end;

    procedure CreazaLiniiAplicare(_PaymentHeader: Record "SSA Payment Header"; _Pozitiv: Boolean; _LineNo: Integer)
    var
        PmtLine: Record "SSA Payment Line";
        PTAEntry: Record "SSA Pmt. Tools AppLedg. Entry";
        EntryNo: Integer;
    begin
        //SSM729>>
        PmtLine.RESET;
        PmtLine.SETRANGE("No.", _PaymentHeader."No.");
        IF _LineNo <> 0 THEN
            PmtLine.SETRANGE("Line No.", _LineNo);
        IF PmtLine.FINDSET THEN BEGIN
            PTAEntry.RESET;
            IF PTAEntry.FINDLAST THEN
                EntryNo := PTAEntry."Entry No."
            ELSE
                EntryNo := 0;
            REPEAT
                EntryNo += 1;
                PTAEntry.INIT;
                PTAEntry."Entry No." := EntryNo;
                PTAEntry.INSERT(TRUE);
                IF PmtLine."Account Type" = PmtLine."Account Type"::Customer THEN
                    PTAEntry.VALIDATE("Document Type", PTAEntry."Document Type"::"Sales Invoice");
                IF PmtLine."Account Type" = PmtLine."Account Type"::Vendor THEN
                    PTAEntry.VALIDATE("Document Type", PTAEntry."Document Type"::"Purchase Invoice");
                PTAEntry.VALIDATE("Document No.", PmtLine."Applies-to Doc. No.");
                IF _Pozitiv THEN
                    PTAEntry.VALIDATE(Amount, -PmtLine.Amount)
                ELSE
                    PTAEntry.VALIDATE(Amount, PmtLine.Amount);
                PTAEntry.VALIDATE("Payment Document No.", PmtLine."No.");
                PTAEntry.VALIDATE("Payment Document Line No.", PmtLine."Line No.");
                PTAEntry.VALIDATE("Payment Series", _PaymentHeader."Payment Series");
                PTAEntry.VALIDATE("Payment No.", _PaymentHeader."Payment Number");
                IF PmtLine."Account Type" = PmtLine."Account Type"::Customer THEN
                    PTAEntry.VALIDATE("Source Type", PTAEntry."Source Type"::Customer);
                IF PmtLine."Account Type" = PmtLine."Account Type"::Vendor THEN
                    PTAEntry.VALIDATE("Source Type", PTAEntry."Source Type"::Vendor);

                PTAEntry.VALIDATE("Source No.", PmtLine."Account No.");
                PTAEntry.VALIDATE("Payment Class", PmtLine."Payment Class");
                PTAEntry.VALIDATE("Status No.", PmtLine."Status No.");
                PTAEntry.VALIDATE("Due Date", PmtLine."Due Date"); //SSM884
                PTAEntry.MODIFY(TRUE);
            UNTIL PmtLine.NEXT = 0;
        END
        //SSM729<<
    end;



    [IntegrationEvent(true, false)]
    local procedure OnBeforePostGenJnlLine(var _PaymentHeader: Record "SSA Payment Header"; var _InvPostingBuffer: record "SSA Payment Post. Buffer"; var GenJnlLine: Record "Gen. Journal Line")
    begin
    end;

    [IntegrationEvent(true, false)]
    local procedure OnBeforePostGenJnlLineRounding(var _PaymentHeader: Record "SSA Payment Header"; var GenJnlLine: Record "Gen. Journal Line")
    begin
    end;
}

