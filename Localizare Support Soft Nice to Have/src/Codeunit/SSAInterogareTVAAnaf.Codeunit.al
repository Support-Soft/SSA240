codeunit 71102 "SSA Interogare TVA Anaf"
{
    var
        Text000: Label '[{"cui":%1,"data":"%2"}]';
        HideDialog: Boolean;
        Text002: Label '"cod":200,';
        Text003: Label '"message":"SUCCESS",';

    procedure ValidatePartner(_PartnerRef: Code[20]; _Cui: Text; _TableID: Integer)
    var
        Customer: Record Customer;
        Vendor: Record Vendor;
        JSONBuffer: Record "JSON Buffer" temporary;
        PName: Text;
        PAddress: Text;
        PscpTVA: Boolean;
        PnrRegCom: Text;
        PstatusTvaIncasare: Boolean;
        PCity: Text;
        PCounty: Text;
        PstatusSplitTVA: Boolean;
        PCuiText: Text;
        UpdateScpTVA: Boolean;
        UpdateStatusTVAIncasare: Boolean;
        UpdateStatusSplitTVA: Boolean;
    begin
        //SSM2160>>
        SendRequest(DelChr(_Cui, '=', 'RrOo '), JSONBuffer);
        GetResponseParams(JSONBuffer, PCuiText, PName, PAddress, PscpTVA, PnrRegCom, PstatusTvaIncasare, PCity, PCounty, PstatusSplitTVA, UpdateScpTVA, UpdateStatusTVAIncasare, UpdateStatusSplitTVA);
        ShowConfirmationMessage(PCuiText, PName, PAddress, PscpTVA, PnrRegCom, PstatusTvaIncasare, PCity, PCounty, PstatusSplitTVA);

        case _TableID of
            DATABASE::Customer:
                begin
                    Customer.Get(_PartnerRef);
                    ValidateCustomer(Customer, PCuiText, PName, PAddress, PscpTVA, PnrRegCom, PCity, PCounty, UpdateScpTVA, UpdateStatusTVAIncasare);
                    Customer.Modify(true);
                end;
            DATABASE::Vendor:
                begin
                    Vendor.Get(_PartnerRef);
                    ValidateVendor(Vendor, PCuiText, PName, PAddress, PscpTVA, PnrRegCom, PstatusTvaIncasare, PCity, PCounty, PstatusSplitTVA, UpdateScpTVA, UpdateStatusTVAIncasare, UpdateStatusSplitTVA);
                    Vendor.Modify(true);
                end;
        end;
        //SSM2160<<
    end;

    [TryFunction]
    local procedure ValidateCustomer(var _Customer: Record Customer; _PCuiText: Text; _PName: Text; _PAddress: Text; _PscpTVA: Boolean; _PnrRegCom: Text; _PCity: Text; _PCounty: Text; _UpdateScpTVA: Boolean; _UpdateStatusTVAIncasare: Boolean)
    var
        CountryRegion: Record "Country/Region";
        SSASetup: Record "SSA Localization Setup";
    begin
        //SSM2160>>
        SSASetup.Get;
        _Customer.Validate("Partner Type", _Customer."Partner Type"::Company);

        CountryRegion.Get(_Customer."Country/Region Code");
        if CountryRegion."EU Country/Region Code" <> '' then
            if CountryRegion."EU Country/Region Code" <> 'RO' then
                _Customer.Validate("SSA Tip Partener", _Customer."SSA Tip Partener"::"3-Fara CUI valid din UE fara RO")
            else
                _Customer.Validate("SSA Tip Partener", _Customer."SSA Tip Partener"::"2-CNP PFA din RO sau CUI neinregistrat in scopuri de TVA")
        else
            _Customer.Validate("SSA Tip Partener", _Customer."SSA Tip Partener"::"4-Fara CUI valid din afara UE fara RO");

        if _PName <> '' then begin
            _Customer.Validate(Name, CopyStr(_PName, 1, MaxStrLen(_Customer.Name)));
            _Customer.Validate("Name 2", CopyStr(_PName, MaxStrLen(_Customer.Name) + 1, MaxStrLen(_Customer."Name 2")));
        end;

        if _PAddress <> '' then begin
            _Customer.Validate(Address, CopyStr(_PAddress, 1, MaxStrLen(_Customer.Address)));
            _Customer.Validate("Address 2", CopyStr(_PAddress, MaxStrLen(_Customer.Address) + 1, MaxStrLen(_Customer."Address 2")));
        end;

        if _UpdateScpTVA then begin
            if _PscpTVA then begin
                _Customer.Validate("SSA Not VAT Registered", false);
                _Customer.Validate("SSA Tip Partener", _Customer."SSA Tip Partener"::"1-CUI Valid din RO si din afara inreg. in scopuri de TVA in RO");
                if ('RO' + _PCuiText) <> _Customer."VAT Registration No." then
                    _Customer.Validate("VAT Registration No.", 'RO' + _PCuiText);
            end else begin
                _Customer.Validate("SSA Not VAT Registered", true);
                _Customer.Validate("SSA Tip Partener", _Customer."SSA Tip Partener"::"2-CNP PFA din RO sau CUI neinregistrat in scopuri de TVA");
                if _PCuiText <> _Customer."VAT Registration No." then
                    _Customer.Validate("VAT Registration No.", _PCuiText);
            end;
        end;

        if _PnrRegCom <> '' then begin
            _Customer.Validate("SSA Commerce Trade No.", CopyStr(_PnrRegCom, 1, MaxStrLen(_Customer."SSA Commerce Trade No.")));
        end;

        if _PCity <> '' then begin
            if STRPOS(UPPERCASE(_PCity), 'MUN. BUCURESTI') <> 0 then
                _PCity := COPYSTR(_PCity, 1, STRPOS(UPPERCASE(_PCity), 'MUN. BUCURESTI') - 2);
            if STRLEN(_PCity) > MAXSTRLEN(_Customer.City) then
                MESSAGE('Localitatea a fost trunchiata. Va rog verificati.');
            _Customer.VALIDATE(City, COPYSTR(_PCity, 1, MAXSTRLEN(_Customer.City)));
        end;

        if _PCounty <> '' then begin
            if STRPOS(UPPERCASE(_PCounty), 'MUNICIPIUL') <> 0 then
                _PCounty := COPYSTR(_PCounty, STRPOS(UPPERCASE(_PCounty), 'MUNICIPIUL') + STRLEN('MUNICIPIUL') + 1);
            if STRLEN(_PCounty) > MAXSTRLEN(_Customer.County) then
                MESSAGE('Judetul a fost trunchiat. Va rog verificati.');
            _Customer.VALIDATE(County, COPYSTR(_PCounty, 1, MAXSTRLEN(_Customer.County)));
        end;

        SSASetup.TestField("Cust. Neex. VAT Posting Group");
        if SSASetup."Sistem TVA" = SSASetup."Sistem TVA"::"Sistem de TVA la Incasare" then
            if SSASetup."Cust. Neex. VAT Posting Group" <> _Customer."VAT Bus. Posting Group" then
                _Customer.Validate("VAT Bus. Posting Group", SSASetup."Cust. Neex. VAT Posting Group");
        if SSASetup."Sistem TVA" = SSASetup."Sistem TVA"::"Neplatitor de TVA" then
            if SSASetup."Cust. Nepl. VAT Posting Group" <> _Customer."VAT Bus. Posting Group" then
                _Customer.Validate("VAT Bus. Posting Group", SSASetup."Cust. Nepl. VAT Posting Group");

        //SSM2160<<
    end;

    [TryFunction]
    procedure ValidateVendor(var _Vendor: Record Vendor; _PCuiText: Text; _PName: Text; _PAddress: Text; _PscpTVA: Boolean; _PnrRegCom: Text; _PstatusTvaIncasare: Boolean; _PCity: Text; _PCounty: Text; _PstatusSplitTVA: Boolean; _UpdateScpTVA: Boolean; _UpdateStatusTVAIncasare: Boolean; _UpdateStatusSplitTVA: Boolean)
    var
        CountryRegion: Record "Country/Region";
        SSASetup: Record "SSA Localization Setup";
    begin
        //SSM2160>>
        SSASetup.Get;
        SSASetup.TestField("Vendor Neex. VAT Posting Group");

        CountryRegion.Get(_Vendor."Country/Region Code");
        if CountryRegion."EU Country/Region Code" <> '' then
            if CountryRegion."EU Country/Region Code" <> 'RO' then
                _Vendor.Validate("SSA Tip Partener", _Vendor."SSA Tip Partener"::"3-Fara CUI valid din UE fara RO")
            else
                _Vendor.Validate("SSA Tip Partener", _Vendor."SSA Tip Partener"::"2-CNP PFA din RO sau CUI neinregistrat in scopuri de TVA")
        else
            _Vendor.Validate("SSA Tip Partener", _Vendor."SSA Tip Partener"::"4-Fara CUI valid din afara UE fara RO");

        if _PName <> '' then begin
            _Vendor.Validate(Name, CopyStr(_PName, 1, MaxStrLen(_Vendor.Name)));
            _Vendor.Validate("Name 2", CopyStr(_PName, MaxStrLen(_Vendor.Name) + 1, MaxStrLen(_Vendor."Name 2")));
        end;

        if _PAddress <> '' then begin
            _Vendor.Validate(Address, CopyStr(_PAddress, 1, MaxStrLen(_Vendor.Address)));
            _Vendor.Validate("Address 2", CopyStr(_PAddress, MaxStrLen(_Vendor.Address) + 1, MaxStrLen(_Vendor."Address 2")));
        end;

        if _UpdateScpTVA then begin
            if _PscpTVA then begin
                _Vendor.Validate("SSA Not VAT Registered", false);
                _Vendor.Validate("SSA Tip Partener", _Vendor."SSA Tip Partener"::"1-CUI Valid din RO si din afara inreg. in scopuri de TVA in RO");
                if ('RO' + _PCuiText) <> _Vendor."VAT Registration No." then
                    _Vendor.Validate("VAT Registration No.", 'RO' + _PCuiText);
            end else begin
                _Vendor.Validate("SSA Not VAT Registered", true);
                _Vendor.Validate("SSA Tip Partener", _Vendor."SSA Tip Partener"::"2-CNP PFA din RO sau CUI neinregistrat in scopuri de TVA");
                if _PCuiText <> _Vendor."VAT Registration No." then
                    _Vendor.Validate("VAT Registration No.", _PCuiText);
            end;
        end;

        if _UpdateStatusTVAIncasare then begin
            if _PstatusTvaIncasare then
                _Vendor.Validate("SSA VAT to Pay", true)
            else
                _Vendor.Validate("SSA VAT to Pay", false);
        end;

        if _UpdateStatusSplitTVA then begin
            if _PstatusSplitTVA then
                _Vendor.Validate("SSA Split VAT", true)
            else
                _Vendor.Validate("SSA Split VAT", false);
        end;

        if _PnrRegCom <> '' then begin
            _Vendor.Validate("SSA Commerce Trade No.", CopyStr(_PnrRegCom, 1, MaxStrLen(_Vendor."SSA Commerce Trade No.")));
        end;

        if _PCity <> '' then begin
            if STRPOS(UPPERCASE(_PCity), 'MUN. BUCURESTI') <> 0 then
                _PCity := COPYSTR(_PCity, 1, STRPOS(UPPERCASE(_PCity), 'MUN. BUCURESTI') - 2);
            if STRLEN(_PCity) > MAXSTRLEN(_Vendor.City) then
                MESSAGE('Localitatea a fost trunchiata. Va rog verificati.');
            _Vendor.VALIDATE(City, COPYSTR(_PCity, 1, MAXSTRLEN(_Vendor.City)));
        end;

        if _PCounty <> '' then begin
            if STRPOS(UPPERCASE(_PCounty), 'MUNICIPIUL') <> 0 then
                _PCounty := COPYSTR(_PCounty, STRPOS(UPPERCASE(_PCounty), 'MUNICIPIUL') + STRLEN('MUNICIPIUL') + 1);
            if STRLEN(_PCounty) > MAXSTRLEN(_Vendor.County) then
                MESSAGE('Judetul a fost trunchiat. Va rog verificati.');
            _Vendor.VALIDATE(County, COPYSTR(_PCounty, 1, MAXSTRLEN(_Vendor.County)));
        end;

        if SSASetup."Sistem TVA" = SSASetup."Sistem TVA"::"Sistem de TVA la Incasare" then
            if SSASetup."Vendor Neex. VAT Posting Group" <> _Vendor."VAT Bus. Posting Group" then
                _Vendor.Validate("VAT Bus. Posting Group", SSASetup."Vendor Neex. VAT Posting Group");
        if SSASetup."Sistem TVA" = SSASetup."Sistem TVA"::"Neplatitor de TVA" then
            if SSASetup."Vendor Nepl. VAT Posting Group" <> _Vendor."VAT Bus. Posting Group" then
                _Vendor.Validate("VAT Bus. Posting Group", SSASetup."Vendor Nepl. VAT Posting Group");
        //SSM2160<<
    end;

    local procedure ParseResponseJSON(_ResponseText: Text; var _JSONBuffer: Record "JSON Buffer" temporary)
    var
        JsonTextReaderWriter: Codeunit "Json Text Reader/Writer";
    begin
        //SSM2160>>
        _JSONBuffer.Reset;
        _JSONBuffer.DeleteAll;
        if (StrPos(_ResponseText, Text002) = 0) or (StrPos(_ResponseText, Text003) = 0) then begin
            Error('Eroare:\\%1', _ResponseText);
        end;

        JsonTextReaderWriter.ReadJSonToJSonBuffer(_ResponseText, _JSONBuffer);
        //SSM2160<<
    end;

    procedure ShowConfirmationMessage(_PCuiText: Text; _PName: Text; _PAddress: Text; _PscpTVA: Boolean; _PnrRegCom: Text; _PstatusTvaIncasare: Boolean; _PCity: Text; _PCounty: Text; _PstatusSplitTVA: Boolean)
    var
        MessageText: Text;
    begin

        if HideDialog then
            exit;

        MessageText := 'Actualizati?\\';

        MessageText += '\' + StrSubstNo('%1:%2', 'Nume', _PName);
        MessageText += '\' + StrSubstNo('%1:%2', 'Adresa', _PAddress);
        MessageText += '\' + StrSubstNo('%1:%2', 'scpTVA', _PscpTVA);
        MessageText += '\' + StrSubstNo('%1:%2', 'Nr. Reg. Com', _PnrRegCom);
        MessageText += '\' + StrSubstNo('%1:%2', 'Localitate', _PCity);
        MessageText += '\' + StrSubstNo('%1:%2', 'Judet', _PCounty);
        MessageText += '\' + StrSubstNo('%1:%2', 'Status TVA Incasare', _PstatusTvaIncasare);
        MessageText += '\' + StrSubstNo('%1:%2', 'Split TVA ', _PstatusSplitTVA);

        if not Confirm(MessageText) then
            Error('Partenerul nu a fost actualizat!');

        //SSM2160<<
    end;

    procedure GetResponseParams(var _JSONBuffer: Record "JSON Buffer" temporary; var _CuiText: Text; var _PName: Text; var _PAddress: Text; var _PscpTVA: Boolean; var _PnrRegCom: Text; var _PstatusTvaIncasare: Boolean; var _PCity: Text; var _PCounty: Text; var _PstatusSplitTVA: Boolean; var _UpdateScpTVA: Boolean; var _UpdateStatusTVAIncasare: Boolean; var _UpdateStatusSplitTVA: Boolean)
    var
        IndexCui: Integer;
        BoolAsText: Text;
    begin
        //SSM2160>>
        Clear(_CuiText);
        Clear(_PName);
        Clear(_PAddress);
        Clear(_PscpTVA);
        Clear(_PnrRegCom);
        Clear(_PstatusTvaIncasare);
        Clear(_PCity);
        Clear(_PCounty);
        Clear(_PstatusSplitTVA);
        Clear(_UpdateScpTVA);
        Clear(_UpdateStatusSplitTVA);
        Clear(_UpdateStatusTVAIncasare);

        if not _JSONBuffer.GetPropertyValueAtPath(_CuiText, 'cui', StrSubstNo('found[%1]*', IndexCui)) then
            Error('CUI neidentificat.');

        if _JSONBuffer.GetPropertyValueAtPath(_PName, 'denumire', StrSubstNo('found[%1]*', IndexCui)) then;
        if _JSONBuffer.GetPropertyValueAtPath(_PAddress, 'adresa', StrSubstNo('found[%1]*', IndexCui)) then;

        Clear(BoolAsText);
        if _JSONBuffer.GetPropertyValueAtPath(BoolAsText, 'scpTVA', StrSubstNo('found[%1]*', IndexCui)) then begin
            _UpdateScpTVA := true;
            Evaluate(_PscpTVA, BoolAsText);
        end;

        if _JSONBuffer.GetPropertyValueAtPath(_PnrRegCom, 'nrRegCom', StrSubstNo('found[%1]*', IndexCui)) then;
        if _JSONBuffer.GetPropertyValueAtPath(_PCity, 'ddenumire_Localitate', StrSubstNo('found[%1]*', IndexCui)) then;
        if _JSONBuffer.GetPropertyValueAtPath(_PCounty, 'ddenumire_Judet', StrSubstNo('found[%1]*', IndexCui)) then;

        Clear(BoolAsText);
        if _JSONBuffer.GetPropertyValueAtPath(BoolAsText, 'statusTvaIncasare', StrSubstNo('found[%1]*', IndexCui)) then begin
            _UpdateStatusTVAIncasare := true;
            Evaluate(_PstatusTvaIncasare, BoolAsText);
        end;

        Clear(BoolAsText);
        if _JSONBuffer.GetPropertyValueAtPath(BoolAsText, 'statusSplitTVA', StrSubstNo('found[%1]*', IndexCui)) then begin
            _UpdateStatusSplitTVA := true;
            Evaluate(_PstatusSplitTVA, BoolAsText);
        end;
        //SSM2160<<
    end;

    [TryFunction]
    procedure SendRequest(_CUI: Text; var _JSONBuffer: Record "JSON Buffer" temporary)
    var
        Client: HttpClient;
        ResponseMessage: HttpResponseMessage;
        RequestHeaders: HttpHeaders;
        Content: HttpContent;
        ResponseText: Text;
        SSASetup: Record "SSA Localization Setup";
    begin

        SSASetup.Get;
        SSASetup.TestField("SSA VAT API URL ANAF");

        Content.Clear();
        Content.WriteFrom(StrSubstNo(Text000, _CUI, Format(Today, 0, '<Year4>-<Month,2>-<Day,2>')));
        Content.GetHeaders(RequestHeaders);
        RequestHeaders.Remove('Content-Type');
        RequestHeaders.Add('Content-Type', 'application/json');
        Client.Post(SSASetup."SSA VAT API URL ANAF", Content, ResponseMessage);

        ResponseMessage.Content.ReadAs(ResponseText);

        ParseResponseJSON(ResponseText, _JSONBuffer);

        /*

        SSAHttpWebRequest := SSAHttpWebRequest.Create(SSASetup."SSA VAT API URL ANAF");
        SSAHttpWebRequest.Method := 'POST';
        SSAHttpWebRequest.KeepAlive := true;
        SSAHttpWebRequest.AllowAutoRedirect := true;
        SSAHttpWebRequest.UseDefaultCredentials := true;
        SSAHttpWebRequest.Timeout := 60000;
        SSAHttpWebRequest.Accept('application/json');
        SSAHttpWebRequest.ContentType('application/json');

        OStream := SSAHttpWebRequest.GetRequestStream;
        OStream.WriteText(StrSubstNo(Text000, _CUI, Format(Today, 0, '<Year4>-<Month,2>-<Day,2>')));
        TempBlob.CreateInStream(ResponseInStream);

        if not WebRequestHelper.GetWebResponse(SSAHttpWebRequest, SSAHttpWebResponse, ResponseInStream, SSAHttpStatusCode,
            SSAResponseHeaders, (not HideDialog))
        then
            TryProcessFaultXMLResponse(SSASetup."SSA VAT API URL ANAF", '', '', '');

        if not HideDialog then
            if SSAHttpStatusCode.ToString <> SSAHttpStatusCode.OK.ToString then
                Error('Connection Failed Error\%1', ErrorText);

        ParseResponseJSON(TempBlob, _JSONBuffer);
        */
    end;

    /*
        local procedure TryProcessFaultXMLResponse(SupportInfo: Text; NodePath: Text; Prefix: Text; NameSpace: Text)
        var
            WebRequestHelper: Codeunit "Web Request Helper";
            XMLDOMMgt: Codeunit "XML DOM Management";
            WebException: DotNet SSAWebException;
            XmlDoc: DotNet SSAXmlDocument;
            ResponseInputStream: InStream;
            ErrorText: Text;
            ServiceURL: Text;
        begin
            ErrorText := WebRequestHelper.GetWebResponseError(WebException, ServiceURL);

            if ErrorText = '' then
                ErrorText := WebException.Message;

            if SupportInfo <> '' then
                ErrorText += '\\' + SupportInfo;
            if not HideDialog then
                Error(ErrorText);
        end;
    */
    procedure GetJudet(_Judet: Text): Integer
    begin
        case _Judet of
            'ALBA':
                exit(1);
            'ARAD':
                exit(2);
            'ARGES':
                exit(3);
            'BACAU':
                exit(4);
            'BIHOR':
                exit(5);
            'BISTRITA-NASAUD':
                exit(6);
            'BOTOSANI':
                exit(7);
            'BRASOV':
                exit(8);
            'BRAILA':
                exit(9);
            'BUZAU':
                exit(10);
            'CARAS-SEVERIN':
                exit(11);
            'CALARASI':
                exit(51);
            'CLUJ':
                exit(12);
            'CONSTANTA':
                exit(13);
            'COVASNA':
                exit(14);
            'DAMBOVITA':
                exit(15);
            'DOLJ':
                exit(16);
            'GALATI':
                exit(17);
            'GIURGIU':
                exit(52);
            'GORJ':
                exit(18);
            'HARGHITA':
                exit(19);
            'HUNEDOARA':
                exit(20);
            'IALOMITA':
                exit(21);
            'IASI':
                exit(22);
            'ILFOV':
                exit(23);
            'MARAMURES':
                exit(24);
            'MEHEDINTI':
                exit(25);
            'MURES':
                exit(26);
            'NEAMT':
                exit(27);
            'OLT':
                exit(28);
            'PRAHOVA':
                exit(29);
            'SATU MARE':
                exit(30);
            'SALAJ':
                exit(31);
            'SIBIU':
                exit(32);
            'SUCEAVA':
                exit(33);
            'TELEORMAN':
                exit(34);
            'TIMIS':
                exit(35);
            'TULCEA':
                exit(36);
            'VASLUI':
                exit(37);
            'VALCEA':
                exit(38);
            'VRANCEA':
                exit(39);
            'BUCURESTI':
                exit(40);
            else
                exit(0);
        end;
    end;

    procedure SetHideDialog(_HideDialog: Boolean)
    begin
        HideDialog := _HideDialog;
    end;
}
