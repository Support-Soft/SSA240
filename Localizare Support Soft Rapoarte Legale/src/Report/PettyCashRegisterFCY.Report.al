report 71312 "SSA Petty Cash Register FCY"
{
    // SSA982 SSCAT 14.10.2019 49.Rapoarte legale-Registru de casa/banca valuta
    DefaultLayout = RDLC;
    RDLCLayout = './src/rdlc/SSAPettyCashRegisterFCY.rdlc';
    Caption = 'Petty Cash Register FCY';
    PreviewMode = PrintLayout;
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem("Bank Account Posting Group"; "Bank Account Posting Group")
        {
            PrintOnlyIfDetail = true;
            RequestFilterFields = "G/L Account No.";
            column(Bank_Account_Posting_Group_Code; Code)
            {
            }
            dataitem("Bank Account"; "Bank Account")
            {
                DataItemLink = "Bank Acc. Posting Group" = FIELD(Code);
                PrintOnlyIfDetail = false;
                RequestFilterFields = "Date Filter";
                column(Bank_Account__TABLECAPTION__________BankFilter; "Bank Account".TableCaption + ': ' + BankFilter)
                {
                }
                column(COMPANYNAME; CompanyInfo.Name)
                {
                }
                column(FORMAT_TODAY_0_4_; Format(Today, 0, 4))
                {
                }
                column(USERID; UserId)
                {
                }
                /*
                column(CurrReport_PAGENO; CurrReport.PageNo)
                {
                }
                */
                column(InitialBalanceLCY; InitialBalanceLCY)
                {
                }
                column(Bank_Account__Currency_Code_; "Currency Code")
                {
                }
                column(InitialBalance; InitialBalance)
                {
                }
                column(Bank_Account__No__; "No.")
                {
                }
                column(Bank_Account_Name; Name)
                {
                }
                column(TotalBalanceLCY; TotalBalanceLCY)
                {
                }
                column(DebitMovementsLCY; DebitMovementsLCY)
                {
                }
                column(CreditMovementsLCY; CreditMovementsLCY)
                {
                }
                column(TotalBalance; TotalBalance)
                {
                }
                column(DebitMovements; DebitMovements)
                {
                }
                column(CreditMovements; CreditMovements)
                {
                }
                column(Petty_Cash_Register_in_Foreign_CurrencyCaption; Petty_Cash_Register_in_Foreign_CurrencyCaptionLbl)
                {
                }
                column(Currency_CodeCaption; Currency_CodeCaptionLbl)
                {
                }
                column(Payments___LCYCaption; Payments___LCYCaptionLbl)
                {
                }
                column(Cash_Receipts___LCYCaption; Cash_Receipts___LCYCaptionLbl)
                {
                }
                column(Payments___FCYCaption; Payments___FCYCaptionLbl)
                {
                }
                column(Cash_Receipts___FCYCaption; Cash_Receipts___FCYCaptionLbl)
                {
                }
                column(Bal__Account_No_Caption; Bal__Account_No_CaptionLbl)
                {
                }
                column(Posting_DescriptionCaption; Posting_DescriptionCaptionLbl)
                {
                }
                column(Cash_Document_No_Caption; Cash_Document_No_CaptionLbl)
                {
                }
                column(No_Caption; No_CaptionLbl)
                {
                }
                column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
                {
                }
                column(Previous_Day_BalanceCaption; Previous_Day_BalanceCaptionLbl)
                {
                }
                column(Bank_Account__No__Caption; FieldCaption("No."))
                {
                }
                column(TotalCaption; TotalCaptionLbl)
                {
                }
                column(BalanceCaption; BalanceCaptionLbl)
                {
                }
                column(Bank_Account_Bank_Acc__Posting_Group; "Bank Acc. Posting Group")
                {
                }
                column(Bank_Account_Date_Filter; "Date Filter")
                {
                }
                column(PreviousDebitAmount; PreviousDebitAmount)
                {
                }
                column(PreviousCreditAmount; PreviousCreditAmount)
                {
                }
                column(Bal__Account_NameCaptionLbl; Bal__Account_NameCaptionLbl)
                {
                }
                column(CompanyInfo_VATRegistrationNumber; CompanyInfo.GetVATRegistrationNumber())
                {

                }
                dataitem("Bank Account Ledger Entry"; "Bank Account Ledger Entry")
                {
                    DataItemLink = "Bank Account No." = FIELD("No."), "Posting Date" = FIELD("Date Filter");
                    DataItemTableView = SORTING("Bank Account No.", "Posting Date");
                    column(nrcrt; nrcrt)
                    {
                    }
                    column(Bank_Account_Ledger_Entry__Document_No__; "Document No.")
                    {
                    }
                    column(Bank_Account_Ledger_Entry__Debit_Amount__LCY__; "Debit Amount (LCY)")
                    {
                    }
                    column(Bank_Account_Ledger_Entry__Credit_Amount__LCY__; "Credit Amount (LCY)")
                    {
                    }
                    column(Bank_Account_Ledger_Entry_Description; Description)
                    {
                    }
                    column(Bank_Account_Ledger_Entry__Debit_Amount_; "Debit Amount")
                    {
                    }
                    column(Bank_Account_Ledger_Entry__Credit_Amount_; "Credit Amount")
                    {
                    }
                    column(Bank_Account_Ledger_Entry__Currency_Code_; "Currency Code")
                    {
                    }
                    column(Bank_Account_Ledger_Entry__Bal__Account_No__; balaccno)
                    {
                    }
                    column(Bank_Account_Ledger_Entry_Entry_No_; "Entry No.")
                    {
                    }
                    column(Bank_Account_Ledger_Entry_Bank_Account_No_; "Bank Account No.")
                    {
                    }
                    column(Bank_Account_Ledger_Entry_Posting_Date; Format("Posting Date"))
                    {
                    }
                    column(DescriptionShow; DescriptionShow)
                    {
                    }

                    trigger OnAfterGetRecord()
                    begin
                        if nrcrt = 0 then begin
                            PreviousDay := "Bank Account Ledger Entry"."Posting Date";
                            PreviousDebitAmount := 0;
                            PreviousCreditAmount := 0;
                            PreviousDebitAmountLCY := 0;
                            PreviousCreditAmountLCY := 0;

                        end;
                        nrcrt := nrcrt + 1;
                        if PreviousDay = "Posting Date" then begin
                            PreviousDebitAmount += "Debit Amount";
                            ;
                            PreviousCreditAmount += "Credit Amount";
                            PreviousDebitAmountLCY += "Debit Amount (LCY)";
                            ;
                            PreviousCreditAmountLCY += "Credit Amount (LCY)";

                        end;
                        if PreviousDay <> "Posting Date" then begin
                            InitialBalance += PreviousDebitAmount - PreviousCreditAmount;
                            InitialBalanceLCY += PreviousDebitAmountLCY - PreviousCreditAmountLCY;

                            PreviousDebitAmount := 0;
                            PreviousCreditAmount := 0;
                            PreviousDebitAmountLCY := 0;
                            PreviousCreditAmountLCY := 0;

                            PreviousDay := "Posting Date";
                            PreviousDebitAmount += "Debit Amount";
                            ;
                            PreviousCreditAmount += "Credit Amount";
                            PreviousDebitAmountLCY += "Debit Amount (LCY)";
                            PreviousCreditAmountLCY += "Credit Amount (LCY)";

                        end;

                        if "Debit Amount" <> 0 then begin
                            TotalBalanceLCY := TotalBalanceLCY + "Debit Amount (LCY)";
                            TotalBalance := TotalBalance + "Debit Amount";
                            DebitMovementsLCY := DebitMovementsLCY + "Debit Amount (LCY)";
                            DebitAmount := "Debit Amount";
                            DebitMovements := DebitMovements + "Debit Amount";
                            DebitCredit := 'D';
                        end else begin
                            if "Credit Amount" <> 0 then begin
                                TotalBalanceLCY := TotalBalanceLCY - "Credit Amount (LCY)";
                                TotalBalance := TotalBalance - "Credit Amount";
                                CreditMovementsLCY := CreditMovementsLCY + "Credit Amount (LCY)";
                                CreditAmount := "Credit Amount";
                                CreditMovements := CreditMovements + "Credit Amount";
                                DebitCredit := 'C';
                            end;
                        end;
                        balaccno := '';
                        case "Bal. Account Type" of
                            "Bal. Account Type"::Customer:
                                begin
                                    customer.Get("Bal. Account No.");
                                    DescriptionShow := customer.Name;
                                    CLE.Reset;
                                    CLE.SetCurrentKey("Transaction No.");

                                    CLE.SetRange("Transaction No.", "Transaction No.");

                                    if CLE.Find('-') then
                                        if CPG.Get(CLE."Customer Posting Group") then
                                            balaccno := CPG."Receivables Account";
                                end;
                            "Bal. Account Type"::Vendor:
                                begin
                                    vendor.Get("Bal. Account No.");
                                    DescriptionShow := vendor.Name;
                                    vLE.Reset;
                                    vLE.SetCurrentKey("Transaction No.");
                                    vLE.SetRange("Transaction No.", "Transaction No.");
                                    if vLE.Find('-') then
                                        if vPG.Get(vLE."Vendor Posting Group") then
                                            balaccno := vPG."Payables Account";

                                end;
                            "Bal. Account Type"::"G/L Account":
                                begin
                                    if Glaccount.Get("Bal. Account No.") then;
                                    DescriptionShow := Glaccount.Name;
                                    balaccno := "Bal. Account No."
                                end;
                            "Bal. Account Type"::"Bank Account":
                                begin
                                    bankaccount.Get("Bal. Account No.");
                                    DescriptionShow := bankaccount.Name;
                                    if bapg.Get("Bank Account"."Bank Acc. Posting Group") then
                                        balaccno := bapg."G/L Account No.";

                                end;
                        end;
                    end;
                }

                trigger OnAfterGetRecord()
                var
                    salvezfiltru: Text;
                begin
                    salvezfiltru := GetFilter("Date Filter");
                    SetFilter("Currency Code", '=%1', Currency.Code);
                    SetFilter("Date Filter", '%1..%2', 0D, ClosingDate(GetRangeMin("Date Filter") - 1));

                    CalcFields("Debit Amount", "Credit Amount", "Debit Amount (LCY)", "Credit Amount (LCY)");

                    InitialBalanceLCY := "Debit Amount (LCY)" - "Credit Amount (LCY)";
                    InitialBalance := "Debit Amount" - "Credit Amount";

                    SetFilter("Date Filter", salvezfiltru);
                    TotalBalanceLCY := InitialBalanceLCY;
                    TotalBalance := InitialBalance;
                    PreviousDebitAmount := 0;
                    PreviousCreditAmount := 0;
                    PreviousDebitAmountLCY := 0;
                    PreviousCreditAmountLCY := 0;
                end;
            }
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
        BankFilter := "Bank Account".GetFilters;
        CompanyInfo.Get();
    end;

    var
        Currency: Record Currency;
        Number: Integer;
        InitialBalanceLCY: Decimal;
        InitialBalance: Decimal;
        TotalBalanceLCY: Decimal;
        TotalBalance: Decimal;
        DebitAmount: Decimal;
        CreditAmount: Decimal;
        DebitCredit: Text;
        nrcrt: Integer;
        DebitAmountLCY: Decimal;
        CreditAmountLCY: Decimal;
        BankFilter: Text;
        DebitMovementsLCY: Decimal;
        DebitMovements: Decimal;
        CreditMovementsLCY: Decimal;
        CreditMovements: Decimal;
        Petty_Cash_Register_in_Foreign_CurrencyCaptionLbl: Label 'Petty Cash Register in Foreign Currency';
        Currency_CodeCaptionLbl: Label 'Currency Code';
        Payments___LCYCaptionLbl: Label 'Payments - LCY';
        Cash_Receipts___LCYCaptionLbl: Label 'Cash Receipts - LCY';
        Payments___FCYCaptionLbl: Label 'Payments - FCY';
        Cash_Receipts___FCYCaptionLbl: Label 'Cash Receipts - FCY';
        Bal__Account_No_CaptionLbl: Label 'Bal. Account No.';
        Posting_DescriptionCaptionLbl: Label 'Posting Description';
        Cash_Document_No_CaptionLbl: Label 'Cash Document No.';
        No_CaptionLbl: Label 'No.';
        CurrReport_PAGENOCaptionLbl: Label 'Page';
        Previous_Day_BalanceCaptionLbl: Label 'Previous Day Balance';
        TotalCaptionLbl: Label 'Total';
        BalanceCaptionLbl: Label 'Balance';
        PreviousDebitAmount: Decimal;
        PreviousCreditAmount: Decimal;
        PreviousDay: Date;
        PreviousDebitAmountLCY: Decimal;
        PreviousCreditAmountLCY: Decimal;
        CLE: Record "Cust. Ledger Entry";
        CPG: Record "Customer Posting Group";
        vLE: Record "Vendor Ledger Entry";
        vPG: Record "Vendor Posting Group";
        bapg: Record "Bank Account Posting Group";
        balaccno: Code[20];
        vendor: Record Vendor;
        customer: Record Customer;
        bankaccount: Record "Bank Account";
        DescriptionShow: Text;
        Glaccount: Record "G/L Account";
        Bal__Account_NameCaptionLbl: Label 'Bal. Account Name';
        CompanyInfo: Record "Company Information";
}

