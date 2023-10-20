codeunit 70009 "SSA C12 Gen. Jnl.-Post Line"
{
    var
        Text001: Label 'You cannot apply %1 with %2 journal line %3! Try to apply %1 with %1!';

    [EventSubscriber(ObjectType::Codeunit, 12, 'OnBeforeInsertDtldCustLedgEntry', '', false, false)]
    local procedure OnBeforeInsertDtldCustLedgEntry(var DtldCustLedgEntry: Record "Detailed Cust. Ledg. Entry"; GenJournalLine: Record "Gen. Journal Line"; DtldCVLedgEntryBuffer: Record "Detailed CV Ledg. Entry Buffer")
    begin
        //SSA960>>
        DtldCustLedgEntry."SSA Customer Posting Group" := GenJournalLine."Posting Group";
        //SSA960<<
    end;

    [EventSubscriber(ObjectType::Codeunit, 12, 'OnBeforeInsertDtldVendLedgEntry', '', false, false)]
    local procedure OnBeforeInsertDtldVendLedgEntry(var DtldVendLedgEntry: Record "Detailed Vendor Ledg. Entry"; GenJournalLine: Record "Gen. Journal Line"; DtldCVLedgEntryBuffer: Record "Detailed CV Ledg. Entry Buffer")
    begin
        //SSA960>>
        DtldVendLedgEntry."SSA Vendor Posting Group" := GenJournalLine."Posting Group";
        //SSA960<<
    end;

    [EventSubscriber(ObjectType::Codeunit, 12, 'OnPrepareTempVendLedgEntryOnBeforeExit', '', false, false)]
    local procedure OnPrepareTempVendLedgEntryOnBeforeExit(var GenJournalLine: Record "Gen. Journal Line"; var CVLedgerEntryBuffer: Record "CV Ledger Entry Buffer"; var TempOldVendLedgEntry: Record "Vendor Ledger Entry" temporary)
    begin
        //SSA944>>
        TempOldVendLedgEntry.SetFilter("Vendor Posting Group", '<>%1', GenJournalLine."Posting Group");
        if TempOldVendLedgEntry.FindFirst() then
            Error(Text001, GenJournalLine."Posting Group", TempOldVendLedgEntry."Vendor Posting Group", GenJournalLine."Line No.")
        else
            TempOldVendLedgEntry.SetRange("Vendor Posting Group");
        //SSA944<<
    end;

    [EventSubscriber(ObjectType::Codeunit, 12, 'OnPrepareTempCustLedgEntryOnBeforeExit', '', false, false)]
    local procedure OnPrepareTempCustLedgEntryOnBeforeExit(var GenJournalLine: Record "Gen. Journal Line"; var CVLedgerEntryBuffer: Record "CV Ledger Entry Buffer"; var TempOldCustLedgEntry: Record "Cust. Ledger Entry" temporary)
    begin
        //SSA944>>
        TempOldCustLedgEntry.SetFilter("Customer Posting Group", '<>%1', GenJournalLine."Posting Group");
        if TempOldCustLedgEntry.FindFirst() then
            Error(Text001, GenJournalLine."Posting Group", TempOldCustLedgEntry."Customer Posting Group", GenJournalLine."Line No.")
        else
            TempOldCustLedgEntry.SetRange("Customer Posting Group");
        //SSA944<<
    end;

    [EventSubscriber(ObjectType::Codeunit, 12, 'OnBeforeInsertPostUnrealVATEntry', '', false, false)]
    local procedure OnBeforeInsertPostUnrealVATEntry(var VATEntry: Record "VAT Entry"; GenJournalLine: Record "Gen. Journal Line")
    begin
        //SSA946>>
        VATEntry."SSA Custom Invoice No." := GenJournalLine."SSA Custom Invoice No.";
        //SSA946<<
    end;

    [EventSubscriber(ObjectType::Codeunit, 12, 'OnBeforeInsertTempVATEntry', '', false, false)]
    local procedure OnBeforeInsertTempVATEntry(var TempVATEntry: Record "VAT Entry" temporary; GenJournalLine: Record "Gen. Journal Line")
    begin
        //SSA946>>
        TempVATEntry."SSA Custom Invoice No." := GenJournalLine."SSA Custom Invoice No.";
        //SSA946<<
    end;

    [EventSubscriber(ObjectType::Table, 25, 'OnAfterCopyVendLedgerEntryFromGenJnlLine', '', false, false)]
    local procedure T25OnAfterCopyVendLedgerEntryFromGenJnlLine(var VendorLedgerEntry: Record "Vendor Ledger Entry"; GenJournalLine: Record "Gen. Journal Line")
    var
        SSASetup: Record "SSA Localization Setup";
    begin
        //SSA946>>
        VendorLedgerEntry."SSA Custom Invoice No." := GenJournalLine."SSA Custom Invoice No.";

        SSASetup.Get();
        if (GenJournalLine."Document Type" in [GenJournalLine."Document Type"::Invoice, GenJournalLine."Document Type"::"Credit Memo"]) and
           SSASetup."Custom Invoice No. Mandatory"
        then
            GenJournalLine.TestField("SSA Custom Invoice No.");
        //SSA946<<
    end;

    [EventSubscriber(ObjectType::Table, 17, 'OnAfterCopyGLEntryFromGenJnlLine', '', false, false)]
    local procedure T17OnAfterCopyGLEntryFromGenJnlLine(var GLEntry: Record "G/L Entry"; var GenJournalLine: Record "Gen. Journal Line")
    begin
        //SSA946>>
        GLEntry."SSA Custom Invoice No." := GenJournalLine."SSA Custom Invoice No.";
        //SSA946<<
    end;

    [EventSubscriber(ObjectType::Table, 254, 'OnAfterCopyFromGenJnlLine', '', false, false)]
    local procedure T254OnAfterCopyFromGenJnlLine(var VATEntry: Record "VAT Entry"; GenJournalLine: Record "Gen. Journal Line")
    begin
        //SSA946>>
        VATEntry."SSA Custom Invoice No." := GenJournalLine."SSA Custom Invoice No.";
        //SSA946<<
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", 'OnPostDeferralPostBufferOnBeforeInsertGLEntryForDeferralAccount', '', true, false)]
    local procedure CU12_OnPostDeferralPostBufferOnBeforeInsertGLEntryForDeferralAccount(GenJournalLine: Record "Gen. Journal Line"; DeferralPostingBuffer: Record "Deferral Posting Buffer"; var GLEntry: Record "G/L Entry")
    var
        GlobalVariables: Codeunit "SSA Global Variables";
    begin
        GlobalVariables.SetDeferralCorrection(GenJournalLine.Correction);
        GenJournalLine.Correction := DeferralPostingBuffer."SSA Correction";
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", 'OnAfterPostDeferralPostBuffer', '', true, false)]
    local procedure CU12_OnAfterPostDeferralPostBuffer(var GenJournalLine: Record "Gen. Journal Line")
    var
        GlobalVariables: Codeunit "SSA Global Variables";
    begin
        GenJournalLine.Correction := GlobalVariables.GetDeferralCorrection();
    end;
    //OnAfterPostDeferralPostBuffer(GenJournalLine);
}