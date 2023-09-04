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
        TempBlobResponse: Codeunit "Temp Blob";
        Client: HttpClient;
        RequestContent: HttpContent;
        Headers: HttpHeaders;
        ContentHeaders: HttpHeaders;
        Response: HttpResponseMessage;
        BodyInstr: InStream;
        ResponseInStream: InStream;
    begin

        Headers := Client.DefaultRequestHeaders;
        Headers.Add('Accept', 'application/xml');
        Headers.Add('Connection', 'Keep-alive');
        Headers.Add('Authorization', StrSubstNo('Bearer %1', _Token));
        Headers.Add('Accept-Encoding', 'gzip, deflate, br');

        _TempBlobRequest.CreateInStream(BodyInstr);
        RequestContent.WriteFrom(BodyInstr);
        RequestContent.GetHeaders(ContentHeaders);
        if ContentHeaders.Contains('Content-Type') then
            ContentHeaders.Remove('Content-Type');
        ContentHeaders.Add('Content-Type', 'application/xml');
        if not Client.Post(_URL + _Param, RequestContent, Response) or (not Response.IsSuccessStatusCode()) then
            Error(Response.ReasonPhrase);

        TempBlobResponse.CreateInStream(ResponseInStream, TEXTENCODING::UTF8);
        Response.Content.ReadAs(ResponseInStream);

        ParseXMLResponse_PostEFactura(TempBlobResponse, _DateResponse, _ExecutionStatus, _index_incarcare);

    end;

    local procedure ParseXMLResponse_PostEFactura(var _TempBlob: Codeunit "Temp Blob"; var _DateResponse: Text; var _ExecutionStatus: Text; var _index_incarcare: Text)
    var
        TempXML: Record "XML Buffer" temporary;
        InStr: InStream;
    begin
        _TempBlob.CreateInStream(InStr);
        TempXML.LoadFromStream(InStr);

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
        TempBlobResponse: Codeunit "Temp Blob";
        Client: HttpClient;
        Headers: HttpHeaders;
        Response: HttpResponseMessage;
        ResponseInStream: InStream;
    begin

        Headers := Client.DefaultRequestHeaders;
        Headers.Add('Accept', 'application/xml');
        Headers.Add('Connection', 'Keep-alive');
        Headers.Add('Authorization', StrSubstNo('Bearer %1', _Token));
        Headers.Add('Accept-Encoding', 'gzip, deflate, br');

        if not Client.Get(_URL + _Param, Response) or (not Response.IsSuccessStatusCode()) then
            Error(Response.ReasonPhrase);

        TempBlobResponse.CreateInStream(ResponseInStream, TEXTENCODING::UTF8);
        Response.Content.ReadAs(ResponseInStream);

        ParseXMLResponse_GetStareMesaj(TempBlobResponse, _StareMesaj, _IDDescarcare);

    end;

    local procedure ParseXMLResponse_GetStareMesaj(var _TempBlob: Codeunit "Temp Blob"; var _StareMesaj: Text; var _IDDescarcare: Text)
    var
        TempXML: Record "XML Buffer" temporary;
        InStr: InStream;
    begin
        _TempBlob.CreateInStream(InStr);
        TempXML.LoadFromStream(InStr);

        TempXML.FindNodesByXPath(TempXML, 'stare');
        _StareMesaj := TempXML.GetValue();

        TempXML.FindNodesByXPath(TempXML, 'id_descarcare');
        _IDDescarcare := TempXML.GetValue();

    end;


    procedure DescarcareMesaj(_IDDescarcare: Text; var _TempBlob: codeunit "Temp Blob")
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

    local procedure SendRequest_DescarcareMesaj(_URL: Text; _Param: Text; _Token: Text; var _TempBlob: codeunit "Temp Blob")
    var
        Client: HttpClient;
        Headers: HttpHeaders;
        Response: HttpResponseMessage;
        ResponseInStream: InStream;
        FileName: Text;
    begin

        Headers := Client.DefaultRequestHeaders;
        Headers.Add('Accept', 'application/xml');
        Headers.Add('Connection', 'Keep-alive');
        Headers.Add('Authorization', StrSubstNo('Bearer %1', _Token));
        Headers.Add('Accept-Encoding', 'gzip, deflate, br');

        if not Client.Get(_URL + _Param, Response) or (not Response.IsSuccessStatusCode()) then
            Error(Response.ReasonPhrase);

        _TempBlob.CreateInStream(ResponseInStream, TEXTENCODING::UTF8);
        Response.Content.ReadAs(ResponseInStream);

    end;

    procedure GetListaMesaje
    begin

        //SSM2210>>
        EFSetup.GET;
        IF EFSetup."EFactura Mod Test" THEN BEGIN
            EFSetup.TESTFIELD(EFSetup."EFactura Test ListaMesaje URL");
            URL := EFSetup."EFactura Test ListaMesaje URL";
        END ELSE BEGIN
            EFSetup.TESTFIELD(EFSetup."EFactura Test ListaMesaje URL");
            URL := EFSetup."EFactura ListaMesaje URL";
        END;

        CompanyInfo.GET;
        CountryRegion.GET(CompanyInfo."Country/Region Code");

        Parameters := STRSUBSTNO('?zile=%1&cif=%2', EFSetup."Nr. Zile Preluare ListaMesaje", DELCHR(UPPERCASE(CompanyInfo."VAT Registration No."), '=', CountryRegion."ISO Code"));
        SendRequest_GetListaMesaje(URL, Parameters, EFSetup."Access Token");
    end;
}

