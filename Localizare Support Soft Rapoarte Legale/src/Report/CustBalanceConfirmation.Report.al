report 71321 "SSA Cust. Balance Confirmation"
{
    DefaultLayout = RDLC;
    RDLCLayout = './src/rdlc/SSA Cust. Balance Confirmation.rdlc';
    UsageCategory = ReportsAndAnalysis;
    Caption = 'Customer Balance Confirmation';

    dataset
    {
        dataitem(Customer; Customer)
        {
            DataItemTableView = SORTING("No.");
            PrintOnlyIfDetail = false;
            RequestFilterFields = "No.", "Search Name", Blocked, "Date Filter";
            column(WithoutDetails; WithoutDetails)
            {
            }
            column(TodayFormatted; FORMAT(TODAY, 0, 4))
            {
            }
            column(TxtCustGeTranmaxDtFilter; STRSUBSTNO(Text000, FORMAT(GETRANGEMAX("Date Filter"))))
            {
            }
            column(PrintOnePrPage; PrintOnePrPage)
            {
            }
            column(CustFilter; CustFilter)
            {
            }
            column(PrintAmountInLCY; PrintAmountInLCY)
            {
            }
            column(CustTableCaptCustFilter; TABLECAPTION + ': ' + CustFilter)
            {
            }
            column(No_Customer; "No.")
            {
            }
            column(Name_Customer; Name)
            {
            }
            column(PhoneNo_Customer; "Phone No.")
            {
                IncludeCaption = true;
            }
            column(CustBalancetoDateCaption; CustBalancetoDateCaptionLbl)
            {
            }
            column(CurrReportPageNoCaption; CurrReportPageNoCaptionLbl)
            {
            }
            column(AllamtsareinLCYCaption; AllamtsareinLCYCaptionLbl)
            {
            }
            column(CustLedgEntryPostingDtCaption; CustLedgEntryPostingDtCaptionLbl)
            {
            }
            column(OriginalAmtCaption; OriginalAmtCaptionLbl)
            {
            }
            column(CreditUnit; CreditUnit)
            {
            }
            column(FiscalCodeID; FiscalCodeId)
            {
            }
            column(CommRegNo; CommRegNo)
            {
            }
            column(TxtLocation; TxtLocation)
            {
            }
            column(TxtCounty; TxtCounty)
            {
            }
            column(Cont; Cont)
            {
            }
            column(Banca; Banca)
            {
            }
            column(DebitUnit; DebitUnit)
            {
            }
            column(InfoName; CompanyInfo.Name)
            {
            }
            column(InfoVatRegName; CompanyInfo."VAT Registration No.")
            {
            }
            column(InfoAddress1; CompanyInfo.City + ' ' + CompanyInfo.Address)
            {
            }
            column(InfoAddress2; CompanyInfo."Address 2")
            {
            }
            column(InfoCounty; CompanyInfo.County)
            {
            }
            column(InfoIBAN; CompanyInfo.IBAN)
            {
            }
            column(InfoBankName; CompanyInfo."Bank Name")
            {
            }
            column(InfoAddressPostCode; CompanyInfo.Address + ' ' + CompanyInfo."Post Code")
            {
            }
            column(InfoComm; CompanyInfo."SSA Commerce Trade No.")
            {
            }
            column(CustVatRegName; Customer."VAT Registration No.")
            {
            }
            column(CustCommTradeNo; Customer."SSA Commerce Trade No.")
            {
            }
            column(CustAddress; Customer.City + ' ' + Customer.Address)
            {
            }
            column(CustAddress2; Customer."Address 2")
            {
            }
            column(Text001; Text001)
            {
            }
            column(StatofAcc; StatofAcc)
            {
            }
            column(MaxDate; MaxDate)
            {
            }
            column(Text002; Text002)
            {
            }
            column(Text003; Text003)
            {
            }
            column(Text004; Text004)
            {
            }
            column(Text005; Text005)
            {
            }
            column(Director; Director)
            {
            }
            column(Contabil; Contabil)
            {
            }
            column(TxtDirector; TxtDirector)
            {
            }
            column(TxtContabil; TxtContabil)
            {
            }
            column(CustNameName2; Customer.Name + ' ' + Customer."Name 2")
            {
            }
            column(CustCity; Customer.City)
            {
            }
            column(CustomerCounty; Customer.County)
            {
            }
            column(PageCaptionLbl; PageCaptionLbl)
            {
            }
            column(BalanceConfirmationLbl; BalanceConfirmationLbl)
            {
            }
            column(RegistrationNoLbl; RegistrationNoLbl)
            {
            }
            column(ExtDocNoCaption; ExtDocNoCaption)
            {
            }
            dataitem(CustLedgEntry3; "Cust. Ledger Entry")
            {
                DataItemTableView = SORTING("Entry No.");
                column(PostingDt_CustLedgEntry; FORMAT("Posting Date"))
                {
                    IncludeCaption = false;
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
                column(OriginalAmt; OriginalAmt)
                {
                    AutoFormatExpression = CurrencyCode;
                    AutoFormatType = 1;
                }
                column(RemainingAmt_CustLedgEntry; RemainingAmt)
                {
                }
                column(EntryNo_CustLedgEntry; "Entry No.")
                {
                    IncludeCaption = true;
                }
                column(CurrencyCode; CurrencyCode)
                {
                }
                column(Currency_Lbl; Currency_Lbl)
                {
                }
                dataitem("Detailed Cust. Ledg. Entry"; "Detailed Cust. Ledg. Entry")
                {
                    DataItemLink = "Cust. Ledger Entry No." = FIELD("Entry No."), "Posting Date" = FIELD("Date Filter");
                    DataItemTableView = SORTING("Cust. Ledger Entry No.", "Posting Date") WHERE("Entry Type" = FILTER(<> "Initial Entry"));
                    column(EntType_DtldCustLedgEnt; "Entry Type")
                    {
                    }
                    column(postDt_DtldCustLedgEntry; FORMAT("Posting Date"))
                    {
                    }
                    column(DocType_DtldCustLedgEntry; "Document Type")
                    {
                    }
                    column(DocNo_DtldCustLedgEntry; "Document No.")
                    {
                    }
                    column(Amt; Amt)
                    {
                        AutoFormatExpression = CurrencyCode;
                        AutoFormatType = 1;
                    }
                    column(CurrencyCodeDtldCustLedgEntry; CurrencyCode)
                    {
                    }
                    column(EntNo_DtldCustLedgEntry; DtldCustLedgEntryNum)
                    {
                    }
                    column(RemainingAmt; RemainingAmt)
                    {
                        AutoFormatExpression = CurrencyCode;
                        AutoFormatType = 1;
                    }

                    trigger OnAfterGetRecord()
                    begin
                        IF NOT PrintUnappliedEntries THEN
                            IF Unapplied THEN
                                CurrReport.SKIP;

                        IF PrintAmountInLCY THEN BEGIN
                            Amt := "Amount (LCY)";
                            CurrencyCode := '';
                        END ELSE BEGIN
                            Amt := Amount;
                            CurrencyCode := "Currency Code";
                        END;
                        IF Amt = 0 THEN
                            CurrReport.SKIP;
                        DtldCustLedgEntryNum := DtldCustLedgEntryNum + 1;

                        IF CurrencyCode = '' THEN
                            CurrencyCode := GLSetup."LCY Code";
                    end;

                    trigger OnPreDataItem()
                    begin
                        DtldCustLedgEntryNum := 0;
                    end;
                }

                trigger OnAfterGetRecord()
                begin
                    IF PrintAmountInLCY THEN BEGIN
                        CALCFIELDS("Original Amt. (LCY)", "Remaining Amt. (LCY)");
                        OriginalAmt := "Original Amt. (LCY)";
                        RemainingAmt := "Remaining Amt. (LCY)";
                        CurrencyCode := GLSetup."LCY Code";
                    END ELSE BEGIN
                        CALCFIELDS("Original Amount", "Remaining Amount");
                        OriginalAmt := "Original Amount";
                        RemainingAmt := "Remaining Amount";
                        CurrencyCode := "Currency Code";
                    END;

                    IF CurrencyCode = '' THEN
                        CurrencyCode := GLSetup."LCY Code";

                    CurrencyTotalBuffer.UpdateTotal(
                      CurrencyCode,
                      RemainingAmt,
                      0,
                      Counter1);
                end;

                trigger OnPreDataItem()
                begin
                    RESET;
                    DtldCustLedgEntry.SETCURRENTKEY("Customer No.", "Posting Date", "Entry Type");
                    DtldCustLedgEntry.SETRANGE("Customer No.", Customer."No.");
                    DtldCustLedgEntry.SETRANGE("Posting Date", CALCDATE('<+1D>', MaxDate), 99991231D);
                    DtldCustLedgEntry.SETRANGE("Entry Type", DtldCustLedgEntry."Entry Type"::Application);
                    IF NOT PrintUnappliedEntries THEN
                        DtldCustLedgEntry.SETRANGE(Unapplied, FALSE);

                    IF DtldCustLedgEntry.FIND('-') THEN
                        REPEAT
                            "Entry No." := DtldCustLedgEntry."Cust. Ledger Entry No.";
                            MARK(TRUE);
                        UNTIL DtldCustLedgEntry.NEXT = 0;

                    SETCURRENTKEY("Customer No.", Open);
                    SETRANGE("Customer No.", Customer."No.");
                    SETRANGE("Posting Date", 0D, MaxDate);
                    IF FINDLAST THEN
                        MARK(TRUE);
                    SETRANGE(Open, TRUE);
                    SETRANGE("Posting Date", 0D, MaxDate);

                    IF FIND('-') THEN
                        REPEAT
                            MARK(TRUE);
                        UNTIL NEXT = 0;

                    SETCURRENTKEY("Entry No.");
                    SETRANGE(Open);
                    MARKEDONLY(TRUE);

                    SETRANGE("Date Filter", 0D, MaxDate);
                end;
            }
            dataitem(Integer2; "Integer")
            {
                DataItemTableView = SORTING(Number) WHERE(Number = FILTER(1 ..));
                column(TotalBalanceCaption; TotalBalanceCaption)
                {
                }
                column(CustName; Customer.Name)
                {
                }
                column(TtlAmtCurrencyTtlBuff; CurrencyTotalBuffer."Total Amount")
                {
                    AutoFormatExpression = CurrencyTotalBuffer."Currency Code";
                    AutoFormatType = 1;
                }
                column(CurryCode_CurrencyTtBuff; CurrencyTotalBuffer."Currency Code")
                {
                }

                trigger OnAfterGetRecord()
                begin
                    IF Number = 1 THEN
                        OK := CurrencyTotalBuffer.FIND('-')
                    ELSE
                        OK := CurrencyTotalBuffer.NEXT <> 0;
                    IF NOT OK THEN
                        CurrReport.BREAK;

                    CurrencyTotalBuffer2.UpdateTotal(
                      CurrencyTotalBuffer."Currency Code",
                      CurrencyTotalBuffer."Total Amount",
                      0,
                      Counter1);
                end;

                trigger OnPostDataItem()
                begin
                    CurrencyTotalBuffer.DELETEALL;
                end;

                trigger OnPreDataItem()
                begin
                    CurrencyTotalBuffer.SETFILTER("Total Amount", '<>0');
                end;
            }

            trigger OnAfterGetRecord()
            begin
                MaxDate := GETRANGEMAX("Date Filter");
                SETRANGE("Date Filter", 0D, MaxDate);
                CALCFIELDS("Net Change (LCY)", "Net Change");

            end;
        }
        dataitem(Integer3; "Integer")
        {
            DataItemTableView = SORTING(Number) WHERE(Number = FILTER(1 ..));
            column(CurryCode_CurrencyTtBuff2; CurrencyTotalBuffer2."Currency Code")
            {
            }
            column(TtlAmtCurrencyTtlBuff2; CurrencyTotalBuffer2."Total Amount")
            {
                AutoFormatExpression = CurrencyTotalBuffer2."Currency Code";
                AutoFormatType = 1;
            }
            column(TotalCaption; TotalCaptionLbl)
            {
            }

            trigger OnAfterGetRecord()
            begin
                IF Number = 1 THEN
                    OK := CurrencyTotalBuffer2.FIND('-')
                ELSE
                    OK := CurrencyTotalBuffer2.NEXT <> 0;
                IF NOT OK THEN
                    CurrReport.BREAK;
            end;

            trigger OnPostDataItem()
            begin
                CurrencyTotalBuffer2.DELETEALL;
            end;

            trigger OnPreDataItem()
            begin
                CurrencyTotalBuffer2.SETFILTER("Total Amount", '<>0');
                CurrReport.BREAK;
            end;
        }
    }

    requestpage
    {
        SaveValues = false;

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(PrintAmountInLCY; PrintAmountInLCY)
                    {
                        Caption = 'Show Amounts in LCY';
                    }
                    field(PrintUnappliedEntries; PrintUnappliedEntries)
                    {
                        Caption = 'Include Unapplied Entries';
                    }
                    field("Without details"; WithoutDetails)
                    {
                        Caption = 'Without details';
                    }
                    field(Director; GeneralManagerNo)
                    {
                        Caption = 'Manager';
                        TableRelation = Employee;
                    }
                    field(Contabil; FinancialManagerNo)
                    {
                        Caption = 'Accountant';
                        TableRelation = Employee;
                    }
                }
            }
        }
        trigger OnOpenPage()
        begin
            CompanyInfo.GET;
            WithoutDetails := FALSE;
        end;
    }

    labels
    {
        To = 'To:';
        Labl1 = 'We confirm this statement of account for the amount of.................lei, for whose payment (this will be filled in accordingly):';
        Labl2 = 'lei, for whose payment (this will be filled in accordingly):';
        Labl3 = 'a) I submitted to (bank, postal office, etc).................................the document (pazment order, warrant)...................................................................................';
        Labl4 = 'with the document (pazment order, warrant)';
        Labl5 = 'no......................................................from..............................................................................';
        Labl6 = 'from';
        Labl7 = 'b) we will make payment in a period of.....................................................................................................................................................';
        Labl8 = 'Our objections regarding the amounts of the present statement of account are enclosed in the explanatory note.';
    }

    trigger OnPreReport()
    begin
        CustFilter := Customer.GETFILTERS;
        CustDateFilter := Customer.GETFILTER("Date Filter");

        IF Employee.GET(GeneralManagerNo) THEN
            Director := Employee.FullName;

        IF Employee.GET(FinancialManagerNo) THEN
            Contabil := Employee.FullName;

        GLSetup.GET;
        CompanyInfo.Get();
    end;

    var
        Text000: Label 'Balance on %1';
        CompanyInfo: Record "Company Information";
        GLSetup: Record "General Ledger Setup";
        CurrencyTotalBuffer: Record "Currency Total Buffer" temporary;
        CurrencyTotalBuffer2: Record "Currency Total Buffer" temporary;
        DtldCustLedgEntry: Record "Detailed Cust. Ledg. Entry";
        Employee: Record Employee;
        PrintAmountInLCY: Boolean;
        PrintOnePrPage: Boolean;
        CustFilter: Text[250];
        CustDateFilter: Text[30];
        MaxDate: Date;
        OriginalAmt: Decimal;
        Amt: Decimal;
        RemainingAmt: Decimal;
        Counter1: Integer;
        DtldCustLedgEntryNum: Integer;
        OK: Boolean;
        CurrencyCode: Code[10];
        PrintUnappliedEntries: Boolean;
        CustBalancetoDateCaptionLbl: Label 'Customer - Balance to Date';
        CurrReportPageNoCaptionLbl: Label 'Page';
        AllamtsareinLCYCaptionLbl: Label 'All amounts are in LCY.';
        CustLedgEntryPostingDtCaptionLbl: Label 'Posting Date';
        OriginalAmtCaptionLbl: Label 'Remaining Amount';
        TotalCaptionLbl: Label 'Total';
        CreditUnit: Label 'Credit Unit:';
        FiscalCodeId: Label 'Fiscal Identification Code:';
        CommRegNo: Label 'Commerce Registration No.:';
        TxtLocation: Label 'Location (City, Street, No.):';
        TxtCounty: Label 'County:';
        Cont: Label 'Cont:';
        Banca: Label 'Bank:';
        DebitUnit: Label 'Debit Unit:';
        StatofAcc: Label 'STATEMENT OF ACCOUNT';
        Text001: Label '         According to the existing provisions, we hereby communicate you that in our bookkeeping, on';
        Text002: Label 'your company has the following debits:';
        Text003: Label '              We ask you to send us this statement of account for the confirmed amount within 5 days from the document''s receipt, and in case of observing differences, to enclose an explanatory note containing your objections.';
        Text004: Label 'receipt, and in case of observing differences, to enclose an explanatory note containing your objections.';
        Text005: Label '              The present statement of account pleads for conciliation according to the arbitrary procedure.';
        GeneralManagerNo: Code[20];
        FinancialManagerNo: Code[20];
        Director: Text[60];
        Contabil: Text[60];
        TxtContabil: Label 'Financial Department Director,';
        TxtDirector: Label 'Director,';
        PageCaptionLbl: Label 'Page';
        Currency_Lbl: Label 'Curr.';
        BalanceConfirmationLbl: Label 'BALANCE CONFIRMATION at date:';
        RegistrationNoLbl: Label 'Registration no.........................................from................................';
        ExtDocNoCaption: Label 'External Doc. No.';
        TotalBalanceCaption: Label 'Total Balance';
        WithoutDetails: Boolean;

    procedure InitializeRequest(NewPrintAmountInLCY: Boolean; NewPrintOnePrPage: Boolean; NewPrintUnappliedEntries: Boolean)
    begin
        PrintAmountInLCY := NewPrintAmountInLCY;
        PrintOnePrPage := NewPrintOnePrPage;
        PrintUnappliedEntries := NewPrintUnappliedEntries;
    end;
}

