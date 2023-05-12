codeunit 70030 "SSA Leasing Mgt."
{
    // SSA1196 SSCAT 04.11.2019 Leasing


    trigger OnRun()
    begin
    end;

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
        VATPostingSetup: Record "VAT Posting Setup";
        Text003: Label 'must have the same sign as %1';
        Text005: Label '%1 + %2 must be %3.';
        Text010: Label '%1 %2 and %3 %4 is not allowed.';
        GenJnlTemplate: Record "Gen. Journal Template";
        GLSetup: Record "General Ledger Setup";
        SpecifyGenPostingTypeErr: Label 'Posting to Account %1 must either be of type Purchase or Sale (see %2), because there are specified values in one of the following fields: %3, %4 , %5, or %6', comment = '%1 an G/L Account number;%2 = Gen. Posting Type; %3 = Gen. Bus. Posting Group; %4 = Gen. Prod. Posting Group; %5 = VAT Bus. Posting Group, %6 = VAT Prod. Posting Group';
    begin

        with GenJnlLine do begin
            if GenJnlTemplate.Get("Journal Template Name") then;

            case "Account Type" of
                "Account Type"::"G/L Account":
                    begin
                        if ((("Gen. Bus. Posting Group" <> '') or ("Gen. Prod. Posting Group" <> '') or
                            ("VAT Bus. Posting Group" <> '') or ("VAT Prod. Posting Group" <> '')) and
                            ("Gen. Posting Type" = "Gen. Posting Type"::" "))
                        then
                            LogError(
                                GenJnlLine,
                                StrSubstNo(
                                    SpecifyGenPostingTypeErr, "Account No.", FieldCaption("Gen. Posting Type"),
                                    FieldCaption("Gen. Bus. Posting Group"), FieldCaption("Gen. Prod. Posting Group"),
                                    FieldCaption("VAT Bus. Posting Group"), FieldCaption("VAT Prod. Posting Group")));

                        CheckGenProdPostingGroupWhenAdjustForPmtDisc(GenJnlLine);

                        if ("Gen. Posting Type" <> "Gen. Posting Type"::" ") and
                           ("VAT Posting" = "VAT Posting"::"Automatic VAT Entry")
                        then begin
                            if "VAT Amount" + "VAT Base Amount" <> Amount then
                                LogError(
                                    GenJnlLine,
                                    StrSubstNo(
                                        Text005, FieldCaption("VAT Amount"), FieldCaption("VAT Base Amount"),
                                        FieldCaption(Amount)));
                            if "Currency Code" <> '' then
                                if "VAT Amount (LCY)" + "VAT Base Amount (LCY)" <> "Amount (LCY)" then
                                    LogError(
                                        GenJnlLine,
                                        StrSubstNo(
                                            Text005, FieldCaption("VAT Amount (LCY)"),
                                            FieldCaption("VAT Base Amount (LCY)"), FieldCaption("Amount (LCY)")));
                        end;
                    end;
                "Account Type"::Customer, "Account Type"::Vendor, "Account Type"::Employee:
                    begin
                        if not "SSA Leasing" then begin
                            LogTestField(GenJnlLine, FieldNo("Gen. Posting Type"), 0);
                            LogTestField(GenJnlLine, FieldNo("Gen. Bus. Posting Group"), '');
                            LogTestField(GenJnlLine, FieldNo("Gen. Prod. Posting Group"), '');
                            LogTestField(GenJnlLine, FieldNo("VAT Bus. Posting Group"), '');
                            LogTestField(GenJnlLine, FieldNo("VAT Prod. Posting Group"), '');
                        end;
                        CheckAccountType(GenJnlLine);

                        GenJnlCheckLine.CheckDocType(GenJnlLine);

                        if not "System-Created Entry" and
                           (((Amount < 0) xor ("Sales/Purch. (LCY)" < 0)) and (Amount <> 0) and ("Sales/Purch. (LCY)" <> 0))
                        then
                            LogFieldError(GenJnlLine, GenJnlLine.FieldNo("Sales/Purch. (LCY)"), StrSubstNo(Text003, FieldCaption(Amount)));
                        LogTestField(GenJnlLine, GenJnlLine.FieldNo("Job No."), '');

                        CheckICPartner("Account Type", "Account No.", "Document Type");
                    end;
                "Account Type"::"Bank Account":
                    begin
                        LogTestField(GenJnlLine, FieldNo("Gen. Posting Type"), 0);
                        LogTestField(GenJnlLine, FieldNo("Gen. Bus. Posting Group"), '');
                        LogTestField(GenJnlLine, FieldNo("Gen. Prod. Posting Group"), '');
                        LogTestField(GenJnlLine, FieldNo("VAT Bus. Posting Group"), '');
                        LogTestField(GenJnlLine, FieldNo("VAT Prod. Posting Group"), '');
                        LogTestField(GenJnlLine, GenJnlLine.FieldNo("Job No."), '');
                        if (Amount < 0) and ("Bank Payment Type" = "Bank Payment Type"::"Computer Check") then
                            LogTestField(GenJnlLine, FieldNo("Check Printed"), true);
                        CheckElectronicPaymentFields(GenJnlLine);
                    end;
                "Account Type"::"IC Partner":
                    begin
                        ICPartner.Get("Account No.");
                        ICPartner.CheckICPartner;
                        if "Journal Template Name" <> '' then
                            if GenJnlTemplate.Type <> GenJnlTemplate.Type::Intercompany then
                                LogFieldError(GenJnlLine, GenJnlLine.FieldNo("Account Type"), '');
                    end;
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
        with GenJnlLine do begin
            if "System-Created Entry" or
               not ("Gen. Posting Type" in ["Gen. Posting Type"::Purchase, "Gen. Posting Type"::Sale]) or
               not ("Document Type" in ["Document Type"::Invoice, "Document Type"::"Credit Memo"])
            then
                exit;

            if VATPostingSetup.Get("VAT Bus. Posting Group", "VAT Prod. Posting Group") and
               VATPostingSetup."Adjust for Payment Discount"
            then
                LogTestField(GenJnlLine, FieldNo("Gen. Prod. Posting Group"));
        end;
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
        with GenJnlLine do
            if ("Bank Payment Type" = "Bank Payment Type"::"Electronic Payment") or
               ("Bank Payment Type" = "Bank Payment Type"::"Electronic Payment-IAT")
            then begin
                LogTestField(GenJnlLine, FieldNo("Exported to Payment File"), true);
                LogTestField(GenJnlLine, FieldNo("Check Transmitted"), true);
            end;
    end;

    [EventSubscriber(ObjectType::Codeunit, 12, 'OnBeforePostGenJnlLine', '', false, false)]
    local procedure C12_OnBeforePostGenJnlLine(var GenJournalLine: Record "Gen. Journal Line"; Balancing: Boolean)
    var
        GLSetup: Record "General Ledger Setup";
        SSASetup: Record "SSA Localization Setup";
    begin
        //SSA1196>>
        SSASetup.Get;
        SSASetup.TestField("Leasing Journal Template");
        SSASetup.TestField("Advance Journal Template");
        with GenJournalLine do begin
            "SSA Leasing" := false;
            if ("Journal Template Name" = SSASetup."Leasing Journal Template") or
               ("Journal Template Name" = SSASetup."Advance Journal Template")
            then
                "SSA Leasing" := true;
        end;
        //SSA1196<<
    end;

    [EventSubscriber(ObjectType::Codeunit, 12, 'OnPostVendOnAfterCopyCVLedgEntryBuf', '', false, false)]
    local procedure C12_OnPostVendOnAfterCopyCVLedgEntryBuf(var CVLedgerEntryBuffer: Record "CV Ledger Entry Buffer"; GenJournalLine: Record "Gen. Journal Line")
    var
        GLSetup: Record "General Ledger Setup";
    begin
        //SSA1196>>
        GLSetup.Get;
        with GenJournalLine do
            if GLSetup."Pmt. Disc. Excl. VAT" then begin
                if "SSA Leasing" then
                    CVLedgerEntryBuffer."Original Pmt. Disc. Possible" := "Sales/Purch. (LCY)" * (Amount - "VAT Amount") / ("Amount (LCY)" - "VAT Amount (LCY)")
                else
                    CVLedgerEntryBuffer."Original Pmt. Disc. Possible" := "Sales/Purch. (LCY)" * Amount / "Amount (LCY)";
            end else begin
                if GenJournalLine."SSA Leasing" then
                    CVLedgerEntryBuffer."Original Pmt. Disc. Possible" := Amount - "VAT Amount"
                else
                    CVLedgerEntryBuffer."Original Pmt. Disc. Possible" := Amount;
            end;
        //SSA1196<<
    end;

    [EventSubscriber(ObjectType::Codeunit, 12, 'OnCreateGLEntryForTotalAmountsOnBeforeInsertGLEntry', '', false, false)]
    local procedure OnCreateGLEntryForTotalAmountsOnBeforeInsertGLEntry(var GenJnlLine: Record "Gen. Journal Line"; var GLEntry: Record "G/L Entry"; var IsHandled: Boolean)
    var
        GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line";
        VATPostingSetup: Record "VAT Posting Setup";
    begin

        IF GenJnlLine."SSA Leasing" THEN BEGIN
            GenJnlPostLine.InitVAT(GenJnlLine, GLEntry, VATPostingSetup);
            GenJnlPostLine.InsertGLEntry(GenJnlLine, GLEntry, TRUE);
            GenJnlPostLine.PostVAT(GenJnlLine, GLEntry, VATPostingSetup);
        END ELSE
            GenJnlPostLine.InsertGLEntry(GenJnlLine, GLEntry, TRUE);
    end;

    [EventSubscriber(ObjectType::Table, 383, 'OnAfterCopyFromGenJnlLine', '', false, false)]
    local procedure T383_OnPostCustOnAfterCopyCVLedgEntryBuf(var DtldCVLedgEntryBuffer: Record "Detailed CV Ledg. Entry Buffer"; GenJnlLine: Record "Gen. Journal Line")
    begin
        //SSA1196>>
        with GenJnlLine do begin
            if "SSA Leasing" then begin
                DtldCVLedgEntryBuffer.Amount := Amount - "VAT Amount";
                DtldCVLedgEntryBuffer."Amount (LCY)" := "Amount (LCY)" - "VAT Amount (LCY)";
                DtldCVLedgEntryBuffer."Additional-Currency Amount" := Amount - "VAT Amount";
            end else begin
                DtldCVLedgEntryBuffer.Amount := Amount;
                DtldCVLedgEntryBuffer."Amount (LCY)" := "Amount (LCY)";
                DtldCVLedgEntryBuffer."Additional-Currency Amount" := Amount;
            end;
        end;
        //SSA1196<<
    end;
}