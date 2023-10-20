report 71319 "SSA Vendor - Trial Balance"
{
    // SSA967 SSCAT 07.10.2019 33.Funct. Filtrare pe posting group
    DefaultLayout = RDLC;
    RDLCLayout = './src/rdlc/SSA Vendor - Trial Balance.rdlc';
    ApplicationArea = All;
    Caption = 'Vendor - Trial Balance';
    PreviewMode = PrintLayout;
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem(VPG; "Vendor Posting Group")
        {
            DataItemTableView = sorting(Code);
            RequestFilterFields = "Code";
            column("Code"; Code)
            {
            }
            dataitem(Vendor; Vendor)
            {
                DataItemTableView = sorting("Vendor Posting Group");
                RequestFilterFields = "No.", "Date Filter";
                column(CompanyName; CompanyInfo.Name)
                {
                }
                column(PeriodPeriodFilter; StrSubstNo(Text003, PeriodFilter))
                {
                }
                column(VendPostGrpGroupTotal; StrSubstNo(Text005, FieldCaption("Vendor Posting Group")))
                {
                }
                column(VendTblCapVendFilter; TableCaption + ': ' + VendFilter)
                {
                }
                column(VendFilter; VendFilter)
                {
                }
                column(PeriodStartDate; Format(PeriodStartDate))
                {
                }
                column(PeriodFilter; PeriodFilter)
                {
                }
                column(FiscalYearStartDate; Format(FiscalYearStartDate))
                {
                }
                column(FiscalYearFilter; FiscalYearFilter)
                {
                }
                column(PeriodEndDate; Format(PeriodEndDate))
                {
                }
                column(YTDTotal; YTDTotal)
                {
                    AutoFormatType = 1;
                }
                column(YTDCreditAmt; YTDCreditAmt)
                {
                    AutoFormatType = 1;
                }
                column(YTDDebitAmt; YTDDebitAmt)
                {
                    AutoFormatType = 1;
                }
                column(YTDBeginBalance; YTDBeginBalance)
                {
                }
                column(PeriodCreditAmt; PeriodCreditAmt)
                {
                }
                column(PeriodDebitAmt; PeriodDebitAmt)
                {
                }
                column(PeriodBeginBalance; PeriodBeginBalance)
                {
                }
                column(Name_Vendor; Name)
                {
                    IncludeCaption = true;
                }
                column(No_Vendor; "No.")
                {
                    IncludeCaption = true;
                }
                column(TotForFrmtVendPostGrp; Text004 + Format(' ') + "Vendor Posting Group")
                {
                }
                column(VendTrialBalanceCap; VendTrialBalanceCapLbl)
                {
                }
                column(CurrReportPageNoCaption; CurrReportPageNoCaptionLbl)
                {
                }
                column(AmountsinLCYCaption; AmountsinLCYCaptionLbl)
                {
                }
                column(VendWithEntryPeriodCapt; VendWithEntryPeriodCaptLbl)
                {
                }
                column(PeriodBeginBalCap; PeriodBeginBalCapLbl)
                {
                }
                column(PeriodDebitAmtCaption; PeriodDebitAmtCaptionLbl)
                {
                }
                column(PeriodCreditAmtCaption; PeriodCreditAmtCaptionLbl)
                {
                }
                column(YTDTotalCaption; YTDTotalCaptionLbl)
                {
                }
                column(PeriodCaption; PeriodCaptionLbl)
                {
                }
                column(FiscalYearToDateCaption; FiscalYearToDateCaptionLbl)
                {
                }
                column(NetChangeCaption; NetChangeCaptionLbl)
                {
                }
                column(TotalinLCYCaption; TotalinLCYCaptionLbl)
                {
                }
                column(CompanyInfo_VATRegistrationNumber; CompanyInfo.GetVATRegistrationNumber())
                {
                }

                trigger OnAfterGetRecord()
                begin
                    //SSA967>>
                    VLE.Reset;
                    VLE.SetCurrentKey("Vendor Posting Group");
                    VLE.SetRange("Vendor Posting Group", VPG.Code);
                    VLE.SetRange("Vendor No.", Vendor."No.");
                    if VLE.IsEmpty then
                        CurrReport.Skip;

                    /*//OC
                    CalcAmounts(
                      PeriodStartDate,PeriodEndDate,
                      PeriodBeginBalance,PeriodDebitAmt,PeriodCreditAmt,YTDTotal);

                    CalcAmounts(
                      FiscalYearStartDate,PeriodEndDate,
                      YTDBeginBalance,YTDDebitAmt,YTDCreditAmt,YTDTotal);
                    */
                    CalcAmountsCustom(
                      PeriodStartDate, PeriodEndDate,
                      PeriodBeginBalance, PeriodDebitAmt, PeriodCreditAmt, YTDTotal);

                    CalcAmountsCustom(
                      FiscalYearStartDate, PeriodEndDate,
                      YTDBeginBalance, YTDDebitAmt, YTDCreditAmt, YTDTotal);
                    //SSA967<<
                end;
            }

            trigger OnAfterGetRecord()
            begin
                //SSA967>>
                VLE.Reset;
                VLE.SetCurrentKey("Vendor Posting Group");
                VLE.SetRange("Vendor Posting Group", Code);
                if VLE.IsEmpty then
                    CurrReport.Skip;

                CLEAR(PeriodBeginBalance);
                CLEAR(PeriodDebitAmt);
                CLEAR(PeriodCreditAmt);
                CLEAR(YTDTotal);
                CLEAR(YTDBeginBalance);
                CLEAR(YTDDebitAmt);
                CLEAR(YTDCreditAmt);
                CLEAR(YTDTotal);
                //SSA967<<
            end;
        }
    }

    requestpage
    {
        layout
        {
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
        PeriodFilter := Vendor.GetFilter("Date Filter");
        PeriodStartDate := Vendor.GetRangeMin("Date Filter");
        PeriodEndDate := Vendor.GetRangeMax("Date Filter");
        Vendor.SetRange("Date Filter");
        VendFilter := Vendor.GetFilters;
        Vendor.SetRange("Date Filter", PeriodStartDate, PeriodEndDate);
        AccountingPeriod.SetRange("Starting Date", 0D, PeriodEndDate);
        AccountingPeriod.SetRange("New Fiscal Year", true);
        if AccountingPeriod.FindLast then
            FiscalYearStartDate := AccountingPeriod."Starting Date"
        else
            Error(Text000, AccountingPeriod.FieldCaption("Starting Date"), AccountingPeriod.TableCaption);
        FiscalYearFilter := Format(FiscalYearStartDate) + '..' + Format(PeriodEndDate);
        CompanyInfo.Get();
    end;

    var
        Text000: Label 'It was not possible to find a %1 in %2.';
        VLE: Record "Vendor Ledger Entry";
        AccountingPeriod: Record "Accounting Period";
        PeriodBeginBalance: Decimal;
        PeriodDebitAmt: Decimal;
        PeriodCreditAmt: Decimal;
        YTDBeginBalance: Decimal;
        YTDDebitAmt: Decimal;
        YTDCreditAmt: Decimal;
        YTDTotal: Decimal;
        PeriodFilter: Text;
        FiscalYearFilter: Text;
        VendFilter: Text;
        PeriodStartDate: Date;
        PeriodEndDate: Date;
        FiscalYearStartDate: Date;
        Text003: Label 'Period: %1';
        Text004: Label 'Total for';
        Text005: Label 'Group Totals: %1';
        VendTrialBalanceCapLbl: Label 'Vendor - Trial Balance';
        CurrReportPageNoCaptionLbl: Label 'Page';
        AmountsinLCYCaptionLbl: Label 'Amounts in LCY';
        VendWithEntryPeriodCaptLbl: Label 'Only includes vendors with entries in the period';
        PeriodBeginBalCapLbl: Label 'Beginning Balance';
        PeriodDebitAmtCaptionLbl: Label 'Debit';
        PeriodCreditAmtCaptionLbl: Label 'Credit';
        YTDTotalCaptionLbl: Label 'Ending Balance';
        PeriodCaptionLbl: Label 'Period';
        FiscalYearToDateCaptionLbl: Label 'Fiscal Year-To-Date';
        NetChangeCaptionLbl: Label 'Net Change';
        TotalinLCYCaptionLbl: Label 'Total in LCY';
        CompanyInfo: Record "Company Information";

    local procedure CalcAmounts(DateFrom: Date; DateTo: Date; var BeginBalance: Decimal; var DebitAmt: Decimal; var CreditAmt: Decimal; var TotalBalance: Decimal)
    var
        VendorCopy: Record Vendor;
    begin
        VendorCopy.Copy(Vendor);
        VendorCopy.SetRange("Date Filter", 0D, DateFrom - 1);
        VendorCopy.CalcFields("Net Change (LCY)");
        BeginBalance := -VendorCopy."Net Change (LCY)";

        VendorCopy.SetRange("Date Filter", DateFrom, DateTo);
        VendorCopy.CalcFields("Debit Amount (LCY)", "Credit Amount (LCY)");
        DebitAmt := VendorCopy."Debit Amount (LCY)";
        CreditAmt := VendorCopy."Credit Amount (LCY)";

        TotalBalance := BeginBalance + DebitAmt - CreditAmt;
    end;

    local procedure CalcAmountsCustom(DateFrom: Date; DateTo: Date; var BeginBalance: Decimal; var DebitAmt: Decimal; var CreditAmt: Decimal; var TotalBalance: Decimal)
    var
        DVLE: Record "Detailed Vendor Ledg. Entry";
    begin
        //SSA967>>
        DVLE.Reset;
        DVLE.SetCurrentKey("Vendor No.", "Posting Date", "Entry Type", "Currency Code");
        DVLE.SetRange("Vendor No.", Vendor."No.");
        DVLE.SetRange("Posting Date", DateFrom, DateTo);
        DVLE.SetRange("SSA Vendor Posting Group", VPG.Code);
        DVLE.SetFilter("Entry Type", '<>%1', DVLE."Entry Type"::Application);
        DVLE.CalcSums("Debit Amount (LCY)", "Credit Amount (LCY)");
        DebitAmt := DVLE."Debit Amount (LCY)";
        CreditAmt := DVLE."Credit Amount (LCY)";
        DVLE.SetFilter("Posting Date", '<%1', DateFrom);
        DVLE.CalcSums("Amount (LCY)");
        BeginBalance += DVLE."Amount (LCY)";
        TotalBalance := BeginBalance + DebitAmt - CreditAmt;
        //SSA967<<
    end;
}
