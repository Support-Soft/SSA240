table 71902 "SSAFT Mapping Values"
{
    // SSM2101 SSCAT 04.01.2023 SAF-T

    Caption = 'SSAFT Mapping Values';
    DrillDownPageID = "SSAFT Mapping Values";
    LookupPageID = "SSAFT Mapping Values";

    fields
    {
        field(1; "NFT Type"; Option)
        {
            Caption = 'NFT Type';
            DataClassification = ToBeClassified;
            OptionMembers = "TAX-IMP - Impozite","TAX-IMP - Bugete",Livrari,"Achizitii ded 100%","Achizitii ded 50%_baserate","Achizitii ded 50%_not_known","Achizitii ded 50%","Achizitii neded","Achizitii baserate","Achizitii not known","WHT - nomenclator","WHT - D207","WHT - cote","IBAN-ISO13616-1997","ISO3166-1A2 - RO Dept Codes","ISO3166-2-CountryCodes",ISO4217CurrCodes,PlanConturiBalSocCom,PlanConturiIFRS,PlanConturiIFRS_Norma39,PlanConturiBanci,PlanConturiNebancare,PlanConturiSocAsigurari,Unitati_masura,NC8_2021_TARIC3,"Nomenclator stocuri","Nomenclator imobilizari",Nomenclator_Regim_fiscal,SAFT_Nomenclator_StockChar,Nom_Tipuri_facturi,Nom_Mecanisme_plati,"An fiscal-perioade de raportare","Nomenclator tari si valuta","IBAN Validation";
        }
        field(10; "SAFT Code"; Code[50])
        {
            Caption = 'SAFT Code';
            DataClassification = ToBeClassified;
        }
        field(20; "SAFT Description"; Text[250])
        {
            Caption = 'SAFT Description';
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "NFT Type", "SAFT Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "SAFT Code", "SAFT Description")
        {
        }
    }
}

