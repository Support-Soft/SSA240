codeunit 70012 "SSA Intrastat"
{
    // SSA953 SSCAT 05.07.2019 19.Funct. intrastat
    // SSA954 SSCAT 04.09.2019 20.Funct. Localizare Intrastat pentru Jobs


    trigger OnRun()
    begin
    end;

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
        with FALedgerEntry do begin
            "SSA Transaction Type" := GenJournalLine."SSA Transaction Type";
            "SSA Transport Method" := GenJournalLine."SSA Transport Method";
            "SSA Country/Region Code" := GenJournalLine."Country/Region Code";
            "SSA Entry/Exit Point" := GenJournalLine."SSA Entry/Exit Point";
            "SSA Area" := GenJournalLine."SSA Area";
            "SSA Transaction Specification" := GenJournalLine."SSA Transaction Specification";
            "SSA Shpt. Method Code" := GenJournalLine."SSA Shpt. Method Code";
        end;
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

        CompanyInfo.Get;
        if ShipTo then
            exit(CountryRegionCode <> CompanyInfo."Ship-to Country/Region Code");
        exit(CountryRegionCode <> CompanyInfo."Country/Region Code");
        //SSA954<<
    end;
}

