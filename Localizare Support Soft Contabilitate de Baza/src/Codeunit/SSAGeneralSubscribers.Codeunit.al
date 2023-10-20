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

        GenJnlLine.InitNewLine(
  GenJournalLine."Posting Date", GenJournalLine."Document Date", GenJournalLine.Description,
  GenJournalLine."Shortcut Dimension 1 Code", GenJournalLine."Shortcut Dimension 2 Code",
  GenJournalLine."Dimension Set ID", GenJournalLine."Reason Code");

        GenJnlLine.CopyDocumentFields(OldGenJnlLine."Document Type", OldGenJnlLine."Document No.", OldGenJnlLine."External Document No.", OldGenJnlLine."Source Code", '');
        GenJnlLine."Source Currency Code" := GenJournalLine."Currency Code";
        GenJnlLine."Currency Factor" := GenJournalLine."Currency Factor";
        GenJnlLine.Correction := GenJournalLine.Correction;
        GenJnlLine."VAT Base Discount %" := GenJournalLine."VAT Base Discount %";

        GenJnlLine."Sell-to/Buy-from No." := GenJournalLine."Sell-to/Buy-from No.";
        GenJnlLine."Bill-to/Pay-to No." := GenJournalLine."Bill-to/Pay-to No.";
        GenJnlLine."Country/Region Code" := GenJournalLine."Country/Region Code";

        GenJnlLine."VAT Registration No." := GenJournalLine."VAT Registration No.";
        GenJnlLine."Source Type" := GenJournalLine."Source Type";
        GenJnlLine."Source No." := GenJournalLine."Source No.";
        GenJnlLine."Posting No. Series" := GenJournalLine."Posting No. Series";
        GenJnlLine."IC Partner Code" := GenJournalLine."IC Partner Code";
        GenJnlLine."Ship-to/Order Address Code" := GenJournalLine."Ship-to/Order Address Code";
        GenJnlLine."Salespers./Purch. Code" := GenJournalLine."Salespers./Purch. Code";
        GenJnlLine."On Hold" := GenJournalLine."On Hold";
        if GenJnlLine."Account Type" = GenJnlLine."Account Type"::Vendor then
            GenJnlLine."Posting Group" := GenJournalLine."Posting Group";

        GenJnlLine."Account No." := GenJournalLine."Account No.";
        GenJnlLine."System-Created Entry" := GenJournalLine."System-Created Entry";
        GenJnlLine."Gen. Bus. Posting Group" := GenJournalLine."Gen. Bus. Posting Group";
        GenJnlLine."Gen. Prod. Posting Group" := GenJournalLine."Gen. Prod. Posting Group";
        GenJnlLine."VAT Bus. Posting Group" := GenJournalLine."VAT Bus. Posting Group";
        GenJnlLine."VAT Prod. Posting Group" := GenJournalLine."VAT Prod. Posting Group";
        GenJnlLine."Tax Area Code" := GenJournalLine."Tax Area Code";
        GenJnlLine."Tax Liable" := GenJournalLine."Tax Liable";
        GenJnlLine."Tax Group Code" := GenJournalLine."Tax Group Code";
        GenJnlLine."Use Tax" := GenJournalLine."Use Tax";
        GenJnlLine.Quantity := GenJournalLine.Quantity;
        GenJnlLine."VAT %" := GenJournalLine."VAT %";
        GenJnlLine."VAT Calculation Type" := GenJournalLine."VAT Calculation Type";
        GenJnlLine."VAT Posting" := GenJnlLine."VAT Posting"::"Manual VAT Entry";
        GenJnlLine."Job No." := GenJournalLine."Job No.";
        GenJnlLine."Deferral Code" := GenJournalLine."Deferral Code";
        GenJnlLine."Deferral Line No." := GenJournalLine."Deferral Line No.";
        GenJnlLine.Amount := GenJournalLine.Amount;
        GenJnlLine."Source Currency Amount" := GenJournalLine."Source Currency Amount";
        GenJnlLine."VAT Base Amount" := GenJournalLine."VAT Base Amount";
        GenJnlLine."Source Curr. VAT Base Amount" := GenJournalLine."Source Curr. VAT Base Amount";
        GenJnlLine."VAT Amount" := GenJournalLine."VAT Amount";
        GenJnlLine."Source Curr. VAT Amount" := GenJournalLine."Source Curr. VAT Amount";
        GenJnlLine."VAT Difference" := GenJournalLine."VAT Difference";
        GenJnlLine."VAT Base Before Pmt. Disc." := GenJournalLine."VAT Base Before Pmt. Disc.";

        GenJnlLine."Account Type" := GenJnlLine."Account Type"::"G/L Account";
        GenJnlLine."Account No." := GenJournalLine."SSA Non-Ded VAT Expense Acc 1";
        GenJnlLine."Gen. Posting Type" := 0;
        GenJnlLine."Gen. Bus. Posting Group" := '';
        GenJnlLine."Gen. Prod. Posting Group" := '';
        GenJnlLine."VAT Calculation Type" := 0;
        GenJnlLine."VAT Bus. Posting Group" := '';
        GenJnlLine."VAT Prod. Posting Group" := '';
        GenJnlLine."Posting Group" := '';
        GenJnlLine."Bal. Account Type" := GenJnlLine."Bal. Account Type"::"G/L Account";
        GenJnlLine."Bal. Account No." := VATPostingSetup."Purchase VAT Account";
        GenJnlLine."Currency Code" := OldGenJnlLine."Currency Code";
        GenJnlLine.Amount := Round(GenJournalLine."VAT Amount" / 2, 0.01);
        FirstLineAmount := Round(GenJournalLine."VAT Amount" / 2, 0.01);
        GenJnlLine."Amount (LCY)" := Round(GenJournalLine."VAT Amount" / 2, 0.01);
        GenJnlLine."Allow Zero-Amount Posting" := true;
        GenJnlPostLine.RunWithCheck(GenJnlLine);

        GenJnlLine.InitNewLine(
  GenJournalLine."Posting Date", GenJournalLine."Document Date", GenJournalLine.Description,
  GenJournalLine."Shortcut Dimension 1 Code", GenJournalLine."Shortcut Dimension 2 Code",
  GenJournalLine."Dimension Set ID", GenJournalLine."Reason Code");

        GenJnlLine.CopyDocumentFields(OldGenJnlLine."Document Type", OldGenJnlLine."Document No.", OldGenJnlLine."External Document No.", OldGenJnlLine."Source Code", '');
        GenJnlLine."Source Currency Code" := GenJournalLine."Currency Code";
        GenJnlLine."Currency Factor" := GenJournalLine."Currency Factor";
        GenJnlLine.Correction := GenJournalLine.Correction;
        GenJnlLine."VAT Base Discount %" := GenJournalLine."VAT Base Discount %";

        GenJnlLine."Sell-to/Buy-from No." := GenJournalLine."Sell-to/Buy-from No.";
        GenJnlLine."Bill-to/Pay-to No." := GenJournalLine."Bill-to/Pay-to No.";
        GenJnlLine."Country/Region Code" := GenJournalLine."Country/Region Code";

        GenJnlLine."VAT Registration No." := GenJournalLine."VAT Registration No.";
        GenJnlLine."Source Type" := GenJournalLine."Source Type";
        GenJnlLine."Source No." := GenJournalLine."Source No.";
        GenJnlLine."Posting No. Series" := GenJournalLine."Posting No. Series";
        GenJnlLine."IC Partner Code" := GenJournalLine."IC Partner Code";
        GenJnlLine."Ship-to/Order Address Code" := GenJournalLine."Ship-to/Order Address Code";
        GenJnlLine."Salespers./Purch. Code" := GenJournalLine."Salespers./Purch. Code";
        GenJnlLine."On Hold" := GenJournalLine."On Hold";
        if GenJnlLine."Account Type" = GenJnlLine."Account Type"::Vendor then
            GenJnlLine."Posting Group" := GenJournalLine."Posting Group";

        GenJnlLine."Account No." := GenJournalLine."Account No.";
        GenJnlLine."System-Created Entry" := GenJournalLine."System-Created Entry";
        GenJnlLine."Gen. Bus. Posting Group" := GenJournalLine."Gen. Bus. Posting Group";
        GenJnlLine."Gen. Prod. Posting Group" := GenJournalLine."Gen. Prod. Posting Group";
        GenJnlLine."VAT Bus. Posting Group" := GenJournalLine."VAT Bus. Posting Group";
        GenJnlLine."VAT Prod. Posting Group" := GenJournalLine."VAT Prod. Posting Group";
        GenJnlLine."Tax Area Code" := GenJournalLine."Tax Area Code";
        GenJnlLine."Tax Liable" := GenJournalLine."Tax Liable";
        GenJnlLine."Tax Group Code" := GenJournalLine."Tax Group Code";
        GenJnlLine."Use Tax" := GenJournalLine."Use Tax";
        GenJnlLine.Quantity := GenJournalLine.Quantity;
        GenJnlLine."VAT %" := GenJournalLine."VAT %";
        GenJnlLine."VAT Calculation Type" := GenJournalLine."VAT Calculation Type";
        GenJnlLine."VAT Posting" := GenJnlLine."VAT Posting"::"Manual VAT Entry";
        GenJnlLine."Job No." := GenJournalLine."Job No.";
        GenJnlLine."Deferral Code" := GenJournalLine."Deferral Code";
        GenJnlLine."Deferral Line No." := GenJournalLine."Deferral Line No.";
        GenJnlLine.Amount := GenJournalLine.Amount;
        GenJnlLine."Source Currency Amount" := GenJournalLine."Source Currency Amount";
        GenJnlLine."VAT Base Amount" := GenJournalLine."VAT Base Amount";
        GenJnlLine."Source Curr. VAT Base Amount" := GenJournalLine."Source Curr. VAT Base Amount";
        GenJnlLine."VAT Amount" := GenJournalLine."VAT Amount";
        GenJnlLine."Source Curr. VAT Amount" := GenJournalLine."Source Curr. VAT Amount";
        GenJnlLine."VAT Difference" := GenJournalLine."VAT Difference";
        GenJnlLine."VAT Base Before Pmt. Disc." := GenJournalLine."VAT Base Before Pmt. Disc.";

        GenJnlLine."Account Type" := GenJnlLine."Account Type"::"G/L Account";
        GenJnlLine."Account No." := GenJournalLine."SSA Non-Ded VAT Expense Acc 2";
        GenJnlLine."Gen. Posting Type" := 0;
        GenJnlLine."Gen. Bus. Posting Group" := '';
        GenJnlLine."Gen. Prod. Posting Group" := '';
        GenJnlLine."VAT Calculation Type" := 0;
        GenJnlLine."VAT Bus. Posting Group" := '';
        GenJnlLine."VAT Prod. Posting Group" := '';
        GenJnlLine."Posting Group" := '';
        GenJnlLine."Bal. Account Type" := GenJnlLine."Bal. Account Type"::"G/L Account";
        GenJnlLine."Bal. Account No." := VATPostingSetup."Purchase VAT Account";
        GenJnlLine."Currency Code" := OldGenJnlLine."Currency Code";
        GenJnlLine.Amount := GenJournalLine."VAT Amount" - FirstLineAmount;
        GenJnlLine."Amount (LCY)" := GenJournalLine."VAT Amount" - FirstLineAmount;
        GenJnlLine."Allow Zero-Amount Posting" := true;
        GenJnlPostLine.RunWithCheck(GenJnlLine);
        //SSA948<<
    end;

    [EventSubscriber(ObjectType::Codeunit, 21, 'OnAfterCheckItemJnlLine', '', false, false)]
    local procedure C21OnAfterCheckItemJnlLine(var ItemJnlLine: Record "Item Journal Line")
    var
        SSASetup: Record "SSA Localization Setup";
    begin
        //SSA970>>
        ItemJnlLine.TestField("Gen. Prod. Posting Group");
        SSASetup.Get();
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
        SSASetup.Get();
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
    begin
        //Error(Text001, Report::"Adjust Exchange Rates", report::"SSA Adjust Exchange Rates");
        IsHandled := true;
    end;

    [EventSubscriber(ObjectType::Report, Report::"Close Income Statement", 'OnBeforeCheckDimPostingRules', '', false, false)]
    local procedure Error_CloseIncomeStatement()
    var
        Text001: Label 'Report %1 has been replaced by Report %2 from SS Localization.';
    begin
        Error(Text001, Report::"Close Income Statement", Report::"SSA Close Income Statement");
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
