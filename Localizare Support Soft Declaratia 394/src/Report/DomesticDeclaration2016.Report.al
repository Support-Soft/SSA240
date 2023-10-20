report 71701 "SSA Domestic Declaration 2016"
{
    // SSA973 SSCAT 06.09.2019 39.Rapoarte legale- Localizare Declaratia 394

    Caption = 'Domestic Declaration';
    ProcessingOnly = true;
    ApplicationArea = All;

    dataset
    {
        dataitem("SSA Domestic Declaration"; "SSA Domestic Declaration")
        {
            dataitem("SSA Domestic Declaration Line"; "SSA Domestic Declaration Line")
            {
                DataItemLink = "Domestic Declaration Code" = FIELD(Code);
                DataItemTableView = SORTING("Domestic Declaration Code", "Line No.");

                trigger OnAfterGetRecord()
                var
                    TaxGroupCode: Code[10];
                begin
                    if "Stare Factura" <> "Stare Factura"::"2-Factura Anulata" then begin //2504
                        if "Cod CAEN" = '' then begin
                            //Serie
                            if StartingDate > 20160930D then
                                if "SSA Domestic Declaration Line".Type = "SSA Domestic Declaration Line".Type::Sale then
                                    if not SerieBuffer.Get(0, 0, "Cod Serie Factura", '') then
                                        if ("SSA Domestic Declaration Line"."Tip Document D394" <> "SSA Domestic Declaration Line"."Tip Document D394"::"Bon Fiscal") then
                                            InsertNoSeriesBuffer("Domestic Declaration Code", "Cod Serie Factura", "Posting Date");

                            //insert Info
                            InsertInfo("SSA Domestic Declaration Line");

                            //Insert facturi Buffer
                            if StartingDate > 20160930D then
                                if "SSA Domestic Declaration Line".Type = "SSA Domestic Declaration Line".Type::Sale then
                                    InsertFacturiBuffer("SSA Domestic Declaration Line");

                            //Insert Operatii buffer
                            InsertOpBuffer("SSA Domestic Declaration Line");
                        end else
                            //Insert Lista Buffer
                            InsertListaCAENBuffer("SSA Domestic Declaration Line");
                    end else
                        if "Cod CAEN" = '' then
                            if StartingDate > 20160930D then
                                if "SSA Domestic Declaration Line".Type = "SSA Domestic Declaration Line".Type::Sale then
                                    InsertFacturiBuffer("SSA Domestic Declaration Line");

                    RecNo += 1;
                    w.Update(1, Round(RecNo / TotalRecNo * 10000, 1));
                end;

                trigger OnPreDataItem()
                begin
                    if StartingDate <= 20160930D then
                        SetRange("Tip Partener", "Tip Partener"::"1-CUI Valid din RO si din afara inreg. in scopuri de TVA in RO");

                    SetRange("Unrealized VAT Entry No.", 0);

                    TotalRecNo := Count;
                end;
            }

            trigger OnAfterGetRecord()
            begin

                if Reported then
                    CurrReport.Skip;

                TestField("Tip Intocmit");
                TestField(Perioada);
                DomesticDeclarations.Get(Code);

                Reported := true;
                Modify;

                TestField("Starting Date");
                TestField("Ending Date");

                StartingDate := "Starting Date";
                EndingDate := "Ending Date";

                R1Buffer.Reset;
                R1Buffer.DeleteAll;

                R1Detaliu.Reset;
                R1Detaliu.DeleteAll;

                R2Buffer.Reset;
                R2Buffer.DeleteAll;

                SerieBuffer.Reset;
                SerieBuffer.DeleteAll;

                InfoBuffer.Reset;
                InfoBuffer.DeleteAll;

                FacturiBuffer.Reset;
                FacturiBuffer.DeleteAll;

                ListaBuffer.Reset;
                ListaBuffer.DeleteAll;

                OpBuffer.Reset;
                OpBuffer.DeleteAll;

                Op11Buffer.Reset;
                Op11Buffer.DeleteAll;

                Op2Buffer.Reset;
                Op2Buffer.DeleteAll;

                CountBuffer.Reset;
                CountBuffer.DeleteAll;

                NrFactCountBuff.Reset;
                NrFactCountBuff.DeleteAll;

                NrBFCount.Reset;
                NrBFCount.DeleteAll;

                InfoDocBuff.Reset;
                InfoDocBuff.DeleteAll;
            end;
        }
        dataitem("Integer"; "Integer")
        {
            DataItemTableView = SORTING(Number);

            trigger OnAfterGetRecord()
            begin

                InsertOp2Buffer;

                UpdateInfo;

                UpdateRezumate;

                CalcTotalA;

                CreateDeclaration394;

                WriteInformatii;

                WriteR1BuffertoXML;
                WriteR2BuffertoXML;

                if StartingDate >= 20160930D then begin
                    UpdateSerieBuffer;
                    WriteSerieFacturi;
                end;

                WriteListaCAEN;

                if StartingDate >= 20160930D then
                    WriteFacturi;

                WriteOperatii;
                WriteOp2;
            end;

            trigger OnPreDataItem()
            begin
                SetRange(Number, 1, 1)
            end;
        }
    }
    labels
    {
    }

    trigger OnInitReport()
    begin
        SSASetup.Get;
        SSASetup.TestField("Sistem TVA");
        SSASetup.TestField("CAEN Code");
        CompanyInfo.Get;
    end;

    trigger OnPostReport()
    var
        FileMgt: Codeunit "File Management";
        FileName: Text;
    begin
        WriteLine('</declaratie394>');

        TempBlob.CreateInStream(XMLInStr);
        DownloadFromStream(XMLInStr, Text001, '', FileMgt.GetToFilterText(Text002, FileName), FileName);

        w.Close;
        Message(Text010, FileName);
    end;

    trigger OnPreReport()
    begin
        w.Open(Text009);
        w.Update(1, 0);
    end;

    var
        CompanyInfo: Record "Company Information";
        SSASetup: Record "SSA Localization Setup";
        DomesticDeclarations: Record "SSA Domestic Declaration";
        R1Buffer: Record "SSA D394 Buffer" temporary;
        R1Detaliu: Record "SSA D394 Buffer" temporary;
        R2Buffer: Record "SSA D394 Buffer" temporary;
        SerieBuffer: Record "SSA D394 Buffer" temporary;
        InfoBuffer: Record "SSA D394 Buffer" temporary;
        FacturiBuffer: Record "SSA Domestic Declaration Line" temporary;
        OpBuffer: Record "SSA D394 Buffer" temporary;
        Op11Buffer: Record "SSA D394 Buffer" temporary;
        Op2Buffer: Record "SSA D394 Buffer" temporary;
        ListaBuffer: Record "SSA D394 Buffer" temporary;
        CountBuffer: Record "SSA D394 Buffer" temporary;
        NrFactCountBuff: Record "SSA D394 Buffer" temporary;
        NrBFCount: Record "SSA D394 Buffer" temporary;
        InfoDocBuff: Record "SSA D394 Buffer" temporary;
        StringLine: Text[1024];
        StartingDate: Date;
        EndingDate: Date;
        TotalPlataA: Integer;
        Text001: Label 'Export to XML File';
        Text002: Label 'XML Files (*.xml)|*.xml|All Files (*.*)|*.*';
        Text006: Label '&';
        Text007: Label '''';
        Text008: Label '"';
        w: Dialog;
        RecNo: Integer;
        TotalRecNo: Integer;
        Text009: Label 'Processing Lines... @1@@@@@@@@@@';
        Text010: Label 'The File %1 has been created.';
        TempBlob: Codeunit "Temp Blob";
        XMLOutStr: OutStream;
        XMLInStr: InStream;

    local
    procedure CreateDeclaration394()
    var
        OpEfectuate: Text[30];
    begin

        //CreateDeclaration394
        TempBlob.CreateOutStream(XMLOutStr);
        WriteLine('<?xml version="1.0"?>');

        AddElement(StringLine, 'declaratie394');
        AddAttribute(StringLine, 'luna', Format(DomesticDeclarations.Perioada));
        AddAttribute(StringLine, 'an', Format(Date2DMY(DomesticDeclarations."Starting Date", 3)));
        AddAttribute(StringLine, 'tip_D394', Format(DomesticDeclarations.TipD394));
        if SSASetup."Sistem TVA" = SSASetup."Sistem TVA"::"Sistem Normal de TVA" then
            AddAttribute(StringLine, 'sistemTVA', '0')
        else
            AddAttribute(StringLine, 'sistemTVA', '1');

        AddAttribute(StringLine, 'op_efectuate', '1');
        AddAttribute(StringLine, 'xmlns:xsi', 'http://www.w3.org/2001/XMLSchema-instance');
        AddAttribute(StringLine, 'xsi:schemaLocation', 'mfp:anaf:dgti:d394:declaratie:v4 D394.xsd');
        AddAttribute(StringLine, 'xmlns', 'mfp:anaf:dgti:d394:declaratie:v4');

        //Sectiunea A
        AddAttribute(StringLine, 'cui', GetVATNo(CompanyInfo."VAT Registration No."));
        AddAttribute(StringLine, 'caen', SSASetup."CAEN Code");
        AddAttribute(StringLine, 'den', ReplaceSpecialChar(CompanyInfo.Name + CompanyInfo."Name 2"));
        AddAttribute(StringLine, 'adresa', ReplaceSpecialChar(CompanyInfo.Address + CompanyInfo."Address 2"));

        if DomesticDeclarations."Telefon Companie" <> '' then
            AddAttribute(StringLine, 'telefon', DomesticDeclarations."Telefon Companie")
        else
            if CompanyInfo."Phone No." <> '' then
                AddAttribute(StringLine, 'telefon', CompanyInfo."Phone No.");

        if DomesticDeclarations."Fax Companie" <> '' then
            AddAttribute(StringLine, 'fax', DomesticDeclarations."Fax Companie")
        else
            if CompanyInfo."Fax No." <> '' then
                AddAttribute(StringLine, 'fax', CompanyInfo."Fax No.");

        if DomesticDeclarations."E-Mail Companie" <> '' then
            AddAttribute(StringLine, 'mail', DomesticDeclarations."E-Mail Companie")
        else
            if CompanyInfo."E-Mail" <> '' then
                AddAttribute(StringLine, 'mail', CompanyInfo."E-Mail");

        AddAttribute(StringLine, 'totalPlata_A', Format(TotalPlataA));

        //Sectiunea B1
        if DomesticDeclarations."CNP Reprezentant" <> '' then
            AddAttribute(StringLine, 'cifR', DomesticDeclarations."CNP Reprezentant");
        AddAttribute(StringLine, 'denR', ReplaceSpecialChar(DomesticDeclarations."Nume Reprezentant"));
        AddAttribute(StringLine, 'functie_reprez', DomesticDeclarations."Functie Declaratie");
        AddAttribute(StringLine, 'adresaR', ReplaceSpecialChar(DomesticDeclarations."Adresa Reprezentant"));
        if DomesticDeclarations."Tel. Reprezentant" <> '' then
            AddAttribute(StringLine, 'telefonR', DomesticDeclarations."Tel. Reprezentant");
        if DomesticDeclarations."Fax Reprezentant" <> '' then
            AddAttribute(StringLine, 'faxR', DomesticDeclarations."Fax Reprezentant");
        if DomesticDeclarations."E-mail Reprezentant" <> '' then
            AddAttribute(StringLine, 'mailR', DomesticDeclarations."E-mail Reprezentant");

        //Sectiunea B2
        if DomesticDeclarations."Tip Intocmit" = DomesticDeclarations."Tip Intocmit"::"Persoana fizica" then begin
            AddAttribute(StringLine, 'tip_intocmit', '1');
            AddAttribute(StringLine, 'calitate_intocmit', DomesticDeclarations."Calitate Intocmit");
            AddAttribute(StringLine, 'functie_intocmit', DomesticDeclarations."Functie Intocmit");
        end else begin
            AddAttribute(StringLine, 'tip_intocmit', '0');
            AddAttribute(StringLine, 'calitate_intocmit', DomesticDeclarations."Calitate Intocmit");
        end;
        AddAttribute(StringLine, 'den_intocmit', ReplaceSpecialChar(DomesticDeclarations."Nume Intocmit"));
        AddAttribute(StringLine, 'cif_intocmit', DomesticDeclarations."CIF Intocmit");
        AddAttribute(StringLine, 'optiune', GetBoolText(DomesticDeclarations."Optiune verificare date"));
        if DomesticDeclarations."Schimb Optiune verificare date" then
            AddAttribute(StringLine, 'schimb_optiune', GetBoolText(DomesticDeclarations."Schimb Optiune verificare date"));

        IF StartingDate >= 20200901D THEN
            AddAttribute(StringLine, 'prsAfiliat', GetBoolText(DomesticDeclarations."Tranzactii Persoane Afiliate"));

        WriteLine(StringLine);
        Clear(StringLine);
    end;

    local
    procedure WriteLine(_StringToFile: Text[1024])
    begin
        //WriteLine

        XMLOutStr.WriteText(_StringToFile);
    end;

    local
    procedure AddElement(var _String: Text[1024]; _Nume: Text[250])
    begin
        //AddElement

        _String := '<' + _Nume + '>'
    end;

    local
    procedure AddAttribute(var _String: Text[1024]; _Nume: Text[250]; _Valoare: Text[250])
    begin
        //AddAttribute

        _String := CopyStr(_String, 1, StrLen(_String) - 1);
        _String += ' ' + _Nume + '="' + _Valoare + '">';
    end;

    local
    procedure GetTxtDocType(_TipDocument: Code[20]): Text[1]
    begin
        //GetTxtDocType

        case _TipDocument of
            'FACTURA FISCALA', 'BON FISCAL', 'FACTURA SIMPLIFICATA':
                exit('1');
            'BORDEROU':
                exit('2');
            'FILE CARNET':
                exit('3');
            'CONTRACT':
                exit('4');
            'ALTE DOCUMENTE':
                exit('5');
            else
                exit('');
        end;
    end;

    local
    procedure GetNoSeriesNoText(No: Code[20]): Code[20]
    var
        StartPos: Integer;
        EndPos: Integer;
    begin
        //GetNoSeriesNoText

        GetIntegerPos(No, StartPos, EndPos);
        if StartPos <> 0 then
            exit(CopyStr(No, StartPos, EndPos - StartPos + 1));
    end;

    local
    procedure GetNoSeriesCodeText(No: Code[20]): Code[20]
    var
        StartPos: Integer;
        EndPos: Integer;
    begin
        //GetNoSeriesCodeText

        GetIntegerPos(No, StartPos, EndPos);
        if StartPos <> 0 then
            exit(CopyStr(No, 1, StartPos - 1));
    end;

    local procedure GetIntegerPos(No: Code[20]; var StartPos: Integer; var EndPos: Integer)
    var
        IsDigit: Boolean;
        i: Integer;
    begin
        //GetIntegerPos

        StartPos := 0;
        EndPos := 0;
        if No <> '' then begin
            i := StrLen(No);
            repeat
                IsDigit := No[i] in ['0' .. '9'];
                if IsDigit then begin
                    if EndPos = 0 then
                        EndPos := i;
                    StartPos := i;
                end;
                i := i - 1;
            until (i = 0) or (StartPos <> 0) and not IsDigit;
        end;
    end;

    local
    procedure GetVATNo(InText: Text[30]): Text[30]
    var
        Loop: Boolean;
        IntVal: Integer;
        CharVal: Text;
        TextValue: Text;
    begin
        //GetVATNo
        InText := DelChr(InText, '=', 'rRoO');
        if StrLen(InText) = 1 then
            exit('')
        else
            exit(InText);
    end;

    local
    procedure CheckVATNo(_InText: Text[30]; _TipPartener: Option " ","1-CUI Valid din RO si din afara inreg. in scopuri de TVA in RO","2-CNP PFA din RO sau CUI neinregistrat in scopuri de TVA","3-Fara CUI valid din UE fara RO","4-Fara CUI valid din afara UE fara RO"): Text[30]
    var
        Loop: Boolean;
        IntVal: Integer;
        CharVal: Text;
        TextValue: Text;
    begin
        //CheckVATNo
        if _TipPartener <> _TipPartener::"2-CNP PFA din RO sau CUI neinregistrat in scopuri de TVA" then
            exit(_InText);

        TextValue := _InText;
        Loop := true;
        while Loop do begin
            if StrLen(TextValue) > 0 then begin
                CharVal := CopyStr(TextValue, 1, 1);
                TextValue := CopyStr(TextValue, 2);
                if not Evaluate(IntVal, CharVal) then
                    exit('');
            end else
                Loop := false;
        end;
        exit(_InText);
    end;

    local
    procedure IsFacturaTerti(_NoSeries: Code[20]): Boolean
    var
        NoSeries: Record "No. Series";
    begin
        //IsFacturaTerti

        if _NoSeries = '' then
            exit(false);

        NoSeries.Get(_NoSeries);
        if NoSeries."SSA Tip Serie" = NoSeries."SSA Tip Serie"::"Emise de Terti" then
            exit(true)
        else
            exit(false);
    end;

    local
    procedure IsFacturaBeneficiar(_NoSeries: Code[20]): Boolean
    var
        NoSeries: Record "No. Series";
    begin
        //IsFacturaBeneficiar

        if _NoSeries = '' then
            exit(false);

        NoSeries.Get(_NoSeries);
        if NoSeries."SSA Tip Serie" = NoSeries."SSA Tip Serie"::"Emise de Beneficiari" then
            exit(true)
        else
            exit(false);
    end;

    local
    procedure GetBoolText(InBool: Boolean): Text[30]
    begin
        //GetBoolText

        if InBool then
            exit('1')
        else
            exit('0');
    end;

    local
    procedure ReplaceSpecialChar(_StringToCheck: Text[250]): Text[250]
    var
        Pos01: Integer;
        Pos02: Integer;
        Pos03: Integer;
    begin
        Clear(Pos01);
        Clear(Pos02);
        Clear(Pos03);

        Pos01 := StrPos(_StringToCheck, Text006);
        if Pos01 > 0 then
            _StringToCheck := InsStr(_StringToCheck, 'amp;', Pos01 + 1);

        Pos02 := StrPos(_StringToCheck, Text007);
        while Pos02 > 0 do begin
            _StringToCheck := DelStr(_StringToCheck, Pos02, 1);
            _StringToCheck := InsStr(_StringToCheck, '&apos;', Pos02);
            Pos02 := StrPos(_StringToCheck, Text007)
        end;

        Pos03 := StrPos(_StringToCheck, Text008);
        while Pos03 > 0 do begin
            _StringToCheck := DelStr(_StringToCheck, Pos03, 1);
            _StringToCheck := InsStr(_StringToCheck, '&quot;', Pos03);
            Pos03 := StrPos(_StringToCheck, Text008);
        end;

        exit(_StringToCheck);
    end;

    local
    procedure InserRezumat1Buffer(_TipPartener: Integer; _Cota: Decimal; _TipOperatie: Text[30]; _TipDocument: Text[30]; _Base: Decimal; _Amount: Decimal; _NrFact: Integer)
    begin

        //InsertRezumat1Buffer
        if (R1Buffer.Pk1 = 2) and (R1Buffer.Pk2 = 0) then
            R1Buffer.Pk3 := Format(_TipDocument);

        Clear(R1Buffer);
        R1Buffer.Reset;
        R1Buffer.SetRange(Pk1, _TipPartener);
        R1Buffer.SetRange(Pk2, _Cota);
        if (_TipPartener = 2) and (_Cota = 0) then
            R1Buffer.SetRange(Pk3, Format(_TipDocument));

        if not R1Buffer.Find('-') then begin
            R1Buffer.Pk1 := _TipPartener;
            R1Buffer.Pk2 := _Cota;
            if (_TipPartener = 2) and (_Cota = 0) then
                R1Buffer.Pk3 := Format(_TipDocument);

            R1Buffer.Insert;
        end;

        case _TipOperatie of

            'L':
                begin
                    R1Buffer.Dec01 += _NrFact; //nr fact  L
                    R1Buffer.Dec02 += _Base;
                    R1Buffer.Dec03 += _Amount;
                end;

            'LS':
                if R1Buffer.Pk2 = 0 then begin
                    R1Buffer.Dec04 += _NrFact; //nr fact  LS
                    R1Buffer.Dec05 += _Base;
                    R1Buffer.Dec06 += _Amount;
                end;

            'A':
                begin
                    R1Buffer.Dec07 += _NrFact; //nr fact  A
                    R1Buffer.Dec08 += _Base;
                    R1Buffer.Dec09 += _Amount;
                end;

            'AI':
                begin
                    R1Buffer.Dec10 += _NrFact; //nr fact  AI
                    R1Buffer.Dec11 += _Base;
                    R1Buffer.Dec12 += _Amount;
                end;

            'AS':
                begin
                    R1Buffer.Dec13 += _NrFact; //nr fact  AS
                    R1Buffer.Dec14 += _Base;
                    R1Buffer.Dec15 += _Amount;
                end;

            'ASI':
                begin
                    R1Buffer.Dec16 += _NrFact; //nr fact  ASI
                    R1Buffer.Dec17 += _Base;
                    R1Buffer.Dec18 += _Amount;
                end;

            'V':
                begin
                    R1Buffer.Dec19 += _NrFact; //nr fact  V
                    R1Buffer.Dec20 += _Base;
                    R1Buffer.Dec21 += _Amount;
                end;

            'C':
                begin
                    R1Buffer.Dec22 += _NrFact; //nr fact  C
                    R1Buffer.Dec23 += _Base;
                    R1Buffer.Dec24 += _Amount;
                end;

            'N':
                begin
                    R1Buffer.Dec25 += _NrFact; //nr fact  N
                    R1Buffer.Dec26 += _Base;
                    R1Buffer.Dec27 += _Amount;
                end
            else
                Error('Tip Operatie %1 netratat', _TipOperatie);
        end;

        R1Buffer.Modify;
    end;

    local
    procedure InsertDetaliuBuffer(_TipPartener: Integer; _Cota: Decimal; _TipOperatie: Text[30]; _TipDocument: Text[30]; _TaxGroupCode: Code[10]; _Base: Decimal; _Amount: Decimal; _NrFact: Integer)
    begin
        //InsertDetaliuBuffer

        if StrLen(_TaxGroupCode) > 3 then
            _TaxGroupCode := '21';

        if ((_TipPartener = 1) and
          (_TaxGroupCode in ['21', '22', '23', '24', '25', '26', '27', '28', '29', '30', '31']))
        or
          ((_TipPartener = 2) and
          (_TaxGroupCode in ['21', '22', '23', '32', '33', '34', '35']))
        then begin

            Clear(R1Detaliu);
            R1Detaliu.Reset;
            R1Detaliu.SetRange(Pk1, _TipPartener);
            R1Detaliu.SetRange(Pk2, _Cota);
            R1Detaliu.SetRange(Pk3, _TaxGroupCode);
            if (_TipPartener = 2) and (_Cota = 0) then
                R1Detaliu.SetRange(PK4, Format(_TipDocument));
            if not R1Detaliu.Find('-') then begin
                R1Detaliu.Pk1 := _TipPartener;
                R1Detaliu.Pk2 := _Cota;
                R1Detaliu.Pk3 := _TaxGroupCode;
                if (_TipPartener = 2) and (_Cota = 0) then
                    R1Detaliu.PK4 := Format(_TipDocument);
                R1Detaliu.Insert;
            end;

            case _TipOperatie of
                'L':
                    if (R1Detaliu.Pk1 = 1) and (R1Detaliu.Pk3 in ['29', '30', '31']) then begin
                        R1Detaliu.Dec01 += _NrFact; //nr fact  nrLiv
                        R1Detaliu.Dec02 += _Base;
                        R1Detaliu.Dec03 += _Amount;
                    end;

                'LS':
                    begin
                        R1Detaliu.Dec04 += _NrFact; //nr fact  LS
                        R1Detaliu.Dec05 += _Base;
                        R1Detaliu.Dec06 += _Amount;
                    end;

                'A':
                    if (R1Detaliu.Pk1 = 1) and (R1Detaliu.Pk3 in ['29', '30', '31']) then begin
                        R1Detaliu.Dec07 += _NrFact; //nr fact  nrAchizA
                        R1Detaliu.Dec08 += _Base;
                        R1Detaliu.Dec09 += _Amount;
                    end;

                'AI':
                    if (R1Detaliu.Pk1 = 1) and (R1Detaliu.Pk3 in ['29', '30', '31']) then begin
                        R1Detaliu.Dec10 += _NrFact; //nr fact  nrAchizAI
                        R1Detaliu.Dec11 += _Base;
                        R1Detaliu.Dec12 += _Amount;
                    end;

                'AS':
                    if (R1Detaliu.Pk1 = 1) and (R1Detaliu.Pk3 = '21') then begin
                        R1Detaliu.Dec13 += _NrFact; //nr fact  AS
                        R1Detaliu.Dec14 += _Base;
                        R1Detaliu.Dec15 += _Amount;
                    end;

                'ASI':
                    begin
                        R1Detaliu.Dec16 += _NrFact; //nr fact  ASI
                        R1Detaliu.Dec17 += _Base;
                        R1Detaliu.Dec18 += _Amount;
                    end;

                'V':
                    if (R1Detaliu.Pk1 = 1) then begin
                        R1Detaliu.Dec19 += _NrFact; //nr fact  nrLivV
                        R1Detaliu.Dec20 += _Base;
                        R1Detaliu.Dec21 += _Amount;
                    end;

                'C':
                    if (R1Detaliu.Pk1 = 1) then begin
                        R1Detaliu.Dec22 += _NrFact; //nr fact  nrAchizC
                        R1Detaliu.Dec23 += _Base;
                        R1Detaliu.Dec24 += _Amount;
                    end;

                'N':
                    if R1Detaliu.Pk1 = 2 then begin
                        R1Detaliu.Dec25 += _NrFact; //nr fact  N
                        R1Detaliu.Dec26 += _Base;
                        R1Detaliu.Dec27 += _Amount;
                    end
                    else
                        Error('Tip Operatie %1 netratat', _TipOperatie);
            end;

            R1Detaliu.Modify;
        end;
    end;

    local
    procedure InsertRezumat2Buffer(_TipPartener: Integer; _Cota: Decimal; _TipOperatie: Text[30]; _TipDocument: Text[30]; _Base: Decimal; _Amount: Decimal; _NrFact: Integer)
    begin

        //InsertRezumat2Buffer

        if _Cota = 0 then
            exit;

        Clear(R2Buffer);
        R2Buffer.Reset;
        R2Buffer.SetRange(Pk1, 0);
        R2Buffer.SetRange(Pk2, _Cota);
        R2Buffer.SetRange(Pk3, '');
        if not R2Buffer.Find('-') then begin
            R2Buffer.Pk1 := 0;
            R2Buffer.Pk2 := _Cota;
            R2Buffer.Pk3 := '';

            R2Buffer.Insert;
        end;

        case _TipDocument of

            'Factura Simplificata':
                begin
                    if (_TipOperatie = 'L') then begin
                        R2Buffer.Dec01 += _NrFact; //
                        R2Buffer.Dec02 += _Base; //bazaFSLcod
                        R2Buffer.Dec03 += _Amount;
                        R2Buffer.Dec04 += _NrFact; //
                        R2Buffer.Dec05 += _Base; //bazaFSL
                        R2Buffer.Dec06 += _Amount;
                    end;
                    if (_TipOperatie = 'A') then begin
                        R2Buffer.Dec07 += _NrFact; //
                        R2Buffer.Dec08 += _Base; //bazaFSA
                        R2Buffer.Dec09 += _Amount;
                    end;
                    if (_TipOperatie = 'AI') then begin
                        R2Buffer.Dec10 += _NrFact; //
                        R2Buffer.Dec11 += _Base; //bazaFSAI
                        R2Buffer.Dec12 += _Amount;
                    end;
                end;

            'Bon Fiscal':
                begin
                    if (_TipOperatie in ['L', 'V', 'LS']) then begin
                        R2Buffer.Dec13 += _NrFact; //
                        R2Buffer.Dec14 += _Base; //baza_incasari_i1
                        R2Buffer.Dec15 += _Amount;
                    end;
                    if (_TipOperatie in ['A', 'AI']) then begin
                        R2Buffer.Dec16 += _NrFact; //
                        R2Buffer.Dec17 += _Base; //bazaBFAI
                        R2Buffer.Dec18 += _Amount; //TVABFAI
                    end;
                end;
            else begin
                if (_TipOperatie in ['L', 'V']) then begin
                    R2Buffer.Dec19 += _NrFact; //
                    R2Buffer.Dec20 += _Base; //bazaL
                    R2Buffer.Dec21 += _Amount;
                end;
                if (_TipOperatie in ['A', 'C']) then begin
                    R2Buffer.Dec22 += _NrFact; //
                    R2Buffer.Dec23 += _Base; //bazaA
                    R2Buffer.Dec24 += _Amount;
                end;
                if (_TipOperatie = 'AI') then begin
                    R2Buffer.Dec25 += _NrFact; //
                    R2Buffer.Dec26 += _Base; //bazaAI
                    R2Buffer.Dec27 += _Amount;
                end;
                if StartingDate < 20170101D then
                    if _TipPartener = 2 then
                        if (_TipOperatie = 'L') then begin
                            R2Buffer.Dec28 += _NrFact; //
                            R2Buffer.Dec29 += _Base; //bazaL_PF
                            R2Buffer.Dec30 += _Amount;
                        end;
            end;
        end;
        R2Buffer.Modify;
    end;

    local
    procedure InsertNoSeriesBuffer(_DeclarationCode: Code[20]; _NoSeries: Code[20]; _PostingDate: Date)
    var
        NoSeries: Record "No. Series";
        NoSeriesLine: Record "No. Series Line";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        StartNo: Code[20];
        EndNo: Code[20];
        LastNoUsed: Code[20];
        DomesticDeclarationLine: Record "SSA Domestic Declaration Line";
    begin
        //InsertNoSeriesBuffer

        NoSeries.Get(_NoSeries);

        NoSeriesMgt.SetNoSeriesLineFilter(NoSeriesLine, _NoSeries, _PostingDate);
        if not NoSeriesLine.Find('-') then
            NoSeriesLine.Init;

        NoSeriesLine.TestField("Starting No.");
        NoSeriesLine.TestField("Ending No.");


        StartNo := NoSeriesLine."Starting No.";
        EndNo := NoSeriesLine."Ending No.";
        LastNoUsed := NoSeriesLine."Last No. Used";

        SerieBuffer.Init;
        SerieBuffer.Pk1 := 0;
        SerieBuffer.Pk2 := 0;
        SerieBuffer.Pk3 := _NoSeries;
        SerieBuffer.Code1 := GetNoSeriesCodeText(StartNo); //cod series
        SerieBuffer.Code2 := StartNo;
        SerieBuffer.Code3 := EndNo; //End No Series
        DomesticDeclarationLine.Reset;
        DomesticDeclarationLine.SetCurrentKey("Domestic Declaration Code", "Cod Serie Factura");
        DomesticDeclarationLine.SetRange("Domestic Declaration Code", _DeclarationCode);
        DomesticDeclarationLine.SetRange("Cod Serie Factura", _NoSeries);
        if DomesticDeclarationLine.FindFirst then begin
            SerieBuffer.Code4 := GetNoSeriesNoText(DomesticDeclarationLine."Document No."); //primul nr utilizat
            DomesticDeclarationLine.FindLast;
            SerieBuffer.Code5 := GetNoSeriesNoText(DomesticDeclarationLine."Document No."); //ultimul nr utilizat
            SerieBuffer.Int02 := 5; //flag serie neutilizata
        end;

        SerieBuffer.Int01 := NoSeries."SSA Tip Serie";

        if NoSeries."SSA Tip Serie" in [NoSeries."SSA Tip Serie"::"Emise de Beneficiari", NoSeries."SSA Tip Serie"::"Emise de Terti"] then begin
            NoSeries.TestField("SSA Denumire Beneficiar/Tert");
            NoSeries.TestField("SSA CUI Beneficiar Tert");
            SerieBuffer.Text01 := NoSeries."SSA Denumire Beneficiar/Tert";
            SerieBuffer.Text02 := NoSeries."SSA CUI Beneficiar Tert";
        end;

        SerieBuffer.Insert;
    end;

    local
    procedure InsertInfo(DecLine: Record "SSA Domestic Declaration Line")
    var
        InsertRec: Boolean;
        VATEntry: Record "VAT Entry";
        CountRec: Boolean;
    begin
        //InsertInfo
        if not InfoBuffer.Get(1, 0, '', '') then begin
            InfoBuffer.Init;
            InfoBuffer.Pk1 := 1;
            InfoBuffer.Insert;
        end;

        Clear(CountRec);
        if not InfoDocBuff.Get(0, 0, DecLine."Document No.") then begin
            InfoDocBuff.Init;
            InfoDocBuff.Pk1 := 0;
            InfoDocBuff.Pk2 := 0;
            InfoDocBuff.Pk3 := DecLine."Document No.";
            InfoDocBuff.Insert;
            CountRec := true;
        end else
            CountRec := false;

        InfoBuffer.Code1 := DecLine."Domestic Declaration Code";

        if StartingDate > 20160930D then
            if (DecLine."Tip Document D394" in [DecLine."Tip Document D394"::"Bon Fiscal", DecLine."Tip Document D394"::
        "Factura Simplificata"]) and
              (DecLine."Tip Operatie" in [DecLine."Tip Operatie"::L, DecLine."Tip Operatie"::V, DecLine."Tip Operatie"::LS])
            then begin
                if CountRec then
                    InfoBuffer.Int01 += 1; //nr_BF_i1
                                           //Dec01 += DecLine.Base; //incasari_i1
                InfoBuffer.Dec01 += DecLine.Base + DecLine.Amount; //incasari_i1
            end;

        if IsFacturaTerti(DecLine."Cod Serie Factura") then
            if CountRec then
                InfoBuffer.Int02 += 1; //nrFacturi_terti

        if IsFacturaBeneficiar(DecLine."Cod Serie Factura") then
            if CountRec then
                InfoBuffer.Int03 += 1; //nrFacturi_benef

        if (DecLine."Tip Document D394" = DecLine."Tip Document D394"::"Factura Fiscala") and
          (DecLine.Type = DecLine.Type::Sale)
        then
            if CountRec then
                InfoBuffer.Int04 += 1; //nrFacturi

        if StartingDate < 20170101D then
            if (DecLine."Tip Document D394" = DecLine."Tip Document D394"::"Factura Fiscala") and (DecLine."Tip Partener" in
              [DecLine."Tip Partener"::"2-CNP PFA din RO sau CUI neinregistrat in scopuri de TVA",
              DecLine."Tip Partener"::"4-Fara CUI valid din afara UE fara RO"])
            then begin
                case DecLine."Tip Operatie" of
                    DecLine."Tip Operatie"::L:
                        if CountRec then
                            InfoBuffer.Int05 += 1; //nrFacturiL_PF
                    DecLine."Tip Operatie"::LS:
                        begin
                            if CountRec then
                                InfoBuffer.Dec03 += 1; //nrFacturiLS_PF
                            InfoBuffer.Dec04 += DecLine.Base //val_LS_PF
                        end;
                end;
            end;
        InfoBuffer.Modify;
    end;

    local
    procedure UpdateInfo()
    var
        InsertRec: Boolean;
        VATPostingSetup: Record "VAT Posting Setup";
        DecLine: Record "SSA Domestic Declaration Line";
    begin

        //UpdateInfo
        InfoBuffer.Get(1, 0, '', '');
        DecLine.SetRange("Domestic Declaration Code", InfoBuffer.Code1);
        DecLine.SetFilter("Unrealized VAT Entry No.", '<>%1', 0);
        if DecLine.FindSet then
            repeat

                VATPostingSetup.Get(DecLine."VAT Bus. Posting Group", DecLine."VAT Prod. Posting Group");
                if DecLine.Type = DecLine.Type::Purchase then begin
                    if not VATPostingSetup."SSA VAT to pay" then begin
                        if SSASetup."Sistem TVA" = SSASetup."Sistem TVA"::"Sistem de TVA la Incasare" then //calcul tvaDed
                            case VATPostingSetup."SSA Journals VAT %" of
                                24:
                                    InfoBuffer.Dec05 += DecLine.Amount; //tvaDed24
                                20:
                                    InfoBuffer.Dec06 += DecLine.Amount; //tvaDed20
                                19:
                                    InfoBuffer.Dec18 += DecLine.Amount; //tvaDed19
                                9:
                                    InfoBuffer.Dec07 += DecLine.Amount; //tvaDed9
                                5:
                                    InfoBuffer.Dec08 += DecLine.Amount; //tvaDed5
                            end
                    end else
                        case VATPostingSetup."SSA Journals VAT %" of
                            24:
                                InfoBuffer.Dec09 += DecLine.Amount; //tvaDedAI24
                            20:
                                InfoBuffer.Dec10 += DecLine.Amount; //tvaDedAI20
                            19:
                                InfoBuffer.Dec17 += DecLine.Amount; //tvaDedAI19
                            9:
                                InfoBuffer.Dec11 += DecLine.Amount; //tvaDedAI9
                            5:
                                InfoBuffer.Dec12 += DecLine.Amount; //tvaDedAI5
                        end
                end else
                    if DecLine.Type = DecLine.Type::Sale then begin
                        if VATPostingSetup."SSA VAT to pay" then
                            if SSASetup."Sistem TVA" = SSASetup."Sistem TVA"::"Sistem de TVA la Incasare" then //calcul tvaCol
                                case VATPostingSetup."SSA Journals VAT %" of
                                    24:
                                        InfoBuffer.Dec13 += -DecLine.Amount; //tvaCol24
                                    20:
                                        InfoBuffer.Dec14 += -DecLine.Amount; //tvaCol20
                                    19:
                                        InfoBuffer.Dec19 += -DecLine.Amount; //tvaCol19
                                    9:
                                        InfoBuffer.Dec15 += -DecLine.Amount; //tvaCol9
                                    5:
                                        InfoBuffer.Dec16 += -DecLine.Amount; //tvaCol5
                                end

                    end;
            until DecLine.Next = 0;

        InfoBuffer.Modify;
    end;

    local
    procedure UpdateRezumate()
    var
        DecLine: Record "SSA Domestic Declaration Line";
        TaxGroupCode: Code[20];
    begin

        NrFactCountBuff.Reset;

        OpBuffer.Reset;
        if OpBuffer.FindSet then
            repeat
                NrFactCountBuff.SetRange(Pk1, OpBuffer.Pk1);
                NrFactCountBuff.SetRange(Pk2, OpBuffer.Pk2);
                if OpBuffer.Int01 <> "SSA Domestic Declaration Line"."Tip Partener"::
            "1-CUI Valid din RO si din afara inreg. in scopuri de TVA in RO" then //ma 24.08.16
                    NrFactCountBuff.SetRange(Pk3, OpBuffer.PK4)
                else
                    NrFactCountBuff.SetRange(Pk3, OpBuffer.Pk3);
                OpBuffer.Int03 := NrFactCountBuff.Count;

                //Rezumat1 Buffer
                InserRezumat1Buffer(OpBuffer.Int01, OpBuffer.Dec01, OpBuffer.Text03, OpBuffer.Text04, Round(OpBuffer.Dec02, 1), Round(OpBuffer.Dec03, 1), OpBuffer.Int03);

                //Rezumat1 Detaliu

                Op11Buffer.Reset;
                Op11Buffer.SetRange(Pk1, OpBuffer.Pk1);
                Op11Buffer.SetRange(Pk2, OpBuffer.Pk2);
                if OpBuffer.Int01 <> "SSA Domestic Declaration Line"."Tip Partener"::
            "1-CUI Valid din RO si din afara inreg. in scopuri de TVA in RO" then
                    Op11Buffer.SetRange(Pk3, OpBuffer.PK4)
                else
                    Op11Buffer.SetRange(Pk3, OpBuffer.Pk3);
                if Op11Buffer.FindSet then
                    repeat
                        TaxGroupCode := Op11Buffer.PK4;
                        if StrLen(TaxGroupCode) > 3 then
                            TaxGroupCode := '21';

                        InsertDetaliuBuffer(OpBuffer.Int01, OpBuffer.Dec01, OpBuffer.Text03, OpBuffer.Text04, TaxGroupCode, Round(Op11Buffer.Dec01, 1),
                          Round(Op11Buffer.Dec02, 1), Op11Buffer.Int01);

                    until Op11Buffer.Next = 0;

                //Update Rezumat2 OP1
                InsertRezumat2Buffer(OpBuffer.Int01, OpBuffer.Dec01, OpBuffer.Text03, OpBuffer.Text04, Round(OpBuffer.Dec02, 1), Round(OpBuffer.Dec03, 1), OpBuffer.Int03)

            until OpBuffer.Next = 0;

        InsertRezumat2Buffer(2, 5, 'L', 'Bon Fiscal', 0, 0, 0);
        InsertRezumat2Buffer(2, 9, 'L', 'Bon Fiscal', 0, 0, 0);
        InsertRezumat2Buffer(2, 20, 'L', 'Bon Fiscal', 0, 0, 0);
        InsertRezumat2Buffer(2, 19, 'L', 'Bon Fiscal', 0, 0, 0);

        DecLine.Reset;
        DecLine.SetRange("Domestic Declaration Code", DomesticDeclarations.Code);
        DecLine.SetFilter("Tip Operatie", '%1|%2|%3|%4|%5', DecLine."Tip Operatie"::A, DecLine."Tip Operatie"::AI,
        DecLine."Tip Operatie"::L, DecLine."Tip Operatie"::LS, DecLine."Tip Operatie"::V);
        DecLine.SetFilter("Tip Document D394", '%1|%2', DecLine."Tip Document D394"::"Factura Simplificata", DecLine."Tip Document D394"::
          "Bon Fiscal");
        DecLine.SetFilter("Unrealized VAT Entry No.", '%1', 0); //HD683
        if DecLine.FindSet then
            repeat
                InsertRezumat2Buffer(DecLine."Tip Partener", DecLine.Cota, Format(DecLine."Tip Operatie"), Format(DecLine."Tip Document D394"),
                  DecLine.Base, DecLine.Amount, 0)
            until DecLine.Next = 0;
    end;

    local
    procedure InsertListaCAENBuffer(DecLine: Record "SSA Domestic Declaration Line")
    var
        InsertRec: Boolean;
        InsertOp11: Boolean;
    begin
        //InsertListaCAENBuffer

        if DecLine."Cod CAEN" = '' then
            exit;

        Clear(InsertRec);

        if ListaBuffer.Get(DecLine."Tip Operatiune CAEN", DecLine.Cota, DecLine."Cod CAEN", '') then
            InsertRec := false
        else
            InsertRec := true;

        if InsertRec then begin
            ListaBuffer.Init;
            ListaBuffer.Pk1 := DecLine."Tip Operatiune CAEN";
            ListaBuffer.Pk2 := DecLine.Cota;
            ListaBuffer.Pk3 := DecLine."Cod CAEN";
        end;

        ListaBuffer.Dec01 += DecLine.Base;
        ListaBuffer.Dec02 += DecLine.Amount;

        if InsertRec then
            ListaBuffer.Insert
        else
            ListaBuffer.Modify;
    end;

    local
    procedure InsertFacturiBuffer(DecLine: Record "SSA Domestic Declaration Line")
    var
        InsertRec: Boolean;
    begin
        //InsertFacturiBuffer

        if DecLine."Stare Factura" = DecLine."Stare Factura"::"0-Factura Emisa" then
            exit;

        FacturiBuffer.Init;
        FacturiBuffer.TransferFields(DecLine);
        FacturiBuffer.Insert;
    end;

    local
    procedure InsertOpBuffer(DecLine: Record "SSA Domestic Declaration Line")
    var
        InsertRec: Boolean;
        InsertOp11: Boolean;
        SkipCount: Boolean;
    begin
        //InsertOpBuffer
        //Skip Facturi Simplificate
        if DecLine."Tip Document D394" in [DecLine."Tip Document D394"::"Bon Fiscal", DecLine."Tip Document D394"::"Factura Simplificata"] then
            exit;

        Clear(InsertRec);

        if DecLine."Tip Partener" <> DecLine."Tip Partener"::"1-CUI Valid din RO si din afara inreg. in scopuri de TVA in RO" then begin
            if OpBuffer.Get(DecLine."Tip Operatie", DecLine.Cota, GetVATNo(DecLine."VAT Registration No."), DecLine."Bill-to/Pay-to No.") then
                InsertRec := false
            else
                InsertRec := true;
        end else begin
            if OpBuffer.Get(DecLine."Tip Operatie", DecLine.Cota, GetVATNo(DecLine."VAT Registration No."), '') then
                InsertRec := false
            else
                InsertRec := true;
        end;

        if InsertRec then begin
            OpBuffer.Init;
            OpBuffer.Pk1 := DecLine."Tip Operatie";
            OpBuffer.Pk2 := DecLine.Cota;
            OpBuffer.Pk3 := GetVATNo(DecLine."VAT Registration No.");
            if DecLine."Tip Partener" <> DecLine."Tip Partener"::"1-CUI Valid din RO si din afara inreg. in scopuri de TVA in RO" then
                OpBuffer.PK4 := DecLine."Bill-to/Pay-to No."
            else
                OpBuffer.PK4 := '';
        end;
        CountFacturi(DecLine);

        OpBuffer.Int01 := DecLine."Tip Partener";
        OpBuffer.Dec01 := DecLine.Cota;
        OpBuffer.Text01 := DecLine."Vendor/Customer Name";
        OpBuffer.Text02 := DecLine."Cod tara D394";
        OpBuffer.Text03 := Format(DecLine."Tip Operatie");
        OpBuffer.Text04 := Format(DecLine."Tip Document D394");

        OpBuffer.Int02 := DecLine."Cod Judet D394";
        OpBuffer.Dec02 += DecLine.Base; //baza
        OpBuffer.Dec03 += DecLine.Amount; //tva

        OpBuffer.Int04 := Date2DMY(DecLine."Posting Date", 2);//luna

        if DecLine.Cota = 20 then begin
            OpBuffer.Dec06 += DecLine.Base;
            OpBuffer.Dec07 += DecLine.Amount;
        end;

        if DecLine.Cota = 9 then begin
            OpBuffer.Dec08 += DecLine.Base;
            OpBuffer.Dec09 += DecLine.Amount;
        end;

        if DecLine.Cota = 5 then begin
            OpBuffer.Dec10 += DecLine.Base;
            OpBuffer.Dec11 += DecLine.Amount;
        end;

        if DecLine.Cota = 19 then begin
            OpBuffer.Dec12 += DecLine.Base;
            OpBuffer.Dec13 += DecLine.Amount;
        end;

        if DecLine.Cota = 24 then begin
            OpBuffer.Dec14 += DecLine.Base;
            OpBuffer.Dec15 += DecLine.Amount;
        end;

        if InsertRec then
            OpBuffer.Insert
        else
            OpBuffer.Modify;

        //OP11
        if ((DecLine."Tip Partener" = DecLine."Tip Partener"::"1-CUI Valid din RO si din afara inreg. in scopuri de TVA in RO") and
        (OpBuffer.Text03 in ['V', 'C'])) or
          ((DecLine."Tip Partener" = DecLine."Tip Partener"::"2-CNP PFA din RO sau CUI neinregistrat in scopuri de TVA") and
          (OpBuffer.Text03 = 'N'))
        then
            if DecLine."Tax Group Code" <> '' then begin
                Clear(InsertOp11);
                if (DecLine."Tip Partener" <> DecLine."Tip Partener"::"1-CUI Valid din RO si din afara inreg. in scopuri de TVA in RO")
                then begin
                    if Op11Buffer.Get(DecLine."Tip Operatie", DecLine.Cota, DecLine."Bill-to/Pay-to No.", DecLine."Tax Group Code") then
                        InsertOp11 := false
                    else
                        InsertOp11 := true;
                end else begin
                    if Op11Buffer.Get(DecLine."Tip Operatie", DecLine.Cota, GetVATNo(DecLine."VAT Registration No."), DecLine."Tax Group Code")
            then
                        InsertOp11 := false
                    else
                        InsertOp11 := true;
                end;

                if InsertOp11 then begin
                    Op11Buffer.Init;
                    Op11Buffer.Pk1 := DecLine."Tip Operatie";
                    Op11Buffer.Pk2 := DecLine.Cota;
                    if (DecLine."Tip Partener" <> DecLine."Tip Partener"::"1-CUI Valid din RO si din afara inreg. in scopuri de TVA in RO")
                    then
                        Op11Buffer.Pk3 := DecLine."Bill-to/Pay-to No."
                    else
                        Op11Buffer.Pk3 := GetVATNo(DecLine."VAT Registration No.");
                    Op11Buffer.PK4 := DecLine."Tax Group Code";
                end;
                Op11Buffer.Int01 += 1; //nr facturi pr
                Op11Buffer.Dec01 += DecLine.Base; //bazapr
                Op11Buffer.Dec02 += DecLine.Amount; //tvapr

                if InsertOp11 then
                    Op11Buffer.Insert
                else
                    Op11Buffer.Modify;
            end;
    end;

    local
    procedure InsertOp2Buffer()
    var
        DecLine: Record "SSA Domestic Declaration Line";
        Luna: Integer;
        InsertRec: Boolean;
    begin
        Clear(InsertRec);

        DecLine.Reset;
        DecLine.SetRange("Domestic Declaration Code", DomesticDeclarations.Code);
        DecLine.SetFilter("Tip Operatie", '%1|%2|%3', DecLine."Tip Operatie"::L,
          "SSA Domestic Declaration Line"."Tip Operatie"::LS, DecLine."Tip Operatie"::V);
        DecLine.SetFilter("Tip Document D394", '%1|%2', DecLine."Tip Document D394"::"Factura Simplificata", DecLine."Tip Document D394"::
        "Bon Fiscal");
        if DecLine.FindSet then
            repeat
                Luna := Date2DMY(DecLine."Posting Date", 2);
                if Op2Buffer.Get(Luna) then //Luna
                    InsertRec := false
                else
                    InsertRec := true;

                if InsertRec then begin
                    Op2Buffer.Init;
                    Op2Buffer.Pk1 := Luna;
                    Op2Buffer.Dec01 := 0;
                end;

                CountBF(DecLine);
                NrBFCount.Reset;
                NrBFCount.SetFilter(Pk1, '%1|%2|%3', DecLine."Tip Operatie"::L, DecLine."Tip Operatie"::LS, DecLine."Tip Operatie"::V);
                NrBFCount.SetFilter(Text04, '%1|%2', 'Bon Fiscal', 'Factura Simplificata');
                NrBFCount.SetRange(Int04, Op2Buffer.Pk1);

                Op2Buffer.Code1 := Format(DecLine."Tip Operatie");
                Op2Buffer.Int01 := NrBFCount.Count; //nr bonuri fiscale
                Op2Buffer.Dec01 += DecLine.Base + DecLine.Amount; //baza //total incasari
                case DecLine.Cota of //cota
                    20:
                        begin
                            Op2Buffer.Dec02 += DecLine.Base; //baza 20
                            Op2Buffer.Dec03 += DecLine.Amount; //TVA 20
                        end;
                    9:
                        begin
                            Op2Buffer.Dec04 += DecLine.Base; //baza 9
                            Op2Buffer.Dec05 += DecLine.Amount; //tva 9
                        end;
                    5:
                        begin
                            Op2Buffer.Dec06 += DecLine.Base; //baza 5
                            Op2Buffer.Dec07 += DecLine.Amount; //TVA 5
                        end;
                    19:
                        begin
                            Op2Buffer.Dec08 += DecLine.Base; //baza 19
                            Op2Buffer.Dec09 += DecLine.Amount; //TVA 19
                        end;
                    24:
                        begin
                            Op2Buffer.Dec10 += DecLine.Base; //baza 24
                            Op2Buffer.Dec11 += DecLine.Amount; //TVA 24
                        end;
                end;
                if InsertRec then
                    Op2Buffer.Insert
                else
                    Op2Buffer.Modify;

            until DecLine.Next = 0;
    end;

    local
    procedure WriteR1BuffertoXML()
    begin
        //WriteR1BuffertoXML
        R1Buffer.Reset;
        if R1Buffer.FindSet then
            repeat
                //L
                AddElement(StringLine, 'rezumat1');
                AddAttribute(StringLine, 'tip_partener', Format(R1Buffer.Pk1));
                AddAttribute(StringLine, 'cota', Format(R1Buffer.Pk2));

                if R1Buffer.Pk2 <> 0 then begin
                    AddAttribute(StringLine, 'facturiL', Format(Round(R1Buffer.Dec01, 1), 0, 1));
                    AddAttribute(StringLine, 'bazaL', Format(Round(-R1Buffer.Dec02, 1), 0, 1));
                    AddAttribute(StringLine, 'tvaL', Format(Round(-R1Buffer.Dec03, 1), 0, 1));
                end;

                if (R1Buffer.Pk2 = 0) and (GetTxtDocType(R1Buffer.Pk3) in ['1', '']) then begin
                    AddAttribute(StringLine, 'facturiLS', Format(Round(R1Buffer.Dec04, 1), 0, 1));
                    AddAttribute(StringLine, 'bazaLS', Format(Round(-R1Buffer.Dec05, 1), 0, 1));
                end;

                if ((R1Buffer.Pk1 = 1) and (R1Buffer.Pk2 <> 0)) then begin
                    AddAttribute(StringLine, 'facturiA', Format(Round(R1Buffer.Dec07, 1), 0, 1));
                    AddAttribute(StringLine, 'bazaA', Format(Round(R1Buffer.Dec08, 1), 0, 1));
                    AddAttribute(StringLine, 'tvaA', Format(Round(R1Buffer.Dec09, 1), 0, 1));
                end;
                if ((R1Buffer.Pk1 = 1) and (R1Buffer.Pk2 <> 0)) then begin
                    AddAttribute(StringLine, 'facturiAI', Format(Round(R1Buffer.Dec10, 1), 0, 1));
                    AddAttribute(StringLine, 'bazaAI', Format(Round(R1Buffer.Dec11, 1), 0, 1));
                    AddAttribute(StringLine, 'tvaAI', Format(Round(R1Buffer.Dec12, 1), 0, 1));
                end;
                if ((R1Buffer.Pk1 = 1) and (R1Buffer.Pk2 = 0)) then begin
                    AddAttribute(StringLine, 'facturiV', Format(Round(R1Buffer.Dec19, 1), 0, 1));
                    AddAttribute(StringLine, 'bazaV', Format(Round(-R1Buffer.Dec20, 1), 0, 1));
                end;

                if (R1Buffer.Pk1 = 1) and (R1Buffer.Pk2 = 0) then begin
                    AddAttribute(StringLine, 'facturiAS', Format(Round(R1Buffer.Dec13, 1), 0, 1));
                    AddAttribute(StringLine, 'bazaAS', Format(Round(R1Buffer.Dec14, 1), 0, 1));
                end;

                if (R1Buffer.Pk1 in [1, 3, 4]) and (R1Buffer.Pk2 <> 0) then begin
                    AddAttribute(StringLine, 'facturiC', Format(Round(R1Buffer.Dec22, 1), 0, 1));
                    AddAttribute(StringLine, 'bazaC', Format(Round(R1Buffer.Dec23, 1), 0, 1));
                    AddAttribute(StringLine, 'tvaC', Format(Round(R1Buffer.Dec24, 1), 0, 1));
                end;

                //N section
                if (R1Buffer.Pk1 = 2) and (R1Buffer.Pk2 = 0) then begin
                    AddAttribute(StringLine, 'facturiN', Format(Round(R1Buffer.Dec25, 1), 0, 1));
                    if GetTxtDocType(R1Buffer.Pk3) = '' then
                        AddAttribute(StringLine, 'document_N', '1')
                    else
                        AddAttribute(StringLine, 'document_N', GetTxtDocType(R1Buffer.Pk3));
                    AddAttribute(StringLine, 'bazaN', Format(Round(R1Buffer.Dec26, 1), 0, 1));
                end;

                WriteLine(StringLine);
                Clear(StringLine);
                //detalii daca este cazul
                WriteR1DetailXML(R1Buffer.Pk1, R1Buffer.Pk2, R1Buffer.Pk3);
                WriteLine('</rezumat1>');
            until R1Buffer.Next = 0;
    end;

    local
    procedure WriteR1DetailXML(_TipPartener: Option " ","1-CUI Valid din RO si din afara inreg. in scopuri de TVA in RO","2-CNP PFA din RO sau CUI neinregistrat in scopuri de TVA","3-fara CUI valid din UE fara RO","4-Fara CUI valid din afara UE fara RO"; _Cota: Decimal; _TipDocument: Code[20])
    begin
        //WriteR1DetailXML
        R1Detaliu.Reset;
        R1Detaliu.SetRange(Pk1, _TipPartener);
        R1Detaliu.SetRange(Pk2, _Cota);
        if (_TipPartener = 2) and (_Cota = 0) then
            R1Detaliu.SetRange(PK4, _TipDocument);
        if R1Detaliu.FindSet then
            repeat
                AddElement(StringLine, 'detaliu');
                AddAttribute(StringLine, 'bun', R1Detaliu.Pk3);
                if (R1Detaliu.Pk1 = 1) and (R1Detaliu.Pk2 = 0) then begin
                    AddAttribute(StringLine, 'nrLivV', Format(Round(R1Detaliu.Dec19, 1), 0, 1));
                    AddAttribute(StringLine, 'bazaLivV', Format(Round(-R1Detaliu.Dec20, 1), 0, 1));
                end;

                if (R1Detaliu.Pk1 = 1) and (R1Detaliu.Pk2 <> 0) then begin
                    AddAttribute(StringLine, 'nrAchizC', Format(Round(R1Detaliu.Dec22, 1), 0, 1));
                    AddAttribute(StringLine, 'bazaAchizC', Format(Round(R1Detaliu.Dec23, 1), 0, 1));
                    AddAttribute(StringLine, 'tvaAchizC', Format(Round(R1Detaliu.Dec24, 1), 0, 1));
                end;

                if R1Detaliu.Pk1 = 2 then begin
                    AddAttribute(StringLine, 'nrN', Format(Round(R1Detaliu.Dec25, 1), 0, 1));
                    AddAttribute(StringLine, 'valN', Format(Round(R1Detaliu.Dec26, 1), 0, 1));
                end;
                WriteLine(StringLine);
                Clear(StringLine);

                WriteLine('</detaliu>');
            until R1Detaliu.Next = 0;
    end;

    local
    procedure WriteR2BuffertoXML()
    begin
        //WriteR2BuffertoXML
        R2Buffer.Reset;
        if R2Buffer.FindSet then
            repeat
                AddElement(StringLine, 'rezumat2');
                AddAttribute(StringLine, 'cota', Format(R2Buffer.Pk2));
                AddAttribute(StringLine, 'bazaFSLcod', Format(Round(-R2Buffer.Dec02, 1), 0, 1));
                AddAttribute(StringLine, 'TVAFSLcod', Format(Round(-R2Buffer.Dec03, 1), 0, 1));

                AddAttribute(StringLine, 'bazaFSL', Format(Round(-R2Buffer.Dec05, 1), 0, 1));
                AddAttribute(StringLine, 'TVAFSL', Format(Round(-R2Buffer.Dec06, 1), 0, 1));

                AddAttribute(StringLine, 'bazaFSA', Format(Round(R2Buffer.Dec08, 1), 0, 1));
                AddAttribute(StringLine, 'TVAFSA', Format(Round(R2Buffer.Dec09, 1), 0, 1));

                AddAttribute(StringLine, 'bazaFSAI', Format(Round(R2Buffer.Dec11, 1), 0, 1));
                AddAttribute(StringLine, 'TVAFSAI', Format(Round(R2Buffer.Dec12, 1), 0, 1));

                AddAttribute(StringLine, 'bazaBFAI', Format(Round(R2Buffer.Dec17, 1), 0, 1));
                AddAttribute(StringLine, 'TVABFAI', Format(Round(R2Buffer.Dec18, 1), 0, 1));

                AddAttribute(StringLine, 'nrFacturiL', Format(Round(R2Buffer.Dec19, 1), 0, 1));
                AddAttribute(StringLine, 'bazaL', Format(Round(-R2Buffer.Dec20, 1), 0, 1));
                AddAttribute(StringLine, 'tvaL', Format(Round(-R2Buffer.Dec21, 1), 0, 1));

                AddAttribute(StringLine, 'nrFacturiA', Format(Round(R2Buffer.Dec22, 1), 0, 1));
                AddAttribute(StringLine, 'bazaA', Format(Round(R2Buffer.Dec23, 1), 0, 1));
                AddAttribute(StringLine, 'tvaA', Format(Round(R2Buffer.Dec24, 1), 0, 1));

                AddAttribute(StringLine, 'nrFacturiAI', Format(Round(R2Buffer.Dec25, 1), 0, 1));
                AddAttribute(StringLine, 'bazaAI', Format(Round(R2Buffer.Dec26, 1), 0, 1));
                AddAttribute(StringLine, 'tvaAI', Format(Round(R2Buffer.Dec27, 1), 0, 1));

                AddAttribute(StringLine, 'baza_incasari_i1', Format(Round(-R2Buffer.Dec14, 1), 0, 1));
                AddAttribute(StringLine, 'tva_incasari_i1', Format(Round(-R2Buffer.Dec15, 1), 0, 1));

                AddAttribute(StringLine, 'baza_incasari_i2', Format(0));
                AddAttribute(StringLine, 'tva_incasari_i2', Format(0));

                AddAttribute(StringLine, 'bazaL_PF', Format(Round(-R2Buffer.Dec29, 1), 0, 1));
                AddAttribute(StringLine, 'tvaL_PF', Format(Round(-R2Buffer.Dec30, 1), 0, 1));

                WriteLine(StringLine);
                Clear(StringLine);

                WriteLine('</rezumat2>');
            until R2Buffer.Next = 0;
    end;

    local
    procedure WriteSerieFacturi()
    begin
        //WriteSerieFacturi
        //Export tip 1
        SerieBuffer.Reset;
        if SerieBuffer.FindSet then
            repeat
                if (SerieBuffer.Int01 <> 3) and (SerieBuffer.Int01 <> 4) then begin
                    AddElement(StringLine, 'serieFacturi');
                    AddAttribute(StringLine, 'tip', '1');
                    if SerieBuffer.Code1 = '' then
                        AddAttribute(StringLine, 'serieI', CopyStr(SerieBuffer.Code2, 1, 2))
                    else
                        AddAttribute(StringLine, 'serieI', SerieBuffer.Code1);
                    AddAttribute(StringLine, 'nrI', GetNoSeriesNoText(SerieBuffer.Code2));
                    AddAttribute(StringLine, 'nrF', GetNoSeriesNoText(SerieBuffer.Code3));

                    WriteLine(StringLine);
                    Clear(StringLine);
                    WriteLine('</serieFacturi>');

                    //nu scriem seria neutilizata
                    if SerieBuffer.Int02 <> 0 then begin
                        AddElement(StringLine, 'serieFacturi');
                        AddAttribute(StringLine, 'tip', '2');
                        if SerieBuffer.Code1 = '' then
                            AddAttribute(StringLine, 'serieI', CopyStr(SerieBuffer.Code2, 1, 2))
                        else
                            AddAttribute(StringLine, 'serieI', SerieBuffer.Code1);
                        AddAttribute(StringLine, 'nrI', SerieBuffer.Code4);
                        AddAttribute(StringLine, 'nrF', SerieBuffer.Code5);

                        WriteLine(StringLine);
                        Clear(StringLine);
                        WriteLine('</serieFacturi>');
                    end;
                end else begin
                    AddElement(StringLine, 'serieFacturi');
                    AddAttribute(StringLine, 'tip', Format(SerieBuffer.Int01));
                    if SerieBuffer.Code1 = '' then
                        AddAttribute(StringLine, 'serieI', CopyStr(SerieBuffer.Code2, 1, 2))
                    else
                        AddAttribute(StringLine, 'serieI', SerieBuffer.Code1);
                    AddAttribute(StringLine, 'nrI', SerieBuffer.Code4);
                    AddAttribute(StringLine, 'nrF', SerieBuffer.Code5);
                    AddAttribute(StringLine, 'den', ReplaceSpecialChar(SerieBuffer.Text01));
                    AddAttribute(StringLine, 'cui', SerieBuffer.Text02);

                    WriteLine(StringLine);
                    Clear(StringLine);
                    WriteLine('</serieFacturi>');

                end;

            until SerieBuffer.Next = 0;
    end;

    local
    procedure WriteInformatii()
    begin
        //WriteInformatii
        //Export tip 1
        InfoBuffer.Reset;
        if not InfoBuffer.FindFirst then
            exit;

        AddElement(StringLine, 'informatii');

        CountBuffer.Reset;
        CountBuffer.SetRange(Int01, 1);
        AddAttribute(StringLine, 'nrCui1', Format(CountBuffer.Count));

        OpBuffer.Reset;
        OpBuffer.SetRange(Int01, 2);
        AddAttribute(StringLine, 'nrCui2', Format(OpBuffer.Count));

        CountBuffer.SetRange(Int01, 3);
        AddAttribute(StringLine, 'nrCui3', Format(CountBuffer.Count));

        CountBuffer.SetRange(Int01, 4);
        AddAttribute(StringLine, 'nrCui4', Format(CountBuffer.Count));

        AddAttribute(StringLine, 'nr_BF_i1', Format(InfoBuffer.Int01));
        AddAttribute(StringLine, 'incasari_i1', Format(-Round(InfoBuffer.Dec01, 1), 0, 1));
        AddAttribute(StringLine, 'incasari_i2', '0');
        AddAttribute(StringLine, 'nrFacturi_terti', Format(InfoBuffer.Int02));
        AddAttribute(StringLine, 'nrFacturi_benef', Format(InfoBuffer.Int03));
        AddAttribute(StringLine, 'nrFacturi', Format(InfoBuffer.Int04));
        AddAttribute(StringLine, 'nrFacturiL_PF', Format(InfoBuffer.Int05));
        AddAttribute(StringLine, 'nrFacturiLS_PF', Format(Round(InfoBuffer.Dec03, 1), 0, 1));
        AddAttribute(StringLine, 'val_LS_PF', Format(Round(-InfoBuffer.Dec04, 1), 0, 1));

        if SSASetup."Sistem TVA" = SSASetup."Sistem TVA"::"Sistem de TVA la Incasare" then begin
            AddAttribute(StringLine, 'tvaDed24', Format(Round(InfoBuffer.Dec05, 1), 0, 1));
            AddAttribute(StringLine, 'tvaDed20', Format(Round(InfoBuffer.Dec06, 1), 0, 1));
            AddAttribute(StringLine, 'tvaDed19', Format(Round(InfoBuffer.Dec18, 1), 0, 1));
            AddAttribute(StringLine, 'tvaDed9', Format(Round(InfoBuffer.Dec07, 1), 0, 1));
            AddAttribute(StringLine, 'tvaDed5', Format(Round(InfoBuffer.Dec08, 1), 0, 1));
            AddAttribute(StringLine, 'tvaCol24', Format(Round(InfoBuffer.Dec13, 1), 0, 1));
            AddAttribute(StringLine, 'tvaCol20', Format(Round(InfoBuffer.Dec14, 1), 0, 1));
            AddAttribute(StringLine, 'tvaCol19', Format(Round(InfoBuffer.Dec19, 1), 0, 1));
            AddAttribute(StringLine, 'tvaCol9', Format(Round(InfoBuffer.Dec15, 1), 0, 1));
            AddAttribute(StringLine, 'tvaCol5', Format(Round(InfoBuffer.Dec16, 1), 0, 1));
        end;

        AddAttribute(StringLine, 'tvaDedAI24', Format(Round(InfoBuffer.Dec09, 1), 0, 1));
        AddAttribute(StringLine, 'tvaDedAI20', Format(Round(InfoBuffer.Dec10, 1), 0, 1));
        AddAttribute(StringLine, 'tvaDedAI19', Format(Round(InfoBuffer.Dec17, 1), 0, 1));
        AddAttribute(StringLine, 'tvaDedAI9', Format(Round(InfoBuffer.Dec11, 1), 0, 1));
        AddAttribute(StringLine, 'tvaDedAI5', Format(Round(InfoBuffer.Dec12, 1), 0, 1));

        //solicit;
        if DomesticDeclarations.Solicit then begin
            AddAttribute(StringLine, 'solicit', '1');
            AddAttribute(StringLine, 'achizitiiPE', GetBoolText(DomesticDeclarations.AchizitiiPE));
            AddAttribute(StringLine, 'achizitiiCR', GetBoolText(DomesticDeclarations.AchizitiiCR));
            AddAttribute(StringLine, 'achizitiiCB', GetBoolText(DomesticDeclarations.AchizitiiCB));
            AddAttribute(StringLine, 'achizitiiCI', GetBoolText(DomesticDeclarations.AchizitiiCI));
            AddAttribute(StringLine, 'achizitiiA', GetBoolText(DomesticDeclarations.AchizitiiA));
            AddAttribute(StringLine, 'achizitiiB24', GetBoolText(DomesticDeclarations.AchizitiiB24));
            AddAttribute(StringLine, 'achizitiiB20', GetBoolText(DomesticDeclarations.AchizitiiB20));
            AddAttribute(StringLine, 'achizitiiB19', GetBoolText(DomesticDeclarations.AchizitiiB19));
            AddAttribute(StringLine, 'achizitiiB9', GetBoolText(DomesticDeclarations.AchizitiiB9));
            AddAttribute(StringLine, 'achizitiiB5', GetBoolText(DomesticDeclarations.AchizitiiB5));
            AddAttribute(StringLine, 'achizitiiS24', GetBoolText(DomesticDeclarations.AchizitiiS24));
            AddAttribute(StringLine, 'achizitiiS20', GetBoolText(DomesticDeclarations.AchizitiiS20));
            AddAttribute(StringLine, 'achizitiiS19', GetBoolText(DomesticDeclarations.AchizitiiS19));
            AddAttribute(StringLine, 'achizitiiS9', GetBoolText(DomesticDeclarations.AchizitiiS9));
            AddAttribute(StringLine, 'achizitiiS5', GetBoolText(DomesticDeclarations.AchizitiiS5));
            AddAttribute(StringLine, 'importB', GetBoolText(DomesticDeclarations.ImportB));
            AddAttribute(StringLine, 'acINecorp', GetBoolText(DomesticDeclarations.AcINecorp));
            AddAttribute(StringLine, 'livrariBI', GetBoolText(DomesticDeclarations.LivrariBI));
            AddAttribute(StringLine, 'BUN24', GetBoolText(DomesticDeclarations.Bun24));
            AddAttribute(StringLine, 'BUN20', GetBoolText(DomesticDeclarations.Bun20));
            AddAttribute(StringLine, 'BUN19', GetBoolText(DomesticDeclarations.Bun19));
            AddAttribute(StringLine, 'BUN9', GetBoolText(DomesticDeclarations.Bun9));
            AddAttribute(StringLine, 'BUN5', GetBoolText(DomesticDeclarations.Bun5));
            AddAttribute(StringLine, 'valoareScutit', GetBoolText(DomesticDeclarations.ValoareScutit));
            AddAttribute(StringLine, 'BunTI', GetBoolText(DomesticDeclarations.BunTI));
            AddAttribute(StringLine, 'Prest24', GetBoolText(DomesticDeclarations.Prest24));
            AddAttribute(StringLine, 'Prest20', GetBoolText(DomesticDeclarations.Prest20));
            AddAttribute(StringLine, 'Prest19', GetBoolText(DomesticDeclarations.Prest19));
            AddAttribute(StringLine, 'Prest9', GetBoolText(DomesticDeclarations.Prest9));
            AddAttribute(StringLine, 'Prest5', GetBoolText(DomesticDeclarations.Prest5));
            AddAttribute(StringLine, 'PrestScutit', GetBoolText(DomesticDeclarations.PrestScutit));
            AddAttribute(StringLine, 'LIntra', GetBoolText(DomesticDeclarations.LIntra));
            AddAttribute(StringLine, 'PrestIntra', GetBoolText(DomesticDeclarations.PrestIntra));
            AddAttribute(StringLine, 'Export', GetBoolText(DomesticDeclarations.Export));
            AddAttribute(StringLine, 'livINecorp', GetBoolText(DomesticDeclarations.LivNecorp));
            AddAttribute(StringLine, 'efectuat', GetBoolText(DomesticDeclarations.Efectuat));
        end else
            AddAttribute(StringLine, 'solicit', '0');

        WriteLine(StringLine);
        Clear(StringLine);
        WriteLine('</informatii>');
    end;

    local
    procedure WriteListaCAEN()
    begin
        //WriteListaCAEN
        //Export tip 1
        ListaBuffer.Reset;
        if not ListaBuffer.FindSet then
            exit;

        repeat
            AddElement(StringLine, 'lista');
            AddAttribute(StringLine, 'caen', ListaBuffer.Pk3);
            AddAttribute(StringLine, 'cota', Format(ListaBuffer.Pk2));
            AddAttribute(StringLine, 'operat', Format(ListaBuffer.Pk1));
            AddAttribute(StringLine, 'valoare', Format(Round(ListaBuffer.Dec01, 1), 0, 1));
            AddAttribute(StringLine, 'tva', Format(Round(ListaBuffer.Dec02, 1), 0, 1));
            WriteLine(StringLine);
            Clear(StringLine);
            WriteLine('</lista>');

        until ListaBuffer.Next = 0;
    end;

    local
    procedure WriteFacturi()
    begin

        //WriteFacturi
        FacturiBuffer.Reset;
        if not FacturiBuffer.FindSet then
            exit;

        repeat
            FacturiBuffer.SetRange("Document No.", FacturiBuffer."Document No.");

            AddElement(StringLine, 'facturi');
            case FacturiBuffer."Stare Factura" of
                FacturiBuffer."Stare Factura"::"1-Factura Stornata":
                    AddAttribute(StringLine, 'tip_factura', '1');
                FacturiBuffer."Stare Factura"::"2-Factura Anulata":
                    AddAttribute(StringLine, 'tip_factura', '2');
                FacturiBuffer."Stare Factura"::"3-Autofactura":
                    AddAttribute(StringLine, 'tip_factura', '3');
                FacturiBuffer."Stare Factura"::"4-In calidate de beneficiar in numele furnizorului":
                    AddAttribute(StringLine, 'tip_factura', '4');
                else
                    Error('Stare Factura %1 netratat', FacturiBuffer."Stare Factura");
            end;

            if GetNoSeriesCodeText(FacturiBuffer."Document No.") = '' then
                AddAttribute(StringLine, 'serie', CopyStr(FacturiBuffer."Document No.", 1, 2))
            else
                AddAttribute(StringLine, 'serie', GetNoSeriesCodeText(FacturiBuffer."Document No."));
            AddAttribute(StringLine, 'nr', GetNoSeriesNoText(FacturiBuffer."Document No."));

            if FacturiBuffer."Stare Factura" = FacturiBuffer."Stare Factura"::"3-Autofactura" then
                case FacturiBuffer.Cota of
                    24:
                        begin
                            AddAttribute(StringLine, 'baza24', Format(Round(FacturiBuffer.Base, 1), 0, 1));
                            AddAttribute(StringLine, 'tva24', Format(Round(FacturiBuffer.Base, 1), 0, 1));
                            AddAttribute(StringLine, 'baza20', '0');
                            AddAttribute(StringLine, 'tva20', '0');
                            AddAttribute(StringLine, 'baza19', '0');
                            AddAttribute(StringLine, 'tva19', '0');
                            AddAttribute(StringLine, 'baza9', '0');
                            AddAttribute(StringLine, 'tva9', '0');
                            AddAttribute(StringLine, 'baza5', '0');
                            AddAttribute(StringLine, 'tva5', '0');
                        end;
                    20:
                        begin
                            AddAttribute(StringLine, 'baza24', '0');
                            AddAttribute(StringLine, 'tva24', '0');
                            AddAttribute(StringLine, 'baza20', Format(Round(FacturiBuffer.Base, 1), 0, 1));
                            AddAttribute(StringLine, 'tva20', Format(Round(FacturiBuffer.Base, 1), 0, 1));
                            AddAttribute(StringLine, 'baza19', '0');
                            AddAttribute(StringLine, 'tva19', '0');
                            AddAttribute(StringLine, 'baza9', '0');
                            AddAttribute(StringLine, 'tva9', '0');
                            AddAttribute(StringLine, 'baza5', '0');
                            AddAttribute(StringLine, 'tva5', '0');

                        end;
                    19:
                        begin
                            AddAttribute(StringLine, 'baza24', '0');
                            AddAttribute(StringLine, 'tva24', '0');
                            AddAttribute(StringLine, 'baza20', '0');
                            AddAttribute(StringLine, 'tva20', '0');
                            AddAttribute(StringLine, 'baza19', Format(Round(FacturiBuffer.Base, 1), 0, 1));
                            AddAttribute(StringLine, 'tva19', Format(Round(FacturiBuffer.Base, 1), 0, 1));
                            AddAttribute(StringLine, 'baza9', '0');
                            AddAttribute(StringLine, 'tva9', '0');
                            AddAttribute(StringLine, 'baza5', '0');
                            AddAttribute(StringLine, 'tva5', '0');
                        end;
                    9:
                        begin
                            AddAttribute(StringLine, 'baza24', '0');
                            AddAttribute(StringLine, 'tva24', '0');
                            AddAttribute(StringLine, 'baza20', '0');
                            AddAttribute(StringLine, 'tva20', '0');
                            AddAttribute(StringLine, 'baza19', '0');
                            AddAttribute(StringLine, 'tva19', '0');
                            AddAttribute(StringLine, 'baza9', Format(Round(FacturiBuffer.Base, 1), 0, 1));
                            AddAttribute(StringLine, 'tva9', Format(Round(FacturiBuffer.Base, 1), 0, 1));
                            AddAttribute(StringLine, 'baza5', '0');
                            AddAttribute(StringLine, 'tva5', '0');
                        end;
                    5:
                        begin
                            AddAttribute(StringLine, 'baza24', '0');
                            AddAttribute(StringLine, 'tva24', '0');
                            AddAttribute(StringLine, 'baza20', '0');
                            AddAttribute(StringLine, 'tva20', '0');
                            AddAttribute(StringLine, 'baza19', '0');
                            AddAttribute(StringLine, 'tva19', '0');
                            AddAttribute(StringLine, 'baza9', '0');
                            AddAttribute(StringLine, 'tva9', '0');
                            AddAttribute(StringLine, 'baza5', Format(Round(FacturiBuffer.Base, 1), 0, 1));
                            AddAttribute(StringLine, 'tva5', Format(Round(FacturiBuffer.Base, 1), 0, 1));
                        end;

                end;
            WriteLine(StringLine);
            Clear(StringLine);
            WriteLine('</facturi>');

            FacturiBuffer.FindLast;
            FacturiBuffer.SetRange("Document No.");

        until FacturiBuffer.Next = 0;
    end;

    local
    procedure WriteOperatii()
    var
        CodJudet: Text[30];
    begin
        //WriteOperatii
        OpBuffer.Reset;
        if not OpBuffer.FindSet then
            exit;

        repeat
            //start op1
            AddElement(StringLine, 'op1');
            AddAttribute(StringLine, 'tip', OpBuffer.Text03);
            AddAttribute(StringLine, 'tip_partener', Format(OpBuffer.Int01));
            AddAttribute(StringLine, 'cota', Format(OpBuffer.Pk2));
            if CheckVATNo(OpBuffer.Pk3, OpBuffer.Int01) <> '' then
                AddAttribute(StringLine, 'cuiP', CheckVATNo(OpBuffer.Pk3, OpBuffer.Int01));

            AddAttribute(StringLine, 'denP', ReplaceSpecialChar(OpBuffer.Text01));
            if (OpBuffer.Int01 = 2) and (CheckVATNo(OpBuffer.Pk3, OpBuffer.Int01) = '') then begin
                AddAttribute(StringLine, 'taraP', OpBuffer.Text02);
                CodJudet := Format(OpBuffer.Int02);
                if (StrLen(CodJudet) < 2) and (CodJudet <> '0') then
                    CodJudet := '0' + CodJudet;
                AddAttribute(StringLine, 'judP', CodJudet);
            end;

            if (OpBuffer.Int01 = 2) and (OpBuffer.Text03 = 'N') then
                AddAttribute(StringLine, 'tip_document', GetTxtDocType(OpBuffer.Text04));

            NrFactCountBuff.Reset;
            NrFactCountBuff.SetRange(Pk1, OpBuffer.Pk1);
            NrFactCountBuff.SetRange(Pk2, OpBuffer.Pk2);
            if OpBuffer.Int01 <> "SSA Domestic Declaration Line"."Tip Partener"::
        "1-CUI Valid din RO si din afara inreg. in scopuri de TVA in RO" then
                NrFactCountBuff.SetRange(Pk3, OpBuffer.PK4)
            else
                NrFactCountBuff.SetRange(Pk3, OpBuffer.Pk3);

            AddAttribute(StringLine, 'nrFact', Format(NrFactCountBuff.Count));

            if OpBuffer.Text03 in ['L', 'LS', 'V'] then
                AddAttribute(StringLine, 'baza', Format(Round(-OpBuffer.Dec02, 1), 0, 1))
            else
                AddAttribute(StringLine, 'baza', Format(Round(OpBuffer.Dec02, 1), 0, 1));
            if OpBuffer.Text03 in ['L', 'C', 'A', 'AI'] then begin
                if OpBuffer.Text03 in ['L', 'LS', 'V'] then
                    AddAttribute(StringLine, 'tva', Format(Round(-OpBuffer.Dec03, 1), 0, 1))
                else
                    AddAttribute(StringLine, 'tva', Format(Round(OpBuffer.Dec03, 1), 0, 1));
            end;

            WriteLine(StringLine);
            Clear(StringLine);
            //end op1

            Op11Buffer.Reset;
            Op11Buffer.SetRange(Pk1, OpBuffer.Pk1);
            Op11Buffer.SetRange(Pk2, OpBuffer.Pk2);
            if OpBuffer.Int01 <> "SSA Domestic Declaration Line"."Tip Partener"::
        "1-CUI Valid din RO si din afara inreg. in scopuri de TVA in RO" then
                Op11Buffer.SetRange(Pk3, OpBuffer.PK4)
            else
                Op11Buffer.SetRange(Pk3, OpBuffer.Pk3);
            if Op11Buffer.FindSet then
                repeat
                    AddElement(StringLine, 'op11');
                    AddAttribute(StringLine, 'codPR', Op11Buffer.PK4);
                    AddAttribute(StringLine, 'nrFactPR', Format(Op11Buffer.Int01));

                    if OpBuffer.Text03 in ['L', 'LS', 'V'] then begin
                        AddAttribute(StringLine, 'bazaPR', Format(Round(-Op11Buffer.Dec01, 1), 0, 1));
                        if (OpBuffer.Int01 <> 2) then
                            if (OpBuffer.Text03 <> 'V') then
                                AddAttribute(StringLine, 'tvaPR', Format(Round(-Op11Buffer.Dec02, 1), 0, 1));
                    end else begin
                        AddAttribute(StringLine, 'bazaPR', Format(Round(Op11Buffer.Dec01, 1), 0, 1));
                        if (OpBuffer.Int01 <> 2) then
                            AddAttribute(StringLine, 'tvaPR', Format(Round(Op11Buffer.Dec02, 1), 0, 1));
                    end;

                    WriteLine(StringLine);
                    Clear(StringLine);
                    WriteLine('</op11>');
                until Op11Buffer.Next = 0;

            WriteLine('</op1>');

        until OpBuffer.Next = 0;
    end;

    local
    procedure WriteOp2()
    begin

        Op2Buffer.Reset;
        if not Op2Buffer.FindSet then
            exit;

        repeat
            AddElement(StringLine, 'op2');
            AddAttribute(StringLine, 'tip_op2', 'I1');
            AddAttribute(StringLine, 'luna', Format(Op2Buffer.Pk1));
            AddAttribute(StringLine, 'nrAMEF', Format(DomesticDeclarations."Nr de AMEF"));
            AddAttribute(StringLine, 'nrBF', Format(Op2Buffer.Int01));
            AddAttribute(StringLine, 'total', Format(Round(-Op2Buffer.Dec01, 1), 0, 1));
            AddAttribute(StringLine, 'baza20', Format(Round(-Op2Buffer.Dec02, 1), 0, 1));
            AddAttribute(StringLine, 'baza9', Format(Round(-Op2Buffer.Dec04, 1), 0, 1));
            AddAttribute(StringLine, 'baza5', Format(Round(-Op2Buffer.Dec06, 1), 0, 1));
            AddAttribute(StringLine, 'TVA20', Format(Round(-Op2Buffer.Dec03, 1), 0, 1));
            AddAttribute(StringLine, 'TVA9', Format(Round(-Op2Buffer.Dec05, 1), 0, 1));
            AddAttribute(StringLine, 'TVA5', Format(Round(-Op2Buffer.Dec07, 1), 0, 1));
            AddAttribute(StringLine, 'baza19', Format(Round(-Op2Buffer.Dec08, 1), 0, 1));
            AddAttribute(StringLine, 'TVA19', Format(Round(-Op2Buffer.Dec09, 1), 0, 1));
            WriteLine(StringLine);
            Clear(StringLine);
            WriteLine('</op2>');

        until Op2Buffer.Next = 0;
    end;

    local
    procedure CalcTotalA()
    var
        InsertRec: Boolean;
    begin
        OpBuffer.Reset;
        if OpBuffer.FindSet then
            repeat
                InsertRec := false;
                if OpBuffer.Pk3 <> '' then begin
                    if not CountBuffer.Get(0, 0, OpBuffer.Pk3, '') then begin
                        InsertRec := true;
                        CountBuffer.Init;
                        CountBuffer.Pk1 := 0;
                        CountBuffer.Pk2 := 0;
                        CountBuffer.Pk3 := OpBuffer.Pk3; //VAT Reg No
                        CountBuffer.PK4 := '';
                    end;
                end else begin
                    if not CountBuffer.Get(0, 0, OpBuffer.Pk3, OpBuffer.PK4) then begin
                        InsertRec := true;
                        CountBuffer.Init;
                        CountBuffer.Pk3 := OpBuffer.Pk3; //VAT Reg No
                        CountBuffer.PK4 := OpBuffer.PK4; //Partener No.
                    end;
                end;

                if InsertRec then begin
                    CountBuffer.Int01 := OpBuffer.Int01;
                    CountBuffer.Insert;
                end;
            until OpBuffer.Next = 0;

        Clear(TotalPlataA);
        CountBuffer.Reset;
        CountBuffer.SetRange(Int01, 1);
        TotalPlataA += CountBuffer.Count;

        OpBuffer.Reset;
        OpBuffer.SetRange(Int01, 2);
        TotalPlataA += OpBuffer.Count;
        CountBuffer.SetRange(Int01, 3);
        TotalPlataA += CountBuffer.Count;
        CountBuffer.SetRange(Int01, 4);
        TotalPlataA += CountBuffer.Count;

        R2Buffer.Reset;
        if R2Buffer.FindSet then
            repeat

                TotalPlataA += Round(-R2Buffer.Dec20, 1) + Round(R2Buffer.Dec23, 1) + Round(R2Buffer.Dec26, 1);

            until R2Buffer.Next = 0;
    end;

    local
    procedure ExportTempToTextFile(var _Intemp: Record "SSA D394 Buffer" temporary)
    var
        TempBlob: Codeunit "Temp Blob";
        OutStr: Outstream;
        InStr: InStream;
        FileName: Text;
    begin
        TempBlob.CreateOutStream(OutStr);
        OutStr.WriteText('Tip Operatie' + ';' + 'Cota' + ';' + 'Nr. Partener' + ';' + 'Document No.' + ';' + 'Total' + ';' + 'Tip D394' + ';' + 'Tip Partener');
        if _Intemp.FindSet then
            repeat
                OutStr.WriteText(Format(_Intemp.Pk1) + ';' + Format(_Intemp.Pk2) + ';' + _Intemp.Pk3 + ';' + _Intemp.PK4 + ';' + Format(_Intemp.Dec02) + ';' + _Intemp.Text04 + ';' + Format(_Intemp.Int01));
            until _Intemp.Next = 0;
        TempBlob.CreateInStream(InStr);
        DownloadFromStream(InStr, Text001, '', '', FileName);
    end;

    local
    procedure UpdateSerieBuffer()
    var
        NoSeries: Record "No. Series";
    begin
        NoSeries.Reset;
        NoSeries.SetRange("SSA Export D394", true);
        if NoSeries.FindSet then
            repeat
                if not SerieBuffer.Get(0, 0, NoSeries.Code, '') then
                    InsertNoSeriesBuffer(DomesticDeclarations.Code, NoSeries.Code, DomesticDeclarations."Ending Date");
            until NoSeries.Next = 0;
    end;

    local
    procedure CountFacturi(_DecLine: Record "SSA Domestic Declaration Line")
    var
        SkipCount: Boolean;
    begin
        //Search for the same doc with different VAT %
        Clear(SkipCount);
        NrFactCountBuff.Reset;
        NrFactCountBuff.SetRange(Pk1, _DecLine."Tip Operatie");
        if _DecLine."Tip Partener" <> _DecLine."Tip Partener"::"1-CUI Valid din RO si din afara inreg. in scopuri de TVA in RO" then
            NrFactCountBuff.SetRange(Pk3, _DecLine."Bill-to/Pay-to No.")
        else
            NrFactCountBuff.SetRange(Pk3, GetVATNo(_DecLine."VAT Registration No."));
        NrFactCountBuff.SetRange(PK4, _DecLine."Document No.");
        if (NrFactCountBuff.FindFirst) and (NrFactCountBuff.Pk2 <> _DecLine.Cota) then
            if (Abs(NrFactCountBuff.Dec01) < Abs(_DecLine.Amount)) then begin
                NrFactCountBuff.Delete;
            end else begin
                SkipCount := true;
            end;

        if not SkipCount then
            if _DecLine."Tip Partener" <> _DecLine."Tip Partener"::"1-CUI Valid din RO si din afara inreg. in scopuri de TVA in RO" then begin
                if not NrFactCountBuff.Get(
                  _DecLine."Tip Operatie", _DecLine.Cota, _DecLine."Bill-to/Pay-to No.", _DecLine."Document No.")
                then begin
                    NrFactCountBuff.Init;
                    NrFactCountBuff.Pk1 := _DecLine."Tip Operatie";
                    NrFactCountBuff.Pk2 := _DecLine.Cota;
                    NrFactCountBuff.Pk3 := _DecLine."Bill-to/Pay-to No.";
                    NrFactCountBuff.PK4 := _DecLine."Document No.";
                    NrFactCountBuff.Dec01 := _DecLine.Amount;
                    NrFactCountBuff.Code1 := _DecLine."Cod Serie Factura";
                    NrFactCountBuff.Text04 := Format(_DecLine."Tip Document D394");
                    NrFactCountBuff.Int04 := Date2DMY(_DecLine."Posting Date", 2);
                    NrFactCountBuff.Insert;
                end;
            end else begin
                if not NrFactCountBuff.Get(
                  _DecLine."Tip Operatie", _DecLine.Cota, GetVATNo(_DecLine."VAT Registration No."), _DecLine."Document No.")
                then begin
                    NrFactCountBuff.Init;
                    NrFactCountBuff.Pk1 := _DecLine."Tip Operatie";
                    NrFactCountBuff.Pk2 := _DecLine.Cota;
                    NrFactCountBuff.Pk3 := GetVATNo(_DecLine."VAT Registration No.");
                    NrFactCountBuff.PK4 := _DecLine."Document No.";
                    NrFactCountBuff.Dec01 := _DecLine.Amount;
                    NrFactCountBuff.Code1 := _DecLine."Cod Serie Factura";
                    NrFactCountBuff.Text04 := Format(_DecLine."Tip Document D394");
                    NrFactCountBuff.Int04 := Date2DMY(_DecLine."Posting Date", 2);
                    NrFactCountBuff.Insert;
                end;
            end;
    end;

    local
    procedure CountBF(_DecLine: Record "SSA Domestic Declaration Line")
    var
        SkipCount: Boolean;
    begin
        //Search for the same doc with different VAT %
        Clear(SkipCount);
        NrBFCount.Reset;
        NrBFCount.SetRange(Pk1, _DecLine."Tip Operatie");
        if _DecLine."Tip Partener" <> _DecLine."Tip Partener"::"1-CUI Valid din RO si din afara inreg. in scopuri de TVA in RO" then
            NrBFCount.SetRange(Pk3, _DecLine."Bill-to/Pay-to No.")
        else
            NrBFCount.SetRange(Pk3, GetVATNo(_DecLine."VAT Registration No."));
        NrBFCount.SetRange(PK4, _DecLine."Document No.");
        if (NrBFCount.FindFirst) and (NrBFCount.Pk2 <> _DecLine.Cota) then
            if (Abs(NrBFCount.Dec01) < Abs(_DecLine.Amount)) then begin
                NrBFCount.Delete;
            end else begin
                SkipCount := true;
            end;

        if not SkipCount then
            if _DecLine."Tip Partener" <> _DecLine."Tip Partener"::"1-CUI Valid din RO si din afara inreg. in scopuri de TVA in RO" then begin
                if not NrBFCount.Get(
                  _DecLine."Tip Operatie", _DecLine.Cota, _DecLine."Bill-to/Pay-to No.", _DecLine."Document No.")
                then begin
                    NrBFCount.Init;
                    NrBFCount.Pk1 := _DecLine."Tip Operatie";
                    NrBFCount.Pk2 := _DecLine.Cota;
                    NrBFCount.Pk3 := _DecLine."Bill-to/Pay-to No.";
                    NrBFCount.PK4 := _DecLine."Document No.";
                    NrBFCount.Dec01 := _DecLine.Amount;
                    NrBFCount.Code1 := _DecLine."Cod Serie Factura";
                    NrBFCount.Text04 := Format(_DecLine."Tip Document D394");
                    NrBFCount.Int04 := Date2DMY(_DecLine."Posting Date", 2);
                    NrBFCount.Insert;
                end;
            end else begin
                if not NrBFCount.Get(
                  _DecLine."Tip Operatie", _DecLine.Cota, GetVATNo(_DecLine."VAT Registration No."), _DecLine."Document No.")
                then begin
                    NrBFCount.Init;
                    NrBFCount.Pk1 := _DecLine."Tip Operatie";
                    NrBFCount.Pk2 := _DecLine.Cota;
                    NrBFCount.Pk3 := GetVATNo(_DecLine."VAT Registration No.");
                    NrBFCount.PK4 := _DecLine."Document No.";
                    NrBFCount.Dec01 := _DecLine.Amount;
                    NrBFCount.Code1 := _DecLine."Cod Serie Factura";
                    NrBFCount.Text04 := Format(_DecLine."Tip Document D394");
                    NrBFCount.Int04 := Date2DMY(_DecLine."Posting Date", 2);
                    NrBFCount.Insert;
                end;
            end;
    end;
}

