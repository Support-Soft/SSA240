report 70503 "SSA Suggest Vendor Payments"
{
    Caption = 'Suggest Vendor Payments';
    Permissions = TableData "Vendor Ledger Entry" = rm;
    ProcessingOnly = true;

    dataset
    {
        dataitem(Vendor; Vendor)
        {
            DataItemTableView = sorting("No.");
            RequestFilterFields = "No.", "Payment Method Code";

            trigger OnAfterGetRecord()
            begin
                if StopPayments then
                    CurrReport.BREAK;
                Window.UPDATE(1, "No.");
                GetVendLedgEntries(true, false);
                GetVendLedgEntries(false, false);
                CheckAmounts(false);
            end;

            trigger OnPostDataItem()
            begin
                if UsePriority and not StopPayments then begin
                    RESET;
                    COPYFILTERS(Vend2);
                    SETCURRENTKEY(Priority);
                    SETRANGE(Priority, 0);
                    if FIND('-') then
                        repeat
                            Window.UPDATE(1, "No.");
                            GetVendLedgEntries(true, false);
                            GetVendLedgEntries(false, false);
                            CheckAmounts(false);
                        until (NEXT = 0) or StopPayments;
                end;

                if UsePaymentDisc and not StopPayments then begin
                    RESET;
                    COPYFILTERS(Vend2);
                    Window.OPEN(Text007);
                    if FIND('-') then
                        repeat
                            Window.UPDATE(1, "No.");
                            PayableVendLedgEntry.SETRANGE("Vendor No.", "No.");
                            GetVendLedgEntries(true, true);
                            GetVendLedgEntries(false, true);
                            CheckAmounts(true);
                        until (NEXT = 0) or StopPayments;
                end;

                GenPayLine.LOCKTABLE;
                GenPayLine.SETRANGE("No.", GenPayLine."No.");
                if GenPayLine.FIND('+') then begin
                    FirstLineNo := GenPayLine."Line No.";
                    LastLineNo := GenPayLine."Line No.";
                    GenPayLine.INIT;
                end;

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
                if LastDueDateToPayReq = 0D then
                    ERROR(Text000);
                if PostingDate = 0D then
                    ERROR(Text001);

                GenPayLineInserted := false;
                SeveralCurrencies := false;
                MessageText := '';

                if UsePaymentDisc and (LastDueDateToPayReq < WORKDATE) then
                    if not
                       CONFIRM(
                         Text003 +
                         Text004, false,
                         WORKDATE)
                    then
                        ERROR(Text005);

                Vend2.COPYFILTERS(Vendor);

                OriginalAmtAvailable := AmountAvailable;
                if AmountAvailable > 0 then begin
                    SETCURRENTKEY(Priority);
                    SETRANGE(Priority, 1, 2147483647);
                    UsePriority := true;
                end;
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
                        ToolTip = 'Specifies the value of the Last Payment Date field.';
                    }
                    field(UsePaymentDisc; UsePaymentDisc)
                    {
                        Caption = 'Find Payment Discounts';
                        MultiLine = true;
                        ToolTip = 'Specifies the value of the Find Payment Discounts field.';
                    }
                    field(SummarizePer; SummarizePer)
                    {
                        Caption = 'Summarize per';
                        OptionCaption = ' ,Vendor,Due date';
                        ToolTip = 'Specifies the value of the Summarize per field.';
                    }
                    field(UsePriority; UsePriority)
                    {
                        Caption = 'Use Vendor Priority';
                        ToolTip = 'Specifies the value of the Use Vendor Priority field.';
                        trigger OnValidate()
                        begin
                            if not UsePriority and (AmountAvailable <> 0) then
                                ERROR(Text011);
                        end;
                    }
                    field(AmountAvailable; AmountAvailable)
                    {
                        Caption = 'Available Amount (LCY)';
                        ToolTip = 'Specifies the value of the Available Amount (LCY) field.';
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
                        ToolTip = 'Specifies the value of the Currency Filter field.';
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
        VendLedgEntry.SETRANGE(Open, true);
        VendLedgEntry.SETRANGE(Positive, Positive);
        VendLedgEntry.SETRANGE("Currency Code", CurrencyFilter);
        VendLedgEntry.SETRANGE("Applies-to ID", '');
        if Future then begin
            VendLedgEntry.SETRANGE("Due Date", LastDueDateToPayReq + 1, 99991231D);
            VendLedgEntry.SETRANGE("Pmt. Discount Date", PostingDate, LastDueDateToPayReq);
            VendLedgEntry.SETFILTER("Original Pmt. Disc. Possible", '<0');
        end else
            VendLedgEntry.SETRANGE("Due Date", 0D, LastDueDateToPayReq);
        VendLedgEntry.SETRANGE("On Hold", '');
        if VendLedgEntry.FIND('-') then
            repeat
                SaveAmount;
            until VendLedgEntry.NEXT = 0;
    end;

    local procedure SaveAmount()
    begin
        GenPayLine."Account Type" := GenPayLine."Account Type"::Vendor;
        GenPayLine.VALIDATE("Account No.", VendLedgEntry."Vendor No.");
        GenPayLine."Posting Date" := VendLedgEntry."Posting Date";
        GenPayLine."Currency Factor" := VendLedgEntry."Adjusted Currency Factor";
        if GenPayLine."Currency Factor" = 0 then
            GenPayLine."Currency Factor" := 1;
        GenPayLine.VALIDATE("Currency Code", VendLedgEntry."Currency Code");
        VendLedgEntry.CALCFIELDS("Remaining Amount");
        if (VendLedgEntry."Document Type" = VendLedgEntry."Document Type"::Invoice) and
           (PostingDate <= VendLedgEntry."Pmt. Discount Date")
        then
            GenPayLine.Amount := -(VendLedgEntry."Remaining Amount" - VendLedgEntry."Original Pmt. Disc. Possible")
        else
            GenPayLine.Amount := -VendLedgEntry."Remaining Amount";
        GenPayLine.VALIDATE(Amount);

        if UsePriority then
            PayableVendLedgEntry.Priority := Vendor.Priority
        else
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
        if PayableVendLedgEntry.FIND('-') then begin
            PrevCurrency := PayableVendLedgEntry."Currency Code";
            repeat
                if PayableVendLedgEntry."Currency Code" <> PrevCurrency then begin
                    if CurrencyBalance < 0 then begin
                        PayableVendLedgEntry.SETRANGE("Currency Code", PrevCurrency);
                        PayableVendLedgEntry.DELETEALL;
                        PayableVendLedgEntry.SETRANGE("Currency Code");
                    end else
                        AmountAvailable := AmountAvailable - CurrencyBalance;
                    CurrencyBalance := 0;
                    PrevCurrency := PayableVendLedgEntry."Currency Code";
                end;
                if (OriginalAmtAvailable = 0) or
                   (AmountAvailable >= CurrencyBalance + PayableVendLedgEntry."Amount (LCY)")
                then
                    CurrencyBalance := CurrencyBalance + PayableVendLedgEntry."Amount (LCY)"
                else
                    PayableVendLedgEntry.DELETE;
            until PayableVendLedgEntry.NEXT = 0;
            if CurrencyBalance < 0 then begin
                PayableVendLedgEntry.SETRANGE("Currency Code", PrevCurrency);
                PayableVendLedgEntry.DELETEALL;
                PayableVendLedgEntry.SETRANGE("Currency Code");
            end else
                if OriginalAmtAvailable > 0 then
                    AmountAvailable := AmountAvailable - CurrencyBalance;
            if (OriginalAmtAvailable > 0) and (AmountAvailable <= 0) then
                StopPayments := true;
        end;
        PayableVendLedgEntry.RESET;
    end;

    local procedure MakeGenPayLines()
    var
        GenPayLine3: Record "Gen. Journal Line";
        EntryNo: Integer;
    begin
        TempPaymentPostBuffer.DELETEALL;

        if PayableVendLedgEntry.FIND('-') then
            repeat
                PayableVendLedgEntry.SETRANGE("Vendor No.", PayableVendLedgEntry."Vendor No.");
                PayableVendLedgEntry.FIND('-');
                repeat
                    VendLedgEntry.GET(PayableVendLedgEntry."Vendor Ledg. Entry No.");
                    TempPaymentPostBuffer."Account No." := VendLedgEntry."Vendor No.";
                    TempPaymentPostBuffer."Currency Code" := VendLedgEntry."Currency Code";
                    if SummarizePer = SummarizePer::"Due date" then
                        TempPaymentPostBuffer."Due Date" := VendLedgEntry."Due Date";

                    //TempPaymentPostBuffer."Dimension Set ID" := 0;
                    TempPaymentPostBuffer."Global Dimension 1 Code" := '';
                    TempPaymentPostBuffer."Global Dimension 2 Code" := '';

                    if SummarizePer in [SummarizePer::Vendor, SummarizePer::"Due date"] then begin
                        TempPaymentPostBuffer."Auxiliary Entry No." := 0;
                        if TempPaymentPostBuffer.FIND then begin
                            TempPaymentPostBuffer.Amount := TempPaymentPostBuffer.Amount + PayableVendLedgEntry.Amount;
                            TempPaymentPostBuffer."Amount (LCY)" := TempPaymentPostBuffer."Amount (LCY)" + PayableVendLedgEntry."Amount (LCY)";
                            TempPaymentPostBuffer.MODIFY;
                        end else begin
                            LastLineNo := LastLineNo + 10000;
                            TempPaymentPostBuffer."Payment Line No." := LastLineNo;
                            if PaymentClass."Line No. Series" = '' then
                                NextDocNo := GenPayHead."No." + '/' + FORMAT(LastLineNo)
                            else
                                NextDocNo := NoSeriesMgt.GetNextNo(PaymentClass."Line No. Series", PostingDate, false);
                            TempPaymentPostBuffer."Document No." := NextDocNo;
                            NextDocNo := INCSTR(NextDocNo);
                            TempPaymentPostBuffer.Amount := PayableVendLedgEntry.Amount;
                            TempPaymentPostBuffer."Amount (LCY)" := PayableVendLedgEntry."Amount (LCY)";
                            Window.UPDATE(1, VendLedgEntry."Vendor No.");
                            TempPaymentPostBuffer.INSERT;
                        end;
                        VendLedgEntry."Applies-to ID" := TempPaymentPostBuffer."Document No.";
                        VendEntryEdit.RUN(VendLedgEntry)
                    end else begin
                        GenPayLine3.RESET;
                        GenPayLine3.SETCURRENTKEY(
                          "Account Type", "Account No.", "Applies-to Doc. Type", "Applies-to Doc. No.");
                        GenPayLine3.SETRANGE("Account Type", GenPayLine3."Account Type"::Vendor);
                        GenPayLine3.SETRANGE("Account No.", VendLedgEntry."Vendor No.");
                        GenPayLine3.SETRANGE("Applies-to Doc. Type", VendLedgEntry."Document Type");
                        GenPayLine3.SETRANGE("Applies-to Doc. No.", VendLedgEntry."Document No.");
                        if GenPayLine3.FIND('-') then
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
                    end;
                    VendLedgEntry.CALCFIELDS(VendLedgEntry."Remaining Amount");
                    VendLedgEntry."Amount to Apply" := VendLedgEntry."Remaining Amount";
                    VendEntryEdit.RUN(VendLedgEntry);
                until PayableVendLedgEntry.NEXT = 0;
                PayableVendLedgEntry.DELETEALL;
                PayableVendLedgEntry.SETRANGE("Vendor No.");
            until not PayableVendLedgEntry.FIND('-');

        CLEAR(OldTempPaymentPostBuffer);
        TempPaymentPostBuffer.SETCURRENTKEY("Document No.");
        if TempPaymentPostBuffer.FIND('-') then
            repeat
                GenPayLine.INIT;
                Window.UPDATE(1, TempPaymentPostBuffer."Account No.");
                if SummarizePer = SummarizePer::" " then begin
                    LastLineNo := LastLineNo + 10000;
                    GenPayLine."Line No." := LastLineNo;
                    if PaymentClass."Line No. Series" = '' then
                        NextDocNo := GenPayHead."No." + '/' + FORMAT(GenPayLine."Line No.")
                    else
                        NextDocNo := NoSeriesMgt.GetNextNo(PaymentClass."Line No. Series", PostingDate, false);
                end else begin
                    GenPayLine."Line No." := TempPaymentPostBuffer."Payment Line No.";
                    NextDocNo := TempPaymentPostBuffer."Document No.";
                end;
                GenPayLine."Document ID" := NextDocNo;
                GenPayLine."Applies-to ID" := GenPayLine."Document ID";
                OldTempPaymentPostBuffer := TempPaymentPostBuffer;
                OldTempPaymentPostBuffer."Document No." := GenPayLine."Document ID";
                if SummarizePer = SummarizePer::" " then begin
                    VendLedgEntry.GET(TempPaymentPostBuffer."Auxiliary Entry No.");
                    VendLedgEntry."Applies-to ID" := NextDocNo;
                    VendLedgEntry.MODIFY;
                end;
                GenPayLine."Account Type" := GenPayLine."Account Type"::Vendor;
                GenPayLine.VALIDATE("Account No.", TempPaymentPostBuffer."Account No.");
                GenPayLine."Currency Code" := TempPaymentPostBuffer."Currency Code";
                GenPayLine.Amount := TempPaymentPostBuffer.Amount;
                if GenPayLine.Amount > 0 then
                    GenPayLine."Debit Amount" := GenPayLine.Amount
                else
                    GenPayLine."Credit Amount" := -GenPayLine.Amount;
                GenPayLine."Amount (LCY)" := TempPaymentPostBuffer."Amount (LCY)";
                GenPayLine."Currency Factor" := TempPaymentPostBuffer."Currency Factor";
                if (GenPayLine."Currency Factor" = 0) and (GenPayLine.Amount <> 0) then
                    GenPayLine."Currency Factor" := GenPayLine.Amount / GenPayLine."Amount (LCY)";
                Vend2.GET(GenPayLine."Account No.");
                GenPayLine.VALIDATE(GenPayLine."Bank Account", Vend2."SSA Default Bank Account Code");
                GenPayLine."Payment Class" := GenPayHead."Payment Class";
                if SummarizePer = SummarizePer::" " then begin
                    GenPayLine."Applies-to Doc. Type" := VendLedgEntry."Document Type";
                    GenPayLine."Applies-to Doc. No." := VendLedgEntry."Document No.";
                end;
                if SummarizePer in [SummarizePer::" ", SummarizePer::Vendor] then
                    GenPayLine."Due Date" := VendLedgEntry."Due Date"
                else
                    GenPayLine."Due Date" := TempPaymentPostBuffer."Due Date";
                if GenPayLine.Amount <> 0 then
                    GenPayLine.INSERT;
                GenPayLineInserted := true;
            until TempPaymentPostBuffer.NEXT = 0;
    end;

    local procedure ShowMessage(var Text: Text[250])
    begin
        if (Text <> '') and GenPayLineInserted then
            MESSAGE(Text);
    end;

    local procedure AmountAvailableOnAfterValidate()
    begin
        if AmountAvailable <> 0 then
            UsePriority := true;
    end;
}
