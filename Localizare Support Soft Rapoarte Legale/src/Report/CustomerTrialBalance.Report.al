report 71317 "SSA Customer - Trial Balance"
{
    // SSA967 SSCAT 07.10.2019 33.Funct. Filtrare pe posting group
    DefaultLayout = RDLC;
    RDLCLayout = './src/rdlc/SSA Customer - Trial Balance.rdlc';

    AdditionalSearchTerms = 'payment due,order status';
    ApplicationArea = All;
    Caption = 'Customer - Trial Balance';
    PreviewMode = PrintLayout;
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem("Customer Posting Group"; "Customer Posting Group")
        {
            DataItemTableView = SORTING(Code);
            RequestFilterFields = "Code";
            PrintOnlyIfDetail = true;
            column(Code; Code)
            {
            }
            dataitem(Customer; Customer)
            {
                DataItemTableView = SORTING("Customer Posting Group");
                RequestFilterFields = "No.", "Date Filter";
                column(CompanyName; CompanyInfo.Name)
                {
                }
                column(PeriodFilter; StrSubstNo(Text003, PeriodFilter))
                {
                }
                column(CustFieldCaptPostingGroup; StrSubstNo(Text005, FieldCaption("Customer Posting Group")))
                {
                }
                column(CustTableCaptioncustFilter; TableCaption + ': ' + CustFilter)
                {
                }
                column(CustFilter; CustFilter)
                {
                }
                column(EmptyString; '')
                {
                }
                column(PeriodStartDate; Format(PeriodStartDate))
                {
                }
                column(PeriodFilter1; PeriodFilter)
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
                column(Name_Customer; Name)
                {
                    IncludeCaption = true;
                }
                column(No_Customer; "No.")
                {
                    IncludeCaption = true;
                }
                column(TotalPostGroup_Customer; Text004 + Format(' ') + "Customer Posting Group")
                {
                }
                column(CustTrialBalanceCaption; CustTrialBalanceCaptionLbl)
                {
                }
                column(CurrReportPageNoCaption; CurrReportPageNoCaptionLbl)
                {
                }
                column(AmtsinLCYCaption; AmtsinLCYCaptionLbl)
                {
                }
                column(inclcustentriesinperiodCaption; inclcustentriesinperiodCaptionLbl)
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
                    /*//OC
                    CalcAmounts(
                      PeriodStartDate,PeriodEndDate,
                      PeriodBeginBalance,PeriodDebitAmt,PeriodCreditAmt,YTDTotal);
                    
                    CalcAmounts(
                      FiscalYearStartDate,PeriodEndDate,
                      YTDBeginBalance,YTDDebitAmt,YTDCreditAmt,YTDTotal);
                    */
                    CLE.SetRange("Customer No.", "No.");
                    if CLE.IsEmpty then
                        CurrReport.Skip;

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
                CLE.SetCurrentKey("Customer Posting Group");
                CLE.SetRange("Customer No.");
                CLE.SetRange("Customer Posting Group", "Customer Posting Group".Code);
                if CLE.IsEmpty then
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
        PeriodBeginBalanceCaption = 'Beginning Balance';
        PeriodDebitAmtCaption = 'Debit';
        PeriodCreditAmtCaption = 'Credit';
    }

    trigger OnPreReport()
    begin
        with Customer do begin
            PeriodFilter := GetFilter("Date Filter");
            PeriodStartDate := GetRangeMin("Date Filter");
            PeriodEndDate := GetRangeMax("Date Filter");
            SetRange("Date Filter");
            CustFilter := GetFilters;
            SetRange("Date Filter", PeriodStartDate, PeriodEndDate);
            AccountingPeriod.SetRange("Starting Date", 0D, PeriodEndDate);
            AccountingPeriod.SetRange("New Fiscal Year", true);
            if AccountingPeriod.FindLast then
                FiscalYearStartDate := AccountingPeriod."Starting Date"
            else
                Error(Text000, AccountingPeriod.FieldCaption("Starting Date"), AccountingPeriod.TableCaption);
            FiscalYearFilter := Format(FiscalYearStartDate) + '..' + Format(PeriodEndDate);
        end;
        CompanyInfo.Get();
    end;

    var
        Text000: Label 'It was not possible to find a %1 in %2.';
        CLE: Record "Cust. Ledger Entry";
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
        CustFilter: Text;
        PeriodStartDate: Date;
        PeriodEndDate: Date;
        FiscalYearStartDate: Date;
        Text003: Label 'Period: %1';
        Text004: Label 'Total for';
        Text005: Label 'Group Totals: %1';
        CustTrialBalanceCaptionLbl: Label 'Customer - Trial Balance';
        CurrReportPageNoCaptionLbl: Label 'Page';
        AmtsinLCYCaptionLbl: Label 'Amounts in LCY';
        inclcustentriesinperiodCaptionLbl: Label 'Only includes customers with entries in the period';
        YTDTotalCaptionLbl: Label 'Ending Balance';
        PeriodCaptionLbl: Label 'Period';
        FiscalYearToDateCaptionLbl: Label 'Fiscal Year-To-Date';
        NetChangeCaptionLbl: Label 'Net Change';
        TotalinLCYCaptionLbl: Label 'Total in LCY';
        CompanyInfo: Record "Company Information";

    local procedure CalcAmountsCustom(DateFrom: Date; DateTo: Date; var BeginBalance: Decimal; var DebitAmt: Decimal; var CreditAmt: Decimal; var TotalBalance: Decimal)
    var
        DCLE: Record "Detailed Cust. Ledg. Entry";
    begin
        //SSA967>>
        DCLE.Reset;
        DCLE.SetCurrentKey("Customer No.", "Posting Date", "Entry Type", "Currency Code");
        DCLE.SetRange("Customer No.", Customer."No.");
        DCLE.SetRange("Posting Date", DateFrom, DateTo);
        DCLE.SetRange("SSA Customer Posting Group", "Customer Posting Group".Code);
        DCLE.SetFilter("Entry Type", '<> %1', DCLE."Entry Type"::Application);
        DCLE.CalcSums("Debit Amount (LCY)", "Credit Amount (LCY)");
        DebitAmt := DCLE."Debit Amount (LCY)";
        CreditAmt := DCLE."Credit Amount (LCY)";
        DCLE.SetFilter("Posting Date", '<%1', DateFrom);
        DCLE.CalcSums("Amount (LCY)");
        BeginBalance += DCLE."Amount (LCY)";
        TotalBalance := BeginBalance + DebitAmt - CreditAmt;
        //SSA967<<
    end;
}

