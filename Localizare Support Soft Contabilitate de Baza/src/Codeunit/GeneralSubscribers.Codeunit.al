codeunit 70023 "SSA General Subscribers"
{
    // SSA969 SSCAT 07.10.2019 35.Funct. Posting group
    // SSA970 SSCAT 07.10.2019 36.Funct. UOM Mandatory, dimensiuni pe rounding, intercompany, denumire, conturi bancare
    // SSA948 SSCAT 08.10.2019 14.Funct. Functionalitatea deductibilitate cheltuieli 50% /100%



    [EventSubscriber(ObjectType::Codeunit, 13, 'OnAfterPostGenJnlLine', '', false, false)]
    local procedure C13_OnAfterPostGenJnlLine(var GenJournalLine: Record "Gen. Journal Line"; var GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line"; CommitIsSuppressed: Boolean)
    var
        OldGenJnlLine: Record "Gen. Journal Line";
        GenJnlLine: Record "Gen. Journal Line";
        VATPostingSetup: Record "VAT Posting Setup";
        FirstLineAmount: Decimal;
    begin
        //SSA948>>
        if not GenJournalLine."SSA Distribute Non-Ded VAT" then
            exit;
        GenJournalLine.TestField("SSA Non-Ded VAT Expense Acc 1");
        GenJournalLine.TestField("SSA Non-Ded VAT Expense Acc 2");
        OldGenJnlLine := GenJournalLine;
        if not VATPostingSetup.Get(GenJournalLine."VAT Bus. Posting Group", GenJournalLine."VAT Prod. Posting Group") then
            Clear(VATPostingSetup);

        with GenJnlLine do begin
            InitNewLine(
              GenJournalLine."Posting Date", GenJournalLine."Document Date", GenJournalLine."Description",
              GenJournalLine."Shortcut Dimension 1 Code", GenJournalLine."Shortcut Dimension 2 Code",
              GenJournalLine."Dimension Set ID", GenJournalLine."Reason Code");

            CopyDocumentFields(OldGenJnlLine."Document Type", OldGenJnlLine."Document No.", OldGenJnlLine."External Document No.", OldGenJnlLine."Source Code", '');
            "Source Currency Code" := GenJournalLine."Currency Code";
            "Currency Factor" := GenJournalLine."Currency Factor";
            Correction := GenJournalLine.Correction;
            "VAT Base Discount %" := GenJournalLine."VAT Base Discount %";

            "Sell-to/Buy-from No." := GenJournalLine."Sell-to/Buy-from No.";
            "Bill-to/Pay-to No." := GenJournalLine."Bill-to/Pay-to No.";
            "Country/Region Code" := GenJournalLine."Country/Region Code";

            "VAT Registration No." := GenJournalLine."VAT Registration No.";
            "Source Type" := GenJournalLine."Source Type";
            "Source No." := GenJournalLine."Source No.";
            "Posting No. Series" := GenJournalLine."Posting No. Series";
            "IC Partner Code" := GenJournalLine."IC Partner Code";
            "Ship-to/Order Address Code" := GenJournalLine."Ship-to/Order Address Code";
            "Salespers./Purch. Code" := GenJournalLine."Salespers./Purch. Code";
            "On Hold" := GenJournalLine."On Hold";
            IF "Account Type" = "Account Type"::Vendor THEN
                "Posting Group" := GenJournalLine."Posting Group";

            "Account No." := GenJournalLine."Account No.";
            "System-Created Entry" := GenJournalLine."System-Created Entry";
            "Gen. Bus. Posting Group" := GenJournalLine."Gen. Bus. Posting Group";
            "Gen. Prod. Posting Group" := GenJournalLine."Gen. Prod. Posting Group";
            "VAT Bus. Posting Group" := GenJournalLine."VAT Bus. Posting Group";
            "VAT Prod. Posting Group" := GenJournalLine."VAT Prod. Posting Group";
            "Tax Area Code" := GenJournalLine."Tax Area Code";
            "Tax Liable" := GenJournalLine."Tax Liable";
            "Tax Group Code" := GenJournalLine."Tax Group Code";
            "Use Tax" := GenJournalLine."Use Tax";
            Quantity := GenJournalLine.Quantity;
            "VAT %" := GenJournalLine."VAT %";
            "VAT Calculation Type" := GenJournalLine."VAT Calculation Type";
            "VAT Posting" := "VAT Posting"::"Manual VAT Entry";
            "Job No." := GenJournalLine."Job No.";
            "Deferral Code" := GenJournalLine."Deferral Code";
            "Deferral Line No." := GenJournalLine."Deferral Line No.";
            Amount := GenJournalLine.Amount;
            "Source Currency Amount" := GenJournalLine."Source Currency Amount";
            "VAT Base Amount" := GenJournalLine."VAT Base Amount";
            "Source Curr. VAT Base Amount" := GenJournalLine."Source Curr. VAT Base Amount";
            "VAT Amount" := GenJournalLine."VAT Amount";
            "Source Curr. VAT Amount" := GenJournalLine."Source Curr. VAT Amount";
            "VAT Difference" := GenJournalLine."VAT Difference";
            "VAT Base Before Pmt. Disc." := GenJournalLine."VAT Base Before Pmt. Disc.";

            "Account Type" := GenJnlLine."Account Type"::"G/L Account";
            "Account No." := GenJournalLine."SSA Non-Ded VAT Expense Acc 1";
            "Gen. Posting Type" := 0;
            "Gen. Bus. Posting Group" := '';
            "Gen. Prod. Posting Group" := '';
            "VAT Calculation Type" := 0;
            "VAT Bus. Posting Group" := '';
            "VAT Prod. Posting Group" := '';
            "Posting Group" := '';
            "Bal. Account Type" := "Bal. Account Type"::"G/L Account";
            "Bal. Account No." := VATPostingSetup."Purchase VAT Account";
            "Currency Code" := OldGenJnlLine."Currency Code";
            Amount := Round(GenJournalLine."VAT Amount" / 2, 0.01);
            FirstLineAmount := Round(GenJournalLine."VAT Amount" / 2, 0.01);
            "Amount (LCY)" := Round(GenJournalLine."VAT Amount" / 2, 0.01);
            "Allow Zero-Amount Posting" := true;
            GenJnlPostLine.RunWithCheck(GenJnlLine);
        end;

        with GenJnlLine do begin
            InitNewLine(
              GenJournalLine."Posting Date", GenJournalLine."Document Date", GenJournalLine."Description",
              GenJournalLine."Shortcut Dimension 1 Code", GenJournalLine."Shortcut Dimension 2 Code",
              GenJournalLine."Dimension Set ID", GenJournalLine."Reason Code");

            CopyDocumentFields(OldGenJnlLine."Document Type", OldGenJnlLine."Document No.", OldGenJnlLine."External Document No.", OldGenJnlLine."Source Code", '');
            "Source Currency Code" := GenJournalLine."Currency Code";
            "Currency Factor" := GenJournalLine."Currency Factor";
            Correction := GenJournalLine.Correction;
            "VAT Base Discount %" := GenJournalLine."VAT Base Discount %";

            "Sell-to/Buy-from No." := GenJournalLine."Sell-to/Buy-from No.";
            "Bill-to/Pay-to No." := GenJournalLine."Bill-to/Pay-to No.";
            "Country/Region Code" := GenJournalLine."Country/Region Code";

            "VAT Registration No." := GenJournalLine."VAT Registration No.";
            "Source Type" := GenJournalLine."Source Type";
            "Source No." := GenJournalLine."Source No.";
            "Posting No. Series" := GenJournalLine."Posting No. Series";
            "IC Partner Code" := GenJournalLine."IC Partner Code";
            "Ship-to/Order Address Code" := GenJournalLine."Ship-to/Order Address Code";
            "Salespers./Purch. Code" := GenJournalLine."Salespers./Purch. Code";
            "On Hold" := GenJournalLine."On Hold";
            IF "Account Type" = "Account Type"::Vendor THEN
                "Posting Group" := GenJournalLine."Posting Group";

            "Account No." := GenJournalLine."Account No.";
            "System-Created Entry" := GenJournalLine."System-Created Entry";
            "Gen. Bus. Posting Group" := GenJournalLine."Gen. Bus. Posting Group";
            "Gen. Prod. Posting Group" := GenJournalLine."Gen. Prod. Posting Group";
            "VAT Bus. Posting Group" := GenJournalLine."VAT Bus. Posting Group";
            "VAT Prod. Posting Group" := GenJournalLine."VAT Prod. Posting Group";
            "Tax Area Code" := GenJournalLine."Tax Area Code";
            "Tax Liable" := GenJournalLine."Tax Liable";
            "Tax Group Code" := GenJournalLine."Tax Group Code";
            "Use Tax" := GenJournalLine."Use Tax";
            Quantity := GenJournalLine.Quantity;
            "VAT %" := GenJournalLine."VAT %";
            "VAT Calculation Type" := GenJournalLine."VAT Calculation Type";
            "VAT Posting" := "VAT Posting"::"Manual VAT Entry";
            "Job No." := GenJournalLine."Job No.";
            "Deferral Code" := GenJournalLine."Deferral Code";
            "Deferral Line No." := GenJournalLine."Deferral Line No.";
            Amount := GenJournalLine.Amount;
            "Source Currency Amount" := GenJournalLine."Source Currency Amount";
            "VAT Base Amount" := GenJournalLine."VAT Base Amount";
            "Source Curr. VAT Base Amount" := GenJournalLine."Source Curr. VAT Base Amount";
            "VAT Amount" := GenJournalLine."VAT Amount";
            "Source Curr. VAT Amount" := GenJournalLine."Source Curr. VAT Amount";
            "VAT Difference" := GenJournalLine."VAT Difference";
            "VAT Base Before Pmt. Disc." := GenJournalLine."VAT Base Before Pmt. Disc.";

            "Account Type" := GenJnlLine."Account Type"::"G/L Account";
            "Account No." := GenJournalLine."SSA Non-Ded VAT Expense Acc 2";
            "Gen. Posting Type" := 0;
            "Gen. Bus. Posting Group" := '';
            "Gen. Prod. Posting Group" := '';
            "VAT Calculation Type" := 0;
            "VAT Bus. Posting Group" := '';
            "VAT Prod. Posting Group" := '';
            "Posting Group" := '';
            "Bal. Account Type" := "Bal. Account Type"::"G/L Account";
            "Bal. Account No." := VATPostingSetup."Purchase VAT Account";
            "Currency Code" := OldGenJnlLine."Currency Code";
            Amount := GenJournalLine."VAT Amount" - FirstLineAmount;
            "Amount (LCY)" := GenJournalLine."VAT Amount" - FirstLineAmount;
            "Allow Zero-Amount Posting" := true;
            GenJnlPostLine.RunWithCheck(GenJnlLine);
        end;
        //SSA948<<
    end;

    [EventSubscriber(ObjectType::Codeunit, 21, 'OnAfterCheckItemJnlLine', '', false, false)]
    local procedure C21OnAfterCheckItemJnlLine(var ItemJnlLine: Record "Item Journal Line")
    var
        SSASetup: Record "SSA Localization Setup";
    begin
        //SSA970>>
        ItemJnlLine.TestField("Gen. Prod. Posting Group");
        SSASetup.Get;
        if SSASetup."Unit of Measure Mandatory" and
            (not ItemJnlLine.Adjustment) and
            (ItemJnlLine."Item Charge No." = '') and
            (not ItemJnlLine.Correction) and
            (ItemJnlLine.Quantity <> 0)
        then
            ItemJnlLine.TestField("Unit of Measure Code");
        //SSA970<<
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Cust. Entry-Edit", 'OnBeforeCustLedgEntryModify', '', true, false)]
    local procedure C103OnBeforeCustLedgEntryModify(var CustLedgEntry: Record "Cust. Ledger Entry"; FromCustLedgEntry: Record "Cust. Ledger Entry")
    begin
        CustLedgEntry."SSA Stare Factura" := FromCustLedgEntry."SSA Stare Factura";
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Vend. Entry-Edit", 'OnBeforeVendLedgEntryModify', '', true, false)]
    local procedure C113OnBeforeVendLedgEntryModify(var VendLedgEntry: Record "Vendor Ledger Entry"; FromVendLedgEntry: Record "Vendor Ledger Entry")
    begin
        VendLedgEntry."SSA Stare Factura" := FromVendLedgEntry."SSA Stare Factura";
    end;

    [EventSubscriber(ObjectType::Codeunit, 395, 'OnAfterInitGenJnlLine', '', false, false)]
    local procedure C395OnAfterInitGenJnlLine(var GenJnlLine: Record "Gen. Journal Line"; FinChargeMemoHeader: Record "Finance Charge Memo Header")
    begin
        //SSA969>>
        GenJnlLine."Posting Group" := FinChargeMemoHeader."Customer Posting Group";
        //SSA969<<
    end;

    [EventSubscriber(ObjectType::Codeunit, 5895, 'OnPostItemJnlLineCopyFromValueEntry', '', false, false)]
    local procedure C5895OnPostItemJnlLineCopyFromValueEntry(var ItemJournalLine: Record "Item Journal Line"; ValueEntry: Record "Value Entry")
    var
        SSASetup: Record "SSA Localization Setup";
    begin
        //SSA970>>
        SSASetup.Get;
        if ItemJournalLine."Value Entry Type" <> ItemJournalLine."Value Entry Type"::Rounding then
            ItemJournalLine."Dimension Set ID" := ValueEntry."Dimension Set ID"
        else
            ItemJournalLine."Dimension Set ID" := SSASetup."Rounding Dimension Set ID";
        //SSA970<<
    end;

    [EventSubscriber(ObjectType::Report, 393, 'OnUpdateTempBufferFromVendorLedgerEntry', '', false, false)]
    local procedure R393OnUpdateTempBufferFromVendorLedgerEntry(var TempPaymentBuffer: Record "Payment Buffer" temporary; VendorLedgerEntry: Record "Vendor Ledger Entry")
    begin
        //SSA969>>
        TempPaymentBuffer."SSA Vendor Posting Group" := VendorLedgerEntry."Vendor Posting Group";
        //SSA969<<
    end;

    [EventSubscriber(ObjectType::Report, 393, 'OnBeforeUpdateGnlJnlLineDimensionsFromTempBuffer', '', false, false)]
    local procedure R393OnBeforeUpdateGnlJnlLineDimensionsFromTempBuffer(var GenJournalLine: Record "Gen. Journal Line"; TempPaymentBuffer: Record "Payment Buffer" temporary)
    begin
        //SSA969>>
        GenJournalLine."Posting Group" := TempPaymentBuffer."SSA Vendor Posting Group";
        //SSA969<<
    end;

    [EventSubscriber(ObjectType::Report, Report::"Adjust Exchange Rates", 'OnBeforeOnInitReport', '', false, false)]
    local procedure Error_AdjustExchangeRates(var IsHandled: Boolean)
    var
        Text001: Label 'Report %1 has been replaced by Report %2 from SS Localization.';
    begin
        //Error(Text001, Report::"Adjust Exchange Rates", report::"SSA Adjust Exchange Rates");
        IsHandled := true;
    end;

    [EventSubscriber(ObjectType::Report, Report::"Close Income Statement", 'OnBeforeCheckDimPostingRules', '', false, false)]
    local procedure Error_CloseIncomeStatement()
    var
        Text001: Label 'Report %1 has been replaced by Report %2 from SS Localization.';
    begin
        Error(Text001, Report::"Close Income Statement", report::"SSA Close Income Statement");
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::ICInboxOutboxMgt, 'OnBeforeICInboxPurchHeaderInsert', '', true, false)]
    local procedure ICInboxOutboxMgt_OnBeforeInsertICInboxPurchHdrFromOutboxSalesHdrToInbox(var ICInboxPurchaseHeader: Record "IC Inbox Purchase Header"; ICOutboxSalesHeader: Record "IC Outbox Sales Header")
    begin
        ICInboxPurchaseHeader."SSA Tip Document D394" := ICOutboxSalesHeader."SSA Tip Document D394";
        ICInboxPurchaseHeader."SSA Stare Factura" := ICOutboxSalesHeader."SSA Stare Factura";
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::ICInboxOutboxMgt, 'OnAfterCreatePurchDocument', '', true, false)]
    local procedure ICInboxOutboxMgt_OnAfterCreatePurchDocument(var PurchaseHeader: Record "Purchase Header"; ICInboxPurchaseHeader: Record "IC Inbox Purchase Header"; HandledICInboxPurchHeader: Record "Handled IC Inbox Purch. Header")
    begin
        PurchaseHeader."SSA Tip Document D394" := ICInboxPurchaseHeader."SSA Tip Document D394";
        PurchaseHeader."SSA Stare Factura" := ICInboxPurchaseHeader."SSA Stare Factura";
        PurchaseHeader.Modify();
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::ICInboxOutboxMgt, 'OnBeforeICInboxSalesHeaderInsert', '', true, false)]
    local procedure ICInboxOutboxMgt_OnBeforeInsertICInboxSalesHdrFromOutboxPurchHdrToInboxPp(var ICInboxSalesHeader: Record "IC Inbox Sales Header"; ICOutboxPurchaseHeader: Record "IC Outbox Purchase Header")
    begin
        ICInboxSalesHeader."SSA Tip Document D394" := ICOutboxPurchaseHeader."SSA Tip Document D394";
        ICInboxSalesHeader."SSA Stare Factura" := ICOutboxPurchaseHeader."SSA Stare Factura";
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::ICInboxOutboxMgt, 'OnAfterCreateSalesDocument', '', true, false)]
    local procedure ICInboxOutboxMgt_OnAfterCreateSalesDocument(var SalesHeader: Record "Sales Header"; ICInboxSalesHeader: Record "IC Inbox Sales Header"; HandledICInboxSalesHeader: Record "Handled IC Inbox Sales Header")
    begin
        SalesHeader."SSA Tip Document D394" := ICInboxSalesHeader."SSA Tip Document D394";
        SalesHeader."SSA Stare Factura" := ICInboxSalesHeader."SSA Stare Factura";
        SalesHeader.Modify();
    end;

}

