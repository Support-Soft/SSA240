codeunit 71101 "SSA VerificareTVA.ro"
{
    // SSA966 SSCAT 05.11.2019 32.Funct. verificare TVA (ANAF, verificaretva.ro) - TVA la plata, split TVA


    trigger OnRun()
    begin
    end;

    var
        RequestStringTemplate: Label 'nume=%1&pwd=%2&cui=%3&data=%4-%5-%6';
        FormatChar: Label '{}"''[]';
        CountryRegion: Record "Country/Region";
        G_Raspuns: Text[6];
        G_Nume: Text[255];
        G_CUI: Code[20];
        G_NrInmtr: Text[15];
        G_Judet: Text[75];
        G_Localitate: Text[75];
        G_Adresa: Text[360];
        G_Stare: Text[255];
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

        with _Customer do begin
            cui := "VAT Registration No.";
            cui := DelChr(cui, '=', 'R');
            cui := DelChr(cui, '=', 'r');
            cui := DelChr(cui, '=', 'O');
            cui := DelChr(cui, '=', 'o');
            cui := DelChr(cui, '=', ' ');

            SendRequest(cui, Today);
            if G_Raspuns = 'valid' then begin
                Validate(Name, CopyStr(G_Nume, 1, 50));
                Validate("Name 2", CopyStr(G_Nume, 51, 50));
                Validate("SSA Commerce Trade No.", G_NrInmtr);
                Validate(County, G_Judet);
                Validate(City, CopyStr(G_Localitate, 1, 30));
                Validate(Address, CopyStr(G_Adresa, 1, 50));
                Validate("Address 2", CopyStr(G_Adresa, 51, 50));
                Validate("SSA Not VAT Registered", not G_TVA);
                Validate("SSA Last Date Modified VAT", Today);
                Validate("SSA Cod Judet D394", GetJudet);
                if G_TVA then begin
                    Validate("SSA Tip Partener", "SSA Tip Partener"::"1-CUI Valid din RO si din afara inreg. in scopuri de TVA in RO");
                    Validate("VAT Registration No.", 'RO' + cui);
                end else begin
                    Validate("SSA Tip Partener", "SSA Tip Partener"::"2-CNP PFA din RO sau CUI neinregistrat in scopuri de TVA");
                    Validate("VAT Registration No.", cui);
                end;

            end else begin
                CountryRegion.Get("Country/Region Code");
                if CountryRegion."EU Country/Region Code" <> '' then
                    if CountryRegion."EU Country/Region Code" <> 'RO' then
                        Validate("SSA Tip Partener", "SSA Tip Partener"::"3-Fara CUI valid din UE fara RO")
                    else
                        Validate("SSA Tip Partener", "SSA Tip Partener"::"2-CNP PFA din RO sau CUI neinregistrat in scopuri de TVA")
                else
                    Validate("SSA Tip Partener", "SSA Tip Partener"::"4-Fara CUI valid din afara UE fara RO");
            end;
            if SSASetup."Sistem TVA" = SSASetup."Sistem TVA"::"Sistem de TVA la Incasare" then
                if SSASetup."Cust. Neex. VAT Posting Group" <> "VAT Bus. Posting Group" then
                    Validate("VAT Bus. Posting Group", SSASetup."Cust. Neex. VAT Posting Group");
            if SSASetup."Sistem TVA" = SSASetup."Sistem TVA"::"Neplatitor de TVA" then
                if SSASetup."Cust. Nepl. VAT Posting Group" <> "VAT Bus. Posting Group" then
                    Validate("VAT Bus. Posting Group", SSASetup."Cust. Nepl. VAT Posting Group");
            Validate("SSA Last Date Modified VAT", Today);
            Modify(true);
        end;
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

        with _Vendor do begin
            TestField(_Vendor."Country/Region Code", 'RO');
            cui := "VAT Registration No.";
            cui := DelChr(cui, '=', 'R');
            cui := DelChr(cui, '=', 'r');
            cui := DelChr(cui, '=', 'O');
            cui := DelChr(cui, '=', 'o');
            cui := DelChr(cui, '=', ' ');

            SendRequest(cui, Today);
            if G_Raspuns = 'valid' then begin
                Validate(Name, CopyStr(G_Nume, 1, 50));
                Validate("Name 2", CopyStr(G_Nume, 51, 50));
                Validate("SSA Commerce Trade No.", G_NrInmtr);
                Validate(County, G_Judet);
                Validate(City, CopyStr(G_Localitate, 1, 30));
                Validate(Address, CopyStr(G_Adresa, 1, 50));
                Validate("Address 2", CopyStr(G_Adresa, 51, 50));
                Validate("SSA Not VAT Registered", not G_TVA);
                if G_TVAIncasare then
                    Validate("VAT Bus. Posting Group", SSASetup."Vendor Neex. VAT Posting Group")
                else
                    Validate("VAT Bus. Posting Group", SSASetup."Vendor Ex. VAT Posting Group");

                Validate("SSA Cod Judet D394", GetJudet);
                if G_TVA then begin
                    Validate("SSA Tip Partener", "SSA Tip Partener"::"1-CUI Valid din RO si din afara inreg. in scopuri de TVA in RO");
                    Validate("VAT Registration No.", 'RO' + cui);
                end else begin
                    Validate("SSA Tip Partener", "SSA Tip Partener"::"2-CNP PFA din RO sau CUI neinregistrat in scopuri de TVA");
                    Validate("VAT Registration No.", cui);
                end;

            end else begin
                CountryRegion.Get("Country/Region Code");
                if CountryRegion."EU Country/Region Code" <> '' then
                    if CountryRegion."EU Country/Region Code" <> 'RO' then
                        Validate("SSA Tip Partener", "SSA Tip Partener"::"3-Fara CUI valid din UE fara RO")
                    else
                        Validate("SSA Tip Partener", "SSA Tip Partener"::"2-CNP PFA din RO sau CUI neinregistrat in scopuri de TVA")
                else
                    Validate("SSA Tip Partener", "SSA Tip Partener"::"4-Fara CUI valid din afara UE fara RO");
            end;
            Validate("SSA Last Date Modified VAT", Today);
            Validate("SSA Split VAT", G_TVASplit);
            Validate("SSA VAT to Pay", G_TVAIncasare);
            if SSASetup."Sistem TVA" = SSASetup."Sistem TVA"::"Sistem de TVA la Incasare" then
                if SSASetup."Vendor Neex. VAT Posting Group" <> "VAT Bus. Posting Group" then
                    Validate("VAT Bus. Posting Group", SSASetup."Vendor Neex. VAT Posting Group");
            if SSASetup."Sistem TVA" = SSASetup."Sistem TVA"::"Neplatitor de TVA" then
                if SSASetup."Vendor Nepl. VAT Posting Group" <> "VAT Bus. Posting Group" then
                    Validate("VAT Bus. Posting Group", SSASetup."Vendor Nepl. VAT Posting Group");
            Modify(true);
        end;
        ShowConfirmationMessage;
    end;

    local procedure SendRequest(_CUI: Code[20]; _RequestDate: Date)
    var
        SSASetup: Record "SSA Localization Setup";
        SSAHttpWebRequest: DotNet SSASSAHttpWebRequest;
        HttpWebResponse: DotNet SSAHttpWebResponse;
        IStream: InStream;
        OStream: OutStream;
        f: File;
        RequestString: Text[250];
        FileName: Text[250];
    begin
        //SendRequest
        if (_CUI = '') or (_RequestDate = 0D) then
            exit;

        SSASetup.Get;
        SSASetup.TestField("SSA VAT API URL");
        SSASetup.TestField("SSA VAT User Name");
        SSASetup.TestField("SSA VAT Password");

        SSAHttpWebRequest := SSAHttpWebRequest.Create(SSASetup."SSA VAT API URL");
        SSAHttpWebRequest.Timeout := 30000;

        SSAHttpWebRequest.Method := 'POST';

        SSAHttpWebRequest.ContentType('application/x-www-form-urlencoded');

        OStream := SSAHttpWebRequest.GetRequestStream;

        RequestString := StrSubstNo(
          RequestStringTemplate, SSASetup."SSA VAT User Name", SSASetup."SSA VAT Password", _CUI,
          Date2DMY(_RequestDate, 3), Date2DMY(_RequestDate, 2), Date2DMY(_RequestDate, 1));

        OStream.WriteText(RequestString);

        HttpWebResponse := SSAHttpWebRequest.GetResponse();
        IStream := HttpWebResponse.GetResponseStream;

        //test
        FileName := TemporaryPath + '\' + _CUI + '.txt';
        //FileName := 'C:\Temp\a.txt';
        if Exists(FileName) then
            Erase(FileName);

        f.Create(FileName);

        f.TextMode(true);
        f.CreateOutStream(OStream);
        CopyStream(OStream, IStream);
        f.Close;

        ParseResponseJSON(FileName);
    end;

    local procedure ParseResponseJSON(_FileName: Text[250])
    var
        fw: File;
        TextLine: Text[1024];
        CurrentObject: Text[50];
        ValuePair: Text[255];
        CurrentElement: Text[255];
        CurrentValue: Text[255];
        ElementName: Text[255];
        ElementValue: Text[255];
        NewSting: Text[255];
        tmpDate: Date;
        IntLen: Integer;
        x: Integer;
        l: Integer;
        p: Integer;
        Tip: Text[50];
        Nr: Text[50];
        Adresa: Text[255];
    begin
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
        Clear(Tip);
        Clear(Adresa);
        Clear(Nr);

        fw.TextMode(true);
        fw.WriteMode(false);
        fw.Open(_FileName);
        IntLen := fw.Len;

        while fw.Pos < IntLen do begin
            p := 0;
            x := 1;

            fw.Read(TextLine);

            if StrPos(TextLine, 'ERROR') > 0 then
                Error(TextLine); // error


            TextLine := DelChr(TextLine, '=', '{}');
            l := StrLen(TextLine);

            while p < l do begin
                ValuePair := SelectStr(x, TextLine);  // get comma separated pairs of values and element names

                p := StrPos(TextLine, ValuePair) + StrLen(ValuePair); // move pointer to the end of the current pair in Value

                ValuePair := DelChr(ValuePair, '=', FormatChar);

                if StrPos(ValuePair, ':') = 0 then begin
                    CurrentValue := CurrentValue + ',' + ValuePair;

                end else begin
                    CurrentElement := CopyStr(ValuePair, 1, StrPos(ValuePair, ':'));
                    CurrentElement := DelChr(CurrentElement, '=', ':');

                    CurrentValue := CopyStr(ValuePair, StrPos(ValuePair, ':'));
                    CurrentValue := DelChr(CurrentValue, '=', ':');
                end;

                case CurrentElement of
                    'Raspuns':
                        Evaluate(G_Raspuns, CurrentValue);
                    'Nume':
                        Evaluate(G_Nume, CurrentValue);
                    'CUI':
                        Evaluate(G_CUI, CurrentValue);
                    'NrInmatr':
                        Evaluate(G_NrInmtr, CurrentValue);
                    'Judet':
                        Evaluate(G_Judet, CurrentValue);
                    'Localitate':
                        Evaluate(G_Localitate, CurrentValue);
                    'Tip':
                        Evaluate(Tip, CurrentValue);
                    'Adresa':
                        Evaluate(Adresa, CurrentValue);
                    'Nr':
                        begin
                            Evaluate(Nr, CurrentValue);
                            G_Adresa := Tip + ' ' + Adresa + ' ' + Nr;
                        end;
                    'Stare':
                        Evaluate(G_Stare, CurrentValue);
                    'Actualizat':
                        G_Actualizat := ConvertJsonDateToDate(CurrentValue);
                    'TVA':
                        Evaluate(G_TVA, CurrentValue);
                    'TVA_data':
                        G_DataTVA := ConvertJsonDateToDate(CurrentValue);
                    'TVAincasare':
                        Evaluate(G_TVAIncasare, CurrentValue);
                    'TVAincasare_data':
                        G_DataTVAIncasare := ConvertJsonDateToDate(CurrentValue);
                    'DataTVA':
                        G_DataTVA := ConvertJsonDateToDate(CurrentValue);
                    'TVAsplit':
                        Evaluate(G_TVASplit, CurrentValue);
                    'TVAsplit_data':
                        G_DataTVASplit := ConvertJsonDateToDate(CurrentValue);
                end;

                x := x + 1; // next pair
            end;
        end;
        fw.Close;
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
    var
        Done: Boolean;
        CNPLen: Integer;
        i: Integer;
        IntVar: Integer;
    begin
        if StrPos(_InText, '/') > 0 then
            exit(false);
        exit(true);
    end;
}

