codeunit 70012 "SSA Intrastat"
{
    [EventSubscriber(ObjectType::Report, 70007, 'OnBeforeInsertItemJnlLine', '', false, false)]
    local procedure OnBeforeInsertItemJnlLine(var IntrastatJnlLine: Record "Intrastat Jnl. Line"; ItemLedgerEntry: Record "Item Ledger Entry")
    begin
        //SSA953>>
        if IntrastatJnlLine."Transaction Type" = '' then
            IntrastatJnlLine."Transaction Type" := '11';
        if IntrastatJnlLine."Transport Method" = '' then
            IntrastatJnlLine."Transport Method" := '3';
        //SSA953<<
    end;

    [EventSubscriber(ObjectType::Report, 70007, 'OnBeforeInsertJobLedgerLine', '', false, false)]
    local procedure OnBeforeInsertJobJnlLine(var IntrastatJnlLine: Record "Intrastat Jnl. Line"; JobLedgerEntry: Record "Job Ledger Entry")
    begin
        //SSA954>>
        if IntrastatJnlLine."Transaction Type" = '' then
            IntrastatJnlLine."Transaction Type" := '11';
        if IntrastatJnlLine."Transport Method" = '' then
            IntrastatJnlLine."Transport Method" := '3';
        //SSA954<<
    end;

    [EventSubscriber(ObjectType::Report, 70007, 'OnBeforeInsertValueEntryLine', '', false, false)]
    local procedure OnBeforeInsertValueJnlLine(var IntrastatJnlLine: Record "Intrastat Jnl. Line"; ItemLedgerEntry: Record "Item Ledger Entry")
    begin
        //SSA954>>
        if IntrastatJnlLine."Transaction Type" = '' then
            IntrastatJnlLine."Transaction Type" := '11';
        if IntrastatJnlLine."Transport Method" = '' then
            IntrastatJnlLine."Transport Method" := '3';
        //SSA954<<
    end;

    [EventSubscriber(ObjectType::Codeunit, 5604, 'OnAfterCopyFromGenJnlLine', '', false, false)]
    local procedure OnAfterCopyFromGenJnlLine(var FALedgerEntry: Record "FA Ledger Entry"; GenJournalLine: Record "Gen. Journal Line")
    begin
        //SSA953>>
        FALedgerEntry."SSA Transaction Type" := GenJournalLine."SSA Transaction Type";
        FALedgerEntry."SSA Transport Method" := GenJournalLine."SSA Transport Method";
        FALedgerEntry."SSA Country/Region Code" := GenJournalLine."Country/Region Code";
        FALedgerEntry."SSA Entry/Exit Point" := GenJournalLine."SSA Entry/Exit Point";
        FALedgerEntry."SSA Area" := GenJournalLine."SSA Area";
        FALedgerEntry."SSA Transaction Specification" := GenJournalLine."SSA Transaction Specification";
        FALedgerEntry."SSA Shpt. Method Code" := GenJournalLine."SSA Shpt. Method Code";
        //SSA953<<
    end;

    procedure IsCountryRegionIntrastat(CountryRegionCode: Code[10]; ShipTo: Boolean): Boolean
    var
        CompanyInfo: Record "Company Information";
        CountryRegion: Record "Country/Region";
    begin
        //SSA954>>
        if CountryRegionCode = '' then
            exit(false);

        CountryRegion.Get(CountryRegionCode);
        if CountryRegion."Intrastat Code" = '' then
            exit(false);

        CompanyInfo.Get();
        if ShipTo then
            exit(CountryRegionCode <> CompanyInfo."Ship-to Country/Region Code");
        exit(CountryRegionCode <> CompanyInfo."Country/Region Code");
        //SSA954<<
    end;
}
