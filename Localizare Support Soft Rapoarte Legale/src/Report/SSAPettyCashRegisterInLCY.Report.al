report 71300 "SSA Petty Cash Register In LCY"
{
    // SSA981 SSCAT 14.10.2019 48.Rapoarte legale-Registru de casa/banca lei
    DefaultLayout = RDLC;
    RDLCLayout = './src/rdlc/PettyCashRegisterInLCY.rdlc';
    Caption = 'Petty Cash Register In LCY';
    PreviewMode = PrintLayout;
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;

    dataset
    {
        dataitem("Bank Account"; "Bank Account")
        {
            PrintOnlyIfDetail = true;
            RequestFilterFields = "No.", "Bank Acc. Posting Group", "Date Filter";
            column(COMPANYNAME; CompanyInfo.Name)
            {
            }
            column(BankAccPostingGroup__G_L_Bank_Account_No__; BankAccPostingGroup."G/L Account No.")
            {
            }
            column(Bank_Account__TABLECAPTION__________GLFilter; "Bank Account".TableCaption + ': ' + GLFilter)
            {
            }
            column(FORMAT_TODAY_0_4_; Format(Today, 0, 4))
            {
            }
            column("USERID"; UserId)
            {
            }
            /*
            column(CurrReport_PAGENO; CurrReport.PageNo)
            {
            }
            */
            column(InitialDebitBalance; InitialDebitBalance)
            {
            }
            column(Bank_Account__No__; "No.")
            {
            }
            column(Bank_Account_Name; Name)
            {
            }
            column(Petty_Cash_Register___LCYCaption; Petty_Cash_Register___LCYCaptionLbl)
            {
            }
            column(Account_No_Caption; Account_No_CaptionLbl)
            {
            }
            column(No_Caption; No_CaptionLbl)
            {
            }
            column(Cash_Document_No_Caption; Cash_Document_No_CaptionLbl)
            {
            }
            column(Posting_DescriptionCaption; Posting_DescriptionCaptionLbl)
            {
            }
            column(Bal__AccountCaption; Bal__AccountCaptionLbl)
            {
            }
            column(Cash_ReceiptsCaption; Cash_ReceiptsCaptionLbl)
            {
            }
            column(PaymentsCaption; PaymentsCaptionLbl)
            {
            }
            column(BalanceCaption; BalanceCaptionLbl)
            {
            }
            column(Bal__Account_NameCaption; Bal__Account_NameCaptionLbl)
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
            column(Bank_Account_Date_Filter; "Date Filter")
            {
            }
            column(CompanyInfo_VATRegistrationNumber; CompanyInfo.GetVATRegistrationNumber())
            {
            }
            dataitem("Bank Account Ledger Entry"; "Bank Account Ledger Entry")
            {
                DataItemLink = "Bank Account No." = field("No."), "Posting Date" = field("Date Filter");
                DataItemTableView = sorting("Bank Account No.", "Posting Date");
                column(Bank_Account_Ledger_Entry__Document_No__; "Document No.")
                {
                }
                column(Bank_Account_Ledger_Entry__Bal__Account_No__; balaccno)
                {
                }
                column(DebitAmount; DebitAmount)
                {
                }
                column(CreditAmount; CreditAmount)
                {
                }
                column(Bank_Account_Ledger_Entry_Description; Description)
                {
                }
                column(TotalBalance; TotalBalance)
                {
                }
                column(Bank_Account_Ledger_Entry__External_Document_No__; "External Document No.")
                {
                }
                column(DescriptionShow; DescriptionShow)
                {
                }
                column(nrcrt; nrcrt)
                {
                }
                column(DebitMovements; DebitMovements)
                {
                }
                column(CreditMovements; CreditMovements)
                {
                }
                column(TotalBalance_Control49; TotalBalance)
                {
                }
                column(TotalCaption; TotalCaptionLbl)
                {
                }
                column(Bank_Account_Ledger_Entry_Entry_No_; "Entry No.")
                {
                }
                column(Bank_Account_Ledger_Entry_Bank_Account_No_; "Bank Account No.")
                {
                }
                column(Bank_Account_Ledger_Entry_Posting_Date; Format("Posting Date", 0, 1))
                {
                }

                trigger OnAfterGetRecord()
                begin
                    nrcrt := nrcrt + 1;
                    if "Debit Amount" <> 0 then
                        TotalBalance := TotalBalance + "Debit Amount"
                    else begin
                        if "Credit Amount" <> 0 then
                            TotalBalance := TotalBalance - "Credit Amount";
                    end;

                    DebitAmount := "Debit Amount";
                    CreditAmount := "Credit Amount";
                    balaccno := '';
                    case "Bal. Account Type" of
                        "Bal. Account Type"::Customer:
                            begin
                                Customer.Get("Bal. Account No.");
                                DescriptionShow := Customer.Name;
                                CLE.Reset;
                                CLE.SetCurrentKey("Transaction No.");

                                CLE.SetRange("Transaction No.", "Transaction No.");

                                if CLE.Find('-') then
                                    if CPG.Get(CLE."Customer Posting Group") then
                                        balaccno := CPG."Receivables Account";
                            end;
                        "Bal. Account Type"::Vendor:
                            begin
                                Vendor.Get("Bal. Account No.");
                                DescriptionShow := Vendor.Name;
                                vLE.Reset;
                                vLE.SetCurrentKey("Transaction No.");
                                vLE.SetRange("Transaction No.", "Transaction No.");
                                if vLE.Find('-') then
                                    if vPG.Get(vLE."Vendor Posting Group") then
                                        balaccno := vPG."Payables Account";
                            end;
                        "Bal. Account Type"::"G/L Account":
                            begin
                                if GLAccount.Get("Bal. Account No.") then;
                                DescriptionShow := GLAccount.Name;
                                balaccno := "Bal. Account No."
                            end;
                        "Bal. Account Type"::"Bank Account":
                            begin
                                BankAccount.Get("Bal. Account No.");
                                DescriptionShow := BankAccount.Name;
                                if bapg.Get("Bank Account"."Bank Acc. Posting Group") then
                                    balaccno := bapg."G/L Account No.";
                            end;
                    end;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                BankAccPostingGroup.Get("Bank Acc. Posting Group");
                SaveFilter := GetFilter("Date Filter");

                SetFilter("Date Filter", SaveFilter);
                CalcFields("Debit Amount", "Credit Amount");
                DebitMovements := "Debit Amount";
                CreditMovements := "Credit Amount";

                SetFilter("Date Filter", '<%1', GetRangeMin("Date Filter"));
                CalcFields("Debit Amount", "Credit Amount");
                InitialDebitBalance := "Debit Amount" - "Credit Amount";

                SetFilter("Date Filter", SaveFilter);
                TotalBalance := InitialDebitBalance;
            end;

            trigger OnPreDataItem()
            begin
                Period := GetFilter("Date Filter");
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
        GLFilter := "Bank Account".GetFilters;
        CompanyInfo.Get();
    end;

    var
        InitialDebitBalance: Decimal;
        TotalBalance: Decimal;
        DebitCredit: Text;
        DebitMovements: Decimal;
        CreditMovements: Decimal;
        nrcrt: Integer;
        DebitAmount: Decimal;
        CreditAmount: Decimal;
        Customer: Record Customer;
        Vendor: Record Vendor;
        GLAccount: Record "G/L Account";
        BankAccount: Record "Bank Account";
        DescriptionShow: Text;
        GLFilter: Text;
        Period: Text;
        BankAccPostingGroup: Record "Bank Account Posting Group";
        SaveFilter: Text;
        Petty_Cash_Register___LCYCaptionLbl: Label 'Petty Cash Register - LCY';
        Account_No_CaptionLbl: Label 'Account No.';
        No_CaptionLbl: Label 'No.';
        Cash_Document_No_CaptionLbl: Label 'Cash Document No.';
        Posting_DescriptionCaptionLbl: Label 'Posting Description';
        Bal__AccountCaptionLbl: Label 'Bal. Account';
        Cash_ReceiptsCaptionLbl: Label 'Cash Receipts';
        PaymentsCaptionLbl: Label 'Payments';
        BalanceCaptionLbl: Label 'Balance';
        Bal__Account_NameCaptionLbl: Label 'Bal. Account Name';
        CurrReport_PAGENOCaptionLbl: Label 'Page';
        Previous_Day_BalanceCaptionLbl: Label 'Previous Day Balance';
        TotalCaptionLbl: Label 'Total';
        CLE: Record "Cust. Ledger Entry";
        CPG: Record "Customer Posting Group";
        vLE: Record "Vendor Ledger Entry";
        vPG: Record "Vendor Posting Group";
        bapg: Record "Bank Account Posting Group";
        balaccno: Code[20];
        CompanyInfo: Record "Company Information";
}
