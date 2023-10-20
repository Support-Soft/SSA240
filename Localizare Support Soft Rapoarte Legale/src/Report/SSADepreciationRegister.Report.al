report 71303 "SSA Depreciation Register"
{
    // SSA1005 SSCAT 14.10.2019 72.Rapoarte legale-Registru amortizare
    DefaultLayout = RDLC;
    RDLCLayout = './src/rdlc/SSADepreciationRegister.rdlc';
    Caption = 'Depreciation Register';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    dataset
    {
        dataitem("FA Depreciation Book"; "FA Depreciation Book")
        {
            RequestFilterFields = "FA No.", "Depreciation Book Code", "FA Posting Group";
            column(PostingGroup; "FA Depreciation Book"."FA Posting Group")
            {
                IncludeCaption = true;
            }
            column(FADepreciationBook_FANo; "FA Depreciation Book"."FA No.")
            {
                IncludeCaption = true;
            }
            column(FA_Description; FixedAsset.Description + ' ' + FixedAsset."Description 2")
            {
            }
            column(NoofDepreciationMonths_FADepreciationBook; "FA Depreciation Book"."No. of Depreciation Months")
            {
                IncludeCaption = true;
            }
            column(DepreciationMethod_FADepreciationBook; "FA Depreciation Book"."Depreciation Method")
            {
                IncludeCaption = true;
            }
            column(Var_CA; CA)
            {
                IncludeCaption = false;
            }
            column(Var_AFP; AFP)
            {
            }
            column(Var_AFC; AFC)
            {
            }
            column(Var_AFCUM; AFCUM)
            {
            }
            column(Var_VALRAM; VALRAM)
            {
            }
            column(CI_Name; Text01 + ' ' + CompInfo.Name)
            {
            }
            column(Fil1; Filtru1)
            {
            }
            column(Fil2; Filtru2)
            {
            }
            column(CI_VAT; CompInfo.FieldCaption("VAT Registration No.") + ':' + ' ' + CompInfo."VAT Registration No.")
            {
            }
            column(CI_Comm; CompInfo.FieldCaption("SSA Commerce Trade No.") + ':' + ' ' + CompInfo."SSA Commerce Trade No.")
            {
            }
            column(CI_Address; CompInfo.FieldCaption(Address) + ':' + ' ' + CompInfo.Address + ' ' + CompInfo."Address 2")
            {
            }
            column(Txt_03; Title)
            {
            }
            column(Txt_16; Text16)
            {
            }
            column(Txt_10; Text10)
            {
            }
            column(Txt_11; Text11)
            {
            }
            column(Txt_17; Text17)
            {
            }
            column(DataRaport_Formated; Format(DataRaport))
            {
            }
            column(Today_Formated; Format(Today))
            {
            }
            column(FA_Inactive; Inactive)
            {
            }
            column(DepreciationStartingDate_FADepreciationBook; "FA Depreciation Book"."Depreciation Starting Date")
            {
                IncludeCaption = true;
            }
            column(COMPANYNAME; COMPANYNAME)
            {
            }

            trigger OnAfterGetRecord()
            begin

                if InventoryItems then
                    Title := Text18
                else
                    Title := Text03;

                Clear(FixedAsset);
                Clear(Inactive);
                if FixedAsset.Get("FA No.") then;
                Inactive := FixedAsset.Inactive;

                CA := 0;
                AFP := 0;
                AFC := 0;

                //calculez COSTURILE DE ACHIZITIE
                tFALE.Reset;
                tFALE.SetFilter("FA No.", "FA No.");
                tFALE.SetFilter("Depreciation Book Code", "Depreciation Book Code");
                tFALE.SetFilter("Posting Date", '<=%1', DataRaport);
                if tFALE.Find('-') then
                    repeat
                        if (tFALE."FA Posting Type" = tFALE."FA Posting Type"::"Acquisition Cost") or
                        (tFALE."FA Posting Type" = tFALE."FA Posting Type"::Appreciation) or
                        (tFALE."FA Posting Type" = tFALE."FA Posting Type"::"Write-Down")
                        then
                            CA := CA + tFALE.Amount;
                    until tFALE.Next = 0;

                //calculez AMORTIZAREA FISCALA PRECEDENTA
                tFALE.Reset;
                tFALE.SetFilter("FA No.", "FA No.");
                tFALE.SetFilter("Depreciation Book Code", "Depreciation Book Code");
                tFALE.SetFilter("Posting Date", '<=%1', StartingDate);
                if tFALE.Find('-') then
                    repeat
                        if tFALE."FA Posting Type" = tFALE."FA Posting Type"::Depreciation then
                            AFP := AFP + tFALE.Amount;
                    until tFALE.Next = 0;

                AFP := Abs(AFP);

                //calculez amortizarea fiscala curenta
                tFALE.Reset;
                tFALE.SetFilter("FA No.", "FA No.");
                tFALE.SetFilter("Depreciation Book Code", "Depreciation Book Code");
                tFALE.SetFilter("Posting Date", '%1..%2', StartingDate, EndingDate);
                tFALE.SetRange("FA Posting Type", tFALE."FA Posting Type"::Depreciation);
                if tFALE.Find('-') then
                    repeat
                        AFC := AFC + tFALE.Amount;
                    until tFALE.Next = 0;

                //calculez pe linii
                AFCUM := AFP - AFC;
                VALRAM := CA - AFCUM;

                if (CA = 0) and (AFP = 0) and (AFC = 0) and (AFCUM = 0) and (VALRAM = 0) then
                    CurrReport.Skip;
            end;

            trigger OnPreDataItem()
            begin
                CurrReport.CreateTotals(CA);
                CurrReport.CreateTotals(AFP);
                CurrReport.CreateTotals(AFC);
                CurrReport.CreateTotals(AFCUM);
                CurrReport.CreateTotals(VALRAM);
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
                    field(FiltruData; DataRaport)
                    {
                        Caption = 'Report Date';
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the Report Date field.';
                    }
                    field(InventoryItems; InventoryItems)
                    {
                        Caption = 'For Inventory Items';
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the For Inventory Items field.';
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
        lblCA = 'Acquisition Cost';
        lblAFP = 'Previous Depreciation';
        lblAFC = 'Current Depreciation';
        lblAFCUM = 'Cumulate Depreciation';
        lblVALRAM = 'Remaining Value';
        lblFA_Description = 'Description';
        lblFA_PIF = 'P.I.F. Date';
        lbl_NoOfDeprMonths = 'No. of Depr. Months';
        lblPostingGroup = 'Posting Group';
    }

    trigger OnPreReport()
    begin
        CompInfo.Get;
        if DataRaport = 0D then
            Error(Text14);
        if "FA Depreciation Book".GetFilter("Depreciation Book Code") = '' then
            Error(Text00);
        Filtru1 := "FA Depreciation Book".GetFilters;
        Filtru2 := DataRaport;

        EndingDate := CalcDate('<CM>', DataRaport);
        StartingDate := CalcDate('<-1M+CM+1D>', DataRaport);
    end;

    var
        CompInfo: Record "Company Information";
        Filtru1: Text[200];
        AFP: Decimal;
        AFC: Decimal;
        AFCUM: Decimal;
        VALRAM: Decimal;
        tFALE: Record "FA Ledger Entry";
        StartingDate: Date;
        EndingDate: Date;
        DataRaport: Date;
        CA: Decimal;
        Filtru2: Date;
        FixedAsset: Record "Fixed Asset";
        Text01: Label 'Company:';
        Text03: Label 'DEPRECIATION REGISTER';
        Text10: Label 'Report date';
        Text11: Label 'User';
        Text14: Label 'Please specify a filter for the Report Date Filter field.';
        Text00: Label 'Please specify a filter for the Depreciation Book Code  field in the   FA Ledger Entry table.                                                                                          For information about entering filters, see the online Help.';
        Text16: Label 'At date:';
        Text17: Label 'Page:';
        Inactive: Boolean;
        InventoryItems: Boolean;
        Text18: Label 'Dare în folosinţă obiecte inventar';
        Title: Text[250];
}
