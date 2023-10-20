report 71305 "SSA Customer Partner Report"
{
    // SSA985 SSCAT 11.10.2019 52.Rapoarte legale-Fisa parteneri–client
    DefaultLayout = RDLC;
    RDLCLayout = './src/rdlc/SSACustomerPartnerReport.rdlc';
    Caption = 'Customer Partner Report';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    dataset
    {
        dataitem(Customer; Customer)
        {
            DataItemTableView = sorting("No.");
            RequestFilterFields = "No.", "Search Name", "Date Filter";
            column(Name_Customer; Customer.Name)
            {
                IncludeCaption = true;
            }
            column(No_Customer; Customer."No.")
            {
                IncludeCaption = true;
            }
            column(PhoneNo_Customer; Customer."Phone No.")
            {
                IncludeCaption = true;
            }
            column(ClosingDocCaption; ClosingDocCaption)
            {
            }
            column(SumeDebitCaption; SumeDebitCaption)
            {
            }
            column(SumeCreditCaption; SumeCreditCaption)
            {
            }
            column(SumeDebitMNCaption; SumeDebitMNCaption)
            {
            }
            column(SumeCreditMNCaption; SumeCreditMNCaption)
            {
            }
            column(Title; Title)
            {
            }
            column(AntetCaption; AntetCaption)
            {
            }
            column(TextAjustari; TextAjustari)
            {
            }
            column(TextAjustari2; TextAjustari2)
            {
            }
            column(TextAjustariTotala; TextAjustariTotala)
            {
            }
            column(CustDateFilter; CustDateFilter)
            {
            }
            column(CustFilter; CustFilter)
            {
            }
            column(CustLedgFilter; CustLedgFilter)
            {
            }
            column(Text000; Text000)
            {
            }
            column(COMPANYNAME; CompanyInfo.Name)
            {
            }
            column(SoldCaption; SoldCaption)
            {
            }
            column(StartBalance; StartBalance)
            {
            }
            column(StartBalanceLCY; StartBalanceLCY)
            {
            }
            column(StartBalAdj; StartBalAdj)
            {
            }
            column(StartBalAdjLCY; StartBalAdjLCY)
            {
            }
            column(StartBalAdjLCYAppl; StartBalAdjLCYAppl)
            {
            }
            column(SoldMNCaption; SoldMNCaption)
            {
            }
            column(ShowForeign; ShowForeign)
            {
            }
            column(RemAmountCaption; RemAmountCaption)
            {
            }
            column(CompanyInfo_VATRegistrationNumber; companyinfo.GetVATRegistrationNumber())
            {
            }
            dataitem("Cust. Ledger Entry"; "Cust. Ledger Entry")
            {
                DataItemLink = "Customer No." = field("No."), "Posting Date" = field("Date Filter"), "Global Dimension 1 Code" = field("Global Dimension 1 Filter"), "Global Dimension 2 Code" = field("Global Dimension 2 Filter"), "Date Filter" = field("Date Filter");
                DataItemTableView = sorting("Customer No.", "Posting Date", "Currency Code");
                RequestFilterFields = "Customer Posting Group", Open, "Currency Code";
                column(DocumentType_CustLedgerEntry; "Cust. Ledger Entry"."Document Type")
                {
                    IncludeCaption = true;
                }
                column(EntryNo_CustLedgerEntry; "Cust. Ledger Entry"."Entry No.")
                {
                    IncludeCaption = true;
                }
                column(DocumentNo_CustLedgerEntry; "Cust. Ledger Entry"."Document No.")
                {
                    IncludeCaption = true;
                }
                column(PostingDate_CustLedgerEntry; "Cust. Ledger Entry"."Posting Date")
                {
                    IncludeCaption = true;
                }
                column(DueDate_CustLedgerEntry; "Cust. Ledger Entry"."Due Date")
                {
                    IncludeCaption = true;
                }
                column(ExternalDocumentNo_CustLedgerEntry; "Cust. Ledger Entry"."External Document No.")
                {
                    IncludeCaption = true;
                }
                column(CurrencyCode_CustLedgerEntry; "Cust. Ledger Entry"."Currency Code")
                {
                    IncludeCaption = true;
                }
                column(Amount_CustLedgerEntry; "Cust. Ledger Entry".Amount)
                {
                    IncludeCaption = true;
                }
                column(AmountLCY_CustLedgerEntry; "Cust. Ledger Entry"."Amount (LCY)")
                {
                    IncludeCaption = true;
                }
                column(ClosingDocNo; ClosingDocNo)
                {
                }
                column(DocumentDate_CustLedgerEntry; "Cust. Ledger Entry"."Document Date")
                {
                    IncludeCaption = true;
                }
                column(DebitAmount; DebitAmount)
                {
                }
                column(CreditAmount; CreditAmount)
                {
                }
                column(CustBalance; CustBalance)
                {
                }
                column(CustBalanceLCY; CustBalanceLCY)
                {
                }
                column(DebitAmountLCY; DebitAmountLCY)
                {
                }
                column(CreditAmountLCY; CreditAmountLCY)
                {
                }
                column(TotalDebit; TotalDebit)
                {
                }
                column(TotalCredit; TotalCredit)
                {
                }
                column(TotalDebitLCY; TotalDebitLCY)
                {
                }
                column(TotalCreditLCY; TotalCreditLCY)
                {
                }
                column(TCustBalance; TCustBalance)
                {
                }
                column(TCustBalanceLCY; TCustBalanceLCY)
                {
                }
                column(Curs; Curs)
                {
                }
                column(Text50005; Text50005)
                {
                }
                column(StartingDate; StartingDate)
                {
                }
                column(DocDate; DocDate)
                {
                }
                column(DueDate; DueDate)
                {
                }
                column(HideDetails; HideDetails)
                {
                }
                column(RemainingAmount; RemainingAmount)
                {
                }
                column(HideLine; HideLine)
                {
                }
                dataitem("Detailed Cust. Ledg. Entry"; "Detailed Cust. Ledg. Entry")
                {
                    DataItemLink = "Cust. Ledger Entry No." = field("Entry No.");
                    DataItemTableView = sorting("Cust. Ledger Entry No.", "Entry Type", "Posting Date") where("Entry Type" = const("Correction of Remaining Amount"));
                    column(EntryType_DetailedCustLedgEntry; "Detailed Cust. Ledg. Entry"."Entry Type")
                    {
                    }
                    column(EntryNo_DetailedCustLedgEntry; "Detailed Cust. Ledg. Entry"."Entry No.")
                    {
                    }
                    column(Correction; Correction)
                    {
                    }
                    column(CustBalanceLCY2; CustBalanceLCY)
                    {
                    }
                    column(ApplicationRounding; ApplicationRounding)
                    {
                    }
                    trigger OnPreDataItem()
                    begin

                        SETFILTER("Posting Date", CustDateFilter);
                        Correction := 0;
                        ApplicationRounding := 0;
                    end;

                    trigger OnAfterGetRecord()
                    begin

                        case "Entry Type" of
                            "Entry Type"::"Appln. Rounding":
                                ApplicationRounding := ApplicationRounding + "Amount (LCY)";
                            "Entry Type"::"Correction of Remaining Amount":
                                Correction := Correction + "Amount (LCY)";
                        end;
                        CustBalanceLCY := CustBalanceLCY + "Amount (LCY)";
                    end;
                }

                trigger OnAfterGetRecord()
                begin
                    DocDate := "Posting Date";
                    DueDate := "Due Date";

                    CalcFields(Amount, "Remaining Amount", "Amount (LCY)", "Remaining Amt. (LCY)", "Debit Amount", "Credit Amount",
                    "Debit Amount (LCY)", "Credit Amount (LCY)");
                    Clear(CustAmountLCY);
                    Clear(CustAmount);
                    Clear(DebitAmount);
                    Clear(CreditAmount);
                    Clear(DebitAmountLCY);
                    Clear(CreditAmountLCY);

                    EntryIdx := EntryIdx + 1;
                    if EntryIdx > 1 then begin
                        StartBalance := 0;
                        StartBalAdj := 0;
                        StartBalanceLCY := 0;
                        StartBalAdjLCY := 0;
                        StartBalAdjLCYAppl := 0;
                    end;

                    Clear(Curs);
                    if Amount <> 0 then
                        Curs := Round(Abs(1 / "Adjusted Currency Factor"), 1 / 10000);

                    CustLedgEntryExists := true;

                    begin
                        if ("Document Type" = "Document Type"::Payment) then begin
                            CreditAmountLCY := -"Amount (LCY)"
                        end;
                        if ("Document Type" = "Document Type"::Refund) then begin
                            CreditAmountLCY := -"Amount (LCY)";
                        end;
                        if ("Document Type" = "Document Type"::Invoice) then begin
                            DebitAmountLCY := "Amount (LCY)"
                        end;
                        if ("Document Type" = "Document Type"::"Credit Memo") then begin
                            DebitAmountLCY := "Amount (LCY)"
                        end;
                        if ("Document Type" = "Document Type"::" ") then begin
                            CreditAmountLCY := "Credit Amount (LCY)";
                            DebitAmountLCY := "Debit Amount (LCY)"
                        end;
                    end;

                    if "Cust. Ledger Entry"."Currency Code" <> '' then begin
                        if ("Document Type" = "Document Type"::Payment) then begin
                            CreditAmount := -Amount
                        end;
                        if ("Document Type" = "Document Type"::Refund) then begin
                            CreditAmount := -Amount;
                        end;
                        if ("Document Type" = "Document Type"::Invoice) then begin
                            DebitAmount := Amount
                        end;
                        if ("Document Type" = "Document Type"::"Credit Memo") then begin
                            DebitAmount := Amount
                        end;
                        if ("Document Type" = "Document Type"::" ") then begin
                            CreditAmount := "Credit Amount";
                            DebitAmount := "Debit Amount"
                        end;
                    end;

                    CustBalanceLCY := CustBalanceLCY + "Amount (LCY)";
                    TCustBalanceLCY := TCustBalanceLCY + "Amount (LCY)";

                    if "Cust. Ledger Entry"."Currency Code" <> '' then begin
                        CustBalance := CustBalance + Amount;
                        TCustBalance := TCustBalance + Amount;
                    end;

                    if ("Document Type" = "Document Type"::Payment) or ("Document Type" = "Document Type"::Refund) then
                        CustEntryDueDate := 0D
                    else
                        CustEntryDueDate := "Due Date";

                    TotalCredit += CreditAmount;
                    TotalDebit += DebitAmount;
                    TotalCreditLCY += CreditAmountLCY;
                    TotalDebitLCY += DebitAmountLCY;

                    Clear(ClosingDocNo);
                    if (("Document Type" = "Document Type"::Invoice)) then begin
                        DetCustLE.Reset;
                        DetCustLE.SetCurrentKey(DetCustLE."Cust. Ledger Entry No.");
                        DetCustLE.SetRange(DetCustLE."Cust. Ledger Entry No.", "Entry No.");
                        DetCustLE.SetRange(DetCustLE."Customer No.", "Customer No.");
                        DetCustLE.SetRange("Entry Type", DetCustLE."Entry Type"::Application);
                        if DetCustLE.FindFirst then begin
                            repeat
                                ClosingDocNo := ClosingDocNo + DetCustLE."Document No." + '; ';
                            until DetCustLE.Next = 0;
                        end;
                    end;

                    RemainingAmount := "Remaining Amount";
                    if not ShowForeign then begin
                        RemainingAmount := "Remaining Amt. (LCY)";
                    end;

                    HideLine := ("SSA Stare Factura" = "SSA Stare Factura"::"2-Factura Anulata") and HideCancelledDocuments;
                end;

                trigger OnPreDataItem()
                begin
                    CustLedgEntryExists := false;
                    SetFilter("Posting Date", CustDateFilter);
                    SetFilter("Cust. Ledger Entry"."Date Filter", CustDateFilter);

                    CurrReport.CreateTotals(CustAmount, "Amount (LCY)", Amount);
                end;
            }

            trigger OnAfterGetRecord()
            var
                DtlCustLedgEntry: Record "Detailed Cust. Ledg. Entry";
                CustomerLedgEntry: Record "Cust. Ledger Entry";
            begin

                StartBalanceLCY := 0;
                StartBalance := 0;
                if CustDateFilter <> '' then begin
                    if GETRANGEMIN("Date Filter") <> 0D then begin
                        SETRANGE("Date Filter", 0D, GETRANGEMIN("Date Filter") - 1);
                        if CustPostGrFilter <> '' then
                            setfilter("SSA Customer Pstg. Grp. Filter", CustPostGrFilter);
                        CALCFIELDS("SSA Net Change (LCY)", "SSA Net Change");
                        StartBalanceLCY := "SSA Net Change (LCY)";
                        StartBalance := "SSA Net Change";
                    end;
                    SETFILTER("Date Filter", CustDateFilter);
                    if CustPostGrFilter <> '' then
                        setfilter("SSA Customer Pstg. Grp. Filter", CustPostGrFilter);
                    CalcFields("SSA Net Change (LCY)");
                    StartBalAdjLCY := "SSA Net Change (LCY)";

                    CustLedgEntry.SETCURRENTKEY("Customer No.", "Posting Date");
                    CustLedgEntry.SETRANGE("Customer No.", "No.");
                    CustLedgEntry.SETFILTER("Posting Date", CustDateFilter);
                    if CustPostGrFilter <> '' then
                        CustLedgEntry.setfilter("Customer Posting Group", CustPostGrFilter);
                    if CustLedgEntry.FIND('-') then
                        repeat
                            CustLedgEntry.SETFILTER("Date Filter", CustDateFilter);
                            CustLedgEntry.CALCFIELDS("Amount (LCY)");
                            StartBalAdjLCY := StartBalAdjLCY - CustLedgEntry."Amount (LCY)";
                            "Detailed Cust. Ledg. Entry".SETCURRENTKEY("Cust. Ledger Entry No.", "Entry Type", "Posting Date");
                            "Detailed Cust. Ledg. Entry".SETRANGE("Cust. Ledger Entry No.", CustLedgEntry."Entry No.");
                            "Detailed Cust. Ledg. Entry".SETFILTER("Entry Type", '%1|%2',
                              "Detailed Cust. Ledg. Entry"."Entry Type"::"Correction of Remaining Amount",
                              "Detailed Cust. Ledg. Entry"."Entry Type"::"Appln. Rounding");
                            "Detailed Cust. Ledg. Entry".SETFILTER("Posting Date", CustDateFilter);
                            if "Detailed Cust. Ledg. Entry".FIND('-') then
                                repeat
                                    StartBalAdjLCY := StartBalAdjLCY - "Detailed Cust. Ledg. Entry"."Amount (LCY)";
                                until "Detailed Cust. Ledg. Entry".NEXT = 0;
                            "Detailed Cust. Ledg. Entry".RESET;
                        until CustLedgEntry.NEXT = 0;
                end;
                CustBalanceLCY := StartBalanceLCY + StartBalAdjLCY;
            end;

            trigger OnPreDataItem()
            begin
                CurrReport.NewPagePerRecord := PrintOnlyOnePerPage;
                CurrReport.CreateTotals("Cust. Ledger Entry"."Amount (LCY)", StartBalanceLCY, StartBalAdjLCY, "Cust. Ledger Entry".Amount,
                TotalCredit, TotalDebitLCY, TotalCredit, TotalDebitLCY, CustBalanceLCY, CustBalance);
                CurrReport.CreateTotals(StartBalAdjLCY, StartBalAdjLCYAppl, Correction);
                SourceCodeSetup.Get;
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
                group(Control70001)
                {
                    ShowCaption = false;
                    field(ShowForeign; ShowForeign)
                    {
                        Caption = 'ShowForeign';
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the ShowForeign field.';
                    }
                    field(HideCancelledDocuments; HideCancelledDocuments)
                    {
                        Caption = 'Hide Cancelled Documents';
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the Hide Cancelled Documents field.';
                    }
                }
            }
        }
    }

    labels
    {
    }

    trigger OnPreReport()
    begin
        CustFilter := Customer.GetFilters;
        CustLedgFilter := "Cust. Ledger Entry".GetFilters;
        CustDateFilter := Customer.GetFilter("Date Filter");
        CustPostGrFilter := "Cust. Ledger Entry".GetFilter("Customer Posting Group");

        if PrintAmountsInLCY then begin
            AmountCaption := "Cust. Ledger Entry".FieldCaption("Amount (LCY)");
            //RemainingAmtCaption := FIELDCAPTION("Remaining Amt. (LCY)");
        end else begin
            AmountCaption := "Cust. Ledger Entry".FieldCaption(Amount);
            //RemainingAmtCaption := FIELDCAPTION("Remaining Amount");
        end;
        if Customer.GetFilter("Date Filter") <> ''
           then
            StartingDate := Customer.GetRangeMin("Date Filter");
        if ("Cust. Ledger Entry".GetFilter("Currency Code") = '') and SoldValuta then
            SoldValuta := false
        else begin
            CurrencyFilter := "Cust. Ledger Entry".GetFilter("Currency Code");
            Moneda := StrSubstNo(Text50008, CurrencyFilter);
        end;
        CurrencyFilter := "Cust. Ledger Entry".GetFilter("Currency Code");

        RemAmountCaption := 'Suma Ramasa MN';
        if ShowForeign then
            RemAmountCaption := 'Suma Ramasa';
        CompanyInfo.Get();
    end;

    var
        Text000: Label 'Period:';
        Text50007: Label '(LCY)';
        Text50008: Label '(%1)';
        Text50005: Label 'Initial Balance At Date';
        Text50006: Label 'Received Invoice';
        Text50004: Label 'Remaining Amount!';
        Text50002: Label 'Cheque paid at %1';
        Text50003: Label 'Cheque unpaid';
        ClosingDocCaption: Label 'Closing Document No.';
        SumeDebitCaption: Label 'Debit Amount';
        SumeCreditCaption: Label 'Credit Amount';
        SumeDebitMNCaption: Label 'Debit Amount LCY';
        SumeCreditMNCaption: Label 'Credit Amount LCY';
        SoldCaption: Label 'Balance';
        SoldMNCaption: Label 'Balance LCY';
        Title: Label 'Customer - Partner Report Currency';
        AntetCaption: Label 'This report also includes customers that only have balances.';
        TextAjustari: Label 'Adj. of Opening Balance';
        TextAjustari2: Label 'Adj. of Opening Balance';
        TextAjustariTotala: Label 'Total Adj. of Opening Balance';
        DocDate: Date;
        DueDate: Date;
        CustLedgEntry: Record "Cust. Ledger Entry";
        PrintAmountsInLCY: Boolean;
        PrintOnlyOnePerPage: Boolean;
        PrintAllHavingBal: Boolean;
        CustFilter: Text[250];
        CustDateFilter: Text[30];
        AmountCaption: Text[30];
        CustAmount: Decimal;
        CustRemainAmount: Decimal;
        CustBalanceLCY: Decimal;
        CustCurrencyCode: Code[10];
        CustEntryDueDate: Date;
        StartDate: Date;
        EndingDate: Date;
        StartBalanceLCY: Decimal;
        StartBalAdjLCY: Decimal;
        Correction: Decimal;
        CustLedgEntryExists: Boolean;
        CreateCustLedgEntry: Record "Cust. Ledger Entry";
        MarkedCustLedgerEntry: Record "Cust. Ledger Entry";
        ApplDescription: Text[60];
        StartingDate: Date;
        ApplAmount: Decimal;
        DetCustLE: Record "Detailed Cust. Ledg. Entry";
        ApplAmountLCY: Decimal;
        CustAmountLCY: Decimal;
        SoldValuta: Boolean;
        Moneda: Text[30];
        CurrencyFilter: Text[30];
        TotalDebit: Decimal;
        TotalCredit: Decimal;
        DebitAmount: Decimal;
        CreditAmount: Decimal;
        ClosingDocNo: Text[250];
        StartBalance: Decimal;
        StartBalAdj: Decimal;
        CustBalance: Decimal;
        HideDetails: Boolean;
        CustLedgFilter: Text[250];
        Curs: Decimal;
        DebitAmountLCY: Decimal;
        CreditAmountLCY: Decimal;
        TotalDebitLCY: Decimal;
        TotalCreditLCY: Decimal;
        CustPostGrFilter: Text[250];
        StartBalAdjLCYAppl: Decimal;
        SourceCodeSetup: Record "Source Code Setup";
        ExportToExcel: Boolean;
        RowNo: Integer;
        ExcelBuf: Record "Excel Buffer";
        TCustBalanceLCY: Decimal;
        TCustBalance: Decimal;
        EntryIdx: Integer;
        ShowForeign: Boolean;
        RemainingAmount: Decimal;
        RemAmountCaption: Text;
        ApplicationRounding: Decimal;
        HideCancelledDocuments: Boolean;
        HideLine: Boolean;
        CompanyInfo: Record "Company Information";

    procedure FindApplnEntriesDtldtLedgEntry()
    var
        DtldCustLedgEntry1: Record "Detailed Cust. Ledg. Entry";
        DtldCustLedgEntry2: Record "Detailed Cust. Ledg. Entry";
    begin
        DtldCustLedgEntry1.SetCurrentKey("Cust. Ledger Entry No.");
        DtldCustLedgEntry1.SetRange("Cust. Ledger Entry No.", CreateCustLedgEntry."Entry No.");
        DtldCustLedgEntry1.SetRange(Unapplied, false);
        if DtldCustLedgEntry1.Find('-') then begin
            repeat
                if DtldCustLedgEntry1."Cust. Ledger Entry No." =
                  DtldCustLedgEntry1."Applied Cust. Ledger Entry No."
                then begin
                    DtldCustLedgEntry2.Init;
                    DtldCustLedgEntry2.SetCurrentKey("Applied Cust. Ledger Entry No.", "Entry Type");
                    DtldCustLedgEntry2.SetRange(
                      "Applied Cust. Ledger Entry No.", DtldCustLedgEntry1."Applied Cust. Ledger Entry No.");
                    DtldCustLedgEntry2.SetRange("Entry Type", DtldCustLedgEntry2."Entry Type"::Application);
                    DtldCustLedgEntry2.SetRange(Unapplied, false);
                    if DtldCustLedgEntry2.Find('-') then begin
                        repeat
                            if DtldCustLedgEntry2."Cust. Ledger Entry No." <>
                              DtldCustLedgEntry2."Applied Cust. Ledger Entry No."
                            then begin
                                MarkedCustLedgerEntry.SetCurrentKey("Entry No.");
                                MarkedCustLedgerEntry.SetRange("Entry No.", DtldCustLedgEntry2."Cust. Ledger Entry No.");
                                if MarkedCustLedgerEntry.Find('-') then
                                    MarkedCustLedgerEntry.Mark(true);
                            end;
                        until DtldCustLedgEntry2.Next = 0;
                    end;
                end else begin
                    MarkedCustLedgerEntry.SetCurrentKey("Entry No.");
                    MarkedCustLedgerEntry.SetRange("Entry No.", DtldCustLedgEntry1."Applied Cust. Ledger Entry No.");
                    if MarkedCustLedgerEntry.Find('-') then
                        MarkedCustLedgerEntry.Mark(true);
                end;
            until DtldCustLedgEntry1.Next = 0;
        end;
    end;

    procedure MarkCustLedgerEntry()
    begin
        MarkedCustLedgerEntry.ClearMarks;
        FindApplnEntriesDtldtLedgEntry;
        MarkedCustLedgerEntry.SetCurrentKey("Entry No.");
        MarkedCustLedgerEntry.SetRange("Entry No.");

        MarkedCustLedgerEntry.SetCurrentKey("Closed by Entry No.");
        MarkedCustLedgerEntry.SetRange("Closed by Entry No.", CreateCustLedgEntry."Entry No.");
        if MarkedCustLedgerEntry.Find('-') then
            repeat
                MarkedCustLedgerEntry.Mark(true);
            until MarkedCustLedgerEntry.Next = 0;

        MarkedCustLedgerEntry.SetCurrentKey("Entry No.");
        MarkedCustLedgerEntry.SetRange("Closed by Entry No.");

        MarkedCustLedgerEntry.MarkedOnly(true);
    end;
}
