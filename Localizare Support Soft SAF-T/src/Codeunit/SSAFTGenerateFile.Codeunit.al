
codeunit 71903 "SSAFT Generate File"
{
    // SSM2101 SSCAT 04.01.2023 SAF-T
    // SSM2133 SSCAT 15.05.2023 Modificari aditionale SAF-T
    // SSM2291 SSCAT 27.07.2023 modificari online preluate in call 190723

    TableNo = "SSAFT Export Line";

    trigger OnRun()
    var
        SAFTExportHeader: Record "SSAFT Export Header";
    begin

        Rec.LockTable;
        Rec.Validate("Server Instance ID", ServiceInstanceId);
        Rec.Validate("Session ID", SessionId);
        Rec.Validate("Created Date/Time", 0DT);
        Rec.Validate("No. Of Retries", 3);
        Rec.Modify;
        Commit;

        if GuiAllowed then
            Window.Open(
              '#1#################################\\' +
              '@2@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@');
        SAFTExportHeader.Get(Rec.ID);

        ExportHeader(SAFTExportHeader, Rec, false);
        ExportEmptySections(Rec, true); //SSM1724
        ExportLine(SAFTExportHeader, Rec);
        ExportEmptySections(Rec, false); //SSM1724

        if GuiAllowed then
            Window.Close;
        FinalizeExport(Rec, SAFTExportHeader);
    end;

    var
        SafTXmlHelper: Codeunit "SSAFT XML Helper";
        Window: Dialog;
        GeneratingHeaderMsg: Label 'Generating header...';
        ExportingCustomersMsg: Label 'Exporting customers...';
        ExportingVendorsMsg: Label 'Exporting vendors...';
        ExportingVATPostingSetupMsg: Label 'Exporting VAT Posting Setup...';
        ExportingDimensionsMsg: Label 'Exporting Dimensions...';
        ExportingGLEntriesMsg: Label 'Exporting G/L entries...';
        ExportingProductsMsg: Label 'Exporting products...';
        ExportingAssetsMsg: Label 'Exporting assets...';
        GlobalNFTType: Option "TAX-IMP - Impozite","TAX-IMP - Bugete",Livrari,"Achizitii ded 100%","Achizitii ded 50%_baserate","Achizitii ded 50%_not_known","Achizitii ded 50%","Achizitii neded","Achizitii baserate","Achizitii not known","WHT - nomenclator","WHT - D207","WHT - cote","IBAN-ISO13616-1997","ISO3166-1A2 - RO Dept Codes","ISO3166-2-CountryCodes",ISO4217CurrCodes,PlanConturiBalSocCom,PlanConturiIFRS,PlanConturiIFRS_Norma39,PlanConturiBanci,PlanConturiNebancare,PlanConturiSocAsigurari,Unitati_masura,NC8_2021_TARIC3,"Nomenclator stocuri","Nomenclator imobilizari",Nomenclator_Regim_fiscal,SAFT_Nomenclator_StockChar,Nom_Tipuri_facturi,Nom_Mecanisme_plati,"An fiscal-perioade de raportare","Nomenclator tari si valuta","IBAN Validation";
        ExportingSalesDocumentsMsg: Label 'Exporting Sales Entries...';
        ExportingMovementOfGoodsMsg: Label 'Exporting Movement of Goods...';
        ExportingAssetTransactions: Label 'Exporting Asset Transactions...';
        ExportingMovement: Label 'Export Movement';
        ExportingPhysicalStock: Label 'Export PhysicalStock';
        ExportingPurchaseDocumentsMsg: Label 'Exporting Purchase Entries...';
        ExportingPaymentsMsg: Label 'Exporting Payments Entries...';
        CountingAssetTransactions: Label 'Counting Asset Transactions...';

    procedure ExportSingleFile(SAFTExportHeader: Record "SSAFT Export Header")
    var
        SAFTExportLine: Record "SSAFT Export Line";
        SAFTExportLine2: Record "SSAFT Export Line";
        DummySAFTExportLine: Record "SSAFT Export Line" temporary;
        TypeHelper: Codeunit "Type Helper";
    begin
        //SSM1724>>
        // LOCKTABLE;
        // VALIDATE("Server Instance ID",SERVICEINSTANCEID);
        // VALIDATE("Session ID",SESSIONID);
        // VALIDATE("Created Date/Time",0DT);
        // VALIDATE("No. Of Retries",3);
        // MODIFY;
        // COMMIT;

        SAFTExportHeader.TestField("Folder Path");

        if GuiAllowed then
            Window.Open(
              '#1#################################\\' +
              '@2@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@');
        // SAFTExportHeader.GET(ID);

        DummySAFTExportLine.Init;
        DummySAFTExportLine.ID := SAFTExportHeader.ID;
        DummySAFTExportLine."Segment Index" := 1;
        DummySAFTExportLine.Insert;


        ExportHeader(SAFTExportHeader, DummySAFTExportLine, true);

        SAFTExportLine.LockTable;
        SAFTExportLine.Reset;
        SAFTExportLine.SetRange(ID, SAFTExportHeader.ID);
        //SAFTExportLine.SETRANGE("Export File",TRUE);
        if SAFTExportLine.FindFirst then begin
            ExportEmptySections(SAFTExportLine, true);
            repeat
                ExportLine(SAFTExportHeader, SAFTExportLine);
                SAFTExportLine2.Get(SAFTExportLine.ID, SAFTExportLine."Line No.");
                SAFTExportLine2.Validate(Status, SAFTExportLine.Status::Completed);
                SAFTExportLine2.Validate(Progress, 10000);
                SAFTExportLine2.Validate("Created Date/Time", TypeHelper.GetCurrentDateTimeInUserTimeZone);
                SAFTExportLine2.Modify;
            until SAFTExportLine.Next = 0;
            ExportEmptySections(SAFTExportLine, false);
        end;

        if GuiAllowed then
            Window.Close;

        FinalizeExportSingleFile(SAFTExportHeader);

        //SSM1724<<
    end;

    local procedure ExportLine(SAFTExportHeader: Record "SSAFT Export Header"; SAFTExportLine: Record "SSAFT Export Line")
    var
        GLEntry: Record "G/L Entry";
        CustLedgerEntry: Record "Cust. Ledger Entry";
        VendorLedgerEntry: Record "Vendor Ledger Entry";
        DetailedCustLedgEntry: Record "Detailed Cust. Ledg. Entry";
        DetailedVendorLedgEntry: Record "Detailed Vendor Ledg. Entry";
        ItemLedgerEntry: Record "Item Ledger Entry";
        FALedgerEntry: Record "FA Ledger Entry";
        BankAccountLedgerEntry: Record "Bank Account Ledger Entry";
        SAFTExportMgt: Codeunit "SSAFT Export Mgt.";
    begin
        //MasterData
        //SSM1724 ExportEmptySections(SAFTExportLine,TRUE);

        if not SAFTExportMgt.IsValidLine(SAFTExportHeader, SAFTExportLine) then
            ExportEmptySection(SAFTExportLine)
        else
            case SAFTExportLine."Type of Line" of
                SAFTExportLine."Type of Line"::"G/L Accounts":
                    begin
                        SafTXmlHelper.AddNewXMLNode('MasterFiles', '');
                        ExportGeneralLedgerAccounts(SAFTExportHeader);
                    end;
                SAFTExportLine."Type of Line"::Customers:
                    ExportCustomers(SAFTExportHeader);
                SAFTExportLine."Type of Line"::Suppliers:
                    ExportVendors(SAFTExportHeader);
                SAFTExportLine."Type of Line"::"Tax Table":
                    ExportTaxTable(SAFTExportHeader);
                SAFTExportLine."Type of Line"::"UoM Table":
                    ExportTUOMTable(SAFTExportHeader);
                SAFTExportLine."Type of Line"::"Analysis Type Table":
                    ExportAnalysisTypeTable(SAFTExportHeader);
                SAFTExportLine."Type of Line"::"Movement Type Table":
                    ExportMovementTypeTable(SAFTExportHeader);
                SAFTExportLine."Type of Line"::Products:
                    ExportProducts(SAFTExportHeader);
                SAFTExportLine."Type of Line"::"Physical Stock":
                    ExportPhysicalStockEntries(SAFTExportHeader);
                SAFTExportLine."Type of Line"::Owners:
                    begin
                        SafTXmlHelper.AddNewXMLNode('Owners', '');
                        SafTXmlHelper.FinalizeXMLNode;
                    end;
                SAFTExportLine."Type of Line"::Assets:
                    begin
                        ExportAssets(SAFTExportHeader);
                        SafTXmlHelper.FinalizeXMLNode;
                    end;
                SAFTExportLine."Type of Line"::"G/L Entries":
                    begin
                        GLEntry.SetRange("Posting Date", SAFTExportHeader."Starting Date", ClosingDate(SAFTExportHeader."Ending Date"));
                        ExportGeneralLedgerEntries(GLEntry, SAFTExportLine);
                    end;
                SAFTExportLine."Type of Line"::"Sales Invoices":
                    begin
                        SafTXmlHelper.AddNewXMLNode('SourceDocuments', '');
                        CustLedgerEntry.Reset;
                        CustLedgerEntry.SetCurrentKey("Document Type", "Customer No.", "Posting Date", "Currency Code");
                        CustLedgerEntry.SetRange("Posting Date", SAFTExportHeader."Starting Date", ClosingDate(SAFTExportHeader."Ending Date"));
                        DetailedCustLedgEntry.Reset;
                        DetailedCustLedgEntry.SetCurrentKey("Initial Document Type", "Entry Type", "Customer No.", "Currency Code", "Initial Entry Global Dim. 1", "Initial Entry Global Dim. 2", "Posting Date");
                        DetailedCustLedgEntry.SetRange("Posting Date", SAFTExportHeader."Starting Date", ClosingDate(SAFTExportHeader."Ending Date"));
                        ExportSalesDocuments(CustLedgerEntry, DetailedCustLedgEntry, SAFTExportLine);

                    end;
                SAFTExportLine."Type of Line"::"Purchase Invoices":
                    begin
                        VendorLedgerEntry.Reset;
                        VendorLedgerEntry.SetCurrentKey("Document Type", "Vendor No.", "Posting Date", "Currency Code");
                        VendorLedgerEntry.SetRange("Posting Date", SAFTExportHeader."Starting Date", ClosingDate(SAFTExportHeader."Ending Date"));
                        DetailedVendorLedgEntry.Reset;
                        DetailedVendorLedgEntry.SetRange("Posting Date", SAFTExportHeader."Starting Date", ClosingDate(SAFTExportHeader."Ending Date"));
                        ExportPurchaseDocuments(VendorLedgerEntry, DetailedVendorLedgEntry, SAFTExportLine);
                    end;
                SAFTExportLine."Type of Line"::Payments:
                    begin
                        CustLedgerEntry.Reset;
                        CustLedgerEntry.SetCurrentKey("Document Type", "Customer No.", "Posting Date", "Currency Code");
                        CustLedgerEntry.SetRange("Posting Date", SAFTExportHeader."Starting Date", ClosingDate(SAFTExportHeader."Ending Date"));
                        DetailedCustLedgEntry.Reset;
                        DetailedCustLedgEntry.SetCurrentKey("Initial Document Type", "Entry Type", "Customer No.", "Currency Code", "Initial Entry Global Dim. 1", "Initial Entry Global Dim. 2", "Posting Date");
                        DetailedCustLedgEntry.SetRange("Posting Date", SAFTExportHeader."Starting Date", ClosingDate(SAFTExportHeader."Ending Date"));

                        VendorLedgerEntry.Reset;
                        VendorLedgerEntry.SetCurrentKey("Document Type", "Vendor No.", "Posting Date", "Currency Code");
                        VendorLedgerEntry.SetRange("Posting Date", SAFTExportHeader."Starting Date", ClosingDate(SAFTExportHeader."Ending Date"));
                        DetailedVendorLedgEntry.Reset;
                        DetailedVendorLedgEntry.SetRange("Posting Date", SAFTExportHeader."Starting Date", ClosingDate(SAFTExportHeader."Ending Date"));

                        //SSM1724>>
                        BankAccountLedgerEntry.Reset;
                        BankAccountLedgerEntry.SetCurrentKey("Bank Account No.", "Posting Date");
                        BankAccountLedgerEntry.SetRange("Posting Date", SAFTExportHeader."Starting Date", ClosingDate(SAFTExportHeader."Ending Date"));
                        BankAccountLedgerEntry.SetRange("Bal. Account Type", BankAccountLedgerEntry."Bal. Account Type"::"G/L Account");
                        //SSM1724<<

                        ExportPayments(CustLedgerEntry, DetailedCustLedgEntry, VendorLedgerEntry, DetailedVendorLedgEntry, BankAccountLedgerEntry, SAFTExportLine);
                    end;
                SAFTExportLine."Type of Line"::"Movement of Goods":
                    begin
                        ItemLedgerEntry.Reset;
                        ItemLedgerEntry.SetCurrentKey("Item No.", "Posting Date");
                        ItemLedgerEntry.SetRange("Posting Date", SAFTExportHeader."Starting Date", ClosingDate(SAFTExportHeader."Ending Date"));
                        ExportMovementOfGoods(ItemLedgerEntry, SAFTExportLine);
                    end;
                SAFTExportLine."Type of Line"::"Asset Transactions":
                    begin
                        FALedgerEntry.Reset;
                        FALedgerEntry.SetCurrentKey("FA No.", "Depreciation Book Code", "FA Posting Date");
                        FALedgerEntry.SetRange("Posting Date", SAFTExportHeader."Starting Date", ClosingDate(SAFTExportHeader."Ending Date"));
                        ExportAssetTransactions(FALedgerEntry, SAFTExportLine);
                    end;
            end;
        //SSM1724 ExportEmptySections(SAFTExportLine,FALSE);
    end;

    local procedure ExportHeader(SAFTExportHeader: Record "SSAFT Export Header"; SAFTExportLine: Record "SSAFT Export Line"; SingleFileExport: Boolean)
    var
        CompanyInformation: Record "Company Information";
        LinesRec: Record "SSAFT Export Line";
        CountryRegion: Record "Country/Region";
        ApplicationSystemConstants: Codeunit "Application System Constants";
        SAFTExportMgt: Codeunit "SSAFT Export Mgt.";
    begin
        SafTXmlHelper.Initialize;
        if GuiAllowed then
            Window.Update(1, GeneratingHeaderMsg);
        CompanyInformation.Get;
        SafTXmlHelper.AddNewXMLNode('Header', '');
        SafTXmlHelper.AppendXMLNode('AuditFileVersion', '2.0');
        CountryRegion.Get(CompanyInformation."Country/Region Code");
        SafTXmlHelper.AppendXMLNode('AuditFileCountry', GetTableMapping(SAFTExportHeader."Mapping Range Code", CountryRegion, GlobalNFTType::"ISO3166-2-CountryCodes"));

        SafTXmlHelper.AppendXMLNode('AuditFileDateCreated', FormatDate(Today));
        SafTXmlHelper.AppendXMLNode('SoftwareCompanyName', 'Microsoft');
        SafTXmlHelper.AppendXMLNode('SoftwareID', ApplicationSystemConstants.ApplicationBuild);
        SafTXmlHelper.AppendXMLNode('SoftwareVersion', ApplicationSystemConstants.ApplicationVersion);

        ExportCompanyInfo(SAFTExportHeader, 'Company');

        SafTXmlHelper.AppendXMLNode('DefaultCurrencyCode', SAFTExportMgt.GetISOCurrencyCode(''));

        SafTXmlHelper.AddNewXMLNode('SelectionCriteria', '');
        SafTXmlHelper.AppendXMLNode('PeriodStart', Format(Date2DMY(SAFTExportHeader."Starting Date", 2)));
        SafTXmlHelper.AppendXMLNode('PeriodStartYear', Format(Date2DMY(SAFTExportHeader."Starting Date", 3)));
        SafTXmlHelper.AppendXMLNode('PeriodEnd', Format(Date2DMY(SAFTExportHeader."Ending Date", 2)));
        SafTXmlHelper.AppendXMLNode('PeriodEndYear', Format(Date2DMY(SAFTExportHeader."Ending Date", 3)));
        SafTXmlHelper.FinalizeXMLNode;

        SafTXmlHelper.AppendXMLNode('HeaderComment', CopyStr(Format(SAFTExportHeader."Header Comment SAFT Type"), 1, 1));

        LinesRec.Reset;
        LinesRec.SetRange(ID, SAFTExportHeader.ID);
        LinesRec.SetRange("Export File", true);
        LinesRec.SetRange(Status, LinesRec.Status::Completed);

        //SSM1724>>
        //OC SafTXmlHelper.AppendXMLNode('SegmentIndex',FORMAT(LinesRec.COUNT + 1));
        SafTXmlHelper.AppendXMLNode('SegmentIndex', Format(SAFTExportLine."Segment Index"));
        //SSM1724<<

        LinesRec.Reset;
        LinesRec.SetRange(ID, SAFTExportHeader.ID);
        LinesRec.SetRange("Export File", true);

        //SSM1724>>
        if SingleFileExport then
            SafTXmlHelper.AppendXMLNode('TotalSegmentsInsequence', Format(SAFTExportLine."Segment Index"))
        else
            SafTXmlHelper.AppendXMLNode('TotalSegmentsInsequence', Format(LinesRec.Count));
        //SSM1724<<

        SafTXmlHelper.AppendXMLNode('TaxAccountingBasis', Format(SAFTExportHeader."Tax Accounting Basis"));
        SafTXmlHelper.FinalizeXMLNode;
    end;

    local procedure ExportCompanyInfo(SAFTExportHeader: Record "SSAFT Export Header"; ParentNodeName: Text)
    var
        CompanyInformation: Record "Company Information";
        Employee: Record Employee;
        CountryRegion: Record "Country/Region";
    begin
        SafTXmlHelper.AddNewXMLNode(ParentNodeName, '');
        CompanyInformation.Get;
        SafTXmlHelper.AppendXMLNode('RegistrationNumber', CompanyInformation."VAT Registration No.");
        SafTXmlHelper.AppendXMLNode('Name', CombineWithSpaceSAFmiddle2textType(CompanyInformation.Name, CompanyInformation."Name 2"));
        CountryRegion.Get(CompanyInformation."Country/Region Code");

        ExportAddress('Address',
          CombineWithSpaceSAFmiddle2textType(CompanyInformation.Address, CompanyInformation."Address 2"),
          CompanyInformation.City,
          CompanyInformation."Post Code",
          GetTableMapping(SAFTExportHeader."Mapping Range Code", CountryRegion, GlobalNFTType::"ISO3166-2-CountryCodes")
          , 'StreetAddress',
          '');

        Employee.Get(CompanyInformation."SSAFT Contact No.");
        ExportContact(
          Employee."First Name",
          Employee."Last Name",
          Employee."Phone No.",
          Employee."Fax No.",
          Employee."E-Mail",
          '',
          Employee."Mobile Phone No.");

        ExportBankAccount(
          GetTableMapping(SAFTExportHeader."Mapping Range Code", CountryRegion, GlobalNFTType::"ISO3166-2-CountryCodes"),
          CompanyInformation."Bank Name",
          CompanyInformation."Bank Account No.",
          CompanyInformation.IBAN,
          CompanyInformation."Bank Branch No.",
          '');
        SafTXmlHelper.FinalizeXMLNode;
    end;

    local procedure ExportAddress(_XMLTag: Text; StreetName: Text; City: Text; PostalCode: Text; Country: Text; AddressType: Text; SAFTCounty: Text)
    begin
        SafTXmlHelper.AddNewXMLNode(_XMLTag, '');
        SafTXmlHelper.AppendXMLNode('City', City);

        SafTXmlHelper.AppendXMLNode('Country', Country);
        SafTXmlHelper.AppendXMLNode('AddressType', AddressType);
        SafTXmlHelper.FinalizeXMLNode;
    end;

    local procedure ExportContact(FirstName: Text; LastName: Text; Telephone: Text; Fax: Text; Email: Text; Website: Text; MobilePhone: Text)
    begin
        if (FirstName = '') or (LastName = '') then
            exit;

        SafTXmlHelper.AddNewXMLNode('Contact', '');
        SafTXmlHelper.AddNewXMLNode('ContactPerson', '');
        SafTXmlHelper.AppendXMLNode('FirstName', FirstName);
        SafTXmlHelper.AppendXMLNode('LastName', LastName);
        SafTXmlHelper.FinalizeXMLNode;

        SafTXmlHelper.AppendXMLNode('Telephone', Telephone);
        SafTXmlHelper.AppendXMLNode('Email', Email);
        SafTXmlHelper.FinalizeXMLNode;
    end;

    local procedure ExportGeneralLedgerAccounts(SAFTExportHeader: Record "SSAFT Export Header")
    var
        SAFTMappingRange: Record "SSAFT Mapping Range";
        SAFTNAVMapping: Record "SSAFT-NAV Mapping";
        TotalNumberOfAccounts: Integer;
        CountOfAccounts: Integer;
    begin
        SAFTMappingRange.Get(SAFTExportHeader."Mapping Range Code");
        SAFTNAVMapping.SetRange("Mapping Range Code", SAFTExportHeader."Mapping Range Code");
        SAFTNAVMapping.SetRange("NFT Type", SAFTMappingRange."Chart of Account NFT");
        SAFTNAVMapping.SetFilter("SAFT Code", '<>%1', '');
        // It's up to date by VerifyMappingIsDone function called from SAFTExportCheck.Codeunit.al right before the actual export
        SAFTNAVMapping.SetRange("G/L Entries Exists", true);
        if not SAFTNAVMapping.FindSet then
            exit;

        SafTXmlHelper.AddNewXMLNode('GeneralLedgerAccounts', '');
        if GuiAllowed then
            TotalNumberOfAccounts := SAFTNAVMapping.Count;
        repeat
            if GuiAllowed then begin
                CountOfAccounts += 1;
                Window.Update(2, Round(100 * (CountOfAccounts / TotalNumberOfAccounts * 100), 1));
            end;
            ExportGLAccount(
              SAFTNAVMapping."NAV Code", SAFTNAVMapping."SAFT Code",
              SAFTExportHeader."Starting Date", SAFTExportHeader."Ending Date");
        until SAFTNAVMapping.Next = 0;
        SafTXmlHelper.FinalizeXMLNode;
    end;

    local procedure ExportGLAccount(NAVGLAccountNo: Code[20]; SAFTAccountID: Code[20]; StartingDate: Date; EndingDate: Date)
    var
        GLAccount: Record "G/L Account";
        SSASAFTMappingHelper: Codeunit "SSAFT Mapping Helper";
        OpeningDebitBalance: Decimal;
        OpeningCreditBalance: Decimal;
        ClosingDebitBalance: Decimal;
        ClosingCreditBalance: Decimal;
    begin
        GLAccount.Get(NAVGLAccountNo);
        GLAccount.SetRange("Date Filter", 0D, ClosingDate(StartingDate - 1));
        GLAccount.CalcFields("Net Change");
        case GLAccount."Debit/Credit" of
            GLAccount."Debit/Credit"::Debit:
                OpeningDebitBalance := GLAccount."Net Change";
            GLAccount."Debit/Credit"::Credit:
                OpeningCreditBalance := -GLAccount."Net Change";
            GLAccount."Debit/Credit"::Both:
                if GLAccount."Net Change" > 0 then
                    OpeningDebitBalance := GLAccount."Net Change"
                else
                    OpeningCreditBalance := -GLAccount."Net Change";
        end;

        GLAccount.SetRange("Date Filter", 0D, ClosingDate(EndingDate));
        GLAccount.CalcFields("Net Change");
        case GLAccount."Debit/Credit" of
            GLAccount."Debit/Credit"::Debit:
                ClosingDebitBalance := GLAccount."Net Change";
            GLAccount."Debit/Credit"::Credit:
                ClosingCreditBalance := -GLAccount."Net Change";
            GLAccount."Debit/Credit"::Both:
                if GLAccount."Net Change" > 0 then
                    ClosingDebitBalance := GLAccount."Net Change"
                else
                    ClosingCreditBalance := -GLAccount."Net Change";
        end;

        //SSM1724>>
        if (ClosingDebitBalance = 0) and (ClosingCreditBalance = 0) and
            (not SSASAFTMappingHelper.GLAccHasEntries(
            NAVGLAccountNo, StartingDate,
            EndingDate, true))

        then
            exit;
        //SSM1724<<

        SafTXmlHelper.AddNewXMLNode('Account', '');
        SafTXmlHelper.AppendXMLNode('AccountID', SAFTAccountID);
        SafTXmlHelper.AppendXMLNode('AccountDescription', GLAccount.Name);
        SafTXmlHelper.AppendXMLNode('StandardAccountID', NAVGLAccountNo);
        case GLAccount."Debit/Credit" of
            GLAccount."Debit/Credit"::Debit:
                SafTXmlHelper.AppendXMLNode('AccountType', 'Activ');
            GLAccount."Debit/Credit"::Credit:
                SafTXmlHelper.AppendXMLNode('AccountType', 'Pasiv');
            GLAccount."Debit/Credit"::Both:
                SafTXmlHelper.AppendXMLNode('AccountType', 'Bifunctional');
        end;
        //SSM1724>>
        /* //OC
        IF OpeningDebitBalance = 0 THEN
          SafTXmlHelper.AppendXMLNode('OpeningCreditBalance',FormatAmount(OpeningCreditBalance))
        ELSE
          SafTXmlHelper.AppendXMLNode('OpeningDebitBalance',FormatAmount(OpeningDebitBalance));
        
        IF ClosingDebitBalance = 0 THEN
          SafTXmlHelper.AppendXMLNode('ClosingCreditBalance',FormatAmount(ClosingCreditBalance))
        ELSE
          SafTXmlHelper.AppendXMLNode('ClosingDebitBalance',FormatAmount(ClosingDebitBalance));
        */
        case GLAccount."Debit/Credit" of
            GLAccount."Debit/Credit"::Debit:
                begin
                    SafTXmlHelper.AppendXMLNode('OpeningDebitBalance', FormatAmount(OpeningDebitBalance));
                    SafTXmlHelper.AppendXMLNode('ClosingDebitBalance', FormatAmount(ClosingDebitBalance));
                end;
            GLAccount."Debit/Credit"::Credit:
                begin
                    SafTXmlHelper.AppendXMLNode('OpeningCreditBalance', FormatAmount(OpeningCreditBalance));
                    SafTXmlHelper.AppendXMLNode('ClosingCreditBalance', FormatAmount(ClosingCreditBalance))
                end;
            GLAccount."Debit/Credit"::Both:
                begin
                    if OpeningDebitBalance = 0 then
                        SafTXmlHelper.AppendXMLNode('OpeningCreditBalance', FormatAmount(OpeningCreditBalance))
                    else
                        SafTXmlHelper.AppendXMLNode('OpeningDebitBalance', FormatAmount(OpeningDebitBalance));

                    if ClosingDebitBalance = 0 then
                        SafTXmlHelper.AppendXMLNode('ClosingCreditBalance', FormatAmount(ClosingCreditBalance))
                    else
                        SafTXmlHelper.AppendXMLNode('ClosingDebitBalance', FormatAmount(ClosingDebitBalance));
                end;

        end;
        //SSM1724<<

        SafTXmlHelper.FinalizeXMLNode;

    end;

    local procedure ExportCustomers(SAFTExportHeader: Record "SSAFT Export Header")
    var
        Customer: Record Customer;
        CustomerPostingGroup: Record "Customer Posting Group";
        TotalNumberOfCustomers: Integer;
        CountOfCustomers: Integer;
    begin
        //Customer.SETFILTER("No.",'CL*'); //test
        if not Customer.FindSet then
            exit;

        SafTXmlHelper.AddNewXMLNode('Customers', '');
        if GuiAllowed then begin
            Window.Update(1, ExportingCustomersMsg);
            TotalNumberOfCustomers := Customer.Count;
        end;

        CustomerPostingGroup.Reset; //SSM1724

        repeat
            if GuiAllowed then begin
                CountOfCustomers += 1;
                Window.Update(2, Round(100 * (CountOfCustomers / TotalNumberOfCustomers * 100), 1));
            end;
            //SSM1724>>
            //OC ExportCustomer(Customer,SAFTExportHeader);
            if CustomerPostingGroup.FindSet then
                repeat
                    ExportCustomer(Customer, SAFTExportHeader, CustomerPostingGroup.Code);
                until CustomerPostingGroup.Next = 0;
        //SSM1724<<
        until Customer.Next = 0;
        SafTXmlHelper.FinalizeXMLNode;
    end;

    local procedure ExportCustomer(Customer: Record Customer; SAFTExportHeader: Record "SSAFT Export Header"; _CPGCode: Code[10])
    var
        SAFTMappingRange: Record "SSAFT Mapping Range";
        CustomerPostingGroup: Record "Customer Posting Group";
        GLAccount: Record "G/L Account";
        CLE: Record "Cust. Ledger Entry";
        CountryRegion: Record "Country/Region";
        OpeningDebitBalance: Decimal;
        OpeningCreditBalance: Decimal;
        ClosingDebitBalance: Decimal;
        ClosingCreditBalance: Decimal;
    begin
        Customer.SetRange("Date Filter", 0D, ClosingDate(SAFTExportHeader."Starting Date" - 1));
        //SSM1724>>
        /*//OC
        Customer.CALCFIELDS("Net Change (LCY)");
        IF Customer."Net Change (LCY)" > 0 THEN
          OpeningDebitBalance := Customer."Net Change (LCY)"
        ELSE
          OpeningCreditBalance := -Customer."Net Change (LCY)";
        Customer.SETRANGE("Date Filter",0D,CLOSINGDATE(SAFTExportHeader."Ending Date"));
        Customer.CALCFIELDS("Net Change (LCY)");
        IF Customer."Net Change (LCY)" > 0 THEN
          ClosingDebitBalance := Customer."Net Change (LCY)"
        ELSE
          ClosingCreditBalance := -Customer."Net Change (LCY)";
        */
        Customer.SetRange("SSA Customer Pstg. Grp. Filter", _CPGCode);
        Customer.CalcFields("SSAFTDebit Amount (LCY) CPG", "SSAFTCredit Amount (LCY) CPG");

        if Abs(Customer."SSAFTDebit Amount (LCY) CPG") - Abs(Customer."SSAFTCredit Amount (LCY) CPG") > 0 then
            OpeningDebitBalance := Customer."SSAFTDebit Amount (LCY) CPG" - Customer."SSAFTCredit Amount (LCY) CPG"
        else
            OpeningCreditBalance := Customer."SSAFTCredit Amount (LCY) CPG" - Customer."SSAFTDebit Amount (LCY) CPG";

        Customer.SetRange("Date Filter", 0D, ClosingDate(SAFTExportHeader."Ending Date"));
        Customer.CalcFields("SSAFTDebit Amount (LCY) CPG", "SSAFTCredit Amount (LCY) CPG");
        if Abs(Customer."SSAFTDebit Amount (LCY) CPG") - Abs(Customer."SSAFTCredit Amount (LCY) CPG") > 0 then
            ClosingDebitBalance := Customer."SSAFTDebit Amount (LCY) CPG" - Customer."SSAFTCredit Amount (LCY) CPG"
        else
            ClosingCreditBalance := Customer."SSAFTCredit Amount (LCY) CPG" - Customer."SSAFTDebit Amount (LCY) CPG";
        //SSM1724<<

        CLE.Reset;
        CLE.SetCurrentKey("Customer No.");
        CLE.SetRange("Customer No.", Customer."No.");
        CLE.SetRange(CLE."Customer Posting Group", _CPGCode); //SSM1724
        CLE.SetRange("Posting Date", SAFTExportHeader."Starting Date", ClosingDate(SAFTExportHeader."Ending Date"));
        if ((ClosingDebitBalance = 0) and (ClosingCreditBalance = 0) and (OpeningDebitBalance = 0) and (OpeningCreditBalance = 0)) and
          (CLE.IsEmpty)
        then
            exit;

        SafTXmlHelper.AddNewXMLNode('Customer', '');
        SafTXmlHelper.AddNewXMLNode('CompanyStructure', '');
        SafTXmlHelper.AppendXMLNode('RegistrationNumber', GetCustomerRegistrationNumber(Customer));
        SafTXmlHelper.AppendXMLNode('Name', CombineWithSpaceSAFmiddle2textType(Customer.Name, Customer."Name 2"));

        CountryRegion.Get(Customer."Country/Region Code");
        ExportAddress('Address',
          CombineWithSpaceSAFmiddle2textType(Customer.Address, Customer."Address 2"), Customer.City,
          Customer."Post Code",
          GetTableMapping(SAFTExportHeader."Mapping Range Code", CountryRegion, GlobalNFTType::"ISO3166-2-CountryCodes"),
          'StreetAddress',
          '');

        SafTXmlHelper.FinalizeXMLNode;

        //SSM1724>>
        /*//OC
        SafTXmlHelper.AppendXMLNode('CustomerID',Customer."No.");
        CustomerPostingGroup.GET(Customer."Customer Posting Group");
        */
        SafTXmlHelper.AppendXMLNode('CustomerID', GetCustomerRegistrationNumber(Customer));
        CustomerPostingGroup.Get(_CPGCode);
        //SSM1724<<

        GLAccount.Get(CustomerPostingGroup."Receivables Account");
        SAFTMappingRange.Get(SAFTExportHeader."Mapping Range Code");
        SafTXmlHelper.AppendXMLNode('AccountID', GetTableMapping(SAFTExportHeader."Mapping Range Code", GLAccount, SAFTMappingRange."Chart of Account NFT"));

        if OpeningDebitBalance = 0 then
            SafTXmlHelper.AppendXMLNode('OpeningCreditBalance', FormatAmount(OpeningCreditBalance))
        else
            SafTXmlHelper.AppendXMLNode('OpeningDebitBalance', FormatAmount(OpeningDebitBalance));
        if ClosingDebitBalance = 0 then
            SafTXmlHelper.AppendXMLNode('ClosingCreditBalance', FormatAmount(ClosingCreditBalance))
        else
            SafTXmlHelper.AppendXMLNode('ClosingDebitBalance', FormatAmount(ClosingDebitBalance));

        SafTXmlHelper.FinalizeXMLNode;

    end;

    local procedure ExportVendors(SAFTExportHeader: Record "SSAFT Export Header")
    var
        Vendor: Record Vendor;
        VendorPostingGroup: Record "Vendor Posting Group";
        PurchSetup: Record "Purchases & Payables Setup";
        TotalNumberOfVendors: Integer;
        CountOfVendors: Integer;
    begin
        PurchSetup.Get;
        if PurchSetup."SSAFT Excl. Vendor Posting Grp" <> '' then
            Vendor.SetFilter("Vendor Posting Group", PurchSetup."SSAFT Excl. Vendor Posting Grp");


        if not Vendor.FindSet then
            exit;

        SafTXmlHelper.AddNewXMLNode('Suppliers', '');
        if GuiAllowed then begin
            Window.Update(1, ExportingVendorsMsg);
            TotalNumberOfVendors := Vendor.Count;
        end;
        repeat
            if GuiAllowed then begin
                CountOfVendors += 1;
                Window.Update(2, Round(100 * (CountOfVendors / TotalNumberOfVendors * 100), 1));
            end;

            VendorPostingGroup.Reset;
            if VendorPostingGroup.FindSet then
                repeat
                    ExportVendor(Vendor, SAFTExportHeader, VendorPostingGroup.Code);
                until VendorPostingGroup.Next = 0;
        until Vendor.Next = 0;
        SafTXmlHelper.FinalizeXMLNode;
    end;

    local procedure ExportVendor(Vendor: Record Vendor; SAFTExportHeader: Record "SSAFT Export Header"; _VPGCode: Code[10])
    var
        VendorPostingGroup: Record "Vendor Posting Group";
        GLAccount: Record "G/L Account";
        SAFTMappingRange: Record "SSAFT Mapping Range";
        VLE: Record "Vendor Ledger Entry";
        CountryRegion: Record "Country/Region";
        OpeningDebitBalance: Decimal;
        OpeningCreditBalance: Decimal;
        ClosingDebitBalance: Decimal;
        ClosingCreditBalance: Decimal;
    begin
        Vendor.SetRange("Date Filter", 0D, ClosingDate(SAFTExportHeader."Starting Date" - 1));

        //SSM1724>>
        /*//OC
        Vendor.CALCFIELDS("Net Change (LCY)");
        IF Vendor."Net Change (LCY)" > 0 THEN
          OpeningDebitBalance := Vendor."Net Change (LCY)"
        ELSE
          OpeningCreditBalance := -Vendor."Net Change (LCY)";
        Vendor.SETRANGE("Date Filter",0D,CLOSINGDATE(SAFTExportHeader."Ending Date"));
        Vendor.CALCFIELDS("Net Change (LCY)");
        IF Vendor."Net Change (LCY)" > 0 THEN
          ClosingDebitBalance := Vendor."Net Change (LCY)"
        ELSE
          ClosingCreditBalance := -Vendor."Net Change (LCY)";
        */

        Vendor.SetRange("SSA Vendor Pstg. Grp. Filter", _VPGCode);
        Vendor.CalcFields("SSAFTDebit Amount (LCY) VPG", "SSAFTCredit Amount (LCY) VPG");

        if Abs(Vendor."SSAFTDebit Amount (LCY) VPG") - Abs(Vendor."SSAFTCredit Amount (LCY) VPG") > 0 then
            OpeningDebitBalance := Vendor."SSAFTDebit Amount (LCY) VPG" - Vendor."SSAFTCredit Amount (LCY) VPG"
        else
            OpeningCreditBalance := Vendor."SSAFTCredit Amount (LCY) VPG" - Vendor."SSAFTDebit Amount (LCY) VPG";

        Vendor.SetRange("Date Filter", 0D, ClosingDate(SAFTExportHeader."Ending Date"));
        Vendor.CalcFields("SSAFTDebit Amount (LCY) VPG", "SSAFTCredit Amount (LCY) VPG");
        if Abs(Vendor."SSAFTDebit Amount (LCY) VPG") - Abs(Vendor."SSAFTCredit Amount (LCY) VPG") > 0 then
            ClosingDebitBalance := Vendor."SSAFTDebit Amount (LCY) VPG" - Vendor."SSAFTCredit Amount (LCY) VPG"
        else
            ClosingCreditBalance := Vendor."SSAFTCredit Amount (LCY) VPG" - Vendor."SSAFTDebit Amount (LCY) VPG";
        //SSM1724<<

        VLE.Reset;
        VLE.SetCurrentKey("Vendor No.");
        VLE.SetRange("Vendor No.", Vendor."No.");
        VLE.SetRange("Vendor Posting Group", _VPGCode); //SSM1724
        VLE.SetRange("Posting Date", SAFTExportHeader."Starting Date", ClosingDate(SAFTExportHeader."Ending Date"));
        if ((ClosingDebitBalance = 0) and (ClosingCreditBalance = 0) and (OpeningDebitBalance = 0) and (OpeningCreditBalance = 0)) and
          (VLE.IsEmpty)
        then
            exit;

        SafTXmlHelper.AddNewXMLNode('Supplier', '');
        SafTXmlHelper.AddNewXMLNode('CompanyStructure', '');
        SafTXmlHelper.AppendXMLNode('RegistrationNumber', GetVendorRegistrationNumber(Vendor));
        SafTXmlHelper.AppendXMLNode('Name', CombineWithSpaceSAFmiddle2textType(Vendor.Name, Vendor."Name 2"));

        CountryRegion.Get(Vendor."Country/Region Code");

        ExportAddress('Address',
          CombineWithSpaceSAFmiddle2textType(Vendor.Address, Vendor."Address 2"), Vendor.City,
          Vendor."Post Code",
          GetTableMapping(SAFTExportHeader."Mapping Range Code", CountryRegion, GlobalNFTType::"ISO3166-2-CountryCodes"),
          'StreetAddress',
          '');

        SafTXmlHelper.FinalizeXMLNode;

        SafTXmlHelper.AppendXMLNode('SupplierID', GetVendorRegistrationNumber(Vendor));
        VendorPostingGroup.Get(_VPGCode);
        GLAccount.Get(VendorPostingGroup."Payables Account");
        SAFTMappingRange.Get(SAFTExportHeader."Mapping Range Code");
        SafTXmlHelper.AppendXMLNode('AccountID', GetTableMapping(SAFTExportHeader."Mapping Range Code", GLAccount, SAFTMappingRange."Chart of Account NFT"));
        if OpeningDebitBalance = 0 then
            SafTXmlHelper.AppendXMLNode('OpeningCreditBalance', FormatAmount(OpeningCreditBalance))
        else
            SafTXmlHelper.AppendXMLNode('OpeningDebitBalance', FormatAmount(OpeningDebitBalance));
        if ClosingDebitBalance = 0 then
            SafTXmlHelper.AppendXMLNode('ClosingCreditBalance', FormatAmount(ClosingCreditBalance))
        else
            SafTXmlHelper.AppendXMLNode('ClosingDebitBalance', FormatAmount(ClosingDebitBalance));
        SafTXmlHelper.FinalizeXMLNode;

    end;

    local procedure ExportTaxTable(SAFTExportHeader: Record "SSAFT Export Header")
    var
        SAFTNAVMapping: Record "SSAFT-NAV Mapping";
        SAFTMappingRange: Record "SSAFT Mapping Range";
    begin
        if GuiAllowed then
            Window.Update(1, ExportingVATPostingSetupMsg);
        SafTXmlHelper.AddNewXMLNode('TaxTable', '');

        //Tax TVA

        SafTXmlHelper.AddNewXMLNode('TaxTableEntry', '');
        SafTXmlHelper.AppendXMLNode('TaxType', GetVATTaxType(SAFTExportHeader));
        SafTXmlHelper.AppendXMLNode('Description', 'TVA');
        ExportTaxCodeDetails('', SAFTExportHeader, true);
        SAFTMappingRange.Get(SAFTExportHeader."Mapping Range Code");
        if SAFTMappingRange."Inchidere TVA Tax Code" <> '' then
            ExportTaxCodeDetails(SAFTMappingRange."Inchidere TVA Tax Code", SAFTExportHeader, true);
        SafTXmlHelper.FinalizeXMLNode;

        //Tax WHT
        SAFTNAVMapping.Reset;
        SAFTNAVMapping.SetCurrentKey("SAFT Code");
        SAFTNAVMapping.SetRange("Mapping Range Code", SAFTExportHeader."Mapping Range Code");
        SAFTNAVMapping.SetRange("NFT Type", SAFTNAVMapping."NFT Type"::"WHT - nomenclator");
        if SAFTNAVMapping.FindSet then
            repeat
                SAFTNAVMapping.SetFilter("SAFT Code", StrSubstNo('%1*', CopyStr(SAFTNAVMapping."SAFT Code", 1, 3)));
                SafTXmlHelper.AddNewXMLNode('TaxTableEntry', '');
                SafTXmlHelper.AppendXMLNode('TaxType', CopyStr(SAFTNAVMapping."SAFT Code", 1, 3));
                SafTXmlHelper.AppendXMLNode('Description', SAFTNAVMapping."SAFT Description");
                ExportTaxCodeDetails(SAFTNAVMapping."SAFT Code", SAFTExportHeader, false);
                SafTXmlHelper.FinalizeXMLNode;
                SAFTNAVMapping.FindLast;
                SAFTNAVMapping.SetRange("SAFT Code");
            until SAFTNAVMapping.Next = 0;

        //Tax IMP
        SAFTNAVMapping.Reset;
        SAFTNAVMapping.SetCurrentKey("SAFT Code");
        SAFTNAVMapping.SetRange("Mapping Range Code", SAFTExportHeader."Mapping Range Code");
        SAFTNAVMapping.SetRange("NFT Type", SAFTNAVMapping."NFT Type"::"TAX-IMP - Impozite");
        if SAFTNAVMapping.FindSet then
            repeat
                SAFTNAVMapping.SetFilter("SAFT Code", StrSubstNo('%1*', CopyStr(SAFTNAVMapping."SAFT Code", 1, 3)));
                SafTXmlHelper.AddNewXMLNode('TaxTableEntry', '');
                SafTXmlHelper.AppendXMLNode('TaxType', CopyStr(SAFTNAVMapping."SAFT Code", 1, 3));
                SafTXmlHelper.AppendXMLNode('Description', SAFTNAVMapping."SAFT Description");
                ExportTaxCodeDetails('000000', SAFTExportHeader, false);
                SafTXmlHelper.FinalizeXMLNode;
                SAFTNAVMapping.FindLast;
                SAFTNAVMapping.SetRange("SAFT Code");
            until SAFTNAVMapping.Next = 0;
        SafTXmlHelper.FinalizeXMLNode;
    end;

    local procedure ExportTaxCodeDetails(_WHTCode: Code[10]; SAFTExportHeader: Record "SSAFT Export Header"; _VAT: Boolean)
    var
        VATPostingSetup: Record "VAT Posting Setup";
        SAFTNAVMapping: Record "SSAFT-NAV Mapping";
    begin
        if _VAT then begin
            if _WHTCode = '' then begin
                VATPostingSetup.SetFilter("SSAFT Tax Code", '<>%1', '');
                if not VATPostingSetup.FindSet then
                    exit;
                repeat
                    ExportTaxCodeDetail(
                      VATPostingSetup."SSAFT Tax Code", VATPostingSetup.Description, VATPostingSetup."VAT %",
                      VATPostingSetup."SSAFT Deductibilitate %");
                until VATPostingSetup.Next = 0;
            end else
                ExportTaxCodeDetail(_WHTCode, 'Nota Inchidere TVA', -1, 0);
        end else begin
            SAFTNAVMapping.Reset;
            SAFTNAVMapping.SetRange("Mapping Range Code", SAFTExportHeader."Mapping Range Code");
            SAFTNAVMapping.SetRange("NFT Type", SAFTNAVMapping."NFT Type"::"WHT - nomenclator");
            SAFTNAVMapping.SetFilter("SAFT Code", StrSubstNo('%1*', CopyStr(_WHTCode, 1, 3)));
            if SAFTNAVMapping.FindSet then
                repeat
                    ExportTaxCodeDetail(SAFTNAVMapping."SAFT Code", SAFTNAVMapping."SAFT Description", SAFTNAVMapping."WHT Tax Percent", 0)
                until SAFTNAVMapping.Next = 0
            else
                ExportTaxCodeDetail('000000', '', 0, 0);
        end;
    end;

    local procedure ExportTaxCodeDetail(SAFTTaxCode: Code[10]; Description: Text; VATRate: Decimal; VATDeductionRate: Decimal)
    var
        CompanyInformation: Record "Company Information";
    begin
        SafTXmlHelper.AddNewXMLNode('TaxCodeDetails', '');
        SafTXmlHelper.AppendXMLNode('TaxCode', SAFTTaxCode);
        SafTXmlHelper.AppendXMLNode('Description', Description);
        SafTXmlHelper.AppendXMLNode('TaxPercentage', FormatAmount(VATRate));
        if VATDeductionRate = 0 then
            VATDeductionRate := 100;
        SafTXmlHelper.AppendXMLNode('BaseRate', FormatAmount(VATDeductionRate / 100));
        CompanyInformation.Get;
        SafTXmlHelper.AppendXMLNode('Country', CompanyInformation."Country/Region Code");

        SafTXmlHelper.FinalizeXMLNode;
    end;

    local procedure ExportTUOMTable(SAFTExportHeader: Record "SSAFT Export Header")
    var
        SAFTNAVMapping: Record "SSAFT-NAV Mapping";
    begin
        if GuiAllowed then
            Window.Update(1, 'Export UOM');
        SafTXmlHelper.AddNewXMLNode('UOMTable', '');

        SAFTNAVMapping.Reset;
        SAFTNAVMapping.SetRange("Mapping Range Code", SAFTExportHeader."Mapping Range Code");
        SAFTNAVMapping.SetRange("NFT Type", SAFTNAVMapping."NFT Type"::Unitati_masura);
        SAFTNAVMapping.SetFilter("SAFT Code", '<>%1', '');
        if SAFTNAVMapping.FindSet then
            repeat
                SafTXmlHelper.AddNewXMLNode('UOMTableEntry', '');
                SafTXmlHelper.AppendXMLNode('UnitOfMeasure', SAFTNAVMapping."SAFT Code");
                SafTXmlHelper.AppendXMLNode('Description', SAFTNAVMapping."NAV Description");
                SafTXmlHelper.FinalizeXMLNode;
            until SAFTNAVMapping.Next = 0;

        SafTXmlHelper.FinalizeXMLNode;
    end;

    local procedure ExportAnalysisTypeTable(SAFTExportHeader: Record "SSAFT Export Header")
    var
        Dimension: Record Dimension;
        DimensionValue: Record "Dimension Value";
        LastDimensionCode: Code[20];
    begin
        if not DimensionValue.FindSet then
            exit;

        if GuiAllowed then
            Window.Update(1, ExportingDimensionsMsg);
        SafTXmlHelper.AddNewXMLNode('AnalysisTypeTable', '');
        repeat
            if LastDimensionCode <> DimensionValue."Dimension Code" then begin
                Dimension.Get(DimensionValue."Dimension Code");
                LastDimensionCode := Dimension.Code;
            end;
            if Dimension."SSAFT Export" then begin
                SafTXmlHelper.AddNewXMLNode('AnalysisTypeTableEntry', '');
                SafTXmlHelper.AppendXMLNode('AnalysisType', Dimension."SSAFT Analysis Type");
                SafTXmlHelper.AppendXMLNode('AnalysisTypeDescription', Dimension.Name);
                SafTXmlHelper.AppendXMLNode('AnalysisID', DimensionValue.Code);
                if DimensionValue.Name = '' then
                    SafTXmlHelper.AppendXMLNode('AnalysisIDDescription', DimensionValue.Code) //test
                else
                    SafTXmlHelper.AppendXMLNode('AnalysisIDDescription', DimensionValue.Name);
                SafTXmlHelper.FinalizeXMLNode;
            end;
        until DimensionValue.Next = 0;
        SafTXmlHelper.FinalizeXMLNode;
    end;

    local procedure ExportMovementTypeTable(SAFTExportHeader: Record "SSAFT Export Header")
    var
        SAFTNAVMapping: Record "SSAFT-NAV Mapping";
    begin
        if GuiAllowed then
            Window.Update(1, ExportingMovement);
        SafTXmlHelper.AddNewXMLNode('MovementTypeTable', '');

        SAFTNAVMapping.Reset;
        SAFTNAVMapping.SetRange("Mapping Range Code", SAFTExportHeader."Mapping Range Code");
        SAFTNAVMapping.SetRange("NFT Type", SAFTNAVMapping."NFT Type"::"Nomenclator stocuri");
        SAFTNAVMapping.SetFilter("SAFT Code", '<>%1', '');
        if SAFTNAVMapping.FindSet then
            repeat
                SafTXmlHelper.AddNewXMLNode('MovementTypeTableEntry', '');
                SafTXmlHelper.AppendXMLNode('MovementType', SAFTNAVMapping."SAFT Code");
                SafTXmlHelper.AppendXMLNode('Description', SAFTNAVMapping."SAFT Description");
                SafTXmlHelper.FinalizeXMLNode;
            until SAFTNAVMapping.Next = 0;

        SafTXmlHelper.FinalizeXMLNode;
    end;

    local procedure ExportProducts(SAFTExportHeader: Record "SSAFT Export Header")
    var
        Item: Record Item;
        TotalNumberOfItems: Integer;
        CountOfItems: Integer;
    begin
        Item.SetFilter(Type, '<>%1', Item.Type::Service);
        if not Item.FindSet then
            exit;

        SafTXmlHelper.AddNewXMLNode('Products', '');
        if GuiAllowed then begin
            Window.Update(1, ExportingProductsMsg);
            TotalNumberOfItems := Item.Count;
        end;

        repeat
            if GuiAllowed then begin
                CountOfItems += 1;
                Window.Update(2, Round(100 * (CountOfItems / TotalNumberOfItems * 100), 1));
            end;
            ExportProduct(Item, SAFTExportHeader);
        until Item.Next = 0;
        SafTXmlHelper.FinalizeXMLNode;
    end;

    local procedure ExportProduct(Item: Record Item; SAFTExportHeader: Record "SSAFT Export Header")
    var
        TariffNumber: Record "Tariff Number";
        UnitofMeasure: Record "Unit of Measure";
        OpeningBalance: Decimal;
        ClosingBalance: Decimal;
    begin
        Item.SetRange("Date Filter", 0D, ClosingDate(SAFTExportHeader."Starting Date" - 1));
        Item.CalcFields("Net Change");
        OpeningBalance := Item."Net Change";

        Item.SetRange("Date Filter", 0D, ClosingDate(SAFTExportHeader."Ending Date"));
        Item.CalcFields("Net Change");
        ClosingBalance := Item."Net Change";
        if (ClosingBalance = 0) and (OpeningBalance = 0) and (not ExistsItemLedgerEntryPeriod(Item."No.", '', SAFTExportHeader)) then
            exit;

        SafTXmlHelper.AddNewXMLNode('Product', '');
        SafTXmlHelper.AppendXMLNode('ProductCode', Item."No.");
        SafTXmlHelper.AppendXMLNode('Description', CombineWithSpaceSAFSAFlongtextType(Item.Description, Item."Description 2"));

        if Item."Tariff No." <> '' then begin
            TariffNumber.Get(Item."Tariff No.");
            SafTXmlHelper.AppendXMLNode('ProductCommodityCode', GetTableMapping(SAFTExportHeader."Mapping Range Code", TariffNumber, GlobalNFTType::NC8_2021_TARIC3));
        end else
            SafTXmlHelper.AppendXMLNode('ProductCommodityCode', '0');

        UnitofMeasure.Get(Item."Base Unit of Measure");

        SafTXmlHelper.AppendXMLNode('UOMBase', GetTableMapping(SAFTExportHeader."Mapping Range Code", UnitofMeasure, GlobalNFTType::Unitati_masura));
        SafTXmlHelper.AppendXMLNode('UOMStandard', GetTableMapping(SAFTExportHeader."Mapping Range Code", UnitofMeasure, GlobalNFTType::Unitati_masura));
        SafTXmlHelper.AppendXMLNode('UOMToUOMBaseConversionFactor', '1');

        SafTXmlHelper.FinalizeXMLNode;
    end;

    local procedure ExportPhysicalStockEntries(SAFTExportHeader: Record "SSAFT Export Header")
    var
        Item: Record Item;
        Location: Record Location;
        TotalNumberOfItems: Integer;
        CountOfItems: Integer;
    begin
        if not Item.FindSet then
            exit;

        Location.SetRange("SSAFT Do Not Export", false);

        SafTXmlHelper.AddNewXMLNode('PhysicalStock', '');

        if GuiAllowed then begin
            Window.Update(1, ExportingPhysicalStock);
            TotalNumberOfItems := Item.Count;
        end;

        repeat
            if Location.FindSet then
                repeat
                    CalcPhysicalStock(Item, SAFTExportHeader, Location.Code);
                until Location.Next = 0
            else
                Error('Export PhysicalStock');

            if GuiAllowed then begin
                CountOfItems += 1;
                Window.Update(2, Round(100 * (CountOfItems / TotalNumberOfItems * 100), 1));
            end;
        until Item.Next = 0;

        SafTXmlHelper.FinalizeXMLNode;
    end;

    local procedure CalcPhysicalStock(_Item: Record Item; _SAFTExportHeader: Record "SSAFT Export Header"; _LocationCode: Code[10])
    var
        ValueEntry: Record "Value Entry";
        OpeningQty: Decimal;
        ClosingQty: Decimal;
        OpeningStockValue: Decimal;
        ClosingStockValue: Decimal;
    begin
        _Item.SetRange("Date Filter", 0D, ClosingDate(_SAFTExportHeader."Starting Date" - 1));
        _Item.SetRange("Location Filter", _LocationCode);
        _Item.CalcFields("Net Change");
        OpeningQty := _Item."Net Change";

        _Item.SetRange("Date Filter", 0D, ClosingDate(_SAFTExportHeader."Ending Date"));
        _Item.CalcFields("Net Change");
        ClosingQty := _Item."Net Change";
        if (ClosingQty = 0) and (OpeningQty = 0) and (not ExistsItemLedgerEntryPeriod(_Item."No.", _LocationCode, _SAFTExportHeader)) then
            exit;

        ValueEntry.Reset;
        ValueEntry.SetCurrentKey("Item No.", "Posting Date", "Item Ledger Entry Type", "Entry Type", "Variance Type", "Item Charge No.", "Location Code", "Variant Code");

        ValueEntry.SetRange("Item No.", _Item."No.");
        ValueEntry.SetFilter("Location Code", _LocationCode);
        ValueEntry.SetRange("Posting Date", 0D, ClosingDate(_SAFTExportHeader."Starting Date" - 1));
        ValueEntry.CalcSums("Cost Amount (Actual)", "Cost Amount (Expected)");
        OpeningStockValue := ValueEntry."Cost Amount (Actual)" + ValueEntry."Cost Amount (Expected)";

        ValueEntry.SetRange("Posting Date", 0D, ClosingDate(_SAFTExportHeader."Starting Date" - 1));
        ValueEntry.CalcSums("Cost Amount (Actual)", "Cost Amount (Expected)");
        ClosingStockValue := ValueEntry."Cost Amount (Actual)" + ValueEntry."Cost Amount (Expected)";

        ExportPhysicalStock(_Item, _LocationCode, _SAFTExportHeader."Mapping Range Code", OpeningQty, OpeningStockValue, ClosingQty, ClosingStockValue);
    end;

    local procedure ExportPhysicalStock(_Item: Record Item; _LocationCode: Code[10]; _MappingRangeCode: Code[20]; _OpeningQty: Decimal; _OpeningValue: Decimal; _ClosingQty: Decimal; _ClosingValue: Decimal)
    var
        CompanyInfo: Record "Company Information";
        GenProductPostingGroup: Record "Gen. Product Posting Group";
        TariffNumber: Record "Tariff Number";
        UnitofMeasure: Record "Unit of Measure";
    begin
        CompanyInfo.Get;
        GenProductPostingGroup.Get(_Item."Gen. Prod. Posting Group");
        UnitofMeasure.Get(_Item."Base Unit of Measure");

        SafTXmlHelper.AddNewXMLNode('PhysicalStockEntry', '');

        SafTXmlHelper.AppendXMLNode('WarehouseID', _LocationCode);
        SafTXmlHelper.AppendXMLNode('ProductCode', _Item."No.");
        SafTXmlHelper.AppendXMLNode('ProductType', CombineWithSpaceSAFshorttextType(GenProductPostingGroup.Description, ''));
        if _Item."Tariff No." <> '' then begin
            TariffNumber.Get(_Item."Tariff No.");
            SafTXmlHelper.AppendXMLNode('StockAccountCommodityCode', GetTableMapping(_MappingRangeCode, TariffNumber, GlobalNFTType::NC8_2021_TARIC3));
        end else
            SafTXmlHelper.AppendXMLNode('StockAccountCommodityCode', '0');

        SafTXmlHelper.AppendXMLNode('OwnerID', '00' + CompanyInfo."VAT Registration No.");
        SafTXmlHelper.AppendXMLNode('UOMPhysicalStock', GetTableMapping(_MappingRangeCode, UnitofMeasure, GlobalNFTType::Unitati_masura));
        SafTXmlHelper.AppendXMLNode('UOMToUOMBaseConversionFactor', '1');
        if _ClosingQty <> 0 then
            SafTXmlHelper.AppendXMLNode('UnitPrice', FormatAmount(Round(_ClosingValue / _ClosingQty, 0.01)))
        else
            SafTXmlHelper.AppendXMLNode('UnitPrice', FormatAmount(0));
        SafTXmlHelper.AppendXMLNode('OpeningStockQuantity', FormatAmount(Round(_OpeningQty, 0.01)));
        SafTXmlHelper.AppendXMLNode('OpeningStockValue', FormatAmount(Round(_OpeningValue, 0.01)));
        SafTXmlHelper.AppendXMLNode('ClosingStockQuantity', FormatAmount(Round(_ClosingQty, 0.01)));
        SafTXmlHelper.AppendXMLNode('ClosingStockValue', FormatAmount(Round(_ClosingValue, 0.01)));

        SafTXmlHelper.AddNewXMLNode('StockCharacteristics', '');
        SafTXmlHelper.AppendXMLNode('StockCharacteristic', '0');
        SafTXmlHelper.AppendXMLNode('StockCharacteristicValue', '0');
        SafTXmlHelper.FinalizeXMLNode;

        SafTXmlHelper.FinalizeXMLNode;
    end;

    local procedure ExportAssets(SAFTExportHeader: Record "SSAFT Export Header")
    var
        FixedAsset: Record "Fixed Asset";
        TotalNumberOfItems: Integer;
        CountOfItems: Integer;
    begin
        if not FixedAsset.FindSet then
            exit;

        SafTXmlHelper.AddNewXMLNode('Assets', '');
        if GuiAllowed then begin
            Window.Update(1, ExportingAssetsMsg);
            TotalNumberOfItems := FixedAsset.Count;
        end;

        repeat
            if GuiAllowed then begin
                CountOfItems += 1;
                Window.Update(2, Round(100 * (CountOfItems / TotalNumberOfItems * 100), 1));
            end;
            ExportAsset(FixedAsset, SAFTExportHeader);
        until FixedAsset.Next = 0;
        SafTXmlHelper.FinalizeXMLNode;
    end;

    local procedure ExportAsset(FixedAsset: Record "Fixed Asset"; SAFTExportHeader: Record "SSAFT Export Header")
    var
        FASetup: Record "FA Setup";
        FADepreciationBook: Record "FA Depreciation Book";
        GLAccount: Record "G/L Account";
        FAPostingGroup: Record "FA Posting Group";
        SAFTMappingRange: Record "SSAFT Mapping Range";
        FALedgerEntry: Record "FA Ledger Entry";
        AcquisitionDate: Date;
        AcquisitionAndProductionCostsBegin: Decimal;
        AcquisitionAndProductionCostsEnd: Decimal;
        InvestmentSupport: Decimal;
        BookValueBegin: Decimal;
        BookValueonDisposal: Decimal;
        DepreciationForPeriod: Decimal;
        AppreciationForPeriod: Decimal;
        AccumulatedDepreciation: Decimal;
        BookValueEnd: Decimal;
        ExtraordinaryDepreciationAmountForPeriod: Decimal;
    begin
        FASetup.GET;

        FASetup.TESTFIELD("SSAFT Posting Group Filter");
        FADepreciationBook.SETRANGE("FA No.", FixedAsset."No.");
        FADepreciationBook.SETFILTER("FA Posting Group", FASetup."SSAFT Posting Group Filter");
        FADepreciationBook.SETFILTER("Disposal Date", '%1|>=%2', 0D, SAFTExportHeader."Starting Date");
        if not FADepreciationBook.FINDFIRST then
            exit;

        FADepreciationBook.SETRANGE("FA Posting Date Filter", 0D, CLOSINGDATE(SAFTExportHeader."Starting Date" - 1));
        FADepreciationBook.CALCFIELDS("Book Value");

        //Sum("FA Ledger Entry".Amount WHERE (FA No.=FIELD(FA No.),Depreciation Book Code=FIELD(Depreciation Book Code),Part of Book Value=CONST(true),FA Posting Date=FIELD(FA Posting Date Filter)))
        FALedgerEntry.RESET;
        FALedgerEntry.SETCURRENTKEY("FA No.", "Depreciation Book Code", "FA Posting Category", "FA Posting Type", "FA Posting Date", "Part of Book Value", "Reclassification Entry");
        FALedgerEntry.SETRANGE("FA No.", FixedAsset."No.");
        FALedgerEntry.SETRANGE("Depreciation Book Code", FADepreciationBook."Depreciation Book Code");
        FALedgerEntry.SETRANGE("FA Posting Date", 0D, CLOSINGDATE(SAFTExportHeader."Starting Date" - 1));
        FALedgerEntry.SETFILTER("FA Posting Group", FASetup."SSAFT Posting Group Filter");
        FALedgerEntry.SETRANGE("Part of Book Value", true);
        FALedgerEntry.SETRANGE("FA Posting Category", FALedgerEntry."FA Posting Category"::" ");
        FALedgerEntry.CALCSUMS(Amount);
        BookValueBegin := FALedgerEntry.Amount;
        FALedgerEntry.SETRANGE("Part of Book Value");

        if BookValueBegin = 0 then begin
            FALedgerEntry.SETRANGE("FA Posting Category", FALedgerEntry."FA Posting Category"::Disposal);
            if FALedgerEntry.FINDFIRST then
                exit;

            FADepreciationBook.SETRANGE("FA Posting Date Filter", 0D, CLOSINGDATE(SAFTExportHeader."Ending Date")); //SSM2590
            FADepreciationBook.CALCFIELDS("Acquisition Cost");
            if FADepreciationBook."Acquisition Cost" = 0 then
                exit;
        end;

        FAPostingGroup.GET(FADepreciationBook."FA Posting Group");
        GLAccount.GET(FAPostingGroup."Acquisition Cost Account");
        SAFTMappingRange.GET(SAFTExportHeader."Mapping Range Code");

        FALedgerEntry.SETRANGE("FA Posting Date");
        FALedgerEntry.SETRANGE("FA Posting Category");
        FALedgerEntry.FINDFIRST;
        AcquisitionDate := FALedgerEntry."Posting Date";

        FALedgerEntry.SETRANGE("Posting Date", 0D, CLOSINGDATE(SAFTExportHeader."Starting Date" - 1));
        FALedgerEntry.SETFILTER("FA Posting Type", '%1|%2', FALedgerEntry."FA Posting Type"::"Acquisition Cost", FALedgerEntry."FA Posting Type"::"Write-Down");
        FALedgerEntry.CALCSUMS(Amount);
        AcquisitionAndProductionCostsBegin := FALedgerEntry.Amount;

        FALedgerEntry.SETRANGE("Posting Date", 0D, CLOSINGDATE(SAFTExportHeader."Ending Date"));
        FALedgerEntry.CALCSUMS(Amount);
        AcquisitionAndProductionCostsEnd := FALedgerEntry.Amount;

        FALedgerEntry.SETRANGE("Posting Date", SAFTExportHeader."Starting Date", CLOSINGDATE(SAFTExportHeader."Ending Date"));
        FALedgerEntry.CALCSUMS(Amount);
        InvestmentSupport := FALedgerEntry.Amount;

        FALedgerEntry.SETRANGE("Posting Date", SAFTExportHeader."Starting Date", CLOSINGDATE(SAFTExportHeader."Ending Date"));
        FALedgerEntry.SETRANGE("FA Posting Category", FALedgerEntry."FA Posting Category"::Disposal);
        FALedgerEntry.SETRANGE("FA Posting Type", FALedgerEntry."FA Posting Type"::"Acquisition Cost");
        FALedgerEntry.CALCSUMS(Amount);
        BookValueonDisposal := FALedgerEntry.Amount;


        FADepreciationBook.SETRANGE("FA Posting Date Filter", SAFTExportHeader."Starting Date", CLOSINGDATE(SAFTExportHeader."Ending Date"));
        FADepreciationBook.CALCFIELDS(Depreciation, Appreciation, "Write-Down");
        DepreciationForPeriod := FADepreciationBook.Depreciation;
        AppreciationForPeriod := FADepreciationBook.Appreciation;
        ExtraordinaryDepreciationAmountForPeriod := FADepreciationBook."Write-Down";

        FALedgerEntry.SETRANGE("Posting Date", 0D, CLOSINGDATE(SAFTExportHeader."Ending Date"));
        FALedgerEntry.SETFILTER("FA Posting Category", '%1|%2', FALedgerEntry."FA Posting Category"::" ", FALedgerEntry."FA Posting Category"::Disposal);
        FALedgerEntry.SETRANGE("FA Posting Type", FALedgerEntry."FA Posting Type"::Depreciation);
        FALedgerEntry.CALCSUMS(Amount);
        AccumulatedDepreciation := FALedgerEntry.Amount;

        FALedgerEntry.SETRANGE("FA Posting Type");
        FALedgerEntry.SETFILTER("FA Posting Category", '%1|%2', FALedgerEntry."FA Posting Category"::" ", FALedgerEntry."FA Posting Category"::Disposal);
        FALedgerEntry.SETRANGE("FA Posting Date", 0D, CLOSINGDATE(SAFTExportHeader."Ending Date"));
        FALedgerEntry.SETFILTER("FA Posting Group", FASetup."SSAFT Posting Group Filter");
        FALedgerEntry.SETFILTER("FA Posting Type", '%1|%2', FALedgerEntry."FA Posting Type"::"Acquisition Cost", FALedgerEntry."FA Posting Type"::Depreciation);
        FALedgerEntry.CALCSUMS(Amount);
        BookValueEnd := FALedgerEntry.Amount;
        FALedgerEntry.SETRANGE("Part of Book Value");

        SafTXmlHelper.AddNewXMLNode('Asset', '');
        SafTXmlHelper.AppendXMLNode('AssetID', FixedAsset."No.");
        SafTXmlHelper.AppendXMLNode('AccountID', GetTableMapping(SAFTExportHeader."Mapping Range Code", GLAccount, SAFTMappingRange."Chart of Account NFT"));
        SafTXmlHelper.AppendXMLNode('Description', CombineWithSpaceSAFSAFlongtextType(FixedAsset.Description, FixedAsset."Description 2"));
        SafTXmlHelper.AppendXMLNode('DateOfAcquisition', FormatDate(AcquisitionDate));
        SafTXmlHelper.AppendXMLNode('StartUpDate', FormatDate(FADepreciationBook."Depreciation Starting Date"));

        SafTXmlHelper.AddNewXMLNode('Valuations', '');
        SafTXmlHelper.AddNewXMLNode('Valuation', '');
        SafTXmlHelper.AppendXMLNode('AssetValuationType', 'contabil');

        SafTXmlHelper.AppendXMLNode('ValuationClass', FixedAsset."FA Subclass Code");

        SafTXmlHelper.AppendXMLNode('AcquisitionAndProductionCostsBegin', FormatAmount(AcquisitionAndProductionCostsBegin));
        SafTXmlHelper.AppendXMLNode('AcquisitionAndProductionCostsEnd', FormatAmount(AcquisitionAndProductionCostsEnd));
        CLEAR(InvestmentSupport);
        SafTXmlHelper.AppendXMLNode('InvestmentSupport', FormatAmount(InvestmentSupport));
        SafTXmlHelper.AppendXMLNode('AssetLifeMonth', FormatAmount(FADepreciationBook."No. of Depreciation Months"));
        SafTXmlHelper.AppendXMLNode('AssetAddition', FormatAmount(0));
        SafTXmlHelper.AppendXMLNode('Transfers', FormatAmount(0));
        SafTXmlHelper.AppendXMLNode('AssetDisposal', FormatAmount(BookValueonDisposal));
        SafTXmlHelper.AppendXMLNode('BookValueBegin', FormatAmount(BookValueBegin));
        SafTXmlHelper.AppendXMLNode('DepreciationMethod', FORMAT(FADepreciationBook."Depreciation Method"));
        if FADepreciationBook."No. of Depreciation Months" = 0 then
            SafTXmlHelper.AppendXMLNode('DepreciationPercentage', FormatAmount(0))
        else
            SafTXmlHelper.AppendXMLNode('DepreciationPercentage', FormatAmount(100 / FADepreciationBook."No. of Depreciation Months"));
        SafTXmlHelper.AppendXMLNode('DepreciationForPeriod', FormatAmount(DepreciationForPeriod));
        SafTXmlHelper.AppendXMLNode('AppreciationForPeriod', FormatAmount(AppreciationForPeriod));

        SafTXmlHelper.AddNewXMLNode('ExtraordinaryDepreciationsForPeriod', '');
        SafTXmlHelper.AddNewXMLNode('ExtraordinaryDepreciationForPeriod', '');
        SafTXmlHelper.AppendXMLNode('ExtraordinaryDepreciationMethod', FADepreciationBook.FIELDCAPTION("Write-Down"));
        SafTXmlHelper.AppendXMLNode('ExtraordinaryDepreciationAmountForPeriod', FormatAmount(ExtraordinaryDepreciationAmountForPeriod));
        SafTXmlHelper.FinalizeXMLNode;
        SafTXmlHelper.FinalizeXMLNode;

        SafTXmlHelper.AppendXMLNode('AccumulatedDepreciation', FormatAmount(AccumulatedDepreciation));
        SafTXmlHelper.AppendXMLNode('BookValueEnd', FormatAmount(BookValueEnd));

        SafTXmlHelper.FinalizeXMLNode;
        SafTXmlHelper.FinalizeXMLNode;
        SafTXmlHelper.FinalizeXMLNode;
    end;

    local procedure ExportGeneralLedgerEntries(var GLEntry: Record "G/L Entry"; var SAFTExportLine: Record "SSAFT Export Line")
    var
        SourceCode: Record "Source Code";
        SAFTExportHeader: Record "SSAFT Export Header";
        SAFTMappingRange: Record "SSAFT Mapping Range";
        GLEntryProgressStep: Decimal;
        GLEntryProgress: Decimal;
    begin
        GLEntry.CalcSums("Debit Amount", "Credit Amount");
        SafTXmlHelper.AddNewXMLNode('GeneralLedgerEntries', '');
        SafTXmlHelper.AppendXMLNode('NumberOfEntries', Format(GLEntry.Count));
        SafTXmlHelper.AppendXMLNode('TotalDebit', FormatAmount(GLEntry."Debit Amount"));
        SafTXmlHelper.AppendXMLNode('TotalCredit', FormatAmount(GLEntry."Credit Amount"));
        if GLEntry.IsEmpty then begin
            SafTXmlHelper.FinalizeXMLNode;
            exit;
        end;

        if GuiAllowed then
            Window.Update(1, ExportingGLEntriesMsg);

        GLEntryProgressStep := Round(10000 / SourceCode.Count, 1, '<');

        SAFTExportHeader.Get(SAFTExportLine.ID);
        SAFTMappingRange.Get(SAFTExportHeader."Mapping Range Code");

        if SourceCode.FindSet() then
            repeat
                GLEntryProgress += GLEntryProgressStep;
                if GuiAllowed() then
                    Window.Update(2, GLEntryProgress);
                if ExportGLEntriesBySourceCodeBuffer(SourceCode, GLEntry, SAFTMappingRange, SAFTExportHeader) then begin
                    SAFTExportLine.Get(SAFTExportLine.ID, SAFTExportLine."Line No.");
                    SAFTExportLine.LockTable();
                    SAFTExportLine.Validate(Progress, GLEntryProgress);
                    SAFTExportLine.Modify(true);
                    Commit();
                end;
            until SourceCode.Next() = 0;

        Clear(SourceCode);
        SourceCode.Code := '';
        SourceCode.Description := 'JNLGEN2';

        GLEntryProgress += GLEntryProgressStep;
        if GuiAllowed() then
            Window.Update(2, GLEntryProgress);
        if ExportGLEntriesBySourceCodeBuffer(SourceCode, GLEntry, SAFTMappingRange, SAFTExportHeader) then begin
            SAFTExportLine.Get(SAFTExportLine.ID, SAFTExportLine."Line No.");
            SAFTExportLine.LockTable();
            SAFTExportLine.Validate(Progress, GLEntryProgress);
            SAFTExportLine.Modify(true);
            Commit();
        end;
        SafTXmlHelper.FinalizeXMLNode;
    end;

    local procedure ExportGLEntriesBySourceCodeBuffer(var SourceCode: Record "Source Code"; var GLEntry: Record "G/L Entry"; SAFTMappingRange: Record "SSAFT Mapping Range"; SAFTExportHeader: Record "SSAFT Export Header"): Boolean
    var
        GLEntriesExists: Boolean;
    begin
        GLEntry.SetFilter("Source Code", '=%1', SourceCode.Code);
        GLEntriesExists := GLEntry.FindSet;
        if not GLEntriesExists then
            exit(false);

        SafTXmlHelper.AddNewXMLNode('Journal', '');
        if SourceCode.Code <> '' then
            SafTXmlHelper.AppendXMLNode('JournalID', SourceCode.Code)
        else
            SafTXmlHelper.AppendXMLNode('JournalID', SourceCode.Description);
        SafTXmlHelper.AppendXMLNode('Description', SourceCode.Description);
        if SourceCode.Code <> '' then
            SafTXmlHelper.AppendXMLNode('Type', CombineWithSpaceSAFCodeType(SourceCode.Code))
        else
            SafTXmlHelper.AppendXMLNode('Type', CombineWithSpaceSAFCodeType(SourceCode.Description));
        ExportGLEntriesByTransaction(GLEntry, SAFTMappingRange, SAFTExportHeader, SourceCode.Description); //SSM2133
        SafTXmlHelper.FinalizeXMLNode;

        exit(true);
    end;

    local procedure ExportGLEntriesByTransaction(var GLEntry: Record "G/L Entry"; SAFTMappingRange: Record "SSAFT Mapping Range"; SAFTExportHeader: Record "SSAFT Export Header"; TransactionDescription: Text)
    var
        VATEntry: Record "VAT Entry";
        GLAccount: Record "G/L Account";
        Customer: Record Customer;
        Vendor: Record Vendor;
        CompanyInformation: Record "Company Information";
        GLEntryVATEntryLink: Record "G/L Entry - VAT Entry Link";
        VATPostingSetup: Record "VAT Posting Setup";
        GLItemLedgerRelation: Record "G/L - Item Ledger Relation";
        ValueEntry: Record "Value Entry";
        SAFTExportMgt: Codeunit "SSAFT Export Mgt.";
        AmountXMLNode: Text;
        Amount: Decimal;
        LastTransactionNo: Integer;
        WHTTaxCode: Code[10];
        IDFound: Boolean;
    begin
        repeat
            if LastTransactionNo <> GLEntry."Transaction No." then begin
                if LastTransactionNo <> 0 then
                    SafTXmlHelper.FinalizeXMLNode;
                ExportGLEntryTransactionInfo(GLEntry, TransactionDescription);
                LastTransactionNo := GLEntry."Transaction No.";
            end;
            GLAccount.Get(GLEntry."G/L Account No.");
            SafTXmlHelper.AddNewXMLNode('TransactionLine', '');
            SafTXmlHelper.AppendXMLNode('RecordID', Format(GLEntry."Entry No."));
            SafTXmlHelper.AppendXMLNode('AccountID', GetTableMapping(SAFTMappingRange.Code, GLAccount, SAFTMappingRange."Chart of Account NFT"));
            //SafTXmlHelper.AppendXMLNode('SourceDocumentID',GLEntry."Document No."); //SSM2020
            case GLEntry."Source Type" of
                GLEntry."Source Type"::Customer:
                    begin
                        Customer.Get(GLEntry."Source No.");
                        SafTXmlHelper.AppendXMLNode('CustomerID', GetCustomerRegistrationNumber(Customer));
                        SafTXmlHelper.AppendXMLNode('SupplierID', '0');
                    end;
                GLEntry."Source Type"::Vendor:
                    begin
                        Vendor.Get(GLEntry."Source No.");
                        SafTXmlHelper.AppendXMLNode('CustomerID', '0');
                        SafTXmlHelper.AppendXMLNode('SupplierID', GetVendorRegistrationNumber(Vendor));
                    end;
                else begin

                    Clear(IDFound);
                    GLItemLedgerRelation.SetRange("G/L Entry No.", GLEntry."Entry No.");
                    if GLItemLedgerRelation.FindFirst then begin
                        ValueEntry.Get(GLItemLedgerRelation."Value Entry No.");
                        if ValueEntry."Source Type" = ValueEntry."Source Type"::Customer then begin
                            Customer.Get(ValueEntry."Source No.");
                            SafTXmlHelper.AppendXMLNode('CustomerID', GetCustomerRegistrationNumber(Customer));
                            SafTXmlHelper.AppendXMLNode('SupplierID', '0');
                            IDFound := true;
                        end;
                        if ValueEntry."Source Type" = ValueEntry."Source Type"::Vendor then begin
                            Vendor.Get(ValueEntry."Source No.");
                            SafTXmlHelper.AppendXMLNode('CustomerID', '0');
                            SafTXmlHelper.AppendXMLNode('SupplierID', GetVendorRegistrationNumber(Vendor));
                            IDFound := true;
                        end;

                    end;
                    //SSM1724<<
                    if not IDFound then begin
                        CompanyInformation.Get;
                        SafTXmlHelper.AppendXMLNode('CustomerID', '00' + DelChr(CompanyInformation."VAT Registration No.", '=', 'roRO'));
                        SafTXmlHelper.AppendXMLNode('SupplierID', '00' + DelChr(CompanyInformation."VAT Registration No.", '=', 'roRO'));
                    end;
                end;
            end;
            if GLEntry.Description <> '' then
                SafTXmlHelper.AppendXMLNode('Description', GLEntry.Description)
            else
                SafTXmlHelper.AppendXMLNode('Description', GLAccount.Name);
            SAFTExportMgt.GetAmountInfoFromGLEntry(AmountXMLNode, Amount, GLEntry);
            ExportAmountInfo(AmountXMLNode, Amount, '', Amount);

            //SSM2020>>
            //OC IF (GLEntry."VAT Bus. Posting Group" <> '') OR (GLEntry."VAT Prod. Posting Group" <> '') THEN BEGIN
            if (GLEntry."VAT Bus. Posting Group" <> '') and (GLEntry."VAT Prod. Posting Group" <> '') then begin
                //SSM2020<<
                //TVA Tax
                GLEntryVATEntryLink.SetRange("G/L Entry No.", GLEntry."Entry No.");
                if GLEntryVATEntryLink.FindSet then
                    repeat
                        VATEntry.Get(GLEntryVATEntryLink."VAT Entry No.");
                        if (VATEntry.Type in [VATEntry.Type::Sale, VATEntry.Type::Purchase]) then begin
                            VATPostingSetup.Get(VATEntry."VAT Bus. Posting Group", VATEntry."VAT Prod. Posting Group");
                            //SSM2020>>
                            //OC ExportTaxInformation(GetVATTaxType(SAFTExportHeader),VATPostingSetup."SSAFT Tax Code",VATEntry.Amount);
                            if (VATEntry.Type = VATEntry.Type::Sale) and (VATEntry."Document Type" in [VATEntry."Document Type"::Invoice, VATEntry."Document Type"::"Credit Memo"]) then
                                ExportTaxInformation(GetVATTaxType(SAFTExportHeader), VATPostingSetup."SSAFT Tax Code", -VATEntry.Amount)
                            else
                                ExportTaxInformation(GetVATTaxType(SAFTExportHeader), VATPostingSetup."SSAFT Tax Code", VATEntry.Amount);
                            //SSM2020<<
                        end;
                    until GLEntryVATEntryLink.Next = 0
                //SSM1724>>
                else begin
                    VATEntry.Reset;
                    VATEntry.SetCurrentKey("Transaction No.");
                    VATEntry.SetRange("Transaction No.", GLEntry."Transaction No.");
                    VATEntry.SetRange(Amount, GLEntry.Amount);
                    VATEntry.SetRange("VAT Bus. Posting Group", GLEntry."VAT Bus. Posting Group");
                    VATEntry.SetRange("VAT Prod. Posting Group", GLEntry."VAT Prod. Posting Group");
                    if VATEntry.FindFirst then begin
                        if (VATEntry.Type in [VATEntry.Type::Sale, VATEntry.Type::Purchase]) then begin
                            VATPostingSetup.Get(VATEntry."VAT Bus. Posting Group", VATEntry."VAT Prod. Posting Group");
                            //SSM2020>>
                            //OC ExportTaxInformation(GetVATTaxType(SAFTExportHeader),VATPostingSetup."SSAFT Tax Code",VATEntry.Amount);
                            if (VATEntry.Type = VATEntry.Type::Sale) and (VATEntry."Document Type" in [VATEntry."Document Type"::Invoice, VATEntry."Document Type"::"Credit Memo"]) then
                                ExportTaxInformation(GetVATTaxType(SAFTExportHeader), VATPostingSetup."SSAFT Tax Code", -VATEntry.Amount)
                            else
                                ExportTaxInformation(GetVATTaxType(SAFTExportHeader), VATPostingSetup."SSAFT Tax Code", VATEntry.Amount);
                            //SSM2020<<
                        end;
                    end else begin
                        //SSM1724>>
                        //WHT Tax
                        WHTTaxCode := GetTax(SAFTMappingRange.Code, GLEntry."G/L Account No.", GlobalNFTType::"WHT - nomenclator");
                        if (WHTTaxCode = '') and (GLEntry."Debit Amount" <> 0) then //Tax-IMP
                            ExportTaxInformation(GetTax(SAFTMappingRange.Code, GLEntry."G/L Account No.", GlobalNFTType::"TAX-IMP - Impozite"), '000000', GLEntry.Amount)
                        else
                            ExportTaxInformation(CopyStr(WHTTaxCode, 1, 3), WHTTaxCode, GLEntry.Amount);
                        //SSM1724<<
                    end;
                end;
            end else
                //SSM1724 TVA Inchidere
                //TVA Tax
                if SAFTMappingRange."Source Code Inchidere TVA" = GLEntry."Source Code" then
                    ExportTaxInformation(GetVATTaxType(SAFTExportHeader), SAFTMappingRange."Inchidere TVA Tax Code", 0)
                else begin
                    //WHT Tax
                    WHTTaxCode := GetTax(SAFTMappingRange.Code, GLEntry."G/L Account No.", GlobalNFTType::"WHT - nomenclator");
                    if (WHTTaxCode = '') and (GLEntry."Debit Amount" <> 0) then //Tax-IMP
                        ExportTaxInformation(GetTax(SAFTMappingRange.Code, GLEntry."G/L Account No.", GlobalNFTType::"TAX-IMP - Impozite"), '000000', GLEntry.Amount)
                    else
                        ExportTaxInformation(CopyStr(WHTTaxCode, 1, 3), WHTTaxCode, GLEntry.Amount)
                end;
            //SSM1724<<
            SafTXmlHelper.FinalizeXMLNode;
        until GLEntry.Next = 0;
        SafTXmlHelper.FinalizeXMLNode;

    end;

    local procedure ExportGLEntryTransactionInfo(GLEntry: Record "G/L Entry"; TransactionDescription: Text)
    var
        Customer: Record Customer;
        Vendor: Record Vendor;
        CompanyInformation: Record "Company Information";
        GLEntryTrans: Record "G/L Entry";
    begin
        SafTXmlHelper.AddNewXMLNode('Transaction', '');
        SafTXmlHelper.AppendXMLNode('TransactionID', Format(GLEntry."Transaction No."));
        SafTXmlHelper.AppendXMLNode('Period', Format(Date2DMY(GLEntry."Posting Date", 2)));
        SafTXmlHelper.AppendXMLNode('PeriodYear', Format(Date2DMY(GLEntry."Posting Date", 3)));
        SafTXmlHelper.AppendXMLNode('TransactionDate', FormatDate(GLEntry."Document Date"));
        SafTXmlHelper.AppendXMLNode('Description', TransactionDescription);

        SafTXmlHelper.AppendXMLNode('SystemEntryDate', FormatDate(GLEntry."Document Date"));
        SafTXmlHelper.AppendXMLNode('GLPostingDate', FormatDate(GLEntry."Posting Date"));

        GLEntryTrans.Reset;
        GLEntryTrans.SetCurrentKey("Transaction No.");
        GLEntryTrans.SetRange("Transaction No.", GLEntry."Transaction No.");
        GLEntryTrans.SetFilter("Source Type", '%1|%2', GLEntryTrans."Source Type"::Customer, GLEntryTrans."Source Type"::Vendor);
        if not GLEntryTrans.FindFirst then
            Clear(GLEntryTrans);

        case GLEntryTrans."Source Type" of
            GLEntryTrans."Source Type"::Customer:
                begin
                    Customer.Get(GLEntryTrans."Source No.");
                    SafTXmlHelper.AppendXMLNode('CustomerID', GetCustomerRegistrationNumber(Customer));
                    SafTXmlHelper.AppendXMLNode('SupplierID', '0');
                end;
            GLEntryTrans."Source Type"::Vendor:
                begin
                    Vendor.Get(GLEntryTrans."Source No.");
                    SafTXmlHelper.AppendXMLNode('CustomerID', '0');
                    SafTXmlHelper.AppendXMLNode('SupplierID', GetVendorRegistrationNumber(Vendor));
                end;
            else begin
                CompanyInformation.Get;
                SafTXmlHelper.AppendXMLNode('CustomerID', '00' + DelChr(CompanyInformation."VAT Registration No.", '=', 'roRO'));
                SafTXmlHelper.AppendXMLNode('SupplierID', '00' + DelChr(CompanyInformation."VAT Registration No.", '=', 'roRO'));
            end;
        end;
        //SSM2020<<

    end;

    local procedure ExportSalesDocuments(var _CustLedgerEntry: Record "Cust. Ledger Entry"; var _DetailedCustLedgEntry: Record "Detailed Cust. Ledg. Entry"; var SAFTExportLine: Record "SSAFT Export Line")
    var
        SAFTExportHeader: Record "SSAFT Export Header";
        SAFTMappingRange: Record "SSAFT Mapping Range";
        TotalRecNo: Integer;
        TotalDebit: Decimal;
        TotalCredit: Decimal;
        CLEProgressStep: Integer;
        CLEProgress: Integer;
    begin
        //SSM2101>>
        //OC _CustLedgerEntry.SETFILTER("SSA Tip Document D394",'<>%1',_CustLedgerEntry."SSA Tip Document D394"::"Bon Fiscal"); //SSM1724
        _CustLedgerEntry.SetFilter("SSA Tip Document D394", '<>%1&<>%2', _CustLedgerEntry."SSA Tip Document D394"::"Bon Fiscal", _CustLedgerEntry."SSA Tip Document D394"::Contract);
        //SSM2101<<
        _CustLedgerEntry.SetFilter("Document Type", '%1|%2', _CustLedgerEntry."Document Type"::Invoice, _CustLedgerEntry."Document Type"::"Credit Memo");
        TotalRecNo := _CustLedgerEntry.Count;

        //SSM2098>>
        /* //OC
        _DetailedCustLedgEntry.SETRANGE("Entry Type",_DetailedCustLedgEntry."Entry Type"::"Initial Entry");
        _DetailedCustLedgEntry.SETRANGE("Initial Document Type",_DetailedCustLedgEntry."Initial Document Type"::Invoice);
        _DetailedCustLedgEntry.CALCSUMS("Amount (LCY)");
        TotalDebit := _DetailedCustLedgEntry."Amount (LCY)";
        
        _DetailedCustLedgEntry.SETRANGE("Initial Document Type",_DetailedCustLedgEntry."Initial Document Type"::"Credit Memo");
        _DetailedCustLedgEntry.CALCSUMS("Amount (LCY)");
        TotalCredit := _DetailedCustLedgEntry."Amount (LCY)";
        */

        Clear(TotalDebit);
        _DetailedCustLedgEntry.SetRange("Entry Type", _DetailedCustLedgEntry."Entry Type"::"Initial Entry");
        _DetailedCustLedgEntry.SetRange("Initial Document Type", _DetailedCustLedgEntry."Initial Document Type"::Invoice);
        if _DetailedCustLedgEntry.FindSet then
            repeat
                _CustLedgerEntry.Get(_DetailedCustLedgEntry."Cust. Ledger Entry No.");
                _CustLedgerEntry.CalcFields("SSA Tip Document D394");
                //SSM2101>>
                //OC IF _CustLedgerEntry."SSA Tip Document D394" <> _CustLedgerEntry."SSA Tip Document D394"::"Bon Fiscal" THEN
                if not (_CustLedgerEntry."SSA Tip Document D394" in [_CustLedgerEntry."SSA Tip Document D394"::"Bon Fiscal", _CustLedgerEntry."SSA Tip Document D394"::Contract]) then
                    //SSM2101<<
                    TotalDebit += _DetailedCustLedgEntry."Amount (LCY)";
            until _DetailedCustLedgEntry.Next = 0;

        Clear(TotalCredit);
        _DetailedCustLedgEntry.SetRange("Initial Document Type", _DetailedCustLedgEntry."Initial Document Type"::"Credit Memo");
        if _DetailedCustLedgEntry.FindSet then
            repeat
                _CustLedgerEntry.Get(_DetailedCustLedgEntry."Cust. Ledger Entry No.");
                _CustLedgerEntry.CalcFields("SSA Tip Document D394");
                //SSM2101>>
                //OC IF _CustLedgerEntry."SSA Tip Document D394" <> _CustLedgerEntry."SSA Tip Document D394"::"Bon Fiscal" THEN
                if not (_CustLedgerEntry."SSA Tip Document D394" in [_CustLedgerEntry."SSA Tip Document D394"::"Bon Fiscal", _CustLedgerEntry."SSA Tip Document D394"::Contract]) then
                    //SSM2101<<
                    TotalCredit += _DetailedCustLedgEntry."Amount (LCY)";
            until _DetailedCustLedgEntry.Next = 0;
        //SSM2098<<

        SafTXmlHelper.AddNewXMLNode('SalesInvoices', '');
        SafTXmlHelper.AppendXMLNode('NumberOfEntries', Format(TotalRecNo));
        SafTXmlHelper.AppendXMLNode('TotalDebit', FormatAmount(TotalDebit));
        SafTXmlHelper.AppendXMLNode('TotalCredit', FormatAmount(TotalCredit));
        if not _CustLedgerEntry.FindSet then begin
            SafTXmlHelper.FinalizeXMLNode;
            exit;
        end;

        if GuiAllowed then
            Window.Update(1, ExportingSalesDocumentsMsg);

        CLEProgressStep := Round(10000 / TotalRecNo, 1, '<');

        SAFTExportHeader.Get(SAFTExportLine.ID);
        SAFTMappingRange.Get(SAFTExportHeader."Mapping Range Code");

        ExportSalesDocument(_CustLedgerEntry, SAFTMappingRange, SAFTExportHeader);

        CLEProgress += CLEProgressStep;
        if GuiAllowed() then
            Window.Update(2, CLEProgress);

        SAFTExportLine.Get(SAFTExportLine.ID, SAFTExportLine."Line No.");
        SAFTExportLine.LockTable();
        SAFTExportLine.Validate(Progress, CLEProgress);
        SAFTExportLine.Modify(true);
        Commit();
        SafTXmlHelper.FinalizeXMLNode;

    end;

    local procedure ExportSalesDocument(var CLE: Record "Cust. Ledger Entry"; SAFTMappingRange: Record "SSAFT Mapping Range"; SAFTExportHeader: Record "SSAFT Export Header")
    var
        Customer: Record Customer;
        CustomerPostingGroup: Record "Customer Posting Group";
        GLAccount: Record "G/L Account";
        SIH: Record "Sales Invoice Header";
        SIL: Record "Sales Invoice Line";
        SCMH: Record "Sales Cr.Memo Header";
        SCML: Record "Sales Cr.Memo Line";
        ServIH: Record "Service Invoice Header";
        ServIL: Record "Service Invoice Line";
        ServCMH: Record "Service Cr.Memo Header";
        ServCML: Record "Service Cr.Memo Line";
        GeneralPostingSetup: Record "General Posting Setup";
        VATPostingSetup: Record "VAT Posting Setup";
        CountryRegion: Record "Country/Region";
        FAPostingGroup: Record "FA Posting Group";
        SalesSetup: Record "Sales & Receivables Setup";
        GLEntry: Record "G/L Entry";
        WHTTaxCode: Code[10];
        DocumentDetailsExported: Boolean;
    begin
        //SSM2020>>
        SalesSetup.Get;
        //SSM2020<<
        repeat
            //SSM2101>>
            Clear(DocumentDetailsExported);
            //SSM2101<<

            //SSM2020>>
            if CLE."Document Type" = CLE."Document Type"::Invoice then begin
                if not SIH.Get(CLE."Document No.") then
                    Clear(SIH);
            end else
                if not SCMH.Get(CLE."Document No.") then
                    Clear(SCMH);
            //SSM2020<<
            SafTXmlHelper.AddNewXMLNode('Invoice', '');
            SafTXmlHelper.AppendXMLNode('InvoiceNo', CLE."Document No.");

            SafTXmlHelper.AddNewXMLNode('CustomerInfo', '');
            Customer.Get(CLE."Customer No.");
            SafTXmlHelper.AppendXMLNode('CustomerID', GetCustomerRegistrationNumber(Customer));

            CountryRegion.Get(Customer."Country/Region Code");

            ExportAddress('BillingAddress',
              CombineWithSpaceSAFmiddle2textType(Customer.Address, Customer."Address 2"), Customer.City,
              Customer."Post Code",
              GetTableMapping(SAFTExportHeader."Mapping Range Code", CountryRegion, GlobalNFTType::"ISO3166-2-CountryCodes"),
              'StreetAddress',
              '');
            SafTXmlHelper.FinalizeXMLNode;

            //SSM1724>>
            //OC CustomerPostingGroup.GET(Customer."Customer Posting Group");
            CustomerPostingGroup.GET(CLE."Customer Posting Group");
            //SSM1724<<
            GLAccount.Get(CustomerPostingGroup."Receivables Account");
            SAFTMappingRange.Get(SAFTExportHeader."Mapping Range Code");
            SafTXmlHelper.AppendXMLNode('AccountID', GetTableMapping(SAFTExportHeader."Mapping Range Code", GLAccount, SAFTMappingRange."Chart of Account NFT"));

            SafTXmlHelper.AppendXMLNode('InvoiceDate', FormatDate(CLE."Posting Date"));
            if CLE."Document Type" = CLE."Document Type"::Invoice then begin
                //SSM2020>>
                if SalesSetup."SSAFT Autofact Cust. No." = CLE."Customer No." then begin
                    if SIH."SSA Stare Factura" = SIH."SSA Stare Factura"::"3-Autofactura" then begin
                        SafTXmlHelper.AppendXMLNode('InvoiceType', '389'); //Invoice
                        SafTXmlHelper.AppendXMLNode('SelfBillingIndicator', '389');
                    end else begin
                        SafTXmlHelper.AppendXMLNode('InvoiceType', '380'); //Invoice
                        SafTXmlHelper.AppendXMLNode('SelfBillingIndicator', '0');
                    end;
                end else begin
                    SafTXmlHelper.AppendXMLNode('InvoiceType', '380'); //Invoice
                    SafTXmlHelper.AppendXMLNode('SelfBillingIndicator', '0');
                end;
                //SSM2020<<

                SIL.SetRange("Document No.", CLE."Document No.");
                SIL.SetFilter(Quantity, '<>%1', 0);
                if SIL.FindSet then begin
                    DocumentDetailsExported := true; //SSM2101
                    repeat
                        SafTXmlHelper.AddNewXMLNode('InvoiceLine', '');
                        case SIL.Type of
                            SIL.Type::Item, SIL.Type::Resource, SIL.Type::"Charge (Item)":
                                begin
                                    GeneralPostingSetup.Get(SIL."Gen. Bus. Posting Group", SIL."Gen. Prod. Posting Group");
                                    GLAccount.Get(GeneralPostingSetup."Sales Account");
                                    SafTXmlHelper.AppendXMLNode('AccountID', GetTableMapping(SAFTExportHeader."Mapping Range Code", GLAccount, SAFTMappingRange."Chart of Account NFT"));
                                end;
                            SIL.Type::"G/L Account":
                                begin
                                    GLAccount.Get(SIL."No.");
                                    SafTXmlHelper.AppendXMLNode('AccountID', GetTableMapping(SAFTExportHeader."Mapping Range Code", GLAccount, SAFTMappingRange."Chart of Account NFT"));
                                end;
                            SIL.Type::"Fixed Asset":
                                begin
                                    FAPostingGroup.Get(SIL."Posting Group");
                                    GLAccount.Get(FAPostingGroup."Gains Acc. on Disposal");
                                    SafTXmlHelper.AppendXMLNode('AccountID', GetTableMapping(SAFTExportHeader."Mapping Range Code", GLAccount, SAFTMappingRange."Chart of Account NFT"));
                                end;
                        end;
                        SafTXmlHelper.AppendXMLNode('Quantity', FormatAmount(SIL.Quantity));
                        SafTXmlHelper.AppendXMLNode('UnitPrice', FormatAmount(Round(SIL."Unit Price", 0.01)));
                        SafTXmlHelper.AppendXMLNode('TaxPointDate', FormatDate(SIL."Posting Date"));
                        SafTXmlHelper.AppendXMLNode('Description', CombineWithSpaceSAFSAFlongtextType(SIL.Description, SIL."Description 2"));
                        //SSM2020>>
                        /*//OC
                        IF SIH."Currency Code" <> '' THEN
                          ExportAmountInfo('InvoiceLineAmount',ROUND(SIL."Amount Including VAT" / SIH."Currency Factor",0.01),CLE."Currency Code",SIL."Amount Including VAT")
                        ELSE
                          ExportAmountInfo('InvoiceLineAmount',SIL."Amount Including VAT",CLE."Currency Code",SIL."Amount Including VAT");
                        */
                        if SIH."Currency Code" <> '' then
                            ExportAmountInfo('InvoiceLineAmount', Round(SIL.Amount / SIH."Currency Factor", 0.01), CLE."Currency Code", SIL.Amount)
                        else
                            ExportAmountInfo('InvoiceLineAmount', SIL.Amount, CLE."Currency Code", SIL.Amount);
                        //SSM2020<<
                        SafTXmlHelper.AppendXMLNode('DebitCreditIndicator', 'C');
                        //SSM2020>>
                        //OC IF (SIL."VAT Bus. Posting Group" <> '') OR (SIL."VAT Prod. Posting Group" <> '') THEN BEGIN
                        if (SIL."VAT Bus. Posting Group" <> '') and (SIL."VAT Prod. Posting Group" <> '') then begin
                            //SSM2020<<
                            //TVA Tax
                            VATPostingSetup.Get(SIL."VAT Bus. Posting Group", SIL."VAT Prod. Posting Group");
                            ExportTaxInformation(GetVATTaxType(SAFTExportHeader), VATPostingSetup."SSAFT Tax Code", SIL."Amount Including VAT" - SIL.Amount);
                        end else begin
                            //SSM1724>>
                            //WHT Tax
                            WHTTaxCode := GetTax(SAFTMappingRange.Code, GLAccount."No.", GlobalNFTType::"WHT - nomenclator");
                            if WHTTaxCode <> '' then
                                ExportTaxInformation(CopyStr(WHTTaxCode, 1, 3), WHTTaxCode, SIL."Amount Including VAT")
                            else
                                ExportTaxInformation(GetTax(SAFTMappingRange.Code, GLAccount."No.", GlobalNFTType::"TAX-IMP - Impozite"), '000000', SIL."Amount Including VAT")
                            //SSM1724<<
                        end;
                        SafTXmlHelper.FinalizeXMLNode;
                    until SIL.Next = 0;
                end;

                //SSM2101>>
                ServIL.SetRange("Document No.", CLE."Document No.");
                ServIL.SetFilter(Quantity, '<>%1', 0);
                if ServIL.FindSet then begin
                    DocumentDetailsExported := true;
                    repeat
                        SafTXmlHelper.AddNewXMLNode('InvoiceLine', '');
                        case ServIL.Type of
                            ServIL.Type::Item, ServIL.Type::Resource:
                                begin
                                    GeneralPostingSetup.Get(ServIL."Gen. Bus. Posting Group", ServIL."Gen. Prod. Posting Group");
                                    GLAccount.Get(GeneralPostingSetup."Sales Account");
                                    SafTXmlHelper.AppendXMLNode('AccountID', GetTableMapping(SAFTExportHeader."Mapping Range Code", GLAccount, SAFTMappingRange."Chart of Account NFT"));
                                end;
                            ServIL.Type::"G/L Account":
                                begin
                                    GLAccount.Get(ServIL."No.");
                                    SafTXmlHelper.AppendXMLNode('AccountID', GetTableMapping(SAFTExportHeader."Mapping Range Code", GLAccount, SAFTMappingRange."Chart of Account NFT"));
                                end;
                        end;
                        SafTXmlHelper.AppendXMLNode('Quantity', FormatAmount(ServIL.Quantity));
                        SafTXmlHelper.AppendXMLNode('UnitPrice', FormatAmount(Round(ServIL."Unit Price", 0.01)));
                        SafTXmlHelper.AppendXMLNode('TaxPointDate', FormatDate(ServIL."Posting Date"));
                        SafTXmlHelper.AppendXMLNode('Description', CombineWithSpaceSAFSAFlongtextType(ServIL.Description, ServIL."Description 2"));
                        ServIH.Get(ServIL."Document No.");
                        if ServIH."Currency Code" <> '' then
                            ExportAmountInfo('InvoiceLineAmount', Round(ServIL.Amount / ServIH."Currency Factor", 0.01), CLE."Currency Code", ServIL.Amount)
                        else
                            ExportAmountInfo('InvoiceLineAmount', ServIL.Amount, CLE."Currency Code", ServIL.Amount);
                        SafTXmlHelper.AppendXMLNode('DebitCreditIndicator', 'C');
                        if (ServIL."VAT Bus. Posting Group" <> '') and (ServIL."VAT Prod. Posting Group" <> '') then begin
                            //TVA Tax
                            VATPostingSetup.Get(ServIL."VAT Bus. Posting Group", ServIL."VAT Prod. Posting Group");
                            ExportTaxInformation(GetVATTaxType(SAFTExportHeader), VATPostingSetup."SSAFT Tax Code", ServIL."Amount Including VAT" - ServIL.Amount);
                        end else begin
                            //WHT Tax
                            WHTTaxCode := GetTax(SAFTMappingRange.Code, GLAccount."No.", GlobalNFTType::"WHT - nomenclator");
                            if WHTTaxCode <> '' then
                                ExportTaxInformation(CopyStr(WHTTaxCode, 1, 3), WHTTaxCode, ServIL."Amount Including VAT")
                            else
                                ExportTaxInformation(GetTax(SAFTMappingRange.Code, GLAccount."No.", GlobalNFTType::"TAX-IMP - Impozite"), '000000', ServIL."Amount Including VAT")
                        end;
                        SafTXmlHelper.FinalizeXMLNode;
                    until ServIL.Next = 0;
                end;

                if not DocumentDetailsExported then begin
                    GLEntry.Reset;
                    GLEntry.SetCurrentKey("Document No.", "Posting Date");
                    GLEntry.SetRange("Document No.", CLE."Document No.");
                    GLEntry.SetRange("Posting Date", CLE."Posting Date");
                    GLEntry.SetRange("Transaction No.", CLE."Transaction No.");
                    GLEntry.SetFilter("VAT Bus. Posting Group", '<>%1', '');
                    GLEntry.SetFilter("VAT Prod. Posting Group", '<>%1', '');
                    GLEntry.FindFirst;
                    repeat
                        SafTXmlHelper.AddNewXMLNode('InvoiceLine', '');
                        GeneralPostingSetup.Get(GLEntry."Gen. Bus. Posting Group", GLEntry."Gen. Prod. Posting Group");
                        GLAccount.Get(GLEntry."G/L Account No.");
                        SafTXmlHelper.AppendXMLNode('AccountID', GetTableMapping(SAFTExportHeader."Mapping Range Code", GLAccount, SAFTMappingRange."Chart of Account NFT"));
                        SafTXmlHelper.AppendXMLNode('Quantity', FormatAmount(1));
                        SafTXmlHelper.AppendXMLNode('UnitPrice', FormatAmount(Round(GLEntry.Amount, 0.01)));
                        SafTXmlHelper.AppendXMLNode('TaxPointDate', FormatDate(GLEntry."Posting Date"));
                        SafTXmlHelper.AppendXMLNode('Description', CombineWithSpaceSAFSAFlongtextType(GLEntry.Description, ''));
                        ExportAmountInfo('InvoiceLineAmount', GLEntry.Amount, '', GLEntry.Amount);
                        SafTXmlHelper.AppendXMLNode('DebitCreditIndicator', 'C');
                        VATPostingSetup.Get(SIL."VAT Bus. Posting Group", SIL."VAT Prod. Posting Group");
                        ExportTaxInformation(GetVATTaxType(SAFTExportHeader), VATPostingSetup."SSAFT Tax Code", GLEntry."VAT Amount");
                        SafTXmlHelper.FinalizeXMLNode;
                    until GLEntry.Next = 0;
                    DocumentDetailsExported := true;
                end;
                //SSM2101<<
            end;
            if CLE."Document Type" = CLE."Document Type"::"Credit Memo" then begin
                //SSM2020>>
                if SalesSetup."SSAFT Autofact Cust. No." = CLE."Customer No." then begin
                    if SCMH."SSA Stare Factura" = SCMH."SSA Stare Factura"::"3-Autofactura" then begin
                        SafTXmlHelper.AppendXMLNode('InvoiceType', '389'); //Invoice
                        SafTXmlHelper.AppendXMLNode('SelfBillingIndicator', '389');
                    end else begin
                        SafTXmlHelper.AppendXMLNode('InvoiceType', '381'); //Invoice
                        SafTXmlHelper.AppendXMLNode('SelfBillingIndicator', '0');
                    end;
                end else begin
                    SafTXmlHelper.AppendXMLNode('InvoiceType', '381'); //Invoice
                    SafTXmlHelper.AppendXMLNode('SelfBillingIndicator', '0');
                end;
                //SSM2020<<

                SCML.SetRange("Document No.", CLE."Document No.");
                SCML.SetFilter(Quantity, '<>%1', 0);
                if SCML.FindSet then begin
                    DocumentDetailsExported := true; //SSM2101
                    repeat
                        SafTXmlHelper.AddNewXMLNode('InvoiceLine', '');
                        case SCML.Type of
                            SCML.Type::Item, SCML.Type::Resource, SCML.Type::"Charge (Item)":
                                begin
                                    GeneralPostingSetup.Get(SCML."Gen. Bus. Posting Group", SCML."Gen. Prod. Posting Group");
                                    GLAccount.Get(GeneralPostingSetup."Sales Account");
                                    SafTXmlHelper.AppendXMLNode('AccountID', GetTableMapping(SAFTExportHeader."Mapping Range Code", GLAccount, SAFTMappingRange."Chart of Account NFT"));
                                end;
                            SCML.Type::"G/L Account":
                                begin
                                    GLAccount.Get(SCML."No.");
                                    SafTXmlHelper.AppendXMLNode('AccountID', GetTableMapping(SAFTExportHeader."Mapping Range Code", GLAccount, SAFTMappingRange."Chart of Account NFT"));
                                end;
                            SCML.Type::"Fixed Asset":
                                begin
                                    FAPostingGroup.Get(SCML."Posting Group");
                                    GLAccount.Get(FAPostingGroup."Gains Acc. on Disposal");
                                    SafTXmlHelper.AppendXMLNode('AccountID', GetTableMapping(SAFTExportHeader."Mapping Range Code", GLAccount, SAFTMappingRange."Chart of Account NFT"));
                                end;
                        end;
                        SafTXmlHelper.AppendXMLNode('Quantity', FormatAmount(SCML.Quantity));
                        SafTXmlHelper.AppendXMLNode('UnitPrice', FormatAmount(Round(SCML."Unit Price", 0.01)));
                        SafTXmlHelper.AppendXMLNode('TaxPointDate', FormatDate(SCML."Posting Date"));
                        SafTXmlHelper.AppendXMLNode('Description', CombineWithSpaceSAFSAFlongtextType(SCML.Description, SCML."Description 2"));
                        //SSM2020>>
                        /*
                        IF SCMH."Currency Code" <> '' THEN
                          ExportAmountInfo('InvoiceLineAmount',ROUND(SCML."Amount Including VAT" / SCMH."Currency Factor",0.01),CLE."Currency Code",SCML."Amount Including VAT")
                        ELSE
                          ExportAmountInfo('InvoiceLineAmount',SCML."Amount Including VAT",CLE."Currency Code",SCML."Amount Including VAT");
                        */
                        if SCMH."Currency Code" <> '' then
                            ExportAmountInfo('InvoiceLineAmount', Round(SCML.Amount / SCMH."Currency Factor", 0.01), CLE."Currency Code", SCML.Amount)
                        else
                            ExportAmountInfo('InvoiceLineAmount', SCML.Amount, CLE."Currency Code", SCML.Amount);
                        //SSM2020<<
                        SafTXmlHelper.AppendXMLNode('DebitCreditIndicator', 'C');
                        //SSM2020>>
                        //OC IF (SCML."VAT Bus. Posting Group" <> '') OR (SCML."VAT Prod. Posting Group" <> '') THEN BEGIN
                        if (SCML."VAT Bus. Posting Group" <> '') and (SCML."VAT Prod. Posting Group" <> '') then begin
                            //SSM2020<<
                            //TVA Tax
                            VATPostingSetup.Get(SCML."VAT Bus. Posting Group", SCML."VAT Prod. Posting Group");
                            ExportTaxInformation(GetVATTaxType(SAFTExportHeader), VATPostingSetup."SSAFT Tax Code", SCML."Amount Including VAT" - SCML.Amount);
                        end else begin
                            //SSM1724>>
                            /*//OC
                            //WHT Tax
                            WHTTaxCode := GetWHTTax(SAFTMappingRange.Code,GLAccount."No.");
                            ExportTaxInformation(COPYSTR(WHTTaxCode,1,3),WHTTaxCode,SCML."Amount Including VAT");
                            */
                            WHTTaxCode := GetTax(SAFTMappingRange.Code, GLAccount."No.", GlobalNFTType::"WHT - nomenclator");
                            if WHTTaxCode <> '' then
                                ExportTaxInformation(CopyStr(WHTTaxCode, 1, 3), WHTTaxCode, SCML."Amount Including VAT")
                            else
                                ExportTaxInformation(GetTax(SAFTMappingRange.Code, GLAccount."No.", GlobalNFTType::"TAX-IMP - Impozite"), '000000', SCML."Amount Including VAT")
                            //SSM1724<<
                        end;
                        SafTXmlHelper.FinalizeXMLNode;
                    until SCML.Next = 0;
                end;
                //SSM2101>>
                ServCML.SetRange("Document No.", CLE."Document No.");
                ServCML.SetFilter(Quantity, '<>%1', 0);
                if ServCML.FindSet then begin
                    DocumentDetailsExported := true;
                    repeat
                        SafTXmlHelper.AddNewXMLNode('InvoiceLine', '');
                        case ServCML.Type of
                            ServCML.Type::Item, ServCML.Type::Resource:
                                begin
                                    GeneralPostingSetup.Get(ServCML."Gen. Bus. Posting Group", ServCML."Gen. Prod. Posting Group");
                                    GLAccount.Get(GeneralPostingSetup."Sales Account");
                                    SafTXmlHelper.AppendXMLNode('AccountID', GetTableMapping(SAFTExportHeader."Mapping Range Code", GLAccount, SAFTMappingRange."Chart of Account NFT"));
                                end;
                            ServCML.Type::"G/L Account":
                                begin
                                    GLAccount.Get(ServCML."No.");
                                    SafTXmlHelper.AppendXMLNode('AccountID', GetTableMapping(SAFTExportHeader."Mapping Range Code", GLAccount, SAFTMappingRange."Chart of Account NFT"));
                                end;
                        end;
                        SafTXmlHelper.AppendXMLNode('Quantity', FormatAmount(ServCML.Quantity));
                        SafTXmlHelper.AppendXMLNode('UnitPrice', FormatAmount(Round(ServCML."Unit Price", 0.01)));
                        SafTXmlHelper.AppendXMLNode('TaxPointDate', FormatDate(ServCML."Posting Date"));
                        SafTXmlHelper.AppendXMLNode('Description', CombineWithSpaceSAFSAFlongtextType(ServCML.Description, ServCML."Description 2"));
                        ServCMH.Get(ServCML."Document No.");
                        if ServCMH."Currency Code" <> '' then
                            ExportAmountInfo('InvoiceLineAmount', Round(ServCML.Amount / ServCMH."Currency Factor", 0.01), CLE."Currency Code", ServCML.Amount)
                        else
                            ExportAmountInfo('InvoiceLineAmount', ServCML.Amount, CLE."Currency Code", ServCML.Amount);
                        SafTXmlHelper.AppendXMLNode('DebitCreditIndicator', 'C');
                        if (ServCML."VAT Bus. Posting Group" <> '') and (ServCML."VAT Prod. Posting Group" <> '') then begin
                            //TVA Tax
                            VATPostingSetup.Get(ServCML."VAT Bus. Posting Group", ServCML."VAT Prod. Posting Group");
                            ExportTaxInformation(GetVATTaxType(SAFTExportHeader), VATPostingSetup."SSAFT Tax Code", ServCML."Amount Including VAT" - ServCML.Amount);
                        end else begin
                            WHTTaxCode := GetTax(SAFTMappingRange.Code, GLAccount."No.", GlobalNFTType::"WHT - nomenclator");
                            if WHTTaxCode <> '' then
                                ExportTaxInformation(CopyStr(WHTTaxCode, 1, 3), WHTTaxCode, ServCML."Amount Including VAT")
                            else
                                ExportTaxInformation(GetTax(SAFTMappingRange.Code, GLAccount."No.", GlobalNFTType::"TAX-IMP - Impozite"), '000000', ServCML."Amount Including VAT")
                        end;
                        SafTXmlHelper.FinalizeXMLNode;
                    until ServCML.Next = 0;
                end;

                if not DocumentDetailsExported then begin
                    GLEntry.Reset;
                    GLEntry.SetCurrentKey("Document No.", "Posting Date");
                    GLEntry.SetRange("Document No.", CLE."Document No.");
                    GLEntry.SetRange("Posting Date", CLE."Posting Date");
                    GLEntry.SetRange("Transaction No.", CLE."Transaction No.");
                    GLEntry.SetFilter("VAT Bus. Posting Group", '<>%1', '');
                    GLEntry.SetFilter("VAT Prod. Posting Group", '<>%1', '');
                    GLEntry.FindSet();
                    repeat
                        SafTXmlHelper.AddNewXMLNode('InvoiceLine', '');
                        GeneralPostingSetup.Get(GLEntry."Gen. Bus. Posting Group", GLEntry."Gen. Prod. Posting Group");
                        GLAccount.Get(GLEntry."G/L Account No.");
                        SafTXmlHelper.AppendXMLNode('AccountID', GetTableMapping(SAFTExportHeader."Mapping Range Code", GLAccount, SAFTMappingRange."Chart of Account NFT"));
                        SafTXmlHelper.AppendXMLNode('Quantity', FormatAmount(1));
                        SafTXmlHelper.AppendXMLNode('UnitPrice', FormatAmount(Round(GLEntry.Amount, 0.01)));
                        SafTXmlHelper.AppendXMLNode('TaxPointDate', FormatDate(GLEntry."Posting Date"));
                        SafTXmlHelper.AppendXMLNode('Description', CombineWithSpaceSAFSAFlongtextType(GLEntry.Description, ''));
                        ExportAmountInfo('InvoiceLineAmount', GLEntry.Amount, '', GLEntry.Amount);
                        SafTXmlHelper.AppendXMLNode('DebitCreditIndicator', 'C');
                        //TVA Tax
                        VATPostingSetup.Get(GLEntry."VAT Bus. Posting Group", GLEntry."VAT Prod. Posting Group");
                        ExportTaxInformation(GetVATTaxType(SAFTExportHeader), VATPostingSetup."SSAFT Tax Code", GLEntry."VAT Amount");
                        SafTXmlHelper.FinalizeXMLNode;
                    until GLEntry.Next = 0;
                    DocumentDetailsExported := true;
                end;
                //SSM2101<<

            end;
            SafTXmlHelper.FinalizeXMLNode;
        until CLE.Next = 0;

    end;

    local procedure ExportPurchaseDocuments(var _VendorLedgerEntry: Record "Vendor Ledger Entry"; var _DetailedVendorLedgEntry: Record "Detailed Vendor Ledg. Entry"; var SAFTExportLine: Record "SSAFT Export Line")
    var
        SAFTExportHeader: Record "SSAFT Export Header";
        SAFTMappingRange: Record "SSAFT Mapping Range";
        VLE: Record "Vendor Ledger Entry";
        TotalRecNo: Integer;
        TotalDebit: Decimal;
        TotalCredit: Decimal;
        VLEProgressStep: Integer;
        VLEProgress: Integer;
    begin
        _VendorLedgerEntry.SetFilter("Document Type", '%1|%2', _VendorLedgerEntry."Document Type"::Invoice, _VendorLedgerEntry."Document Type"::"Credit Memo");
        //SSM2101>>
        //OC _VendorLedgerEntry.SETFILTER("SSA Tip Document D394",'<>%1',_VendorLedgerEntry."SSA Tip Document D394"::"Bon Fiscal"); //SSM2020
        _VendorLedgerEntry.SetFilter("SSA Tip Document D394", '<>%1&<>%2', _VendorLedgerEntry."SSA Tip Document D394"::"Bon Fiscal", _VendorLedgerEntry."SSA Tip Document D394"::Contract);
        //SSM2101<<
        TotalRecNo := _VendorLedgerEntry.Count;

        _DetailedVendorLedgEntry.SetRange("Entry Type", _DetailedVendorLedgEntry."Entry Type"::"Initial Entry");
        _DetailedVendorLedgEntry.SetRange("Initial Document Type", _DetailedVendorLedgEntry."Initial Document Type"::"Credit Memo");
        //SSM2020>>
        /*//OC
        _DetailedVendorLedgEntry.CALCSUMS("Amount (LCY)");
        TotalDebit := _DetailedVendorLedgEntry."Amount (LCY)";
        
        _DetailedVendorLedgEntry.SETRANGE("Initial Document Type",_DetailedVendorLedgEntry."Initial Document Type"::Invoice);
        _DetailedVendorLedgEntry.CALCSUMS("Amount (LCY)");
        TotalCredit := _DetailedVendorLedgEntry."Amount (LCY)";
        */
        Clear(TotalDebit);
        if _DetailedVendorLedgEntry.FindSet then
            repeat
                VLE.Get(_DetailedVendorLedgEntry."Vendor Ledger Entry No.");
                VLE.CalcFields("SSA Tip Document D394");
                //SSM2101>>
                //OC IF VLE."SSA Tip Document D394" <> VLE."SSA Tip Document D394"::"Bon Fiscal" THEN
                if not (VLE."SSA Tip Document D394" in [VLE."SSA Tip Document D394"::"Bon Fiscal", VLE."SSA Tip Document D394"::Contract]) then
                    //SSM2101<<
                    TotalDebit += _DetailedVendorLedgEntry."Amount (LCY)";
            until _DetailedVendorLedgEntry.Next = 0;

        Clear(TotalCredit);
        _DetailedVendorLedgEntry.SetRange("Initial Document Type", _DetailedVendorLedgEntry."Initial Document Type"::Invoice);
        if _DetailedVendorLedgEntry.FindSet then
            repeat
                VLE.Get(_DetailedVendorLedgEntry."Vendor Ledger Entry No.");
                VLE.CalcFields("SSA Tip Document D394");
                //SSM2101>>
                //OC IF VLE."SSA Tip Document D394" <> VLE."SSA Tip Document D394"::"Bon Fiscal" THEN
                if not (VLE."SSA Tip Document D394" in [VLE."SSA Tip Document D394"::"Bon Fiscal", VLE."SSA Tip Document D394"::Contract]) then
                    //SSM2101<<
                    TotalCredit += _DetailedVendorLedgEntry."Amount (LCY)";
            until _DetailedVendorLedgEntry.Next = 0;
        //SSM2020<<

        SafTXmlHelper.AddNewXMLNode('PurchaseInvoices', '');
        SafTXmlHelper.AppendXMLNode('NumberOfEntries', Format(TotalRecNo));
        SafTXmlHelper.AppendXMLNode('TotalDebit', FormatAmount(TotalDebit));
        SafTXmlHelper.AppendXMLNode('TotalCredit', FormatAmount(TotalCredit));
        if not _VendorLedgerEntry.FindSet then begin
            SafTXmlHelper.FinalizeXMLNode;
            exit;
        end;

        if GuiAllowed then
            Window.Update(1, ExportingPurchaseDocumentsMsg);

        VLEProgressStep := Round(10000 / TotalRecNo, 1, '<');

        SAFTExportHeader.Get(SAFTExportLine.ID);
        SAFTMappingRange.Get(SAFTExportHeader."Mapping Range Code");

        ExportPurchaseDocument(_VendorLedgerEntry, SAFTMappingRange, SAFTExportHeader);

        VLEProgress += VLEProgressStep;
        if GuiAllowed() then
            Window.Update(2, VLEProgress);

        SAFTExportLine.Get(SAFTExportLine.ID, SAFTExportLine."Line No.");
        SAFTExportLine.LockTable();
        SAFTExportLine.Validate(Progress, VLEProgress);
        SAFTExportLine.Modify(true);
        Commit();
        SafTXmlHelper.FinalizeXMLNode;

    end;

    local procedure ExportPurchaseDocument(var VLE: Record "Vendor Ledger Entry"; SAFTMappingRange: Record "SSAFT Mapping Range"; SAFTExportHeader: Record "SSAFT Export Header")
    var
        Vendor: Record Vendor;
        VendorPostingGroup: Record "Vendor Posting Group";
        GLAccount: Record "G/L Account";
        PIH: Record "Purch. Inv. Header";
        PIL: Record "Purch. Inv. Line";
        PCMH: Record "Purch. Cr. Memo Hdr.";
        PCML: Record "Purch. Cr. Memo Line";
        GeneralPostingSetup: Record "General Posting Setup";
        VATPostingSetup: Record "VAT Posting Setup";
        CountryRegion: Record "Country/Region";
        FAPostingGroup: Record "FA Posting Group";
        WHTTaxCode: Code[10];
    begin
        repeat
            SafTXmlHelper.AddNewXMLNode('Invoice', '');

            //SSM2020>>
            //OC SafTXmlHelper.AppendXMLNode('InvoiceNo',VLE."Document No.");
            if VLE."Document Type" = VLE."Document Type"::Invoice then begin
                if not PIH.Get(VLE."Document No.") then
                    Clear(PIH);
                SafTXmlHelper.AppendXMLNode('InvoiceNo', PIH."Vendor Invoice No.");
            end;
            if VLE."Document Type" = VLE."Document Type"::"Credit Memo" then begin
                if not PCMH.Get(VLE."Document No.") then
                    Clear(PCMH);
                SafTXmlHelper.AppendXMLNode('InvoiceNo', PCMH."Vendor Cr. Memo No.");
            end;
            //SSM2020<<

            SafTXmlHelper.AddNewXMLNode('SupplierInfo', '');
            Vendor.Get(VLE."Vendor No.");
            SafTXmlHelper.AppendXMLNode('SupplierID', GetVendorRegistrationNumber(Vendor));

            CountryRegion.Get(Vendor."Country/Region Code");
            ExportAddress('BillingAddress',
              CombineWithSpaceSAFmiddle2textType(Vendor.Address, Vendor."Address 2"), Vendor.City,
              Vendor."Post Code",
              GetTableMapping(SAFTExportHeader."Mapping Range Code", CountryRegion, GlobalNFTType::"ISO3166-2-CountryCodes"),
              'StreetAddress',
              '');
            SafTXmlHelper.FinalizeXMLNode;

            //SSM1724>>
            //OC VendorPostingGroup.GET(Vendor."Vendor Posting Group");
            VendorPostingGroup.GET(VLE."Vendor Posting Group");
            //SSM1724<<
            GLAccount.Get(VendorPostingGroup."Payables Account");
            SAFTMappingRange.Get(SAFTExportHeader."Mapping Range Code");
            SafTXmlHelper.AppendXMLNode('AccountID', GetTableMapping(SAFTExportHeader."Mapping Range Code", GLAccount, SAFTMappingRange."Chart of Account NFT"));

            SafTXmlHelper.AppendXMLNode('InvoiceDate', FormatDate(VLE."Posting Date"));
            if VLE."Document Type" = VLE."Document Type"::Invoice then begin
                SafTXmlHelper.AppendXMLNode('InvoiceType', '380'); //Invoice
                SafTXmlHelper.AppendXMLNode('SelfBillingIndicator', '0');

                PIL.SetRange("Document No.", VLE."Document No.");
                PIL.SetFilter(Quantity, '<>%1', 0);
                if PIL.FindSet then
                    repeat
                        SafTXmlHelper.AddNewXMLNode('InvoiceLine', '');
                        case PIL.Type of
                            PIL.Type::Item, PIL.Type::"Charge (Item)":
                                begin
                                    GeneralPostingSetup.Get(PIL."Gen. Bus. Posting Group", PIL."Gen. Prod. Posting Group");
                                    GLAccount.Get(GeneralPostingSetup."Purch. Account");
                                    SafTXmlHelper.AppendXMLNode('AccountID', GetTableMapping(SAFTExportHeader."Mapping Range Code", GLAccount, SAFTMappingRange."Chart of Account NFT"));
                                end;
                            PIL.Type::"G/L Account":
                                begin
                                    GLAccount.Get(PIL."No.");
                                    SafTXmlHelper.AppendXMLNode('AccountID', GetTableMapping(SAFTExportHeader."Mapping Range Code", GLAccount, SAFTMappingRange."Chart of Account NFT"));
                                end;
                            PIL.Type::"Fixed Asset":
                                begin
                                    FAPostingGroup.Get(PIL."Posting Group");
                                    GLAccount.Get(FAPostingGroup."Acquisition Cost Account");
                                    SafTXmlHelper.AppendXMLNode('AccountID', GetTableMapping(SAFTExportHeader."Mapping Range Code", GLAccount, SAFTMappingRange."Chart of Account NFT"));
                                end;
                        end;
                        SafTXmlHelper.AppendXMLNode('Quantity', FormatAmount(PIL.Quantity));
                        SafTXmlHelper.AppendXMLNode('UnitPrice', FormatAmount(Round(PIL."Direct Unit Cost", 0.01)));
                        SafTXmlHelper.AppendXMLNode('TaxPointDate', FormatDate(PIL."Posting Date"));
                        SafTXmlHelper.AppendXMLNode('Description', CombineWithSpaceSAFSAFlongtextType(PIL.Description, PIL."Description 2"));
                        //SSM2020>>
                        /*//OC
                        IF PIH."Currency Code" <> '' THEN
                          ExportAmountInfo('InvoiceLineAmount',ROUND(PIL."Amount Including VAT" / PIH."Currency Factor",0.01),VLE."Currency Code",PIL."Amount Including VAT")
                        ELSE
                          ExportAmountInfo('InvoiceLineAmount',PIL."Amount Including VAT",VLE."Currency Code",PIL."Amount Including VAT");
                        */
                        if PIH."Currency Code" <> '' then
                            ExportAmountInfo('InvoiceLineAmount', Round(PIL.Amount / PIH."Currency Factor", 0.01), VLE."Currency Code", PIL.Amount)
                        else
                            ExportAmountInfo('InvoiceLineAmount', PIL.Amount, VLE."Currency Code", PIL.Amount);
                        //SSM2020<<
                        SafTXmlHelper.AppendXMLNode('DebitCreditIndicator', 'D');
                        //SSM2020>>
                        //OC IF (PIL."VAT Bus. Posting Group" <> '') OR (PIL."VAT Prod. Posting Group" <> '') THEN BEGIN
                        if (PIL."VAT Bus. Posting Group" <> '') and (PIL."VAT Prod. Posting Group" <> '') then begin
                            //SSM2020<<
                            //TVA Tax
                            VATPostingSetup.Get(PIL."VAT Bus. Posting Group", PIL."VAT Prod. Posting Group");
                            ExportTaxInformation(GetVATTaxType(SAFTExportHeader), VATPostingSetup."SSAFT Tax Code", PIL."Amount Including VAT" - PIL.Amount);
                        end else begin
                            //WHT Tax
                            //SSM1724>>
                            /*//OC
                            WHTTaxCode := GetWHTTax(SAFTMappingRange.Code,GLAccount."No.");
                            ExportTaxInformation(COPYSTR(WHTTaxCode,1,3),WHTTaxCode,PIL."Amount Including VAT");
                            */
                            WHTTaxCode := GetTax(SAFTMappingRange.Code, GLAccount."No.", GlobalNFTType::"WHT - nomenclator");
                            if WHTTaxCode <> '' then
                                ExportTaxInformation(CopyStr(WHTTaxCode, 1, 3), WHTTaxCode, PIL."Amount Including VAT")
                            else
                                ExportTaxInformation(GetTax(SAFTMappingRange.Code, GLAccount."No.", GlobalNFTType::"TAX-IMP - Impozite"), '000000', PIL."Amount Including VAT")
                            //SSM1724<<
                        end;
                        SafTXmlHelper.FinalizeXMLNode;
                    until PIL.Next = 0;
            end;
            if VLE."Document Type" = VLE."Document Type"::"Credit Memo" then begin
                SafTXmlHelper.AppendXMLNode('InvoiceType', '381'); //Credit Memo
                SafTXmlHelper.AppendXMLNode('SelfBillingIndicator', '0');
                PCML.SetRange("Document No.", VLE."Document No.");
                PCML.SetFilter(Quantity, '<>%1', 0);
                if PCML.FindSet then
                    repeat
                        SafTXmlHelper.AddNewXMLNode('InvoiceLine', '');
                        case PCML.Type of
                            PCML.Type::Item, PCML.Type::"Charge (Item)":
                                begin
                                    GeneralPostingSetup.Get(PCML."Gen. Bus. Posting Group", PCML."Gen. Prod. Posting Group");
                                    GLAccount.Get(GeneralPostingSetup."Purch. Account");
                                    SafTXmlHelper.AppendXMLNode('AccountID', GetTableMapping(SAFTExportHeader."Mapping Range Code", GLAccount, SAFTMappingRange."Chart of Account NFT"));
                                end;
                            PCML.Type::"G/L Account":
                                begin
                                    GLAccount.Get(PCML."No.");
                                    SafTXmlHelper.AppendXMLNode('AccountID', GetTableMapping(SAFTExportHeader."Mapping Range Code", GLAccount, SAFTMappingRange."Chart of Account NFT"));
                                end;
                            PCML.Type::"Fixed Asset":
                                begin
                                    FAPostingGroup.Get(PCML."Posting Group");
                                    GLAccount.Get(FAPostingGroup."Acquisition Cost Account");
                                    SafTXmlHelper.AppendXMLNode('AccountID', GetTableMapping(SAFTExportHeader."Mapping Range Code", GLAccount, SAFTMappingRange."Chart of Account NFT"));
                                end;
                        end;
                        SafTXmlHelper.AppendXMLNode('Quantity', FormatAmount(PCML.Quantity));
                        SafTXmlHelper.AppendXMLNode('UnitPrice', FormatAmount(Round(PCML."Direct Unit Cost", 0.01)));
                        SafTXmlHelper.AppendXMLNode('TaxPointDate', FormatDate(PCML."Posting Date"));
                        SafTXmlHelper.AppendXMLNode('Description', CombineWithSpaceSAFSAFlongtextType(PCML.Description, PCML."Description 2"));
                        //SSM2020>>
                        /*//OC
                        IF PCMH."Currency Code" <> '' THEN
                          ExportAmountInfo('InvoiceLineAmount',ROUND(PCML."Amount Including VAT" / PCMH."Currency Factor",0.01),VLE."Currency Code",PCML."Amount Including VAT")
                        ELSE
                          ExportAmountInfo('InvoiceLineAmount',PCML."Amount Including VAT",VLE."Currency Code",PCML."Amount Including VAT");
                        */
                        if PCMH."Currency Code" <> '' then
                            ExportAmountInfo('InvoiceLineAmount', Round(PCML.Amount / PCMH."Currency Factor", 0.01), VLE."Currency Code", PCML.Amount)
                        else
                            ExportAmountInfo('InvoiceLineAmount', PCML.Amount, VLE."Currency Code", PCML.Amount);
                        //SSM2020<<
                        SafTXmlHelper.AppendXMLNode('DebitCreditIndicator', 'D');
                        //SSM2020>>
                        //OC IF (PCML."VAT Bus. Posting Group" <> '') OR (PCML."VAT Prod. Posting Group" <> '') THEN BEGIN
                        if (PCML."VAT Bus. Posting Group" <> '') and (PCML."VAT Prod. Posting Group" <> '') then begin
                            //SSM2020<<
                            //TVA Tax
                            VATPostingSetup.Get(PCML."VAT Bus. Posting Group", PCML."VAT Prod. Posting Group");
                            ExportTaxInformation(GetVATTaxType(SAFTExportHeader), VATPostingSetup."SSAFT Tax Code", PCML."Amount Including VAT" - PCML.Amount);
                        end else begin
                            //WHT Tax
                            //SSM1724>>
                            /*//OC
                            WHTTaxCode := GetWHTTax(SAFTMappingRange.Code,GLAccount."No.");
                            ExportTaxInformation(COPYSTR(WHTTaxCode,1,3),WHTTaxCode,PCML."Amount Including VAT");
                            */
                            WHTTaxCode := GetTax(SAFTMappingRange.Code, GLAccount."No.", GlobalNFTType::"WHT - nomenclator");
                            if WHTTaxCode <> '' then
                                ExportTaxInformation(CopyStr(WHTTaxCode, 1, 3), WHTTaxCode, PCML."Amount Including VAT")
                            else
                                ExportTaxInformation(GetTax(SAFTMappingRange.Code, GLAccount."No.", GlobalNFTType::"TAX-IMP - Impozite"), '000000', PCML."Amount Including VAT")
                            //SSM1724<<
                        end;
                        SafTXmlHelper.FinalizeXMLNode;
                    until PCML.Next = 0;
            end;
            SafTXmlHelper.FinalizeXMLNode;
        until VLE.Next = 0;

    end;

    local procedure ExportPayments(var _CustLedgerEntry: Record "Cust. Ledger Entry"; var _DetailedCustLedgEntry: Record "Detailed Cust. Ledg. Entry"; var _VendorLedgerEntry: Record "Vendor Ledger Entry"; var _DetailedVendorLedgEntry: Record "Detailed Vendor Ledg. Entry"; var _BankAccountLedgerEntry: Record "Bank Account Ledger Entry"; var SAFTExportLine: Record "SSAFT Export Line")
    var
        SAFTExportHeader: Record "SSAFT Export Header";
        SAFTMappingRange: Record "SSAFT Mapping Range";
        GLSetup: Record "General Ledger Setup";
        GLEntry: Record "G/L Entry";
        TotalRecNo: Integer;
        TotalDebit: Decimal;
        TotalCredit: Decimal;
        CLEProgressStep: Integer;
        CLEProgress: Integer;
    begin
        GLSetup.GET;
        GLEntry.RESET;
        GLEntry.SETCURRENTKEY("Transaction No.");
        if GLSetup."SSAFTG/L Accounts Payments" <> '' then
            GLEntry.SETFILTER("G/L Account No.", GLSetup."SSAFTG/L Accounts Payments");

        Clear(TotalRecNo);
        Clear(TotalCredit);
        Clear(TotalDebit);
        _CustLedgerEntry.SetFilter("Document Type", '%1|%2|%3', _CustLedgerEntry."Document Type"::" ", _CustLedgerEntry."Document Type"::Payment, _CustLedgerEntry."Document Type"::Refund);
        if _CustLedgerEntry.FINDSET then
            repeat
                GLEntry.SETRANGE("Transaction No.", _CustLedgerEntry."Transaction No.");
                if not GLEntry.ISEMPTY then
                    TotalRecNo += 1;
            until _CustLedgerEntry.NEXT = 0;

        _VendorLedgerEntry.SetFilter("Document Type", '%1|%2|%3', _VendorLedgerEntry."Document Type"::" ", _VendorLedgerEntry."Document Type"::Payment, _VendorLedgerEntry."Document Type"::Refund);
        if _VendorLedgerEntry.FINDSET then
            repeat
                GLEntry.SETRANGE("Transaction No.", _VendorLedgerEntry."Transaction No.");
                if not GLEntry.ISEMPTY then
                    TotalRecNo += 1;
            until _VendorLedgerEntry.NEXT = 0;



        _DetailedCustLedgEntry.SetRange("Entry Type", _DetailedCustLedgEntry."Entry Type"::"Initial Entry");
        _DetailedCustLedgEntry.SetFilter("Initial Document Type", '%1|%2|%3',
           _DetailedCustLedgEntry."Initial Document Type"::" ",
           _DetailedCustLedgEntry."Initial Document Type"::Payment,
           _DetailedCustLedgEntry."Initial Document Type"::Refund);
        if _DetailedCustLedgEntry.FINDSET then
            repeat
                GLEntry.SETRANGE("Transaction No.", _DetailedCustLedgEntry."Transaction No.");
                if not GLEntry.ISEMPTY then
                    TotalDebit += -_DetailedCustLedgEntry."Amount (LCY)";
            until _DetailedCustLedgEntry.NEXT = 0;


        _DetailedVendorLedgEntry.SetRange("Entry Type", _DetailedVendorLedgEntry."Entry Type"::"Initial Entry");
        _DetailedVendorLedgEntry.SetFilter("Initial Document Type", '%1|%2|%3',
           _DetailedVendorLedgEntry."Initial Document Type"::" ",
           _DetailedVendorLedgEntry."Initial Document Type"::Payment,
           _DetailedVendorLedgEntry."Initial Document Type"::Refund);
        if _DetailedVendorLedgEntry.FINDSET then
            repeat
                GLEntry.SETRANGE("Transaction No.", _DetailedVendorLedgEntry."Transaction No.");
                if not GLEntry.ISEMPTY then
                    TotalCredit += _DetailedVendorLedgEntry."Amount (LCY)";
            until _DetailedVendorLedgEntry.NEXT = 0;

        //SSM1724>>
        _BankAccountLedgerEntry.CALCSUMS("Debit Amount (LCY)", "Credit Amount (LCY)");
        TotalRecNo += _BankAccountLedgerEntry.Count; //SSM1724
        TotalDebit := TotalDebit + _BankAccountLedgerEntry."Debit Amount (LCY)";
        TotalCredit += _BankAccountLedgerEntry."Credit Amount (LCY)";

        SafTXmlHelper.AddNewXMLNode('Payments', '');
        SafTXmlHelper.AppendXMLNode('NumberOfEntries', Format(TotalRecNo));
        SafTXmlHelper.AppendXMLNode('TotalDebit', FormatAmount(TotalDebit));
        SafTXmlHelper.AppendXMLNode('TotalCredit', FormatAmount(TotalCredit));
        if (not _CustLedgerEntry.FindSet) and (not _VendorLedgerEntry.FindSet) and (not _BankAccountLedgerEntry.FindSet) then begin
            SafTXmlHelper.FinalizeXMLNode;
            exit;
        end;

        if GuiAllowed then
            Window.Update(1, ExportingPaymentsMsg);

        CLEProgressStep := Round(10000 / TotalRecNo, 1, '<');

        SAFTExportHeader.Get(SAFTExportLine.ID);
        SAFTMappingRange.Get(SAFTExportHeader."Mapping Range Code");

        ExportCLEPayment(_CustLedgerEntry, SAFTMappingRange, SAFTExportHeader);
        ExportVLEPayment(_VendorLedgerEntry, SAFTMappingRange, SAFTExportHeader);
        ExportBALEPayment(_BankAccountLedgerEntry, SAFTMappingRange, SAFTExportHeader); //SSM1724

        CLEProgress += CLEProgressStep;
        if GuiAllowed() then
            Window.Update(2, CLEProgress);

        SAFTExportLine.Get(SAFTExportLine.ID, SAFTExportLine."Line No.");
        SAFTExportLine.LockTable();
        SAFTExportLine.Validate(Progress, CLEProgress);
        SAFTExportLine.Modify(true);
        Commit();
        SafTXmlHelper.FinalizeXMLNode;
    end;

    local procedure ExportCLEPayment(var CLE: Record "Cust. Ledger Entry"; SAFTMappingRange: Record "SSAFT Mapping Range"; SAFTExportHeader: Record "SSAFT Export Header")
    var
        Customer: Record Customer;
        CustomerPostingGroup: Record "Customer Posting Group";
        GLAccount: Record "G/L Account";
        PaymentMethod: Record "Payment Method";
        GLEntry: Record "G/L Entry";
        GLEntryVATEntryLink: Record "G/L Entry - VAT Entry Link";
        VATEntry: Record "VAT Entry";
        VATPostingSetup: Record "VAT Posting Setup";
        GLSetup: Record "General Ledger Setup";
        GLEntry2: Record "G/L Entry";
        WHTTaxCode: Code[10];
    begin
        GLSetup.GET;
        GLEntry2.RESET;
        GLEntry2.SETCURRENTKEY("Transaction No.");
        repeat
            GLEntry2.SETFILTER("G/L Account No.", GLSetup."SSAFTG/L Accounts Payments");
            GLEntry2.SETRANGE("Transaction No.", CLE."Transaction No.");
            if not GLEntry2.ISEMPTY then begin
                SafTXmlHelper.AddNewXMLNode('Payment', '');
                SafTXmlHelper.AppendXMLNode('PaymentRefNo', Format(CLE."Entry No."));
                SafTXmlHelper.AppendXMLNode('TransactionDate', FormatDate(CLE."Posting Date"));
                if not PaymentMethod.Get(CLE."Payment Method Code") then
                    Clear(PaymentMethod);
                SafTXmlHelper.AppendXMLNode('PaymentMethod', GetTableMapping(SAFTMappingRange.Code, PaymentMethod, GlobalNFTType::Nom_Mecanisme_plati));
                if CLE.Description <> '' then
                    SafTXmlHelper.AppendXMLNode('Description', CLE.Description)
                else
                    SafTXmlHelper.AppendXMLNode('Description', CLE."Document No.");

                SafTXmlHelper.AddNewXMLNode('PaymentLine', '');
                Customer.Get(CLE."Customer No.");
                //SSM1724>>
                //OC CustomerPostingGroup.GET(Customer."Customer Posting Group");
                CustomerPostingGroup.Get(CLE."Customer Posting Group");
                //SSM1724<<
                GLAccount.Get(CustomerPostingGroup."Receivables Account");
                SAFTMappingRange.Get(SAFTExportHeader."Mapping Range Code");
                SafTXmlHelper.AppendXMLNode('AccountID', GetTableMapping(SAFTExportHeader."Mapping Range Code", GLAccount, SAFTMappingRange."Chart of Account NFT"));
                SafTXmlHelper.AppendXMLNode('CustomerID', GetCustomerRegistrationNumber(Customer));
                SafTXmlHelper.AppendXMLNode('SupplierID', '0');

                //IF CLE.Positive THEN
                SafTXmlHelper.AppendXMLNode('DebitCreditIndicator', 'D');
                //ELSE
                //  SafTXmlHelper.AppendXMLNode('DebitCreditIndicator','C');
                CLE.CalcFields("Original Amt. (LCY)", "Original Amount");
                ExportAmountInfo('PaymentLineAmount', -CLE."Original Amt. (LCY)", CLE."Currency Code", -CLE."Original Amount");

                GLEntry.Get(CLE."Entry No.");
                //SSM2020>>
                //OC IF (GLEntry."VAT Bus. Posting Group" <> '') OR (GLEntry."VAT Prod. Posting Group" <> '') THEN BEGIN
                if (GLEntry."VAT Bus. Posting Group" <> '') and (GLEntry."VAT Prod. Posting Group" <> '') then begin
                    //SSM2020<<
                    //TVA Tax
                    GLEntryVATEntryLink.SetRange("G/L Entry No.", GLEntry."Entry No.");
                    if GLEntryVATEntryLink.FindSet then
                        repeat
                            VATEntry.Get(GLEntryVATEntryLink."VAT Entry No.");
                            if (VATEntry.Type in [VATEntry.Type::Sale, VATEntry.Type::Purchase]) then begin
                                VATPostingSetup.Get(VATEntry."VAT Bus. Posting Group", VATEntry."VAT Prod. Posting Group");
                                ExportTaxInformation(GetVATTaxType(SAFTExportHeader), VATPostingSetup."SSAFT Tax Code", VATEntry.Amount);
                            end;
                        until GLEntryVATEntryLink.Next = 0;
                end else begin
                    //WHT Tax
                    //SSM1724>>
                    /* //OC
                    WHTTaxCode := GetWHTTax(SAFTMappingRange.Code,GLEntry."G/L Account No.");
                    ExportTaxInformation(COPYSTR(WHTTaxCode,1,3),WHTTaxCode,GLEntry.Amount);
                    */
                    WHTTaxCode := GetTax(SAFTMappingRange.Code, GLEntry."G/L Account No.", GlobalNFTType::"WHT - nomenclator");
                    if (WHTTaxCode = '') and (GLEntry."Debit Amount" <> 0) then //Tax-IMP
                        ExportTaxInformation(GetTax(SAFTMappingRange.Code, GLEntry."G/L Account No.", GlobalNFTType::"TAX-IMP - Impozite"), '000000', GLEntry.Amount)
                    else
                        ExportTaxInformation(CopyStr(WHTTaxCode, 1, 3), WHTTaxCode, GLEntry.Amount)

                    //SSM1724<<
                end;
                SafTXmlHelper.FinalizeXMLNode;

                SafTXmlHelper.FinalizeXMLNode;
            end;
        until CLE.Next = 0;

    end;

    local procedure ExportVLEPayment(var VLE: Record "Vendor Ledger Entry"; SAFTMappingRange: Record "SSAFT Mapping Range"; SAFTExportHeader: Record "SSAFT Export Header")
    var
        Vendor: Record Vendor;
        VendorPostingGroup: Record "Vendor Posting Group";
        GLAccount: Record "G/L Account";
        PaymentMethod: Record "Payment Method";
        GLEntry: Record "G/L Entry";
        GLEntryVATEntryLink: Record "G/L Entry - VAT Entry Link";
        VATEntry: Record "VAT Entry";
        VATPostingSetup: Record "VAT Posting Setup";
        GLSetup: Record "General Ledger Setup";
        GLEntry2: Record "G/L Entry";
        WHTTaxCode: Code[10];
    begin
        GLSetup.GET;
        GLEntry2.RESET;
        GLEntry2.SETCURRENTKEY("Transaction No.");
        repeat
            GLEntry2.SETFILTER("G/L Account No.", GLSetup."SSAFTG/L Accounts Payments");
            GLEntry2.SETRANGE("Transaction No.", VLE."Transaction No.");
            if not GLEntry2.ISEMPTY then begin
                SafTXmlHelper.AddNewXMLNode('Payment', '');
                SafTXmlHelper.AppendXMLNode('PaymentRefNo', Format(VLE."Entry No."));
                SafTXmlHelper.AppendXMLNode('TransactionDate', FormatDate(VLE."Posting Date"));
                if not PaymentMethod.Get(VLE."Payment Method Code") then
                    Clear(PaymentMethod);
                SafTXmlHelper.AppendXMLNode('PaymentMethod', GetTableMapping(SAFTMappingRange.Code, PaymentMethod, GlobalNFTType::Nom_Mecanisme_plati));
                if VLE.Description <> '' then
                    SafTXmlHelper.AppendXMLNode('Description', VLE.Description)
                else
                    SafTXmlHelper.AppendXMLNode('Description', VLE."Document No.");

                SafTXmlHelper.AddNewXMLNode('PaymentLine', '');
                Vendor.Get(VLE."Vendor No.");
                //SSM1724>>
                //OC VendorPostingGroup.GET(Vendor."Vendor Posting Group");
                VendorPostingGroup.Get(VLE."Vendor Posting Group");
                //SSM1724<<
                GLAccount.Get(VendorPostingGroup."Payables Account");
                SAFTMappingRange.Get(SAFTExportHeader."Mapping Range Code");
                SafTXmlHelper.AppendXMLNode('AccountID', GetTableMapping(SAFTExportHeader."Mapping Range Code", GLAccount, SAFTMappingRange."Chart of Account NFT"));
                SafTXmlHelper.AppendXMLNode('CustomerID', '0');
                SafTXmlHelper.AppendXMLNode('SupplierID', GetVendorRegistrationNumber(Vendor));
                //IF VLE.Positive THEN
                //  SafTXmlHelper.AppendXMLNode('DebitCreditIndicator','D')
                //ELSE
                SafTXmlHelper.AppendXMLNode('DebitCreditIndicator', 'C');
                VLE.CalcFields("Original Amt. (LCY)", "Original Amount");
                ExportAmountInfo('PaymentLineAmount', VLE."Original Amt. (LCY)", VLE."Currency Code", VLE."Original Amount");

                GLEntry.Get(VLE."Entry No.");
                //SSM2020>>
                //OC IF (GLEntry."VAT Bus. Posting Group" <> '') OR (GLEntry."VAT Prod. Posting Group" <> '') THEN BEGIN
                if (GLEntry."VAT Bus. Posting Group" <> '') and (GLEntry."VAT Prod. Posting Group" <> '') then begin
                    //SSM2020<<
                    //TVA Tax
                    GLEntryVATEntryLink.SetRange("G/L Entry No.", GLEntry."Entry No.");
                    if GLEntryVATEntryLink.FindSet then
                        repeat
                            VATEntry.Get(GLEntryVATEntryLink."VAT Entry No.");
                            if (VATEntry.Type in [VATEntry.Type::Sale, VATEntry.Type::Purchase]) then begin
                                VATPostingSetup.Get(VATEntry."VAT Bus. Posting Group", VATEntry."VAT Prod. Posting Group");
                                ExportTaxInformation(GetVATTaxType(SAFTExportHeader), VATPostingSetup."SSAFT Tax Code", VATEntry.Amount);
                            end;
                        until GLEntryVATEntryLink.Next = 0;
                end else begin
                    //WHT Tax
                    //SSM1724>>
                    /*
                    WHTTaxCode := GetWHTTax(SAFTMappingRange.Code,GLEntry."G/L Account No.");
                    ExportTaxInformation(COPYSTR(WHTTaxCode,1,3),WHTTaxCode,GLEntry.Amount);
                    */
                    WHTTaxCode := GetTax(SAFTMappingRange.Code, GLEntry."G/L Account No.", GlobalNFTType::"WHT - nomenclator");
                    if (WHTTaxCode = '') and (GLEntry."Debit Amount" <> 0) then //Tax-IMP
                        ExportTaxInformation(GetTax(SAFTMappingRange.Code, GLEntry."G/L Account No.", GlobalNFTType::"TAX-IMP - Impozite"), '000000', GLEntry.Amount)
                    else
                        ExportTaxInformation(CopyStr(WHTTaxCode, 1, 3), WHTTaxCode, GLEntry.Amount);

                    //SSM1724<<
                end;

                SafTXmlHelper.FinalizeXMLNode;

                SafTXmlHelper.FinalizeXMLNode;
            end;
        until VLE.Next = 0;

    end;

    local procedure ExportBALEPayment(var BALE: Record "Bank Account Ledger Entry"; SAFTMappingRange: Record "SSAFT Mapping Range"; SAFTExportHeader: Record "SSAFT Export Header")
    var
        GLAccount: Record "G/L Account";
        PaymentMethod: Record "Payment Method";
        BankAccount: Record "Bank Account";
        BankAccountPostingGroup: Record "Bank Account Posting Group";
        CompanyInformation: Record "Company Information";
        WHTTaxCode: Code[10];
    begin

        //SSM1724>>
        repeat
            SafTXmlHelper.AddNewXMLNode('Payment', '');
            SafTXmlHelper.AppendXMLNode('PaymentRefNo', Format(BALE."Entry No."));
            SafTXmlHelper.AppendXMLNode('TransactionDate', FormatDate(BALE."Posting Date"));
            SafTXmlHelper.AppendXMLNode('PaymentMethod', GetTableMapping(SAFTMappingRange.Code, PaymentMethod, GlobalNFTType::Nom_Mecanisme_plati));
            if BALE.Description <> '' then
                SafTXmlHelper.AppendXMLNode('Description', BALE.Description)
            else
                SafTXmlHelper.AppendXMLNode('Description', BALE."Document No.");

            SafTXmlHelper.AddNewXMLNode('PaymentLine', '');
            BankAccount.Get(BALE."Bank Account No.");
            BankAccountPostingGroup.Get(BankAccount."Bank Acc. Posting Group");
            GLAccount.Get(BankAccountPostingGroup."G/L Account No.");
            SAFTMappingRange.Get(SAFTExportHeader."Mapping Range Code");
            SafTXmlHelper.AppendXMLNode('AccountID', GetTableMapping(SAFTExportHeader."Mapping Range Code", GLAccount, SAFTMappingRange."Chart of Account NFT"));
            CompanyInformation.Get;
            SafTXmlHelper.AppendXMLNode('CustomerID', '00' + DelChr(CompanyInformation."VAT Registration No.", '=', 'roRO'));
            SafTXmlHelper.AppendXMLNode('SupplierID', '00' + DelChr(CompanyInformation."VAT Registration No.", '=', 'roRO'));

            if BALE."Debit Amount (LCY)" <> 0 then begin
                SafTXmlHelper.AppendXMLNode('DebitCreditIndicator', 'D');
                ExportAmountInfo('PaymentLineAmount', BALE."Debit Amount (LCY)", BALE."Currency Code", BALE."Debit Amount");
            end;
            if BALE."Credit Amount (LCY)" <> 0 then begin
                SafTXmlHelper.AppendXMLNode('DebitCreditIndicator', 'C');
                ExportAmountInfo('PaymentLineAmount', BALE."Credit Amount (LCY)", BALE."Currency Code", BALE."Credit Amount");
            end;

            //WHT Tax
            WHTTaxCode := GetTax(SAFTMappingRange.Code, BALE."Bal. Account No.", GlobalNFTType::"WHT - nomenclator");
            if (WHTTaxCode = '') and (BALE."Credit Amount" <> 0) then //Tax-IMP
                ExportTaxInformation(GetTax(SAFTMappingRange.Code, BALE."Bal. Account No.", GlobalNFTType::"TAX-IMP - Impozite"), '000000', BALE."Credit Amount (LCY)")
            else
                ExportTaxInformation(CopyStr(WHTTaxCode, 1, 3), WHTTaxCode, BALE."Amount (LCY)");

            //SSM1724<<
            SafTXmlHelper.FinalizeXMLNode;

            SafTXmlHelper.FinalizeXMLNode;
        until BALE.Next = 0;
        //SSM1724<<
    end;

    local procedure ExportMovementOfGoods(var _ItemLedgerEntry: Record "Item Ledger Entry"; var SAFTExportLine: Record "SSAFT Export Line")
    var
        SAFTExportHeader: Record "SSAFT Export Header";
        SAFTMappingRange: Record "SSAFT Mapping Range";
        TotalRecNo: Integer;
        TotalQtyReceived: Decimal;
        TotalQtyIssued: Decimal;
        ILEProgressStep: Integer;
        ILEProgress: Integer;
    begin
        Clear(TotalRecNo);
        Clear(TotalQtyReceived);
        Clear(TotalQtyIssued);
        TotalRecNo += _ItemLedgerEntry.Count;

        _ItemLedgerEntry.SetRange(Positive, true);
        _ItemLedgerEntry.CalcSums(Quantity);
        TotalQtyReceived += _ItemLedgerEntry.Quantity;

        _ItemLedgerEntry.SetRange(Positive, false);
        _ItemLedgerEntry.CalcSums(Quantity);
        TotalQtyIssued += _ItemLedgerEntry.Quantity;

        _ItemLedgerEntry.SetRange(Positive);

        SafTXmlHelper.AddNewXMLNode('MovementOfGoods', '');
        SafTXmlHelper.AppendXMLNode('NumberOfMovementLines', Format(TotalRecNo));
        SafTXmlHelper.AppendXMLNode('TotalQuantityReceived', FormatAmount(TotalQtyReceived));
        SafTXmlHelper.AppendXMLNode('TotalQuantityIssued', FormatAmount(TotalQtyIssued));
        if (not _ItemLedgerEntry.FindSet) then begin
            SafTXmlHelper.FinalizeXMLNode;
            exit;
        end;

        if GuiAllowed then
            Window.Update(1, ExportingMovementOfGoodsMsg);

        ILEProgressStep := Round(10000 / TotalRecNo, 1, '<');

        SAFTExportHeader.Get(SAFTExportLine.ID);
        SAFTMappingRange.Get(SAFTExportHeader."Mapping Range Code");

        ExportStockMovement(_ItemLedgerEntry, SAFTMappingRange, SAFTExportHeader);

        ILEProgress += ILEProgressStep;
        if GuiAllowed() then
            Window.Update(2, ILEProgress);

        SAFTExportLine.Get(SAFTExportLine.ID, SAFTExportLine."Line No.");
        SAFTExportLine.LockTable();
        SAFTExportLine.Validate(Progress, ILEProgress);
        SAFTExportLine.Modify(true);
        Commit();
        SafTXmlHelper.FinalizeXMLNode;
    end;

    local procedure ExportStockMovement(var ILE: Record "Item Ledger Entry"; SAFTMappingRange: Record "SSAFT Mapping Range"; SAFTExportHeader: Record "SSAFT Export Header")
    var
        Item: Record Item;
        InventoryPostingSetup: Record "Inventory Posting Setup";
        GLAccount: Record "G/L Account";
        Customer: Record Customer;
        Vendor: Record Vendor;
        CompanyInformation: Record "Company Information";
    begin
        repeat
            SafTXmlHelper.AddNewXMLNode('StockMovement', '');
            SafTXmlHelper.AppendXMLNode('MovementReference', Format(ILE."Entry No."));
            SafTXmlHelper.AppendXMLNode('MovementDate', FormatDate(ILE."Posting Date"));
            //SSM2101>>
            /*//OC
            IF ILE."Document Type" <> ILE."Document Type"::"Internal Consumption" THEN
              SafTXmlHelper.AppendXMLNode('MovementType',GetTableFieldMapping(SAFTMappingRange.Code,ILE,FORMAT(ILE."SSA Document Type"),GlobalNFTType::"Nomenclator stocuri"))
            ELSE
            */
            //SSM2101<<
            if GetTableFieldMapping(SAFTMappingRange.Code, ILE, Format(ILE."Document Type"), GlobalNFTType::"Nomenclator stocuri") <> '' then
                SafTXmlHelper.AppendXMLNode('MovementType', GetTableFieldMapping(SAFTMappingRange.Code, ILE, Format(ILE."Document Type"), GlobalNFTType::"Nomenclator stocuri"))
            else
                SafTXmlHelper.AppendXMLNode('MovementType', GetTableFieldMapping(SAFTMappingRange.Code, ILE, Format(ILE."Entry Type"), GlobalNFTType::"Nomenclator stocuri"));

            SafTXmlHelper.AddNewXMLNode('StockMovementLine', '');
            SafTXmlHelper.AppendXMLNode('LineNumber', Format(ILE."Entry No."));
            Item.Get(ILE."Item No.");
            InventoryPostingSetup.Get(ILE."Location Code", Item."Inventory Posting Group");
            //IF NOT InventoryPostingSetup.GET(ILE."Location Code",Item."Inventory Posting Group") THEN
            //  GLAccount.GET('351.08');
            GLAccount.Get(InventoryPostingSetup."Inventory Account");
            SafTXmlHelper.AppendXMLNode('AccountID', GetTableMapping(SAFTMappingRange.Code, GLAccount, SAFTMappingRange."Chart of Account NFT"));
            case ILE."Source Type" of
                ILE."Source Type"::Customer:
                    begin
                        Customer.Get(ILE."Source No.");
                        SafTXmlHelper.AppendXMLNode('CustomerID', GetCustomerRegistrationNumber(Customer));
                        SafTXmlHelper.AppendXMLNode('SupplierID', '0');
                    end;
                ILE."Source Type"::Vendor:
                    begin
                        Vendor.Get(ILE."Source No.");
                        SafTXmlHelper.AppendXMLNode('CustomerID', '0');
                        SafTXmlHelper.AppendXMLNode('SupplierID', GetVendorRegistrationNumber(Vendor));
                    end;
                else begin
                    CompanyInformation.Get;
                    SafTXmlHelper.AppendXMLNode('CustomerID', '00' + DelChr(CompanyInformation."VAT Registration No.", '=', 'roRO'));
                    SafTXmlHelper.AppendXMLNode('SupplierID', '00' + DelChr(CompanyInformation."VAT Registration No.", '=', 'roRO'));
                end;
            end;

            SafTXmlHelper.AppendXMLNode('ProductCode', Item."No.");
            SafTXmlHelper.AppendXMLNode('Quantity', FormatAmount(ILE.Quantity));

            //SSM2101>>
            /*//OC
              IF ILE."SSA Document Type" <> ILE."SSA Document Type"::" " THEN
              SafTXmlHelper.AppendXMLNode('MovementSubType',GetTableFieldMapping(SAFTMappingRange.Code,ILE,FORMAT(ILE."SSA Document Type"),GlobalNFTType::"Nomenclator stocuri"))
            ELSE
            */
            //SSM2101<<
            if GetTableFieldMapping(SAFTMappingRange.Code, ILE, Format(ILE."Document Type"), GlobalNFTType::"Nomenclator stocuri") <> '' then
                SafTXmlHelper.AppendXMLNode('MovementSubType', GetTableFieldMapping(SAFTMappingRange.Code, ILE, Format(ILE."Document Type"), GlobalNFTType::"Nomenclator stocuri"))
            else
                SafTXmlHelper.AppendXMLNode('MovementSubType', GetTableFieldMapping(SAFTMappingRange.Code, ILE, Format(ILE."Entry Type"), GlobalNFTType::"Nomenclator stocuri"));

            SafTXmlHelper.FinalizeXMLNode;

            SafTXmlHelper.FinalizeXMLNode;
        until ILE.Next = 0;

    end;

    local procedure ExportAssetTransactions(var _FALedgerEntry: Record "FA Ledger Entry"; var SAFTExportLine: Record "SSAFT Export Line")
    var
        SAFTExportHeader: Record "SSAFT Export Header";
        SAFTMappingRange: Record "SSAFT Mapping Range";
        FASetup: Record "FA Setup";
        NameValueBuffer: Record "Name/Value Buffer" temporary;
        TempFALE: Record "FA Ledger Entry" temporary;
        TotalRecNo: Integer;
        FAProgressStep: Integer;
        FAProgress: Integer;
        TotalCount: Integer;
        RecNo: Integer;
    begin
        if GUIALLOWED then begin
            Window.UPDATE(1, CountingAssetTransactions);
            TotalCount := _FALedgerEntry.COUNT;
            CLEAR(RecNo);
        end;
        NameValueBuffer.RESET;
        NameValueBuffer.DELETEALL;
        FASetup.GET;
        FASetup.TESTFIELD("SSAFT Posting Group Filter");

        TempFALE.RESET;
        TempFALE.DELETEALL;
        _FALedgerEntry.SETFILTER("FA Posting Group", FASetup."SSAFT Posting Group Filter");
        if _FALedgerEntry.FINDSET then
            repeat
                if GUIALLOWED then begin
                    RecNo += 1;
                    Window.UPDATE(2, ROUND(RecNo / TotalCount * 10000, 1));
                end;
                NameValueBuffer.SETRANGE(Name, FORMAT(_FALedgerEntry."Transaction No."));
                NameValueBuffer.SETRANGE(Value, _FALedgerEntry."FA No.");
                if NameValueBuffer.ISEMPTY then
                    NameValueBuffer.AddNewEntry(FORMAT(_FALedgerEntry."Transaction No."), _FALedgerEntry."FA No.");

                if not TempFALE.GET(_FALedgerEntry."Transaction No.") then begin
                    TempFALE.INIT;
                    TempFALE.TRANSFERFIELDS(_FALedgerEntry);
                    TempFALE."Entry No." := _FALedgerEntry."Transaction No.";
                    TempFALE.INSERT;
                end else begin
                    if _FALedgerEntry."FA Posting Category" <> _FALedgerEntry."FA Posting Category"::" " then
                        TempFALE."FA Posting Category" := _FALedgerEntry."FA Posting Category";

                    TempFALE.Amount += _FALedgerEntry.Amount;
                    TempFALE.MODIFY;
                end;
                if (_FALedgerEntry."FA Posting Type" = _FALedgerEntry."FA Posting Type"::"Proceeds on Disposal") and
                   (_FALedgerEntry.Amount <> 0)
                then begin
                    TempFALE."FA Posting Type" := _FALedgerEntry."FA Posting Type"::"Book Value on Disposal";
                    TempFALE.MODIFY;
                end;
                if TempFALE."FA Posting Type" in [TempFALE."FA Posting Type"::Appreciation,
                   TempFALE."FA Posting Type"::"Write-Down",
                   TempFALE."FA Posting Type"::"Custom 1",
                   TempFALE."FA Posting Type"::"Custom 2",
                   TempFALE."FA Posting Type"::"Salvage Value",
                   TempFALE."FA Posting Type"::"Gain/Loss"]
                then begin
                    TempFALE."FA Posting Type" := _FALedgerEntry."FA Posting Type";
                    TempFALE.MODIFY;
                end;
            //SSM2590<<
            until _FALedgerEntry.NEXT = 0;

        TempFALE.RESET;
        CLEAR(TotalRecNo);
        TotalRecNo += TempFALE.COUNT;
        //SSM2020<<

        SafTXmlHelper.AddNewXMLNode('AssetTransactions', '');
        SafTXmlHelper.AppendXMLNode('NumberOfAssetTransactions', FORMAT(TotalRecNo));
        if (not _FALedgerEntry.FINDSET) then begin
            SafTXmlHelper.FinalizeXMLNode;
            exit;
        end;

        SAFTExportHeader.GET(SAFTExportLine.ID);
        SAFTMappingRange.GET(SAFTExportHeader."Mapping Range Code");

        ExportAssetTrans(NameValueBuffer, TempFALE, SAFTMappingRange, SAFTExportHeader);

        FAProgressStep := ROUND(10000 / TotalRecNo, 1, '<');
        FAProgress += FAProgressStep;

        SAFTExportLine.GET(SAFTExportLine.ID, SAFTExportLine."Line No.");
        SAFTExportLine.LOCKTABLE();
        SAFTExportLine.VALIDATE(Progress, FAProgress);
        SAFTExportLine.MODIFY(true);
        COMMIT();
        SafTXmlHelper.FinalizeXMLNode;
    end;

    local procedure ExportAssetTrans(var _NameValueBuffer: Record "Name/Value Buffer" temporary; var _TempFALE: Record "FA Ledger Entry" temporary; SAFTMappingRange: Record "SSAFT Mapping Range"; SAFTExportHeader: Record "SSAFT Export Header")
    var
        FASetup: Record "FA Setup";
        FixedAsset: Record "Fixed Asset";
        FALedgerEntry: Record "FA Ledger Entry";
        AcquisitionAndProductionCostsOnTransaction: Decimal;
        BookValueOnTransaction: Decimal;
        AssetTransactionAmount: Decimal;
        FADepreciationBook: Record "FA Depreciation Book";
        TotalRecNo: Integer;
        RecNo: Integer;
    begin
        if GUIALLOWED then begin
            Window.UPDATE(1, ExportingAssetTransactions);
            TotalRecNo := _TempFALE.COUNT;
            CLEAR(RecNo);
        end;
        _NameValueBuffer.RESET;

        FALedgerEntry.RESET;
        FALedgerEntry.SETCURRENTKEY("FA No.", "Depreciation Book Code", "FA Posting Category", "FA Posting Type", "FA Posting Date", "Part of Book Value", "Reclassification Entry");

        FASetup.GET;
        _TempFALE.RESET;

        if _TempFALE.FINDSET then
            repeat
                if GUIALLOWED then begin
                    RecNo += 1;
                    Window.UPDATE(2, ROUND(RecNo / TotalRecNo * 10000, 1));
                end;

                _NameValueBuffer.SETRANGE(Name, FORMAT(_TempFALE."Transaction No."));
                if _NameValueBuffer.FINDSET then
                    repeat

                        if not FixedAsset.GET(_NameValueBuffer.Value) then begin
                            FixedAsset.GET(_TempFALE."Canceled from FA No.");
                            FALedgerEntry.SETRANGE("FA No.");
                        end else
                            FALedgerEntry.SETRANGE("FA No.", FixedAsset."No.");

                        FADepreciationBook.SETRANGE("FA No.", FixedAsset."No.");
                        FADepreciationBook.FINDFIRST;
                        FADepreciationBook.SETRANGE("FA Posting Date Filter", _TempFALE."Posting Date");

                        FALedgerEntry.SETRANGE("Depreciation Book Code", _TempFALE."Depreciation Book Code");
                        FALedgerEntry.SETRANGE("Transaction No.", _TempFALE."Transaction No.");
                        FALedgerEntry.SETRANGE("Posting Date", _TempFALE."Posting Date");

                        case _TempFALE."FA Posting Type" of
                            _TempFALE."FA Posting Type"::"Book Value on Disposal": //Vanzare
                                begin
                                    AcquisitionAndProductionCostsOnTransaction := 0;

                                    FALedgerEntry.SETRANGE("FA Posting Type", FALedgerEntry."FA Posting Type"::"Book Value on Disposal");
                                    FALedgerEntry.SETRANGE("FA Posting Category", FALedgerEntry."FA Posting Category"::Disposal);
                                    if FALedgerEntry.FINDFIRST then
                                        BookValueOnTransaction := FALedgerEntry.Amount
                                    else
                                        BookValueOnTransaction := 0;

                                    FALedgerEntry.SETRANGE("FA Posting Type", FALedgerEntry."FA Posting Type"::"Gain/Loss");
                                    FALedgerEntry.SETRANGE("FA Posting Category", FALedgerEntry."FA Posting Category"::" ");
                                    if FALedgerEntry.FINDFIRST then
                                        AssetTransactionAmount := -FALedgerEntry.Amount
                                    else
                                        AssetTransactionAmount := 0;
                                end;
                            _TempFALE."FA Posting Type"::"Proceeds on Disposal": //Casare
                                begin
                                    AcquisitionAndProductionCostsOnTransaction := 0;

                                    FALedgerEntry.SETRANGE("FA Posting Type", FALedgerEntry."FA Posting Type"::"Proceeds on Disposal");
                                    FALedgerEntry.SETRANGE("FA Posting Category", FALedgerEntry."FA Posting Category"::" ");
                                    if FALedgerEntry.FINDFIRST then
                                        BookValueOnTransaction := FALedgerEntry.Amount
                                    else
                                        BookValueOnTransaction := 0;

                                    FALedgerEntry.SETRANGE("FA Posting Type", FALedgerEntry."FA Posting Type"::"Gain/Loss");
                                    FALedgerEntry.SETRANGE("FA Posting Category", FALedgerEntry."FA Posting Category"::" ");
                                    if FALedgerEntry.FINDFIRST then
                                        AssetTransactionAmount := -FALedgerEntry.Amount
                                    else
                                        AssetTransactionAmount := 0;
                                end;
                            _TempFALE."FA Posting Type"::Depreciation: //Amortizare
                                begin
                                    AcquisitionAndProductionCostsOnTransaction := 0;

                                    FALedgerEntry.SETRANGE("FA Posting Type", FALedgerEntry."FA Posting Type"::Depreciation);
                                    FALedgerEntry.SETRANGE("FA Posting Category", FALedgerEntry."FA Posting Category"::" ");
                                    if FALedgerEntry.FINDFIRST then
                                        BookValueOnTransaction := FALedgerEntry.Amount
                                    else
                                        BookValueOnTransaction := 0;

                                    AssetTransactionAmount := BookValueOnTransaction

                                end;
                            _TempFALE."FA Posting Type"::"Acquisition Cost": //Achizitie
                                begin
                                    FALedgerEntry.SETRANGE("FA Posting Type", FALedgerEntry."FA Posting Type"::"Acquisition Cost");
                                    FALedgerEntry.SETRANGE("FA Posting Category", FALedgerEntry."FA Posting Category"::" ");
                                    if FALedgerEntry.FINDFIRST then
                                        AcquisitionAndProductionCostsOnTransaction := FALedgerEntry.Amount
                                    else
                                        AcquisitionAndProductionCostsOnTransaction := 0;

                                    BookValueOnTransaction := AcquisitionAndProductionCostsOnTransaction;

                                    AssetTransactionAmount := AcquisitionAndProductionCostsOnTransaction;
                                end;
                        end;

                        SafTXmlHelper.AddNewXMLNode('AssetTransaction', '');
                        SafTXmlHelper.AppendXMLNode('AssetTransactionID', FORMAT(_TempFALE."Entry No."));
                        SafTXmlHelper.AppendXMLNode('AssetID', FixedAsset."No.");

                        SafTXmlHelper.AppendXMLNode('AssetTransactionType', GetTableFieldMapping(SAFTMappingRange.Code, _TempFALE, FORMAT(_TempFALE."FA Posting Type"), GlobalNFTType::"Nomenclator imobilizari"));

                        SafTXmlHelper.AppendXMLNode('AssetTransactionDate', FormatDate(_TempFALE."Posting Date"));
                        SafTXmlHelper.AppendXMLNode('TransactionID', FORMAT(_TempFALE."Transaction No."));

                        SafTXmlHelper.AddNewXMLNode('AssetTransactionValuations', '');
                        SafTXmlHelper.AddNewXMLNode('AssetTransactionValuation', '');
                        SafTXmlHelper.AppendXMLNode('AcquisitionAndProductionCostsOnTransaction', FormatAmount(AcquisitionAndProductionCostsOnTransaction));
                        SafTXmlHelper.AppendXMLNode('BookValueOnTransaction', FormatAmount(BookValueOnTransaction));
                        SafTXmlHelper.AppendXMLNode('AssetTransactionAmount', FormatAmount(AssetTransactionAmount));
                        SafTXmlHelper.FinalizeXMLNode;

                        SafTXmlHelper.FinalizeXMLNode;

                        SafTXmlHelper.FinalizeXMLNode;
                    until _NameValueBuffer.NEXT = 0;
            until _TempFALE.NEXT = 0;
    end;

    local procedure ExportTaxInformation(_TaxType: Code[10]; _TaxCode: Code[10]; _TaxAmount: Decimal)
    begin
        //SSM1724>>
        SafTXmlHelper.AddNewXMLNode('TaxInformation', '');
        if _TaxType <> '' then begin
            SafTXmlHelper.AppendXMLNode('TaxType', _TaxType);
            SafTXmlHelper.AppendXMLNode('TaxCode', _TaxCode);
            //SSM2020>>
            //OC ExportAmountInfo('TaxAmount',ABS(_TaxAmount),'',ABS(_TaxAmount));
            ExportAmountInfo('TaxAmount', _TaxAmount, '', _TaxAmount);
            //SSM2020<<
        end else begin
            SafTXmlHelper.AppendXMLNode('TaxType', '000');
            SafTXmlHelper.AppendXMLNode('TaxCode', '000000');
            ExportAmountInfo('TaxAmount', 0, '', 0);
        end;
        /*
        IF _TaxCode <> '' THEN BEGIN
          SafTXmlHelper.AppendXMLNode('TaxType',_TaxType);
          SafTXmlHelper.AppendXMLNode('TaxCode',_TaxCode);
          ExportAmountInfo('TaxAmount',ABS(_TaxAmount),'',ABS(_TaxAmount));
        END ELSE BEGIN
          SafTXmlHelper.AppendXMLNode('TaxType','000');
          SafTXmlHelper.AppendXMLNode('TaxCode','000000');
          ExportAmountInfo('TaxAmount',0,'',0);
        END;
        */
        SafTXmlHelper.FinalizeXMLNode;
        //SSM1724<<

    end;

    local procedure ExportAmountInfo(ParentNodeName: Text; Amount: Decimal; _CurrencyCode: Code[10]; _CurrencyAmount: Decimal)
    var
        SAFTExportMgt: Codeunit "SSAFT Export Mgt.";
    begin
        SafTXmlHelper.AddNewXMLNode(ParentNodeName, '');
        SafTXmlHelper.AppendXMLNode('Amount', FormatAmount(Amount));
        SafTXmlHelper.AppendXMLNode('CurrencyCode', SAFTExportMgt.GetISOCurrencyCode(_CurrencyCode));
        SafTXmlHelper.AppendXMLNode('CurrencyAmount', FormatAmount(_CurrencyAmount));
        SafTXmlHelper.FinalizeXMLNode;
    end;

    local procedure ExportBankAccount(CountryCode: Code[10]; BankName: Text; BankNumber: Text; IBAN: Text; BranchNo: Text; CurrencyCode: Code[10])
    var
        TempNameValueBuffer: Record "Name/Value Buffer" temporary;
        Exported: Boolean;
    begin
        if (IBAN = '') and (BankNumber = '') and (BankName = '') and (BranchNo = '') then
            exit;

        GetBankAccInfo(TempNameValueBuffer, CountryCode, BankName, BankNumber, IBAN, BranchNo);
        Exported := false;
        if not TempNameValueBuffer.FindSet then
            exit;

        SafTXmlHelper.AddNewXMLNode('BankAccount', '');
        repeat
            if TempNameValueBuffer.Value <> '' then begin
                SafTXmlHelper.AppendXMLNode(TempNameValueBuffer.Name, TempNameValueBuffer.Value);
                Exported := true;
            end;
        until (TempNameValueBuffer.Next = 0) or Exported;
        SafTXmlHelper.FinalizeXMLNode;
    end;

    local procedure GetBankAccInfo(var TempNameValueBuffer: Record "Name/Value Buffer" temporary; CountryCode: Code[10]; BankName: Text; BankNumber: Text; IBAN: Text; BranchNo: Text)
    begin
        TempNameValueBuffer.Reset;
        TempNameValueBuffer.DeleteAll;
        InsertTempNameValueBuffer(TempNameValueBuffer, 'IBANNumber', IBAN);
        InsertTempNameValueBuffer(TempNameValueBuffer, 'BankAccountNumber', BankNumber);
        InsertTempNameValueBuffer(TempNameValueBuffer, 'BankAccountName', BankName);
        InsertTempNameValueBuffer(TempNameValueBuffer, 'SortCode', BranchNo);
    end;

    local procedure InsertTempNameValueBuffer(var TempNameValueBuffer: Record "Name/Value Buffer" temporary; Name: Text; Value: Text)
    begin
        TempNameValueBuffer.ID += 1;
        TempNameValueBuffer.Name := CopyStr(Name, 1, MaxStrLen(TempNameValueBuffer.Name));
        TempNameValueBuffer.Value := CopyStr(Value, 1, MaxStrLen(TempNameValueBuffer.Value));
        if not TempNameValueBuffer.Insert then
            TempNameValueBuffer.Modify;
    end;

    local procedure ExportAnalysisInfo(var TempDimCodeAmountBuffer: Record "Dimension Code Amount Buffer" temporary)
    begin
        if TempDimCodeAmountBuffer.FindSet then
            repeat
                SafTXmlHelper.AddNewXMLNode('Analysis', '');
                SafTXmlHelper.AppendXMLNode('AnalysisType', TempDimCodeAmountBuffer."Line Code");
                SafTXmlHelper.AppendXMLNode('AnalysisID', TempDimCodeAmountBuffer."Column Code");
                SafTXmlHelper.FinalizeXMLNode;
            until TempDimCodeAmountBuffer.Next = 0;
    end;

    local procedure GetFirstAndLastNameFromContactName(var FirstName: Text; var LastName: Text; ContactName: Text)
    var
        SpacePos: Integer;
    begin
        SpacePos := StrPos(ContactName, ' ');
        if SpacePos = 0 then begin
            FirstName := ContactName;
            LastName := '-';
        end else begin
            FirstName := CopyStr(ContactName, 1, SpacePos - 1);
            LastName := CopyStr(ContactName, SpacePos + 1, StrLen(ContactName) - SpacePos);
        end;
    end;

    local procedure FinalizeExport(var SAFTExportLine: Record "SSAFT Export Line"; SAFTExportHeader: Record "SSAFT Export Header")
    var
        SAFTExportMgt: Codeunit "SSAFT Export Mgt.";
        TypeHelper: Codeunit "Type Helper";
    begin
        SAFTExportLine.Get(SAFTExportLine.ID, SAFTExportLine."Line No.");
        SAFTExportLine.LockTable;
        SafTXmlHelper.WriteXmlDocToAuditLine(SAFTExportLine);
        SAFTExportLine.Validate(Status, SAFTExportLine.Status::Completed);
        SAFTExportLine.Validate(Progress, 10000);
        SAFTExportLine.Validate("Created Date/Time", TypeHelper.GetCurrentDateTimeInUserTimeZone);
        SAFTExportLine.Modify(true);
        Commit;
        SAFTExportMgt.UpdateExportStatus(SAFTExportHeader);
        SAFTExportMgt.LogSuccess(SAFTExportLine);
        SAFTExportMgt.StartExportLinesNotStartedYet(SAFTExportHeader);
        SAFTExportHeader.Get(SAFTExportHeader.ID);
        if SAFTExportHeader.Status = SAFTExportHeader.Status::Completed then
            SAFTExportMgt.BuildZipFilesWithAllRelatedXmlFiles(SAFTExportHeader);
    end;

    local procedure FinalizeExportSingleFile(SAFTExportHeader: Record "SSAFT Export Header")
    var
        SAFTExportMgt: Codeunit "SSAFT Export Mgt.";
    begin
        SafTXmlHelper.WriteXmlDocToAuditHeader(SAFTExportHeader);
        SAFTExportHeader.Modify(true);
        Commit;
        SAFTExportMgt.UpdateExportStatus(SAFTExportHeader);
        SAFTExportMgt.StartExportLinesNotStartedYet(SAFTExportHeader);
    end;

    local procedure CombineWithSpaceSAFmiddle2textType(FirstString: Text; SecondString: Text) Result: Text
    begin
        Result := FirstString;
        if (Result <> '') and (SecondString <> '') then
            Result += ' ';
        exit(CopyStr(Result + SecondString, 1, 70));
    end;

    local procedure CombineWithSpaceSAFSAFlongtextType(FirstString: Text; SecondString: Text) Result: Text
    begin
        Result := FirstString;
        if (Result <> '') and (SecondString <> '') then
            Result += ' ';
        exit(CopyStr(Result + SecondString, 1, 256));
    end;

    local procedure CombineWithSpaceSAFshorttextType(FirstString: Text; SecondString: Text) Result: Text
    begin
        Result := FirstString;
        if (Result <> '') and (SecondString <> '') then
            Result += ' ';
        exit(CopyStr(Result + SecondString, 1, 18));
    end;

    local procedure CombineWithSpaceSAFCodeType(FirstString: Text) Result: Code[10]
    begin
        Result := FirstString;
        exit(CopyStr(Result, 1, 9));
    end;

    local procedure FormatDate(DateToFormat: Date): Text
    begin
        exit(Format(DateToFormat, 0, 9));
    end;

    local procedure FormatAmount(AmountToFormat: Decimal): Text
    begin
        exit(Format(AmountToFormat, 0, 9))
    end;

    local procedure GetTableMapping(_MappingRangeCode: Code[20]; _Variant: Variant; _NFTType: Integer): Code[50]
    var
        RecRef: RecordRef;
        FldRef: FieldRef;
        KeyReference: KeyRef;
        SAFTNAVMapping: Record "SSAFT-NAV Mapping";
        FieldValue: Code[20];
    begin
        RecRef.GetTable(_Variant);

        KeyReference := RecRef.KeyIndex(1);
        FldRef := KeyReference.FieldIndex(1);
        FieldValue := FldRef.Value;

        SAFTNAVMapping.Reset;
        SAFTNAVMapping.SetRange("NFT Type", _NFTType);
        SAFTNAVMapping.SetRange("Mapping Range Code", _MappingRangeCode);
        SAFTNAVMapping.SetRange("Table ID", RecRef.Number);
        SAFTNAVMapping.SetRange("NAV Code", FieldValue);
        SAFTNAVMapping.FindFirst;

        exit(SAFTNAVMapping."SAFT Code");
    end;

    local procedure GetValueMapping(_MappingRangeCode: Code[20]; _NAVCode: Text; _NFTType: Integer): Code[50]
    var
        SAFTNAVMapping: Record "SSAFT-NAV Mapping";
    begin
        SAFTNAVMapping.Reset;
        SAFTNAVMapping.SetRange("NFT Type", _NFTType);
        SAFTNAVMapping.SetRange("Mapping Range Code", _MappingRangeCode);
        SAFTNAVMapping.SetRange("NAV Code", _NAVCode);
        SAFTNAVMapping.FindFirst;

        exit(SAFTNAVMapping."SAFT Code");
    end;

    local procedure GetTableFieldMapping(_MappingRangeCode: Code[20]; _Variant: Variant; _FieldValue: Code[50]; _NFTType: Integer): Code[50]
    var
        RecRef: RecordRef;
        SAFTNAVMapping: Record "SSAFT-NAV Mapping";
    begin
        RecRef.GetTable(_Variant);

        SAFTNAVMapping.Reset;
        SAFTNAVMapping.SetRange("NFT Type", _NFTType);
        SAFTNAVMapping.SetRange("Mapping Range Code", _MappingRangeCode);
        SAFTNAVMapping.SetRange("Table ID", RecRef.Number);
        SAFTNAVMapping.SetRange("NAV Code", _FieldValue);
        if not SAFTNAVMapping.FindFirst then
            exit('');

        exit(SAFTNAVMapping."SAFT Code");
    end;

    local procedure ExportEmptySections(SAFTExportLine: Record "SSAFT Export Line"; _Before: Boolean)
    var
        SAFTExportLine2: Record "SSAFT Export Line";
    begin
        SAFTExportLine2.Reset;
        SAFTExportLine2.SetRange(ID, SAFTExportLine.ID);
        if _Before then
            SAFTExportLine2.SetFilter("Line No.", '<%1', SAFTExportLine."Line No.")
        else
            SAFTExportLine2.SetFilter("Line No.", '>%1', SAFTExportLine."Line No.");

        if SAFTExportLine2.FindSet then
            repeat
                ExportEmptySection(SAFTExportLine2);
            until SAFTExportLine2.Next = 0;
    end;

    local procedure ExportEmptySection(SAFTExportLine: Record "SSAFT Export Line")
    var
        SAFTExportHeader: Record "SSAFT Export Header";
    begin
        case SAFTExportLine."Type of Line" of
            SAFTExportLine."Type of Line"::"G/L Accounts":
                begin
                    SafTXmlHelper.AddNewXMLNode('MasterFiles', '');
                    SafTXmlHelper.AddNewXMLNode('GeneralLedgerAccounts', '');
                    SafTXmlHelper.FinalizeXMLNode;
                end;
            SAFTExportLine."Type of Line"::Customers:
                begin
                    SafTXmlHelper.AddNewXMLNode('Customers', '');
                    SafTXmlHelper.FinalizeXMLNode;
                end;
            SAFTExportLine."Type of Line"::Suppliers:
                begin
                    SafTXmlHelper.AddNewXMLNode('Suppliers', '');
                    SafTXmlHelper.FinalizeXMLNode;
                end;
            SAFTExportLine."Type of Line"::"Tax Table":
                begin
                    SafTXmlHelper.AddNewXMLNode('TaxTable', '');
                    SafTXmlHelper.FinalizeXMLNode;
                end;
            SAFTExportLine."Type of Line"::"UoM Table":
                begin
                    SafTXmlHelper.AddNewXMLNode('UOMTable', '');
                    SafTXmlHelper.FinalizeXMLNode;
                end;
            SAFTExportLine."Type of Line"::"Analysis Type Table":
                begin
                    SafTXmlHelper.AddNewXMLNode('AnalysisTypeTable', '');
                    SafTXmlHelper.FinalizeXMLNode;
                end;
            SAFTExportLine."Type of Line"::"Movement Type Table":
                begin
                    SafTXmlHelper.AddNewXMLNode('MovementTypeTable', '');
                    SafTXmlHelper.FinalizeXMLNode;
                end;
            SAFTExportLine."Type of Line"::Products:
                begin
                    SafTXmlHelper.AddNewXMLNode('Products', '');
                    SafTXmlHelper.FinalizeXMLNode;
                end;
            //  SAFTExportLine."Type of Line"::"Physical Stock":
            //    BEGIN
            //      SafTXmlHelper.AddNewXMLNode('PhysicalStock','');
            //      SafTXmlHelper.AddNewXMLNode('PhysicalStockEntry','0');
            //      SafTXmlHelper.FinalizeXMLNode;
            //      SafTXmlHelper.FinalizeXMLNode;
            //    END;
            SAFTExportLine."Type of Line"::Owners:
                begin
                    SafTXmlHelper.AddNewXMLNode('Owners', '');
                    SafTXmlHelper.FinalizeXMLNode;
                end;
            SAFTExportLine."Type of Line"::Assets:
                begin
                    SafTXmlHelper.AddNewXMLNode('Assets', '');
                    SafTXmlHelper.FinalizeXMLNode;
                    SafTXmlHelper.FinalizeXMLNode;
                end;
            SAFTExportLine."Type of Line"::"G/L Entries":
                begin
                    SafTXmlHelper.AddNewXMLNode('GeneralLedgerEntries', '');
                    SafTXmlHelper.FinalizeXMLNode;
                end;
            SAFTExportLine."Type of Line"::"Sales Invoices":
                begin
                    SafTXmlHelper.AddNewXMLNode('SourceDocuments', '');
                    SafTXmlHelper.AddNewXMLNode('SalesInvoices', '');
                    SafTXmlHelper.FinalizeXMLNode;
                end;
            SAFTExportLine."Type of Line"::"Purchase Invoices":
                begin
                    SafTXmlHelper.AddNewXMLNode('PurchaseInvoices', '');
                    SafTXmlHelper.FinalizeXMLNode;
                end;
            SAFTExportLine."Type of Line"::Payments:
                begin
                    SafTXmlHelper.AddNewXMLNode('Payments', '');
                    SafTXmlHelper.FinalizeXMLNode;
                end;
            SAFTExportLine."Type of Line"::"Movement of Goods":
                begin
                    SafTXmlHelper.AddNewXMLNode('MovementOfGoods', '');
                    SafTXmlHelper.FinalizeXMLNode;
                end;
            SAFTExportLine."Type of Line"::"Asset Transactions":
                begin
                    SAFTExportHeader.Get(SAFTExportLine.ID);
                    if SAFTExportHeader."Header Comment SAFT Type" = SAFTExportHeader."Header Comment SAFT Type"::"A - pentru declaratii anuale" then begin
                        SafTXmlHelper.AddNewXMLNode('AssetTransactions', '');
                        SafTXmlHelper.AppendXMLNode('NumberOfAssetTransactions', '0');
                        SafTXmlHelper.FinalizeXMLNode;
                    end;
                    SafTXmlHelper.FinalizeXMLNode;
                end;
        end;
    end;


    procedure GetCustomerRegistrationNumber(_Variant: Variant): Text
    var
        Customer: Record Customer;
        CountryRegion: Record "Country/Region";
        GLSetup: Record "General Ledger Setup";
        RecRef: RecordRef;
        VATRegNo: Text;
    begin
        GLSetup.Get;

        RecRef.GetTable(_Variant);
        case RecRef.Number of
            DATABASE::Customer:
                begin
                    RecRef.SetTable(Customer);
                    VATRegNo := DelChr(Customer."VAT Registration No.", '=', Customer."Country/Region Code" + LowerCase(Customer."Country/Region Code") + ' ');
                    if Customer."Partner Type" = Customer."Partner Type"::Company then begin
                        if (Customer."SSA Tip Partener" in
                           [Customer."SSA Tip Partener"::"1-CUI Valid din RO si din afara inreg. in scopuri de TVA in RO",
                           Customer."SSA Tip Partener"::"2-CNP PFA din RO sau CUI neinregistrat in scopuri de TVA"])
                        then
                            exit('00' + VATRegNo);

                        if CountryRegion.Get(Customer."Country/Region Code") then begin
                            if (CountryRegion."EU Country/Region Code" <> '') and (CountryRegion."EU Country/Region Code" <> 'RO') then
                                if GLSetup."SSAFTGrupa cu TVA UE Client" = Customer."VAT Bus. Posting Group" then
                                    exit('01' + Customer."Country/Region Code" + VATRegNo);

                            if (CountryRegion."EU Country/Region Code" = '') then
                                if GLSetup."SSAFTGrupa cu TVA NONUE Client" = Customer."VAT Bus. Posting Group" then
                                    exit('02' + Customer."Country/Region Code" + VATRegNo);
                        end;

                        if Customer."SSA Tip Partener" = Customer."SSA Tip Partener"::"3-Fara CUI valid din UE fara RO" then
                            if CountryRegion.Get(Customer."Country/Region Code") then
                                if (CountryRegion."EU Country/Region Code" <> '') and (CountryRegion."EU Country/Region Code" <> 'RO') then
                                    if GLSetup."SSAFTGrupa cu TVA UE Client" <> Customer."VAT Bus. Posting Group" then
                                        exit('05' + Customer."Country/Region Code" + Customer."No.");

                        if Customer."SSA Tip Partener" = Customer."SSA Tip Partener"::"4-Fara CUI valid din afara UE fara RO" then
                            if CountryRegion.Get(Customer."Country/Region Code") then
                                //SSM2020>>
                                //OC IF (CountryRegion."EU Country/Region Code" <> '') AND (CountryRegion."EU Country/Region Code" <> 'RO') THEN
                                if (CountryRegion."EU Country/Region Code" = '') then
                                    //SSM2020<<
                                    if GLSetup."SSAFTGrupa cu TVA NONUE Client" <> Customer."VAT Bus. Posting Group" then
                                        //SSM2020>>
                                        //OC EXIT('06' + Customer."Country/Region Code" + VATRegNo);
                                        exit('06' + Customer."Country/Region Code" + Customer."No.");
                        //SSM2020<<
                    end;

                    if Customer."Partner Type" = Customer."Partner Type"::Person then
                        if Customer."SSA Tip Partener" = Customer."SSA Tip Partener"::"2-CNP PFA din RO sau CUI neinregistrat in scopuri de TVA" then
                            if STRLEN(VATRegNo) = 13 then
                                exit('03' + VATRegNo)
                            else
                                exit('04' + Customer."No.");
                end;
        end;

    end;


    procedure GetVendorRegistrationNumber(_Variant: Variant): Text
    var
        Vendor: Record Vendor;
        CountryRegion: Record "Country/Region";
        GLSetup: Record "General Ledger Setup";
        RecRef: RecordRef;
        VATRegNo: Text;
    begin
        GLSetup.Get;

        RecRef.GetTable(_Variant);
        case RecRef.Number of
            DATABASE::Vendor:
                begin
                    RecRef.SetTable(Vendor);
                    VATRegNo := DelChr(Vendor."VAT Registration No.", '=', Vendor."Country/Region Code" + LowerCase(Vendor."Country/Region Code") + ' ');
                    if Vendor."Partner Type" = Vendor."Partner Type"::Company then begin
                        if (Vendor."SSA Tip Partener" in
                           [Vendor."SSA Tip Partener"::"1-CUI Valid din RO si din afara inreg. in scopuri de TVA in RO",
                           Vendor."SSA Tip Partener"::"2-CNP PFA din RO sau CUI neinregistrat in scopuri de TVA"])
                        then
                            exit('00' + VATRegNo);

                        if CountryRegion.Get(Vendor."Country/Region Code") then begin
                            if (CountryRegion."EU Country/Region Code" <> '') and (CountryRegion."EU Country/Region Code" <> 'RO') then
                                if GLSetup."SSAFTGrupa cu TVA UE Furnizor" = Vendor."VAT Bus. Posting Group" then
                                    exit('01' + Vendor."Country/Region Code" + VATRegNo);

                            if (CountryRegion."EU Country/Region Code" = '') then
                                if GLSetup."SSAFTGrupa cu TVA NONUE Fz" = Vendor."VAT Bus. Posting Group" then
                                    exit('02' + Vendor."Country/Region Code" + VATRegNo);
                        end;

                        if Vendor."SSA Tip Partener" = Vendor."SSA Tip Partener"::"3-Fara CUI valid din UE fara RO" then
                            if CountryRegion.Get(Vendor."Country/Region Code") then
                                if (CountryRegion."EU Country/Region Code" <> '') and (CountryRegion."EU Country/Region Code" <> 'RO') then
                                    if GLSetup."SSAFTGrupa cu TVA UE Furnizor" <> Vendor."VAT Bus. Posting Group" then
                                        exit('05' + Vendor."Country/Region Code" + Vendor."No.");

                        if Vendor."SSA Tip Partener" = Vendor."SSA Tip Partener"::"4-Fara CUI valid din afara UE fara RO" then
                            if CountryRegion.Get(Vendor."Country/Region Code") then
                                //SSM2020>>
                                //OC IF (CountryRegion."EU Country/Region Code" <> '') AND (CountryRegion."EU Country/Region Code" <> 'RO') THEN
                                if (CountryRegion."EU Country/Region Code" = '') then
                                    //SSM2020<<
                                    if GLSetup."SSAFTGrupa cu TVA NONUE Fz" <> Vendor."VAT Bus. Posting Group" then
                                        //SSM2020>>
                                        //OC EXIT('06' + Vendor."Country/Region Code" + VATRegNo);
                                        exit('06' + Vendor."Country/Region Code" + Vendor."No.");
                        //SSM2020<<
                    end;

                    if Vendor."Partner Type" = Vendor."Partner Type"::Person then
                        if Vendor."SSA Tip Partener" = Vendor."SSA Tip Partener"::"2-CNP PFA din RO sau CUI neinregistrat in scopuri de TVA" then
                            if StrLen(VATRegNo) = 13 then
                                exit('03' + VATRegNo)
                            else
                                exit('04' + Vendor."No.");
                end;
        end;
    end;

    procedure ExistsItemLedgerEntryPeriod(_ItemNo: Code[20]; _LocationCode: Code[10]; _SAFTExportHeader: Record "SSAFT Export Header"): Boolean
    var
        ItemLedgEntry: Record "Item Ledger Entry";
    begin
        ItemLedgEntry.Reset;
        ItemLedgEntry.SetCurrentKey("Item No.", "Posting Date");
        ItemLedgEntry.SetRange("Item No.", _ItemNo);
        ItemLedgEntry.SetRange("Posting Date", _SAFTExportHeader."Starting Date", ClosingDate(_SAFTExportHeader."Ending Date"));
        if _LocationCode <> '' then
            ItemLedgEntry.SetRange("Location Code", _LocationCode);
        exit(not ItemLedgEntry.IsEmpty);
    end;

    local procedure GetTax(_MappingRangeCode: Code[20]; _NavCode: Code[20]; _NFTType: Integer): Code[10]
    var
        SAFTNAVMapping: Record "SSAFT-NAV Mapping";
    begin
        SAFTNAVMapping.Reset;
        SAFTNAVMapping.SetRange("NFT Type", _NFTType);
        SAFTNAVMapping.SetRange("Mapping Range Code", _MappingRangeCode);
        SAFTNAVMapping.SetRange("Table ID", DATABASE::"G/L Account");
        SAFTNAVMapping.SetRange("NAV Code", _NavCode);

        if SAFTNAVMapping.FindFirst then
            exit(SAFTNAVMapping."SAFT Code")
        else
            exit('');
    end;

    local procedure GetVATTaxType(SAFTExportHeader: Record "SSAFT Export Header"): Code[10]
    begin
        //Tax TVA
        /*
        CASE SAFTExportHeader."Header Comment SAFT Type" OF
          SAFTExportHeader."Header Comment SAFT Type"::"L - pentru declaratii lunare",
          SAFTExportHeader."Header Comment SAFT Type"::"NL - nerezidenti lunar":
            BEGIN
              EXIT('301');
            END;
          SAFTExportHeader."Header Comment SAFT Type"::"T - pentru declaratii trimestriale",
          SAFTExportHeader."Header Comment SAFT Type"::"NT - nerezidenti trimestrial":
            BEGIN
              EXIT('302');
            END;
          SAFTExportHeader."Header Comment SAFT Type"::"A - pentru declaratii anuale":
            BEGIN
              EXIT('304');
            END;
        END;
        */
        exit('300');

    end;
}



