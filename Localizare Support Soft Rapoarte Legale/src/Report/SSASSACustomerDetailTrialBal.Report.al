report 71316 "SSACustomer - Detail Trial Bal"
{
    // SSA967 SSCAT 07.10.2019 33.Funct. Filtrare pe posting group
    DefaultLayout = RDLC;
    RDLCLayout = './src/rdlc/SSACustomer - Detail Trial Bal.rdlc';
    ApplicationArea = All;
    Caption = 'Customer - Detail Trial Bal.';
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem(CustomerPostingGroup; "Customer Posting Group")
        {
            RequestFilterFields = "Code";
            dataitem(Customer; Customer)
            {
                DataItemTableView = sorting("No.");
                PrintOnlyIfDetail = true;
                RequestFilterFields = "No.", "Search Name", "Date Filter";
                column(TodayFormatted; Format(Today))
                {
                }
                column(PeriodCustDatetFilter; StrSubstNo(Text000, CustDateFilter))
                {
                }
                column(CompanyName; CompanyInfo.Name)
                {
                }
                column(PrintAmountsInLCY; PrintAmountsInLCY)
                {
                }
                column(ExcludeBalanceOnly; ExcludeBalanceOnly)
                {
                }
                column(PrintDebitCredit; PrintDebitCredit)
                {
                }
                column(CustFilterCaption; TableCaption + ': ' + CustFilter)
                {
                }
                column(CustFilter; CustFilter)
                {
                }
                column(AmountCaption; AmountCaption)
                {
                }
                column(DebitAmountCaption; DebitLbl)
                {
                }
                column(CreditAmountCaption; CreditLbl)
                {
                }
                column(RemainingAmtCaption; RemainingAmtCaption)
                {
                }
                column(No_Cust; "No.")
                {
                }
                column(Name_Cust; Name)
                {
                }
                column(PageGroupNo; PageGroupNo)
                {
                }
                column(StartBalanceLCY; StartBalanceLCY)
                {
                    AutoFormatType = 1;
                }
                column(CustBalanceLCY; CustBalanceLCY)
                {
                    AutoFormatType = 1;
                }
                column(CustLedgerEntryAmtLCY; "Cust. Ledger Entry"."Amount (LCY)")
                {
                    AutoFormatType = 1;
                }
                column(CustDetailTrialBalCaption; CustDetailTrialBalCaptionLbl)
                {
                }
                column(PageNoCaption; PageNoCaptionLbl)
                {
                }
                column(AllAmtsLCYCaption; AllAmtsLCYCaptionLbl)
                {
                }
                column(RepInclCustsBalCptn; RepInclCustsBalCptnLbl)
                {
                }
                column(PostingDateCaption; PostingDateCaptionLbl)
                {
                }
                column(DueDateCaption; DueDateCaptionLbl)
                {
                }
                column(BalanceLCYCaption; BalanceLCYCaptionLbl)
                {
                }
                column(AdjOpeningBalCaption; AdjOpeningBalCaptionLbl)
                {
                }
                column(BeforePeriodCaption; BeforePeriodCaptionLbl)
                {
                }
                column(TotalCaption; TotalCaptionLbl)
                {
                }
                column(OpeningBalCaption; OpeningBalCaptionLbl)
                {
                }
                column(ExternalDocNoCaption; ExternalDocNoCaptionLbl)
                {
                }
                column(CompanyInfo_VATRegistrationNumber; CompanyInfo.GetVATRegistrationNumber())
                {
                }
                dataitem("Cust. Ledger Entry"; "Cust. Ledger Entry")
                {
                    DataItemLink = "Customer No." = field("No."), "Posting Date" = field("Date Filter"), "Global Dimension 2 Code" = field("Global Dimension 2 Filter"), "Global Dimension 1 Code" = field("Global Dimension 1 Filter"), "Date Filter" = field("Date Filter");
                    DataItemTableView = sorting("Customer No.", "Posting Date");
                    column(PostDate_CustLedgEntry; Format("Posting Date"))
                    {
                    }
                    column(DocType_CustLedgEntry; "Document Type")
                    {
                        IncludeCaption = true;
                    }
                    column(DocNo_CustLedgEntry; "Document No.")
                    {
                        IncludeCaption = true;
                    }
                    column(ExtDocNo_CustLedgEntry; "External Document No.")
                    {
                    }
                    column(Desc_CustLedgEntry; Description)
                    {
                        IncludeCaption = true;
                    }
                    column(CustAmount; CustAmount)
                    {
                        AutoFormatExpression = CustCurrencyCode;
                        AutoFormatType = 1;
                    }
                    column(CustDebitAmount; CustDebitAmount)
                    {
                        AutoFormatExpression = CustCurrencyCode;
                        AutoFormatType = 1;
                    }
                    column(CustCreditAmount; CustCreditAmount)
                    {
                        AutoFormatExpression = CustCurrencyCode;
                        AutoFormatType = 1;
                    }
                    column(CustRemainAmount; CustRemainAmount)
                    {
                        AutoFormatExpression = CustCurrencyCode;
                        AutoFormatType = 1;
                    }
                    column(CustEntryDueDate; Format(CustEntryDueDate))
                    {
                    }
                    column(EntryNo_CustLedgEntry; "Entry No.")
                    {
                        IncludeCaption = true;
                    }
                    column(CustCurrencyCode; CustCurrencyCode)
                    {
                    }
                    column(CustBalanceLCY1; CustBalanceLCY)
                    {
                        AutoFormatType = 1;
                    }

                    trigger OnAfterGetRecord()
                    begin
                        CustLedgEntryExists := true;
                        if PrintAmountsInLCY then begin
                            CustAmount := "Amount (LCY)";
                            CustRemainAmount := "Remaining Amt. (LCY)";
                            CustCurrencyCode := '';
                        end else begin
                            CustAmount := Amount;
                            CustRemainAmount := "Remaining Amount";
                            CustCurrencyCode := "Currency Code";
                        end;
                        CustDebitAmount := 0;
                        CustCreditAmount := 0;
                        if CustAmount > 0 then
                            CustDebitAmount := CustAmount
                        else
                            CustCreditAmount := -CustAmount;
                        CustTotalDebitAmount += CustDebitAmount;
                        CustTotalCreditAmount += CustCreditAmount;

                        CustBalanceLCY := CustBalanceLCY + "Amount (LCY)";
                        if ("Document Type" = "Document Type"::Payment) or ("Document Type" = "Document Type"::Refund) then
                            CustEntryDueDate := 0D
                        else
                            CustEntryDueDate := "Due Date";
                    end;

                    trigger OnPreDataItem()
                    begin
                        CustLedgEntryExists := false;
                        CustTotalDebitAmount := 0;
                        CustTotalCreditAmount := 0;
                        CustAmount := 0;
                        CustDebitAmount := 0;
                        CustCreditAmount := 0;

                        SetAutoCalcFields(Amount, "Remaining Amount", "Amount (LCY)", "Remaining Amt. (LCY)");

                        //SSA967>>
                        if CustomerPostingGroup.Code <> '' then
                            SetFilter("Customer Posting Group", CustomerPostingGroup.Code);
                        //SSA967<<
                    end;
                }
                dataitem("Integer"; "Integer")
                {
                    DataItemTableView = sorting(Number) where(Number = const(1));
                    column(Name1_Cust; Customer.Name)
                    {
                    }
                    column(CustBalanceLCY4; CustBalanceLCY)
                    {
                        AutoFormatType = 1;
                    }
                    column(StartBalanceLCY2; StartBalanceLCY)
                    {
                    }
                    column(CustTotalDebitAmount; CustTotalDebitAmount)
                    {
                    }
                    column(CustTotalCreditAmount; CustTotalCreditAmount)
                    {
                    }

                    trigger OnAfterGetRecord()
                    begin
                        if not CustLedgEntryExists and ((StartBalanceLCY = 0) or ExcludeBalanceOnly) then begin
                            StartBalanceLCY := 0;
                            CurrReport.Skip;
                        end;
                    end;
                }

                trigger OnAfterGetRecord()
                begin
                    //
                    CLE.Reset;
                    CLE.SetCurrentKey("Customer No.", "Posting Date", "Currency Code");
                    CLE.SetRange("Customer No.", "No.");
                    CLE.SetRange("Customer Posting Group", CustomerPostingGroup.Code);
                    if CLE.IsEmpty then
                        CurrReport.Skip;
                    //SSA967<<

                    if PrintOnlyOnePerPage then
                        PageGroupNo := PageGroupNo + 1;

                    StartBalanceLCY := 0;
                    if CustDateFilter <> '' then begin
                        if GetRangeMin("Date Filter") <> 0D then begin
                            SetRange("Date Filter", 0D, GetRangeMin("Date Filter") - 1);
                            //SSA967>>
                            /*//OC
                            CALCFIELDS("Net Change (LCY)");
                            StartBalanceLCY := "Net Change (LCY)";
                            */
                            CLE.SetFilter("Date Filter", GetFilter("Date Filter"));
                            if CLE.FindSet then
                                repeat
                                    CLE.CalcFields("Remaining Amt. (LCY)");
                                    StartBalanceLCY += CLE."Remaining Amt. (LCY)";
                                until CLE.Next = 0;
                            //SSA967<<
                        end;
                        SetFilter("Date Filter", CustDateFilter);
                    end;
                    CurrReport.PrintOnlyIfDetail := ExcludeBalanceOnly or (StartBalanceLCY = 0);
                    CustBalanceLCY := StartBalanceLCY;
                end;

                trigger OnPreDataItem()
                begin
                    PageGroupNo := 1;
                    CurrReport.NewPagePerRecord := PrintOnlyOnePerPage;
                    Clear(StartBalanceLCY);
                end;
            }

            trigger OnAfterGetRecord()
            begin
                //SSA967>>
                CLE.Reset;
                CLE.SetCurrentKey("Customer Posting Group");
                CLE.SetRange("Customer Posting Group", CustomerPostingGroup.Code);
                if CLE.IsEmpty then
                    CurrReport.Skip;
                //SSA967<<
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
                    field(ShowAmountsInLCY; PrintAmountsInLCY)
                    {
                        ApplicationArea = All;
                        Caption = 'Show Amounts in LCY';
                        ToolTip = 'Specifies if the reported amounts are shown in the local currency.';
                    }
                    field(NewPageperCustomer; PrintOnlyOnePerPage)
                    {
                        ApplicationArea = All;
                        Caption = 'New Page per Customer';
                        ToolTip = 'Specifies if each customer''s information is printed on a new page if you have chosen two or more customers to be included in the report.';
                    }
                    field(ExcludeCustHaveaBalanceOnly; ExcludeBalanceOnly)
                    {
                        ApplicationArea = All;
                        Caption = 'Exclude Customers That Have a Balance Only';
                        MultiLine = true;
                        ToolTip = 'Specifies if you do not want the report to include entries for customers that have a balance but do not have a net change during the selected time period.';
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
    var
        FormatDocument: Codeunit "Format Document";
    begin
        GeneralLedgerSetup.Get;
        PrintDebitCredit := GeneralLedgerSetup."Show Amounts" = GeneralLedgerSetup."Show Amounts"::"Debit/Credit Only";
        CustFilter := FormatDocument.GetRecordFiltersWithCaptions(Customer);
        CustDateFilter := Customer.GetFilter("Date Filter");
        if PrintAmountsInLCY then begin
            AmountCaption := "Cust. Ledger Entry".FieldCaption("Amount (LCY)");
            RemainingAmtCaption := "Cust. Ledger Entry".FieldCaption("Remaining Amt. (LCY)");
        end else begin
            AmountCaption := "Cust. Ledger Entry".FieldCaption(Amount);
            RemainingAmtCaption := "Cust. Ledger Entry".FieldCaption("Remaining Amount");
        end;
        CompanyInfo.get;
    end;

    var
        Text000: Label 'Period: %1';
        GeneralLedgerSetup: Record "General Ledger Setup";
        CLE: Record "Cust. Ledger Entry";
        PrintDebitCredit: Boolean;
        PrintAmountsInLCY: Boolean;
        PrintOnlyOnePerPage: Boolean;
        ExcludeBalanceOnly: Boolean;
        CustFilter: Text;
        CustDateFilter: Text;
        AmountCaption: Text[80];
        RemainingAmtCaption: Text[30];
        CustAmount: Decimal;
        CustDebitAmount: Decimal;
        CustCreditAmount: Decimal;
        CustTotalDebitAmount: Decimal;
        CustTotalCreditAmount: Decimal;
        CustRemainAmount: Decimal;
        CustBalanceLCY: Decimal;
        CustCurrencyCode: Code[10];
        CustEntryDueDate: Date;
        StartBalanceLCY: Decimal;
        CustLedgEntryExists: Boolean;
        PageGroupNo: Integer;
        CustDetailTrialBalCaptionLbl: Label 'Customer - Detail Trial Bal.';
        PageNoCaptionLbl: Label 'Page';
        AllAmtsLCYCaptionLbl: Label 'All amounts are in LCY';
        RepInclCustsBalCptnLbl: Label 'This report also includes customers that only have balances.';
        PostingDateCaptionLbl: Label 'Posting Date';
        DueDateCaptionLbl: Label 'Due Date';
        BalanceLCYCaptionLbl: Label 'Balance (LCY)';
        AdjOpeningBalCaptionLbl: Label 'Adj. of Opening Balance';
        BeforePeriodCaptionLbl: Label 'Total (LCY) Before Period';
        TotalCaptionLbl: Label 'Total (LCY)';
        OpeningBalCaptionLbl: Label 'Total Adj. of Opening Balance';
        DebitLbl: Label 'Debit Amount';
        CreditLbl: Label 'Credit Amount';
        ExternalDocNoCaptionLbl: Label 'External Doc. No.';
        CompanyInfo: Record "Company Information";

    procedure InitializeRequest(ShowAmountInLCY: Boolean; SetPrintOnlyOnePerPage: Boolean; SetExcludeBalanceOnly: Boolean)
    begin
        PrintOnlyOnePerPage := SetPrintOnlyOnePerPage;
        PrintAmountsInLCY := ShowAmountInLCY;
        ExcludeBalanceOnly := SetExcludeBalanceOnly;
    end;
}
