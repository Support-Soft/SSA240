report 71320 "SSA Vend. Balance Confirmation"
{
    DefaultLayout = RDLC;
    RDLCLayout = './src/rdlc/SSA Vend. Balance Confirmation.rdlc';
    UsageCategory = ReportsAndAnalysis;
    Caption = 'Vendor Balance Confirmation';
    ApplicationArea = All;

    dataset
    {
        dataitem(Vendor; Vendor)
        {
            DataItemTableView = sorting("No.");
            PrintOnlyIfDetail = false;
            RequestFilterFields = "No.", "Search Name", Blocked, "Date Filter";
            column(WithoutDetails; WithoutDetails)
            {
            }
            column(TodayFormatted; FORMAT(TODAY, 0, '<Day,2>.<Month,2>.<Year4>'))
            {
            }
            column(TxtvendGeTranmaxDtFilter; STRSUBSTNO(Text000, FORMAT(GETRANGEMAX("Date Filter"), 0, '<Day,2>.<Month,2>.<Year4>')))
            {
            }
            column(PrintOnePrPage; PrintOnePrPage)
            {
            }
            column(vendFilter; vendFilter)
            {
            }
            column(PrintAmountInLCY; PrintAmountInLCY)
            {
            }
            column(vendTableCaptvendFilter; TABLECAPTION + ': ' + vendFilter)
            {
            }
            column(No_Vendor; "No.")
            {
            }
            column(Name_Vendor; Name)
            {
            }
            column(PhoneNo_Vendor; "Phone No.")
            {
                IncludeCaption = true;
            }
            column(vendBalancetoDateCaption; vendBalancetoDateCaptionLbl)
            {
            }
            column(CurrReportPageNoCaption; CurrReportPageNoCaptionLbl)
            {
            }
            column(AllamtsareinLCYCaption; AllamtsareinLCYCaptionLbl)
            {
            }
            column(vendLedgEntryPostingDtCaption; vendLedgEntryPostingDtCaptionLbl)
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
            column(VendVatRegName; Vendor."VAT Registration No.")
            {
            }
            column(VendCommTradeNo; Vendor."SSA Commerce Trade No.")
            {
            }
            column(vendAddress; Vendor.City + ' ' + Vendor.Address)
            {
            }
            column(vendAddress2; Vendor."Address 2")
            {
            }
            column(Text001; Text001)
            {
            }
            column(StatofAcc; StatofAcc)
            {
            }
            column(MaxDate; format(MaxDate, 0, '<Day,2>.<Month,2>.<Year4>'))
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
            column(vendNameName2; Vendor.Name + ' ' + Vendor."Name 2")
            {
            }
            column(vendCity; Vendor.City)
            {
            }
            column(VendorCounty; Vendor.County)
            {
            }
            column(PageCaptionLbl; PageCaptionLbl)
            {
            }
            column(BalanceConfirmationLbl; BalanceConfirmationLbl)
            {
            }
            column(ExtDocNoCaption; ExtDocNoCaption)
            {
            }
            column(RegistrationNoLbl; RegistrationNoLbl)
            {
            }
            dataitem(vendLedgEntry3; "Vendor Ledger Entry")
            {
                DataItemTableView = sorting("Entry No.");
                column(PostingDt_vendLedgEntry; FORMAT("Posting Date", 0, '<Day,2>.<Month,2>.<Year4>'))
                {
                    IncludeCaption = false;
                }
                column(DocType_vendLedgEntry; "Document Type")
                {
                    IncludeCaption = true;
                }
                column(DocNo_vendLedgEntry; "Document No.")
                {
                    IncludeCaption = true;
                }
                column(ExternalDocNo_vendLedgEntry; "External Document No.")
                {
                }
                column(Desc_vendLedgEntry; Description)
                {
                    IncludeCaption = true;
                }
                column(OriginalAmt; OriginalAmt)
                {
                    AutoFormatExpression = CurrencyCode;
                    AutoFormatType = 1;
                }
                column(EntryNo_vendLedgEntry; "Entry No.")
                {
                    IncludeCaption = true;
                }
                column(CurrencyCode; CurrencyCode)
                {
                }
                column(Currency_Lbl; Currency_Lbl)
                {
                }
                column(RemainingAmt_vendLedgEntry; -RemainingAmt)
                {
                }
                column(DocNo; DocNo)
                {
                }
                dataitem("Detailed Vendor Ledg. Entry"; "Detailed Vendor Ledg. Entry")
                {
                    DataItemLink = "Vendor Ledger Entry No." = field("Entry No."), "Posting Date" = field("Date Filter");
                    DataItemTableView = sorting("Vendor Ledger Entry No.", "Posting Date") where("Entry Type" = filter(<> "Initial Entry"));
                    column(EntryType_DtldvendLedgEntry; "Entry Type")
                    {
                    }
                    column(postDt_DtldvendLedgEntry; FORMAT("Posting Date", 0, '<Day,2>.<Month,2>.<Year4>'))
                    {
                    }
                    column(DocType_DtldvendLedgEntry; "Document Type")
                    {
                    }
                    column(DocNo_DtldvendLedgEntry; "Document No.")
                    {
                    }
                    column(Amt; Amt)
                    {
                        AutoFormatExpression = CurrencyCode;
                        AutoFormatType = 1;
                    }
                    column(CurrencyCodeDtldvendLedgEntry; CurrencyCode)
                    {
                    }
                    column(EntNo_DtldvendLedgEntry; DtldvendLedgEntryNum)
                    {
                    }
                    column(RemainingAmt; RemainingAmt)
                    {
                        AutoFormatExpression = CurrencyCode;
                        AutoFormatType = 1;
                    }

                    trigger OnAfterGetRecord()
                    begin
                        if not PrintUnappliedEntries then
                            if Unapplied then
                                CurrReport.SKIP;

                        if PrintAmountInLCY then begin
                            Amt := "Amount (LCY)";
                            CurrencyCode := '';
                        end else begin
                            Amt := Amount;
                            CurrencyCode := "Currency Code";
                        end;

                        if CurrencyCode = '' then
                            CurrencyCode := GLSetup."LCY Code";

                        if Amt = 0 then
                            CurrReport.SKIP;

                        DtldvendLedgEntryNum := DtldvendLedgEntryNum + 1;
                    end;

                    trigger OnPreDataItem()
                    begin
                        DtldvendLedgEntryNum := 0;
                    end;
                }

                trigger OnAfterGetRecord()
                begin
                    if PrintAmountInLCY then begin
                        CALCFIELDS("Original Amt. (LCY)", "Remaining Amt. (LCY)");
                        OriginalAmt := "Original Amt. (LCY)";
                        RemainingAmt := "Remaining Amt. (LCY)";
                        CurrencyCode := GLSetup."LCY Code";
                    end else begin
                        CALCFIELDS("Original Amount", "Remaining Amount");
                        OriginalAmt := "Original Amount";
                        RemainingAmt := "Remaining Amount";
                        CurrencyCode := "Currency Code";
                    end;

                    if CurrencyCode = '' then
                        CurrencyCode := GLSetup."LCY Code";

                    CurrencyTotalBuffer.UpdateTotal(
                      CurrencyCode,
                      RemainingAmt,
                      0,
                      Counter1);

                    if vendLedgEntry3."External Document No." <> '' then
                        DocNo := vendLedgEntry3."External Document No."
                    else
                        DocNo := vendLedgEntry3."Document No."
                end;

                trigger OnPreDataItem()
                begin
                    RESET;
                    DtldvendLedgEntry.SETCURRENTKEY("Vendor No.", "Posting Date", "Entry Type");
                    DtldvendLedgEntry.SETRANGE("Vendor No.", Vendor."No.");
                    DtldvendLedgEntry.SETRANGE("Posting Date", CALCDATE('<+1D>', MaxDate), 99991231D);
                    DtldvendLedgEntry.SETRANGE("Entry Type", DtldvendLedgEntry."Entry Type"::Application);
                    if not PrintUnappliedEntries then
                        DtldvendLedgEntry.SETRANGE(Unapplied, false);

                    if DtldvendLedgEntry.FIND('-') then
                        repeat
                            "Entry No." := DtldvendLedgEntry."Vendor Ledger Entry No.";
                            MARK(true);
                        until DtldvendLedgEntry.NEXT = 0;

                    SETCURRENTKEY("Vendor No.", Open);
                    SETRANGE("Vendor No.", Vendor."No.");
                    SETRANGE("Posting Date", 0D, MaxDate);
                    /*
                    IF FINDLAST THEN
                        MARK(TRUE);
                    */
                    SETRANGE(Open, true);
                    SETRANGE("Posting Date", 0D, MaxDate);

                    if FIND('-') then
                        repeat
                            MARK(true);
                        until NEXT = 0;

                    SETCURRENTKEY("Entry No.");
                    SETRANGE(Open);
                    MARKEDONLY(true);
                    SETRANGE("Date Filter", 0D, MaxDate);
                end;
            }
            dataitem(Integer2; "Integer")
            {
                DataItemTableView = sorting(Number) where(Number = filter(1 ..));
                column(TotalBalanceCaption; TotalBalanceCaption)
                {
                }
                column(vendName; Vendor.Name)
                {
                }
                column(TtlAmtCurrencyTtlBuff; -CurrencyTotalBuffer."Total Amount")
                {
                    AutoFormatExpression = CurrencyTotalBuffer."Currency Code";
                    AutoFormatType = 1;
                }
                column(CurryCode_CurrencyTtBuff; CurrencyTotalBuffer."Currency Code")
                {
                }

                trigger OnAfterGetRecord()
                begin
                    if Number = 1 then
                        OK := CurrencyTotalBuffer.FIND('-')
                    else
                        OK := CurrencyTotalBuffer.NEXT <> 0;
                    if not OK then
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
            DataItemTableView = sorting(Number) where(Number = filter(1 ..));
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
                if Number = 1 then
                    OK := CurrencyTotalBuffer2.FIND('-')
                else
                    OK := CurrencyTotalBuffer2.NEXT <> 0;
                if not OK then
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
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the Show Amounts in LCY field.';
                    }
                    field(PrintUnappliedEntries; PrintUnappliedEntries)
                    {
                        Caption = 'Include Unapplied Entries';
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the Include Unapplied Entries field.';
                    }
                    field("Without details"; WithoutDetails)
                    {
                        Caption = 'Without details';
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the Without details field.';
                    }
                    field(Director; GeneralManagerNo)
                    {
                        Caption = 'Manager';
                        TableRelation = Employee;
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the Manager field.';
                    }
                    field(Contabil; FinancialManagerNo)
                    {
                        Caption = 'Accountant';
                        TableRelation = Employee;
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the Accountant field.';
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnOpenPage()
        begin
            CompanyInfo.GET;
            WithoutDetails := false;
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
        vendFilter := Vendor.GETFILTERS;
        vendDateFilter := Vendor.GETFILTER("Date Filter");

        if Employee.GET(GeneralManagerNo) then
            Director := Employee.FullName;

        if Employee.GET(FinancialManagerNo) then
            Contabil := Employee.FullName;

        GLSetup.GET;
    end;

    var
        Text000: Label 'Balance on %1';
        CompanyInfo: Record "Company Information";
        GLSetup: Record "General Ledger Setup";
        CurrencyTotalBuffer: Record "Currency Total Buffer" temporary;
        CurrencyTotalBuffer2: Record "Currency Total Buffer" temporary;
        DtldvendLedgEntry: Record "Detailed Vendor Ledg. Entry";
        Employee: Record Employee;
        PrintAmountInLCY: Boolean;
        PrintOnePrPage: Boolean;
        vendFilter: Text[250];
        vendDateFilter: Text[30];
        MaxDate: Date;
        OriginalAmt: Decimal;
        Amt: Decimal;
        RemainingAmt: Decimal;
        Counter1: Integer;
        DtldvendLedgEntryNum: Integer;
        OK: Boolean;
        CurrencyCode: Code[10];
        PrintUnappliedEntries: Boolean;
        vendBalancetoDateCaptionLbl: Label 'Vendor - Balance to Date';
        CurrReportPageNoCaptionLbl: Label 'Page';
        AllamtsareinLCYCaptionLbl: Label 'All amounts are in LCY.';
        vendLedgEntryPostingDtCaptionLbl: Label 'Posting Date';
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
        GeneralManagerNo: Code[20];
        FinancialManagerNo: Code[20];
        StatofAcc: Label 'STATEMENT OF ACCOUNT';
        Text001: Label '         According to the existing provisions, we hereby communicate you that in our bookkeeping, on';
        Text002: Label 'your company has the following credits:';
        Text003: Label '              We ask you to send us this statement of account for the confirmed amount within 5 days from the document''s receipt, and in case of observing differences, to enclose an explanatory note containing your objections.';
        Text004: Label 'receipt, and in case of observing differences, to enclose an explanatory note containing your objections.';
        Text005: Label '              The present statement of account pleads for conciliation according to the arbitrary procedure.';
        Director: Text[60];
        Contabil: Text[60];
        TxtContabil: Label 'Financial Department Director,';
        TxtDirector: Label 'Director,';
        PageCaptionLbl: Label 'Page';
        Currency_Lbl: Label 'Curr.';
        BalanceConfirmationLbl: Label 'BALANCE CONFIRMATION at date:';
        RegistrationNoLbl: Label 'Registration no.........................................from................................';
        ExtDocNoCaption: Label 'External Doc. No.';
        DocNo: Code[35];
        WithoutDetails: Boolean;
        TotalBalanceCaption: Label 'Total Balance';

    procedure InitializeRequest(NewPrintAmountInLCY: Boolean; NewPrintOnePrPage: Boolean; NewPrintUnappliedEntries: Boolean)
    begin
        PrintAmountInLCY := NewPrintAmountInLCY;
        PrintOnePrPage := NewPrintOnePrPage;
        PrintUnappliedEntries := NewPrintUnappliedEntries;
    end;
}
