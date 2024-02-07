codeunit 71100 "SSA Actualizare Cursuri BNR"
{
    // SSA949 SSCAT 23.10.2019 15.Funct. import curs BNR si avertizare lipsa valuta

    Permissions = tabledata "Currency Exchange Rate" = ri;

    trigger OnRun()
    begin
        New_ImportCurrencyExchangeRates;
    end;

    var
        Text50000: Label 'Currency Exchange Rate is missing for: %1';

    [EventSubscriber(ObjectType::Codeunit, codeunit::"System Initialization", OnAfterLogin, '', false, false)]
    local procedure OnAfterLogin()
    var
        Currency: Record Currency;
        CurrencyExchangeRate: Record "Currency Exchange Rate";
        SSASetup: Record "SSA Localization Setup";
        ActualizareCursuriBNR: Codeunit "SSA Actualizare Cursuri BNR";
        CurrenciesString: Text;
    begin
        if SSASetup.Get() then begin
            if not SSASetup."SSA Import BNR at LogIn" then
                exit;
        end else
            exit;

        Clear(CurrenciesString);
        commit;
        ActualizareCursuriBNR.Run;

        Currency.Reset;
        if Currency.FindSet then begin
            CurrencyExchangeRate.SetRange("Starting Date", Today);
            repeat
                CurrencyExchangeRate.SetRange("Currency Code", Currency.Code);
                if CurrencyExchangeRate.IsEmpty then
                    CurrenciesString := CurrenciesString + Format(Currency.Code) + ',';
            until Currency.Next = 0;
        end;
        if (CurrenciesString <> '') and GuiAllowed then
            Message(Text50000, CurrenciesString);
    end;

    /*
    local procedure ImportCurrencyExchangeRates()
    var
        Currencies: Record Currency;
        Company: Record Company;
        CompanyInfo: Record "Company Information";
        XmlDocument: DotNet SSAXmlDocument;
        NameTable: DotNet SSANameTable;
        XmlNameSpaceManager: DotNet SSAXmlNamespaceManager;
        XmlNode: DotNet SSAXmlNode;
        XmlNodes: DotNet SSAXmlNodeList;
        XmlNodeAttribute: DotNet SSAXmlNode;
        NodeCounter: Integer;
        CurrencyName: Code[20];
        CurrencyRate: Text;
        Output: Text;
        XmlNodes1: DotNet SSAXmlNodeList;
        xml: DotNet SSAXmlNode;
        CurrRate: Decimal;
        multiplier: Decimal;
        multi: Text;
        intreg: Integer;
        zecimal: Integer;
        CurrencyDecimal: Decimal;
    begin
        if ExchangeRateIsImported then
            exit;

        XmlDocument := XmlDocument.XmlDocument;
        XmlDocument.Load('http://www.bnr.ro/nbrfxrates.xml');

        NameTable := NameTable.NameTable;
        XmlNameSpaceManager := XmlNameSpaceManager.XmlNamespaceManager(NameTable);

        XmlNameSpaceManager.AddNamespace('ns1', 'http://www.bnr.ro/xsd');

        XmlNodes := XmlDocument.SelectNodes('/ns1:DataSet/ns1:Body/ns1:Cube/ns1:Rate', XmlNameSpaceManager);
        for NodeCounter := 0 to XmlNodes.Count - 1 do begin
            CurrencyName := XmlNodes.Item(NodeCounter).Attributes.GetNamedItem('currency').InnerXml;
            Evaluate(CurrencyRate, ConvertStr(Format(XmlNodes.Item(NodeCounter).InnerText), '.', ','));
            if not IsNull(XmlNodes.Item(NodeCounter).Attributes.GetNamedItem('multiplier')) then
                Evaluate(multiplier, XmlNodes.Item(NodeCounter).Attributes.GetNamedItem('multiplier').InnerXml)
            else
                multiplier := 0;

            Evaluate(intreg, CopyStr(CurrencyRate, 1, StrPos(CurrencyRate, ',')));
            Evaluate(zecimal, (CopyStr(CurrencyRate, StrPos(CurrencyRate, ',') + 1, 4)));
            CurrencyDecimal := intreg + zecimal / 10000;

            Company.SetRange(Name, CompanyName);
            if Company.FindSet then
                repeat
                    CompanyInfo.ChangeCompany(Company.Name);
                    CompanyInfo.Get;
                    if CompanyInfo."Country/Region Code" = 'RO' then begin
                        Currencies.ChangeCompany(Company.Name);
                        if Currencies.Get(CurrencyName) then
                            WriteExchangeRate(Company.Name, CurrencyName, multiplier, CurrencyDecimal);
                    end;
                until Company.Next = 0;
        end;
    end;
    end;
    */
    local procedure New_ImportCurrencyExchangeRates()
    var

        XMLBuffer: Record "XML Buffer" temporary;
        XMLBuffer2: Record "XML Buffer" temporary;
        GeneralFunctions: Codeunit "SSA General Functions";
        ImportRatesLbl: Label 'BNR Rates could not be imported.';
        HTTPReq: HttpClient;
        HTTPResponse: HttpResponseMessage;
        CurrencyCode: Code[10];
        CurrencyMultiplier: Decimal;
        CurrencyExchRateAmount: Decimal;
        ResponseText: Text;
    begin
        if not (CurrentClientType in [ClientType::Web, ClientType::Desktop]) then
            exit;

        if ExchangeRateIsImported then
            exit;

        HTTPReq.Get('https://www.bnr.ro/nbrfxrates.xml', HTTPResponse);
        if not HTTPResponse.IsSuccessStatusCode then begin
            Message(ImportRatesLbl);
            exit;
        end;

        //TempBlob.CreateInStream(InStr);
        //HTTPResponse.Content.ReadAs(InStr);

        //test
        /*
        TempBlob.CreateOutStream(TestOutStream);
        TestOutStream.WriteText(TestBNRLabel);
        TempBlob.CreateInStream(InStr);
        */
        //End test

        HTTPResponse.Content.ReadAs(ResponseText);
        XMLBuffer.LoadFromText(ResponseText);
        XMLBuffer2.CopyImportFrom(XMLBuffer);

        XMLBuffer.reset;
        if XMLBuffer.FindSet() then
            repeat
                if UpperCase(XMLBuffer.Name) = UpperCase('currency') then begin

                    CurrencyCode := XMLBuffer.Value;
                    if (XMLBuffer2.get(XMLBuffer."Entry No." - 1)) and (UpperCase(XMLBuffer2.Name) = UpperCase('Rate')) then
                        CurrencyExchRateAmount := GeneralFunctions.ConvertTextToDecimal(XMLBuffer2.Value);
                    if (XMLBuffer2.get(XMLBuffer."Entry No." + 1)) and (UpperCase(XMLBuffer2.Name) = UpperCase('multiplier')) then
                        CurrencyMultiplier := GeneralFunctions.ConvertTextToDecimal(XMLBuffer2.Value);

                    WriteExchangeRateAllCompanies(CurrencyCode, CurrencyMultiplier, CurrencyExchRateAmount);
                end
            until XMLBuffer.Next() = 0;
    end;

    local procedure WriteExchangeRateAllCompanies(_CurrencyCode: Code[10]; _Multiplier: Decimal; _CurrencyDecimal: Decimal)
    var
        Currencies: Record Currency;
        Company: Record Company;
        CompanyInfo: Record "Company Information";
    begin
        Company.SetRange(Name, CompanyName);
        if Company.FindSet then
            repeat
                CompanyInfo.ChangeCompany(Company.Name);
                CompanyInfo.Get;
                if CompanyInfo."Country/Region Code" = 'RO' then begin
                    Currencies.ChangeCompany(Company.Name);
                    if Currencies.Get(_CurrencyCode) then
                        WriteExchangeRate(Company.Name, _CurrencyCode, _Multiplier, _CurrencyDecimal);
                end;
            until Company.Next = 0;
    end;

    local procedure WriteExchangeRate(_CompanyName: Text; _CurrencyName: Code[10]; _Multiplier: Decimal; _CurrencyDecimal: Decimal)
    var
        CurrencyExchangeRate: Record "Currency Exchange Rate";
    begin
        CurrencyExchangeRate.ChangeCompany(_CompanyName);
        CurrencyExchangeRate.SetRange("Currency Code", _CurrencyName);

        if Time > 140000T then
            CurrencyExchangeRate.SetRange("Starting Date", Today + 1)
        else
            CurrencyExchangeRate.SetRange("Starting Date", Today);

        if not CurrencyExchangeRate.FindSet then begin
            CurrencyExchangeRate.Init;
            CurrencyExchangeRate."Currency Code" := _CurrencyName;
            if Time > 140000T then
                CurrencyExchangeRate."Starting Date" := Today + 1
            else
                CurrencyExchangeRate."Starting Date" := Today;
            if _Multiplier = 0 then
                CurrencyExchangeRate."Exchange Rate Amount" := 1
            else
                CurrencyExchangeRate."Exchange Rate Amount" := _Multiplier;
            CurrencyExchangeRate."Relational Exch. Rate Amount" := _CurrencyDecimal;
            CurrencyExchangeRate."Adjustment Exch. Rate Amount" := 1;
            if CurrencyExchangeRate."Starting Date" <> CalcDate('<CM>', CurrencyExchangeRate."Starting Date") then
                CurrencyExchangeRate."Relational Adjmt Exch Rate Amt" := _CurrencyDecimal;
            CurrencyExchangeRate.Insert;
        end;
    end;

    local procedure ExchangeRateIsImported(): Boolean
    var
        Currency: Record Currency;
        CurrencyExchangeRate: Record "Currency Exchange Rate";
    begin
        Currency.Reset;
        if Currency.FindSet then begin
            if Time > 140000T then
                CurrencyExchangeRate.SetRange("Starting Date", Today + 1)
            else
                CurrencyExchangeRate.SetRange("Starting Date", Today);
            repeat
                CurrencyExchangeRate.SetRange("Currency Code", Currency.Code);
                if CurrencyExchangeRate.IsEmpty then
                    exit(false);
            until Currency.Next = 0;
        end;
        exit(true);
    end;
}
