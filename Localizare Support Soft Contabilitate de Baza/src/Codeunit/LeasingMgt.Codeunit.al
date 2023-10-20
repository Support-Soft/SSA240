codeunit 70030 "SSA Leasing Mgt."
{


    var
        GenJnlTemplate: Record "Gen. Journal Template";

    [EventSubscriber(ObjectType::Codeunit, 11, 'OnBeforeCheckPostingDateInFiscalYear', '', false, false)]
    local procedure CUGenJnlCheckLineOnBeforeCheckPostingDateInFiscalYear(GenJournalLine: Record "Gen. Journal Line"; var IsHandled: Boolean)
    var
        AccountingPeriod: Record "Accounting Period";
    begin
        if AccountingPeriod.IsEmpty() then
            exit;
        AccountingPeriod.Get(NormalDate(GenJournalLine."Posting Date") + 1);
        IsHandled := true;
    end;

    [EventSubscriber(ObjectType::Codeunit, 11, 'OnBeforeCheckAccountNo', '', false, false)]
    local procedure CUGenJnlCheckLineOnBeforeCheckAccountNoSubscr(var GenJnlLine: Record "Gen. Journal Line"; var CheckDone: Boolean)
    var
        ICPartner: Record "IC Partner";
        GenJnlCheckLine: Codeunit "Gen. Jnl.-Check Line";
        Text003: Label 'must have the same sign as %1';
        Text005: Label '%1 + %2 must be %3.';
        GenJnlTemplate: Record "Gen. Journal Template";
        SpecifyGenPostingTypeErr: Label 'Posting to Account %1 must either be of type Purchase or Sale (see %2), because there are specified values in one of the following fields: %3, %4 , %5, or %6', Comment = '%1 an G/L Account number;%2 = Gen. Posting Type; %3 = Gen. Bus. Posting Group; %4 = Gen. Prod. Posting Group; %5 = VAT Bus. Posting Group, %6 = VAT Prod. Posting Group';
    begin

        if GenJnlTemplate.Get(GenJnlLine."Journal Template Name") then;

        case GenJnlLine."Account Type" of
            GenJnlLine."Account Type"::"G/L Account":
                begin
                    if (((GenJnlLine."Gen. Bus. Posting Group" <> '') or (GenJnlLine."Gen. Prod. Posting Group" <> '') or
                        (GenJnlLine."VAT Bus. Posting Group" <> '') or (GenJnlLine."VAT Prod. Posting Group" <> '')) and
                        (GenJnlLine."Gen. Posting Type" = GenJnlLine."Gen. Posting Type"::" "))
                    then
                        LogError(
                            GenJnlLine,
                            StrSubstNo(
                                SpecifyGenPostingTypeErr, GenJnlLine."Account No.", GenJnlLine.FieldCaption("Gen. Posting Type"),
                                GenJnlLine.FieldCaption("Gen. Bus. Posting Group"), GenJnlLine.FieldCaption("Gen. Prod. Posting Group"),
                                GenJnlLine.FieldCaption("VAT Bus. Posting Group"), GenJnlLine.FieldCaption("VAT Prod. Posting Group")));

                    CheckGenProdPostingGroupWhenAdjustForPmtDisc(GenJnlLine);

                    if (GenJnlLine."Gen. Posting Type" <> GenJnlLine."Gen. Posting Type"::" ") and
                       (GenJnlLine."VAT Posting" = GenJnlLine."VAT Posting"::"Automatic VAT Entry")
                    then begin
                        if GenJnlLine."VAT Amount" + GenJnlLine."VAT Base Amount" <> GenJnlLine.Amount then
                            LogError(
                                GenJnlLine,
                                StrSubstNo(
                                    Text005, GenJnlLine.FieldCaption("VAT Amount"), GenJnlLine.FieldCaption("VAT Base Amount"),
                                    GenJnlLine.FieldCaption(Amount)));
                        if GenJnlLine."Currency Code" <> '' then
                            if GenJnlLine."VAT Amount (LCY)" + GenJnlLine."VAT Base Amount (LCY)" <> GenJnlLine."Amount (LCY)" then
                                LogError(
                                    GenJnlLine,
                                    StrSubstNo(
                                        Text005, GenJnlLine.FieldCaption("VAT Amount (LCY)"),
                                        GenJnlLine.FieldCaption("VAT Base Amount (LCY)"), GenJnlLine.FieldCaption("Amount (LCY)")));
                    end;
                end;
            GenJnlLine."Account Type"::Customer, GenJnlLine."Account Type"::Vendor, GenJnlLine."Account Type"::Employee:
                begin
                    if not GenJnlLine."SSA Leasing" then begin
                        LogTestField(GenJnlLine, GenJnlLine.FieldNo("Gen. Posting Type"), 0);
                        LogTestField(GenJnlLine, GenJnlLine.FieldNo("Gen. Bus. Posting Group"), '');
                        LogTestField(GenJnlLine, GenJnlLine.FieldNo("Gen. Prod. Posting Group"), '');
                        LogTestField(GenJnlLine, GenJnlLine.FieldNo("VAT Bus. Posting Group"), '');
                        LogTestField(GenJnlLine, GenJnlLine.FieldNo("VAT Prod. Posting Group"), '');
                    end;
                    CheckAccountType(GenJnlLine);

                    GenJnlCheckLine.CheckDocType(GenJnlLine);

                    if not GenJnlLine."System-Created Entry" and
                       (((GenJnlLine.Amount < 0) xor (GenJnlLine."Sales/Purch. (LCY)" < 0)) and (GenJnlLine.Amount <> 0) and (GenJnlLine."Sales/Purch. (LCY)" <> 0))
                    then
                        LogFieldError(GenJnlLine, GenJnlLine.FieldNo("Sales/Purch. (LCY)"), StrSubstNo(Text003, GenJnlLine.FieldCaption(Amount)));
                    LogTestField(GenJnlLine, GenJnlLine.FieldNo("Job No."), '');

                    CheckICPartner(GenJnlLine."Account Type", GenJnlLine."Account No.", GenJnlLine."Document Type");
                end;
            GenJnlLine."Account Type"::"Bank Account":
                begin
                    LogTestField(GenJnlLine, GenJnlLine.FieldNo("Gen. Posting Type"), 0);
                    LogTestField(GenJnlLine, GenJnlLine.FieldNo("Gen. Bus. Posting Group"), '');
                    LogTestField(GenJnlLine, GenJnlLine.FieldNo("Gen. Prod. Posting Group"), '');
                    LogTestField(GenJnlLine, GenJnlLine.FieldNo("VAT Bus. Posting Group"), '');
                    LogTestField(GenJnlLine, GenJnlLine.FieldNo("VAT Prod. Posting Group"), '');
                    LogTestField(GenJnlLine, GenJnlLine.FieldNo("Job No."), '');
                    if (GenJnlLine.Amount < 0) and (GenJnlLine."Bank Payment Type" = GenJnlLine."Bank Payment Type"::"Computer Check") then
                        LogTestField(GenJnlLine, GenJnlLine.FieldNo("Check Printed"), true);
                    CheckElectronicPaymentFields(GenJnlLine);
                end;
            GenJnlLine."Account Type"::"IC Partner":
                begin
                    ICPartner.Get(GenJnlLine."Account No.");
                    ICPartner.CheckICPartner();
                    if GenJnlLine."Journal Template Name" <> '' then
                        if GenJnlTemplate.Type <> GenJnlTemplate.Type::Intercompany then
                            LogFieldError(GenJnlLine, GenJnlLine.FieldNo("Account Type"), '');
                end;
        end;
        CheckDone := true;
    end;

    local procedure LogError(SourceVariant: Variant; ErrorMessage: Text)
    var
        ErrorMessageMgt: Codeunit "Error Message Management";
        LogErrorMode: Boolean;
    begin
        if LogErrorMode then
            ErrorMessageMgt.LogErrorMessage(0, ErrorMessage, SourceVariant, 0, '')
        else
            Error(ErrorMessage);
    end;

    local procedure LogTestField(SourceVariant: Variant; FieldNo: Integer)
    var
        RecRef: RecordRef;
        FldRef: FieldRef;
        ErrorMessageMgt: Codeunit "Error Message Management";
        LogErrorMode: Boolean;
    begin
        RecRef.GetTable(SourceVariant);
        FldRef := RecRef.Field(FieldNo);
        if LogErrorMode then
            ErrorMessageMgt.LogTestField(SourceVariant, FieldNo)
        else
            FldRef.TestField();
    end;

    local procedure LogTestField(SourceVariant: Variant; FieldNo: Integer; ExpectedValue: Variant)
    var
        RecRef: RecordRef;
        FldRef: FieldRef;
        ErrorMessageMgt: Codeunit "Error Message Management";
        LogErrorMode: Boolean;
    begin
        RecRef.GetTable(SourceVariant);
        FldRef := RecRef.Field(FieldNo);
        if LogErrorMode then
            ErrorMessageMgt.LogTestField(SourceVariant, FieldNo, ExpectedValue)
        else
            FldRef.TestField(ExpectedValue);
    end;

    local procedure LogFieldError(SourceVariant: Variant; FieldNo: Integer; ErrorMessage: Text)
    var
        RecRef: RecordRef;
        FldRef: FieldRef;
        LogErrorMode: Boolean;
        ErrorMessageMgt: Codeunit "Error Message Management";
    begin
        RecRef.GetTable(SourceVariant);
        FldRef := RecRef.Field(FieldNo);
        if LogErrorMode then
            ErrorMessageMgt.LogFieldError(SourceVariant, FieldNo, ErrorMessage)
        else
            FldRef.FieldError(ErrorMessage);
    end;

    local procedure CheckGenProdPostingGroupWhenAdjustForPmtDisc(GenJnlLine: Record "Gen. Journal Line")
    var
        VATPostingSetup: Record "VAT Posting Setup";
    begin
        if GenJnlLine."System-Created Entry" or
   not (GenJnlLine."Gen. Posting Type" in [GenJnlLine."Gen. Posting Type"::Purchase, GenJnlLine."Gen. Posting Type"::Sale]) or
   not (GenJnlLine."Document Type" in [GenJnlLine."Document Type"::Invoice, GenJnlLine."Document Type"::"Credit Memo"])
then
            exit;

        if VATPostingSetup.Get(GenJnlLine."VAT Bus. Posting Group", GenJnlLine."VAT Prod. Posting Group") and
           VATPostingSetup."Adjust for Payment Discount"
        then
            LogTestField(GenJnlLine, GenJnlLine.FieldNo("Gen. Prod. Posting Group"));
    end;

    local procedure CheckAccountType(GenJnlLine: Record "Gen. Journal Line")
    var
        Text010: Label '%1 %2 and %3 %4 is not allowed.';
    begin

        if ((GenJnlLine."Account Type" = GenJnlLine."Account Type"::Customer) and
            (GenJnlLine."Bal. Gen. Posting Type" = GenJnlLine."Bal. Gen. Posting Type"::Purchase)) or
           ((GenJnlLine."Account Type" = GenJnlLine."Account Type"::Vendor) and
            (GenJnlLine."Bal. Gen. Posting Type" = GenJnlLine."Bal. Gen. Posting Type"::Sale))
        then
            LogError(
                GenJnlLine,
                StrSubstNo(
                    Text010,
                    GenJnlLine.FieldCaption("Account Type"), GenJnlLine."Account Type",
                    GenJnlLine.FieldCaption("Bal. Gen. Posting Type"), GenJnlLine."Bal. Gen. Posting Type"));
    end;

    local procedure CheckICPartner(AccountType: Enum "Gen. Journal Account Type"; AccountNo: Code[20]; DocumentType: Enum "Gen. Journal Document Type")
    var
        Customer: Record Customer;
        Vendor: Record Vendor;
        ICPartner: Record "IC Partner";
        Employee: Record Employee;

    begin
        case AccountType of
            AccountType::Customer:
                if Customer.Get(AccountNo) then begin
                    Customer.CheckBlockedCustOnJnls(Customer, DocumentType, true);
                    if (Customer."IC Partner Code" <> '') and (GenJnlTemplate.Type = GenJnlTemplate.Type::Intercompany) and
                       ICPartner.Get(Customer."IC Partner Code")
                    then
                        ICPartner.CheckICPartnerIndirect(Format(AccountType), AccountNo);
                end;
            AccountType::Vendor:
                if Vendor.Get(AccountNo) then begin
                    Vendor.CheckBlockedVendOnJnls(Vendor, DocumentType, true);
                    if (Vendor."IC Partner Code" <> '') and (GenJnlTemplate.Type = GenJnlTemplate.Type::Intercompany) and
                       ICPartner.Get(Vendor."IC Partner Code")
                    then
                        ICPartner.CheckICPartnerIndirect(Format(AccountType), AccountNo);
                end;
            AccountType::Employee:
                if Employee.Get(AccountNo) then
                    Employee.CheckBlockedEmployeeOnJnls(true)
        end;
    end;

    local procedure CheckElectronicPaymentFields(GenJnlLine: Record "Gen. Journal Line")
    begin
        if (GenJnlLine."Bank Payment Type" = GenJnlLine."Bank Payment Type"::"Electronic Payment") or
   (GenJnlLine."Bank Payment Type" = GenJnlLine."Bank Payment Type"::"Electronic Payment-IAT")
then begin
            LogTestField(GenJnlLine, GenJnlLine.FieldNo("Exported to Payment File"), true);
            LogTestField(GenJnlLine, GenJnlLine.FieldNo("Check Transmitted"), true);
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, 12, 'OnBeforePostGenJnlLine', '', false, false)]
    local procedure C12_OnBeforePostGenJnlLine(var GenJournalLine: Record "Gen. Journal Line"; Balancing: Boolean)
    var
        SSASetup: Record "SSA Localization Setup";
    begin
        //SSA1196>>
        SSASetup.Get();
        SSASetup.TestField("Leasing Journal Template");
        SSASetup.TestField("Advance Journal Template");
        GenJournalLine."SSA Leasing" := false;
        if (GenJournalLine."Journal Template Name" = SSASetup."Leasing Journal Template") or
           (GenJournalLine."Journal Template Name" = SSASetup."Advance Journal Template")
        then
            GenJournalLine."SSA Leasing" := true;
        //SSA1196<<
    end;

    [EventSubscriber(ObjectType::Codeunit, 12, 'OnPostVendOnAfterCopyCVLedgEntryBuf', '', false, false)]
    local procedure C12_OnPostVendOnAfterCopyCVLedgEntryBuf(var CVLedgerEntryBuffer: Record "CV Ledger Entry Buffer"; GenJournalLine: Record "Gen. Journal Line")
    var
        GLSetup: Record "General Ledger Setup";
    begin
        //SSA1196>>
        GLSetup.Get();
        if GLSetup."Pmt. Disc. Excl. VAT" then begin
            if GenJournalLine."SSA Leasing" then
                CVLedgerEntryBuffer."Original Pmt. Disc. Possible" := GenJournalLine."Sales/Purch. (LCY)" * (GenJournalLine.Amount - GenJournalLine."VAT Amount") / (GenJournalLine."Amount (LCY)" - GenJournalLine."VAT Amount (LCY)")
            else
                CVLedgerEntryBuffer."Original Pmt. Disc. Possible" := GenJournalLine."Sales/Purch. (LCY)" * GenJournalLine.Amount / GenJournalLine."Amount (LCY)";
        end
        else
            if GenJournalLine."SSA Leasing" then
                CVLedgerEntryBuffer."Original Pmt. Disc. Possible" := GenJournalLine.Amount - GenJournalLine."VAT Amount"
            else
                CVLedgerEntryBuffer."Original Pmt. Disc. Possible" := GenJournalLine.Amount;
        //SSA1196<<
    end;

    [EventSubscriber(ObjectType::Codeunit, 12, 'OnCreateGLEntryForTotalAmountsOnBeforeInsertGLEntry', '', false, false)]
    local procedure OnCreateGLEntryForTotalAmountsOnBeforeInsertGLEntry(var GenJnlLine: Record "Gen. Journal Line"; var GLEntry: Record "G/L Entry"; var IsHandled: Boolean)
    var
        GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line";
        VATPostingSetup: Record "VAT Posting Setup";
    begin

        if GenJnlLine."SSA Leasing" then begin
            GenJnlPostLine.InitVAT(GenJnlLine, GLEntry, VATPostingSetup);
            GenJnlPostLine.InsertGLEntry(GenJnlLine, GLEntry, true);
            GenJnlPostLine.PostVAT(GenJnlLine, GLEntry, VATPostingSetup);
        end
        else
            GenJnlPostLine.InsertGLEntry(GenJnlLine, GLEntry, true);
    end;

    [EventSubscriber(ObjectType::Table, 383, 'OnAfterCopyFromGenJnlLine', '', false, false)]
    local procedure T383_OnPostCustOnAfterCopyCVLedgEntryBuf(var DtldCVLedgEntryBuffer: Record "Detailed CV Ledg. Entry Buffer"; GenJnlLine: Record "Gen. Journal Line")
    begin
        //SSA1196>>
        if GenJnlLine."SSA Leasing" then begin
            DtldCVLedgEntryBuffer.Amount := GenJnlLine.Amount - GenJnlLine."VAT Amount";
            DtldCVLedgEntryBuffer."Amount (LCY)" := GenJnlLine."Amount (LCY)" - GenJnlLine."VAT Amount (LCY)";
            DtldCVLedgEntryBuffer."Additional-Currency Amount" := GenJnlLine.Amount - GenJnlLine."VAT Amount";
        end
        else begin
            DtldCVLedgEntryBuffer.Amount := GenJnlLine.Amount;
            DtldCVLedgEntryBuffer."Amount (LCY)" := GenJnlLine."Amount (LCY)";
            DtldCVLedgEntryBuffer."Additional-Currency Amount" := GenJnlLine.Amount;
        end;
        //SSA1196<<
    end;
}