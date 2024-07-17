table 71900 "SSAFT Mapping Range"
{
    // SSM2101 SSCAT 04.01.2023 SAF-T

    Caption = 'SAFT Mapping Range';
    DrillDownPageID = "SSAFT Mapping Range";
    LookupPageID = "SSAFT Mapping Range";

    fields
    {
        field(1; "Code"; Code[20])
        {
            Caption = 'Code';
            DataClassification = ToBeClassified;
            NotBlank = true;
        }
        field(10; "Starting Date"; Date)
        {
            Caption = 'Starting Date';
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                CheckDateConsistency;
                if "Starting Date" = 0D then
                    "Range Type" := 0
                else begin
                    "Accounting Period" := 0D;
                    "Range Type" := "Range Type"::"Date Range";
                end;
            end;
        }
        field(20; "Ending Date"; Date)
        {
            Caption = 'Ending Date';
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                CheckDateConsistency;
                if "Ending Date" = 0D then
                    "Range Type" := 0
                else begin
                    "Accounting Period" := 0D;
                    "Range Type" := "Range Type"::"Date Range";
                end;
            end;
        }
        field(30; "Range Type"; Option)
        {
            Caption = 'Range Type';
            DataClassification = ToBeClassified;
            OptionCaption = ' ,Accounting Period,Date Range';
            OptionMembers = " ","Accounting Period","Date Range";
        }
        field(40; "Accounting Period"; Date)
        {
            Caption = 'Accounting Period';
            DataClassification = ToBeClassified;
            TableRelation = "Accounting Period" where("New Fiscal Year" = const(true));

            trigger OnValidate()
            var
                AccountingPeriod: Record "Accounting Period";
            begin
                if "Accounting Period" = 0D then
                    "Range Type" := 0
                else begin
                    "Range Type" := "Range Type"::"Accounting Period";
                    AccountingPeriod.Get("Accounting Period");
                    "Starting Date" := AccountingPeriod."Starting Date";
                    "Ending Date" := AccountingPeriod.GetFiscalYearEndDate("Starting Date");
                    if "Ending Date" = 0D then
                        Error(CannotSelectAccPeriodWithoutEndingDateErr);
                end;
            end;
        }
        field(60; "Chart of Account NFT"; Option)
        {
            Caption = 'Chart of Account NFT';
            DataClassification = ToBeClassified;
            InitValue = PlanConturiBalSocCom;
            OptionMembers = "TAX-IMP - Impozite","TAX-IMP - Bugete",Livrari,"Achizitii ded 100%","Achizitii ded 50%_baserate","Achizitii ded 50%_not_known","Achizitii ded 50%","Achizitii neded","Achizitii baserate","Achizitii not known","WHT - nomenclator","WHT - D207","WHT - cote","IBAN-ISO13616-1997","ISO3166-1A2 - RO Dept Codes","ISO3166-2-CountryCodes",ISO4217CurrCodes,PlanConturiBalSocCom,PlanConturiIFRS,PlanConturiIFRS_Norma39,PlanConturiBanci,PlanConturiNebancare,PlanConturiSocAsigurari,Unitati_masura,NC8_2021_TARIC3,"Nomenclator stocuri","Nomenclator imobilizari",Nomenclator_Regim_fiscal,SAFT_Nomenclator_StockChar,Nom_Tipuri_facturi,Nom_Mecanisme_plati,"An fiscal-perioade de raportare","Nomenclator tari si valuta","IBAN Validation";
        }
        field(70; Description; Text[100])
        {
            Caption = 'Description';
            DataClassification = ToBeClassified;
        }
        field(80; "Source Code Inchidere TVA"; Code[10])
        {
            Caption = 'Source Code Inchidere TVA';
            DataClassification = ToBeClassified;
            TableRelation = "Source Code";
        }
        field(90; "Inchidere TVA Tax Code"; Code[10])
        {
            Caption = 'Inchidere TVA Tax Code';
            DataClassification = ToBeClassified;
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

    var
        DatesAreNotCorrectErr: Label 'Starting date cannot be before ending date.';
        CannotSelectAccPeriodWithoutEndingDateErr: Label 'You cannot select the accounting period that does not have the ending date.';

    local procedure CheckDateConsistency()
    begin
        if ("Starting Date" <> 0D) and ("Ending Date" <> 0D) and ("Starting Date" > "Ending Date") then
            Error(DatesAreNotCorrectErr);
    end;
}

