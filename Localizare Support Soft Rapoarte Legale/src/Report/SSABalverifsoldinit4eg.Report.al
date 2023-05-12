report 71301 "SSABal. verif. sold init(4eg)"
{
    // SSA977 SSCAT 11.10.2019 44.Rapoarte legale-Balanta de verificare sold initial
    DefaultLayout = RDLC;
    RDLCLayout = './src/rdlc/SSABalverifsoldinit4eg.rdlc';
    Caption = 'Balanta de verificare sold initial (4 eg.)';
    PreviewMode = PrintLayout;
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem("G/L Account"; "G/L Account")
        {
            DataItemTableView = SORTING("No.");
            RequestFilterFields = "No.", "Account Type", "Date Filter", "Global Dimension 1 Filter", "Global Dimension 2 Filter", "Business Unit Filter";
            column(Account_Type; "G/L Account"."Account Type")
            {
            }
            column(ShowACY; ShowACY)
            {
            }
            column(all; all)
            {
            }
            column(Period______PeriodText; 'Period: ' + PeriodText)
            {
            }
            column(G_L_Account__TABLECAPTION______________GLFilter; "G/L Account".TableCaption + ': ' + ' ' + GLFilter)
            {
            }
            column(Text000___BalanceType; Text000 + BalanceType)
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
            column(TotalInitDebitBalance; TotalInitDebitBalance)
            {
            }
            column(TotalInitCreditBalance; TotalInitCreditBalance)
            {
            }
            column(TotalDebitBalance; TotalDebitBalance)
            {
            }
            column(TotalCreditBalance; TotalCreditBalance)
            {
            }
            column(G_L_Trial_Balance___Initial_AmountsCaption; G_L_Trial_Balance___Initial_AmountsCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Ending_BalanceCaption; Ending_BalanceCaptionLbl)
            {
            }
            column(Account_No_Caption; Account_No_CaptionLbl)
            {
            }
            column(Account_NameCaption; Account_NameCaptionLbl)
            {
            }
            column(DebitCaption; DebitCaptionLbl)
            {
            }
            column(CreditCaption; CreditCaptionLbl)
            {
            }
            column(DebitCaption_Control7; DebitCaption_Control7Lbl)
            {
            }
            column(CreditCaption_Control32; CreditCaption_Control32Lbl)
            {
            }
            column(DebitCaption_Control33; DebitCaption_Control33Lbl)
            {
            }
            column(CreditCaption_Control34; CreditCaption_Control34Lbl)
            {
            }
            column(DebitCaption_Control35; DebitCaption_Control35Lbl)
            {
            }
            column(CreditCaption_Control36; CreditCaption_Control36Lbl)
            {
            }
            column(Total_AmountsCaption; Total_AmountsCaptionLbl)
            {
            }
            column(Current_Month_MovementsCaption; Current_Month_MovementsCaptionLbl)
            {
            }
            column(Initial_BalanceCaption; Initial_BalanceCaptionLbl)
            {
            }
            column(TotalCaption; TotalCaptionLbl)
            {
            }
            column(G_L_Account_No_; "No.")
            {
            }
            column(BoldLine; BoldLine)
            {
            }
            column(CompanyInfo_VATRegistrationNumber; CompanyInfo.GetVATRegistrationNumber())
            {

            }
            dataitem(NrCrtGol; "Integer")
            {
                DataItemTableView = SORTING(Number);

                trigger OnPreDataItem()
                begin
                    NrCrtGol.SetRange(Number, 1, "G/L Account"."No. of Blank Lines");
                end;
            }
            dataitem("Integer"; "Integer")
            {
                DataItemTableView = SORTING(Number) WHERE(Number = CONST(1));
                column(PADSTR_____G_L_Account__Indentation___2___G_L_Account__Name; PadStr('', "G/L Account".Indentation * 2) + "G/L Account".Name)
                {
                }
                column(InitialDebitBalance; InitialDebitBalance)
                {
                }
                column(InitialCreditBalance; InitialCreditBalance)
                {
                }
                column(DebitAmount; DebitAmount)
                {
                }
                column(CreditAmount; CreditAmount)
                {
                }
                column(TotalDebit; TotalDebit)
                {
                }
                column(TotalCredit; TotalCredit)
                {
                }
                column(TotalInitDebitBalance_TotalDebit; TotalInitDebitBalance)
                {
                }
                column(TotalInitCreditBalance_TotalCredit; TotalInitCreditBalance)
                {
                }
                column(RulajDebit; RulajDebit)
                {
                }
                column(RulajCredit; RulajCredit)
                {
                }
                column(DebitBalance; DebitBalance)
                {
                }
                column(CreditBAlance; CreditBAlance)
                {
                }
                column(AccountNo; AccountNo)
                {
                }
                column(AccountNo_Control1000000000; AccountNo)
                {
                }
                column(PADSTR_____G_L_Account__Indentation___2___G_L_Account__Name_Control1000000001; PadStr('', "G/L Account".Indentation * 2) + "G/L Account".Name)
                {
                }
                column(InitialDebitBalance_Control1000000002; InitialDebitBalance)
                {
                }
                column(InitialCreditBalance_Control1000000003; InitialCreditBalance)
                {
                }
                column(DebitAmount_Control1000000004; DebitAmount)
                {
                }
                column(CreditAmount_Control1000000005; CreditAmount)
                {
                }
                column(InitialDebitBalance__G_L_Account___Add__Currency_Debit_Amount_; InitialDebitBalance + "G/L Account"."Add.-Currency Debit Amount")
                {
                }
                column(InitialCreditBalance__G_L_Account___Add__Currency_Credit_Amount_; InitialCreditBalance + "G/L Account"."Add.-Currency Credit Amount")
                {
                }
                column(DebitBalance_Control1000000008; DebitBalance)
                {
                }
                column(CreditBAlance_Control1000000009; CreditBAlance)
                {
                }
                column(PADSTR_____G_L_Account__Indentation___2___G_L_Account__Name_Control26; PadStr('', "G/L Account".Indentation * 2) + "G/L Account".Name)
                {
                }
                column(InitialDebitBalance__G_L_Account___Debit_Amount__Control17; InitialDebitBalance + "G/L Account"."Debit Amount")
                {
                }
                column(InitialCreditBalance__G_L_Account___Credit_Amount__Control18; InitialCreditBalance + "G/L Account"."Credit Amount")
                {
                }
                column(DebitBalance_Control21; DebitBalance)
                {
                }
                column(CreditBAlance_Control22; CreditBAlance)
                {
                }
                column(InitialDebitBalance_Control27; InitialDebitBalance)
                {
                }
                column(InitialCreditBalance_Control28; InitialCreditBalance)
                {
                }
                column(DebitAmount_Control29; DebitAmount)
                {
                }
                column(CreditAmount_Control30; CreditAmount)
                {
                }
                column(AccountNo_Control41; AccountNo)
                {
                }
                column(AccountNo_Control1000000010; AccountNo)
                {
                }
                column(PADSTR_____G_L_Account__Indentation___2___G_L_Account__Name_Control1000000011; PadStr('', "G/L Account".Indentation * 2) + "G/L Account".Name)
                {
                }
                column(InitialDebitBalance__G_L_Account___Add__Currency_Debit_Amount__Control1000000012; InitialDebitBalance + "G/L Account"."Add.-Currency Debit Amount")
                {
                }
                column(InitialCreditBalance__G_L_Account___Add__Currency_Credit_Amount__Control1000000013; InitialCreditBalance + "G/L Account"."Add.-Currency Credit Amount")
                {
                }
                column(DebitBalance_Control1000000014; DebitBalance)
                {
                }
                column(CreditBAlance_Control1000000015; CreditBAlance)
                {
                }
                column(InitialDebitBalance_Control1000000016; InitialDebitBalance)
                {
                }
                column(InitialCreditBalance_Control1000000017; InitialCreditBalance)
                {
                }
                column(DebitAmount_Control1000000018; DebitAmount)
                {
                }
                column(CreditAmount_Control1000000019; CreditAmount)
                {
                }
                column(Integer_Number; Number)
                {
                }
                column(RulajTotalDebit; RulajTotalDebit)
                {
                }
                column(RulajTotalCredit; RulajTotalCredit)
                {
                }
            }

            trigger OnPreDataItem()
            begin
                case AccountTriaBalance of
                    AccountTriaBalance::Synthetic1:
                        SetFilter("SSA Analytic/Synth1/Synth2", '%1|%2', "SSA Analytic/Synth1/Synth2"::Synthetic1,
                          "SSA Analytic/Synth1/Synth2"::" ");
                    AccountTriaBalance::Synthetic2:
                        SetFilter("SSA Analytic/Synth1/Synth2", '%1|%2|%3', "SSA Analytic/Synth1/Synth2"::Synthetic1,
                          "SSA Analytic/Synth1/Synth2"::Synthetic2, "SSA Analytic/Synth1/Synth2"::" ");
                end;

                Savefilter := GetFilter("Date Filter");

                Fdperiod := GetRangeMin("Date Filter");
                EndCurrPeriod := GetRangeMax("Date Filter");
                Year := Date2DMY(Fdperiod, 3);
                Firstdayyear := DMY2Date(1, 1, Year);
                SetFilter("Date Filter", Savefilter);
            end;

            trigger OnAfterGetRecord()
            begin
                InitialDebitBalance := 0;
                InitialCreditBalance := 0;
                InitialBalance := 0;
                TotalBalance := 0;
                DebitBalance := 0;
                CreditBAlance := 0;
                Clear(RulajCredit);
                Clear(RulajDebit);

                //Balanta Initiala
                SetFilter("Date Filter", '..%1', ClosingDate(Firstdayyear - 1));
                CalcFields("Debit Amount", "Credit Amount", "Add.-Currency Debit Amount", "Add.-Currency Credit Amount");
                case "Debit/Credit" of
                    "Debit/Credit"::Both:
                        begin
                            if ShowACY then
                                InitialBalance := "Add.-Currency Debit Amount" - "Add.-Currency Credit Amount"
                            else
                                InitialBalance := "Debit Amount" - "Credit Amount";
                            if InitialBalance > 0 then
                                InitialDebitBalance := InitialBalance
                            else
                                if InitialBalance < 0 then
                                    InitialCreditBalance := -InitialBalance;
                        end;
                    "Debit/Credit"::Debit:
                        if ShowACY then
                            InitialDebitBalance := "Add.-Currency Debit Amount" - "Add.-Currency Credit Amount"
                        else
                            InitialDebitBalance := "Debit Amount" - "Credit Amount";
                    "Debit/Credit"::Credit:
                        if ShowACY then
                            InitialCreditBalance := "Add.-Currency Credit Amount" - "Add.-Currency Debit Amount"
                        else
                            InitialCreditBalance := "Credit Amount" - "Debit Amount";
                end;

                case AccountTriaBalance of
                    AccountTriaBalance::Synthetic1:
                        begin
                            if "SSA Analytic/Synth1/Synth2" = "SSA Analytic/Synth1/Synth2"::Synthetic1 then begin
                                TotalInitDebitBalance += InitialDebitBalance;
                                TotalInitCreditBalance += InitialCreditBalance;
                            end;
                        end;
                    AccountTriaBalance::Synthetic2:
                        begin
                            if "SSA Analytic/Synth1/Synth2" = "SSA Analytic/Synth1/Synth2"::Synthetic1 then begin
                                TotalInitDebitBalance += InitialDebitBalance;
                                TotalInitCreditBalance += InitialCreditBalance;
                            end;
                        end;
                    AccountTriaBalance::Analitical:
                        if "Account Type" = "Account Type"::Posting then begin
                            TotalInitDebitBalance += InitialDebitBalance;
                            TotalInitCreditBalance += InitialCreditBalance;
                        end;
                end;
                //END Balanta Initiala

                //Rulaj Luna Curenta
                SetFilter("Date Filter", Savefilter);
                if not WithClosing then begin
                    SetFilter("Date Filter", GetFilter("Date Filter") + ' & <>%1 & <>%2 & <>%3 & <>%4 & <>%5 & <>%6 & <>%7',
                              ClosingDate(DMY2Date(1, 2, Year) - 1), ClosingDate(DMY2Date(1, 3, Year) - 1), ClosingDate(DMY2Date(1, 4, Year) - 1),
                              ClosingDate(DMY2Date(1, 5, Year) - 1), ClosingDate(DMY2Date(1, 6, Year) - 1), ClosingDate(DMY2Date(1, 7, Year) - 1),
                              ClosingDate(DMY2Date(1, 8, Year) - 1));
                    SetFilter("Date Filter", GetFilter("Date Filter") + ' & <>%1 & <>%2 & <>%3 & <>%4 & <>%5',
                              ClosingDate(DMY2Date(1, 9, Year) - 1), ClosingDate(DMY2Date(1, 10, Year) - 1), ClosingDate(DMY2Date(1, 11, Year) - 1),
                              ClosingDate(DMY2Date(1, 12, Year) - 1), ClosingDate(DMY2Date(1, 1, Year + 1) - 1));
                end;
                CalcFields("Debit Amount", "Credit Amount", "Add.-Currency Debit Amount", "Add.-Currency Credit Amount");

                if ShowACY then begin
                    DebitAmount := "Add.-Currency Debit Amount";
                    CreditAmount := "Add.-Currency Credit Amount";
                end else begin
                    DebitAmount := "Debit Amount";
                    CreditAmount := "Credit Amount";
                end;

                case AccountTriaBalance of
                    AccountTriaBalance::Synthetic1:
                        if "SSA Analytic/Synth1/Synth2" = "SSA Analytic/Synth1/Synth2"::Synthetic1 then begin
                            if ShowACY then begin
                                TotalDebit += "Add.-Currency Debit Amount";
                                TotalCredit += "Add.-Currency Credit Amount";
                            end else begin
                                TotalDebit += "Debit Amount";
                                TotalCredit += "Credit Amount";
                            end;
                        end;
                    AccountTriaBalance::Synthetic2:
                        if "SSA Analytic/Synth1/Synth2" = "SSA Analytic/Synth1/Synth2"::Synthetic2 then begin
                            if ShowACY then begin
                                TotalDebit += "Add.-Currency Debit Amount";
                                TotalCredit += "Add.-Currency Credit Amount";
                            end else begin
                                TotalDebit += "Debit Amount";
                                TotalCredit += "Credit Amount";
                            end;
                        end;
                    AccountTriaBalance::Analitical:
                        begin
                            if "Account Type" = "Account Type"::Posting then begin
                                if ShowACY then begin
                                    TotalDebit += "Add.-Currency Debit Amount";
                                    TotalCredit += "Add.-Currency Credit Amount";
                                end else begin
                                    TotalDebit += "Debit Amount";
                                    TotalCredit += "Credit Amount";
                                end;
                            end;
                        end;
                end;
                //END Rulaj Luna Curenta

                //RULAJ Total
                SetFilter("Date Filter", '%1..%2', Firstdayyear, ClosingDate(EndCurrPeriod));
                if not WithClosing then begin
                    SetFilter("Date Filter", GetFilter("Date Filter") + ' & <>%1 & <>%2 & <>%3 & <>%4 & <>%5 & <>%6 & <>%7',
                              ClosingDate(DMY2Date(1, 2, Year) - 1), ClosingDate(DMY2Date(1, 3, Year) - 1), ClosingDate(DMY2Date(1, 4, Year) - 1),
                              ClosingDate(DMY2Date(1, 5, Year) - 1), ClosingDate(DMY2Date(1, 6, Year) - 1), ClosingDate(DMY2Date(1, 7, Year) - 1),
                              ClosingDate(DMY2Date(1, 8, Year) - 1));
                    SetFilter("Date Filter", GetFilter("Date Filter") + ' & <>%1 & <>%2 & <>%3 & <>%4 & <>%5',
                              ClosingDate(DMY2Date(1, 9, Year) - 1), ClosingDate(DMY2Date(1, 10, Year) - 1), ClosingDate(DMY2Date(1, 11, Year) - 1),
                              ClosingDate(DMY2Date(1, 12, Year) - 1), ClosingDate(DMY2Date(1, 1, Year + 1) - 1));
                end;
                CalcFields("Debit Amount", "Credit Amount", "Add.-Currency Debit Amount", "Add.-Currency Credit Amount");

                if ShowACY then begin
                    RulajDebit := "Add.-Currency Debit Amount";
                    RulajCredit := "Add.-Currency Credit Amount";
                end else begin
                    RulajDebit := "Debit Amount";
                    RulajCredit := "Credit Amount";
                end;
                case AccountTriaBalance of
                    AccountTriaBalance::Synthetic1:
                        if "SSA Analytic/Synth1/Synth2" = "SSA Analytic/Synth1/Synth2"::Synthetic1 then begin
                            if ShowACY then begin
                                RulajTotalDebit += "Add.-Currency Debit Amount";
                                RulajTotalCredit += "Add.-Currency Credit Amount";
                            end else begin
                                RulajTotalDebit += "Debit Amount";
                                RulajTotalCredit += "Credit Amount";
                            end;
                        end;
                    AccountTriaBalance::Synthetic2:
                        if "SSA Analytic/Synth1/Synth2" = "SSA Analytic/Synth1/Synth2"::Synthetic2 then begin
                            if ShowACY then begin
                                RulajTotalDebit += "Add.-Currency Debit Amount";
                                RulajTotalCredit += "Add.-Currency Credit Amount";
                            end else begin
                                RulajTotalDebit += "Debit Amount";
                                RulajTotalCredit += "Credit Amount";
                            end;
                        end;
                    AccountTriaBalance::Analitical:
                        begin
                            if "Account Type" = "Account Type"::Posting then begin
                                if ShowACY then begin
                                    RulajTotalDebit += "Add.-Currency Debit Amount";
                                    RulajTotalCredit += "Add.-Currency Credit Amount";
                                end else begin
                                    RulajTotalDebit += "Debit Amount";
                                    RulajTotalCredit += "Credit Amount";
                                end;
                            end;
                        end;
                end;
                //END Rulaj Total

                //Ending Balance
                case "Debit/Credit" of
                    "Debit/Credit"::Both:
                        begin
                            TotalBalance := RulajDebit - RulajCredit + InitialDebitBalance - InitialCreditBalance;
                            if TotalBalance > 0 then
                                DebitBalance := TotalBalance
                            else
                                if TotalBalance < 0 then
                                    CreditBAlance := -TotalBalance;
                        end;
                    "Debit/Credit"::Debit:
                        DebitBalance := RulajDebit - RulajCredit + InitialDebitBalance - InitialCreditBalance;
                    "Debit/Credit"::Credit:
                        CreditBAlance := RulajCredit - RulajDebit - InitialDebitBalance + InitialCreditBalance;
                end;

                case AccountTriaBalance of
                    AccountTriaBalance::Synthetic1:
                        begin
                            if "SSA Analytic/Synth1/Synth2" = "SSA Analytic/Synth1/Synth2"::Synthetic1 then begin
                                TotalDebitBalance += DebitBalance;
                                TotalCreditBalance += CreditBAlance;
                            end;
                        end;
                    AccountTriaBalance::Synthetic2:
                        if "SSA Analytic/Synth1/Synth2" = "SSA Analytic/Synth1/Synth2"::Synthetic1 then begin
                            TotalDebitBalance += DebitBalance;
                            TotalCreditBalance := TotalCreditBalance + CreditBAlance;
                        end;
                    AccountTriaBalance::Analitical:
                        if "Account Type" = "Account Type"::Posting then begin
                            TotalDebitBalance += DebitBalance;
                            TotalCreditBalance += CreditBAlance;
                        end;
                end;
                //END Ending Balance

                AccountNo := "No.";
                //if InitialDebitBalance + InitialCreditBalance + DebitAmount + CreditAmount + DebitBalance + CreditBAlance = 0 then
                //    CurrReport.Skip;
                if (InitialDebitBalance = 0) and
                    (InitialCreditBalance = 0) and
                    (DebitAmount = 0) and
                    (CreditAmount = 0) and
                    (RulajDebit = 0) and
                    (RulajCredit = 0) and
                    (DebitBalance = 0) and
                    (CreditBAlance = 0)
                then
                    CurrReport.Skip;
                if "Account Type" = "Account Type"::Posting then
                    BoldLine := false
                else
                    BoldLine := true;

                if StrPos("No.", '.99') > 0 then begin
                    GLAccount.Get("No.");
                    GLAccount.CalcFields(Balance);
                    if GLAccount.Balance = 0 then
                        CurrReport.Skip;
                end;
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(all; all)
                    {
                        Caption = 'Print Chart of Accounts';
                    }
                    field(WithClosing; WithClosing)
                    {
                        Caption = 'Include Closing Entries';
                    }
                    field(ShowACY; ShowACY)
                    {
                        Caption = 'Show in ACY';
                    }
                    field(AccountTriaBalance; AccountTriaBalance)
                    {
                        Caption = 'Analytic / Synthetic1 / Synthetic2';
                        OptionCaption = 'Analytic,Synthetic1,Synthetic2';
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnInit()
        begin
            WithClosing := true;
        end;
    }

    labels
    {
    }

    trigger OnPreReport()
    begin
        GLFilter := "G/L Account".GetFilters;
        PeriodText := "G/L Account".GetFilter("Date Filter");
        case AccountTriaBalance of
            AccountTriaBalance::Analitical:
                BalanceType := Text001;
            AccountTriaBalance::Synthetic1:
                BalanceType := Text002;
            AccountTriaBalance::Synthetic2:
                BalanceType := Text003;
        end;
        CompanyInfo.Get();
    end;

    var
        GLAccount: Record "G/L Account";
        GLFilter: Text[250];
        PeriodText: Text[30];
        Savefilter: Text[30];
        AccountNo: Code[20];
        BalanceType: Text[30];
        Fdperiod: Date;
        Firstdayyear: Date;
        TotalDebit: Decimal;
        DebitAmount: Decimal;
        TotalCredit: Decimal;
        CreditAmount: Decimal;
        InitialBalance: Decimal;
        InitialDebitBalance: Decimal;
        TotalInitDebitBalance: Decimal;
        InitialCreditBalance: Decimal;
        TotalInitCreditBalance: Decimal;
        TotalBalance: Decimal;
        TotalDebitBalance: Decimal;
        TotalCreditBalance: Decimal;
        CreditBAlance: Decimal;
        DebitBalance: Decimal;
        all: Boolean;
        WithClosing: Boolean;
        [InDataSet]
        ShowACY: Boolean;
        i: Integer;
        Year: Integer;
        Text000: Label 'Trial Balance Type: ';
        AccountTriaBalance: Option Analitical,Synthetic1,Synthetic2;
        Text001: Label 'Analytic';
        Text002: Label 'Synthetic1';
        Text003: Label 'Synthetic2';
        G_L_Trial_Balance___Initial_AmountsCaptionLbl: Label 'G/L Trial Balance - Initial Amounts';
        CurrReport_PAGENOCaptionLbl: Label 'Page';
        Ending_BalanceCaptionLbl: Label 'Ending Balance';
        Account_No_CaptionLbl: Label 'Account No.';
        Account_NameCaptionLbl: Label 'Account Name';
        DebitCaptionLbl: Label 'Debit';
        CreditCaptionLbl: Label 'Credit';
        DebitCaption_Control7Lbl: Label 'Debit';
        CreditCaption_Control32Lbl: Label 'Credit';
        DebitCaption_Control33Lbl: Label 'Debit';
        CreditCaption_Control34Lbl: Label 'Credit';
        DebitCaption_Control35Lbl: Label 'Debit';
        CreditCaption_Control36Lbl: Label 'Credit';
        Total_AmountsCaptionLbl: Label 'Total Amounts';
        Current_Month_MovementsCaptionLbl: Label 'Current Month Movements';
        Initial_BalanceCaptionLbl: Label 'Initial Balance';
        TotalCaptionLbl: Label 'Total';
        USERID: Text[50];
        BoldLine: Boolean;
        RulajDebit: Decimal;
        RulajCredit: Decimal;
        RulajTotalDebit: Decimal;
        RulajTotalCredit: Decimal;
        EndCurrPeriod: Date;
        CompanyInfo: Record "Company Information";
}

