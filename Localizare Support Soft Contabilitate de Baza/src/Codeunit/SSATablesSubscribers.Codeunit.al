codeunit 70025 "SSA Tables Subscribers"
{
    [EventSubscriber(ObjectType::Table, 18, 'OnAfterValidateEvent', 'Country/Region Code', false, false)]
    local procedure T18OnAfterValidateEventCountry(var Rec: Record Customer; var xRec: Record Customer; CurrFieldNo: Integer)
    var
        SSASetup: Record "SSA Localization Setup";
        CountryRegion: Record "Country/Region";
    begin
        //SSA971>>
        SSASetup.Get();
        if CountryRegion.Get(Rec."Country/Region Code") then begin
            if SSASetup."Sistem TVA" = SSASetup."Sistem TVA"::"Sistem Normal de TVA" then
                Rec.Validate("VAT Bus. Posting Group", CountryRegion."SSA Cust. Ex. VATPstgGroup")
            else
                Rec.Validate("VAT Bus. Posting Group", CountryRegion."SSA Cust. Neex. VATPstgGroup");

            Rec.Validate("Gen. Bus. Posting Group", CountryRegion."SSA Cust. GenBusPostingGroup");
            Rec.Validate("Customer Posting Group", CountryRegion."SSA Customer Posting Group");
        end
        else

            if SSASetup."Sistem TVA" = SSASetup."Sistem TVA"::"Sistem Normal de TVA" then
                Rec.Validate("VAT Bus. Posting Group", SSASetup."Cust. Ex. VAT Posting Group")
            else
                Rec.Validate("VAT Bus. Posting Group", SSASetup."Cust. Neex. VAT Posting Group");
        //SSA971<<
    end;

    [EventSubscriber(ObjectType::Table, Database::"Cust. Ledger Entry", 'OnAfterCopyCustLedgerEntryFromGenJnlLine', '', true, false)]
    local procedure T21OnAfterCopyCustLedgerEntryFromGenJnlLine(var CustLedgerEntry: Record "Cust. Ledger Entry"; GenJournalLine: Record "Gen. Journal Line")
    begin
        CustLedgerEntry."SSA Stare Factura" := GenJournalLine."SSA Stare Factura";
    end;

    [EventSubscriber(ObjectType::Table, 23, 'OnAfterValidateEvent', 'Country/Region Code', false, false)]
    local procedure T23OnAfterValidateEventCountry(var Rec: Record Vendor; var xRec: Record Vendor; CurrFieldNo: Integer)
    var
        SSASetup: Record "SSA Localization Setup";
        CountryRegion: Record "Country/Region";
    begin
        //SSA971>>
        SSASetup.Get();
        if CountryRegion.Get(Rec."Country/Region Code") then begin
            if SSASetup."Sistem TVA" = SSASetup."Sistem TVA"::"Sistem Normal de TVA" then
                Rec.Validate("VAT Bus. Posting Group", CountryRegion."SSA Vendor Ex. VATPstgGroup")
            else
                Rec.Validate("VAT Bus. Posting Group", CountryRegion."SSA Vendor Neex. VATPstgGroup");

            Rec.Validate("Gen. Bus. Posting Group", CountryRegion."SSA Vendor GenBusPstgGroup");
            Rec.Validate("Vendor Posting Group", CountryRegion."SSA Vendor Posting Group");
        end
        else

            if SSASetup."Sistem TVA" = SSASetup."Sistem TVA"::"Sistem Normal de TVA" then
                Rec.Validate("VAT Bus. Posting Group", SSASetup."Vendor Ex. VAT Posting Group")
            else
                Rec.Validate("VAT Bus. Posting Group", SSASetup."Vendor Neex. VAT Posting Group");
        //SSA971<<
    end;

    [EventSubscriber(ObjectType::Table, Database::"Vendor Ledger Entry", 'OnAfterCopyVendLedgerEntryFromGenJnlLine', '', true, false)]
    local procedure T25OnAfterCopyVendLedgerEntryFromGenJnlLine(var VendorLedgerEntry: Record "Vendor Ledger Entry"; GenJournalLine: Record "Gen. Journal Line")
    begin
        VendorLedgerEntry."SSA Stare Factura" := GenJournalLine."SSA Stare Factura";
    end;

    [EventSubscriber(ObjectType::Table, 27, 'OnAfterValidateEvent', 'Inventory Posting Group', false, false)]
    local procedure T27OnAfterValidateEventInventoryPostingGroup(var Rec: Record Item; var xRec: Record Item; CurrFieldNo: Integer)
    var
        CannotChangeFieldErr: Label 'You cannot change the %1 field on %2 %3 because at least one %4 exists for this item.', Comment = '%1 = Field Caption, %2 = Item Table Name, %3 = Item No., %4 = Table Name';

    begin
        //SSA962>>
        if Rec.ExistsItemLedgerEntry() then
            Error(CannotChangeFieldErr, Rec.FieldCaption("Inventory Posting Group"), Rec.TableCaption, Rec."No.");
        //SSA962<<
    end;

    [EventSubscriber(ObjectType::Table, 27, 'OnAfterValidateEvent', 'Gen. Prod. Posting Group', false, false)]
    local procedure T27OnAfterValidateEventGenProdPostingGroup(var Rec: Record Item; var xRec: Record Item; CurrFieldNo: Integer)
    var
        CannotChangeFieldErr: Label 'You cannot change the %1 field on %2 %3 because at least one %4 exists for this item.', Comment = '%1 = Field Caption, %2 = Item Table Name, %3 = Item No., %4 = Table Name';

    begin
        //SSA962>>
        if Rec.ExistsItemLedgerEntry() then
            Error(CannotChangeFieldErr, Rec.FieldCaption("Gen. Prod. Posting Group"), Rec.TableCaption, Rec."No.");
        //SSA962<<
    end;

    [EventSubscriber(ObjectType::Table, 27, 'OnAfterValidateEvent', 'Item Category Code', false, false)]
    local procedure T27OnAfterValidateEventItemCategoryCode(var Rec: Record Item; var xRec: Record Item; CurrFieldNo: Integer)
    var
        ItemCategory: Record "Item Category";
    begin
        //SSA962>>
        if not ItemCategory.Get(Rec."Item Category Code") then
            exit;

        Rec.Validate("Costing Method", ItemCategory."SSA Costing Method");

        if ItemCategory."SSA Inventory Posting Group" <> '' then
            Rec.Validate("Inventory Posting Group", ItemCategory."SSA Inventory Posting Group");

        if ItemCategory."SSA Gen. Prod. Posting Group" <> '' then
            Rec.Validate("Gen. Prod. Posting Group", ItemCategory."SSA Gen. Prod. Posting Group");

        if ItemCategory."SSA VAT Prod. Posting Group" <> '' then
            Rec.Validate("VAT Prod. Posting Group", ItemCategory."SSA VAT Prod. Posting Group");
        //SSA962<<
    end;

    [EventSubscriber(ObjectType::Table, 36, 'OnAfterCopySellToCustomerAddressFieldsFromCustomer', '', false, false)]
    local procedure OnAfterCopySellToCustomerAddressFieldsFromCustomer(var SalesHeader: Record "Sales Header"; SellToCustomer: Record Customer; CurrentFieldNo: Integer)
    begin
        //SSA968>>
        SalesHeader.Validate("SSA Commerce Trade No.", SellToCustomer."SSA Commerce Trade No.");
        //SSA968<<
    end;

    [EventSubscriber(ObjectType::Table, 36, 'OnCheckSalesPostRestrictions', '', false, false)]
    local procedure OnCheckSalesPostRestrictions(var Sender: Record "Sales Header")
    var
        ShippingAgent: Record "Shipping Agent";
    begin
        //SSA968>>
        if ShippingAgent.Get(Sender."Shipping Agent Code") and ShippingAgent."SSA Delivery Info Mandatory" then
            Sender.TestField("SSA Delivery Contact No.");
        //SSA968<<
    end;

    [EventSubscriber(ObjectType::Table, 38, 'OnUpdatePurchLinesByChangedFieldName', '', false, false)]
    local procedure OnUpdatePurchLinesByChangedFieldName(PurchHeader: Record "Purchase Header"; var PurchLine: Record "Purchase Line"; ChangedFieldName: Text[100])
    begin
        //SSA947>>
        if ChangedFieldName = PurchLine.FieldCaption("VAT Bus. Posting Group") then
            if PurchLine."No." <> '' then
                PurchLine.Validate("VAT Bus. Posting Group", PurchHeader."VAT Bus. Posting Group")
        //SSA947<<
    end;

    [EventSubscriber(ObjectType::Table, 38, 'OnValidatePurchaseHeaderPayToVendorNo', '', false, false)]
    local procedure OnValidatePurchaseHeaderPayToVendorNo(var Sender: Record "Purchase Header"; Vendor: Record Vendor)
    begin
        //SSA947>>
        Sender.Validate("SSA VAT to Pay", Vendor."SSA VAT to Pay");
        //SSA947<<

        //SSA968>>
        Sender.Validate("SSA Commerce Trade No.", Vendor."SSA Commerce Trade No.");
        //SSA968<<
    end;

    [EventSubscriber(ObjectType::Table, 39, 'OnAfterAssignGLAccountValues', '', false, false)]
    local procedure OnAfterAssignGLAccountValues(var PurchLine: Record "Purchase Line"; GLAccount: Record "G/L Account")
    begin
        //SSA948>>
        PurchLine."SSA Distribute Non-Ded VAT" := GLAccount."SSA Distribute Non-Ded VAT";
        PurchLine."SSA Non-Ded VAT Expense Acc 1" := GLAccount."SSA Non-Ded VAT Expense Acc 1";
        PurchLine."SSA Non-Ded VAT Expense Acc 2" := GLAccount."SSA Non-Ded VAT Expense Acc 2";
        //SSA948<<
    end;

    [EventSubscriber(ObjectType::Table, 49, 'OnAfterInvPostBufferPreparePurchase', '', false, false)]
    local procedure T49OnAfterInvPostBufferPreparePurchase(var PurchaseLine: Record "Purchase Line"; var InvoicePostBuffer: Record "Invoice Post. Buffer")
    begin
        //SSA948>>
        InvoicePostBuffer."SSA Distribute Non-Ded VAT" := PurchaseLine."SSA Distribute Non-Ded VAT";
        InvoicePostBuffer."SSA Non-Ded VAT Expense Acc 1" := PurchaseLine."SSA Non-Ded VAT Expense Acc 1";
        InvoicePostBuffer."SSA Non-Ded VAT Expense Acc 2" := PurchaseLine."SSA Non-Ded VAT Expense Acc 2";
        //SSA948<<
    end;

    [EventSubscriber(ObjectType::Table, 81, 'OnAfterAccountNoOnValidateGetGLAccount', '', false, false)]
    local procedure T81_OnAfterAccountNoOnValidateGetGLAccount(var GenJournalLine: Record "Gen. Journal Line"; var GLAccount: Record "G/L Account")
    begin
        //SSA948>>
        GenJournalLine."SSA Distribute Non-Ded VAT" := GLAccount."SSA Distribute Non-Ded VAT";
        GenJournalLine."SSA Non-Ded VAT Expense Acc 1" := GLAccount."SSA Non-Ded VAT Expense Acc 1";
        GenJournalLine."SSA Non-Ded VAT Expense Acc 2" := GLAccount."SSA Non-Ded VAT Expense Acc 2";
        //SSA948<<
    end;

    [EventSubscriber(ObjectType::Report, Report::"Calc. and Post VAT Settlement", 'OnBeforePreReport', '', false, false)]
    local procedure R20OnBeforePreReport(var VATPostingSetup: Record "VAT Posting Setup")
    var
        Text001: Label 'Filter cannot be applied because filter applied for Non-Deductible VAT is applied automatically.';
    begin
        //SSA948>>
        if VATPostingSetup.GetFilter("VAT Prod. Posting Group") <> '' then
            Error(Text001);

        VATPostingSetup.SetRange("SSA Non-Deductible VAT Prod.", false);
        //SSA948<<
    end;

    [EventSubscriber(ObjectType::Table, Database::"Gen. Journal Line", 'OnBeforeValidateGenPostingType', '', true, false)]
    local procedure SetLeasingOnBeforeValidateGenPostingType(var GenJournalLine: Record "Gen. Journal Line"; var CheckIfFieldIsEmpty: Boolean)
    begin

        if GenJournalLine."SSA Leasing" then
            CheckIfFieldIsEmpty := false;

        if GenJournalLine."Gen. Posting Type" = GenJournalLine."Gen. Posting Type"::Purchase then
            GenJournalLine."SSA Stare Factura" := GenJournalLine."SSA Stare Factura"::"0-Factura Emisa";
    end;

    [EventSubscriber(ObjectType::Table, Database::"Gen. Journal Line", 'OnBeforeValidateGenBusPostingGroup', '', true, false)]
    local procedure SetLeasingOnBeforeValidateGenBusPostingGroup(var GenJournalLine: Record "Gen. Journal Line"; var CheckIfFieldIsEmpty: Boolean)
    begin
        if GenJournalLine."SSA Leasing" then
            CheckIfFieldIsEmpty := false;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Gen. Journal Line", 'OnBeforeValidateGenProdPostingGroup', '', true, false)]
    local procedure SetLeasingOnBeforeValidateGenProdPostingGroup(var GenJournalLine: Record "Gen. Journal Line"; var CheckIfFieldIsEmpty: Boolean)
    begin
        if GenJournalLine."SSA Leasing" then
            CheckIfFieldIsEmpty := false;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Gen. Journal Line", 'OnAfterCopyGenJnlLineFromPurchHeader', '', false, false)]
    local procedure OnAfterCopyGenJnlLineFromPurchHeader(PurchaseHeader: Record "Purchase Header"; var GenJournalLine: Record "Gen. Journal Line")
    begin

        //SSA946>>
        GenJournalLine."SSA Custom Invoice No." := PurchaseHeader."SSA Custom Invoice No.";
        //SSA946<<
    end;

    [EventSubscriber(ObjectType::Table, Database::"Gen. Journal Line", 'OnAfterCopyGenJnlLineFromServHeader', '', false, false)]
    local procedure OnAfterCopyGenJnlLineFromServHeader(ServiceHeader: Record "Service Header"; var GenJournalLine: Record "Gen. Journal Line")
    begin
        //SSA969>>
        GenJournalLine."Posting Group" := ServiceHeader."Customer Posting Group";
        //SSA969<<
    end;

    [EventSubscriber(ObjectType::Table, Database::"Gen. Journal Line", 'OnAfterCopyGenJnlLineFromInvPostBuffer', '', true, false)]
    local procedure OnAfterCopyGenJnlLineFromInvPostBuffer(var GenJournalLine: Record "Gen. Journal Line"; InvoicePostBuffer: Record "Invoice Post. Buffer")
    var
        SSASetup: Record "SSA Localization Setup";
        SourceCodeSetup: Record "Source Code Setup";
    begin
        //SSA951>>
        SourceCodeSetup.Get();
        SSASetup.Get();
        if ((GenJournalLine."Source Code" = SourceCodeSetup.Sales) and SSASetup."Sales Negative Line Correction") then begin
            if (GenJournalLine.Amount > 0) and (GenJournalLine."Document Type" = GenJournalLine."Document Type"::Invoice) then
                GenJournalLine.Correction := not GenJournalLine.Correction;
            if (GenJournalLine.Amount < 0) and (GenJournalLine."Document Type" = GenJournalLine."Document Type"::"Credit Memo") then
                GenJournalLine.Correction := not GenJournalLine.Correction;
        end;
        if ((GenJournalLine."Source Code" = SourceCodeSetup.Purchases) and SSASetup."Purch Negative Line Correction") then begin
            if (GenJournalLine.Amount < 0) and (GenJournalLine."Document Type" = GenJournalLine."Document Type"::Invoice) then
                GenJournalLine.Correction := not GenJournalLine.Correction;
            if (GenJournalLine.Amount > 0) and (GenJournalLine."Document Type" = GenJournalLine."Document Type"::"Credit Memo") then
                GenJournalLine.Correction := not GenJournalLine.Correction;
        end;
        //SSA951<<
    end;

    [EventSubscriber(ObjectType::Table, Database::"Gen. Journal Line", 'OnAfterValidateEvent', 'Depreciation Book Code', true, false)]
    local procedure OnAfterValidateEvent_DepreciationBookCode(var Rec: Record "Gen. Journal Line")
    begin
        Rec."SSA Posting Group" := Rec."Posting Group";
    end;

    [EventSubscriber(ObjectType::Table, Database::"Gen. Journal Line", 'OnAfterAccountNoOnValidateGetFAAccount', '', true, false)]
    local procedure OnAfterValidateEvent_OnAfterAccountNoOnValidateGetFAAccount(var GenJournalLine: Record "Gen. Journal Line")
    begin
        GenJournalLine."SSA Posting Group" := GenJournalLine."Posting Group";
    end;

    [EventSubscriber(ObjectType::Table, Database::"Gen. Journal Line", 'OnAfterCopyGenJnlLineFromCustLedgEntry', '', true, false)]
    local procedure OnAfterValidateEvent_OnAfterCopyGenJnlLineFromCustLedgEntry(var GenJournalLine: Record "Gen. Journal Line")
    begin
        GenJournalLine."SSA Posting Group" := GenJournalLine."Posting Group";
    end;

    [EventSubscriber(ObjectType::Table, Database::"Gen. Journal Line", 'OnAfterCopyGenJnlLineFromPurchHeader', '', true, false)]
    local procedure OnAfterValidateEvent_OnAfterCopyGenJnlLineFromPurchHeader(var GenJournalLine: Record "Gen. Journal Line")
    begin
        GenJournalLine."SSA Posting Group" := GenJournalLine."Posting Group";
    end;

    [EventSubscriber(ObjectType::Table, Database::"Gen. Journal Line", 'OnAfterCopyGenJnlLineFromSalesHeader', '', true, false)]
    local procedure OnAfterValidateEvent_OnAfterCopyGenJnlLineFromSalesHeader(var GenJournalLine: Record "Gen. Journal Line")
    begin
        GenJournalLine."SSA Posting Group" := GenJournalLine."Posting Group";
    end;

    [EventSubscriber(ObjectType::Table, Database::"Gen. Journal Line", 'OnAfterAccountNoOnValidateGetGLAccount', '', true, false)]
    local procedure OnAfterValidateEvent_OnAfterAccountNoOnValidateGetGLAccount(var GenJournalLine: Record "Gen. Journal Line")
    begin
        GenJournalLine."SSA Posting Group" := GenJournalLine."Posting Group";
    end;

    [EventSubscriber(ObjectType::Table, Database::"Gen. Journal Line", 'OnAfterAccountNoOnValidateGetGLBalAccount', '', true, false)]
    local procedure OnAfterValidateEvent_OnAfterAccountNoOnValidateGetGLBalAccount(var GenJournalLine: Record "Gen. Journal Line")
    begin
        GenJournalLine."SSA Posting Group" := GenJournalLine."Posting Group";
    end;

    [EventSubscriber(ObjectType::Table, Database::"Gen. Journal Line", 'OnAfterAccountNoOnValidateGetCustomerAccount', '', true, false)]
    local procedure OnAfterValidateEvent_OnAfterAccountNoOnValidateGetCustomerAccount(var GenJournalLine: Record "Gen. Journal Line")
    begin
        GenJournalLine."SSA Posting Group" := GenJournalLine."Posting Group";
    end;

    [EventSubscriber(ObjectType::Table, Database::"Gen. Journal Line", 'OnAfterAccountNoOnValidateGetCustomerBalAccount', '', true, false)]
    local procedure OnAfterValidateEvent_OnAfterAccountNoOnValidateGetCustomerBalAccount(var GenJournalLine: Record "Gen. Journal Line")
    begin
        GenJournalLine."SSA Posting Group" := GenJournalLine."Posting Group";
    end;

    [EventSubscriber(ObjectType::Table, Database::"Gen. Journal Line", 'OnAfterAccountNoOnValidateGetVendorAccount', '', true, false)]
    local procedure OnAfterValidateEvent_OnAfterAccountNoOnValidateGetVendorAccount(var GenJournalLine: Record "Gen. Journal Line")
    begin
        GenJournalLine."SSA Posting Group" := GenJournalLine."Posting Group";
    end;

    [EventSubscriber(ObjectType::Table, Database::"Gen. Journal Line", 'OnAfterAccountNoOnValidateGetVendorBalAccount', '', true, false)]
    local procedure OnAfterValidateEvent_OnAfterAccountNoOnValidateGetVendorBalAccount(var GenJournalLine: Record "Gen. Journal Line")
    begin
        GenJournalLine."SSA Posting Group" := GenJournalLine."Posting Group";
    end;

    [EventSubscriber(ObjectType::Table, Database::"Gen. Journal Line", 'OnAfterAccountNoOnValidateGetEmployeeAccount', '', true, false)]
    local procedure OnAfterValidateEvent_OnAfterAccountNoOnValidateGetEmployeeAccount(var GenJournalLine: Record "Gen. Journal Line")
    begin
        GenJournalLine."SSA Posting Group" := GenJournalLine."Posting Group";
    end;

    [EventSubscriber(ObjectType::Table, Database::"Gen. Journal Line", 'OnAfterAccountNoOnValidateGetEmployeeBalAccount', '', true, false)]
    local procedure OnAfterValidateEvent_OnAfterAccountNoOnValidateGetEmployeeBalAccount(var GenJournalLine: Record "Gen. Journal Line")
    begin
        GenJournalLine."SSA Posting Group" := GenJournalLine."Posting Group";
    end;

    [EventSubscriber(ObjectType::Table, Database::"Gen. Journal Line", 'OnAfterAccountNoOnValidateGetBankAccount', '', true, false)]
    local procedure OnAfterValidateEvent_OnAfterAccountNoOnValidateGetBankAccount(var GenJournalLine: Record "Gen. Journal Line")
    begin
        GenJournalLine."SSA Posting Group" := GenJournalLine."Posting Group";
    end;

    [EventSubscriber(ObjectType::Table, Database::"Gen. Journal Line", 'OnAfterAccountNoOnValidateGetBankBalAccount', '', true, false)]
    local procedure OnAfterValidateEvent_OnAfterAccountNoOnValidateGetBankBalAccount(var GenJournalLine: Record "Gen. Journal Line")
    begin
        GenJournalLine."SSA Posting Group" := GenJournalLine."Posting Group";
    end;

    [EventSubscriber(ObjectType::Table, 83, 'OnAfterCopyItemJnlLineFromSalesHeader', '', false, false)]
    local procedure OnAfterCopyItemJnlLineFromSalesHeader(var ItemJnlLine: Record "Item Journal Line"; SalesHeader: Record "Sales Header")
    begin
        //SSA935>>
        ItemJnlLine."SSA Correction Cost" := SalesHeader.Correction;
        ItemJnlLine."SSA Correction Cost Inv. Val." := SalesHeader.Correction;
        //SSA935<
    end;

    [EventSubscriber(ObjectType::Table, 83, 'OnAfterCopyItemJnlLineFromPurchHeader', '', false, false)]
    local procedure OnAfterCopyItemJnlLineFromPurchHeader(var ItemJnlLine: Record "Item Journal Line"; PurchHeader: Record "Purchase Header")
    begin
        //SSA935>>
        ItemJnlLine."SSA Correction Cost" := PurchHeader.Correction;
        ItemJnlLine."SSA Correction Cost Inv. Val." := PurchHeader.Correction;
        //SSA935<<

        //SSA946>>
        ItemJnlLine."SSA Custom Invoice No." := PurchHeader."SSA Custom Invoice No.";
        //SSA946<<
    end;

    [EventSubscriber(ObjectType::Table, Database::"Deferral Posting Buffer", 'OnAfterPreparePurch', '', true, false)]
    local procedure T1706_OnAfterPreparePurch(var DeferralPostingBuffer: Record "Deferral Posting Buffer"; PurchaseLine: Record "Purchase Line")
    var
        PurchaseHeader: Record "Purchase Header";
    begin
        PurchaseHeader.Get(PurchaseLine."Document Type", PurchaseLine."Document No.");
        DeferralPostingBuffer."SSA Correction" := not PurchaseHeader.Correction;
    end;
}
