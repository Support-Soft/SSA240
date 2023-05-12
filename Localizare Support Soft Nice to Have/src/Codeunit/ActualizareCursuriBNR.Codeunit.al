codeunit 71100 "SSA Actualizare Cursuri BNR"
{
    // SSA949 SSCAT 23.10.2019 15.Funct. import curs BNR si avertizare lipsa valuta

    Permissions = TableData "Currency Exchange Rate" = ri;

    trigger OnRun()
    begin
        ImportCurrencyExchangeRates;
    end;

    var
        Text50000: Label 'Currency Exchange Rate is missing for: %1';
        Text50001: Label 'BNR Exchange Rates not imported.';

    [EventSubscriber(ObjectType::Codeunit, 40, 'OnAfterCompanyOpen', '', false, false)]
    local procedure OnAfterCompanyOpen()
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

