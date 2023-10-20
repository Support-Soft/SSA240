report 71306 "SSA Vendor - Partner Report"
{
    // SSA992 SSCAT 14.10.2019 59.Rapoarte legale-Fisa parteneri–furnizori
    DefaultLayout = RDLC;
    RDLCLayout = './src/rdlc/SSAVendorPartnerReport.rdlc';
    Caption = 'Vendor - Partner Report';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    dataset
    {
        dataitem(Vendor; Vendor)
        {
            DataItemTableView = sorting("No.");
            PrintOnlyIfDetail = false;
            RequestFilterFields = "No.", "Search Name", "Date Filter";
            column(No_Vendor; Vendor."No.")
            {
            }
            column(Name_Vendor; Vendor.Name)
            {
            }
            column(PhoneNo_Vendor; Vendor."Phone No.")
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
            column(VendDateFilter; VendDateFilter)
            {
            }
            column(VendFilter; VendFilter)
            {
            }
            column(VendLedgFilter; VendLedgFilter)
            {
            }
            column(Text000; Text000)
            {
            }
            column(CompName; CompanyInfo.Name)
            {
            }
            column(SoldCaption; SoldCaption)
            {
            }
            column(SoldMNCaption; SoldMNCaption)
            {
            }
            column(StartBalance; StartDebitBalance)
            {
            }
            column(StartDebitBalanceLCY; StartDebitBalanceLCY)
            {
            }
            column(StartCreditBalance; StartCreditBalance)
            {
            }
            column(StartCreditBalanceLCY; StartCreditBalanceLCY)
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
            column(ShowForeign; ShowForeign)
            {
            }
            column(RemAmountCaption; RemAmountCaption)
            {
            }
            column(CompanyInfo_VATRegistrationNumber; CompanyInfo.GetVATRegistrationNumber())
            {
            }
            dataitem("Vendor Ledger Entry"; "Vendor Ledger Entry")
            {
                DataItemLink = "Vendor No." = field("No."), "Posting Date" = field("Date Filter"), "Global Dimension 1 Code" = field("Global Dimension 1 Filter"), "Global Dimension 2 Code" = field("Global Dimension 2 Filter"), "Date Filter" = field("Date Filter");
                DataItemTableView = sorting("Vendor No.", "Posting Date", "Currency Code");
                RequestFilterFields = "Vendor Posting Group", Open, "Currency Code";
                column(EntryNo_VendorLedgerEntry; "Vendor Ledger Entry"."Entry No.")
                {
                }
                column(DocumentDate_VendorLedgerEntry; "Vendor Ledger Entry"."Document Date")
                {
                    IncludeCaption = true;
                }
                column(PostingDate_VendorLedgerEntry; "Vendor Ledger Entry"."Posting Date")
                {
                    IncludeCaption = true;
                }
                column(DueDate_VendorLedgerEntry; "Vendor Ledger Entry"."Due Date")
                {
                    IncludeCaption = true;
                }
                column(DocumentType_VendorLedgerEntry; "Vendor Ledger Entry"."Document Type")
                {
                    IncludeCaption = true;
                }
                column(ExternalDocumentNo_VendorLedgerEntry; "Vendor Ledger Entry"."External Document No.")
                {
                    IncludeCaption = true;
                }
                column(DocumentNo_VendorLedgerEntry; "Vendor Ledger Entry"."Document No.")
                {
                    IncludeCaption = true;
                }
                column(CurrencyCode_VendorLedgerEntry; "Vendor Ledger Entry"."Currency Code")
                {
                    IncludeCaption = true;
                }
                column(ClosingDocNo; ClosingDocNo)
                {
                }
                column(DebitAmount; DebitAmount)
                {
                }
                column(CreditAmount; CreditAmount)
                {
                }
                column(VendBalance; VendBalance)
                {
                }
                column(DebitAmountLCY; DebitAmountLCY)
                {
                }
                column(CreditAmountLCY; CreditAmountLCY)
                {
                }
                column(VendBalanceLCY; VendBalanceLCY)
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
                column(TVendBalance; TVendBalance)
                {
                }
                column(TVendBalanceLCY; TVendBalanceLCY)
                {
                }
                column(AmountLCY_VendorLedgerEntry; "Vendor Ledger Entry"."Amount (LCY)")
                {
                }
                column(Amount_VendorLedgerEntry; "Vendor Ledger Entry".Amount)
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
                dataitem("Detailed Vendor Ledg. Entry"; "Detailed Vendor Ledg. Entry")
                {
                    DataItemLink = "Vendor Ledger Entry No." = field("Entry No.");
                    DataItemTableView = sorting("Vendor Ledger Entry No.", "Entry Type", "Posting Date") where("Entry Type" = const("Correction of Remaining Amount"));
                    column(EntryNo_DetailedVendorLedgEntry; "Detailed Vendor Ledg. Entry"."Entry No.")
                    {
                    }
                    column(EntryType_DetailedVendorLedgEntry; "Detailed Vendor Ledg. Entry"."Entry Type")
                    {
                    }
                    column(Correction; Correction)
                    {
                    }
                    column(VendBalanceLCY2; VendBalanceLCY)
                    {
                    }
                    column(ApplicationRounding; ApplicationRounding)
                    {
                    }

                    trigger OnPreDataItem()
                    begin

                        SETFILTER("Posting Date", VendDateFilter);
                        Correction := 0;
                        ApplicationRounding := 0;
                    end;

                    trigger OnAfterGetRecord()
                    begin

                        case "Entry Type" of
                            "Entry Type"::"Appln. Rounding":
                                ApplicationRounding := "Amount (LCY)";
                            "Entry Type"::"Correction of Remaining Amount":
                                Correction := "Amount (LCY)";
                        end;
                        VendBalanceLCY := VendBalanceLCY + "Amount (LCY)";
                    end;
                }

                trigger OnAfterGetRecord()
                begin
                    DocDate := "Posting Date";
                    DueDate := "Due Date";

                    CalcFields(Amount, "Remaining Amount", "Amount (LCY)", "Remaining Amt. (LCY)", "Credit Amount", "Debit Amount (LCY)",
                    "Debit Amount", "Credit Amount", "Credit Amount (LCY)");
                    Clear(VendAmountLCY);
                    Clear(VendAmount);
                    Clear(DebitAmount);
                    Clear(CreditAmount);
                    Clear(CreditAmountLCY);
                    Clear(DebitAmountLCY);

                    EntryIdx := EntryIdx + 1;
                    if EntryIdx > 1 then begin
                        CLEAR(StartDebitBalance);
                        CLEAR(StartDebitBalanceLCY);
                        CLEAR(StartCreditBalance);
                        CLEAR(StartCreditBalanceLCY);
                        StartBalAdj := 0;
                        StartBalAdjLCY := 0;
                        StartBalAdjLCYAppl := 0;
                    end;

                    VendLedgEntryExists := true;
                    Clear(Curs);
                    if Amount <> 0 then
                        Curs := Round(Abs(1 / "Adjusted Currency Factor"), 1 / 10000);

                    if ("Document Type" = "Document Type"::Payment) then begin
                        DebitAmountLCY := "Amount (LCY)"
                    end;
                    if ("Document Type" = "Document Type"::Refund) then begin
                        DebitAmountLCY := "Amount (LCY)";
                    end;
                    if ("Document Type" = "Document Type"::Invoice) then begin
                        CreditAmountLCY := -"Amount (LCY)"
                    end;
                    if ("Document Type" = "Document Type"::"Credit Memo") then begin
                        CreditAmountLCY := -"Amount (LCY)"
                    end;

                    if ("Document Type" = "Document Type"::" ") then begin
                        CreditAmountLCY := "Credit Amount (LCY)";
                        DebitAmountLCY := "Debit Amount (LCY)";
                    end;

                    if "Vendor Ledger Entry"."Currency Code" <> '' then begin
                        if ("Document Type" = "Document Type"::Payment) then begin
                            DebitAmount := Amount
                        end;
                        if ("Document Type" = "Document Type"::Refund) then begin
                            DebitAmount := Amount;
                        end;
                        if ("Document Type" = "Document Type"::Invoice) then begin
                            CreditAmount := -Amount;
                        end;
                        if ("Document Type" = "Document Type"::"Credit Memo") then begin
                            CreditAmount := -Amount
                        end;
                        if ("Document Type" = "Document Type"::" ") then begin
                            CreditAmount := "Credit Amount";
                            DebitAmount := "Debit Amount";
                        end;
                    end;

                    VendBalanceLCY := VendBalanceLCY + "Amount (LCY)";
                    TVendBalanceLCY := TVendBalanceLCY + "Amount (LCY)";

                    if "Vendor Ledger Entry"."Currency Code" <> '' then begin
                        VendBalance := VendBalance + Amount;
                        TVendBalance := TVendBalance + Amount;
                    end;

                    if ("Document Type" = "Document Type"::Payment) or ("Document Type" = "Document Type"::Refund) then
                        VendEntryDueDate := 0D
                    else
                        VendEntryDueDate := "Due Date";

                    TotalCredit += CreditAmount;
                    TotalDebit += DebitAmount;
                    TotalCreditLCY += CreditAmountLCY;
                    TotalDebitLCY += DebitAmountLCY;

                    Clear(ClosingDocNo);
                    if (("Document Type" = "Document Type"::Invoice)) then begin
                        DetVendLE.Reset;
                        DetVendLE.SetCurrentKey("Vendor Ledger Entry No.");
                        DetVendLE.SetRange(DetVendLE."Vendor Ledger Entry No.", "Entry No.");
                        DetVendLE.SetRange(DetVendLE."Vendor No.", "Vendor No.");
                        DetVendLE.SetRange("Entry Type", DetVendLE."Entry Type"::Application);
                        if DetVendLE.FindFirst then begin
                            repeat
                                ClosingDocNo := ClosingDocNo + DetVendLE."Document No." + '; ';
                            until DetVendLE.Next = 0;
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
                    VendLedgEntryExists := false;
                    SetFilter("Posting Date", VendDateFilter);
                    SetFilter("Vendor Ledger Entry"."Date Filter", VendDateFilter);
                    CurrReport.CreateTotals(VendAmount, "Amount (LCY)", Amount);
                end;
            }

            trigger OnAfterGetRecord()
            begin
                CLEAR(StartDebitBalance);
                CLEAR(StartDebitBalanceLCY);
                CLEAR(StartCreditBalance);
                CLEAR(StartCreditBalanceLCY);

                StartBalAdjLCY := 0;
                StartBalAdj := 0;
                if VendDateFilter <> '' then begin
                    if GETRANGEMIN("Date Filter") <> 0D then begin
                        SETRANGE("Date Filter", 0D, GETRANGEMIN("Date Filter") - 1);
                        if VendPostGrFilter <> '' then
                            setfilter("SSA Vendor Pstg. Grp. Filter", VendPostGrFilter);
                        CALCFIELDS("SSA Net Change (LCY)", "SSA Net Change");
                        if "SSA Net Change (LCY)" > 0 then begin
                            StartDebitBalanceLCY := "SSA Net Change (LCY)";
                            StartDebitBalance := "SSA Net Change";
                        end else begin
                            StartCreditBalanceLCY := -"SSA Net Change (LCY)";
                            StartCreditBalance := -"SSA Net Change";
                        end;
                    end;
                    SETFILTER("Date Filter", VendDateFilter);
                    if VendPostGrFilter <> '' then
                        setfilter("SSA Vendor Pstg. Grp. Filter", VendPostGrFilter);
                    CALCFIELDS("SSA Net Change (LCY)", "SSA Net Change");
                    StartBalAdjLCY := "SSA Net Change (LCY)";
                    StartBalAdj := "SSA Net Change";
                    VendorLedgerEntry.SETCURRENTKEY("Vendor No.", "Posting Date");
                    VendorLedgerEntry.SETRANGE("Vendor No.", "No.");
                    VendorLedgerEntry.SETFILTER("Posting Date", VendDateFilter);
                    if VendPostGrFilter <> '' then
                        VendorLedgerEntry.setfilter("Vendor Posting Group", VendPostGrFilter);
                    if VendorLedgerEntry.FIND('-') then
                        repeat
                            VendorLedgerEntry.SETFILTER("Date Filter", VendDateFilter);
                            VendorLedgerEntry.CALCFIELDS("Amount (LCY)", Amount);
                            StartBalAdjLCY := StartBalAdjLCY - VendorLedgerEntry."Amount (LCY)";
                            StartBalAdj := StartBalAdj - VendorLedgerEntry.Amount;
                            "Detailed Vendor Ledg. Entry".SETCURRENTKEY("Vendor Ledger Entry No.", "Entry Type", "Posting Date");
                            "Detailed Vendor Ledg. Entry".SETRANGE("Vendor Ledger Entry No.", VendorLedgerEntry."Entry No.");
                            "Detailed Vendor Ledg. Entry".SETFILTER("Entry Type", '%1|%2',
                              "Detailed Vendor Ledg. Entry"."Entry Type"::"Correction of Remaining Amount",
                              "Detailed Vendor Ledg. Entry"."Entry Type"::"Appln. Rounding");
                            "Detailed Vendor Ledg. Entry".SETFILTER("Posting Date", VendDateFilter);
                            if VendPostGrFilter <> '' then
                                "Detailed Vendor Ledg. Entry".SetFilter("SSA Vendor Posting Group", VendPostGrFilter);
                            if "Detailed Vendor Ledg. Entry".FIND('-') then
                                repeat
                                    StartBalAdjLCY := StartBalAdjLCY - "Detailed Vendor Ledg. Entry"."Amount (LCY)";
                                    StartBalAdj := StartBalAdj - "Detailed Vendor Ledg. Entry".Amount;
                                until "Detailed Vendor Ledg. Entry".NEXT = 0;
                            "Detailed Vendor Ledg. Entry".RESET;
                        until VendorLedgerEntry.NEXT = 0;
                end;
                VendBalanceLCY := StartDebitBalanceLCY - StartCreditBalanceLCY + StartBalAdjLCY;
                VendBalance := StartDebitBalance - StartCreditBalance + StartBalAdj;
            end;

            trigger OnPreDataItem()
            begin
                CurrReport.NewPagePerRecord := PrintOnlyOnePerPage;

                CurrReport.CreateTotals("Vendor Ledger Entry"."Amount (LCY)", "Vendor Ledger Entry".Amount, TotalDebit, TotalCredit,
                                         TotalDebitLCY, TotalCreditLCY, VendBalanceLCY, VendBalance);
                CurrReport.CreateTotals(StartDebitBalance, StartCreditBalance, StartDebitBalanceLCY, StartCreditBalanceLCY, StartBalAdjLCY, StartBalAdjLCYAppl, StartBalAdj, Correction);

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
                group(Control70002)
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
        VendFilter := Vendor.GetFilters;
        VendLedgFilter := "Vendor Ledger Entry".GetFilters;
        VendDateFilter := Vendor.GetFilter("Date Filter");
        VendPostGrFilter := "Vendor Ledger Entry".GetFilter("Vendor Posting Group");

        AmountCaption := "Vendor Ledger Entry".FieldCaption(Amount);

        if Vendor.GetFilter("Date Filter") <> ''
           then
            StartingDate := Format(Vendor.GetRangeMin("Date Filter"));
        if ("Vendor Ledger Entry".GetFilter("Currency Code") = '') and SoldValuta then
            SoldValuta := false
        else begin
            CurrencyFilter := "Vendor Ledger Entry".GetFilter("Currency Code");
            Moneda := StrSubstNo(Text50008, CurrencyFilter);
        end;
        CurrencyFilter := "Vendor Ledger Entry".GetFilter("Currency Code");
        CompName := CompanyName;

        RemAmountCaption := 'Suma Ramasa MN';
        if ShowForeign then
            RemAmountCaption := 'Suma Ramasa';

        CompanyInfo.Get();
    end;

    var
        VendorLedgerEntry: Record "Vendor Ledger Entry";
        VendFilter: Text[250];
        VendDateFilter: Text[30];
        VendAmount: Decimal;
        VendEntryDueDate: Date;
        Correction: Decimal;
        PrintOnlyOnePerPage: Boolean;
        VendLedgEntryExists: Boolean;
        AmountCaption: Text[30];
        Moneda: Text[30];
        SoldValuta: Boolean;
        CurrencyFilter: Text[30];
        StartingDate: Text;
        VendAmountLCY: Decimal;
        CreateVendLedgEntry: Record "Vendor Ledger Entry";
        MarkedVendLedgerEntry: Record "Vendor Ledger Entry";
        DetVendLE: Record "Detailed Vendor Ledg. Entry";
        TotalDebit: Decimal;
        TotalCredit: Decimal;
        DebitAmount: Decimal;
        CreditAmount: Decimal;
        ClosingDocNo: Text[250];
        StartDebitBalance: Decimal;
        StartDebitBalanceLCY: Decimal;
        StartCreditBalance: Decimal;
        StartCreditBalanceLCY: Decimal;
        VendBalance: Decimal;
        VendBalanceLCY: Decimal;
        StartBalAdj: Decimal;
        StartBalAdjLCY: Decimal;
        VendPostGrFilter: Text[100];
        HideDetails: Boolean;
        VendLedgFilter: Text[250];
        DebitAmountLCY: Decimal;
        CreditAmountLCY: Decimal;
        TotalDebitLCY: Decimal;
        TotalCreditLCY: Decimal;
        Curs: Decimal;
        StartBalAdjLCYAppl: Decimal;
        SourceCodeSetup: Record "Source Code Setup";
        TVendBalanceLCY: Decimal;
        TVendBalance: Decimal;
        Text000: Label 'Period:';
        Text50008: Label '(%1)';
        Text50005: Label 'Initial Balance At Date';
        ClosingDocCaption: Label 'Closing Document No.';
        SumeDebitCaption: Label 'Debit Amount';
        SumeCreditCaption: Label 'Credit Amount';
        SumeDebitMNCaption: Label 'Debit Amount LCY';
        SumeCreditMNCaption: Label 'Credit Amount LCY';
        SoldCaption: Label 'Balance';
        SoldMNCaption: Label 'Balance LCY';
        Title: Label 'Vendor - Partner Report - currency';
        AntetCaption: Label 'This report also includes vendors that only have balances.';
        TextAjustari: Label 'Adj. of Opening Balance';
        TextAjustari2: Label 'Adj. of Opening Balance';
        TextAjustariTotala: Label 'Total Adj. of Opening Balance';
        CompName: Text;
        DocDate: Date;
        DueDate: Date;
        EntryIdx: Integer;
        RemainingAmount: Decimal;
        RemAmountCaption: Text;
        ShowForeign: Boolean;
        ApplicationRounding: Decimal;
        HideCancelledDocuments: Boolean;
        HideLine: Boolean;
        CompanyInfo: Record "Company Information";

    procedure FindApplnEntriesDtldtLedgEntry()
    var
        DtldVendLedgEntry1: Record "Detailed Vendor Ledg. Entry";
        DtldVendLedgEntry2: Record "Detailed Vendor Ledg. Entry";
    begin
        DtldVendLedgEntry1.SetCurrentKey("Vendor Ledger Entry No.");
        DtldVendLedgEntry1.SetRange("Vendor Ledger Entry No.", CreateVendLedgEntry."Entry No.");
        DtldVendLedgEntry1.SetRange(Unapplied, false);
        if DtldVendLedgEntry1.Find('-') then begin
            repeat
                if DtldVendLedgEntry1."Vendor Ledger Entry No." =
                  DtldVendLedgEntry1."Applied Vend. Ledger Entry No."
                then begin
                    DtldVendLedgEntry2.Init;
                    DtldVendLedgEntry2.SetCurrentKey("Applied Vend. Ledger Entry No.", "Entry Type");
                    DtldVendLedgEntry2.SetRange(
                      "Applied Vend. Ledger Entry No.", DtldVendLedgEntry1."Applied Vend. Ledger Entry No.");
                    DtldVendLedgEntry2.SetRange("Entry Type", DtldVendLedgEntry2."Entry Type"::Application);
                    DtldVendLedgEntry2.SetRange(Unapplied, false);
                    if DtldVendLedgEntry2.Find('-') then begin
                        repeat
                            if DtldVendLedgEntry2."Vendor Ledger Entry No." <>
                              DtldVendLedgEntry2."Applied Vend. Ledger Entry No."
                            then begin
                                MarkedVendLedgerEntry.SetCurrentKey("Entry No.");
                                MarkedVendLedgerEntry.SetRange("Entry No.", DtldVendLedgEntry2."Vendor Ledger Entry No.");
                                if MarkedVendLedgerEntry.Find('-') then
                                    MarkedVendLedgerEntry.Mark(true);
                            end;
                        until DtldVendLedgEntry2.Next = 0;
                    end;
                end else begin
                    MarkedVendLedgerEntry.SetCurrentKey("Entry No.");
                    MarkedVendLedgerEntry.SetRange("Entry No.", DtldVendLedgEntry1."Applied Vend. Ledger Entry No.");
                    if MarkedVendLedgerEntry.Find('-') then
                        MarkedVendLedgerEntry.Mark(true);
                end;
            until DtldVendLedgEntry1.Next = 0;
        end;
    end;

    procedure MarkVendLedgerEntry()
    begin
        MarkedVendLedgerEntry.ClearMarks;
        FindApplnEntriesDtldtLedgEntry;
        MarkedVendLedgerEntry.SetCurrentKey("Entry No.");
        MarkedVendLedgerEntry.SetRange("Entry No.");

        MarkedVendLedgerEntry.SetCurrentKey("Closed by Entry No.");
        MarkedVendLedgerEntry.SetRange("Closed by Entry No.", CreateVendLedgEntry."Entry No.");
        if MarkedVendLedgerEntry.Find('-') then
            repeat
                MarkedVendLedgerEntry.Mark(true);
            until MarkedVendLedgerEntry.Next = 0;

        MarkedVendLedgerEntry.SetCurrentKey("Entry No.");
        MarkedVendLedgerEntry.SetRange("Closed by Entry No.");

        MarkedVendLedgerEntry.MarkedOnly(true);
    end;
}
