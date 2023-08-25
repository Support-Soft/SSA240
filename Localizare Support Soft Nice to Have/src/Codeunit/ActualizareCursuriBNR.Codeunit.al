codeunit 71100 "SSA Actualizare Cursuri BNR"
{
    // SSA949 SSCAT 23.10.2019 15.Funct. import curs BNR si avertizare lipsa valuta

    Permissions = TableData "Currency Exchange Rate" = ri;

    trigger OnRun()
    begin
        New_ImportCurrencyExchangeRates;
    end;

    var
        Text50000: Label 'Currency Exchange Rate is missing for: %1';
        Text50001: Label 'BNR Exchange Rates not imported.';

    [EventSubscriber(ObjectType::Codeunit, codeunit::"System Initialization", OnAfterLogin, '', false, false)]
    local procedure OnAfterLogin()
    var
        Currency: Record Currency;
        CurrencyExchangeRate: Record "Currency Exchange Rate";
        ActualizareCursuriBNR: Codeunit "SSA Actualizare Cursuri BNR";
        CurrenciesString: Text;
    begin
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
        TempBlob: Codeunit "Temp Blob";
        ImportRatesLbl: Label 'BNR Rates could not be imported.';
        TestBNRLabel: Label '<?xml version="1.0" encoding="utf-8"?><DataSet xmlns="http://www.bnr.ro/xsd" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.bnr.ro/xsd nbrfxrates.xsd"><Header><Publisher>National Bank of Romania</Publisher><PublishingDate>2023-05-18</PublishingDate><MessageType>DR</MessageType></Header><Body><Subject>Reference rates</Subject><OrigCurrency>RON</OrigCurrency><Cube date="2023-05-18"><Rate currency="AED">1.2521</Rate><Rate currency="AUD">3.0515</Rate><Rate currency="BGN">2.5427</Rate><Rate currency="BRL">0.9308</Rate><Rate currency="CAD">3.4124</Rate><Rate currency="CHF">5.1061</Rate><Rate currency="CNY">0.6539</Rate><Rate currency="CZK">0.2098</Rate><Rate currency="DKK">0.6677</Rate><Rate currency="EGP">0.1488</Rate><Rate currency="EUR">4.9731</Rate><Rate currency="GBP">5.7169</Rate><Rate currency="HUF" multiplier="100">1.3335</Rate><Rate currency="INR">0.0557</Rate><Rate currency="JPY" multiplier="100">3.3370</Rate><Rate currency="KRW" multiplier="100">0.3442</Rate><Rate currency="MDL">0.2589</Rate><Rate currency="MXN">0.2598</Rate><Rate currency="NOK">0.4238</Rate><Rate currency="NZD">2.8697</Rate><Rate currency="PLN">1.0958</Rate><Rate currency="RSD">0.0424</Rate><Rate currency="RUB">0.0575</Rate><Rate currency="SEK">0.4382</Rate><Rate currency="THB">0.1338</Rate><Rate currency="TRY">0.2326</Rate><Rate currency="UAH">0.1245</Rate><Rate currency="USD">4.5975</Rate><Rate currency="XAU">292.2952</Rate><Rate currency="XDR">6.1469</Rate><Rate currency="ZAR">0.2371</Rate></Cube></Body></DataSet>';
        HTTPReq: HttpClient;
        HTTPResponse: HttpResponseMessage;
        InStr: InStream;
        CurrencyCode: Code[10];
        CurrencyMultiplier: Decimal;
        CurrencyExchRateAmount: Decimal;
        TestOutStream: OutStream;
    begin
        if ExchangeRateIsImported then
            exit;

        HTTPReq.Get('http://www.bnr.ro/nbrfxrates.xml', HTTPResponse);
        if not HTTPResponse.IsSuccessStatusCode then begin
            Message(ImportRatesLbl);
            exit;
        end;


        //TempBlob.CreateInStream(InStr);
        //HTTPResponse.Content.ReadAs(InStr);

        //test
        TempBlob.CreateOutStream(TestOutStream);
        TestOutStream.WriteText(TestBNRLabel);
        TempBlob.CreateInStream(InStr);
        //End test
        XMLBuffer.LoadFromStream(InStr);
        XMLBuffer2.CopyImportFrom(XMLBuffer);

        XMLBuffer.reset;
        if XMLBuffer.FindSet() then
            repeat
                if UpperCase(XMLBuffer.Name) = UpperCase('currency') then begin

                    CurrencyCode := XMLBuffer.Value;
                    if (XMLBuffer2.get(XMLBuffer."Entry No." - 1)) and (UpperCase(XMLBuffer2.Name) = UpperCase('Rate')) then
                        evaluate(CurrencyExchRateAmount, XMLBuffer2.Value);
                    if (XMLBuffer2.get(XMLBuffer."Entry No." + 1)) and (UpperCase(XMLBuffer2.Name) = UpperCase('multiplier')) then
                        evaluate(CurrencyMultiplier, XMLBuffer2.Value);

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

