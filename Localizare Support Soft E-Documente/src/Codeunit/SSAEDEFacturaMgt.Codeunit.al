codeunit 72003 "SSAEDEFactura Mgt."
{

    trigger OnRun()
    begin
    end;

    var
        SalespersonTxt: Label 'Salesperson';
        InvoiceDisAmtTxt: Label 'Invoice Discount Amount';
        LineDisAmtTxt: Label 'Line Discount Amount';
        GLNTxt: Label 'GLN', locked = true;
        VATTxt: Label 'VAT', locked = true;
        MultiplyTxt: Label 'Multiply', locked = true;
        IBANPaymentSchemeIDTxt: Label 'IBAN', locked = true;
        LocalPaymentSchemeIDTxt: Label 'LOCAL', locked = true;
        BICTxt: Label 'BIC', locked = true;
        AllowanceChargeReasonCodeTxt: Label '104', locked = true;
        GTINTxt: Label '0160', locked = true;
        UoMforPieceINUNECERec20ListIDTxt: Label 'EA', Locked = true;
        NoUnitOfMeasureErr: Label 'The %1 %2 contains lines on which the %3 field is empty.', Comment = '1: document type, 2: document no 3 Unit of Measure Code';


    procedure GetGeneralInfo(SalesHeader: Record "Sales Header"; var ID: Text; var IssueDate: Text; var InvoiceTypeCode: Text; var InvoiceTypeCodeListID: Text; var Note: Text; var TaxPointDate: Text; var DocumentCurrencyCode: Text; var DocumentCurrencyCodeListID: Text; var TaxCurrencyCode: Text; var TaxCurrencyCodeListID: Text; var AccountingCost: Text; var DueDate: Text)
    var
        GLSetup: Record "General Ledger Setup";
    begin
        ID := SalesHeader."No.";

        IssueDate := Format(SalesHeader."Document Date", 0, 9);
        InvoiceTypeCode := GetInvoiceTypeCode();
        InvoiceTypeCodeListID := GetUNCL1001ListID;
        Note := '';

        GLSetup.Get;
        TaxPointDate := '';
        DocumentCurrencyCode := GetSalesDocCurrencyCode(SalesHeader);
        DocumentCurrencyCodeListID := GetISO4217ListID;
        TaxCurrencyCode := DocumentCurrencyCode;
        TaxCurrencyCodeListID := GetISO4217ListID;
        AccountingCost := '';

        DueDate := FORMAT(SalesHeader."Due Date", 0, 9);
    end;


    procedure GetInvoicePeriodInfo(var StartDate: Text; var EndDate: Text)
    begin
        StartDate := '';
        EndDate := '';
    end;


    procedure GetOrderReferenceInfo(SalesHeader: Record "Sales Header"; var OrderReferenceID: Text)
    begin
        OrderReferenceID := SalesHeader."External Document No.";
    end;


    procedure GetOrderReferenceInfoBIS(SalesHeader: Record "Sales Header"; var OrderReferenceID: Text)
    begin
        OrderReferenceID := SalesHeader."External Document No.";
        if OrderReferenceID = '' then
            OrderReferenceID := SalesHeader."No.";
    end;


    procedure GetContractDocRefInfo(SalesHeader: Record "Sales Header"; var ContractDocumentReferenceID: Text; var DocumentTypeCode: Text; var ContractRefDocTypeCodeListID: Text; var DocumentType: Text)
    begin
        ContractDocumentReferenceID := SalesHeader."No.";
        DocumentTypeCode := '';
        ContractRefDocTypeCodeListID := GetUNCL1001ListID;
        DocumentType := '';
    end;


    procedure GetAdditionalDocRefInfo(var AdditionalDocumentReferenceID: Text; var AdditionalDocRefDocumentType: Text; var URI: Text; var MimeCode: Text; var EmbeddedDocumentBinaryObject: Text)
    begin
        AdditionalDocumentReferenceID := '';
        AdditionalDocRefDocumentType := '';
        URI := '';
        MimeCode := '';
        EmbeddedDocumentBinaryObject := '';
    end;


    procedure GetAccountingSupplierPartyInfo(var SupplierEndpointID: Text; var SupplierSchemeID: Text; var SupplierName: Text)
    begin
        GetAccountingSupplierPartyInfoByFormat(SupplierEndpointID, SupplierSchemeID, SupplierName, false);
    end;


    procedure GetAccountingSupplierPartyInfoBIS(var SupplierEndpointID: Text; var SupplierSchemeID: Text; var SupplierName: Text)
    begin
        GetAccountingSupplierPartyInfoByFormat(SupplierEndpointID, SupplierSchemeID, SupplierName, true);
    end;

    local procedure GetAccountingSupplierPartyInfoByFormat(var SupplierEndpointID: Text; var SupplierSchemeID: Text; var SupplierName: Text; IsBISBilling: Boolean)
    var
        CompanyInfo: Record "Company Information";
        CountryRegion: Record "Country/Region";
    begin
        CompanyInfo.Get;
        if CompanyInfo.GLN <> '' then begin
            SupplierEndpointID := CompanyInfo.GLN;
            SupplierSchemeID := GetGLNSchemeIDByFormat(IsBISBilling);
        end else
            if CompanyInfo."VAT Registration No." <> '' then begin
                CountryRegion.Get(CompanyInfo."Country/Region Code");
                SupplierEndpointID := FormatVATRegitrationNo(CompanyInfo."VAT Registration No.", CountryRegion."ISO Code");
                SupplierSchemeID := GetVATScheme(CompanyInfo."Country/Region Code");
            end;

        SupplierName := CompanyInfo.Name;
    end;


    procedure GetAccountingSupplierPartyPostalAddr(SalesHeader: Record "Sales Header"; var StreetName: Text; var SupplierAdditionalStreetName: Text; var CityName: Text; var PostalZone: Text; var CountrySubentity: Text; var IdentificationCode: Text; var ListID: Text)
    var
        CompanyInfo: Record "Company Information";
        RespCenter: Record "Responsibility Center";
    begin
        CompanyInfo.Get;
        if RespCenter.Get(SalesHeader."Responsibility Center") then begin
            CompanyInfo.Address := RespCenter.Address;
            CompanyInfo."Address 2" := RespCenter."Address 2";
            CompanyInfo.City := RespCenter.City;
            CompanyInfo."Post Code" := RespCenter."Post Code";
            CompanyInfo.County := GetJudet(RespCenter.County);
            CompanyInfo."Country/Region Code" := RespCenter."Country/Region Code";
            CompanyInfo."Phone No." := RespCenter."Phone No.";
            CompanyInfo."Fax No." := RespCenter."Fax No.";
        end;

        StreetName := CompanyInfo.Address;
        SupplierAdditionalStreetName := CompanyInfo."Address 2";
        CityName := CompanyInfo.City;
        PostalZone := CompanyInfo."Post Code";
        CountrySubentity := GetJudet(CompanyInfo.County);
        if CountrySubentity = 'RO-B' then
            CityName := Format(CompanyInfo."SSAEDSector");
        IdentificationCode := CompanyInfo."Country/Region Code";
        ListID := GetISO3166_1Alpha2;
    end;


    procedure GetAccountingSupplierPartyTaxScheme(var CompanyID: Text; var CompanyIDSchemeID: Text; var TaxSchemeID: Text)
    var
        CompanyInfo: Record "Company Information";
    begin
        CompanyInfo.Get;
        if CompanyInfo."VAT Registration No." <> '' then begin
            CompanyID := CompanyInfo."VAT Registration No.";
            CompanyIDSchemeID := GetVATScheme(CompanyInfo."Country/Region Code");
            TaxSchemeID := VATTxt;
        end;
    end;


    procedure GetAccountingSupplierPartyTaxSchemeBIS(var VATAmtLine: Record "VAT Amount Line"; var CompanyID: Text; var CompanyIDSchemeID: Text; var TaxSchemeID: Text)
    begin
        VATAmtLine.SetFilter("VAT Identifier", '<>%1', GetTaxCategoryO);
        if not VATAmtLine.IsEmpty then
            GetAccountingSupplierPartyTaxScheme(CompanyID, CompanyIDSchemeID, TaxSchemeID);
        VATAmtLine.SetRange("VAT Identifier");
        CompanyID := DelChr(CompanyID);
        CompanyIDSchemeID := '';
    end;


    procedure GetAccountingSupplierPartyLegalEntity(var PartyLegalEntityRegName: Text; var PartyLegalEntityCompanyID: Text; var PartyLegalEntitySchemeID: Text; var SupplierRegAddrCityName: Text; var SupplierRegAddrCountryIdCode: Text; var SupplRegAddrCountryIdListId: Text)
    begin
        GetAccountingSupplierPartyLegalEntityByFormat(
          PartyLegalEntityRegName, PartyLegalEntityCompanyID, PartyLegalEntitySchemeID,
          SupplierRegAddrCityName, SupplierRegAddrCountryIdCode, SupplRegAddrCountryIdListId, false);
    end;


    procedure GetAccountingSupplierPartyLegalEntityBIS(var PartyLegalEntityRegName: Text; var PartyLegalEntityCompanyID: Text; var PartyLegalEntitySchemeID: Text; var SupplierRegAddrCityName: Text; var SupplierRegAddrCountryIdCode: Text; var SupplRegAddrCountryIdListId: Text)
    begin
        GetAccountingSupplierPartyLegalEntityByFormat(
          PartyLegalEntityRegName, PartyLegalEntityCompanyID, PartyLegalEntitySchemeID,
          SupplierRegAddrCityName, SupplierRegAddrCountryIdCode, SupplRegAddrCountryIdListId, true);
    end;

    local procedure GetAccountingSupplierPartyLegalEntityByFormat(var PartyLegalEntityRegName: Text; var PartyLegalEntityCompanyID: Text; var PartyLegalEntitySchemeID: Text; var SupplierRegAddrCityName: Text; var SupplierRegAddrCountryIdCode: Text; var SupplRegAddrCountryIdListId: Text; IsBISBilling: Boolean)
    var
        CompanyInfo: Record "Company Information";
    begin
        CompanyInfo.Get;

        PartyLegalEntityRegName := CompanyInfo.Name;
        PartyLegalEntityCompanyID := CompanyInfo."SSA Commerce Trade No.";

        SupplierRegAddrCityName := CompanyInfo.City;
        SupplierRegAddrCountryIdCode := CompanyInfo."Country/Region Code";
        SupplRegAddrCountryIdListId := GetISO3166_1Alpha2;
    end;


    procedure GetAccountingSupplierPartyContact(SalesHeader: Record "Sales Header"; var ContactID: Text; var ContactName: Text; var Telephone: Text; var Telefax: Text; var ElectronicMail: Text)
    var
        CompanyInfo: Record "Company Information";
        Salesperson: Record "Salesperson/Purchaser";
    begin
        CompanyInfo.Get;
        GetSalesperson(SalesHeader, Salesperson);
        ContactID := SalespersonTxt;
        ContactName := Salesperson.Name;
        Telephone := Salesperson."Phone No.";
        Telefax := CompanyInfo."Telex No.";
        ElectronicMail := Salesperson."E-Mail";
    end;


    procedure GetAccountingCustomerPartyInfo(SalesHeader: Record "Sales Header"; var CustomerEndpointID: Text; var CustomerSchemeID: Text; var CustomerPartyIdentificationID: Text; var CustomerPartyIDSchemeID: Text; var CustomerName: Text)
    begin
        GetAccountingCustomerPartyInfoByFormat(
          SalesHeader, CustomerEndpointID, CustomerSchemeID,
          CustomerPartyIdentificationID, CustomerPartyIDSchemeID, CustomerName, false);
    end;


    procedure GetAccountingCustomerPartyInfoBIS(SalesHeader: Record "Sales Header"; var CustomerEndpointID: Text; var CustomerSchemeID: Text; var CustomerPartyIdentificationID: Text; var CustomerPartyIDSchemeID: Text; var CustomerName: Text)
    begin
        GetAccountingCustomerPartyInfoByFormat(
          SalesHeader, CustomerEndpointID, CustomerSchemeID,
          CustomerPartyIdentificationID, CustomerPartyIDSchemeID, CustomerName, true);
    end;

    local procedure GetAccountingCustomerPartyInfoByFormat(SalesHeader: Record "Sales Header"; var CustomerEndpointID: Text; var CustomerSchemeID: Text; var CustomerPartyIdentificationID: Text; var CustomerPartyIDSchemeID: Text; var CustomerName: Text; IsBISBilling: Boolean)
    var
        Cust: Record Customer;
        CountryRegion: Record "Country/Region";
    begin
        Cust.Get(SalesHeader."Bill-to Customer No.");
        if Cust.GLN <> '' then begin
            CustomerEndpointID := Cust.GLN;
            CustomerSchemeID := GetGLNSchemeIDByFormat(IsBISBilling);
        end else
            if SalesHeader."VAT Registration No." <> '' then begin
                CountryRegion.Get(SalesHeader."Bill-to Country/Region Code");
                CustomerEndpointID := FormatVATRegitrationNo(SalesHeader."VAT Registration No.", CountryRegion."ISO Code");
                CustomerSchemeID := GetVATScheme(SalesHeader."Bill-to Country/Region Code");
            end;

        CustomerPartyIdentificationID := Cust.GLN;
        CustomerPartyIDSchemeID := GetGLNSchemeIDByFormat(IsBISBilling);
        CustomerName := SalesHeader."Bill-to Name";
    end;


    procedure GetAccountingCustomerPartyPostalAddr(SalesHeader: Record "Sales Header"; var CustomerStreetName: Text; var CustomerAdditionalStreetName: Text; var CustomerCityName: Text; var CustomerPostalZone: Text; var CustomerCountrySubentity: Text; var CustomerIdentificationCode: Text; var CustomerListID: Text)
    var
        Customer: Record Customer;
    begin
        Customer.Get(SalesHeader."Bill-to Customer No.");
        CustomerStreetName := SalesHeader."Bill-to Address";
        CustomerAdditionalStreetName := SalesHeader."Bill-to Address 2";
        CustomerCityName := SalesHeader."Bill-to City";
        CustomerPostalZone := SalesHeader."Bill-to Post Code";
        CustomerCountrySubentity := GetJudet(SalesHeader."Bill-to County");
        if CustomerCountrySubentity = 'RO-B' then
            CustomerCityName := Format(Customer."SSAEDSector Bucuresti");
        CustomerIdentificationCode := SalesHeader."Bill-to Country/Region Code";
        CustomerListID := GetISO3166_1Alpha2;
    end;


    procedure GetAccountingCustomerPartyTaxScheme(SalesHeader: Record "Sales Header"; var CustPartyTaxSchemeCompanyID: Text; var CustPartyTaxSchemeCompIDSchID: Text; var CustTaxSchemeID: Text)
    begin
        GetAccountingCustomerPartyTaxSchemeByFormat(
          SalesHeader, CustPartyTaxSchemeCompanyID, CustPartyTaxSchemeCompIDSchID, CustTaxSchemeID, false);
    end;


    procedure GetAccountingCustomerPartyTaxSchemeBIS(SalesHeader: Record "Sales Header"; var CustPartyTaxSchemeCompanyID: Text; var CustPartyTaxSchemeCompIDSchID: Text; var CustTaxSchemeID: Text)
    begin
        GetAccountingCustomerPartyTaxSchemeByFormat(
          SalesHeader, CustPartyTaxSchemeCompanyID, CustPartyTaxSchemeCompIDSchID, CustTaxSchemeID, true);
    end;

    local procedure GetAccountingCustomerPartyTaxSchemeByFormat(SalesHeader: Record "Sales Header"; var CustPartyTaxSchemeCompanyID: Text; var CustPartyTaxSchemeCompIDSchID: Text; var CustTaxSchemeID: Text; IsBISBilling: Boolean)
    var
        CountryRegion: Record "Country/Region";
    begin
        if SalesHeader."VAT Registration No." <> '' then begin
            CountryRegion.Get(SalesHeader."Bill-to Country/Region Code");
            CustPartyTaxSchemeCompanyID := FormatVATRegitrationNo(SalesHeader."VAT Registration No.", CountryRegion."ISO Code");
            CustPartyTaxSchemeCompIDSchID := GetVATSchemeByFormat(SalesHeader."Bill-to Country/Region Code", IsBISBilling);
            CustTaxSchemeID := VATTxt;
        end;
    end;


    procedure GetAccountingCustomerPartyLegalEntity(SalesHeader: Record "Sales Header"; var CustPartyLegalEntityRegName: Text; var CustPartyLegalEntityCompanyID: Text; var CustPartyLegalEntityIDSchemeID: Text)
    begin
        GetAccountingCustomerPartyLegalEntityByFormat(
          SalesHeader, CustPartyLegalEntityRegName, CustPartyLegalEntityCompanyID, CustPartyLegalEntityIDSchemeID, false);
    end;


    procedure GetAccountingCustomerPartyLegalEntityBIS(SalesHeader: Record "Sales Header"; var CustPartyLegalEntityRegName: Text; var CustPartyLegalEntityCompanyID: Text; var CustPartyLegalEntityIDSchemeID: Text)
    begin
        GetAccountingCustomerPartyLegalEntityByFormat(
          SalesHeader, CustPartyLegalEntityRegName, CustPartyLegalEntityCompanyID, CustPartyLegalEntityIDSchemeID, true);
    end;

    local procedure GetAccountingCustomerPartyLegalEntityByFormat(SalesHeader: Record "Sales Header"; var CustPartyLegalEntityRegName: Text; var CustPartyLegalEntityCompanyID: Text; var CustPartyLegalEntityIDSchemeID: Text; IsBISBilling: Boolean)
    var
        Customer: Record Customer;
    begin
        if Customer.Get(SalesHeader."Bill-to Customer No.") then begin
            CustPartyLegalEntityRegName := Customer.Name;
            CustPartyLegalEntityCompanyID := Customer."SSA Commerce Trade No.";
        end;
    end;


    procedure GetAccountingCustomerPartyContact(SalesHeader: Record "Sales Header"; var CustContactID: Text; var CustContactName: Text; var CustContactTelephone: Text; var CustContactTelefax: Text; var CustContactElectronicMail: Text)
    var
        Customer: Record Customer;
    begin
        CustContactID := SalesHeader."Your Reference";
        CustContactName := SalesHeader."Bill-to Name";

        if Customer.Get(SalesHeader."Bill-to Customer No.") then begin
            CustContactTelephone := Customer."Phone No.";
            CustContactTelefax := Customer."Telex No.";
            CustContactElectronicMail := Customer."E-Mail";
        end;
    end;


    procedure GetPayeePartyInfo(var PayeePartyID: Text; var PayeePartyIDSchemeID: Text; var PayeePartyNameName: Text; var PayeePartyLegalEntityCompanyID: Text; var PayeePartyLegalCompIDSchemeID: Text)
    var
        CompanyInfo: Record "Company Information";
    begin
        CompanyInfo.Get;

        PayeePartyID := CompanyInfo.GLN;
        PayeePartyIDSchemeID := GLNTxt;
        PayeePartyNameName := CompanyInfo.Name;
        PayeePartyLegalEntityCompanyID := CompanyInfo."VAT Registration No.";
        PayeePartyLegalCompIDSchemeID := GetVATScheme(CompanyInfo."Country/Region Code");
    end;


    procedure GetTaxRepresentativePartyInfo(var TaxRepPartyNameName: Text; var PayeePartyTaxSchemeCompanyID: Text; var PayeePartyTaxSchCompIDSchemeID: Text; var PayeePartyTaxSchemeTaxSchemeID: Text)
    begin
        TaxRepPartyNameName := '';
        PayeePartyTaxSchemeCompanyID := '';
        PayeePartyTaxSchCompIDSchemeID := '';
        PayeePartyTaxSchemeTaxSchemeID := '';
    end;


    procedure GetDeliveryInfo(var ActualDeliveryDate: Text; var DeliveryID: Text; var DeliveryIDSchemeID: Text)
    begin
        ActualDeliveryDate := '';
        DeliveryID := '';
        DeliveryIDSchemeID := '';
    end;


    procedure GetGLNDeliveryInfo(SalesHeader: Record "Sales Header"; var ActualDeliveryDate: Text; var DeliveryID: Text; var DeliveryIDSchemeID: Text)
    begin
        ActualDeliveryDate := Format(SalesHeader."Shipment Date", 0, 9);

        DeliveryID := GetGLNForHeader(SalesHeader);

        if DeliveryID <> '' then
            DeliveryIDSchemeID := '0088'
        else
            DeliveryIDSchemeID := '';
    end;


    procedure GetGLNForHeader(SalesHeader: Record "Sales Header"): Code[13]
    var
        Customer: Record Customer;
        ShipToAddress: Record "Ship-to Address";
    begin
        if ShipToAddress.Get(SalesHeader."Sell-to Customer No.", SalesHeader."Ship-to Code") then
            if ShipToAddress.GLN <> '' then
                exit(ShipToAddress.GLN);
        if Customer.Get(SalesHeader."Sell-to Customer No.") then
            exit(Customer.GLN);
        exit('');
    end;


    procedure GetDeliveryAddress(SalesHeader: Record "Sales Header"; var DeliveryStreetName: Text; var DeliveryAdditionalStreetName: Text; var DeliveryCityName: Text; var DeliveryPostalZone: Text; var DeliveryCountrySubentity: Text; var DeliveryCountryIdCode: Text; var DeliveryCountryListID: Text)
    begin
        DeliveryStreetName := SalesHeader."Ship-to Address";
        DeliveryAdditionalStreetName := SalesHeader."Ship-to Address 2";
        DeliveryCityName := SalesHeader."Ship-to City";
        DeliveryPostalZone := SalesHeader."Ship-to Post Code";
        DeliveryCountrySubentity := GetJudet(SalesHeader."Ship-to County");
        if DeliveryCountrySubentity = 'RO-B' then
            DeliveryCityName := Format(SalesHeader."SSAEDShip-to Sector");
        DeliveryCountryIdCode := SalesHeader."Ship-to Country/Region Code";
        DeliveryCountryListID := GetISO3166_1Alpha2;
    end;


    procedure GetPaymentMeansInfo(SalesHeader: Record "Sales Header"; var PaymentMeansCode: Text; var PaymentMeansListID: Text; var PaymentDueDate: Text; var PaymentChannelCode: Text; var PaymentID: Text; var PrimaryAccountNumberID: Text; var NetworkID: Text)
    var
        PaymentMethod: Record "Payment Method";
    begin
        PaymentMethod.Get(SalesHeader."Payment Method Code");
        PaymentMethod.TestField("SSAEDEFactura ID");
        PaymentMeansCode := PaymentMethod."SSAEDEFactura ID";
        PaymentMeansListID := GetUNCL4461ListID;
        PaymentDueDate := Format(SalesHeader."Due Date", 0, 9);
        PaymentChannelCode := '';
        PaymentID := '';
        PrimaryAccountNumberID := '';
        NetworkID := '';
    end;


    procedure GetPaymentMeansPayeeFinancialAcc(var PayeeFinancialAccountID: Text; var PaymentMeansSchemeID: Text; var FinancialInstitutionBranchID: Text; var FinancialInstitutionID: Text; var FinancialInstitutionSchemeID: Text; var FinancialInstitutionName: Text)
    var
        CompanyInfo: Record "Company Information";
    begin
        CompanyInfo.Get;
        if CompanyInfo."SSA IBAN 2" <> '' then begin
            PayeeFinancialAccountID := DelChr(CompanyInfo."SSA IBAN 2", '=', ' ');
            PaymentMeansSchemeID := IBANPaymentSchemeIDTxt;
        end else
            if CompanyInfo."Bank Account No." <> '' then begin
                PayeeFinancialAccountID := CompanyInfo."Bank Account No.";
                PaymentMeansSchemeID := LocalPaymentSchemeIDTxt;
            end;

        FinancialInstitutionBranchID := CompanyInfo."Bank Branch No.";
        FinancialInstitutionID := DelChr(CompanyInfo."SWIFT Code", '=', ' ');
        FinancialInstitutionSchemeID := BICTxt;
        FinancialInstitutionName := CompanyInfo."Bank Name";
    end;


    procedure GetPaymentMeansFinancialInstitutionAddr(var FinancialInstitutionStreetName: Text; var AdditionalStreetName: Text; var FinancialInstitutionCityName: Text; var FinancialInstitutionPostalZone: Text; var FinancialInstCountrySubentity: Text; var FinancialInstCountryIdCode: Text; var FinancialInstCountryListID: Text)
    begin
        FinancialInstitutionStreetName := '';
        AdditionalStreetName := '';
        FinancialInstitutionCityName := '';
        FinancialInstitutionPostalZone := '';
        FinancialInstCountrySubentity := '';
        FinancialInstCountryIdCode := '';
        FinancialInstCountryListID := '';
    end;


    procedure GetPaymentMeansInfo1(SalesHeader: Record "Sales Header"; var PaymentMeansCode: Text; var PaymentMeansListID: Text; var PaymentDueDate: Text; var PaymentChannelCode: Text; var PaymentID: Text; var PrimaryAccountNumberID: Text; var NetworkID: Text)
    var
        PaymentMethod: Record "Payment Method";
    begin
        PaymentMethod.Get(SalesHeader."Payment Method Code");
        PaymentMethod.TestField("SSAEDEFactura ID");
        PaymentMeansCode := PaymentMethod."SSAEDEFactura ID";
        PaymentMeansListID := GetUNCL4461ListID;
        PaymentDueDate := Format(SalesHeader."Due Date", 0, 9);
        PaymentChannelCode := '';
        PaymentID := '';
        PrimaryAccountNumberID := '';
        NetworkID := '';
    end;


    procedure GetPaymentMeansPayeeFinancialAcc1(var PayeeFinancialAccountID: Text; var PaymentMeansSchemeID: Text; var FinancialInstitutionBranchID: Text; var FinancialInstitutionID: Text; var FinancialInstitutionSchemeID: Text; var FinancialInstitutionName: Text)
    var
        CompanyInfo: Record "Company Information";
    begin
        CompanyInfo.Get;
        if CompanyInfo.IBAN <> '' then begin
            PayeeFinancialAccountID := DelChr(CompanyInfo.IBAN, '=', ' ');
            PaymentMeansSchemeID := IBANPaymentSchemeIDTxt;
        end else
            if CompanyInfo."Bank Account No." <> '' then begin
                PayeeFinancialAccountID := CompanyInfo."Bank Account No.";
                PaymentMeansSchemeID := LocalPaymentSchemeIDTxt;
            end;

        FinancialInstitutionBranchID := CompanyInfo."Bank Branch No.";
        FinancialInstitutionID := DelChr(CompanyInfo."SWIFT Code", '=', ' ');
        FinancialInstitutionSchemeID := BICTxt;
        FinancialInstitutionName := CompanyInfo."Bank Name";
    end;


    procedure GetPaymentTermsInfo(SalesHeader: Record "Sales Header"; var PaymentTermsNote: Text)
    var
        PmtTerms: Record "Payment Terms";
    begin
        /*
        if SalesHeader."Payment Terms Code" = '' then
            PmtTerms.Init
        else begin
            PmtTerms.Get(SalesHeader."Payment Terms Code");
            PmtTerms.TranslateDescription(PmtTerms, SalesHeader."Language Code");
        end;

        PaymentTermsNote := PmtTerms.Description;
        */
    end;


    procedure GetAllowanceChargeInfo(VATAmtLine: Record "VAT Amount Line"; SalesHeader: Record "Sales Header"; var ChargeIndicator: Text; var AllowanceChargeReasonCode: Text; var AllowanceChargeListID: Text; var AllowanceChargeReason: Text; var Amount: Text; var AllowanceChargeCurrencyID: Text; var TaxCategoryID: Text; var TaxCategorySchemeID: Text; var Percent: Text; var AllowanceChargeTaxSchemeID: Text)
    begin
        if VATAmtLine."Invoice Discount Amount" = 0 then begin
            ChargeIndicator := '';
            exit;
        end;

        ChargeIndicator := 'false';
        AllowanceChargeReasonCode := AllowanceChargeReasonCodeTxt;
        AllowanceChargeListID := GetUNCL4465ListID;
        AllowanceChargeReason := InvoiceDisAmtTxt;
        //SSM2434>>
        IF SalesHeader.IsCreditDocType THEN
            Amount := FORMAT(-VATAmtLine."Invoice Discount Amount", 0, 9)
        ELSE
            Amount := FORMAT(VATAmtLine."Invoice Discount Amount", 0, 9);

        //SSM2434<<
        AllowanceChargeCurrencyID := GetSalesDocCurrencyCode(SalesHeader);
        TaxCategoryID := VATAmtLine."Tax Category";
        TaxCategorySchemeID := GetUNCL5305ListID;
        Percent := Format(VATAmtLine."VAT %", 0, 9);
        AllowanceChargeTaxSchemeID := VATTxt;
    end;


    procedure GetAllowanceChargeInfoBIS(VATAmtLine: Record "VAT Amount Line"; SalesHeader: Record "Sales Header"; var ChargeIndicator: Text; var AllowanceChargeReasonCode: Text; var AllowanceChargeListID: Text; var AllowanceChargeReason: Text; var Amount: Text; var AllowanceChargeCurrencyID: Text; var TaxCategoryID: Text; var TaxCategorySchemeID: Text; var Percent: Text; var AllowanceChargeTaxSchemeID: Text)
    begin
        GetAllowanceChargeInfo(
          VATAmtLine, SalesHeader, ChargeIndicator, AllowanceChargeReasonCode, AllowanceChargeListID, AllowanceChargeReason,
          Amount, AllowanceChargeCurrencyID, TaxCategoryID, TaxCategorySchemeID, Percent, AllowanceChargeTaxSchemeID);
        if TaxCategoryID = GetTaxCategoryO then
            Percent := '';
    end;


    procedure GetTaxExchangeRateInfo(SalesHeader: Record "Sales Header"; var SourceCurrencyCode: Text; var SourceCurrencyCodeListID: Text; var TargetCurrencyCode: Text; var TargetCurrencyCodeListID: Text; var CalculationRate: Text; var MathematicOperatorCode: Text; var Date: Text)
    var
        GLSetup: Record "General Ledger Setup";
    begin
        GLSetup.Get;
        if GLSetup."LCY Code" = GetSalesDocCurrencyCode(SalesHeader) then
            exit;

        SourceCurrencyCode := GetSalesDocCurrencyCode(SalesHeader);
        SourceCurrencyCodeListID := GetISO4217ListID;
        TargetCurrencyCode := GLSetup."LCY Code";
        TargetCurrencyCodeListID := GetISO4217ListID;
        CalculationRate := Format(SalesHeader."Currency Factor", 0, 9);
        MathematicOperatorCode := MultiplyTxt;
        Date := Format(SalesHeader."Posting Date", 0, 9);
    end;


    procedure GetTaxTotalInfo(SalesHeader: Record "Sales Header"; var VATAmtLine: Record "VAT Amount Line"; var TaxAmount: Text; var TaxTotalCurrencyID: Text)
    begin
        VATAmtLine.CalcSums(VATAmtLine."VAT Amount");
        if SalesHeader."Document Type" = SalesHeader."Document Type"::Invoice then
            TaxAmount := Format(VATAmtLine."VAT Amount", 0, 9);
        if SalesHeader."Document Type" = SalesHeader."Document Type"::"Credit Memo" then
            TaxAmount := Format(-VATAmtLine."VAT Amount", 0, 9);
        TaxTotalCurrencyID := GetSalesDocCurrencyCode(SalesHeader);
    end;


    procedure GetTaxSubtotalInfo(VATAmtLine: Record "VAT Amount Line"; SalesHeader: Record "Sales Header"; var TaxableAmount: Text; var TaxAmountCurrencyID: Text; var SubtotalTaxAmount: Text; var TaxSubtotalCurrencyID: Text; var TransactionCurrencyTaxAmount: Text; var TransCurrTaxAmtCurrencyID: Text; var TaxTotalTaxCategoryID: Text; var schemeID: Text; var TaxCategoryPercent: Text; var TaxTotalTaxSchemeID: Text; var TaxExemptionReason: Text)
    var
        GLSetup: Record "General Ledger Setup";
    begin
        if SalesHeader."Document Type" = SalesHeader."Document Type"::Invoice then
            TaxableAmount := Format(VATAmtLine."VAT Base", 0, 9);
        if SalesHeader."Document Type" = SalesHeader."Document Type"::"Credit Memo" then
            TaxableAmount := Format(-VATAmtLine."VAT Base", 0, 9);
        TaxAmountCurrencyID := GetSalesDocCurrencyCode(SalesHeader);
        if SalesHeader."Document Type" = SalesHeader."Document Type"::Invoice then
            SubtotalTaxAmount := Format(VATAmtLine."VAT Amount", 0, 9);
        if SalesHeader."Document Type" = SalesHeader."Document Type"::"Credit Memo" then
            SubtotalTaxAmount := Format(-VATAmtLine."VAT Amount", 0, 9);
        TaxSubtotalCurrencyID := GetSalesDocCurrencyCode(SalesHeader);
        GLSetup.Get;
        if GLSetup."LCY Code" <> GetSalesDocCurrencyCode(SalesHeader) then begin
            TransactionCurrencyTaxAmount :=
              Format(
                VATAmtLine.GetAmountLCY(
                  SalesHeader."Posting Date",
                  GetSalesDocCurrencyCode(SalesHeader),
                  SalesHeader."Currency Factor"), 0, 9);
            TransCurrTaxAmtCurrencyID := GLSetup."LCY Code";
        end;
        TaxTotalTaxCategoryID := VATAmtLine."Tax Category";
        schemeID := GetUNCL5305ListID;
        TaxCategoryPercent := Format(VATAmtLine."VAT %", 0, 9);
        TaxTotalTaxSchemeID := VATTxt;

        //SSM1991>>
        if (TaxTotalTaxCategoryID in [GetTaxCategoryE, GetTaxCategoryG, GetTaxCategoryK, GetTaxCategoryO, GetTaxCategoryAE]) then
            TaxExemptionReason := FORMAT(VATAmtLine."SSAEDColumn Type")
        else
            CLEAR(TaxExemptionReason);
        //SSM1991<<
    end;


    procedure GetLegalMonetaryInfo(SalesHeader: Record "Sales Header"; var VATAmtLine: Record "VAT Amount Line"; var LineExtensionAmount: Text; var LegalMonetaryTotalCurrencyID: Text; var TaxExclusiveAmount: Text; var TaxExclusiveAmountCurrencyID: Text; var TaxInclusiveAmount: Text; var TaxInclusiveAmountCurrencyID: Text; var AllowanceTotalAmount: Text; var AllowanceTotalAmountCurrencyID: Text; var ChargeTotalAmount: Text; var ChargeTotalAmountCurrencyID: Text; var PrepaidAmount: Text; var PrepaidCurrencyID: Text; var PayableRoundingAmount: Text; var PayableRndingAmountCurrencyID: Text; var PayableAmount: Text; var PayableAmountCurrencyID: Text)
    begin
        VATAmtLine.Reset;
        VATAmtLine.CalcSums("Line Amount", "VAT Base", "Amount Including VAT", "Invoice Discount Amount");
        if SalesHeader."Document Type" = SalesHeader."Document Type"::Invoice then
            LineExtensionAmount := Format(Round(VATAmtLine."VAT Base", 0.01) + Round(VATAmtLine."Invoice Discount Amount", 0.01), 0, 9);
        if SalesHeader."Document Type" = SalesHeader."Document Type"::"Credit Memo" then
            LineExtensionAmount := Format(Round(-VATAmtLine."VAT Base", 0.01) - Round(VATAmtLine."Invoice Discount Amount", 0.01), 0, 9);
        LegalMonetaryTotalCurrencyID := GetSalesDocCurrencyCode(SalesHeader);

        if SalesHeader."Document Type" = SalesHeader."Document Type"::Invoice then
            TaxExclusiveAmount := Format(Round(VATAmtLine."VAT Base", 0.01), 0, 9);
        if SalesHeader."Document Type" = SalesHeader."Document Type"::"Credit Memo" then
            TaxExclusiveAmount := Format(Round(-VATAmtLine."VAT Base", 0.01), 0, 9);
        TaxExclusiveAmountCurrencyID := GetSalesDocCurrencyCode(SalesHeader);

        if SalesHeader."Document Type" = SalesHeader."Document Type"::Invoice then
            TaxInclusiveAmount := Format(Round(VATAmtLine."Amount Including VAT", 0.01, '>'), 0, 9); // Should be two decimal places
        if SalesHeader."Document Type" = SalesHeader."Document Type"::"Credit Memo" then
            TaxInclusiveAmount := Format(Round(-VATAmtLine."Amount Including VAT", 0.01, '>'), 0, 9); // Should be two decimal places
        TaxInclusiveAmountCurrencyID := GetSalesDocCurrencyCode(SalesHeader);

        if SalesHeader."Document Type" = SalesHeader."Document Type"::Invoice then
            AllowanceTotalAmount := Format(Round(VATAmtLine."Invoice Discount Amount", 0.01), 0, 9);
        if SalesHeader."Document Type" = SalesHeader."Document Type"::"Credit Memo" then
            AllowanceTotalAmount := Format(Round(-VATAmtLine."Invoice Discount Amount", 0.01), 0, 9);
        AllowanceTotalAmountCurrencyID := GetSalesDocCurrencyCode(SalesHeader);
        TaxInclusiveAmountCurrencyID := GetSalesDocCurrencyCode(SalesHeader);

        ChargeTotalAmount := '';
        ChargeTotalAmountCurrencyID := '';

        PrepaidAmount := '0.00';
        PrepaidCurrencyID := GetSalesDocCurrencyCode(SalesHeader);

        PayableRoundingAmount :=
          Format(VATAmtLine."Amount Including VAT" - Round(VATAmtLine."Amount Including VAT", 0.01), 0, 9);
        PayableRndingAmountCurrencyID := GetSalesDocCurrencyCode(SalesHeader);

        if SalesHeader."Document Type" = SalesHeader."Document Type"::Invoice then
            PayableAmount := Format(Round(VATAmtLine."Amount Including VAT", 0.01), 0, 9);
        if SalesHeader."Document Type" = SalesHeader."Document Type"::"Credit Memo" then
            PayableAmount := Format(Round(-VATAmtLine."Amount Including VAT", 0.01), 0, 9);
        PayableAmountCurrencyID := GetSalesDocCurrencyCode(SalesHeader);
    end;


    procedure GetLineGeneralInfo(SalesLine: Record "Sales Line"; SalesHeader: Record "Sales Header"; var InvoiceLineID: Text; var InvoiceLineNote: Text; var InvoicedQuantity: Text; var InvoiceLineExtensionAmount: Text; var LineExtensionAmountCurrencyID: Text; var InvoiceLineAccountingCost: Text)
    begin
        InvoiceLineID := Format(SalesLine."Line No.", 0, 9);
        //InvoiceLineNote := Format(SalesLine.Type);
        InvoicedQuantity := Format(SalesLine.Quantity, 0, 9);
        if SalesHeader."Document Type" = SalesHeader."Document Type"::Invoice then
            InvoiceLineExtensionAmount := Format(SalesLine."VAT Base Amount" + SalesLine."Inv. Discount Amount", 0, 9);
        if SalesHeader."Document Type" = SalesHeader."Document Type"::"Credit Memo" then
            InvoiceLineExtensionAmount := Format(-SalesLine."VAT Base Amount" - SalesLine."Inv. Discount Amount", 0, 9);
        LineExtensionAmountCurrencyID := GetSalesDocCurrencyCode(SalesHeader);
        InvoiceLineAccountingCost := '';
    end;


    procedure GetLineUnitCodeInfo(SalesLine: Record "Sales Line"; var unitCode: Text; var unitCodeListID: Text)
    var
        UOM: Record "Unit of Measure";
    begin
        unitCode := '';
        unitCodeListID := GetUNECERec20ListID;

        if SalesLine.Quantity = 0 then begin
            unitCode := UoMforPieceINUNECERec20ListIDTxt; // unitCode is required
            exit;
        end;

        case SalesLine.Type of
            SalesLine.Type::Item, SalesLine.Type::Resource:

                if UOM.Get(SalesLine."Unit of Measure Code") then
                    unitCode := UOM."International Standard Code"
                else
                    Error(NoUnitOfMeasureErr, SalesLine."Document Type", SalesLine."Document No.", SalesLine.FieldCaption(SalesLine."Unit of Measure Code"));
            SalesLine.Type::"G/L Account", SalesLine.Type::"Fixed Asset", SalesLine.Type::"Charge (Item)":

                if UOM.Get(SalesLine."Unit of Measure Code") then
                    unitCode := UOM."International Standard Code"
                else
                    unitCode := UoMforPieceINUNECERec20ListIDTxt;

        end;
    end;


    procedure GetLineInvoicePeriodInfo(var InvLineInvoicePeriodStartDate: Text; var InvLineInvoicePeriodEndDate: Text)
    begin
        InvLineInvoicePeriodStartDate := '';
        InvLineInvoicePeriodEndDate := '';
    end;


    procedure GetLineOrderLineRefInfo()
    begin
    end;


    procedure GetLineDeliveryInfo(var InvoiceLineActualDeliveryDate: Text; var InvoiceLineDeliveryID: Text; var InvoiceLineDeliveryIDSchemeID: Text)
    begin
        InvoiceLineActualDeliveryDate := '';
        InvoiceLineDeliveryID := '';
        InvoiceLineDeliveryIDSchemeID := '';
    end;


    procedure GetLineDeliveryPostalAddr(var InvoiceLineDeliveryStreetName: Text; var InvLineDeliveryAddStreetName: Text; var InvoiceLineDeliveryCityName: Text; var InvoiceLineDeliveryPostalZone: Text; var InvLnDeliveryCountrySubentity: Text; var InvLnDeliveryCountryIdCode: Text; var InvLineDeliveryCountryListID: Text)
    begin
        InvoiceLineDeliveryStreetName := '';
        InvLineDeliveryAddStreetName := '';
        InvoiceLineDeliveryCityName := '';
        InvoiceLineDeliveryPostalZone := '';
        InvLnDeliveryCountrySubentity := '';
        InvLnDeliveryCountryIdCode := '';
        InvLineDeliveryCountryListID := GetISO3166_1Alpha2;
    end;


    procedure GetLineAllowanceChargeInfo(SalesLine: Record "Sales Line"; SalesHeader: Record "Sales Header"; var InvLnAllowanceChargeIndicator: Text; var InvLnAllowanceChargeReason: Text; var InvLnAllowanceChargeAmount: Text; var InvLnAllowanceChargeAmtCurrID: Text)
    begin
        InvLnAllowanceChargeIndicator := '';
        InvLnAllowanceChargeReason := '';
        InvLnAllowanceChargeAmount := '';
        InvLnAllowanceChargeAmtCurrID := '';
        if SalesLine."Line Discount Amount" = 0 then
            exit;

        InvLnAllowanceChargeIndicator := 'false';
        InvLnAllowanceChargeReason := LineDisAmtTxt;
        InvLnAllowanceChargeAmount := Format(SalesLine."Line Discount Amount", 0, 9);
        InvLnAllowanceChargeAmtCurrID := GetSalesDocCurrencyCode(SalesHeader);
    end;


    procedure GetLineTaxTotal(SalesLine: Record "Sales Line"; SalesHeader: Record "Sales Header"; var InvoiceLineTaxAmount: Text; var currencyID: Text)
    begin
        InvoiceLineTaxAmount := Format(SalesLine."Amount Including VAT" - SalesLine.Amount, 0, 9);
        currencyID := GetSalesDocCurrencyCode(SalesHeader);
    end;


    procedure GetLineItemInfo(SalesLine: Record "Sales Line"; var Description: Text; var Name: Text; var SellersItemIdentificationID: Text; var StandardItemIdentificationID: Text; var StdItemIdIDSchemeID: Text; var OriginCountryIdCode: Text; var OriginCountryIdCodeListID: Text)
    var
        Item: Record Item;
    begin
        Name := SalesLine.Description;
        Description := SalesLine."Description 2";

        if SalesLine.IsInventoriableItem() then begin
            SellersItemIdentificationID := SalesLine."No.";
            if (SalesLine."Item Reference Type" = SalesLine."Item Reference Type"::"Bar Code") and (SalesLine."Item Reference No." <> '') then
                StandardItemIdentificationID := SalesLine."Item Reference No."
            else
                StandardItemIdentificationID := Item.GTIN;
            StdItemIdIDSchemeID := GTINTxt;
        end else begin
            SellersItemIdentificationID := '';
            StandardItemIdentificationID := '';
            StdItemIdIDSchemeID := '';
        end;

        OriginCountryIdCode := '';
        OriginCountryIdCodeListID := '';
        if SalesLine.Type <> SalesLine.Type::" " then
            OriginCountryIdCodeListID := GetISO3166_1Alpha2
    end;


    procedure GetLineItemCommodityClassficationInfo(var CommodityCode: Text; var CommodityCodeListID: Text; var ItemClassificationCode: Text; var ItemClassificationCodeListID: Text)
    begin
        CommodityCode := '';
        CommodityCodeListID := '';

        ItemClassificationCode := '';
        ItemClassificationCodeListID := '';
    end;


    procedure GetLineItemClassfiedTaxCategory(SalesLine: Record "Sales Line"; var ClassifiedTaxCategoryID: Text; var ItemSchemeID: Text; var InvoiceLineTaxPercent: Text; var ClassifiedTaxCategorySchemeID: Text)
    var
        VATPostingSetup: Record "VAT Posting Setup";
    begin
        if VATPostingSetup.Get(SalesLine."VAT Bus. Posting Group", SalesLine."VAT Prod. Posting Group") then
            ClassifiedTaxCategoryID := VATPostingSetup."Tax Category";
        ItemSchemeID := GetUNCL5305ListID;
        InvoiceLineTaxPercent := Format(SalesLine."VAT %", 0, 9);
        ClassifiedTaxCategorySchemeID := VATTxt;
    end;


    procedure GetLineItemClassfiedTaxCategoryBIS(SalesLine: Record "Sales Line"; var ClassifiedTaxCategoryID: Text; var ItemSchemeID: Text; var InvoiceLineTaxPercent: Text; var ClassifiedTaxCategorySchemeID: Text)
    begin
        GetLineItemClassfiedTaxCategory(
          SalesLine, ClassifiedTaxCategoryID, ItemSchemeID, InvoiceLineTaxPercent, ClassifiedTaxCategorySchemeID);
        if ClassifiedTaxCategoryID = GetTaxCategoryO then
            InvoiceLineTaxPercent := '';
    end;


    procedure GetLineAdditionalItemPropertyInfo(SalesLine: Record "Sales Line"; var AdditionalItemPropertyName: Text; var AdditionalItemPropertyValue: Text)
    var
        ItemVariant: Record "Item Variant";
    begin
        AdditionalItemPropertyName := '';
        AdditionalItemPropertyValue := '';

        if SalesLine.Type <> SalesLine.Type::Item then
            exit;
        if SalesLine."No." = '' then
            exit;
        if not ItemVariant.Get(SalesLine."No.", SalesLine."Variant Code") then
            exit;

        //AdditionalItemPropertyName := ItemVariant.Code;
        //AdditionalItemPropertyValue := ItemVariant.Description;
    end;


    procedure GetLinePriceInfo(SalesLine: Record "Sales Line"; SalesHeader: Record "Sales Header"; var InvoiceLinePriceAmount: Text; var InvLinePriceAmountCurrencyID: Text; var BaseQuantity: Text; var UnitCode: Text)
    var
        unitCodeListID: Text;
    begin
        InvoiceLinePriceAmount := Format(SalesLine."Unit Price", 0, 9);
        InvLinePriceAmountCurrencyID := GetSalesDocCurrencyCode(SalesHeader);
        BaseQuantity := '1';
        GetLineUnitCodeInfo(SalesLine, UnitCode, unitCodeListID);
    end;


    procedure GetLinePriceAllowanceChargeInfo(var PriceChargeIndicator: Text; var PriceAllowanceChargeAmount: Text; var PriceAllowanceAmountCurrencyID: Text; var PriceAllowanceChargeBaseAmount: Text; var PriceAllowChargeBaseAmtCurrID: Text)
    begin
        PriceChargeIndicator := '';
        PriceAllowanceChargeAmount := '';
        PriceAllowanceAmountCurrencyID := '';
        PriceAllowanceChargeBaseAmount := '';
        PriceAllowChargeBaseAmtCurrID := '';
    end;

    local procedure GetSalesDocCurrencyCode(SalesHeader: Record "Sales Header"): Code[10]
    var
        GLSetup: Record "General Ledger Setup";
    begin
        if SalesHeader."Currency Code" = '' then begin
            GLSetup.Get;
            GLSetup.TestField("LCY Code");
            exit(GLSetup."LCY Code");
        end;
        exit(SalesHeader."Currency Code");
    end;

    local procedure GetSalesperson(SalesHeader: Record "Sales Header"; var Salesperson: Record "Salesperson/Purchaser")
    begin
        if SalesHeader."Salesperson Code" = '' then
            Salesperson.Init
        else
            Salesperson.Get(SalesHeader."Salesperson Code");
    end;


    procedure GetCrMemoBillingReferenceInfo(SalesCrMemoHeader: Record "Sales Cr.Memo Header"; var InvoiceDocRefID: Text; var InvoiceDocRefIssueDate: Text)
    var
        SalesInvoiceHeader: Record "Sales Invoice Header";
    begin
        if (SalesCrMemoHeader."Applies-to Doc. Type" = SalesCrMemoHeader."Applies-to Doc. Type"::Invoice) and
           SalesInvoiceHeader.Get(SalesCrMemoHeader."Applies-to Doc. No.")
        then begin
            InvoiceDocRefID := SalesInvoiceHeader."No.";
            InvoiceDocRefIssueDate := Format(SalesInvoiceHeader."Posting Date", 0, 9);
        end;
    end;


    procedure GetTotals(SalesLine: Record "Sales Line"; var VATAmtLine: Record "VAT Amount Line")
    var
        VATPostingSetup: Record "VAT Posting Setup";
    begin
        if not VATPostingSetup.Get(SalesLine."VAT Bus. Posting Group", SalesLine."VAT Prod. Posting Group") then
            VATPostingSetup.Init;
        VATAmtLine.Init;
        VATAmtLine."VAT Identifier" := VATPostingSetup."VAT Identifier";
        VATAmtLine."VAT Calculation Type" := SalesLine."VAT Calculation Type";
        //VATAmtLine."Tax Group Code" := SalesLine."Tax Group Code";
        VATAmtLine."VAT %" := SalesLine."VAT %";
        VATAmtLine."VAT Base" := SalesLine.Amount;
        VATAmtLine."Amount Including VAT" := SalesLine."Amount Including VAT";
        VATAmtLine."Line Amount" := SalesLine."Line Amount";
        if SalesLine."Allow Invoice Disc." then
            VATAmtLine."Inv. Disc. Base Amount" := SalesLine."Line Amount";
        VATAmtLine."Invoice Discount Amount" := SalesLine."Inv. Discount Amount";
        VATAmtLine."Tax Category" := VATPostingSetup."Tax Category";
        VATAmtLine."SSAEDColumn Type" := VATPostingSetup."SSA Column Type"; //SSM1991
        //InsertLine;
        VATAmtLine.InsertLineEfactura();
    end;

    procedure GetTaxCategories(SalesLine: Record "Sales Line"; var VATProductPostingGroupCategory: Record "VAT Product Posting Group")
    var
        VATPostingSetup: Record "VAT Posting Setup";
        VATProductPostingGroup: Record "VAT Product Posting Group";
    begin
        if not VATPostingSetup.Get(SalesLine."VAT Bus. Posting Group", SalesLine."VAT Prod. Posting Group") then
            VATPostingSetup.Init;
        if not VATProductPostingGroup.Get(SalesLine."VAT Prod. Posting Group") then
            VATProductPostingGroup.Init;

        VATProductPostingGroupCategory.Init;
        VATProductPostingGroupCategory.Code := VATPostingSetup."Tax Category";
        VATProductPostingGroupCategory.Description := VATProductPostingGroup.Description;
        if VATProductPostingGroupCategory.Insert then;
    end;

    procedure GetTaxExemptionReason(var VATProductPostingGroupCategory: Record "VAT Product Posting Group"; var TaxExemptionReasonTxt: Text; TaxCategoryID: Text)
    begin
        if not (TaxCategoryID in [GetTaxCategoryE, GetTaxCategoryG, GetTaxCategoryK, GetTaxCategoryO, GetTaxCategoryAE]) then
            exit;
        if VATProductPostingGroupCategory.Get(TaxCategoryID) then
            TaxExemptionReasonTxt := VATProductPostingGroupCategory.Description;
    end;

    local procedure GetInvoiceTypeCode(): Text
    begin

        exit('380');
    end;

    local procedure GetUNCL1001ListID(): Text
    begin
        exit('UNCL1001');
    end;

    local procedure GetISO4217ListID(): Text
    begin
        exit('ISO4217');
    end;

    local procedure GetISO3166_1Alpha2(): Text
    begin
        exit('ISO3166-1:Alpha2');
    end;

    local procedure GetUNCL4461ListID(): Text
    begin
        exit('UNCL4461');
    end;

    local procedure GetUNCL4465ListID(): Text
    begin
        exit('UNCL4465');
    end;

    local procedure GetUNCL5305ListID(): Text
    begin
        exit('UNCL5305');
    end;

    local procedure GetUNECERec20ListID(): Text
    begin
        exit('UNECERec20');
    end;

    procedure GetUoMforPieceINUNECERec20ListID(): Code[10]
    begin
        exit(UoMforPieceINUNECERec20ListIDTxt);
    end;

    local procedure GetGLNSchemeIDByFormat(IsBISBillling: Boolean): Text
    begin
        if IsBISBillling then
            exit(GetGLNSchemeID);
        exit(GLNTxt);
    end;

    local procedure GetGLNSchemeID(): Text
    begin
        exit('0088');
    end;

    local procedure GetVATSchemeByFormat(CountryRegionCode: Code[10]; IsBISBilling: Boolean): Text
    begin
        if IsBISBilling then
            exit('');
        exit(GetVATScheme(CountryRegionCode));
    end;

    local procedure GetVATScheme(CountryRegionCode: Code[10]): Text
    var
        CountryRegion: Record "Country/Region";
        CompanyInfo: Record "Company Information";
    begin
        if CountryRegionCode = '' then begin
            CompanyInfo.Get;
            CompanyInfo.TestField("Country/Region Code");
            CountryRegion.Get(CompanyInfo."Country/Region Code");
        end else
            CountryRegion.Get(CountryRegionCode);
        exit(CountryRegion."VAT Scheme");
    end;

    local procedure GetTaxCategoryAE(): Text
    begin
        exit('AE');
    end;

    local procedure GetTaxCategoryE(): Text
    begin
        exit('E');
    end;

    local procedure GetTaxCategoryG(): Text
    begin
        exit('G');
    end;

    local procedure GetTaxCategoryK(): Text
    begin
        exit('K');
    end;

    local procedure GetTaxCategoryO(): Text
    begin
        exit('O');
    end;

    procedure FormatVATRegitrationNo(VATRegistrartionNo: Text; _ISOCountryCode: Code[10]): Text
    begin
        exit(_ISOCountryCode + DelChr(uppercase(VATRegistrartionNo), '=', _ISOCountryCode));

    end;

    procedure FindNextInvoiceRec(var SalesInvoiceHeader: Record "Sales Invoice Header"; var SalesCrMemoHeader: Record "Sales Cr.Memo Header"; var SalesHeader: Record "Sales Header"; ProcessedDocType: Option "Sales Invoice","Sales Credit Memo"; Position: Integer): Boolean
    var
        Found: Boolean;
    begin
        case ProcessedDocType of
            ProcessedDocType::"Sales Invoice":
                begin
                    if Position = 1 then
                        Found := SalesInvoiceHeader.Find('-')
                    else
                        Found := SalesInvoiceHeader.Next <> 0;
                    if Found then
                        SalesHeader.TransferFields(SalesInvoiceHeader);
                    SalesHeader."Document Type" := SalesHeader."Document Type"::Invoice;
                end;
            ProcessedDocType::"Sales Credit Memo":
                begin
                    if Position = 1 then
                        Found := SalesCrMemoHeader.Find('-')
                    else
                        Found := SalesCrMemoHeader.Next <> 0;
                    if Found then
                        SalesHeader.TransferFields(SalesCrMemoHeader);
                    SalesHeader."Document Type" := SalesHeader."Document Type"::"Credit Memo";
                end;
        end;


        exit(Found);
    end;

    procedure FindNextInvoiceLineRec(var SalesInvoiceLine: Record "Sales Invoice Line"; var SalesCrMemoLine: Record "Sales Cr.Memo Line"; var SalesLine: Record "Sales Line"; ProcessedDocType: Option "Sales Invoice","Sales Credit Memo"; Position: Integer): Boolean
    var
        Found: Boolean;
    begin
        case ProcessedDocType of
            ProcessedDocType::"Sales Invoice":
                begin
                    if Position = 1 then
                        Found := SalesInvoiceLine.Find('-')
                    else
                        Found := SalesInvoiceLine.Next <> 0;
                    if Found then
                        SalesLine.TransferFields(SalesInvoiceLine);
                end;
            ProcessedDocType::"Sales Credit Memo":
                begin
                    if Position = 1 then
                        Found := SalesCrMemoLine.Find('-')
                    else
                        Found := SalesCrMemoLine.Next <> 0;
                    if Found then begin
                        SalesLine.TransferFields(SalesCrMemoLine);
                        SalesLine.Quantity := -SalesCrMemoLine.Quantity; //SSM2434
                    end;
                end;
        end;

        exit(Found);
    end;


    procedure GetJudet(_Judet: Text): Text
    begin
        case UpperCase(_Judet) of
            'ALBA':
                exit('RO-AB');
            'ARAD':
                exit('RO-AR');
            'ARGES', 'ARGEŞ':
                exit('RO-AG');
            'BACAU',
            'BACĂU':
                exit('RO-BC');
            'BIHOR':
                exit('RO-BH');
            'BISTRITA-NASAUD',
            'BISTRITA NASAUD',
            'BISTRIŢA-NĂSĂUD':
                exit('RO-BN');
            'BOTOSANI',
            'BOTOŞANI':
                exit('RO-BT');
            'BRASOV',
            'BRAŞOV':
                exit('RO-BV');
            'BRAILA',
            'BRĂILA':
                exit('RO-BR');
            'BUZAU',
            'BUZĂU':
                exit('RO-BZ');
            'CARAS-SEVERIN',
            'CARAS SEVERIN',
            'CARAŞ-SEVERIN',
            'CARAŞ SEVERIN':
                exit('RO-CS');
            'CALARASI',
            'CĂLĂRAŞI':
                exit('RO-CL');
            'CLUJ':
                exit('RO-CJ');
            'CONSTANTA',
            'CONSTANŢA':
                exit('RO-CT');
            'COVASNA':
                exit('RO-CV');
            'DAMBOVITA',
            'DÂMBOVIŢA':
                exit('RO-DB');
            'DOLJ':
                exit('RO-DJ');
            'GALATI',
            'GALAŢI':
                exit('RO-GL');
            'GIURGIU':
                exit('RO-GR');
            'GORJ':
                exit('RO-GJ');
            'HARGHITA':
                exit('RO-HR');
            'HUNEDOARA':
                exit('RO-HD');
            'IALOMITA',
            'IALOMIŢA':
                exit('RO-IL');
            'IASI',
            'IAŞI':
                exit('RO-IS');
            'ILFOV':
                exit('RO-IF');
            'MARAMURES',
            'MARAMUREŞ':
                exit('RO-MM');
            'MEHEDINTI',
            'MEHEDINŢI':
                exit('RO-MH');
            'MURES',
            'MUREŞ':
                exit('RO-MS');
            'NEAMT',
            'NEAMŢ':
                exit('RO-NT');
            'OLT':
                exit('RO-OT');
            'PRAHOVA':
                exit('RO-PH');
            'SATU MARE':
                exit('RO-SM');
            'SALAJ':
                exit('RO-SJ');
            'SIBIU':
                exit('RO-SB');
            'SUCEAVA':
                exit('RO-SV');
            'TELEORMAN':
                exit('RO-TR');
            'TIMIS',
            'TIMIŞ':
                exit('RO-TM');
            'TULCEA':
                exit('RO-TL');
            'VASLUI':
                exit('RO-VS');
            'VALCEA',
            'VÂLCEA':
                exit('RO-VL');
            'VRANCEA':
                exit('RO-VN');
            'BUCURESTI',
            'BUCUREŞTI',
            'MUNICIPIUL BUCUREŞTI',
            'MUNICIPIUL BUCURESTI':
                exit('RO-B');
            else
                exit('RO');
        end;
    end;
}

