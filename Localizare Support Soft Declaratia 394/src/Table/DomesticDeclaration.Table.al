table 71701 "SSA Domestic Declaration"
{
    // SSA973 SSCAT 06.09.2019 39.Rapoarte legale- Localizare Declaratia 394

    LookupPageID = "SSA Domestic Declaration List";
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Code"; Code[10])
        {
            Caption = 'Code';
            NotBlank = true;
        }
        field(2; Description; Text[50])
        {
            Caption = 'Description';
        }
        field(3; Type; Option)
        {
            Caption = 'Type';
            InitValue = Monthly;
            OptionCaption = 'Monthly,Quarterly,Semester';
            OptionMembers = Monthly,Quarterly,Semester;

            trigger OnValidate()
            begin
                DomesticDeclarationLine.Reset;
                DomesticDeclarationLine.SetRange(DomesticDeclarationLine."Domestic Declaration Code", Code);
                if not DomesticDeclarationLine.IsEmpty then
                    Error(Text003, FieldCaption(Type));

                if Type <> xRec.Type then
                    ResetPeriod;

                CheckPeriod;
            end;
        }
        field(4; Period; Integer)
        {
            Caption = 'Period';
            MaxValue = 12;
            MinValue = 0;

            trigger OnValidate()
            begin
                if Year = 0 then
                    Year := Date2DMY(WorkDate, 3);
                SetPeriod;
            end;
        }
        field(5; Year; Integer)
        {
            Caption = 'Year';
            MaxValue = 9999;
            MinValue = 2000;

            trigger OnValidate()
            begin
                if Period = 0 then
                    Period := Date2DMY(WorkDate, 2);
                SetPeriod;
            end;
        }
        field(13; Reported; Boolean)
        {
            Caption = 'Reported';
        }
        field(14; "Starting Date"; Date)
        {
            Caption = 'Starting Date';

            trigger OnValidate()
            begin
                TestField(Reported, false);

                if ("Starting Date" <> 0D) and ("Ending Date" <> 0D) and ("Starting Date" > "Ending Date") then
                    Error(Text001);

                if ("Starting Date" <> 0D) and ("Ending Date" <> 0D) then
                    if (Date2DMY("Starting Date", 1) = 1) and (Date2DMY("Starting Date", 2) = 1) and (Date2DMY("Ending Date", 1) = 30) and
                    (Date2DMY("Ending Date", 2) = 6) and (Date2DMY("Starting Date", 3) = Date2DMY("Ending Date", 3)) then
                        Semester := Semester::S1
                    else
                        if (Date2DMY("Starting Date", 1) = 1) and (Date2DMY("Starting Date", 2) = 7) and (Date2DMY("Ending Date", 1) = 31) and
                          (Date2DMY("Ending Date", 2) = 12) and (Date2DMY("Starting Date", 3) = Date2DMY("Ending Date", 3)) then
                            Semester := Semester::S2
                        else
                            Semester := Semester::S0;

                if ("Starting Date" = 0D) or ("Ending Date" = 0D) then
                    Semester := Semester::" ";
            end;
        }
        field(15; "Ending Date"; Date)
        {
            Caption = 'Ending Date';

            trigger OnValidate()
            begin
                TestField(Reported, false);

                if ("Starting Date" <> 0D) and ("Ending Date" <> 0D) and ("Starting Date" > "Ending Date") then
                    Error(Text001);

                if ("Starting Date" <> 0D) and ("Ending Date" <> 0D) then
                    if (Date2DMY("Starting Date", 1) = 1) and (Date2DMY("Starting Date", 2) = 1) and (Date2DMY("Ending Date", 1) = 30) and
                    (Date2DMY("Ending Date", 2) = 6) and (Date2DMY("Starting Date", 3) = Date2DMY("Ending Date", 3)) then
                        Semester := Semester::S1
                    else
                        if (Date2DMY("Starting Date", 1) = 1) and (Date2DMY("Starting Date", 2) = 7) and (Date2DMY("Ending Date", 1) = 31) and
                          (Date2DMY("Ending Date", 2) = 12) and (Date2DMY("Starting Date", 3) = Date2DMY("Ending Date", 3)) then
                            Semester := Semester::S2
                        else
                            Semester := Semester::S0;

                if ("Starting Date" = 0D) or ("Ending Date" = 0D) then
                    Semester := Semester::" ";
            end;
        }
        field(16; Semester; Option)
        {
            Caption = 'Semester';
            Editable = false;
            OptionCaption = ' ,S0,S1,S2';
            OptionMembers = " ",S0,S1,S2;
        }
        field(50000; Month; Option)
        {
            Caption = 'Lună';
            OptionCaption = ' ,01,02,03,04,05,06,07,08,09,10,11,12';
            OptionMembers = " ","01","02","03","04","05","06","07","08","09","10","11","12";
        }
        field(92200; Solicit; Boolean)
        {
        }
        field(92210; AchizitiiPE; Boolean)
        {
        }
        field(92220; AchizitiiCR; Boolean)
        {
        }
        field(92230; AchizitiiCB; Boolean)
        {
        }
        field(92240; AchizitiiCI; Boolean)
        {
        }
        field(92250; AchizitiiA; Boolean)
        {
        }
        field(92260; AchizitiiB24; Boolean)
        {
        }
        field(92270; AchizitiiB20; Boolean)
        {
        }
        field(92280; AchizitiiB19; Boolean)
        {
        }
        field(92290; AchizitiiB9; Boolean)
        {
        }
        field(92300; AchizitiiB5; Boolean)
        {
        }
        field(92310; AchizitiiS24; Boolean)
        {
        }
        field(92320; AchizitiiS20; Boolean)
        {
        }
        field(92330; AchizitiiS19; Boolean)
        {
        }
        field(92340; AchizitiiS9; Boolean)
        {
        }
        field(92350; AchizitiiS5; Boolean)
        {
        }
        field(92360; ImportB; Boolean)
        {
        }
        field(92370; AcINecorp; Boolean)
        {
        }
        field(92380; LivrariBI; Boolean)
        {
        }
        field(92390; Bun24; Boolean)
        {
        }
        field(92400; Bun20; Boolean)
        {
        }
        field(92410; Bun19; Boolean)
        {
        }
        field(92420; Bun9; Boolean)
        {
        }
        field(92430; Bun5; Boolean)
        {
        }
        field(92440; ValoareScutit; Boolean)
        {
        }
        field(92450; BunTI; Boolean)
        {
        }
        field(92460; Prest24; Boolean)
        {
        }
        field(92470; Prest20; Boolean)
        {
        }
        field(92480; Prest19; Boolean)
        {
        }
        field(92490; Prest9; Boolean)
        {
        }
        field(92500; Prest5; Boolean)
        {
        }
        field(92510; PrestScutit; Boolean)
        {
        }
        field(92520; LIntra; Boolean)
        {
        }
        field(92530; PrestIntra; Boolean)
        {
        }
        field(92540; Export; Boolean)
        {
        }
        field(92550; LivNecorp; Boolean)
        {
        }
        field(92560; Efectuat; Boolean)
        {
        }
        field(92570; TipD394; Option)
        {
            OptionCaption = ' ,L,T,S,A';
            OptionMembers = " ",L,T,S,A;
        }
        field(92580; "Tip Intocmit"; Option)
        {
            OptionMembers = " ","Persoana fizica","Persoana Juridica";
        }
        field(92590; "Calitate Intocmit"; Text[50])
        {
        }
        field(92600; "Functie Intocmit"; Text[50])
        {
        }
        field(92610; Perioada; Integer)
        {

            trigger OnValidate()
            var
                DateRec: Record Date;
            begin
                DateRec.Reset;
                DateRec.SetRange("Period Start", DMY2Date(1, 1, Date2DWY(WorkDate, 3)), ClosingDate(DMY2Date(31, 12, Date2DWY(WorkDate, 3))));
                DateRec.SetRange("Period End", DMY2Date(1, 1, Date2DWY(WorkDate, 3)), ClosingDate(DMY2Date(31, 12, Date2DWY(WorkDate, 3))));

                case TipD394 of
                    TipD394::L:
                        begin
                            DateRec.SetRange("Period Type", DateRec."Period Type"::Month);
                            DateRec.SetRange("Period No.", Perioada);
                            if not DateRec.FindFirst then
                                Error('Perioada incorecta');

                            "Starting Date" := DateRec."Period Start";
                            "Ending Date" := NormalDate(DateRec."Period End");
                        end;
                    TipD394::T:
                        begin
                            if Perioada in [1, 4, 7, 10] then
                                Error('Perioada Incorecta!')
                            //      DateRec.SETRANGE("Period Type",DateRec."Period Type"::Quarter);
                            //      DateRec.SETRANGE("Period No.",Perioada);
                            //      IF NOT DateRec.FINDFIRST THEN
                            //        ERROR('Perioada incorecta');
                            //      "Starting Date" := DateRec."Period Start";
                            //      "Ending Date" := NORMALDATE(DateRec."Period End");
                        end;
                    // TipD394::S:
                    //    BEGIN
                    //      CASE Perioada OF
                    //        1: BEGIN
                    //          "Starting Date" := DMY2DATE(1,1,DATE2DWY(WORKDATE,3));
                    //          "Ending Date" := DMY2DATE(30,6,DATE2DWY(WORKDATE,3));
                    //        END;
                    //        2: BEGIN
                    //          "Starting Date" := DMY2DATE(1,7,DATE2DWY(WORKDATE,3));
                    //          "Ending Date" := DMY2DATE(31,12,DATE2DWY(WORKDATE,3));
                    //        END;
                    //      ELSE
                    //        ERROR('perioada incorecta');
                    //      END;
                    //    END;
                    TipD394::A:
                        begin
                            DateRec.Reset;
                            DateRec.SetRange("Period Type", DateRec."Period Type"::Year);
                            DateRec.SetRange("Period No.", Perioada);
                            if not DateRec.FindFirst then
                                Error('Perioada incorecta');

                            "Starting Date" := DateRec."Period Start";
                            "Ending Date" := NormalDate(DateRec."Period End");

                        end;
                    else
                        Error('Tip D394 %1 netratat', TipD394);
                end;
            end;
        }
        field(92620; "Nume Reprezentant"; Code[20])
        {
            Caption = 'Nume Reprezentant';
        }
        field(92630; "Functie Declaratie"; Text[50])
        {
            Caption = 'Functie Declaratie';
        }
        field(92640; "Adresa Reprezentant"; Text[250])
        {
            Caption = 'Adresa Reperzentant';
        }
        field(92650; "Nume Declaratie"; Text[50])
        {
            Caption = 'Nume Declaratie';
        }
        field(92660; "Prenume Declaratie"; Text[50])
        {
            Caption = 'Prenume Declaratie';
        }
        field(92670; "CNP Reprezentant"; Code[20])
        {
            Caption = 'CNP Reprezentant';
        }
        field(92680; "Tel. Reprezentant"; Code[20])
        {
            Caption = 'Tel. Reprezentant';
        }
        field(92690; "E-mail Reprezentant"; Text[50])
        {
            Caption = 'E-mail Reprezentant';
        }
        field(92700; "Telefon Companie"; Text[15])
        {
        }
        field(92710; "Fax Companie"; Text[15])
        {
        }
        field(92720; "E-Mail Companie"; Text[80])
        {
        }
        field(92730; "Fax Reprezentant"; Text[15])
        {
        }
        field(92740; "Nume Intocmit"; Code[80])
        {
        }
        field(92750; "CIF Intocmit"; Code[20])
        {
        }
        field(92760; "Optiune verificare date"; Boolean)
        {
        }
        field(92770; "Schimb Optiune verificare date"; Boolean)
        {

            trigger OnValidate()
            begin
                Validate("Optiune verificare date", true);
            end;
        }
        field(92780; "Nr de AMEF"; Integer)
        {
        }
        field(92790; "Tranzactii Persoane Afiliate"; Boolean)
        {
            Caption = 'Tranzactii Persoane Afiliate';
        }
        field(92800; "Copy Declaration Info from"; Code[10])
        {
            Caption = 'Copy Declaration Info from';
            TableRelation = "SSA Domestic Declaration";
            trigger OnValidate()
            begin
                CopyInfo("Copy Declaration Info from");
            end;
        }
    }

    keys
    {
        key(Key1; "Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        DomesticDeclarationLine.SetRange("Domestic Declaration Code", Code);
        DomesticDeclarationLine.DeleteAll;
    end;

    var
        Text001: Label 'Ending Date cannot be earlier the Starting Date.';
        DomesticDeclarationLine: Record "SSA Domestic Declaration Line";
        Text002: Label 'Declaration %1=%2, %3=%4 already exists.';
        Text003: Label 'You cannot change %1 because you already have declaration lines.';
        Text004: Label 'Period must not be more than %1 when type is %2.';
        Text005: Label 'Do you want to copy infromation form Domestic Declaration %1?';

    local procedure ResetPeriod()
    begin
        Period := 0;
        Year := Date2DMY(WorkDate, 3);
        SetPeriod;
    end;

    local procedure SetPeriod()
    begin
        case Type of
            Type::Monthly:
                begin
                    "Starting Date" := DMY2Date(1, Period, Year);
                    "Ending Date" := CalcDate('<CM>', "Starting Date");
                end;
            Type::Quarterly:
                begin
                    if Period > 4 then
                        Error(Text004, 4, Type);
                    "Ending Date" := CalcDate('<CM>', DMY2Date(1, Period * 3, Year));
                    "Starting Date" := CalcDate('<-CM-2M>', "Ending Date");
                end;
            Type::Semester:
                begin
                    if Period > 2 then
                        Error(Text004, 2, Type);
                    "Ending Date" := CalcDate('<CM>', DMY2Date(1, Period * 6, Year));
                    "Starting Date" := CalcDate('<-CM-5M>', "Ending Date");
                end;
        end;

        CheckPeriod;
    end;

    local procedure CheckPeriod()
    var
        DomesticDeclaration: Record "SSA Domestic Declaration";
    begin
        if ("Starting Date" = 0D) or ("Ending Date" = 0D) then
            exit;

        if "Starting Date" >= "Ending Date" then
            Error(Text001, FieldCaption("Starting Date"), FieldCaption("Ending Date"));

        DomesticDeclaration.Reset;
        DomesticDeclaration.SetCurrentKey(Type, Period);
        DomesticDeclaration.SetRange(Type, Type);
        DomesticDeclaration.SetRange(Period, Period);
        if not DomesticDeclaration.IsEmpty then
            Error(Text002, FieldCaption(Type), Type, FieldCaption(Period), Period);
    end;

    procedure CopyInfo(_DecNo: Code[10])
    var
        DecHeader: Record "SSA Domestic Declaration";
    begin
        IF NOT CONFIRM(STRSUBSTNO(Text005, _DecNo)) THEN
            EXIT;

        DecHeader.GET(_DecNo);

        VALIDATE(Solicit, DecHeader.Solicit);
        VALIDATE(AchizitiiPE, DecHeader.AchizitiiPE);
        VALIDATE(AchizitiiCR, DecHeader.AchizitiiCR);
        VALIDATE(AchizitiiCB, DecHeader.AchizitiiCB);
        VALIDATE(AchizitiiCI, DecHeader.AchizitiiCI);
        VALIDATE(AchizitiiA, DecHeader.AchizitiiA);
        VALIDATE(AchizitiiB24, DecHeader.AchizitiiB24);
        VALIDATE(AchizitiiB20, DecHeader.AchizitiiB20);
        VALIDATE(AchizitiiB19, DecHeader.AchizitiiB19);
        VALIDATE(AchizitiiB9, DecHeader.AchizitiiB9);
        VALIDATE(AchizitiiB5, DecHeader.AchizitiiB5);
        VALIDATE(AchizitiiS24, DecHeader.AchizitiiS24);
        VALIDATE(AchizitiiS20, DecHeader.AchizitiiS20);
        VALIDATE(AchizitiiS19, DecHeader.AchizitiiS19);
        VALIDATE(AchizitiiS9, DecHeader.AchizitiiS9);
        VALIDATE(AchizitiiS5, DecHeader.AchizitiiS5);
        VALIDATE(ImportB, DecHeader.ImportB);
        VALIDATE(AcINecorp, DecHeader.AcINecorp);
        VALIDATE(LivrariBI, DecHeader.LivrariBI);
        VALIDATE(Bun24, DecHeader.Bun24);
        VALIDATE(Bun20, DecHeader.Bun20);
        VALIDATE(Bun19, DecHeader.Bun19);
        VALIDATE(Bun9, DecHeader.Bun9);
        VALIDATE(Bun5, DecHeader.Bun5);
        VALIDATE(ValoareScutit, DecHeader.ValoareScutit);
        VALIDATE(BunTI, DecHeader.BunTI);
        VALIDATE(Prest24, DecHeader.Prest24);
        VALIDATE(Prest20, DecHeader.Prest20);
        VALIDATE(Prest19, DecHeader.Prest19);
        VALIDATE(Prest9, DecHeader.Prest9);
        VALIDATE(Prest5, DecHeader.Prest5);
        VALIDATE(PrestScutit, DecHeader.PrestScutit);
        VALIDATE(LIntra, DecHeader.LIntra);
        VALIDATE(PrestIntra, DecHeader.PrestIntra);
        VALIDATE(Export, DecHeader.Export);
        VALIDATE(LivNecorp, DecHeader.LivNecorp);
        VALIDATE(Efectuat, DecHeader.Efectuat);
        VALIDATE("Tip Intocmit", DecHeader."Tip Intocmit");
        VALIDATE("Calitate Intocmit", DecHeader."Calitate Intocmit");
        VALIDATE("Functie Intocmit", DecHeader."Functie Intocmit");
        VALIDATE("Nume Reprezentant", DecHeader."Nume Reprezentant");
        VALIDATE("Functie Declaratie", DecHeader."Functie Declaratie");
        VALIDATE("Adresa Reprezentant", DecHeader."Adresa Reprezentant");
        VALIDATE("Nume Declaratie", DecHeader."Nume Declaratie");
        VALIDATE("Prenume Declaratie", DecHeader."Prenume Declaratie");
        VALIDATE("CNP Reprezentant", DecHeader."CNP Reprezentant");
        VALIDATE("Tel. Reprezentant", DecHeader."Tel. Reprezentant");
        VALIDATE("E-mail Reprezentant", DecHeader."E-mail Reprezentant");
        VALIDATE("Telefon Companie", DecHeader."Telefon Companie");
        VALIDATE("Fax Companie", DecHeader."Fax Companie");
        VALIDATE("E-Mail Companie", DecHeader."E-Mail Companie");
        VALIDATE("Fax Reprezentant", DecHeader."Fax Reprezentant");
        VALIDATE("Nume Intocmit", DecHeader."Nume Intocmit");
        VALIDATE("CIF Intocmit", DecHeader."CIF Intocmit");
        VALIDATE("Optiune verificare date", DecHeader."Optiune verificare date");
        VALIDATE("Schimb Optiune verificare date", DecHeader."Schimb Optiune verificare date");
        MODIFY(TRUE);
    end;
}

