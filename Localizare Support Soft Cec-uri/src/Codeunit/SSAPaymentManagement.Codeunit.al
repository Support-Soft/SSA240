codeunit 70500 "SSA Payment Management"
{
    // SSM729 SSCAT 22.06.2018 Nr.crt.76-Limita valorica pentru instrumente de plata neincasate- fin

    Permissions = tabledata "Cust. Ledger Entry" = rm,
                  tabledata "Vendor Ledger Entry" = rm;

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

        if StepParameter."Verify Header RIB" and not PaymentHeader."RIB Checked" then
            ERROR(Text008);

        PaymentLine.SETRANGE("No.", PaymentHeader."No.");
        PaymentLine.SETRANGE("Copied To No.", '');

        if StepParameter."Acceptation Code<>No" then begin
            PaymentLine.SETRANGE("Acceptation Code", PaymentLine."Acceptation Code"::No);
            if PaymentLine.FIND('-') then
                ERROR(Text002);
            PaymentLine.SETRANGE("Acceptation Code");
        end;

        if StepParameter."Verify Lines RIB" then begin
            PaymentLine.SETRANGE("RIB Checked", false);
            if PaymentLine.FIND('-') then
                ERROR(Text003);
            PaymentLine.SETRANGE("RIB Checked");
        end;

        if StepParameter."Verify Due Date" then begin
            PaymentLine.SETRANGE("Due Date", 0D);
            if PaymentLine.FIND('-') then
                ERROR(Text006);
            PaymentLine.SETRANGE("Due Date");
        end;

        Step.GET(StepParameter."Payment Class", StepParameter.Line);

        case Step."Action Type" of
            Step."Action Type"::None:
                ActionValidated := true;
            Step."Action Type"::File:
                begin
                    PaymentHeader2.SETRANGE("No.", PaymentHeader."No.");
                    PaymentHeader.Parameter := false;
                    PaymentHeader.MODIFY;
                    COMMIT;
                    REPORT.RUNMODAL(Step."Dataport No.", true, true, PaymentHeader2);
                    PaymentHeader.GET(PaymentHeaderParameter."No.");
                    ActionValidated := PaymentHeader.Parameter;
                end;
            Step."Action Type"::Report:
                begin
                    REPORT.RUNMODAL(Step."Report No.", true, true, PaymentLine);
                    ActionValidated := true;
                end;
            Step."Action Type"::Ledger:
                begin
                    InvPostingBuffer[1].DELETEALL;
                    CopyAndCheckDocDimToTempDocDim;
                    Window.OPEN(
                      '#1#################################\\' +
                      Text005);
                    //SSM729>>
                    PaymentHeader.CALCFIELDS(Amount, "Suma Aplicata");
                    PaymentHeader.TESTFIELD(Amount, -PaymentHeader."Suma Aplicata");
                    //SSM729<<
                    if PaymentLine.FIND('-') then
                        repeat
                            Window.UPDATE(1, Text005 + ' ' + PaymentLine."No." + ' ' + FORMAT(PaymentLine."Line No."));
                            OldPaymentLine := PaymentLine;
                            HeaderAccountUsedGlobally := false;
                            GenerInvPostingBuffer;
                            PaymentLine."Acc. Type last entry Debit" := EntryTypeDebit;
                            PaymentLine."Acc. No. Last entry Debit" := EntryNoAccountDebit;
                            PaymentLine."P. Group Last Entry Debit" := EntryPostGroupDebit;
                            PaymentLine."Acc. Type last entry Credit" := EntryTypeCredit;
                            PaymentLine."Acc. No. Last entry Credit" := EntryNoAccountCredit;
                            PaymentLine."P. Group Last Entry Credit" := EntryPostGroupCredit;
                            PaymentLine.VALIDATE("Status No.", Step."Next Status");
                            PaymentLine.Posted := true;
                            PaymentLine.MODIFY;
                        until PaymentLine.NEXT = 0;
                    Window.CLOSE;
                    GenerEntries;
                    ActionValidated := true;
                end;
        end;

        if ActionValidated then begin
            PaymentHeader.VALIDATE("Status No.", Step."Next Status");
            PaymentHeader.MODIFY;
            PaymentLine.SETRANGE("No.", PaymentHeader."No.");
            if PaymentLine.FINDFIRST then
                repeat
                    PaymentLine.VALIDATE("Status No.", Step."Next Status");
                    PaymentLine.MODIFY;
                until PaymentLine.NEXT = 0;
            //SSM729>>
            if Step."Tip Detalii Aplicari" = Step."Tip Detalii Aplicari"::"Suma Aplicata" then
                CreazaLiniiAplicare(PaymentHeader, true, 0);
            if Step."Tip Detalii Aplicari" = Step."Tip Detalii Aplicari"::"Suma Dezaplicata" then
                CreazaLiniiAplicare(PaymentHeader, false, 0);
            PaymentStatus.GET(PaymentHeader."Payment Class", PaymentHeader."Status No.");
            if PaymentStatus."Auto Archive" then
                ArchiveDocument(PaymentHeader);

            if PaymentStatus."Canceled/Refused" then begin
                COMMIT;
                MESSAGE(Text50000, PaymentHeader."No.");
                NewPaymentHeader.INIT;
                NewPaymentHeader."No." := '';
                NewPaymentHeader.INSERT(true);
                PAGE.RUN(PAGE::"SSA Payment Headers", NewPaymentHeader);
            end;
            //SSM729<<
        end else
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
        if InvPostingBuffer[2].FIND then begin
            InvPostingBuffer[2].VALIDATE(Amount, InvPostingBuffer[2].Amount + InvPostingBuffer[1].Amount);
            InvPostingBuffer[2].VALIDATE("Amount (LCY)", InvPostingBuffer[2]."Amount (LCY)" + InvPostingBuffer[1]."Amount (LCY)");
            InvPostingBuffer[2]."VAT Amount" :=
              InvPostingBuffer[2]."VAT Amount" + InvPostingBuffer[1]."VAT Amount";
            InvPostingBuffer[2]."Line Discount Amount" :=
              InvPostingBuffer[2]."Line Discount Amount" + InvPostingBuffer[1]."Line Discount Amount";
            if InvPostingBuffer[1]."Line Discount Account" <> '' then
                InvPostingBuffer[2]."Line Discount Account" := InvPostingBuffer[1]."Line Discount Account";
            InvPostingBuffer[2]."Inv. Discount Amount" :=
              InvPostingBuffer[2]."Inv. Discount Amount" + InvPostingBuffer[1]."Inv. Discount Amount";
            if InvPostingBuffer[1]."Inv. Discount Account" <> '' then
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
            if not InvPostingBuffer[1]."System-Created Entry" then
                InvPostingBuffer[2]."System-Created Entry" := false;
            InvPostingBuffer[2].MODIFY;
        end else begin
            GLEntryNoTmp += 1;
            InvPostingBuffer[1]."GL Entry No." := GLEntryNoTmp;
            InvPostingBuffer[1].INSERT;
        end;
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
        FromPaymentLine.MARKEDONLY(true);
        if not FromPaymentLine.FIND('-') then
            FromPaymentLine.MARKEDONLY(false);
        if FromPaymentLine.FIND('-') then begin
            Step.GET(FromPaymentLine."Payment Class", "New Step");
            Process.GET(FromPaymentLine."Payment Class");
            if PayNum = '' then begin
                i := 10000;
                NoSeriesMgt.InitSeries(Step."Header Nos. Series", ToBord."No. Series", 0D, ToBord."No.", ToBord."No. Series");
                ToBord."Payment Class" := FromPaymentLine."Payment Class";
                ToBord.VALIDATE("Status No.", Step."Next Status");
                PaymentStatus.GET(ToBord."Payment Class", ToBord."Status No.");
                ToBord."Archiving authorized" := PaymentStatus."Archiving authorized";
                ToBord."Currency Code" := FromPaymentLine."Currency Code";
                ToBord."Currency Factor" := FromPaymentLine."Currency Factor";
                ToBord.InitHeader;
                ToBord.INSERT;
            end else begin
                ToBord.GET(PayNum);
                ToPaymentLine.SETRANGE("No.", PayNum);
                if ToPaymentLine.FIND('+') then
                    i := ToPaymentLine."Line No." + 10000
                else
                    i := 10000;
            end;
            repeat
                ToPaymentLine.COPY(FromPaymentLine);
                ToPaymentLine."No." := ToBord."No.";
                ToPaymentLine."Line No." := i;
                ToPaymentLine.IsCopy := true;
                ToPaymentLine.VALIDATE("Status No.", Step."Next Status");
                ToPaymentLine."Copied To No." := '';
                ToPaymentLine."Copied To Line" := 0;
                ToPaymentLine.Posted := false;
                ToPaymentLine.INSERT(true);
                FromPaymentLine."Copied To No." := ToPaymentLine."No.";
                FromPaymentLine."Copied To Line" := ToPaymentLine."Line No.";
                /*DocDim.SETRANGE("Table ID",DATABASE::"Payment Line");
                DocDim.SETRANGE("Document Type",DocDim."Document Type"::" ");
                DocDim.SETRANGE("Document No.",FromPaymentLine."No.");
                DocDim.SETRANGE("Line No.",FromPaymentLine."Line No.");
                DimManagement.MoveDocDimToDocDim(DocDim,DATABASE::"Payment Line",ToBord."No.",DocDim."Document Type"::" ",i);*/
                FromPaymentLine.MODIFY;
                i += 10000;
            until FromPaymentLine.NEXT = 0;
            PayNum := ToBord."No.";
        end;
    end;

    procedure DeleteLigBorCopy(var FromPaymentLine: Record "SSA Payment Line")
    var
        ToPaymentLine: Record "SSA Payment Line";
    begin
        FromPaymentLine.MARKEDONLY(true);
        ToPaymentLine.SETCURRENTKEY("Copied To No.", "Copied To Line");

        if FromPaymentLine.FIND('-') then
            if FromPaymentLine.Posted then
                MESSAGE(Text016)
            else
                repeat
                    ToPaymentLine.SETRANGE("Copied To No.", FromPaymentLine."No.");
                    ToPaymentLine.SETRANGE("Copied To Line", FromPaymentLine."Line No.");
                    ToPaymentLine.FIND('-');
                    ToPaymentLine."Copied To No." := '';
                    ToPaymentLine."Copied To Line" := 0;
                    ToPaymentLine.MODIFY;
                    FromPaymentLine.DELETE(true);
                until FromPaymentLine.NEXT = 0;
    end;

    procedure GenerInvPostingBuffer()
    var
        NoSeriesMgt: Codeunit NoSeriesManagement;
        PaymentClass: Record "SSA Payment Class";
        PartnerName: Text[100];
        Customer: Record Customer;
        Vendor: Record Vendor;
    begin
        StepLedger.SETRANGE("Payment Class", Step."Payment Class");
        StepLedger.SETRANGE(Line, Step.Line);

        if StepLedger.FIND('-') then begin
            repeat
                CLEAR(InvPostingBuffer[1]);
                SetPostingGroup;
                SetAccountNo;
                InvPostingBuffer[1]."System-Created Entry" := true;
                if (StepLedger.Sign = StepLedger.Sign::Debit) then begin
                    InvPostingBuffer[1].VALIDATE(Amount, ABS(PaymentLine.Amount));
                    InvPostingBuffer[1].VALIDATE("Amount (LCY)", ABS(PaymentLine."Amount (LCY)"));
                end else begin
                    InvPostingBuffer[1].VALIDATE(Amount, ABS(PaymentLine.Amount) * -1);
                    InvPostingBuffer[1].VALIDATE("Amount (LCY)", ABS(PaymentLine."Amount (LCY)") * -1);
                end;
                InvPostingBuffer[1]."Currency Code" := PaymentLine."Currency Code";
                InvPostingBuffer[1]."Currency Factor" := PaymentLine."Currency Factor";
                InvPostingBuffer[1].Correction := PaymentLine.Correction xor Step.Correction;
                if (StepLedger."Detail Level" = StepLedger."Detail Level"::Line) then
                    InvPostingBuffer[1]."Payment Line No." := PaymentLine."Line No."
                else
                    if (StepLedger."Detail Level" = StepLedger."Detail Level"::"Due Date") then
                        InvPostingBuffer[1]."Due Date" := PaymentLine."Due Date";

                InvPostingBuffer[1]."Document Type" := StepLedger."Document Type";
                if StepLedger."Document No." = StepLedger."Document No."::"Header No." then
                    InvPostingBuffer[1]."Document No." := PaymentHeader."No."
                else begin
                    if (InvPostingBuffer[1].Sens = InvPostingBuffer[1].Sens::Positive) and
                       (PaymentLine."Entry No. Debit" = 0) and (PaymentLine."Entry No. Credit" = 0) then begin
                        PaymentClass.GET(PaymentHeader."Payment Class");
                        if PaymentClass."Line No. Series" = '' then
                            PaymentLine.TESTFIELD("Document ID", NoSeriesMgt.GetNextNo(PaymentHeader."No. Series", PaymentLine."Posting Date", false))
                        else
                            PaymentLine.TESTFIELD("Document ID", NoSeriesMgt.GetNextNo(PaymentClass."Line No. Series", PaymentLine."Posting Date",
                              false));
                    end;
                    InvPostingBuffer[1]."Document No." := PaymentLine."Document ID";
                end;
                InvPostingBuffer[1]."Header Document No." := PaymentHeader."No.";
                if StepLedger.Sign = StepLedger.Sign::Debit then begin
                    EntryTypeDebit := InvPostingBuffer[1]."Account Type";
                    EntryNoAccountDebit := InvPostingBuffer[1]."Account No.";
                    EntryPostGroupDebit := InvPostingBuffer[1]."Posting group";
                end else begin
                    EntryTypeCredit := InvPostingBuffer[1]."Account Type";
                    EntryNoAccountCredit := InvPostingBuffer[1]."Account No.";
                    EntryPostGroupCredit := InvPostingBuffer[1]."Posting group";
                end;
                InvPostingBuffer[1]."System-Created Entry" := true;
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
                if (InvPostingBuffer[1].Amount >= 0) xor InvPostingBuffer[1].Correction then
                    PaymentLine."Entry No. Debit" := InvPostingBuffer[1]."GL Entry No."
                else
                    PaymentLine."Entry No. Credit" := InvPostingBuffer[1]."GL Entry No.";
            until StepLedger.NEXT = 0;
            NoSeriesMgt.SaveNoSeries;
        end;
    end;

    procedure SetPostingGroup()
    begin
        if PaymentLine."Account Type" = PaymentLine."Account Type"::Customer then begin
            InvPostingBuffer[1]."Posting group" := PaymentLine."Posting Group";
            if not CustomerPostingGroup.GET(PaymentLine."Posting Group") then
                if not CustomerPostingGroup.GET(StepLedger."Customer Posting Group") then begin
                    if StepLedger."Customer Posting Group" <> '' then
                        ERROR(Text012, StepLedger."Customer Posting Group");
                    Customer.GET(PaymentLine."Account No.");
                    CustomerPostingGroup.GET(Customer."Customer Posting Group");
                end
                else
                    if CustomerPostingGroup."Receivables Account" = '' then
                        ERROR(Text014, StepLedger."Customer Posting Group");
        end;

        if PaymentLine."Account Type" = PaymentLine."Account Type"::Vendor then begin
            if not VendorPostingGroup.GET(PaymentLine."Posting Group") then
                if not VendorPostingGroup.GET(StepLedger."Vendor Posting Group") then begin
                    if StepLedger."Customer Posting Group" <> '' then
                        ERROR(Text013, StepLedger."Vendor Posting Group");
                    Vendor.GET(PaymentLine."Account No.");
                    VendorPostingGroup.GET(Vendor."Vendor Posting Group");
                end
                else
                    if VendorPostingGroup."Payables Account" = '' then
                        ERROR(Text015, StepLedger."Vendor Posting Group");
        end;
    end;

    procedure SetAccountNo()
    begin
        case StepLedger."Accounting Type" of
            StepLedger."Accounting Type"::"Payment Line Account":
                begin
                    InvPostingBuffer[1]."Account Type" := PaymentLine."Account Type";
                    InvPostingBuffer[1]."Account No." := PaymentLine."Account No.";
                    if PaymentLine."Account Type" = PaymentLine."Account Type"::Customer then
                        InvPostingBuffer[1]."Posting group" := CustomerPostingGroup.Code;
                    if PaymentLine."Account Type" = PaymentLine."Account Type"::Vendor then
                        InvPostingBuffer[1]."Posting group" := VendorPostingGroup.Code;
                    InvPostingBuffer[1]."Line No." := PaymentLine."Line No.";
                end;
            StepLedger."Accounting Type"::"Associated G/L Account":
                begin
                    InvPostingBuffer[1]."Account Type" := InvPostingBuffer[1]."Account Type"::"G/L Account";
                    if PaymentLine."Account Type" = PaymentLine."Account Type"::Customer then
                        InvPostingBuffer[1]."Account No." := CustomerPostingGroup."Receivables Account"
                    else
                        InvPostingBuffer[1]."Account No." := VendorPostingGroup."Payables Account";
                    InvPostingBuffer[1]."Line No." := PaymentLine."Line No.";
                end;
            StepLedger."Accounting Type"::"Below Account":
                begin
                    InvPostingBuffer[1]."Account Type" := StepLedger."Account Type";
                    InvPostingBuffer[1]."Account No." := StepLedger."Account No.";
                    if StepLedger."Account No." = '' then begin
                        PaymentHeader.CALCFIELDS("Payment Class Name");
                        if StepLedger.Sign = StepLedger.Sign::Debit then
                            ERROR(Text018, Step.Name, PaymentHeader."Payment Class Name")
                        else
                            ERROR(Text019, Step.Name, PaymentHeader."Payment Class Name");
                    end;
                    if StepLedger."Account Type" = StepLedger."Account Type"::Customer then
                        InvPostingBuffer[1]."Posting group" := StepLedger."Customer Posting Group"
                    else
                        InvPostingBuffer[1]."Posting group" := StepLedger."Vendor Posting Group";
                    InvPostingBuffer[1]."Line No." := PaymentLine."Line No.";
                end;
            StepLedger."Accounting Type"::"G/L Account / Month":
                begin
                    InvPostingBuffer[1]."Account Type" := InvPostingBuffer[1]."Account Type"::"G/L Account";
                    N := DATE2DMY(PaymentLine."Due Date", 2);
                    if N < 10 then Suffix := '0' + FORMAT(N) else Suffix := FORMAT(N);
                    InvPostingBuffer[1]."Account No." := StepLedger.Root + Suffix;
                    InvPostingBuffer[1]."Line No." := PaymentLine."Line No.";
                end;
            StepLedger."Accounting Type"::"G/L Account / Week":
                begin
                    InvPostingBuffer[1]."Account Type" := InvPostingBuffer[1]."Account Type"::"G/L Account";
                    N := DATE2DWY(PaymentLine."Due Date", 2);
                    if N < 10 then Suffix := '0' + FORMAT(N) else Suffix := FORMAT(N);
                    InvPostingBuffer[1]."Account No." := StepLedger.Root + Suffix;
                    InvPostingBuffer[1]."Line No." := PaymentLine."Line No.";
                end;
            StepLedger."Accounting Type"::"Bal. Account Previous Entry":
                begin
                    if (StepLedger.Sign = StepLedger.Sign::Debit) and not (PaymentLine.Correction xor Step.Correction) then begin
                        InvPostingBuffer[1]."Account Type" := PaymentLine."Acc. Type last entry Credit";
                        InvPostingBuffer[1]."Account No." := PaymentLine."Acc. No. Last entry Credit";
                        InvPostingBuffer[1]."Posting group" := PaymentLine."P. Group Last Entry Credit";
                    end else begin
                        InvPostingBuffer[1]."Account Type" := PaymentLine."Acc. Type last entry Debit";
                        InvPostingBuffer[1]."Account No." := PaymentLine."Acc. No. Last entry Debit";
                        InvPostingBuffer[1]."Posting group" := PaymentLine."P. Group Last Entry Debit";
                    end;
                    InvPostingBuffer[1]."Line No." := PaymentLine."Line No.";
                end;
            StepLedger."Accounting Type"::"Header Payment Account":
                begin
                    InvPostingBuffer[1]."Account Type" := PaymentHeader."Account Type";
                    InvPostingBuffer[1]."Account No." := PaymentHeader."Account No.";
                    if PaymentHeader."Account No." = '' then
                        ERROR(Text020);
                    if StepLedger."Detail Level" = StepLedger."Detail Level"::Account then
                        HeaderAccountUsedGlobally := true;
                    InvPostingBuffer[1]."Line No." := 0;
                end;
        end;
    end;

    procedure Application()
    begin
        if StepLedger.Application <> StepLedger.Application::None then begin
            if StepLedger.Application = StepLedger.Application::"Applied Entry" then begin
                InvPostingBuffer[1]."Applies-to Doc. Type" := PaymentLine."Applies-to Doc. Type";
                InvPostingBuffer[1]."Applies-to Doc. No." := PaymentLine."Applies-to Doc. No.";
                InvPostingBuffer[1]."Applies-to ID" := PaymentLine."Applies-to ID";
            end else
                if StepLedger.Application = StepLedger.Application::"Entry Previous Step" then begin
                    InvPostingBuffer[1]."Applies-to ID" := PaymentLine."No." + '/' + FORMAT(PaymentLine."Line No.") + Text011;
                    if InvPostingBuffer[1]."Account Type" = InvPostingBuffer[1]."Account Type"::Customer then begin
                        if (InvPostingBuffer[1].Amount < 0) xor InvPostingBuffer[1].Correction then
                            CustLedgerEntry.SETRANGE("Entry No.", OldPaymentLine."Entry No. Debit")
                        else
                            CustLedgerEntry.SETRANGE("Entry No.", OldPaymentLine."Entry No. Credit");
                        if CustLedgerEntry.FIND('-') then begin
                            CustLedgerEntry."Applies-to ID" := InvPostingBuffer[1]."Applies-to ID";
                            CustLedgerEntry.CALCFIELDS("Remaining Amount");
                            CustLedgerEntry.VALIDATE("Amount to Apply", CustLedgerEntry."Remaining Amount");
                            CustLedgerEntry.MODIFY;
                        end;
                    end else
                        if InvPostingBuffer[1]."Account Type" = InvPostingBuffer[1]."Account Type"::Vendor then begin
                            if (InvPostingBuffer[1].Amount < 0) xor InvPostingBuffer[1].Correction then
                                VendorLedgerEntry.SETRANGE("Entry No.", OldPaymentLine."Entry No. Debit")
                            else
                                VendorLedgerEntry.SETRANGE("Entry No.", OldPaymentLine."Entry No. Credit");
                            if VendorLedgerEntry.FIND('-') then begin
                                VendorLedgerEntry."Applies-to ID" := InvPostingBuffer[1]."Applies-to ID";
                                VendorLedgerEntry.CALCFIELDS("Remaining Amount");
                                VendorLedgerEntry.VALIDATE("Amount to Apply", VendorLedgerEntry."Remaining Amount");
                                VendorLedgerEntry.MODIFY;
                            end;
                        end;
                end else
                    if StepLedger.Application = StepLedger.Application::"Memorized Entry" then begin
                        InvPostingBuffer[1]."Applies-to ID" := PaymentLine."No." + '/' + FORMAT(PaymentLine."Line No.") + Text011;
                        if InvPostingBuffer[1]."Account Type" = InvPostingBuffer[1]."Account Type"::Customer then begin
                            CustLedgerEntry.RESET;
                            if (InvPostingBuffer[1].Amount < 0) xor InvPostingBuffer[1].Correction then
                                CustLedgerEntry.SETRANGE("Entry No.", OldPaymentLine."Entry No. Debit Memo")
                            else
                                CustLedgerEntry.SETRANGE("Entry No.", OldPaymentLine."Entry No. Credit Memo");
                            if CustLedgerEntry.FIND('-') then begin
                                CustLedgerEntry."Applies-to ID" := InvPostingBuffer[1]."Applies-to ID";
                                CustLedgerEntry.CALCFIELDS("Remaining Amount");
                                CustLedgerEntry.VALIDATE("Amount to Apply", CustLedgerEntry."Remaining Amount");
                                CustLedgerEntry.MODIFY;
                            end;
                        end else
                            if InvPostingBuffer[1]."Account Type" = InvPostingBuffer[1]."Account Type"::Vendor then begin
                                if (InvPostingBuffer[1].Amount < 0) xor InvPostingBuffer[1].Correction then
                                    VendorLedgerEntry.SETRANGE("Entry No.", OldPaymentLine."Entry No. Debit Memo")
                                else
                                    VendorLedgerEntry.SETRANGE("Entry No.", OldPaymentLine."Entry No. Credit Memo");
                                if VendorLedgerEntry.FIND('-') then begin
                                    VendorLedgerEntry."Applies-to ID" := InvPostingBuffer[1]."Applies-to ID";
                                    VendorLedgerEntry.CALCFIELDS("Remaining Amount");
                                    VendorLedgerEntry.VALIDATE("Amount to Apply", VendorLedgerEntry."Remaining Amount");
                                    VendorLedgerEntry.MODIFY;
                                end;
                            end;
                    end;
        end;
        InvPostingBuffer[1]."Due Date" := PaymentLine."Due Date"; // FR Payment due date
    end;

    procedure GenerEntries()
    var
        CurrExchRate: Record "Currency Exchange Rate";
        Difference: Decimal;
        Currency: Record Currency;
        Text100: Label 'Rounding on ';
    begin
        if InvPostingBuffer[1].FIND('+') then
            repeat
                GenJnlLine.INIT;
                GenJnlLine."Posting Date" := PaymentHeader."Posting Date";
                GenJnlLine."Document Date" := PaymentHeader."Document Date";
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
                if PaymentHeader."Source Code" <> '' then begin
                    TestSourceCode(PaymentHeader."Source Code");
                    GenJnlLine."Source Code" := PaymentHeader."Source Code";
                end else begin
                    Step.TESTFIELD("Source Code");
                    TestSourceCode(Step."Source Code");
                    GenJnlLine."Source Code" := Step."Source Code";
                end;
                GenJnlLine."Applies-to Doc. Type" := InvPostingBuffer[1]."Applies-to Doc. Type";
                GenJnlLine."Applies-to Doc. No." := InvPostingBuffer[1]."Applies-to Doc. No.";
                if GenJnlLine."Applies-to Doc. No." = '' then
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
                if GenJnlLine.Amount >= 0 then begin
                    PaymentLine.SETRANGE("Entry No. Debit", InvPostingBuffer[1]."GL Entry No.");
                    StepLedger.GET(Step."Payment Class", Step.Line, StepLedger.Sign::Debit);
                    if StepLedger."Memorize Entry" then
                        PaymentLine.MODIFYALL(PaymentLine."Entry No. Debit Memo", GenJnlLine."SSA Entry No.");
                    PaymentLine.MODIFYALL("Entry No. Debit", GenJnlLine."SSA Entry No.");
                end else begin
                    PaymentLine.SETRANGE("Entry No. Credit", InvPostingBuffer[1]."GL Entry No.");
                    StepLedger.GET(Step."Payment Class", Step.Line, StepLedger.Sign::Credit);
                    if StepLedger."Memorize Entry" then
                        PaymentLine.MODIFYALL(PaymentLine."Entry No. Credit Memo", GenJnlLine."SSA Entry No.");
                    PaymentLine.MODIFYALL("Entry No. Credit", GenJnlLine."SSA Entry No.");
                end;
            until InvPostingBuffer[1].NEXT(-1) = 0;

        if HeaderAccountUsedGlobally then begin
            PaymentHeader.CALCFIELDS(Amount, "Amount (LCY)");
            Difference := PaymentHeader."Amount (LCY)" - ROUND(CurrExchRate.ExchangeAmtFCYToLCY(PaymentHeader."Posting Date",
              PaymentHeader."Currency Code", PaymentHeader.Amount, PaymentHeader."Currency Factor"));
            if Difference <> 0 then begin
                GenJnlLine.INIT;
                GenJnlLine."Account Type" := GenJnlLine."Account Type"::"G/L Account";
                Currency.GET(PaymentHeader."Currency Code");
                if Difference < 0 then begin
                    GenJnlLine."Account No." := Currency."Unrealized Losses Acc.";
                    StepLedger.GET(Step."Payment Class", Step.Line, StepLedger.Sign::Debit);
                    GenJnlLine.VALIDATE("Debit Amount", -Difference);
                end else begin
                    GenJnlLine."Account No." := Currency."Unrealized Gains Acc.";
                    StepLedger.GET(Step."Payment Class", Step.Line, StepLedger.Sign::Credit);
                    GenJnlLine.VALIDATE("Credit Amount", Difference);
                end;
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
            end;
        end;

        InvPostingBuffer[1].DELETEALL;
    end;

    local procedure GetIntegerPos(No: Code[20]; var StartPos: Integer; var EndPos: Integer)
    var
        IsDigit: Boolean;
        i: Integer;
    begin
        StartPos := 0;
        EndPos := 0;
        if No <> '' then begin
            i := STRLEN(No);
            repeat
                IsDigit := No[i] in ['0' .. '9'];
                if IsDigit then begin
                    if EndPos = 0 then
                        EndPos := i;
                    StartPos := i;
                end;
                i := i - 1;
            until (i = 0) or (StartPos <> 0) and not IsDigit;
        end;
        if (StartPos = 0) and (EndPos = 0) then
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
        if StartPos > 1 then
            StartNo := COPYSTR(No, 1, StartPos - 1);
        if EndPos < STRLEN(No) then
            EndNo := COPYSTR(No, EndPos + 1);
        NewLength := STRLEN(NewNo);
        OldLength := EndPos - StartPos + 1;
        if FixedLength > OldLength then
            OldLength := FixedLength;
        if OldLength > NewLength then
            ZeroNo := PADSTR('', OldLength - NewLength, '0');
        if STRLEN(StartNo) + STRLEN(ZeroNo) + STRLEN(NewNo) + STRLEN(EndNo) > 20 then
            ERROR(
              Text001,
              No);
        No := StartNo + ZeroNo + NewNo + EndNo;
    end;

    procedure CreatePaymentHeaders()
    begin
        Step.SETRANGE(Step."Action Type", Step."Action Type"::"Create new Document");

        if StepSelect('', -1, Step, true) then
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
        InserForm.LOOKUPMODE(true);
        if InserForm.RUNMODAL = ACTION::LookupOK then
            if CONFIRM(Text023) then begin
                InserForm.SetSelection(PaymentLine);
                CopyLigBor(PaymentLine, PaymtStep.Line, PayNum);
                if Bor.GET(PayNum) then begin
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
                end else
                    ERROR(Text004);
            end;
        exit(PayNum);
    end;

    procedure LinesInsert(HeaderNumber: Code[20])
    var
        Header: Record "SSA Payment Header";
        PaymentLine: Record "SSA Payment Line";
        InserForm: Page "SSA Payment Lines List";
        Step: Record "SSA Payment Step";
    begin
        Header.GET(HeaderNumber);
        if StepSelect(Header."Payment Class", Header."Status No.", Step, false) then begin
            PaymentLine.SETRANGE("Payment Class", Header."Payment Class");
            PaymentLine.SETRANGE("Copied To No.", '');
            PaymentLine.SETFILTER("Status No.", FORMAT(Step."Previous Status"));
            PaymentLine.SETRANGE("Currency Code", Header."Currency Code");
            PaymentLine.FILTERGROUP(2);

            InserForm.SETRECORD(PaymentLine);
            InserForm.SETTABLEVIEW(PaymentLine);
            InserForm.LOOKUPMODE(true);
            if InserForm.RUNMODAL = ACTION::LookupOK then begin
                InserForm.SetSelection(PaymentLine);
                CopyLigBor(PaymentLine, Step.Line, Header."No.");
            end;
            /*PS12301 start deletion
            InserForm.SetSteps(Step.Line);
            InserForm.SetNumBor(Header."No.");
            InserForm.SETTABLEVIEW(PaymentLine);
            InserForm.RUNMODAL;
            deletion end PS12301*/
        end;
    end;

    procedure StepSelect(Process: Text[30]; NextStatus: Integer; var Step: Record "SSA Payment Step"; CreateDocumentFilter: Boolean) OK: Boolean
    var
        Options: Text[250];
        PaymentClass: Record "SSA Payment Class";
        Choice: Integer;
        i: Integer;
    begin
        OK := false;
        i := 0;
        if Process = '' then begin
            PaymentClass.SETRANGE(Enable, true);
            if CreateDocumentFilter then
                PaymentClass.SETRANGE("Is create document", true);
            if PaymentClass.FIND('-') then
                repeat
                    i += 1;
                    if Options = '' then
                        Options := PaymentClass.Code
                    else
                        Options := Options + ',' + PaymentClass.Code;
                until PaymentClass.NEXT = 0;
            if i > 0 then
                Choice := STRMENU(Options, 1);
            i := 1;
            if Choice > 0 then begin
                PaymentClass.FIND('-');
                while Choice > i do begin
                    i += 1;
                    PaymentClass.NEXT;
                end;
            end;
        end else begin
            PaymentClass.GET(Process);
            Choice := 1;
        end;
        if Choice > 0 then begin
            Options := '';
            Step.SETRANGE("Payment Class", PaymentClass.Code);
            Step.SETRANGE("Action Type", Step."Action Type"::"Create new Document");
            if NextStatus > -1 then
                Step.SETRANGE("Next Status", NextStatus);
            i := 0;
            if Step.FIND('-') then begin
                i += 1;
                repeat
                    if Options = '' then
                        Options := Step.Name
                    else
                        Options := Options + ',' + Step.Name;
                until Step.NEXT = 0;
                if i > 0 then begin
                    Choice := STRMENU(Options, 1);
                    i := 1;
                    if Choice > 0 then begin
                        Step.FIND('-');
                        while Choice > i do begin
                            i += 1;
                            Step.NEXT;
                        end;
                        OK := true;
                    end;
                end;
            end;
        end;
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
        if not SourceCode.GET(Code) then
            ERROR(Text017, Code);
    end;

    procedure PaymentAddr(var AddrArray: array[8] of Text[50]; PaymentAddress: Record "SSA Payment Address")
    var
        FormatAddress: Codeunit "Format Address";
    begin
        FormatAddress.FormatAddr(
  AddrArray, PaymentAddress.Name, PaymentAddress."Name 2", PaymentAddress.Contact, PaymentAddress.Address, PaymentAddress."Address 2",
  PaymentAddress.City, PaymentAddress."Post Code", PaymentAddress.County, PaymentAddress."Country/Region Code");
    end;

    procedure PaymentBankAcc(var AddrArray: array[8] of Text[50]; BankAcc: Record "SSA Payment Header")
    var
        FormatAddress: Codeunit "Format Address";
    begin
        FormatAddress.FormatAddr(
  AddrArray, BankAcc."Bank Name", BankAcc."Bank Name 2", BankAcc."Bank Contact", BankAcc."Bank Address", BankAcc."Bank Address 2",
  BankAcc."Bank City", BankAcc."Bank Post Code", BankAcc."Bank County", BankAcc."Bank Country/Region Code");
    end;

    procedure ArchiveDocument(Document: Record "SSA Payment Header")
    var
        ArchiveHeader: Record "SSA Payment Header Archive";
        ArchiveLine: Record "SSA Payment Line Archive";
        PaymentLine: Record "SSA Payment Line";
    begin
        Document.CALCFIELDS("Archiving authorized");
        if not Document."Archiving authorized" then
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
        if PaymentLine.FIND('-') then
            repeat
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
            until PaymentLine.NEXT = 0;
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
        if _LineNo <> 0 then
            PmtLine.SETRANGE("Line No.", _LineNo);
        if PmtLine.FINDSET then begin
            PTAEntry.RESET;
            if PTAEntry.FINDLAST then
                EntryNo := PTAEntry."Entry No."
            else
                EntryNo := 0;
            repeat
                EntryNo += 1;
                PTAEntry.INIT;
                PTAEntry."Entry No." := EntryNo;
                PTAEntry.INSERT(true);
                if PmtLine."Account Type" = PmtLine."Account Type"::Customer then
                    PTAEntry.VALIDATE("Document Type", PTAEntry."Document Type"::"Sales Invoice");
                if PmtLine."Account Type" = PmtLine."Account Type"::Vendor then
                    PTAEntry.VALIDATE("Document Type", PTAEntry."Document Type"::"Purchase Invoice");
                PTAEntry.VALIDATE("Document No.", PmtLine."Applies-to Doc. No.");
                if _Pozitiv then
                    PTAEntry.VALIDATE(Amount, -PmtLine.Amount)
                else
                    PTAEntry.VALIDATE(Amount, PmtLine.Amount);
                PTAEntry.VALIDATE("Payment Document No.", PmtLine."No.");
                PTAEntry.VALIDATE("Payment Document Line No.", PmtLine."Line No.");
                PTAEntry.VALIDATE("Payment Series", _PaymentHeader."Payment Series");
                PTAEntry.VALIDATE("Payment No.", _PaymentHeader."Payment Number");
                if PmtLine."Account Type" = PmtLine."Account Type"::Customer then
                    PTAEntry.VALIDATE("Source Type", PTAEntry."Source Type"::Customer);
                if PmtLine."Account Type" = PmtLine."Account Type"::Vendor then
                    PTAEntry.VALIDATE("Source Type", PTAEntry."Source Type"::Vendor);

                PTAEntry.VALIDATE("Source No.", PmtLine."Account No.");
                PTAEntry.VALIDATE("Payment Class", PmtLine."Payment Class");
                PTAEntry.VALIDATE("Status No.", PmtLine."Status No.");
                PTAEntry.VALIDATE("Due Date", PmtLine."Due Date"); //SSM884
                PTAEntry.MODIFY(true);
            until PmtLine.NEXT = 0;
        end
        //SSM729<<
    end;

    [IntegrationEvent(true, false)]
    local procedure OnBeforePostGenJnlLine(var _PaymentHeader: Record "SSA Payment Header"; var _InvPostingBuffer: Record "SSA Payment Post. Buffer"; var GenJnlLine: Record "Gen. Journal Line")
    begin
    end;

    [IntegrationEvent(true, false)]
    local procedure OnBeforePostGenJnlLineRounding(var _PaymentHeader: Record "SSA Payment Header"; var GenJnlLine: Record "Gen. Journal Line")
    begin
    end;
}
