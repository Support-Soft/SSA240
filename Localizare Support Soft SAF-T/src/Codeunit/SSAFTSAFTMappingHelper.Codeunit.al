codeunit 71902 "SSAFTSAFT Mapping Helper"
{
    // SSM2101 SSCAT 04.01.2023 SAF-T

    TableNo = "SSAFTSAFT Mapping Range";

    trigger OnRun()
    var
        SAFTNAVMapping: Record "SSAFTSAFT-NAV Mapping";
        ILE: Record "Item Ledger Entry";
    begin
        SetupCurrenciesForMapping(Rec);
        SetupCountriesForMapping(Rec);
        SetupGLAccountsForMapping(Rec);
        SetupUnitOfMeasuresForMapping(Rec);
        SetupPaymentMethodForMapping(Rec);
        SetupSAFTValuesForMapping(Rec, GlobalNFTType::"TAX-IMP - Impozite", DATABASE::"G/L Account", 0);
        SetupSAFTValuesForMapping(Rec, GlobalNFTType::"WHT - nomenclator", DATABASE::"G/L Account", 0);
        SetupTariffNoForMapping(Rec);
        UpdateMasterDataWithNoSeries;
        SetupSAFTValuesForMapping(Rec, SAFTNAVMapping."NFT Type"::"Nomenclator stocuri", DATABASE::"Item Ledger Entry", ILE.FieldNo("Document Type"));
    end;

    var
        ChartOfAccountsDoesNotExistErr: Label 'A chart of accounts does not exist in the current company.';
        StartingDateNotFilledErr: Label 'You must specify a starting date.';
        EndingDateNotFilledErr: Label 'You must specify an ending date.';
        DifferentMappingTypeErr: Label 'It is not possible to copy the mapping due to different mapping types.';
        MatchQst: Label 'Do you want to match entries with SAF-T codes?';
        NoGLAccountMappingErr: Label 'No G/L account mapping was created for range ID %1.', Comment = '%1 = any integer number';
        MappingExistsErr: Label 'Mapping for category %1 with mapping code %2 already exists for range ID %3.', Comment = '%1 = category no., %2 = mapping code, %3 = any integer number';
        MappingNotDoneErr: Label 'One or more G/L accounts do not have a mapping setup. Open the SAF-T Mapping Setup page for the selected mapping range and map each G/L account either to the  standard account or the grouping code.';
        MappingDoneErr: Label 'One or more G/L accounts already have a mapping setup. Create a new mapping range with another mapping type.';
        DimensionWithoutAnalysisCodeErr: Label 'One or more dimensions do not have a SAF-T analysis code. Open the Dimensions page and specify a SAF-T analysis code for each dimension.';
        VATPostingSetupWithoutTaxCodeErr: Label 'One or more VAT posting setup do not have a %1. Open the VAT Posting Setup page and specify %1 for each VAT posting setup combination.', Comment = '%1 = field caption';
        DefaultLbl: Label 'Default';
        FieldValueIsNotSpecifiedErr: Label '%1 is not specified', Comment = '%1 = field caption';
        GlobalNFTType: Option "TAX-IMP - Impozite","TAX-IMP - Bugete",Livrari,"Achizitii ded 100%","Achizitii ded 50%_baserate","Achizitii ded 50%_not_known","Achizitii ded 50%","Achizitii neded","Achizitii baserate","Achizitii not known","WHT - nomenclator","WHT - D207","WHT - cote","IBAN-ISO13616-1997","ISO3166-1A2 - RO Dept Codes","ISO3166-2-CountryCodes",ISO4217CurrCodes,PlanConturiBalSocCom,PlanConturiIFRS,PlanConturiIFRS_Norma39,PlanConturiBanci,PlanConturiNebancare,PlanConturiSocAsigurari,Unitati_masura,NC8_2021_TARIC3,"Nomenclator stocuri","Nomenclator imobilizari",Nomenclator_Regim_fiscal,SAFT_Nomenclator_StockChar,Nom_Tipuri_facturi,Nom_Mecanisme_plati,"An fiscal-perioade de raportare","Nomenclator tari si valuta","IBAN Validation";
        PreparingForMappingMsg: Label 'Preparring for Mapping...';


    procedure GetDefaultSAFTMappingRange(var SAFTMappingRange: Record "SSAFTSAFT Mapping Range")
    begin
        with SAFTMappingRange do
            if not FindLast then begin
                Init;
                Code := DefaultLbl;
                Insert(true);
            end;
    end;


    procedure ValidateMappingRange(var SAFTMappingRange: Record "SSAFTSAFT Mapping Range")
    begin
        if SAFTMappingRange."Starting Date" = 0D then
            Error(StartingDateNotFilledErr);
        if SAFTMappingRange."Ending Date" = 0D then
            Error(EndingDateNotFilledErr);
        SAFTMappingRange.Modify;
    end;


    procedure MatchMapping(SAFTMappingRange: Record "SSAFTSAFT Mapping Range")
    begin
        if GuiAllowed then
            if not Confirm(MatchQst, false) then
                exit;
        MatchCurrenciesLocal(SAFTMappingRange);
        MatchCountriesLocal(SAFTMappingRange);
        MatchChartOfAccountsLocal(SAFTMappingRange);
        MatchUnitOfMeasureLocal(SAFTMappingRange);
        MatchTariffNoLocal(SAFTMappingRange);
    end;

    local procedure MatchChartOfAccountsLocal(var SAFTMappingRange: Record "SSAFTSAFT Mapping Range")
    var
        SAFTMappingValues: Record "SSAFTSAFT Mapping Values";
        SAFTNAVMapping: Record "SSAFTSAFT-NAV Mapping";
        GLAccount: Record "G/L Account";
        MatchedCount: Integer;
    begin
        SAFTMappingValues.SetRange("NFT Type", SAFTMappingRange."Chart of Account NFT");
        SAFTMappingValues.FindSet;
        repeat
            if GLAccount.Get(SAFTMappingValues."SAFT Code") and (GLAccount."Account Type" = GLAccount."Account Type"::Posting) then begin
                SAFTNAVMapping.Init;
                SAFTNAVMapping."Mapping Range Code" := SAFTMappingRange.Code;
                SAFTNAVMapping."NFT Type" := SAFTMappingValues."NFT Type";
                SAFTNAVMapping."Table ID" := DATABASE::"G/L Account";
                SAFTNAVMapping."NAV Code" := GLAccount."No.";
                SAFTNAVMapping."SAFT Code" := SAFTMappingValues."SAFT Code";
                SAFTNAVMapping."SAFT Description" := SAFTMappingValues."SAFT Description";
                SAFTNAVMapping."NAV Description" := GLAccount.Name;
                if not SAFTNAVMapping.Insert(true) then
                    SAFTNAVMapping.Modify(true);

                MatchedCount += 1;
            end;
        until SAFTMappingValues.Next = 0;
    end;

    local procedure MatchCurrenciesLocal(var SAFTMappingRange: Record "SSAFTSAFT Mapping Range")
    var
        SAFTMappingValues: Record "SSAFTSAFT Mapping Values";
        SAFTNAVMapping: Record "SSAFTSAFT-NAV Mapping";
        Currency: Record Currency;
        MatchedCount: Integer;
    begin
        SAFTMappingValues.SetRange("NFT Type", GlobalNFTType::ISO4217CurrCodes);
        SAFTMappingValues.FindSet;
        repeat
            if Currency.Get(SAFTMappingValues."SAFT Code") then begin
                SAFTNAVMapping.Init;
                SAFTNAVMapping."Mapping Range Code" := SAFTMappingRange.Code;
                SAFTNAVMapping."NFT Type" := SAFTMappingValues."NFT Type";
                SAFTNAVMapping."Table ID" := DATABASE::Currency;
                SAFTNAVMapping."NAV Code" := Currency.Code;
                SAFTNAVMapping."SAFT Code" := SAFTMappingValues."SAFT Code";
                SAFTNAVMapping."SAFT Description" := SAFTMappingValues."SAFT Description";
                SAFTNAVMapping."NAV Description" := Currency.Description;
                if not SAFTNAVMapping.Insert(true) then
                    SAFTNAVMapping.Modify(true);

                MatchedCount += 1;
            end;
        until SAFTMappingValues.Next = 0;
    end;

    local procedure MatchCountriesLocal(var SAFTMappingRange: Record "SSAFTSAFT Mapping Range")
    var
        SAFTMappingValues: Record "SSAFTSAFT Mapping Values";
        SAFTNAVMapping: Record "SSAFTSAFT-NAV Mapping";
        CountryRegion: Record "Country/Region";
        MatchedCount: Integer;
    begin
        SAFTMappingValues.SetRange("NFT Type", GlobalNFTType::"ISO3166-2-CountryCodes");
        SAFTMappingValues.FindSet;
        repeat
            if CountryRegion.Get(SAFTMappingValues."SAFT Code") then begin
                SAFTNAVMapping.Init;
                SAFTNAVMapping."Mapping Range Code" := SAFTMappingRange.Code;
                SAFTNAVMapping."NFT Type" := SAFTMappingValues."NFT Type";
                SAFTNAVMapping."Table ID" := DATABASE::"Country/Region";
                SAFTNAVMapping."NAV Code" := CountryRegion.Code;
                SAFTNAVMapping."SAFT Code" := SAFTMappingValues."SAFT Code";
                SAFTNAVMapping."SAFT Description" := SAFTMappingValues."SAFT Description";
                SAFTNAVMapping."NAV Description" := CountryRegion.Name;
                if not SAFTNAVMapping.Insert(true) then
                    SAFTNAVMapping.Modify(true);

                MatchedCount += 1;
            end;
        until SAFTMappingValues.Next = 0;
    end;

    local procedure MatchUnitOfMeasureLocal(var SAFTMappingRange: Record "SSAFTSAFT Mapping Range")
    var
        SAFTMappingValues: Record "SSAFTSAFT Mapping Values";
        SAFTNAVMapping: Record "SSAFTSAFT-NAV Mapping";
        UnitofMeasure: Record "Unit of Measure";
        MatchedCount: Integer;
    begin
        SAFTMappingValues.SetRange("NFT Type", GlobalNFTType::Unitati_masura);
        SAFTMappingValues.FindSet;
        repeat
            if UnitofMeasure.Get(SAFTMappingValues."SAFT Code") then begin
                SAFTNAVMapping.Init;
                SAFTNAVMapping."Mapping Range Code" := SAFTMappingRange.Code;
                SAFTNAVMapping."NFT Type" := SAFTMappingValues."NFT Type";
                SAFTNAVMapping."Table ID" := DATABASE::"Unit of Measure";
                SAFTNAVMapping."NAV Code" := UnitofMeasure.Code;
                SAFTNAVMapping."SAFT Code" := SAFTMappingValues."SAFT Code";
                SAFTNAVMapping."SAFT Description" := SAFTMappingValues."SAFT Description";
                SAFTNAVMapping."NAV Description" := UnitofMeasure.Description;
                if not SAFTNAVMapping.Insert(true) then
                    SAFTNAVMapping.Modify(true);

                MatchedCount += 1;
            end;
        until SAFTMappingValues.Next = 0;
    end;

    local procedure MatchTariffNoLocal(var SAFTMappingRange: Record "SSAFTSAFT Mapping Range")
    var
        SAFTMappingValues: Record "SSAFTSAFT Mapping Values";
        SAFTNAVMapping: Record "SSAFTSAFT-NAV Mapping";
        TariffNumber: Record "Tariff Number";
        MatchedCount: Integer;
    begin
        SAFTMappingValues.SetRange("NFT Type", GlobalNFTType::NC8_2021_TARIC3);
        SAFTMappingValues.FindSet;
        repeat
            if TariffNumber.Get(SAFTMappingValues."SAFT Code") then begin
                SAFTNAVMapping.Init;
                SAFTNAVMapping."Mapping Range Code" := SAFTMappingRange.Code;
                SAFTNAVMapping."NFT Type" := SAFTMappingValues."NFT Type";
                SAFTNAVMapping."Table ID" := DATABASE::"Tariff Number";
                SAFTNAVMapping."NAV Code" := TariffNumber."No.";
                SAFTNAVMapping."SAFT Code" := SAFTMappingValues."SAFT Code";
                SAFTNAVMapping."SAFT Description" := SAFTMappingValues."SAFT Description";
                SAFTNAVMapping."NAV Description" := TariffNumber.Description;
                if not SAFTNAVMapping.Insert(true) then
                    SAFTNAVMapping.Modify(true);

                MatchedCount += 1;
            end;
        until SAFTMappingValues.Next = 0;
    end;


    procedure CopyMapping(FromMappingRangeCode: Code[20]; ToMappingRangecode: Code[20]; Replace: Boolean)
    var
        FromSAFTMappingRange: Record "SSAFTSAFT Mapping Range";
        ToSAFTMappingRange: Record "SSAFTSAFT Mapping Range";
        FromSAFTNAVMapping: Record "SSAFTSAFT-NAV Mapping";
        ToSAFTNAVMapping: Record "SSAFTSAFT-NAV Mapping";
    begin
        FromSAFTMappingRange.Get(FromMappingRangeCode);
        ToSAFTMappingRange.Get(ToMappingRangecode);
        if FromSAFTMappingRange."Chart of Account NFT" <> ToSAFTMappingRange."Chart of Account NFT" then
            Error(DifferentMappingTypeErr);

        FromSAFTNAVMapping.SetRange("Mapping Range Code", FromMappingRangeCode);
        if not FromSAFTNAVMapping.FindSet then
            Error(NoGLAccountMappingErr, FromSAFTNAVMapping);
        repeat
            ToSAFTNAVMapping := FromSAFTNAVMapping;
            ToSAFTNAVMapping."Mapping Range Code" := ToMappingRangecode;
            if not ToSAFTNAVMapping.Insert then
                if Replace then
                    ToSAFTNAVMapping.Modify
                else
                    Error(
                      MappingExistsErr, '',
                      ToSAFTNAVMapping."NAV Code", ToSAFTNAVMapping."Mapping Range Code");
        until FromSAFTNAVMapping.Next = 0;
    end;

    local procedure SetupCurrenciesForMapping(SAFTMappingRange: Record "SSAFTSAFT Mapping Range")
    var
        Currency: Record Currency;
        SAFTNAVMapping: Record "SSAFTSAFT-NAV Mapping";
        Window: Dialog;
    begin
        if GuiAllowed then
            Window.Open(PreparingForMappingMsg);
        if Currency.FindSet then
            repeat
                SAFTNAVMapping.Init;
                SAFTNAVMapping."Mapping Range Code" := SAFTMappingRange.Code;
                SAFTNAVMapping."NFT Type" := SAFTNAVMapping."NFT Type"::ISO4217CurrCodes;
                SAFTNAVMapping."NAV Code" := Currency.Code;
                SAFTNAVMapping."NAV Description" := Currency.Description;
                SAFTNAVMapping."Table ID" := DATABASE::Currency;
                if not SAFTNAVMapping.Find then
                    SAFTNAVMapping.Insert;
            until Currency.Next = 0;

        if GuiAllowed then
            Window.Close;
    end;

    local procedure SetupCountriesForMapping(SAFTMappingRange: Record "SSAFTSAFT Mapping Range")
    var
        CountryRegion: Record "Country/Region";
        SAFTNAVMapping: Record "SSAFTSAFT-NAV Mapping";
        Window: Dialog;
    begin
        SAFTMappingRange.TestField("Starting Date");
        SAFTMappingRange.TestField("Ending Date");
        if GuiAllowed then
            Window.Open(PreparingForMappingMsg);

        if CountryRegion.FindSet then
            repeat
                SAFTNAVMapping.Init;
                SAFTNAVMapping."Mapping Range Code" := SAFTMappingRange.Code;
                SAFTNAVMapping."NFT Type" := SAFTNAVMapping."NFT Type"::"ISO3166-2-CountryCodes";
                SAFTNAVMapping."NAV Code" := CountryRegion.Code;
                SAFTNAVMapping."NAV Description" := CountryRegion.Name;
                SAFTNAVMapping."Table ID" := DATABASE::"Country/Region";

                if not SAFTNAVMapping.Find then
                    SAFTNAVMapping.Insert;
            until CountryRegion.Next = 0;

        if GuiAllowed then
            Window.Close;
    end;

    local procedure SetupGLAccountsForMapping(SAFTMappingRange: Record "SSAFTSAFT Mapping Range")
    var
        GLAccount: Record "G/L Account";
        SAFTNAVMapping: Record "SSAFTSAFT-NAV Mapping";
        Window: Dialog;
    begin
        SAFTMappingRange.TestField("Chart of Account NFT");
        SAFTMappingRange.TestField("Starting Date");
        SAFTMappingRange.TestField("Ending Date");
        if GuiAllowed then
            Window.Open(PreparingForMappingMsg);
        GetGLAccountForMapping(GLAccount);
        repeat
            SAFTNAVMapping.Init;
            SAFTNAVMapping."Mapping Range Code" := SAFTMappingRange.Code;
            SAFTNAVMapping."NFT Type" := SAFTMappingRange."Chart of Account NFT";
            SAFTNAVMapping."NAV Code" := GLAccount."No.";
            SAFTNAVMapping."NAV Description" := GLAccount.Name;
            SAFTNAVMapping."Table ID" := DATABASE::"G/L Account";
            SAFTNAVMapping."G/L Entries Exists" :=
              GLAccNetChangeIsNotZero(
                GLAccount, SAFTMappingRange."Starting Date", SAFTMappingRange."Ending Date", true);
            if not SAFTNAVMapping.Find then
                SAFTNAVMapping.Insert;
        until GLAccount.Next = 0;
        if GuiAllowed then
            Window.Close;
    end;

    local procedure SetupUnitOfMeasuresForMapping(SAFTMappingRange: Record "SSAFTSAFT Mapping Range")
    var
        UnitofMeasure: Record "Unit of Measure";
        SAFTNAVMapping: Record "SSAFTSAFT-NAV Mapping";
        Window: Dialog;
    begin
        SAFTMappingRange.TestField("Starting Date");
        SAFTMappingRange.TestField("Ending Date");
        if GuiAllowed then
            Window.Open(PreparingForMappingMsg);
        if UnitofMeasure.FindSet then
            repeat
                SAFTNAVMapping.Init;
                SAFTNAVMapping."Mapping Range Code" := SAFTMappingRange.Code;
                SAFTNAVMapping."NFT Type" := SAFTNAVMapping."NFT Type"::Unitati_masura;
                SAFTNAVMapping."NAV Code" := UnitofMeasure.Code;
                SAFTNAVMapping."NAV Description" := UnitofMeasure.Description;
                SAFTNAVMapping."Table ID" := DATABASE::"Unit of Measure";

                if not SAFTNAVMapping.Find then
                    SAFTNAVMapping.Insert;
            until UnitofMeasure.Next = 0;

        if GuiAllowed then
            Window.Close;
    end;

    local procedure SetupPaymentMethodForMapping(SAFTMappingRange: Record "SSAFTSAFT Mapping Range")
    var
        PaymentMethod: Record "Payment Method";
        SAFTNAVMapping: Record "SSAFTSAFT-NAV Mapping";
        Window: Dialog;
    begin
        SAFTMappingRange.TestField("Starting Date");
        SAFTMappingRange.TestField("Ending Date");
        if GuiAllowed then
            Window.Open(PreparingForMappingMsg);
        if PaymentMethod.FindSet then
            repeat
                SAFTNAVMapping.Init;
                SAFTNAVMapping."Mapping Range Code" := SAFTMappingRange.Code;
                SAFTNAVMapping."NFT Type" := SAFTNAVMapping."NFT Type"::Nom_Mecanisme_plati;
                SAFTNAVMapping."NAV Code" := PaymentMethod.Code;
                SAFTNAVMapping."NAV Description" := PaymentMethod.Description;
                SAFTNAVMapping."Table ID" := DATABASE::"Payment Method";

                if not SAFTNAVMapping.Find then
                    SAFTNAVMapping.Insert;
            until PaymentMethod.Next = 0;

        if GuiAllowed then
            Window.Close;
    end;

    local procedure SetupTariffNoForMapping(SAFTMappingRange: Record "SSAFTSAFT Mapping Range")
    var
        TariffNumber: Record "Tariff Number";
        SAFTNAVMapping: Record "SSAFTSAFT-NAV Mapping";
        Window: Dialog;
    begin
        SAFTMappingRange.TestField("Starting Date");
        SAFTMappingRange.TestField("Ending Date");
        if GuiAllowed then
            Window.Open(PreparingForMappingMsg);
        if TariffNumber.FindSet then
            repeat
                SAFTNAVMapping.Init;
                SAFTNAVMapping."Mapping Range Code" := SAFTMappingRange.Code;
                SAFTNAVMapping."NFT Type" := SAFTNAVMapping."NFT Type"::NC8_2021_TARIC3;
                SAFTNAVMapping."NAV Code" := TariffNumber."No.";
                SAFTNAVMapping."NAV Description" := TariffNumber.Description;
                SAFTNAVMapping."Table ID" := DATABASE::"Tariff Number";

                if not SAFTNAVMapping.Find then
                    SAFTNAVMapping.Insert;
            until TariffNumber.Next = 0;

        if GuiAllowed then
            Window.Close;
    end;

    local procedure SetupSAFTValuesForMapping(SAFTMappingRange: Record "SSAFTSAFT Mapping Range"; NFTType: Integer; TableID: Integer; FieldID: Integer)
    var
        SAFTNAVMapping: Record "SSAFTSAFT-NAV Mapping";
        SAFTMappingValues: Record "SSAFTSAFT Mapping Values";
        Window: Dialog;
        i: Integer;
    begin
        if GuiAllowed then
            Window.Open(PreparingForMappingMsg);

        Clear(i);
        SAFTMappingValues.Reset;
        SAFTMappingValues.SetRange("NFT Type", NFTType);
        if SAFTMappingValues.FindSet then
            repeat
                Clear(SAFTNAVMapping);
                SAFTNAVMapping.SetRange("Mapping Range Code", SAFTMappingRange.Code);
                SAFTNAVMapping.SetRange("NFT Type", SAFTMappingValues."NFT Type");
                SAFTNAVMapping.SetRange("SAFT Code", SAFTMappingValues."SAFT Code");
                if SAFTNAVMapping.IsEmpty then begin
                    SAFTNAVMapping.Init;
                    SAFTNAVMapping."Mapping Range Code" := SAFTMappingRange.Code;
                    SAFTNAVMapping."NFT Type" := SAFTMappingValues."NFT Type";
                    SAFTNAVMapping."SAFT Code" := SAFTMappingValues."SAFT Code";
                    SAFTNAVMapping."SAFT Description" := SAFTMappingValues."SAFT Description";
                    SAFTNAVMapping."Table ID" := TableID;
                    SAFTNAVMapping."Field ID" := FieldID;
                    i += 1;
                    SAFTNAVMapping."NAV Code" := StrSubstNo('NM %1', i);
                    SAFTNAVMapping.Insert;
                end;
            until SAFTMappingValues.Next = 0;

        if GuiAllowed then
            Window.Close;
    end;

    local procedure GetGLAccountForMapping(var GLAccount: Record "G/L Account")
    begin
        GLAccount.SetRange("Account Type", GLAccount."Account Type"::Posting);
        if not GLAccount.FindSet then
            Error(ChartOfAccountsDoesNotExistErr);
    end;


    procedure UpdateGLEntriesExistStateForGLAccMapping(MappingRangeCode: Code[20])
    var
        SAFTMappingRange: Record "SSAFTSAFT Mapping Range";
        SAFTNAVMapping: Record "SSAFTSAFT-NAV Mapping";
    begin
        if MappingRangeCode = '' then
            exit;
        if not SAFTMappingRange.Get(MappingRangeCode) then
            exit;
        SAFTNAVMapping.SetRange("NFT Type", SAFTMappingRange."Chart of Account NFT");
        SAFTNAVMapping.SetRange("Mapping Range Code", SAFTMappingRange.Code);
        if SAFTNAVMapping.FindSet then
            repeat
                SAFTNAVMapping.Validate("G/L Entries Exists",
                  GLAccHasEntries(
                    SAFTNAVMapping."NAV Code", SAFTMappingRange."Starting Date",
                    SAFTMappingRange."Ending Date", true));
                SAFTNAVMapping.Modify(true);
            until SAFTNAVMapping.Next = 0;
    end;

    procedure GLAccHasEntries(GLAccNo: Code[20]; StartingDate: Date; EndingDate: Date; IncludeIncomingBalance: Boolean): Boolean
    var
        GLAccount: Record "G/L Account";
    begin
        GLAccount.Get(GLAccNo);
        exit(GLAccNetChangeIsNotZero(GLAccount, StartingDate, EndingDate, IncludeIncomingBalance));
    end;

    local procedure GLAccNetChangeIsNotZero(GLAccount: Record "G/L Account"; StartingDate: Date; EndingDate: Date; IncludeIncomingBalance: Boolean): Boolean
    var
        GLEntry: Record "G/L Entry";
    begin
        GLAccount.SetRange("Date Filter", 0D, ClosingDate(EndingDate));
        GLAccount.CalcFields("Net Change");
        //SSM1724>>
        //OC EXIT(GLAccount."Net Change" <> 0);
        GLEntry.Reset;
        GLEntry.SetCurrentKey("G/L Account No.", "Posting Date");
        GLEntry.SetRange("G/L Account No.", GLAccount."No.");
        GLEntry.SetRange("Posting Date", StartingDate, ClosingDate(EndingDate));
        //SSM1724<<

        exit((GLAccount."Net Change" <> 0) or (not GLEntry.IsEmpty));
    end;


    procedure UpdateMasterDataWithNoSeries()
    var
        Dimension: Record Dimension;
    begin
        Dimension.SetRange("SSAFTSAFT Analysis Type", '');
        if Dimension.FindSet then
            repeat
                Dimension.Validate("SSAFTSAFT Analysis Type", CopyStr(Dimension.Code, 1, 9));
                Dimension.Validate("SSAFTSAFT Export", true);
                Dimension.Modify(true);
            until Dimension.Next = 0;
    end;

    local procedure InsertTempNameValueBuffer(var TempNameValueBuffer: Record "Name/Value Buffer" temporary; ID: Integer; Name: Text[250])
    begin
        TempNameValueBuffer.ID := ID;
        TempNameValueBuffer.Name := Name;
        if not TempNameValueBuffer.Insert then
            TempNameValueBuffer.Modify; // make it possible to overwrite by subscriber
    end;


    procedure VerifyMappingIsDone(var TempErrorMessage: Record "Error Message" temporary; MappingRangeCode: Code[20])
    var
        SAFTNAVMapping: Record "SSAFTSAFT-NAV Mapping";
        SAFTMappingRange: Record "SSAFTSAFT Mapping Range";
        SAFTMappingHelper: Codeunit "SSAFTSAFT Mapping Helper";
    begin
        SAFTMappingHelper.UpdateGLEntriesExistStateForGLAccMapping(MappingRangeCode);

        SAFTMappingRange.Get(MappingRangeCode);

        SAFTNAVMapping.SetRange("NFT Type", SAFTMappingRange."Chart of Account NFT");
        SAFTNAVMapping.SetRange("Mapping Range Code", MappingRangeCode);
        SAFTNAVMapping.SetRange("SAFT Code", '');
        SAFTNAVMapping.SetRange("G/L Entries Exists", true);
        if not SAFTNAVMapping.IsEmpty then begin
            LogError(TempErrorMessage, SAFTMappingRange, MappingNotDoneErr);
        end;
    end;


    procedure VerifyNoMappingDone(SAFTMappingRange: Record "SSAFTSAFT Mapping Range")
    var
        SAFTNAVMapping: Record "SSAFTSAFT-NAV Mapping";
    begin
        SAFTNAVMapping.SetRange("NFT Type", SAFTMappingRange."Chart of Account NFT");
        SAFTNAVMapping.SetRange("Mapping Range Code", SAFTMappingRange.Code);
        SAFTNAVMapping.SetFilter("SAFT Code", '<>%1', '');
        if not SAFTNAVMapping.IsEmpty then
            Error(MappingDoneErr);
    end;


    procedure VerifyDimensionsHaveAnalysisCode(var TempErrorMessage: Record "Error Message" temporary)
    var
        Dimension: Record Dimension;
        DimensionValue: Record "Dimension Value";
    begin
        Dimension.Reset;
        Dimension.SetRange("SSAFTSAFT Export", true);
        if not Dimension.FindSet then
            exit;

        repeat
            if Dimension."SSAFTSAFT Analysis Type" = '' then
                LogError(TempErrorMessage, Dimension, DimensionWithoutAnalysisCodeErr);
            DimensionValue.SetRange("Dimension Code", Dimension.Code);
            if DimensionValue.FindSet then
                repeat
                    if DimensionValue.Name = '' then
                        TempErrorMessage.LogMessage(
                          DimensionValue, DimensionValue.FieldNo(Name), TempErrorMessage."Message Type"::Error,
                          StrSubstNo(FieldValueIsNotSpecifiedErr, DimensionValue.FieldCaption(Name)));
                until DimensionValue.Next = 0;
        until Dimension.Next = 0;

        Dimension.SetRange("SSAFTSAFT Analysis Type", '');
        if not Dimension.IsEmpty then
            LogError(TempErrorMessage, Dimension, DimensionWithoutAnalysisCodeErr);
    end;


    procedure VerifyVATPostingSetupHasTaxCodes(var TempErrorMessage: Record "Error Message" temporary)
    var
        VATPostingSetup: Record "VAT Posting Setup";
    begin
        if VATPostingSetup.IsEmpty then
            exit;
        VATPostingSetup.SetRange("SSAFTSAFT Tax Code", '');
        if not VATPostingSetup.IsEmpty then
            LogFieldError(
              TempErrorMessage, VATPostingSetup, VATPostingSetup.FieldNo("SSAFTSAFT Tax Code"),
              StrSubstNo(VATPostingSetupWithoutTaxCodeErr, VATPostingSetup.FieldCaption("SSAFTSAFT Tax Code")));
    end;


    procedure GetGLAccountsMappedInfo(MappingRangeCode: Code[20]): Text[20]
    var
        SAFTMappingRange: Record "SSAFTSAFT Mapping Range";
        SAFTNAVMapping: Record "SSAFTSAFT-NAV Mapping";
        TotalCount: Integer;
    begin
        SAFTMappingRange.Get(MappingRangeCode);
        SAFTNAVMapping.SetRange("NFT Type", SAFTMappingRange."Chart of Account NFT");
        SAFTNAVMapping.SetRange("Mapping Range Code", MappingRangeCode);
        TotalCount := SAFTNAVMapping.Count;
        SAFTNAVMapping.SetFilter("SAFT Code", '<>%1', '');
        exit(StrSubstNo('%1/%2', SAFTNAVMapping.Count, TotalCount));
    end;

    local procedure LogError(var TempErrorMessage: Record "Error Message" temporary; SourceVariant: Variant; ErrorMessageText: Text)
    begin
        if not GuiAllowed then
            Error(ErrorMessageText);
        TempErrorMessage.LogMessage(SourceVariant, 0, TempErrorMessage."Message Type"::Error, ErrorMessageText);
    end;

    local procedure LogFieldError(var TempErrorMessage: Record "Error Message" temporary; SourceVariant: Variant; SourceFieldNo: Integer; ErrorMessageText: Text)
    begin
        if not GuiAllowed then
            Error(ErrorMessageText);
        TempErrorMessage.LogMessage(SourceVariant, SourceFieldNo, TempErrorMessage."Message Type"::Error, ErrorMessageText);
    end;


    procedure VerifyMappingIsDoneUOM(var TempErrorMessage: Record "Error Message" temporary; MappingRangeCode: Code[20])
    var
        UnitofMeasure: Record "Unit of Measure";
        SAFTNAVMapping: Record "SSAFTSAFT-NAV Mapping";
        SAFTMappingRange: Record "SSAFTSAFT Mapping Range";
    begin
        SAFTMappingRange.Get(MappingRangeCode);

        SAFTNAVMapping.Reset;
        SAFTNAVMapping.SetRange("Mapping Range Code", MappingRangeCode);
        SAFTNAVMapping.SetRange("Table ID", DATABASE::"Unit of Measure");
        UnitofMeasure.Reset;
        if UnitofMeasure.FindSet then
            repeat
                SAFTNAVMapping.SetRange("NAV Code", UnitofMeasure.Code);
                if not SAFTNAVMapping.FindFirst then
                    LogError(TempErrorMessage, SAFTMappingRange, 'Mapping Not Done Units of Measure.');

            until UnitofMeasure.Next = 0;
    end;


    procedure VerifyMappingIsDonePaymentMethod(var TempErrorMessage: Record "Error Message" temporary; MappingRangeCode: Code[20])
    var
        PaymentMethod: Record "Payment Method";
        SAFTNAVMapping: Record "SSAFTSAFT-NAV Mapping";
        SAFTMappingRange: Record "SSAFTSAFT Mapping Range";
    begin
        SAFTMappingRange.Get(MappingRangeCode);

        SAFTNAVMapping.Reset;
        SAFTNAVMapping.SetRange("Mapping Range Code", MappingRangeCode);
        SAFTNAVMapping.SetRange("Table ID", DATABASE::"Payment Method");
        PaymentMethod.Reset;
        if PaymentMethod.FindSet then
            repeat
                SAFTNAVMapping.SetRange("NAV Code", PaymentMethod.Code);
                if not SAFTNAVMapping.FindFirst then
                    LogError(TempErrorMessage, SAFTMappingRange, StrSubstNo('Mapping Not Done Payment Method %1.', PaymentMethod.Code));

            until PaymentMethod.Next = 0;
    end;
}

