report 70504 "SSA Suggest Customer Payments"
{

    Caption = 'Suggest Customer Payments';
    Permissions = TableData "Cust. Ledger Entry" = rm;
    ProcessingOnly = true;

    dataset
    {
        dataitem(Customer; Customer)
        {
            DataItemTableView = SORTING("No.");
            RequestFilterFields = "No.", "Payment Method Code";

            trigger OnAfterGetRecord()
            begin
                Window.UPDATE(1, "No.");
                GetCustLedgEntries(TRUE, FALSE);
                GetCustLedgEntries(FALSE, FALSE);
                CheckAmounts(FALSE);
            end;

            trigger OnPostDataItem()
            begin
                IF UsePaymentDisc THEN BEGIN
                    RESET;
                    COPYFILTERS(Cust2);
                    Window.OPEN(Text007);
                    IF FIND('-') THEN
                        REPEAT
                            Window.UPDATE(1, "No.");
                            PayableCustLedgEntry.SETRANGE("Vendor No.", "No.");
                            GetCustLedgEntries(TRUE, TRUE);
                            GetCustLedgEntries(FALSE, TRUE);
                            CheckAmounts(TRUE);
                        UNTIL NEXT = 0;
                END;

                GenPayLine.LOCKTABLE;
                GenPayLine.SETRANGE("No.", GenPayLine."No.");
                IF GenPayLine.FIND('+') THEN BEGIN
                    FirstLineNo := GenPayLine."Line No.";
                    LastLineNo := GenPayLine."Line No.";
                    GenPayLine.INIT;
                END;

                Window.OPEN(Text008);

                PayableCustLedgEntry.RESET;
                PayableCustLedgEntry.SETRANGE(Priority, 1, 2147483647);
                MakeGenPayLines;
                PayableCustLedgEntry.RESET;
                PayableCustLedgEntry.SETRANGE(Priority, 0);
                MakeGenPayLines;
                PayableCustLedgEntry.RESET;
                PayableCustLedgEntry.DELETEALL;

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

                Cust2.COPYFILTERS(Customer);

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
                        OptionCaption = ' ,Customer,Due date';
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
        Text006: Label 'Processing customers     #1##########';
        Text007: Label 'Processing customers for payment discounts #1##########';
        Text008: Label 'Inserting payment journal lines #1##########';
        Text009: Label '%1 must be G/L Account or Bank Account.';
        Text010: Label '%1 must be filled only when %2 is Bank Account.';
        Text011: Label 'Use Customer Priority must be activated when the value in the Amount Available field is not 0.';
        Text012: Label 'Starting Document No. must contain a number.';
        Text013: Label 'Use Customer Priority must be activated when the value in the Amount Available Amount (LCY) field is not 0.';
        Text014: Label 'Payment to customer %1';
        Text015: Label 'Payment of %1 %2';
        Text016: Label ' is already applied to %1 %2 for customer %3.';
        Text017: Label 'When %1 = %2 and you have not placed a check mark in the Summarize per Customer field,\';
        Text018: Label 'then you must place a check mark in New Doc. No. per Line.';
        Text019: Label 'You have only created suggested customer payment lines for the %1 %2.\';
        Text020: Label 'There are, however, other open customer ledger entries in currencies other than %2.';
        Text021: Label 'There are no other open customer ledger entries in other currencies.';
        Text022: Label 'You have created suggested customer payment lines for all currencies.';
        Text023: Label ' ,Computer Check,Manual Check';
        Cust2: Record Customer;
        GenPayHead: Record "SSA Payment Header";
        GenPayLine: Record "SSA Payment Line";
        CustLedgEntry: Record "Cust. Ledger Entry";
        GLAcc: Record "G/L Account";
        BankAcc: Record "Bank Account";
        PayableCustLedgEntry: Record "Payable Vendor Ledger Entry" temporary;
        TempPaymentPostBuffer: Record "SSA Payment Post. Buffer" temporary;
        OldTempPaymentPostBuffer: Record "SSA Payment Post. Buffer" temporary;
        NoSeriesMgt: Codeunit NoSeriesManagement;
        CustEntryEdit: Codeunit "Cust. Entry-Edit";
        Window: Dialog;
        UsePaymentDisc: Boolean;
        PostingDate: Date;
        LastDueDateToPayReq: Date;
        NextDocNo: Code[20];
        SummarizePer: Option " ",Customer,"Due date";
        FirstLineNo: Integer;
        LastLineNo: Integer;
        NextEntryNo: Integer;
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

    procedure GetCustLedgEntries(Positive: Boolean; Future: Boolean)
    begin
        CustLedgEntry.RESET;
        CustLedgEntry.SETCURRENTKEY("Customer No.", Open, Positive, "Due Date");
        CustLedgEntry.SETRANGE("Customer No.", Customer."No.");
        CustLedgEntry.SETRANGE(Open, TRUE);
        CustLedgEntry.SETRANGE(Positive, Positive);
        CustLedgEntry.SETRANGE("Currency Code", CurrencyFilter);
        CustLedgEntry.SETRANGE("Applies-to ID", '');
        IF Future THEN BEGIN
            CustLedgEntry.SETRANGE("Due Date", LastDueDateToPayReq + 1, 99991231D);
            CustLedgEntry.SETRANGE("Pmt. Discount Date", PostingDate, LastDueDateToPayReq);
            CustLedgEntry.SETFILTER("Original Pmt. Disc. Possible", '<0');
        END ELSE
            CustLedgEntry.SETRANGE("Due Date", 0D, LastDueDateToPayReq);
        CustLedgEntry.SETRANGE("On Hold", '');
        IF CustLedgEntry.FIND('-') THEN
            REPEAT
                SaveAmount;
            UNTIL CustLedgEntry.NEXT = 0;
    end;

    local procedure SaveAmount()
    begin
        WITH GenPayLine DO BEGIN
            "Account Type" := "Account Type"::Customer;
            VALIDATE("Account No.", CustLedgEntry."Customer No.");
            "Posting Date" := CustLedgEntry."Posting Date";
            "Currency Factor" := CustLedgEntry."Adjusted Currency Factor";
            IF "Currency Factor" = 0 THEN
                "Currency Factor" := 1;
            VALIDATE("Currency Code", CustLedgEntry."Currency Code");
            CustLedgEntry.CALCFIELDS("Remaining Amount");
            IF (CustLedgEntry."Document Type" = CustLedgEntry."Document Type"::Invoice) AND
               (PostingDate <= CustLedgEntry."Pmt. Discount Date")
            THEN
                Amount := -(CustLedgEntry."Remaining Amount" - CustLedgEntry."Original Pmt. Disc. Possible")
            ELSE
                Amount := -CustLedgEntry."Remaining Amount";
            VALIDATE(Amount);
        END;

        PayableCustLedgEntry."Vendor No." := CustLedgEntry."Customer No.";
        PayableCustLedgEntry."Entry No." := NextEntryNo;
        PayableCustLedgEntry."Vendor Ledg. Entry No." := CustLedgEntry."Entry No.";
        PayableCustLedgEntry.Amount := GenPayLine.Amount;
        PayableCustLedgEntry."Amount (LCY)" := GenPayLine."Amount (LCY)";
        PayableCustLedgEntry.Positive := (PayableCustLedgEntry.Amount > 0);
        PayableCustLedgEntry.Future := (CustLedgEntry."Due Date" > LastDueDateToPayReq);
        PayableCustLedgEntry."Currency Code" := CustLedgEntry."Currency Code";
        PayableCustLedgEntry.INSERT;
        NextEntryNo := NextEntryNo + 1;
    end;

    procedure CheckAmounts(Future: Boolean)
    var
        CurrencyBalance: Decimal;
        PrevCurrency: Code[10];
    begin
        PayableCustLedgEntry.SETRANGE("Vendor No.", Customer."No.");
        PayableCustLedgEntry.SETRANGE(Future, Future);
        IF PayableCustLedgEntry.FIND('-') THEN BEGIN
            PrevCurrency := PayableCustLedgEntry."Currency Code";
            REPEAT
                IF PayableCustLedgEntry."Currency Code" <> PrevCurrency THEN BEGIN
                    IF CurrencyBalance < 0 THEN BEGIN
                        PayableCustLedgEntry.SETRANGE("Currency Code", PrevCurrency);
                        PayableCustLedgEntry.DELETEALL;
                        PayableCustLedgEntry.SETRANGE("Currency Code");
                    END;
                    CurrencyBalance := 0;
                    PrevCurrency := PayableCustLedgEntry."Currency Code";
                END;
                CurrencyBalance := CurrencyBalance + PayableCustLedgEntry."Amount (LCY)"
            UNTIL PayableCustLedgEntry.NEXT = 0;
            IF CurrencyBalance > 0 THEN BEGIN
                PayableCustLedgEntry.SETRANGE("Currency Code", PrevCurrency);
                PayableCustLedgEntry.DELETEALL;
                PayableCustLedgEntry.SETRANGE("Currency Code");
            END;
        END;
        PayableCustLedgEntry.RESET;
    end;

    local procedure MakeGenPayLines()
    var
        GenPayLine3: Record "Gen. Journal Line";
        EntryNo: Integer;
    begin
        TempPaymentPostBuffer.DELETEALL;

        IF PayableCustLedgEntry.FIND('-') THEN
            REPEAT
                PayableCustLedgEntry.SETRANGE("Vendor No.", PayableCustLedgEntry."Vendor No.");
                PayableCustLedgEntry.FIND('-');
                REPEAT
                    CustLedgEntry.GET(PayableCustLedgEntry."Vendor Ledg. Entry No.");
                    TempPaymentPostBuffer."Account No." := CustLedgEntry."Customer No.";
                    TempPaymentPostBuffer."Currency Code" := CustLedgEntry."Currency Code";
                    IF SummarizePer = SummarizePer::"Due date" THEN
                        TempPaymentPostBuffer."Due Date" := CustLedgEntry."Due Date";

                    //TempPaymentPostBuffer."Dimension Set ID" := 0;
                    TempPaymentPostBuffer."Global Dimension 1 Code" := '';
                    TempPaymentPostBuffer."Global Dimension 2 Code" := '';

                    IF SummarizePer IN [SummarizePer::Customer, SummarizePer::"Due date"] THEN BEGIN
                        TempPaymentPostBuffer."Auxiliary Entry No." := 0;
                        IF TempPaymentPostBuffer.FIND THEN BEGIN
                            TempPaymentPostBuffer.Amount := TempPaymentPostBuffer.Amount + PayableCustLedgEntry.Amount;
                            TempPaymentPostBuffer."Amount (LCY)" := TempPaymentPostBuffer."Amount (LCY)" + PayableCustLedgEntry."Amount (LCY)";
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
                            TempPaymentPostBuffer.Amount := PayableCustLedgEntry.Amount;
                            TempPaymentPostBuffer."Amount (LCY)" := PayableCustLedgEntry."Amount (LCY)";
                            Window.UPDATE(1, CustLedgEntry."Customer No.");
                            TempPaymentPostBuffer.INSERT;
                        END;
                        CustLedgEntry."Applies-to ID" := TempPaymentPostBuffer."Document No.";
                        CustEntryEdit.RUN(CustLedgEntry)
                    END ELSE BEGIN
                        GenPayLine3.RESET;
                        GenPayLine3.SETCURRENTKEY(
                          "Account Type", "Account No.", "Applies-to Doc. Type", "Applies-to Doc. No.");
                        GenPayLine3.SETRANGE("Account Type", GenPayLine3."Account Type"::Customer);
                        GenPayLine3.SETRANGE("Account No.", CustLedgEntry."Customer No.");
                        GenPayLine3.SETRANGE("Applies-to Doc. Type", CustLedgEntry."Document Type");
                        GenPayLine3.SETRANGE("Applies-to Doc. No.", CustLedgEntry."Document No.");
                        IF GenPayLine3.FIND('-') THEN
                            GenPayLine3.FIELDERROR(
                              "Applies-to Doc. No.",
                              STRSUBSTNO(
                                Text016,
                                CustLedgEntry."Document Type", CustLedgEntry."Document No.",
                                CustLedgEntry."Customer No."));

                        TempPaymentPostBuffer."Applies-to Doc. Type" := CustLedgEntry."Document Type";
                        TempPaymentPostBuffer."Applies-to Doc. No." := CustLedgEntry."Document No.";
                        TempPaymentPostBuffer."Currency Factor" := CustLedgEntry."Adjusted Currency Factor";
                        TempPaymentPostBuffer.Amount := PayableCustLedgEntry.Amount;
                        TempPaymentPostBuffer."Amount (LCY)" := PayableCustLedgEntry."Amount (LCY)";
                        TempPaymentPostBuffer."Global Dimension 1 Code" := CustLedgEntry."Global Dimension 1 Code";
                        TempPaymentPostBuffer."Global Dimension 2 Code" := CustLedgEntry."Global Dimension 2 Code";
                        TempPaymentPostBuffer."Auxiliary Entry No." := CustLedgEntry."Entry No.";
                        Window.UPDATE(1, CustLedgEntry."Customer No.");
                        TempPaymentPostBuffer.INSERT;
                    END;
                    CustLedgEntry.CALCFIELDS(CustLedgEntry."Remaining Amount");
                    CustLedgEntry."Amount to Apply" := CustLedgEntry."Remaining Amount";
                    CustEntryEdit.RUN(CustLedgEntry);
                UNTIL PayableCustLedgEntry.NEXT = 0;
                PayableCustLedgEntry.DELETEALL;
                PayableCustLedgEntry.SETRANGE("Vendor No.");
            UNTIL NOT PayableCustLedgEntry.FIND('-');

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
                        CustLedgEntry.GET(TempPaymentPostBuffer."Auxiliary Entry No.");
                        CustLedgEntry."Applies-to ID" := NextDocNo;
                        CustLedgEntry.MODIFY;
                    END;
                    "Account Type" := "Account Type"::Customer;
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
                    Cust2.GET(GenPayLine."Account No.");
                    VALIDATE(GenPayLine."Bank Account", Cust2."SSA Default Bank Account Code");
                    "Payment Class" := GenPayHead."Payment Class";
                    IF SummarizePer = SummarizePer::" " THEN BEGIN
                        "Applies-to Doc. Type" := CustLedgEntry."Document Type";
                        "Applies-to Doc. No." := CustLedgEntry."Document No.";
                    END;
                    IF SummarizePer IN [SummarizePer::" ", SummarizePer::Customer] THEN
                        "Due Date" := CustLedgEntry."Due Date"
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
}

