table 71501 "SSA VIES Header"
{
    // SSA974 SSCAT 11.10.2019 40.Rapoarte legale-Declaratia 390

    Caption = 'VIES Header';
    DrillDownPageID = "SSA VIES Declarations";
    LookupPageID = "SSA VIES Declarations";

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';

            trigger OnValidate()
            var
                NoSeriesMgt: Codeunit NoSeriesManagement;
            begin
                if "No." <> xRec."No." then begin
                    NoSeriesMgt.TestManual(GetNoSeriesCode);
                    "No. Series" := '';
                end;
            end;
        }
        field(2; "VAT Registration No."; Text[20])
        {
            Caption = 'VAT Registration No.';
            NotBlank = true;

            trigger OnValidate()
            begin
                TestField(Status, Status::Open);
            end;
        }
        field(3; "Trade Type"; Option)
        {
            Caption = 'Trade Type';
            InitValue = Sales;
            OptionCaption = 'Purchases,Sales,Both';
            OptionMembers = Purchases,Sales,Both;

            trigger OnValidate()
            begin
                TestField(Status, Status::Open);
                if LineExists then
                    Error(Text004, FieldCaption("Trade Type"));
                CheckPeriod;
            end;
        }
        field(4; "Period No."; Integer)
        {
            Caption = 'Period No.';

            trigger OnValidate()
            begin
                TestField(Status, Status::Open);
                if "Period No." <> xRec."Period No." then begin
                    if LineExists then
                        Error(Text004, FieldCaption("Period No."));
                    SetPeriod;
                end;
            end;
        }
        field(5; Year; Integer)
        {
            Caption = 'Year';
            MaxValue = 9999;
            MinValue = 2000;

            trigger OnValidate()
            begin
                TestField(Status, Status::Open);
                if Year <> xRec.Year then begin
                    if LineExists then
                        Error(Text004, FieldCaption(Year));
                    SetPeriod;
                end;
            end;
        }
        field(6; "Start Date"; Date)
        {
            Caption = 'Start Date';
            Editable = false;
        }
        field(7; "End Date"; Date)
        {
            Caption = 'End Date';
            Editable = false;
        }
        field(8; Name; Text[100])
        {
            Caption = 'Name';

            trigger OnValidate()
            begin
                TestField(Status, Status::Open);
            end;
        }
        field(9; "Name 2"; Text[50])
        {
            Caption = 'Name 2';

            trigger OnValidate()
            begin
                TestField(Status, Status::Open);
            end;
        }
        field(10; "Country/Region Name"; Text[30])
        {
            Caption = 'Country/Region Name';

            trigger OnValidate()
            begin
                TestField(Status, Status::Open);
            end;
        }
        field(11; County; Text[30])
        {
            Caption = 'County';

            trigger OnValidate()
            begin
                TestField(Status, Status::Open);
            end;
        }
        field(12; "Municipality No."; Text[30])
        {
            Caption = 'Municipality No.';

            trigger OnValidate()
            begin
                TestField(Status, Status::Open);
            end;
        }
        field(13; Street; Text[50])
        {
            Caption = 'Street';

            trigger OnValidate()
            begin
                TestField(Status, Status::Open);
            end;
        }
        field(14; "House No."; Text[30])
        {
            Caption = 'House No.';

            trigger OnValidate()
            begin
                TestField(Status, Status::Open);
            end;
        }
        field(15; "Apartment No."; Text[30])
        {
            Caption = 'Apartment No.';

            trigger OnValidate()
            begin
                TestField(Status, Status::Open);
            end;
        }
        field(16; City; Text[30])
        {
            Caption = 'City';

            trigger OnLookup()
            begin
                PostCode.LookupPostCode(City, "Post Code", County, "Country/Region Code");
            end;

            trigger OnValidate()
            begin
                TestField(Status, Status::Open);
                PostCode.ValidateCity(City, "Post Code", County, "Country/Region Code", (CurrFieldNo <> 0) and GuiAllowed);
            end;
        }
        field(17; "Post Code"; Code[20])
        {
            Caption = 'Post Code';

            trigger OnLookup()
            begin
                PostCode.LookupPostCode(City, "Post Code", County, "Country/Region Code");
            end;

            trigger OnValidate()
            begin
                TestField(Status, Status::Open);
                PostCode.ValidatePostCode(City, "Post Code", County, "Country/Region Code", false);
            end;
        }
        field(18; "SSA Tax Office Number"; Code[20])
        {
            Caption = 'Tax Office Number';

            trigger OnValidate()
            begin
                TestField(Status, Status::Open);
            end;
        }
        field(19; "Declaration Period"; Option)
        {
            Caption = 'Declaration Period';
            OptionCaption = 'Quarter,Month';
            OptionMembers = Quarter,Month;

            trigger OnValidate()
            begin
                TestField(Status, Status::Open);
                if "Declaration Period" <> xRec."Declaration Period" then begin
                    if LineExists then
                        Error(Text004, FieldCaption("Declaration Period"));
                    SetPeriod;
                end;
            end;
        }
        field(20; "Declaration Type"; Option)
        {
            Caption = 'Declaration Type';
            OptionCaption = 'Normal,Corrective,Corrective-Supplementary';
            OptionMembers = Normal,Corrective,"Corrective-Supplementary";

            trigger OnValidate()
            begin
                TestField(Status, Status::Open);
                if "Declaration Type" <> xRec."Declaration Type" then begin
                    if LineExists then
                        Error(Text004, FieldCaption("Declaration Type"));
                    if "Declaration Type" = "Declaration Type"::Normal then
                        "Corrected Declaration No." := '';
                end;
            end;
        }
        field(21; "Corrected Declaration No."; Code[20])
        {
            Caption = 'Corrected Declaration No.';
            TableRelation = "SSA VIES Header" WHERE("Corrected Declaration No." = FILTER(''),
                                                     Status = CONST(Released));

            trigger OnValidate()
            begin
                TestField(Status, Status::Open);
                if "Corrected Declaration No." <> xRec."Corrected Declaration No." then begin
                    if "Declaration Type" = "Declaration Type"::Normal then
                        FieldError("Declaration Type");
                    if "No." = "Corrected Declaration No." then
                        FieldError("Corrected Declaration No.");
                    if LineExists then
                        Error(Text004, FieldCaption("Corrected Declaration No."));

                    CopyCorrDeclaration;
                end;
            end;
        }
        field(24; "Document Date"; Date)
        {
            Caption = 'Document Date';

            trigger OnValidate()
            begin
                TestField(Status, Status::Open);
            end;
        }
        field(25; "Number of Pages"; Integer)
        {
            CalcFormula = Max("SSA VIES Line"."Report Page Number" WHERE("VIES Declaration No." = FIELD("No.")));
            Caption = 'Number of Pages';
            Editable = false;
            FieldClass = FlowField;
        }
        field(26; "Number of Lines"; Integer)
        {
            CalcFormula = Count("SSA VIES Line" WHERE("VIES Declaration No." = FIELD("No.")));
            Caption = 'Number of Lines';
            Editable = false;
            FieldClass = FlowField;
        }
        field(27; "Sign-off Place"; Text[30])
        {
            Caption = 'Sign-off Place';

            trigger OnValidate()
            begin
                TestField(Status, Status::Open);
            end;
        }
        field(28; "Sign-off Date"; Date)
        {
            Caption = 'Sign-off Date';

            trigger OnValidate()
            begin
                TestField(Status, Status::Open);
            end;
        }
        field(29; "EU Goods/Services"; Option)
        {
            Caption = 'EU Goods/Services';
            OptionCaption = 'Both,Goods,Services';
            OptionMembers = Both,Goods,Services;

            trigger OnValidate()
            begin
                if LineExists then
                    Error(Text004, FieldCaption("EU Goods/Services"));
            end;
        }
        field(30; "Purchase Amount (LCY)"; Decimal)
        {
            CalcFormula = Sum("SSA VIES Line"."Amount (LCY)" WHERE("VIES Declaration No." = FIELD("No."),
                                                                    "Trade Type" = CONST(Purchase)));
            Caption = 'Purchase Amount (LCY)';
            Editable = false;
            FieldClass = FlowField;
        }
        field(31; "Sales Amount (LCY)"; Decimal)
        {
            CalcFormula = Sum("SSA VIES Line"."Amount (LCY)" WHERE("VIES Declaration No." = FIELD("No."),
                                                                    "Trade Type" = CONST(Sale)));
            Caption = 'Sales Amount (LCY)';
            Editable = false;
            FieldClass = FlowField;
        }
        field(32; "Amount (LCY)"; Decimal)
        {
            CalcFormula = Sum("SSA VIES Line"."Amount (LCY)" WHERE("VIES Declaration No." = FIELD("No.")));
            Caption = 'Amount (LCY)';
            Editable = false;
            FieldClass = FlowField;
        }
        field(33; "Number of Supplies"; Decimal)
        {
            CalcFormula = Sum("SSA VIES Line"."Number of Supplies" WHERE("VIES Declaration No." = FIELD("No.")));
            Caption = 'Number of Supplies';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50; Status; Option)
        {
            Caption = 'Status';
            OptionCaption = 'Open,Released';
            OptionMembers = Open,Released;
        }
        field(51; "No. Series"; Code[10])
        {
            Caption = 'No. Series';
            TableRelation = "No. Series";
        }
        field(70; "Authorized Employee No."; Code[20])
        {
            Caption = 'Authorized Employee No.';

            trigger OnValidate()
            begin
                TestField(Status, Status::Open);
            end;
        }
        field(71; "Filled by Employee No."; Code[20])
        {
            Caption = 'Filled by Employee No.';

            trigger OnValidate()
            begin
                TestField(Status, Status::Open);
            end;
        }
        field(72; "Country/Region Code"; Code[10])
        {
            TableRelation = "Country/Region";
        }
    }

    keys
    {
        key(Key1; "No.")
        {
            Clustered = true;
        }
        key(Key2; "Start Date", "End Date")
        {
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "EU Goods/Services", "Period No.", Year)
        {
        }
    }

    trigger OnDelete()
    var
        VIESLine: Record "SSA VIES Line";
    begin
        TestField(Status, Status::Open);

        VIESLine.Reset;
        VIESLine.SetRange("VIES Declaration No.", "No.");
        VIESLine.DeleteAll;
    end;

    trigger OnInsert()
    var
        NoSeriesMgt: Codeunit NoSeriesManagement;
    begin
        if "No." = '' then
            NoSeriesMgt.InitSeries(GetNoSeriesCode, xRec."No. Series", WorkDate, "No.", "No. Series");

        InitRecord;
    end;

    trigger OnRename()
    begin
        Error(Text003, TableCaption);
    end;

    var
        Text001: Label 'Period from %1 till %2 already exists on %3 %4.';
        Text002: Label '%1 should be earlier than %2.';
        Text003: Label 'You cannot rename a %1.';
        PostCode: Record "Post Code";
        Text004: Label 'You cannot change %1 because you already have declaration lines.';
        Text005: Label 'The permitted values for %1 are from 1 to %2.';

    local
    procedure InitRecord()
    var
        SSASetup: Record "SSA Localization Setup";
        CountryRegion: Record "Country/Region";
        CompanyInfo: Record "Company Information";
    begin
        CompanyInfo.Get;
        SSASetup.Get;

        "VAT Registration No." := CompanyInfo."VAT Registration No.";
        "Document Date" := WorkDate;
        Name := CompanyInfo.Name;
        "Name 2" := CompanyInfo."Name 2";

        CountryRegion.Get(CompanyInfo."Country/Region Code");
        "Country/Region Code" := CompanyInfo."Country/Region Code";
        "Country/Region Name" := CountryRegion.Name;
        County := CompanyInfo.County;
        City := CompanyInfo.City;
        Street := SSASetup."SSA Street";
        "House No." := SSASetup."SSA House No.";
        "Apartment No." := SSASetup."SSA Apartment No.";
        "Municipality No." := SSASetup."SSA Municipality No.";
        "Post Code" := CompanyInfo."Post Code";
        "SSA Tax Office Number" := SSASetup."SSA Tax Office Number";
    end;

    procedure AssistEdit(OldVIESHeader: Record "SSA VIES Header"): Boolean
    var
        NoSeriesMgt: Codeunit NoSeriesManagement;
    begin
        if NoSeriesMgt.SelectSeries(GetNoSeriesCode, OldVIESHeader."No. Series", "No. Series") then begin
            NoSeriesMgt.SetSeries("No.");
            exit(true);
        end;
    end;

    local procedure GetNoSeriesCode(): Code[10]
    var
        SSASetup: Record "SSA Localization Setup";
    begin
        SSASetup.Get;
        SSASetup.TestField("SSA VIES Declaration Nos.");
        exit(SSASetup."SSA VIES Declaration Nos.");
    end;

    local procedure CheckPeriodNo()
    var
        MaxPeriodNo: Integer;
    begin
        if "Declaration Period" = "Declaration Period"::Month then
            MaxPeriodNo := 12
        else
            MaxPeriodNo := 4;
        if not ("Period No." in [1 .. MaxPeriodNo]) then
            Error(Text005, FieldCaption("Period No."), MaxPeriodNo);
    end;

    local procedure SetPeriod()
    begin
        if "Period No." <> 0 then
            CheckPeriodNo;
        if ("Period No." = 0) or (Year = 0) then begin
            "Start Date" := 0D;
            "End Date" := 0D;
        end else begin
            if "Declaration Period" = "Declaration Period"::Month then begin
                "Start Date" := DMY2Date(1, "Period No.", Year);
                "End Date" := CalcDate('<CM>', "Start Date");
            end else begin
                "Start Date" := DMY2Date(1, "Period No." * 3 - 2, Year);
                "End Date" := CalcDate('<CQ>', "Start Date");
            end;
        end;
        CheckPeriod;
    end;

    local procedure CheckPeriod()
    var
        VIESHeader: Record "SSA VIES Header";
    begin
        if ("Start Date" = 0D) or ("End Date" = 0D) then
            exit;

        if "Start Date" >= "End Date" then
            Error(Text002, FieldCaption("Start Date"), FieldCaption("End Date"));

        if "Corrected Declaration No." = '' then begin
            VIESHeader.Reset;
            VIESHeader.SetCurrentKey("Start Date", "End Date");
            VIESHeader.SetRange("Start Date", "Start Date");
            VIESHeader.SetRange("End Date", "End Date");
            VIESHeader.SetRange("Corrected Declaration No.", '');
            VIESHeader.SetRange("VAT Registration No.", "VAT Registration No.");
            VIESHeader.SetRange("Declaration Type", "Declaration Type");
            VIESHeader.SetRange("Trade Type", "Trade Type");
            VIESHeader.SetFilter("No.", '<>%1', "No.");
            if VIESHeader.FindFirst then
                Error(Text001, "Start Date", "End Date", VIESHeader.TableCaption, VIESHeader."No.");
        end;
    end;

    procedure Print()
    var
        VIESDeclarationHeader: Record "SSA VIES Header";

    begin
        TestField(Status, Status::Released);

        VIESDeclarationHeader := Rec;
        VIESDeclarationHeader.SetRecFilter;
        REPORT.Run(report::"SSA VAT- VIES Declaration", true, false, VIESDeclarationHeader);
    end;

    local procedure LineExists(): Boolean
    var
        VIESLine: Record "SSA VIES Line";
    begin
        VIESLine.Reset;
        VIESLine.SetRange("VIES Declaration No.", "No.");
        exit(VIESLine.FindFirst);
    end;

    local procedure CopyCorrDeclaration()
    var
        SavedVIESHeader: Record "SSA VIES Header";
        VIESHeader: Record "SSA VIES Header";
    begin
        TestField("Corrected Declaration No.");
        VIESHeader.Get("Corrected Declaration No.");
        SavedVIESHeader.TransferFields(Rec);
        TransferFields(VIESHeader);
        Modify;
        "No." := SavedVIESHeader."No.";
        Status := SavedVIESHeader.Status::Open;
        "Document Date" := SavedVIESHeader."Document Date";
        "Declaration Type" := SavedVIESHeader."Declaration Type";
        "Corrected Declaration No." := SavedVIESHeader."Corrected Declaration No.";
    end;
}

