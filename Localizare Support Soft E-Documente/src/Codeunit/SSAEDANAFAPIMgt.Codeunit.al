codeunit 72007 "SSAEDANAF API Mgt"
{

    trigger OnRun()
    begin
    end;


    procedure PostEFactura(var _TempBlobRequest: Codeunit "Temp Blob"; var _DateResponse: Text; var _ExecutionStatus: Text; var _index_incarcare: Text)
    var
        EFSetup: Record "SSAEDEDocuments Setup";
        CompanyInfo: Record "Company Information";
        CountryRegion: Record "Country/Region";
        URL: Text;
        Parameters: Text;
    begin
        EFSetup.Get;
        //EFSetup.TESTFIELD("Access Token"
        if EFSetup."EFactura Mod Test" then begin
            EFSetup.TestField("EFactura Test Upload URL");
            URL := EFSetup."EFactura Test Upload URL";
        end else begin
            EFSetup.TestField("EFactura Upload URL");
            URL := EFSetup."EFactura Upload URL";
        end;

        CompanyInfo.Get;
        CountryRegion.Get(CompanyInfo."Country/Region Code");

        Parameters := StrSubstNo('?standard=UBL&cif=%1', DelChr(UpperCase(CompanyInfo."VAT Registration No."), '=', CountryRegion."ISO Code"));

        SendRequest_PostEFactura(URL, Parameters, EFSetup."Access Token", _TempBlobRequest, _DateResponse, _ExecutionStatus, _index_incarcare);
    end;

    local procedure SendRequest_PostEFactura(_URL: Text; _Param: Text; _Token: Text; var _TempBlobRequest: Codeunit "Temp Blob"; var _DateResponse: Text; var _ExecutionStatus: Text; var _index_incarcare: Text)
    var
        Client: HttpClient;
        RequestContent: HttpContent;
        Headers: HttpHeaders;
        ContentHeaders: HttpHeaders;
        Response: HttpResponseMessage;
        BodyInstr: InStream;
        ResponseText: Text;
        RequestText: Text;
    begin

        CheckTokenValidity();

        Headers := Client.DefaultRequestHeaders;
        Headers.Add('Accept', '*/*');
        Headers.Add('Connection', 'keep-alive');
        Headers.Add('Authorization', StrSubstNo('Bearer %1', _Token));
        Headers.Add('Accept-Encoding', 'gzip, deflate, br');

        _TempBlobRequest.CreateInStream(BodyInstr, TextEncoding::UTF8);
        BodyInstr.ReadText(RequestText);
        RequestContent.WriteFrom(RequestText);
        RequestContent.GetHeaders(ContentHeaders);

        if ContentHeaders.Contains('Content-Type') then
            ContentHeaders.Remove('Content-Type');
        ContentHeaders.Add('Content-Type', 'application/xml');
        if not Client.Post(_URL + _Param, RequestContent, Response) or (not Response.IsSuccessStatusCode()) then
            Error(Response.ReasonPhrase);

        Response.Content.ReadAs(ResponseText);

        ParseXMLResponse_PostEFactura(ResponseText, _DateResponse, _ExecutionStatus, _index_incarcare);

    end;

    local procedure ParseXMLResponse_PostEFactura(_ResponseText: Text; var _DateResponse: Text; var _ExecutionStatus: Text; var _index_incarcare: Text)
    var
        TempXML: Record "XML Buffer" temporary;
    begin
        TempXML.LoadFromText(_ResponseText);

        TempXML.FindNodesByXPath(TempXML, 'dateResponse');
        _DateResponse := TempXML.GetValue();

        TempXML.FindNodesByXPath(TempXML, 'ExecutionStatus');
        _ExecutionStatus := TempXML.GetValue();

        TempXML.FindNodesByXPath(TempXML, 'index_incarcare');
        _index_incarcare := TempXML.GetValue();

    end;


    procedure GetStareMesaj(_IDIncarcare: Text; var _StareMesaj: Text; var _IDDescarcare: Text)
    var
        EFSetup: Record "SSAEDEDocuments Setup";
        URL: Text;
        Parameters: Text;
    begin
        EFSetup.Get;
        if EFSetup."EFactura Mod Test" then begin
            EFSetup.TestField("EFactura Test Stare Mesaj URL");
            URL := EFSetup."EFactura Test Stare Mesaj URL";
        end else begin
            EFSetup.TestField("EFactura Stare Mesaj URL");
            URL := EFSetup."EFactura Stare Mesaj URL";
        end;

        Parameters := StrSubstNo('?id_incarcare=%1', _IDIncarcare);

        SendRequest_GetStareMesaj(URL, Parameters, EFSetup."Access Token", _StareMesaj, _IDDescarcare);
    end;

    local procedure SendRequest_GetStareMesaj(_URL: Text; _Param: Text; _Token: Text; var _StareMesaj: Text; var _IDDescarcare: Text)
    var
        Client: HttpClient;
        Headers: HttpHeaders;
        Response: HttpResponseMessage;
        ResponseText: Text;
    begin
        CheckTokenValidity();

        Headers := Client.DefaultRequestHeaders;
        Headers.Add('Accept', '*/*');
        Headers.Add('Connection', 'keep-alive');
        Headers.Add('Authorization', StrSubstNo('Bearer %1', _Token));
        Headers.Add('Accept-Encoding', 'gzip, deflate, br');

        if not Client.Get(_URL + _Param, Response) or (not Response.IsSuccessStatusCode()) then
            Error(Response.ReasonPhrase);

        Response.Content.ReadAs(ResponseText);

        ParseXMLResponse_GetStareMesaj(ResponseText, _StareMesaj, _IDDescarcare);

    end;

    local procedure ParseXMLResponse_GetStareMesaj(_ResponseText: Text; var _StareMesaj: Text; var _IDDescarcare: Text)
    var
        TempXML: Record "XML Buffer" temporary;
    begin
        TempXML.LoadFromText(_ResponseText);

        TempXML.FindNodesByXPath(TempXML, 'stare');
        _StareMesaj := TempXML.GetValue();

        TempXML.FindNodesByXPath(TempXML, 'id_descarcare');
        _IDDescarcare := TempXML.GetValue();

    end;


    procedure DescarcareMesaj(_IDDescarcare: Text; var _TempBlob: Codeunit "Temp Blob")
    var
        EFSetup: Record "SSAEDEDocuments Setup";
        URL: Text;
        Parameters: Text;
    begin
        EFSetup.Get;
        if EFSetup."EFactura Mod Test" then begin
            EFSetup.TestField("EFactura Test Descarcare URL");
            URL := EFSetup."EFactura Test Descarcare URL";
        end else begin
            EFSetup.TestField("EFactura Descarcare URL");
            URL := EFSetup."EFactura Descarcare URL";
        end;

        Parameters := StrSubstNo('?id=%1', _IDDescarcare);

        SendRequest_DescarcareMesaj(URL, Parameters, EFSetup."Access Token", _TempBlob);
    end;

    local procedure SendRequest_DescarcareMesaj(_URL: Text; _Param: Text; _Token: Text; var _TempBlob: Codeunit "Temp Blob")
    var
        Client: HttpClient;
        Headers: HttpHeaders;
        Response: HttpResponseMessage;
        ResponseInStream: InStream;
        ResponseOutStream: OutStream;
    begin

        CheckTokenValidity();

        Headers := Client.DefaultRequestHeaders;
        Headers.Add('Accept', '*/*');
        Headers.Add('Connection', 'keep-alive');
        Headers.Add('Authorization', StrSubstNo('Bearer %1', _Token));
        Headers.Add('Accept-Encoding', 'gzip, deflate, br');

        if not Client.Get(_URL + _Param, Response) or (not Response.IsSuccessStatusCode()) then
            Error(Response.ReasonPhrase);

        _TempBlob.CreateInStream(ResponseInStream, TEXTENCODING::UTF8);
        Response.Content.ReadAs(ResponseInStream);
        _TempBlob.CreateOutStream(ResponseOutStream, TextEncoding::UTF8);
        CopyStream(ResponseOutStream, ResponseInStream);
    end;

    procedure DescarcareMesajPDF(_IDDescarcare: Text; var _TempBlob: Codeunit "Temp Blob")
    var
        EFSetup: Record "SSAEDEDocuments Setup";
        TempBlobZIP: Codeunit "Temp Blob";
        TempBlobXML: Codeunit "Temp Blob";
        ProcessEFactura: Codeunit "SSAEDProcess Import E-Doc";
        URL: Text;
    begin
        DescarcareMesaj(_IDDescarcare, TempBlobZIP);
        ProcessEFactura.UnzippFiles(TempBlobZIP, TempBlobXML);
        EFSetup.Get;

        EFSetup.TestField("URL EFactura PDF");
        URL := EFSetup."URL EFactura PDF";

        SendRequest_DescarcareMesaj(URL, TempBlobXML, _TempBlob);
    end;

    local procedure SendRequest_DescarcareMesaj(_URL: Text; var _TempBlobRequest: Codeunit "Temp Blob"; var _TempBlobResponse: Codeunit "Temp Blob")
    var
        Client: HttpClient;
        Headers: HttpHeaders;
        ContentHeaders: HttpHeaders;
        Response: HttpResponseMessage;
        ResponseInStream: InStream;
        ResponseOutStream: OutStream;
        RequestContent: HttpContent;
        ContentText: Text;
        ReqInstream: InStream;
    begin
        Headers := Client.DefaultRequestHeaders;
        Headers.Add('Accept', '*/*');
        Headers.Add('Connection', 'keep-alive');
        Headers.Add('Accept-Encoding', 'gzip, deflate, br');

        _TempBlobRequest.CreateInStream(ReqInstream, TextEncoding::UTF8);
        ReqInstream.Read(ContentText);

        RequestContent.WriteFrom(ContentText);
        RequestContent.GetHeaders(ContentHeaders);
        if ContentHeaders.Contains('Content-Type') then
            ContentHeaders.Remove('Content-Type');
        ContentHeaders.Add('Content-Type', 'text/plain');
        if not Client.Post(_URL, RequestContent, Response) or (not Response.IsSuccessStatusCode()) then
            Error(Response.ReasonPhrase);

        _TempBlobResponse.CreateInStream(ResponseInStream, TEXTENCODING::UTF8);
        Response.Content.ReadAs(ResponseInStream);
        _TempBlobResponse.CreateOutStream(ResponseOutStream, TextEncoding::UTF8);
        CopyStream(ResponseOutStream, ResponseInStream);
    end;


    procedure GetListaMesaje()
    var
        EFSetup: Record "SSAEDEDocuments Setup";
        CompanyInfo: Record "Company Information";
        CountryRegion: Record "Country/Region";
        URL: Text;
        Parameters: Text;
    begin

        //SSM2210>>
        EFSetup.GET;
        if EFSetup."EFactura Mod Test" then begin
            EFSetup.TESTFIELD(EFSetup."EFactura Test ListaMesaje URL");
            URL := EFSetup."EFactura Test ListaMesaje URL";
        end else begin
            EFSetup.TESTFIELD(EFSetup."EFactura ListaMesaje URL");
            URL := EFSetup."EFactura ListaMesaje URL";
        end;

        CompanyInfo.GET;
        CountryRegion.GET(CompanyInfo."Country/Region Code");

        Parameters := STRSUBSTNO('?zile=%1&cif=%2', EFSetup."Nr. Zile Preluare ListaMesaje", DELCHR(UPPERCASE(CompanyInfo."VAT Registration No."), '=', CountryRegion."ISO Code"));
        SendRequest_GetListaMesaje(URL, Parameters, EFSetup."Access Token");
    end;

    local procedure SendRequest_GetListaMesaje(_URL: Text; _Param: Text; _Token: Text)
    var
        Client: HttpClient;
        Headers: HttpHeaders;
        Response: HttpResponseMessage;
        ResponseText: Text;
    begin

        CheckTokenValidity();

        Headers := Client.DefaultRequestHeaders;
        Headers.Add('Accept', '*/*');
        Headers.Add('Connection', 'keep-alive');
        Headers.Add('Authorization', StrSubstNo('Bearer %1', _Token));
        Headers.Add('Accept-Encoding', 'gzip, deflate, br');

        if not Client.Get(_URL + _Param, Response) or (not Response.IsSuccessStatusCode()) then
            Error(Response.ReasonPhrase);

        Response.Content.ReadAs(ResponseText);

        ParseXMLResponse_GetListaMesaje(ResponseText);

    end;

    local procedure ParseXMLResponse_GetListaMesaje(_JSonText: Text)
    var
        TempJSONBuffer: Record "JSON Buffer" temporary;
        CompanyInfo: Record "Company Information";
        CountryRegion: Record "Country/Region";
        MessagesCount: Integer;
        Done: Boolean;
        IndexIncarcare: Text;
        DescriptionText: Text;
        IDDescarcare: Text;
    begin
        CompanyInfo.GET;
        CountryRegion.GET(CompanyInfo."Country/Region Code");

        TempJSONBuffer.ReadFromText(_JSonText);
        CLEAR(MessagesCount);
        while (not Done) and (MessagesCount <= 500) do
            if TempJSONBuffer.GetPropertyValueAtPath(IndexIncarcare, 'id_solicitare', STRSUBSTNO('mesaje[%1]*', MessagesCount)) then begin
                CLEAR(DescriptionText);
                TempJSONBuffer.GetPropertyValueAtPath(DescriptionText, 'detalii', STRSUBSTNO('mesaje[%1]*', MessagesCount));
                CLEAR(IDDescarcare);
                TempJSONBuffer.GetPropertyValueAtPath(IDDescarcare, 'id', STRSUBSTNO('mesaje[%1]*', MessagesCount));
                if STRPOS(DescriptionText,
                    STRSUBSTNO('cif_emitent=%1',
                        DELCHR(CompanyInfo."VAT Registration No.", '=', CountryRegion."ISO Code"))) = 0
    then
                    CreateLogEntry(IndexIncarcare, DescriptionText, IDDescarcare);

                MessagesCount += 1;
            end else
                Done := true;

    end;

    local procedure CreateLogEntry(_IndexIncarcare: Text; _DescriptionText: Text; _IDDescarcare: Text)
    var
        LogEntry: Record "SSAEDE-Documents Log Entry";
        EntryNo: Integer;
    begin

        LogEntry.RESET;
        if LogEntry.FINDLAST then
            EntryNo := LogEntry."Entry No."
        else
            EntryNo := 0;


        LogEntry.SETCURRENTKEY("Entry Type", Status);
        LogEntry.SETRANGE("Entry Type", LogEntry."Entry Type"::"Import E-Factura");
        LogEntry.SETRANGE("Index Incarcare", _IndexIncarcare);
        if LogEntry.FINDFIRST then begin
            LogEntry."ID Descarcare" := _IDDescarcare;
            LogEntry.MODIFY;
            exit;
        end;

        CLEAR(LogEntry);
        EntryNo += 1;
        LogEntry.INIT;
        LogEntry."Entry No." := EntryNo;
        LogEntry.INSERT(true);
        LogEntry."Entry Type" := LogEntry."Entry Type"::"Import E-Factura";
        LogEntry."Creation Date" := TODAY;
        LogEntry."Creation Time" := TIME;
        LogEntry."Index Incarcare" := _IndexIncarcare;
        LogEntry.Description := _DescriptionText;
        LogEntry."ID Descarcare" := _IDDescarcare;
        LogEntry.MODIFY(true);
    end;

    procedure RefreshToken(var _Rec: Record "SSAEDEDocuments Setup")
    begin
        _Rec.TESTFIELD("Access Token URL");

        SendRequest_RefreshToken(_Rec);
    end;

    local procedure SendRequest_RefreshToken(var _Rec: Record "SSAEDEDocuments Setup")
    var
        BearerToken: Label 'Bearer %1', Locked = true;
        Client: HttpClient;
        Headers: HttpHeaders;
        Response: HttpResponseMessage;
        RequestContent: HttpContent;
        ContentHeaders: HttpHeaders;
        TypeHelper: Codeunit "Type Helper";
        ResponseText: Text;
        ContentText: Text;
    begin

        CheckTokenValidity();

        Headers := Client.DefaultRequestHeaders;
        Headers.Add('Accept', '*/*');
        Headers.Add('Connection', 'keep-alive');
        Headers.Add('Authorization', StrSubstNo(BearerToken, _Rec."Access Token"));
        Headers.Add('Accept-Encoding', 'gzip, deflate, br');

        ContentText := 'grant_type=refresh_token' +
            '&refresh_token=' + TypeHelper.UriEscapeDataString(_Rec."Refresh Token") +
            '&client_id=' + TypeHelper.UriEscapeDataString(_Rec."Client ID") +
            '&client_secret=' + TypeHelper.UriEscapeDataString(_Rec."Client Secret");

        RequestContent.WriteFrom(contentText);
        RequestContent.GetHeaders(ContentHeaders);
        if ContentHeaders.Contains('Content-Type') then
            ContentHeaders.Remove('Content-Type');
        ContentHeaders.Add('Content-Type', 'application/x-www-form-urlencoded');

        if not Client.Post(_Rec."Authorization URL", RequestContent, Response) or (not Response.IsSuccessStatusCode()) then
            Error(Response.ReasonPhrase);

        Response.Content.ReadAs(ResponseText);

        ParseXMLResponse_RefreshToken(ResponseText, _Rec);

    end;

    local procedure ParseXMLResponse_RefreshToken(_JSonText: Text; var _Rec: Record "SSAEDEDocuments Setup")
    var
        TempJSONBuffer: Record "JSON Buffer" temporary;
    begin

        TempJSONBuffer.ReadFromText(_JSonText);
        TempJSONBuffer.GetPropertyValue(_Rec."Access Token", 'access_token');
        TempJSONBuffer.GetPropertyValue(_Rec."Refresh Token", 'refresh_token');
        TempJSONBuffer.GetIntegerPropertyValue(_Rec."Expires In", 'expires_in');
        _Rec.VALIDATE("Access Token");
    end;

    local procedure CheckTokenValidity()
    var
        EFTSetup: Record "SSAEDEDocuments Setup";
        DecVar: Decimal;
        ExpirationDT: DateTime;
    begin
        EFTSetup.GET;

        if EFTSetup."Authorization Time" <> 0DT then begin
            DecVar := EFTSetup."Expires In";
            DecVar := DecVar * 1000;
            ExpirationDT := EFTSetup."Authorization Time" + DecVar;
            if CALCDATE('<1D>', TODAY) < DT2DATE(ExpirationDT) then
                exit;
        end;

        RefreshToken(EFTSetup);
        EFTSetup.Modify();
        Commit();
    end;
}

