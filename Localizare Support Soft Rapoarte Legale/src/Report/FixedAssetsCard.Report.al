report 71309 "SSA Fixed Assets Card"
{
    // SSA1006 SSCAT 14.10.2019 73.Rapoarte legale-Fisa MF
    DefaultLayout = RDLC;
    RDLCLayout = './src/rdlc/SSAFixedAssetsCard.rdlc';
    Caption = 'Fixed Assets Card';
    PreviewMode = PrintLayout;
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem("Fixed Asset"; "Fixed Asset")
        {
            DataItemTableView = SORTING("FA Subclass Code", "Global Dimension 1 Code", "FA Location Code");
            RequestFilterFields = "No.", "FA Class Code", "FA Subclass Code", "Global Dimension 1 Code", "FA Location Code", "FA Posting Date Filter";
            column(FORMAT_TODAY_0_4_; Format(Today, 0, 4))
            {
            }
            /*
            column(CurrReport_PAGENO; CurrReport.PageNo)
            {
            }
            */
            column(USERID; UserId)
            {
            }
            column(COMPANYNAME; CompanyInfo.Name)
            {
            }
            column(Fixed_Asset__TABLECAPTION__________FAFilter; "Fixed Asset".TableCaption + ': ' + FAFilter)
            {
            }
            column(Text001___DeprBookCode; Text001 + DeprBookCode)
            {
            }
            column(Fixed_Asset__FA_Class_Code_; "FA Class Code")
            {
            }
            column(Fixed_Asset__FA_Subclass_Code_; "FA Subclass Code")
            {
            }
            column(DeprStartingDate; DeprStartingDate)
            {
            }
            column(DeprEndingDate; DeprEndingDate)
            {
            }
            column(DeprNoOfYear; DeprNoOfYear)
            {
            }
            column(DeprPercent; DeprPercent)
            {
                DecimalPlaces = 1 : 1;
            }
            column(Fixed_Asset__No__; "No.")
            {
            }
            column(Description____Description_2_; Description + "Description 2")
            {
            }
            column(AcqDocNo; AcqDocNo)
            {
            }
            column(AcquisitionCost; AcquisitionCost)
            {
            }
            column(MonthlyDepreciation; MonthlyDepreciation)
            {
            }
            column(Fixed_Asset__FA_Location_Code_; "FA Location Code")
            {
            }
            column(Text002; Text002)
            {
            }
            column(TotalFALocationAfis_1_; TotalFALocationAfis[1])
            {
            }
            column(TotalFALocationAfis_2_; TotalFALocationAfis[2])
            {
            }
            column(TotalFALocationAfis_3_; TotalFALocationAfis[3])
            {
            }
            column(Fixed_Asset__FA_Location_Code__Control66; "FA Location Code")
            {
            }
            column(Text003___FIELDCAPTION__Global_Dimension_1_Code__; Text003 + FieldCaption("Global Dimension 1 Code"))
            {
            }
            column(TotalGlobalDim1Afis_1_; TotalGlobalDim1Afis[1])
            {
            }
            column(TotalGlobalDim1Afis_2_; TotalGlobalDim1Afis[2])
            {
            }
            column(TotalGlobalDim1Afis_3_; TotalGlobalDim1Afis[3])
            {
            }
            column(Fixed_Asset__Global_Dimension_1_Code_; "Global Dimension 1 Code")
            {
            }
            column(Text004; Text004)
            {
            }
            column(TotalClassCodeAfis_1_; TotalClassCodeAfis[1])
            {
            }
            column(TotalClassCodeAfis_2_; TotalClassCodeAfis[2])
            {
            }
            column(TotalClassCodeAfis_3_; TotalClassCodeAfis[3])
            {
            }
            column(Fixed_Asset__FA_Subclass_Code__Control78; "FA Subclass Code")
            {
            }
            column(Text005; Text005)
            {
            }
            column(Total_1_; Total[1])
            {
            }
            column(Total_2_; Total[2])
            {
            }
            column(Total_3_; Total[3])
            {
            }
            column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Fixed_Assets_CardCaption; Fixed_Assets_CardCaptionLbl)
            {
            }
            column(Fixed_Asset__FA_Class_Code_Caption; FieldCaption("FA Class Code"))
            {
            }
            column(Fixed_Asset__FA_Subclass_Code_Caption; FieldCaption("FA Subclass Code"))
            {
            }
            column(DeprStartingDateCaption; DeprStartingDateCaptionLbl)
            {
            }
            column(DeprEndingDateCaption; DeprEndingDateCaptionLbl)
            {
            }
            column(DeprNoOfYearCaption; DeprNoOfYearCaptionLbl)
            {
            }
            column(DeprPercentCaption; DeprPercentCaptionLbl)
            {
            }
            column(Fixed_Asset__No__Caption; FieldCaption("No."))
            {
            }
            column(Description____Description_2_Caption; Description____Description_2_CaptionLbl)
            {
            }
            column(AcqDocNoCaption; AcqDocNoCaptionLbl)
            {
            }
            column(AcquisitionCostCaption; AcquisitionCostCaptionLbl)
            {
            }
            column(MonthlyDepreciationCaption; MonthlyDepreciationCaptionLbl)
            {
            }
            column(Fixed_Asset__FA_Location_Code_Caption; FieldCaption("FA Location Code"))
            {
            }
            column(Fixed_Asset_FA_Posting_Date_Filter; "FA Posting Date Filter")
            {
            }
            column(CompanyInfo_VATRegistrationNumber; CompanyInfo.GetVATRegistrationNumber())
            {

            }
            dataitem("FA Ledger Entry"; "FA Ledger Entry")
            {
                DataItemLink = "FA No." = FIELD("No."), "Posting Date" = FIELD("FA Posting Date Filter");
                DataItemTableView = SORTING("FA No.", "Depreciation Book Code", "FA Posting Date") WHERE("FA Posting Type" = FILTER(<> "Proceeds on Disposal" & <> "Gain/Loss"));
                column(Text007; Text007)
                {
                }
                column(FAStartBalanceLCY; FAStartBalanceLCY)
                {
                }
                column(Text006; Text006)
                {
                }
                column(Balance; Balance)
                {
                }
                column(FA_Ledger_Entry__Posting_Date_; "Posting Date")
                {
                }
                column(FA_Ledger_Entry__Document_Type_; "Document Type")
                {
                }
                column(FA_Ledger_Entry__FA_Posting_Type_; "FA Posting Type")
                {
                }
                column(FA_Ledger_Entry__Document_No__; "Document No.")
                {
                }
                column(FA_Ledger_Entry__Debit_Amount_; "Debit Amount")
                {
                }
                column(FA_Ledger_Entry__Credit_Amount_; "Credit Amount")
                {
                }
                column(Balance_Control60; Balance)
                {
                }
                column(NrCrt; NrCrt)
                {
                }
                column(FA_Ledger_Entry_Description; Description)
                {
                }
                column(Text006_Control41; Text006)
                {
                }
                column(Balance_Control42; Balance)
                {
                }
                column(Text005_Control15; Text005)
                {
                }
                column(Balance_Control50; Balance)
                {
                }
                column(FA_Ledger_Entry__Debit_Amount__Control51; "Debit Amount")
                {
                }
                column(FA_Ledger_Entry__Credit_Amount__Control62; "Credit Amount")
                {
                }
                column(No_Caption; No_CaptionLbl)
                {
                }
                column(Book_ValueCaption; Book_ValueCaptionLbl)
                {
                }
                column(FA_Ledger_Entry__Posting_Date_Caption; FieldCaption("Posting Date"))
                {
                }
                column(FA_Ledger_Entry__Document_No__Caption; FieldCaption("Document No."))
                {
                }
                column(FA_Ledger_Entry__Document_Type_Caption; FieldCaption("Document Type"))
                {
                }
                column(FA_Ledger_Entry__FA_Posting_Type_Caption; FieldCaption("FA Posting Type"))
                {
                }
                column(FA_Ledger_Entry__Debit_Amount_Caption; FieldCaption("Debit Amount"))
                {
                }
                column(FA_Ledger_Entry__Credit_Amount_Caption; FieldCaption("Credit Amount"))
                {
                }
                column(FA_Ledger_Entry_DescriptionCaption; FieldCaption(Description))
                {
                }
                column(FA_Ledger_Entry_Entry_No_; "Entry No.")
                {
                }
                column(FA_Ledger_Entry_FA_No_; "FA No.")
                {
                }

                trigger OnAfterGetRecord()
                begin
                    NrCrt := NrCrt + 1;
                    Balance := Balance + Amount;
                    if ("FA Posting Type" = "FA Posting Type"::Depreciation) and
                      ("Debit Amount" <> 0) then begin
                        "Credit Amount" := -"Debit Amount";
                        "Debit Amount" := 0;
                    end;
                end;

                trigger OnPostDataItem()
                begin
                    TotalFALocation[1] := TotalFALocation[1] + "Debit Amount";
                    TotalFALocation[2] := TotalFALocation[2] + "Credit Amount";
                    TotalFALocation[3] := TotalFALocation[3] + Balance;
                end;

                trigger OnPreDataItem()
                begin
                    SetFilter("Depreciation Book Code", '=%1', DeprBookCode);
                    "Fixed Asset".CopyFilter("FA Posting Date Filter", "Posting Date");

                    CurrReport.CreateTotals("Debit Amount", "Credit Amount");
                end;
            }

            trigger OnAfterGetRecord()
            begin
                AcquisitionCost := 0;
                MonthlyDepreciation := 0;
                FAStartBalanceLCY := 0;
                NrCrt := 0;
                NewFA := "No.";

                FADeprBook.SetFilter(FADeprBook."FA No.", '=%1', "No.");
                FADeprBook.SetFilter(FADeprBook."Depreciation Book Code", '=%1', DeprBookCode);
                if FADeprBook.Find('-') then begin
                    DeprStartingDate := FADeprBook."Depreciation Starting Date";
                    DeprEndingDate := FADeprBook."Depreciation Ending Date";
                    DeprNoOfYear := Round(FADeprBook."No. of Depreciation Years", 1);
                    if DeprNoOfYear <> 0 then
                        DeprPercent := 100 / DeprNoOfYear;

                    FALedgerEntry.Reset;
                    FALedgerEntry.SetCurrentKey("FA No.", "Depreciation Book Code", "FA Posting Category",
                                                "FA Posting Type", "FA Posting Date", "Part of Book Value", "Reclassification Entry");
                    FALedgerEntry.SetFilter(FALedgerEntry."FA No.", '=%1', "No.");
                    FALedgerEntry.SetFilter(FALedgerEntry."Depreciation Book Code", '=%1', FADeprBook."Depreciation Book Code");
                    FALedgerEntry.SetRange(FALedgerEntry."FA Posting Date", 0D, EndDate);
                    FALedgerEntry.SetFilter(FALedgerEntry."FA Posting Type", '=%1', FALedgerEntry."FA Posting Type"::"Acquisition Cost");
                    if FALedgerEntry.Find('-') then
                        AcqDocNo := FALedgerEntry."Document No.";

                    FADeprBook.SetRange("FA Posting Date Filter", 0D, EndDate);
                    FADeprBook.CalcFields("Acquisition Cost", Appreciation, "Write-Down");
                    AcquisitionCost := FADeprBook."Acquisition Cost" + FADeprBook.Appreciation + FADeprBook."Write-Down";


                    FALedgerEntry.Reset;
                    FALedgerEntry.SetCurrentKey("FA No.", "Depreciation Book Code", "FA Posting Category",
                                                "FA Posting Type", "FA Posting Date", "Part of Book Value", "Reclassification Entry");
                    FALedgerEntry.SetFilter(FALedgerEntry."FA No.", '=%1', "No.");
                    FALedgerEntry.SetRange(FALedgerEntry."FA Posting Date", 0D, EndDate);
                    FALedgerEntry.SetFilter(FALedgerEntry."FA Posting Type", '=%1', FALedgerEntry."FA Posting Type"::Depreciation);
                    FALedgerEntry.SetFilter(FALedgerEntry."FA Posting Category", '=%1', FALedgerEntry."FA Posting Category"::" ");
                    FALedgerEntry.SetFilter(FALedgerEntry."Canceled from FA No.", '=%1', '');
                    if FALedgerEntry.Find('+') then;
                    MonthlyDepreciation := FALedgerEntry."Credit Amount";
                    if BeginDate <> 0D then begin
                        FADeprBook.SetFilter("FA Posting Date Filter", '<%1', BeginDate);
                        FADeprBook.CalcFields("Book Value");
                        FAStartBalanceLCY := FADeprBook."Book Value";
                    end;
                end;

                Balance := FAStartBalanceLCY;

                if OldFA <> NewFA then begin
                    OldFA := NewFA;
                    NewFAPerPage := true;
                end else
                    NewFAPerPage := false;
            end;

            trigger OnPreDataItem()
            begin
                FooterLocationFA := true;
                FooterDepartment := true;
                FooterSubclassFA := true;
                OldFA := "No.";
                FirstTimeRun := true;
            end;
        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(DeprBookCode; DeprBookCode)
                    {
                        Caption = 'Depreciation Book Code';
                        TableRelation = "Depreciation Book";
                    }
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnPreReport()
    begin
        FAFilter := "Fixed Asset".GetFilters();
        if "Fixed Asset".GetFilter("FA Posting Date Filter") <> '' then begin
            BeginDate := "Fixed Asset".GetRangeMin("FA Posting Date Filter");
            EndDate := "Fixed Asset".GetRangeMax("FA Posting Date Filter");
        end else
            EndDate := 99991231D;
        if DeprBookCode = '' then
            Error(Text000);

        CompanyInfo.Get();
    end;

    var
        Text000: Label 'You should specify Depreciation Book Code.';
        Text001: Label 'Depreciation Book: ';
        Text002: Label 'TOTAL Amount on FA Location Code';
        Text003: Label 'TOTAL Amount on ';
        Text004: Label 'TOTAL Amount on FA Subclass Code';
        Text005: Label 'TOTAL';
        Text006: Label 'Continued';
        Text007: Label 'Initial Book Value';
        FAFilter: Text[250];
        FooterLocationFA: Boolean;
        FooterDepartment: Boolean;
        FooterSubclassFA: Boolean;
        NewFAPerPage: Boolean;
        FirstTimeRun: Boolean;
        AcqDocNo: Code[20];
        DeprBookCode: Code[20];
        NewFA: Code[10];
        OldFA: Code[10];
        BeginDate: Date;
        EndDate: Date;
        DeprStartingDate: Date;
        DeprEndingDate: Date;
        FADeprBook: Record "FA Depreciation Book";
        FALedgerEntry: Record "FA Ledger Entry";
        NrCrt: Integer;
        DeprNoOfYear: Decimal;
        DeprPercent: Decimal;
        MonthlyDepreciation: Decimal;
        Balance: Decimal;
        FAStartBalanceLCY: Decimal;
        AcquisitionCost: Decimal;
        TotalFALocation: array[3] of Decimal;
        TotalGlobalDim1: array[3] of Decimal;
        TotalClassCode: array[3] of Decimal;
        Total: array[3] of Decimal;
        TotalFALocationAfis: array[3] of Decimal;
        TotalGlobalDim1Afis: array[3] of Decimal;
        TotalClassCodeAfis: array[3] of Decimal;
        CurrReport_PAGENOCaptionLbl: Label 'Page';
        Fixed_Assets_CardCaptionLbl: Label 'Fixed Assets Card';
        DeprStartingDateCaptionLbl: Label 'Depreciation Starting Date';
        DeprEndingDateCaptionLbl: Label 'Depreciation Ending Date';
        DeprNoOfYearCaptionLbl: Label 'No. of Depreciation Years';
        DeprPercentCaptionLbl: Label 'Depreciation %';
        Description____Description_2_CaptionLbl: Label 'Description';
        AcqDocNoCaptionLbl: Label 'Document No.';
        AcquisitionCostCaptionLbl: Label 'Acquisition Cost';
        MonthlyDepreciationCaptionLbl: Label 'Monthly Depreciation';
        No_CaptionLbl: Label 'No.';
        Book_ValueCaptionLbl: Label 'Book Value';
        CompanyInfo: Record "Company Information";
}

