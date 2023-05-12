report 70503 "SSA Suggest Vendor Payments"
{

    Caption = 'Suggest Vendor Payments';
    Permissions = TableData "Vendor Ledger Entry" = rm;
    ProcessingOnly = true;

    dataset
    {
        dataitem(Vendor; Vendor)
        {
            DataItemTableView = SORTING("No.");
            RequestFilterFields = "No.", "Payment Method Code";

            trigger OnAfterGetRecord()
            begin
                IF StopPayments THEN
                    CurrReport.BREAK;
                Window.UPDATE(1, "No.");
                GetVendLedgEntries(TRUE, FALSE);
                GetVendLedgEntries(FALSE, FALSE);
                CheckAmounts(FALSE);
            end;

            trigger OnPostDataItem()
            begin
                IF UsePriority AND NOT StopPayments THEN BEGIN
                    RESET;
                    COPYFILTERS(Vend2);
                    SETCURRENTKEY(Priority);
                    SETRANGE(Priority, 0);
                    IF FIND('-') THEN
                        REPEAT
                            Window.UPDATE(1, "No.");
                            GetVendLedgEntries(TRUE, FALSE);
                            GetVendLedgEntries(FALSE, FALSE);
                            CheckAmounts(FALSE);
                        UNTIL (NEXT = 0) OR StopPayments;
                END;

                IF UsePaymentDisc AND NOT StopPayments THEN BEGIN
                    RESET;
                    COPYFILTERS(Vend2);
                    Window.OPEN(Text007);
                    IF FIND('-') THEN
                        REPEAT
                            Window.UPDATE(1, "No.");
                            PayableVendLedgEntry.SETRANGE("Vendor No.", "No.");
                            GetVendLedgEntries(TRUE, TRUE);
                            GetVendLedgEntries(FALSE, TRUE);
                            CheckAmounts(TRUE);
                        UNTIL (NEXT = 0) OR StopPayments;
                END;

                GenPayLine.LOCKTABLE;
                GenPayLine.SETRANGE("No.", GenPayLine."No.");
                IF GenPayLine.FIND('+') THEN BEGIN
                    FirstLineNo := GenPayLine."Line No.";
                    LastLineNo := GenPayLine."Line No.";
                    GenPayLine.INIT;
                END;

                Window.OPEN(Text008);

                PayableVendLedgEntry.RESET;
                PayableVendLedgEntry.SETRANGE(Priority, 1, 2147483647);
                MakeGenPayLines;
                PayableVendLedgEntry.RESET;
                PayableVendLedgEntry.SETRANGE(Priority, 0);
                MakeGenPayLines;
                PayableVendLedgEntry.RESET;
                PayableVendLedgEntry.DELETEALL;

                Window.CLOSE;
                ShowMessage(MessageText);
            end;

            trigger OnPreDataItem()
            begin
                IF LastDueDateToPayReq = 0D THEN
                    ERROR(Text000);
                IF PostingDate = 0D THEN
                    ERROR(Text001);

                GenPayLineInserted := FALSE;
                SeveralCurrencies := FALSE;
                MessageText := '';

                IF UsePaymentDisc AND (LastDueDateToPayReq < WORKDATE) THEN
                    IF NOT
                       CONFIRM(
                         Text003 +
                         Text004, FALSE,
                         WORKDATE)
                    THEN
                        ERROR(Text005);

                Vend2.COPYFILTERS(Vendor);

                OriginalAmtAvailable := AmountAvailable;
                IF AmountAvailable > 0 THEN BEGIN
                    SETCURRENTKEY(Priority);
                    SETRANGE(Priority, 1, 2147483647);
                    UsePriority := TRUE;
                END;
                Window.OPEN(Text006);

                NextEntryNo := 1;
            end;
        }
    }

    requestpage
    {
        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(LastDueDateToPayReq; LastDueDateToPayReq)
                    {
                        Caption = 'Last Payment Date';
                    }
                    field(UsePaymentDisc; UsePaymentDisc)
                    {
                        Caption = 'Find Payment Discounts';
                        MultiLine = true;
                    }
                    field(SummarizePer; SummarizePer)
                    {
                        Caption = 'Summarize per';
                        OptionCaption = ' ,Vendor,Due date';
                    }
                    field(UsePriority; UsePriority)
                    {
                        Caption = 'Use Vendor Priority';

                        trigger OnValidate()
                        begin
                            IF NOT UsePriority AND (AmountAvailable <> 0) THEN
                                ERROR(Text011);
                        end;
                    }
                    field(AmountAvailable; AmountAvailable)
                    {
                        Caption = 'Available Amount (LCY)';

                        trigger OnValidate()
                        begin
                            AmountAvailableOnAfterValidate;
                        end;
                    }
                    field(CurrencyFilter; CurrencyFilter)
                    {
                        Caption = 'Currency Filter';
                        Editable = false;
                        TableRelation = Currency;
                    }
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    var
        Text000: Label 'Please enter the last payment date.';
        Text001: Label 'Please enter the posting date.';
        Text002: Label 'Please enter a Starting Document No.';
        Text003: Label 'The selected last due date is earlier than %1.\\';
        Text004: Label 'Do you still want to run the batch job?';
        Text005: Label 'The batch job was interrupted.';
        Text006: Label 'Processing vendors     #1##########';
        Text007: Label 'Processing vendors for payment discounts #1##########';
        Text008: Label 'Inserting payment journal lines #1##########';
        Text009: Label '%1 must be G/L Account or Bank Account.';
        Text010: Label '%1 must be filled only when %2 is Bank Account.';
        Text011: Label 'Use Vendor Priority must be activated when the value in the Amount Available field is not 0.';
        Text012: Label 'Starting Document No. must contain a number.';
        Text013: Label 'Use Vendor Priority must be activated when the value in the Amount Available Amount (LCY) field is not 0.';
        Text014: Label 'Payment to vendor %1';
        Text015: Label 'Payment of %1 %2';
        Text016: Label ' is already applied to %1 %2 for vendor %3.';
        Text017: Label 'When %1 = %2 and you have not placed a check mark in the Summarize per Vendor field,\';
        Text018: Label 'then you must place a check mark in New Doc. No. per Line.';
        Text019: Label 'You have only created suggested vendor payment lines for the %1 %2.\';
        Text020: Label 'There are, however, other open vendor ledger entries in currencies other than %2.';
        Text021: Label 'There are no other open vendor ledger entries in other currencies.';
        Text022: Label 'You have created suggested vendor payment lines for all currencies.';
        Text023: Label ' ,Computer Check,Manual Check';
        Vend2: Record Vendor;
        GenPayHead: Record "SSA Payment Header";
        GenPayLine: Record "SSA Payment Line";
        VendLedgEntry: Record "Vendor Ledger Entry";
        GLAcc: Record "G/L Account";
        BankAcc: Record "Bank Account";
        PayableVendLedgEntry: Record "Payable Vendor Ledger Entry" temporary;
        TempPaymentPostBuffer: Record "SSA Payment Post. Buffer" temporary;
        OldTempPaymentPostBuffer: Record "SSA Payment Post. Buffer" temporary;
        NoSeriesMgt: Codeunit NoSeriesManagement;
        VendEntryEdit: Codeunit "Vend. Entry-Edit";
        Window: Dialog;
        UsePaymentDisc: Boolean;
        PostingDate: Date;
        LastDueDateToPayReq: Date;
        NextDocNo: Code[20];
        AmountAvailable: Decimal;
        OriginalAmtAvailable: Decimal;
        UsePriority: Boolean;
        SummarizePer: Option " ",Vendor,"Due date";
        FirstLineNo: Integer;
        LastLineNo: Integer;
        NextEntryNo: Integer;
        StopPayments: Boolean;
        MessageText: Text[250];
        GenPayLineInserted: Boolean;
        SeveralCurrencies: Boolean;
        PaymentClass: Record "SSA Payment Class";
        CurrencyFilter: Code[10];

    procedure SetGenPayLine(NewGenPayLine: Record "SSA Payment Header")
    begin
        GenPayHead := NewGenPayLine;
        GenPayLine."No." := NewGenPayLine."No.";
        PaymentClass.GET(GenPayHead."Payment Class");
        PostingDate := GenPayHead."Posting Date";
        CurrencyFilter := GenPayHead."Currency Code";
    end;

    procedure GetVendLedgEntries(Positive: Boolean; Future: Boolean)
    begin
        VendLedgEntry.RESET;
        VendLedgEntry.SETCURRENTKEY("Vendor No.", Open, Positive, "Due Date");
        VendLedgEntry.SETRANGE("Vendor No.", Vendor."No.");
        VendLedgEntry.SETRANGE(Open, TRUE);
        VendLedgEntry.SETRANGE(Positive, Positive);
        VendLedgEntry.SETRANGE("Currency Code", CurrencyFilter);
        VendLedgEntry.SETRANGE("Applies-to ID", '');
        IF Future THEN BEGIN
            VendLedgEntry.SETRANGE("Due Date", LastDueDateToPayReq + 1, 99991231D);
            VendLedgEntry.SETRANGE("Pmt. Discount Date", PostingDate, LastDueDateToPayReq);
            VendLedgEntry.SETFILTER("Original Pmt. Disc. Possible", '<0');
        END ELSE
            VendLedgEntry.SETRANGE("Due Date", 0D, LastDueDateToPayReq);
        VendLedgEntry.SETRANGE("On Hold", '');
        IF VendLedgEntry.FIND('-') THEN
            REPEAT
                SaveAmount;
            UNTIL VendLedgEntry.NEXT = 0;
    end;

    local procedure SaveAmount()
    begin
        WITH GenPayLine DO BEGIN
            "Account Type" := "Account Type"::Vendor;
            VALIDATE("Account No.", VendLedgEntry."Vendor No.");
            "Posting Date" := VendLedgEntry."Posting Date";
            "Currency Factor" := VendLedgEntry."Adjusted Currency Factor";
            IF "Currency Factor" = 0 THEN
                "Currency Factor" := 1;
            VALIDATE("Currency Code", VendLedgEntry."Currency Code");
            VendLedgEntry.CALCFIELDS("Remaining Amount");
            IF (VendLedgEntry."Document Type" = VendLedgEntry."Document Type"::Invoice) AND
               (PostingDate <= VendLedgEntry."Pmt. Discount Date")
            THEN
                Amount := -(VendLedgEntry."Remaining Amount" - VendLedgEntry."Original Pmt. Disc. Possible")
            ELSE
                Amount := -VendLedgEntry."Remaining Amount";
            VALIDATE(Amount);
        END;

        IF UsePriority THEN
            PayableVendLedgEntry.Priority := Vendor.Priority
        ELSE
            PayableVendLedgEntry.Priority := 0;
        PayableVendLedgEntry."Vendor No." := VendLedgEntry."Vendor No.";
        PayableVendLedgEntry."Entry No." := NextEntryNo;
        PayableVendLedgEntry."Vendor Ledg. Entry No." := VendLedgEntry."Entry No.";
        PayableVendLedgEntry.Amount := GenPayLine.Amount;
        PayableVendLedgEntry."Amount (LCY)" := GenPayLine."Amount (LCY)";
        PayableVendLedgEntry.Positive := (PayableVendLedgEntry.Amount > 0);
        PayableVendLedgEntry.Future := (VendLedgEntry."Due Date" > LastDueDateToPayReq);
        PayableVendLedgEntry."Currency Code" := VendLedgEntry."Currency Code";
        PayableVendLedgEntry.INSERT;
        NextEntryNo := NextEntryNo + 1;
    end;

    procedure CheckAmounts(Future: Boolean)
    var
        CurrencyBalance: Decimal;
        PrevCurrency: Code[10];
    begin
        PayableVendLedgEntry.SETRANGE("Vendor No.", Vendor."No.");
        PayableVendLedgEntry.SETRANGE(Future, Future);
        IF PayableVendLedgEntry.FIND('-') THEN BEGIN
            PrevCurrency := PayableVendLedgEntry."Currency Code";
            REPEAT
                IF PayableVendLedgEntry."Currency Code" <> PrevCurrency THEN BEGIN
                    IF CurrencyBalance < 0 THEN BEGIN
                        PayableVendLedgEntry.SETRANGE("Currency Code", PrevCurrency);
                        PayableVendLedgEntry.DELETEALL;
                        PayableVendLedgEntry.SETRANGE("Currency Code");
                    END ELSE
                        AmountAvailable := AmountAvailable - CurrencyBalance;
                    CurrencyBalance := 0;
                    PrevCurrency := PayableVendLedgEntry."Currency Code";
                END;
                IF (OriginalAmtAvailable = 0) OR
                   (AmountAvailable >= CurrencyBalance + PayableVendLedgEntry."Amount (LCY)")
                THEN
                    CurrencyBalance := CurrencyBalance + PayableVendLedgEntry."Amount (LCY)"
                ELSE
                    PayableVendLedgEntry.DELETE;
            UNTIL PayableVendLedgEntry.NEXT = 0;
            IF CurrencyBalance < 0 THEN BEGIN
                PayableVendLedgEntry.SETRANGE("Currency Code", PrevCurrency);
                PayableVendLedgEntry.DELETEALL;
                PayableVendLedgEntry.SETRANGE("Currency Code");
            END ELSE
                IF OriginalAmtAvailable > 0 THEN
                    AmountAvailable := AmountAvailable - CurrencyBalance;
            IF (OriginalAmtAvailable > 0) AND (AmountAvailable <= 0) THEN
                StopPayments := TRUE;
        END;
        PayableVendLedgEntry.RESET;
    end;

    local procedure MakeGenPayLines()
    var
        GenPayLine3: Record "Gen. Journal Line";
        EntryNo: Integer;
    begin
        TempPaymentPostBuffer.DELETEALL;

        IF PayableVendLedgEntry.FIND('-') THEN
            REPEAT
                PayableVendLedgEntry.SETRANGE("Vendor No.", PayableVendLedgEntry."Vendor No.");
                PayableVendLedgEntry.FIND('-');
                REPEAT
                    VendLedgEntry.GET(PayableVendLedgEntry."Vendor Ledg. Entry No.");
                    TempPaymentPostBuffer."Account No." := VendLedgEntry."Vendor No.";
                    TempPaymentPostBuffer."Currency Code" := VendLedgEntry."Currency Code";
                    IF SummarizePer = SummarizePer::"Due date" THEN
                        TempPaymentPostBuffer."Due Date" := VendLedgEntry."Due Date";

                    //TempPaymentPostBuffer."Dimension Set ID" := 0;
                    TempPaymentPostBuffer."Global Dimension 1 Code" := '';
                    TempPaymentPostBuffer."Global Dimension 2 Code" := '';

                    IF SummarizePer IN [SummarizePer::Vendor, SummarizePer::"Due date"] THEN BEGIN
                        TempPaymentPostBuffer."Auxiliary Entry No." := 0;
                        IF TempPaymentPostBuffer.FIND THEN BEGIN
                            TempPaymentPostBuffer.Amount := TempPaymentPostBuffer.Amount + PayableVendLedgEntry.Amount;
                            TempPaymentPostBuffer."Amount (LCY)" := TempPaymentPostBuffer."Amount (LCY)" + PayableVendLedgEntry."Amount (LCY)";
                            TempPaymentPostBuffer.MODIFY;
                        END ELSE BEGIN
                            LastLineNo := LastLineNo + 10000;
                            TempPaymentPostBuffer."Payment Line No." := LastLineNo;
                            IF PaymentClass."Line No. Series" = '' THEN
                                NextDocNo := GenPayHead."No." + '/' + FORMAT(LastLineNo)
                            ELSE
                                NextDocNo := NoSeriesMgt.GetNextNo(PaymentClass."Line No. Series", PostingDate, FALSE);
                            TempPaymentPostBuffer."Document No." := NextDocNo;
                            NextDocNo := INCSTR(NextDocNo);
                            TempPaymentPostBuffer.Amount := PayableVendLedgEntry.Amount;
                            TempPaymentPostBuffer."Amount (LCY)" := PayableVendLedgEntry."Amount (LCY)";
                            Window.UPDATE(1, VendLedgEntry."Vendor No.");
                            TempPaymentPostBuffer.INSERT;
                        END;
                        VendLedgEntry."Applies-to ID" := TempPaymentPostBuffer."Document No.";
                        VendEntryEdit.RUN(VendLedgEntry)
                    END ELSE BEGIN
                        GenPayLine3.RESET;
                        GenPayLine3.SETCURRENTKEY(
                          "Account Type", "Account No.", "Applies-to Doc. Type", "Applies-to Doc. No.");
                        GenPayLine3.SETRANGE("Account Type", GenPayLine3."Account Type"::Vendor);
                        GenPayLine3.SETRANGE("Account No.", VendLedgEntry."Vendor No.");
                        GenPayLine3.SETRANGE("Applies-to Doc. Type", VendLedgEntry."Document Type");
                        GenPayLine3.SETRANGE("Applies-to Doc. No.", VendLedgEntry."Document No.");
                        IF GenPayLine3.FIND('-') THEN
                            GenPayLine3.FIELDERROR(
                              "Applies-to Doc. No.",
                              STRSUBSTNO(
                                Text016,
                                VendLedgEntry."Document Type", VendLedgEntry."Document No.",
                                VendLedgEntry."Vendor No."));

                        TempPaymentPostBuffer."Applies-to Doc. Type" := VendLedgEntry."Document Type";
                        TempPaymentPostBuffer."Applies-to Doc. No." := VendLedgEntry."Document No.";
                        TempPaymentPostBuffer."Currency Factor" := VendLedgEntry."Adjusted Currency Factor";
                        TempPaymentPostBuffer.Amount := PayableVendLedgEntry.Amount;
                        TempPaymentPostBuffer."Amount (LCY)" := PayableVendLedgEntry."Amount (LCY)";
                        TempPaymentPostBuffer."Global Dimension 1 Code" := VendLedgEntry."Global Dimension 1 Code";
                        TempPaymentPostBuffer."Global Dimension 2 Code" := VendLedgEntry."Global Dimension 2 Code";
                        TempPaymentPostBuffer."Auxiliary Entry No." := VendLedgEntry."Entry No.";
                        Window.UPDATE(1, VendLedgEntry."Vendor No.");
                        TempPaymentPostBuffer.INSERT;
                    END;
                    VendLedgEntry.CALCFIELDS(VendLedgEntry."Remaining Amount");
                    VendLedgEntry."Amount to Apply" := VendLedgEntry."Remaining Amount";
                    VendEntryEdit.RUN(VendLedgEntry);
                UNTIL PayableVendLedgEntry.NEXT = 0;
                PayableVendLedgEntry.DELETEALL;
                PayableVendLedgEntry.SETRANGE("Vendor No.");
            UNTIL NOT PayableVendLedgEntry.FIND('-');

        CLEAR(OldTempPaymentPostBuffer);
        TempPaymentPostBuffer.SETCURRENTKEY("Document No.");
        IF TempPaymentPostBuffer.FIND('-') THEN
            REPEAT
                WITH GenPayLine DO BEGIN
                    INIT;
                    Window.UPDATE(1, TempPaymentPostBuffer."Account No.");
                    IF SummarizePer = SummarizePer::" " THEN BEGIN
                        LastLineNo := LastLineNo + 10000;
                        "Line No." := LastLineNo;
                        IF PaymentClass."Line No. Series" = '' THEN
                            NextDocNo := GenPayHead."No." + '/' + FORMAT(GenPayLine."Line No.")
                        ELSE
                            NextDocNo := NoSeriesMgt.GetNextNo(PaymentClass."Line No. Series", PostingDate, FALSE);
                    END ELSE BEGIN
                        "Line No." := TempPaymentPostBuffer."Payment Line No.";
                        NextDocNo := TempPaymentPostBuffer."Document No.";
                    END;
                    "Document ID" := NextDocNo;
                    GenPayLine."Applies-to ID" := "Document ID";
                    OldTempPaymentPostBuffer := TempPaymentPostBuffer;
                    OldTempPaymentPostBuffer."Document No." := "Document ID";
                    IF SummarizePer = SummarizePer::" " THEN BEGIN
                        VendLedgEntry.GET(TempPaymentPostBuffer."Auxiliary Entry No.");
                        VendLedgEntry."Applies-to ID" := NextDocNo;
                        VendLedgEntry.MODIFY;
                    END;
                    "Account Type" := "Account Type"::Vendor;
                    VALIDATE("Account No.", TempPaymentPostBuffer."Account No.");
                    "Currency Code" := TempPaymentPostBuffer."Currency Code";
                    Amount := TempPaymentPostBuffer.Amount;
                    IF Amount > 0 THEN
                        "Debit Amount" := Amount
                    ELSE
                        "Credit Amount" := -Amount;
                    "Amount (LCY)" := TempPaymentPostBuffer."Amount (LCY)";
                    "Currency Factor" := TempPaymentPostBuffer."Currency Factor";
                    IF ("Currency Factor" = 0) AND (Amount <> 0) THEN
                        "Currency Factor" := Amount / "Amount (LCY)";
                    Vend2.GET(GenPayLine."Account No.");
                    VALIDATE(GenPayLine."Bank Account", Vend2."SSA Default Bank Account Code");
                    "Payment Class" := GenPayHead."Payment Class";
                    IF SummarizePer = SummarizePer::" " THEN BEGIN
                        "Applies-to Doc. Type" := VendLedgEntry."Document Type";
                        "Applies-to Doc. No." := VendLedgEntry."Document No.";
                    END;
                    IF SummarizePer IN [SummarizePer::" ", SummarizePer::Vendor] THEN
                        "Due Date" := VendLedgEntry."Due Date"
                    ELSE
                        "Due Date" := TempPaymentPostBuffer."Due Date";
                    IF Amount <> 0 THEN
                        INSERT;
                    GenPayLineInserted := TRUE;
                END;
            UNTIL TempPaymentPostBuffer.NEXT = 0;
    end;

    local procedure ShowMessage(var Text: Text[250])
    begin
        IF (Text <> '') AND GenPayLineInserted THEN
            MESSAGE(Text);
    end;

    local procedure AmountAvailableOnAfterValidate()
    begin
        IF AmountAvailable <> 0 THEN
            UsePriority := TRUE;
    end;
}

