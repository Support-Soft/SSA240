table 71901 "SSAFTSAFT-NAV Mapping"
{
    // SSM2101 SSCAT 04.01.2023 SAF-T

    Caption = 'SSAFTSAFT-NAV Mapping';

    fields
    {
        field(1; "Mapping Range Code"; Code[20])
        {
            Caption = 'Mapping Range Code';
            DataClassification = ToBeClassified;
        }
        field(10; "NFT Type"; Option)
        {
            Caption = 'NFT Type';
            DataClassification = ToBeClassified;
            OptionMembers = "TAX-IMP - Impozite","TAX-IMP - Bugete",Livrari,"Achizitii ded 100%","Achizitii ded 50%_baserate","Achizitii ded 50%_not_known","Achizitii ded 50%","Achizitii neded","Achizitii baserate","Achizitii not known","WHT - nomenclator","WHT - D207","WHT - cote","IBAN-ISO13616-1997","ISO3166-1A2 - RO Dept Codes","ISO3166-2-CountryCodes",ISO4217CurrCodes,PlanConturiBalSocCom,PlanConturiIFRS,PlanConturiIFRS_Norma39,PlanConturiBanci,PlanConturiNebancare,PlanConturiSocAsigurari,Unitati_masura,NC8_2021_TARIC3,"Nomenclator stocuri","Nomenclator imobilizari",Nomenclator_Regim_fiscal,SAFT_Nomenclator_StockChar,Nom_Tipuri_facturi,Nom_Mecanisme_plati,"An fiscal-perioade de raportare","Nomenclator tari si valuta","IBAN Validation";
        }
        field(20; "SAFT Code"; Code[50])
        {
            Caption = 'SAFT Code';
            DataClassification = ToBeClassified;
            TableRelation = "SSAFTSAFT Mapping Values"."SAFT Code" where("NFT Type" = field("NFT Type"));

            trigger OnValidate()
            var
                SAFTMappingValues: Record "SSAFTSAFT Mapping Values";
            begin
                if SAFTMappingValues.Get("NFT Type", "SAFT Code") then
                    Validate("SAFT Description", SAFTMappingValues."SAFT Description")
                else
                    Validate("SAFT Description", '');
            end;
        }
        field(30; "Table ID"; Integer)
        {
            Caption = 'Table ID';
            DataClassification = ToBeClassified;
            TableRelation = AllObj."Object ID" where("Object Type" = const(Table));
        }
        field(50; "NAV Code"; Code[50])
        {
            Caption = 'NAV Code';
            DataClassification = ToBeClassified;
            TableRelation = if ("Table ID" = const(15)) "G/L Account"
            else
            if ("Table ID" = const(9)) "Country/Region"
            else
            if ("Table ID" = const(4)) Currency
            else
            if ("Table ID" = const(204)) "Unit of Measure"
            else
            if ("Table ID" = const(289)) "Payment Method"
            else
            if ("Table ID" = const(260)) "Tariff Number";
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;

            trigger OnLookup()
            var
                CountryRegion: Record "Country/Region";
                UnitofMeasure: Record "Unit of Measure";
                PaymentMethod: Record "Payment Method";
                TariffNumber: Record "Tariff Number";
                CurrenciesPage: Page Currencies;
                GLAccountListPage: Page "G/L Account List";
                CountriesRegionsPage: Page "Countries/Regions";
                UnitsofMeasurePage: Page "Units of Measure";
                PaymentMethodsPage: Page "Payment Methods";
                TariffNumbersPage: Page "Tariff Numbers";
                RecRef: RecordRef;
                FldRef: FieldRef;
                ValueText: Text;
                IntOption: Integer;
            begin
                case "Table ID" of
                    4:
                        begin
                            CurrenciesPage.LookupMode(true);
                            if CurrenciesPage.RunModal = ACTION::LookupOK then
                                Validate("NAV Code", CurrenciesPage.GetSelectionFilter);
                        end;
                    9:
                        begin
                            CountriesRegionsPage.LookupMode(true);
                            if CountriesRegionsPage.RunModal = ACTION::LookupOK then begin
                                CountriesRegionsPage.GetRecord(CountryRegion);
                                Validate("NAV Code", CountryRegion.Code);
                            end;
                        end;
                    15:
                        begin
                            GLAccountListPage.LookupMode(true);
                            if GLAccountListPage.RunModal = ACTION::LookupOK then
                                Validate("NAV Code", GLAccountListPage.GetSelectionFilter);
                        end;
                    204:
                        begin
                            UnitsofMeasurePage.LookupMode(true);
                            if UnitsofMeasurePage.RunModal = ACTION::LookupOK then begin
                                UnitsofMeasurePage.GetRecord(UnitofMeasure);
                                Validate("NAV Code", UnitofMeasure.Code);
                            end;
                        end;
                    260:
                        begin
                            TariffNumbersPage.LookupMode(true);
                            if TariffNumbersPage.RunModal = ACTION::LookupOK then begin
                                TariffNumbersPage.GetRecord(TariffNumber);
                                Validate("NAV Code", TariffNumber."No.");
                            end;
                        end;
                    289:
                        begin
                            PaymentMethodsPage.LookupMode(true);
                            if PaymentMethodsPage.RunModal = ACTION::LookupOK then begin
                                PaymentMethodsPage.GetRecord(PaymentMethod);
                                Validate("NAV Code", PaymentMethod.Code);
                            end;
                        end;
                    else
                        if ("Table ID" <> 0) and ("Field ID" <> 0) then begin
                            RecRef.Open("Table ID");
                            FldRef := RecRef.Field("Field ID");
                            //MESSAGE('%1',FldRef.TYPE);
                            ValueText := FldRef.OptionCaption;
                            Evaluate(IntOption, Format(FldRef.Value(StrMenu(ValueText))));
                            "NAV Code" := CopyStr(SelectStr(IntOption, ValueText), 1, MaxStrLen("NAV Code"));
                            Validate("NAV Code");
                        end;
                        Validate("NAV Description", "NAV Code");
                end;
            end;

            trigger OnValidate()
            var
                Currency: Record Currency;
                GLAccount: Record "G/L Account";
                CountryRegion: Record "Country/Region";
                UnitofMeasure: Record "Unit of Measure";
                PaymentMethod: Record "Payment Method";
                TariffNumber: Record "Tariff Number";
            begin
                case "Table ID" of
                    4:
                        if Currency.Get("NAV Code") then
                            Validate("NAV Description", Currency.Description);
                    9:
                        if CountryRegion.Get("NAV Code") then
                            Validate("NAV Description", CountryRegion.Name);
                    15:
                        if GLAccount.Get("NAV Code") then
                            Validate("NAV Description", GLAccount.Name);
                    204:
                        if UnitofMeasure.Get("NAV Code") then
                            Validate("NAV Description", UnitofMeasure.Description);
                    260:
                        if TariffNumber.Get("NAV Code") then
                            Validate("NAV Description", TariffNumber.Description);
                    289:
                        if PaymentMethod.Get("NAV Code") then
                            Validate("NAV Description", PaymentMethod.Description);
                    else
                        Validate("NAV Description", "NAV Code");
                end;
                if "NAV Code" = '' then
                    Validate("NAV Description", '');
            end;
        }
        field(60; "SAFT Description"; Text[250])
        {
            Caption = 'SAFT Description';
            DataClassification = ToBeClassified;
        }
        field(70; "NAV Description"; Text[100])
        {
            Caption = 'NAV Description';
            DataClassification = ToBeClassified;
        }
        field(80; "Field ID"; Integer)
        {
            Caption = 'Field ID';
            DataClassification = ToBeClassified;
            TableRelation = Field."No." where(TableNo = field("Table ID"));
        }
        field(90; "Field Name"; Text[50])
        {
            CalcFormula = lookup(Field.FieldName where(TableNo = field("Table ID"),
                                                        "No." = field("Field ID")));
            Caption = 'Field Name';
            Editable = false;
            FieldClass = FlowField;
        }
        field(100; "WHT Tax Percent"; Decimal)
        {
            Caption = 'WHT Tax Percent';
            DataClassification = ToBeClassified;
        }
        field(10000; "G/L Entries Exists"; Boolean)
        {
            Caption = 'G/L Entries Exists';
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Mapping Range Code", "NFT Type", "Table ID", "NAV Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

