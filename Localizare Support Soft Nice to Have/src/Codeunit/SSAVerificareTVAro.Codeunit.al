codeunit 71101 "SSA VerificareTVA.ro"
{
    var
        RequestStringTemplate: Label 'nume=%1&pwd=%2&cui=%3&data=%4-%5-%6', Locked = true;
        CountryRegion: Record "Country/Region";
        G_Raspuns: Text;
        G_Nume: Text;
        G_CUI: Text;
        G_NrInmtr: Text;
        G_Judet: Text;
        G_Localitate: Text;
        G_Adresa: Text;
        G_Stare: Text;
        G_Actualizat: Date;
        G_TVA: Boolean;
        G_TVAIncasare: Boolean;
        G_DataTVAIncasare: Date;
        G_DataTVA: Date;
        G_HideMessage: Boolean;
        G_TVASplit: Boolean;
        G_DataTVASplit: Date;

    procedure ValidateCustomer(var _Customer: Record Customer)
    var
        SSASetup: Record "SSA Localization Setup";
        cui: Code[20];
    begin
        SSASetup.Get;
        SSASetup.TestField("Cust. Neex. VAT Posting Group");

        cui := _Customer."VAT Registration No.";
        cui := DelChr(cui, '=', 'R');
        cui := DelChr(cui, '=', 'r');
        cui := DelChr(cui, '=', 'O');
        cui := DelChr(cui, '=', 'o');
        cui := DelChr(cui, '=', ' ');

        SendRequest(cui, Today);
        if G_Raspuns = 'valid' then begin
            _Customer.Validate(Name, CopyStr(G_Nume, 1, 50));
            _Customer.Validate("Name 2", CopyStr(G_Nume, 51, 50));
            _Customer.Validate("SSA Commerce Trade No.", G_NrInmtr);
            _Customer.Validate(County, G_Judet);
            _Customer.Validate(City, CopyStr(G_Localitate, 1, 30));
            _Customer.Validate(Address, CopyStr(G_Adresa, 1, 50));
            _Customer.Validate("Address 2", CopyStr(G_Adresa, 51, 50));
            _Customer.Validate("SSA Not VAT Registered", not G_TVA);
            _Customer.Validate("SSA Last Date Modified VAT", Today);
            _Customer.Validate("SSA Cod Judet D394", GetJudet);
            if G_TVA then begin
                _Customer.Validate("SSA Tip Partener", _Customer."SSA Tip Partener"::"1-CUI Valid din RO si din afara inreg. in scopuri de TVA in RO");
                _Customer.Validate("VAT Registration No.", 'RO' + cui);
            end else begin
                _Customer.Validate("SSA Tip Partener", _Customer."SSA Tip Partener"::"2-CNP PFA din RO sau CUI neinregistrat in scopuri de TVA");
                _Customer.Validate("VAT Registration No.", cui);
            end;

        end else begin
            CountryRegion.Get(_Customer."Country/Region Code");
            if CountryRegion."EU Country/Region Code" <> '' then
                if CountryRegion."EU Country/Region Code" <> 'RO' then
                    _Customer.Validate("SSA Tip Partener", _Customer."SSA Tip Partener"::"3-Fara CUI valid din UE fara RO")
                else
                    _Customer.Validate("SSA Tip Partener", _Customer."SSA Tip Partener"::"2-CNP PFA din RO sau CUI neinregistrat in scopuri de TVA")
            else
                _Customer.Validate("SSA Tip Partener", _Customer."SSA Tip Partener"::"4-Fara CUI valid din afara UE fara RO");
        end;
        if SSASetup."Sistem TVA" = SSASetup."Sistem TVA"::"Sistem de TVA la Incasare" then
            if SSASetup."Cust. Neex. VAT Posting Group" <> _Customer."VAT Bus. Posting Group" then
                _Customer.Validate("VAT Bus. Posting Group", SSASetup."Cust. Neex. VAT Posting Group");
        if SSASetup."Sistem TVA" = SSASetup."Sistem TVA"::"Neplatitor de TVA" then
            if SSASetup."Cust. Nepl. VAT Posting Group" <> _Customer."VAT Bus. Posting Group" then
                _Customer.Validate("VAT Bus. Posting Group", SSASetup."Cust. Nepl. VAT Posting Group");
        _Customer.Validate("SSA Last Date Modified VAT", Today);
        _Customer.Modify(true);
        ShowConfirmationMessage;
    end;

    procedure ValidateVendor(var _Vendor: Record Vendor)
    var
        SSASetup: Record "SSA Localization Setup";
        cui: Code[20];
    begin
        SSASetup.Get;
        SSASetup.TestField("Vendor Ex. VAT Posting Group");
        SSASetup.TestField("Vendor Neex. VAT Posting Group");

        _Vendor.TestField(_Vendor."Country/Region Code", 'RO');
        cui := _Vendor."VAT Registration No.";
        cui := DelChr(cui, '=', 'R');
        cui := DelChr(cui, '=', 'r');
        cui := DelChr(cui, '=', 'O');
        cui := DelChr(cui, '=', 'o');
        cui := DelChr(cui, '=', ' ');

        SendRequest(cui, Today);
        if G_Raspuns = 'valid' then begin
            _Vendor.Validate(Name, CopyStr(G_Nume, 1, 50));
            _Vendor.Validate("Name 2", CopyStr(G_Nume, 51, 50));
            _Vendor.Validate("SSA Commerce Trade No.", G_NrInmtr);
            _Vendor.Validate(County, G_Judet);
            _Vendor.Validate(City, CopyStr(G_Localitate, 1, 30));
            _Vendor.Validate(Address, CopyStr(G_Adresa, 1, 50));
            _Vendor.Validate("Address 2", CopyStr(G_Adresa, 51, 50));
            _Vendor.Validate("SSA Not VAT Registered", not G_TVA);
            if G_TVAIncasare then
                _Vendor.Validate("VAT Bus. Posting Group", SSASetup."Vendor Neex. VAT Posting Group")
            else
                _Vendor.Validate("VAT Bus. Posting Group", SSASetup."Vendor Ex. VAT Posting Group");

            _Vendor.Validate("SSA Cod Judet D394", GetJudet);
            if G_TVA then begin
                _Vendor.Validate("SSA Tip Partener", _Vendor."SSA Tip Partener"::"1-CUI Valid din RO si din afara inreg. in scopuri de TVA in RO");
                _Vendor.Validate("VAT Registration No.", 'RO' + cui);
            end else begin
                _Vendor.Validate("SSA Tip Partener", _Vendor."SSA Tip Partener"::"2-CNP PFA din RO sau CUI neinregistrat in scopuri de TVA");
                _Vendor.Validate("VAT Registration No.", cui);
            end;

        end else begin
            CountryRegion.Get(_Vendor."Country/Region Code");
            if CountryRegion."EU Country/Region Code" <> '' then
                if CountryRegion."EU Country/Region Code" <> 'RO' then
                    _Vendor.Validate("SSA Tip Partener", _Vendor."SSA Tip Partener"::"3-Fara CUI valid din UE fara RO")
                else
                    _Vendor.Validate("SSA Tip Partener", _Vendor."SSA Tip Partener"::"2-CNP PFA din RO sau CUI neinregistrat in scopuri de TVA")
            else
                _Vendor.Validate("SSA Tip Partener", _Vendor."SSA Tip Partener"::"4-Fara CUI valid din afara UE fara RO");
        end;
        _Vendor.Validate("SSA Last Date Modified VAT", Today);
        _Vendor.Validate("SSA Split VAT", G_TVASplit);
        _Vendor.Validate("SSA VAT to Pay", G_TVAIncasare);
        if SSASetup."Sistem TVA" = SSASetup."Sistem TVA"::"Sistem de TVA la Incasare" then
            if SSASetup."Vendor Neex. VAT Posting Group" <> _Vendor."VAT Bus. Posting Group" then
                _Vendor.Validate("VAT Bus. Posting Group", SSASetup."Vendor Neex. VAT Posting Group");
        if SSASetup."Sistem TVA" = SSASetup."Sistem TVA"::"Neplatitor de TVA" then
            if SSASetup."Vendor Nepl. VAT Posting Group" <> _Vendor."VAT Bus. Posting Group" then
                _Vendor.Validate("VAT Bus. Posting Group", SSASetup."Vendor Nepl. VAT Posting Group");
        _Vendor.Modify(true);
        ShowConfirmationMessage;
    end;

    local procedure SendRequest(_CUI: Code[20]; _RequestDate: Date)
    var
        Client: HttpClient;
        ResponseMessage: HttpResponseMessage;
        RequestHeaders: HttpHeaders;
        Content: HttpContent;
        ResponseText: Text;
        SSASetup: Record "SSA Localization Setup";
    begin
        //SendRequest
        if (_CUI = '') or (_RequestDate = 0D) then
            exit;

        SSASetup.Get;
        SSASetup.TestField("SSA VAT API URL");
        SSASetup.TestField("SSA VAT User Name");
        SSASetup.TestField("SSA VAT Password");

        Content.Clear();
        Content.WriteFrom(StrSubstNo(
          RequestStringTemplate, SSASetup."SSA VAT User Name", SSASetup."SSA VAT Password", _CUI,
          Date2DMY(_RequestDate, 3), Date2DMY(_RequestDate, 2), Date2DMY(_RequestDate, 1)));
        Content.GetHeaders(RequestHeaders);
        RequestHeaders.Remove('Content-Type');
        RequestHeaders.Add('Content-Type', 'application/x-www-form-urlencoded');
        Client.Post(SSASetup."SSA VAT API URL", Content, ResponseMessage);

        ResponseMessage.Content.ReadAs(ResponseText);
        ParseResponseJSON(ResponseText);
    end;

    local procedure ParseResponseJSON(_ResponseText: Text)
    var
        JsonBuffer: Record "JSON Buffer" temporary;
        JsonTextReaderWriter: Codeunit "Json Text Reader/Writer";
        FoundLabel: Label 'found[%1]*', Locked = true;
        IndexCui: Integer;
        Tip: Text;
        Nr: Text;
        Adresa: Text;
        ActualizatDate: Text;
        TVA: Text;
        TVAIncasare: Text;
        DataTVA: Text;
        TVASplit: Text;
        DataTVAIncasare: Text;
        DataTVASplit: Text;

    begin
        JsonBuffer.reset;
        JsonBuffer.DeleteAll();
        JsonTextReaderWriter.ReadJSonToJSonBuffer(_ResponseText, JsonBuffer);

        Clear(G_Raspuns);
        Clear(G_Nume);
        Clear(G_CUI);
        Clear(G_NrInmtr);
        Clear(G_Judet);
        Clear(G_Localitate);
        Clear(G_Adresa);
        Clear(G_Stare);
        Clear(G_Actualizat);
        Clear(G_TVA);
        Clear(G_TVAIncasare);
        Clear(G_DataTVA);

        if StrPos(_ResponseText, 'ERROR') > 0 then
            Error(_ResponseText); // error

        if JSONBuffer.GetPropertyValueAtPath(G_Raspuns, 'Raspuns', StrSubstNo(FoundLabel, IndexCui)) then;
        if JsonBuffer.GetPropertyValueAtPath(G_Nume, 'Nume', StrSubstNo(FoundLabel, IndexCui)) then;
        if JsonBuffer.GetPropertyValueAtPath(G_CUI, 'CUI', StrSubstNo(FoundLabel, IndexCui)) then;
        if JsonBuffer.GetPropertyValueAtPath(G_NrInmtr, 'NrInmatr', StrSubstNo(FoundLabel, IndexCui)) then;
        if JsonBuffer.GetPropertyValueAtPath(G_Judet, 'Judet', StrSubstNo(FoundLabel, IndexCui)) then;
        if JsonBuffer.GetPropertyValueAtPath(G_Localitate, 'Localitate', StrSubstNo(FoundLabel, IndexCui)) then;
        if JsonBuffer.GetPropertyValueAtPath(Adresa, 'Adresa', StrSubstNo(FoundLabel, IndexCui)) then;
        if JsonBuffer.GetPropertyValueAtPath(Nr, 'Nr', StrSubstNo(FoundLabel, IndexCui)) then;
        if JsonBuffer.GetPropertyValueAtPath(Tip, 'Tip', StrSubstNo(FoundLabel, IndexCui)) then;
        if JsonBuffer.GetPropertyValueAtPath(G_Stare, 'Stare', StrSubstNo(FoundLabel, IndexCui)) then;

        if JsonBuffer.GetPropertyValueAtPath(ActualizatDate, 'Actualizat', StrSubstNo(FoundLabel, IndexCui)) then
            G_Actualizat := ConvertJsonDateToDate(ActualizatDate);

        if JsonBuffer.GetPropertyValueAtPath(TVA, 'TVA', StrSubstNo(FoundLabel, IndexCui)) then
            Evaluate(G_TVA, TVA);

        if JsonBuffer.GetPropertyValueAtPath(DataTVA, 'TVA_data', StrSubstNo(FoundLabel, IndexCui)) then
            G_DataTVA := ConvertJsonDateToDate(DataTVA);

        if JsonBuffer.GetPropertyValueAtPath(TVAIncasare, 'TVAincasare', StrSubstNo(FoundLabel, IndexCui)) then
            Evaluate(G_TVAIncasare, TVAIncasare);

        if JsonBuffer.GetPropertyValueAtPath(DataTVAIncasare, 'TVAincasare_data', StrSubstNo(FoundLabel, IndexCui)) then
            G_DataTVAIncasare := ConvertJsonDateToDate(DataTVAIncasare);

        if JsonBuffer.GetPropertyValueAtPath(TVASplit, 'TVAsplit', StrSubstNo(FoundLabel, IndexCui)) then
            Evaluate(G_TVASplit, TVASplit);

        if JsonBuffer.GetPropertyValueAtPath(DataTVASplit, 'TVAsplit_data', StrSubstNo(FoundLabel, IndexCui)) then
            G_DataTVASplit := ConvertJsonDateToDate(DataTVASplit);

        G_Adresa := Tip + ' ' + Adresa + ' ' + Nr;
    end;

    procedure ShowConfirmationMessage()
    begin
        if not G_HideMessage then
            Message(
            StrSubstNo('Raspuns:%1\' +
            'TVA:%2\' +
            'TVAIncasare:%3\' +
            'Nume:%4\' +
            'CUI:%5\' +
            'NrInmatr:%6\' +
            'Judet:%7\' +
            'Localitate:%8\' +
            'Adresa:%9\' +
            'Stare:%10\' +
            'Actualizat:%11\' +
            'Data TVA:%12\' +
            'Data TVAincasare:%13\' +
            'TVA_Split:%14\' +
            'Data TVA_Split:%15\',
            UpperCase(G_Raspuns), G_TVA, G_TVAIncasare, G_Nume, G_CUI, G_NrInmtr, G_Judet, G_Localitate, G_Adresa, DelChr(G_Stare, '=', '\r'), G_Actualizat, G_DataTVA, G_DataTVAIncasare, G_TVASplit, G_DataTVASplit));
    end;

    procedure SetHideMessage(_HideMessage: Boolean)
    begin
        G_HideMessage := _HideMessage;
    end;

    procedure GetJudet(): Integer
    begin
        case G_Judet of
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

    procedure ConvertJsonDateToDate(_CurrValue: Text): Date
    var
        Day: Integer;
        Month: Integer;
        Year: Integer;
    begin
        if StrLen(_CurrValue) < 10 then
            exit(0D);
        Evaluate(Day, CopyStr(_CurrValue, 9, 2));
        Evaluate(Month, CopyStr(_CurrValue, 6, 2));
        Evaluate(Year, CopyStr(_CurrValue, 1, 4));
        exit(DMY2Date(Day, Month, Year));
    end;

    procedure IsCNP(_InText: Text): Boolean
    begin
        if StrPos(_InText, '/') > 0 then
            exit(false);
        exit(true);
    end;
}
