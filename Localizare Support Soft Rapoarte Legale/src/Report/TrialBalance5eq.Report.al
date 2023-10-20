report 71315 "SSA Trial Balance (5 eq.)"
{
    // SSA975 SSCAT 11.10.2019 42.Rapoarte legale-Balanta verificare 5 egalitati
    DefaultLayout = RDLC;
    RDLCLayout = './src/rdlc/SSATrialBalance5eq.rdlc';
    Caption = 'Trial Balance (5 equalities)';
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem("G/L Account"; "G/L Account")
        {
            DataItemTableView = SORTING("No.");
            RequestFilterFields = "No.", "Account Type", "Date Filter", "Global Dimension 1 Filter", "Global Dimension 2 Filter";
            column(CompName; txtSociety + CompanyInfo.Name)
            {
            }
            column(lblVatRegNo; CompanyInfo.FieldCaption("VAT Registration No."))
            {
            }
            column(lblComTradeNo; CompanyInfo.FieldCaption("SSA Commerce Trade No."))
            {
            }
            column(lblAdr; CompanyInfo.FieldCaption(Address))
            {
            }
            column(VatRegNo; CompanyInfo."VAT Registration No.")
            {
            }
            column(ComTradeNo; CompanyInfo."SSA Commerce Trade No.")
            {
            }
            column(CompAdr; CompanyInfo.Address + ' ' + CompanyInfo."Address 2")
            {
            }
            column(Today_Formated; Format(Today))
            {
            }
            column(Txt_10; txtDate)
            {
            }
            column(Txt_11; txtUser)
            {
            }
            column(Txt_17; Text17)
            {
            }
            column(Filters; GLFilter)
            {
            }
            column(ReportTitle; Title_Report)
            {
            }
            column(TitlePer; Title_Period + PeriodText)
            {
            }
            column(TitleBalType; Title_BalType + BalanceType)
            {
            }
            column(WithClosing; txtWithClosing + ' ' + Format(WithClosing))
            {
            }
            column(PrintAll; all)
            {
            }
            column(ShowACY; ShowACY)
            {
            }
            dataitem(NrCrtGol; "Integer")
            {
                DataItemTableView = SORTING(Number);

                trigger OnPreDataItem()
                begin
                    SetRange(Number, 1, "G/L Account"."No. of Blank Lines");
                end;
            }
            dataitem("Integer"; "Integer")
            {
                DataItemTableView = SORTING(Number) WHERE(Number = CONST(1));
                column(ShowLine; ShowLine)
                {
                }
                column(FontBold; FontBold)
                {
                }
                column(FontItalic; FontItalic)
                {
                }
                column(AccountTrialBalance; AccountTriaBalance)
                {
                }
                column(AccountNo; AccountNo)
                {
                }
                column(AccountName; PadStr('', "G/L Account".Indentation * 2) + "G/L Account".Name)
                {
                }
                column(InitialDebitBalance; InitialDebitBalance)
                {
                }
                column(InitialCreditBalance; InitialCreditBalance)
                {
                }
                column(DebitMovements; DebitMovements)
                {
                }
                column(CreditMovements; CreditMovements)
                {
                }
                column(DebitAmount; DebitAmount)
                {
                }
                column(CreditAmount; CreditAmount)
                {
                }
                column(TotalAmounts_Debit; InitialDebitBalance + DebitMovements + DebitAmount)
                {
                }
                column(TotalAmounts_Credit; InitialCreditBalance + CreditMovements + CreditAmount)
                {
                }
                column(DebitBalance; DebitBalance)
                {
                }
                column(CreditBAlance; CreditBAlance)
                {
                }
                column(TotalInitDebitBalance; TotalInitDebitBalance)
                {
                }
                column(TotalInitCreditBalance; TotalInitCreditBalance)
                {
                }
                column(TotalDebitMovements; TotalDebitMovements)
                {
                }
                column(TotalCreditMovements; TotalCreditMovements)
                {
                }
                column(TotalDebit; TotalDebit)
                {
                }
                column(TotalCredit; TotalCredit)
                {
                }
                column(TotalAmounts_TotalDebit; TotalInitDebitBalance + TotalDebitMovements + TotalDebit)
                {
                }
                column(TotalAmounts_TotalCredit; TotalInitCreditBalance + TotalCreditMovements + TotalCredit)
                {
                }
                column(TotalDebitBalance; TotalDebitBalance)
                {
                }
                column(TotalCreditBalance; TotalCreditBalance)
                {
                }
                column(AccountType; AccountType)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    ShowLine := 0;
                    FontBold := 0;
                    FontItalic := 0;

                    if "G/L Account"."Account Type" = "G/L Account"."Account Type"::Total then
                        FontBold := 1;

                    if all then begin   //section 1
                        if (("G/L Account"."Account Type" = "G/L Account"."Account Type"::Posting) and
                           ("G/L Account"."SSA Analytic/Synth1/Synth2" = "G/L Account"."SSA Analytic/Synth1/Synth2"::Synthetic1)) then begin
                            ShowLine := 1;
                        end;
                    end
                    else begin
                        if (("G/L Account"."Account Type" = "G/L Account"."Account Type"::Posting) and
                           ("G/L Account"."SSA Analytic/Synth1/Synth2" = "G/L Account"."SSA Analytic/Synth1/Synth2"::Synthetic1)
                                              and ((InitialDebitBalance <> 0) or (InitialCreditBalance <> 0)
                                              or (DebitMovements <> 0) or (CreditMovements <> 0)
                                              or (DebitAmount <> 0) or (CreditAmount <> 0)))
                        then begin
                            ShowLine := 1;
                        end;
                    end;

                    if all then begin //section 2
                        if (("G/L Account"."Account Type" = "G/L Account"."Account Type"::Posting) and
                            ("G/L Account"."SSA Analytic/Synth1/Synth2" = "G/L Account"."SSA Analytic/Synth1/Synth2"::" ")) then
                            ShowLine := 1;
                    end
                    else begin
                        if (("G/L Account"."Account Type" = "G/L Account"."Account Type"::Posting) and
                           ("G/L Account"."SSA Analytic/Synth1/Synth2" = "G/L Account"."SSA Analytic/Synth1/Synth2"::" ")
                                              and ((InitialDebitBalance <> 0) or (InitialCreditBalance <> 0)
                                              or (DebitMovements <> 0) or (CreditMovements <> 0)
                                              or (DebitAmount <> 0) or (CreditAmount <> 0)))
                        then
                            ShowLine := 1;
                    end;

                    if all then begin //section 3
                        if (("G/L Account"."Account Type" <> "G/L Account"."Account Type"::Posting) and
                                ("G/L Account"."SSA Analytic/Synth1/Synth2" = "G/L Account"."SSA Analytic/Synth1/Synth2"::Synthetic1)) then begin
                            ShowLine := 1;
                        end;
                    end
                    else begin
                        if (("G/L Account"."Account Type" <> "G/L Account"."Account Type"::Posting) and
                                    ("G/L Account"."SSA Analytic/Synth1/Synth2" = "G/L Account"."SSA Analytic/Synth1/Synth2"::Synthetic1)
                                              and ((InitialDebitBalance <> 0) or (InitialCreditBalance <> 0)
                                              or (DebitMovements <> 0) or (CreditMovements <> 0)
                                              or (DebitAmount <> 0) or (CreditAmount <> 0))) then begin
                            ShowLine := 1;
                        end;
                    end;

                    if (AccountTriaBalance = AccountTriaBalance::Synthetic2) or (AccountTriaBalance = AccountTriaBalance::Analitical) then begin  //section 4
                        if all then begin
                            if (("G/L Account"."Account Type" = "G/L Account"."Account Type"::Posting) and
                              ("G/L Account"."SSA Analytic/Synth1/Synth2" = "G/L Account"."SSA Analytic/Synth1/Synth2"::Synthetic2)) then begin
                                ShowLine := 1;
                                FontItalic := 1;
                            end;
                        end
                        else begin
                            if (("G/L Account"."Account Type" = "G/L Account"."Account Type"::Posting) and
                               ("G/L Account"."SSA Analytic/Synth1/Synth2" = "G/L Account"."SSA Analytic/Synth1/Synth2"::Synthetic2)
                                                  and ((InitialDebitBalance <> 0) or (InitialCreditBalance <> 0)
                                                  or (DebitMovements <> 0) or (CreditMovements <> 0) //RCRVG03.n
                                                  or (DebitAmount <> 0) or (CreditAmount <> 0)))
                            then begin
                                ShowLine := 1;
                                FontItalic := 1;
                            end;
                        end;
                    end;

                    if (AccountTriaBalance = AccountTriaBalance::Synthetic2) or (AccountTriaBalance = AccountTriaBalance::Analitical) then begin //section 5
                        if all then begin
                            if (("G/L Account"."Account Type" <> "G/L Account"."Account Type"::Posting) and
                              ("G/L Account"."SSA Analytic/Synth1/Synth2" = "G/L Account"."SSA Analytic/Synth1/Synth2"::Synthetic2)) then begin
                                FontItalic := 1;
                                ShowLine := 1;
                            end;
                        end
                        else begin
                            if (("G/L Account"."Account Type" <> "G/L Account"."Account Type"::Posting) and
                               ("G/L Account"."SSA Analytic/Synth1/Synth2" = "G/L Account"."SSA Analytic/Synth1/Synth2"::Synthetic2)
                                                  and ((InitialDebitBalance <> 0) or (InitialCreditBalance <> 0)
                                                  or (DebitMovements <> 0) or (CreditMovements <> 0)
                                                  or (DebitAmount <> 0) or (CreditAmount <> 0))) then begin
                                ShowLine := 1;
                                FontItalic := 1;
                            end;
                        end;
                    end;

                    if all then begin //section 6
                        if (("G/L Account"."Account Type" <> "G/L Account"."Account Type"::Posting) and
                            ("G/L Account"."SSA Analytic/Synth1/Synth2" = "G/L Account"."SSA Analytic/Synth1/Synth2"::" ")) then
                            ShowLine := 1;
                    end
                    else begin
                        if (("G/L Account"."Account Type" <> "G/L Account"."Account Type"::Posting) and
                           ("G/L Account"."SSA Analytic/Synth1/Synth2" = "G/L Account"."SSA Analytic/Synth1/Synth2"::" ")
                                              and ((InitialDebitBalance <> 0) or (InitialCreditBalance <> 0)
                                              or (DebitMovements <> 0) or (CreditMovements <> 0)
                                              or (DebitAmount <> 0) or (CreditAmount <> 0)))
                        then
                            ShowLine := 1;
                    end;

                    if (AccountTriaBalance = AccountTriaBalance::Analitical) then begin //section 7
                        if all then begin
                            if (("G/L Account"."Account Type" <> "G/L Account"."Account Type"::Posting) and
                              ("G/L Account"."SSA Analytic/Synth1/Synth2" = "G/L Account"."SSA Analytic/Synth1/Synth2"::Analytic)) then
                                ShowLine := 1;
                        end
                        else begin
                            if (("G/L Account"."Account Type" <> "G/L Account"."Account Type"::Posting) and
                              ("G/L Account"."SSA Analytic/Synth1/Synth2" = "G/L Account"."SSA Analytic/Synth1/Synth2"::Analytic)
                                                  and ((InitialDebitBalance <> 0) or (InitialCreditBalance <> 0)
                                                  or (DebitMovements <> 0) or (CreditMovements <> 0)
                                                  or (DebitAmount <> 0) or (CreditAmount <> 0))) then
                                ShowLine := 1;
                        end;
                    end;

                    if (AccountTriaBalance = AccountTriaBalance::Analitical) then begin //section 8
                        if all then begin
                            if (("G/L Account"."Account Type" = "G/L Account"."Account Type"::Posting) and
                              ("G/L Account"."SSA Analytic/Synth1/Synth2" = "G/L Account"."SSA Analytic/Synth1/Synth2"::Analytic)) then
                                ShowLine := 1;
                        end
                        else begin
                            if (("G/L Account"."Account Type" = "G/L Account"."Account Type"::Posting) and
                               ("G/L Account"."SSA Analytic/Synth1/Synth2" = "G/L Account"."SSA Analytic/Synth1/Synth2"::Analytic)
                                                  and ((InitialDebitBalance <> 0) or (InitialCreditBalance <> 0)
                                                  or (DebitMovements <> 0) or (CreditMovements <> 0)
                                                  or (DebitAmount <> 0) or (CreditAmount <> 0))) then
                                ShowLine := 1;
                        end;
                    end;

                    if AccountNo = '' then
                        ShowLine := 0;
                end;
            }

            trigger OnAfterGetRecord()
            var
                lrGLEntry: Record "G/L Entry";
                ldInitialDebitMovements: Decimal;
                ldInitialCreditMovements: Decimal;
            begin
                InitialDebitBalance := 0;
                InitialCreditBalance := 0;
                InitialBalance := 0;
                TotalBalance := 0;
                DebitBalance := 0;
                CreditBAlance := 0;

                CurrReport.CreateTotals(InitialDebitBalance, InitialCreditBalance, DebitBalance, CreditBAlance, TotalDebit, TotalCredit);
                if Firstdayyear < Fdperiod then
                    SetFilter("Date Filter", '%1..%2', Firstdayyear, ClosingDate(Fdperiod - 1))
                else
                    SetFilter("Date Filter", '%1..%2', DMY2Date(1, 1, 2000), DMY2Date(1, 1, 2000));

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
                    DebitMovements := "Add.-Currency Debit Amount";
                    CreditMovements := "Add.-Currency Credit Amount";
                end else begin
                    DebitMovements := "Debit Amount";
                    CreditMovements := "Credit Amount";
                end;

                SetFilter("Date Filter", '<%1', Firstdayyear);
                CalcFields("Debit Amount", "Credit Amount", "Add.-Currency Debit Amount", "Add.-Currency Credit Amount");

                ldInitialDebitMovements := "Add.-Currency Debit Amount";
                ldInitialCreditMovements := "Add.-Currency Credit Amount";

                case "Debit/Credit" of
                    "Debit/Credit"::Both:
                        begin
                            if ShowACY then
                                InitialBalance := ldInitialDebitMovements - ldInitialCreditMovements
                            else
                                InitialBalance := "Debit Amount" - "Credit Amount";

                            if "G/L Account".Totaling <> '' then begin
                                if not ShowACY then begin
                                    GLAcc1.Reset;
                                    GLAcc1.SetFilter("No.", "G/L Account".Totaling);
                                    GLAcc1.SetRange(GLAcc1."Account Type", GLAcc1."Account Type"::Posting);
                                    if GlobalDim1 <> '' then
                                        GLAcc1.SetFilter("Global Dimension 1 Filter", GlobalDim1);
                                    if GlobalDim2 <> '' then
                                        GLAcc1.SetFilter("Global Dimension 2 Filter", GlobalDim2);
                                    if WithClosing then
                                        GLAcc1.SetFilter("Date Filter", '..%1', ClosingDate(Firstdayyear - 1))
                                    else
                                        GLAcc1.SetFilter(GLAcc1."Date Filter", '..%1', Firstdayyear - 1);
                                    if GLAcc1.FindFirst then
                                        repeat
                                            GLAcc1.CalcFields("Balance at Date");
                                            if GLAcc1."Debit/Credit" = GLAcc1."Debit/Credit"::Both then begin
                                                if GLAcc1."Balance at Date" < 0 then
                                                    InitialCreditBalance -= GLAcc1."Balance at Date"
                                                else
                                                    InitialDebitBalance += GLAcc1."Balance at Date";
                                            end else
                                                if GLAcc1."Debit/Credit" = GLAcc1."Debit/Credit"::Debit then
                                                    InitialDebitBalance += GLAcc1."Balance at Date"
                                                else
                                                    InitialCreditBalance -= GLAcc1."Balance at Date";
                                        until GLAcc1.Next = 0;
                                end
                                else begin
                                    GLAcc1.Reset;
                                    GLAcc1.SetFilter("No.", "G/L Account".Totaling);
                                    GLAcc1.SetRange(GLAcc1."Account Type", GLAcc1."Account Type"::Posting);
                                    if GlobalDim1 <> '' then
                                        GLAcc1.SetFilter("Global Dimension 1 Filter", GlobalDim1);
                                    if GlobalDim2 <> '' then
                                        GLAcc1.SetFilter("Global Dimension 2 Filter", GlobalDim2);
                                    if WithClosing then
                                        GLAcc1.SetFilter("Date Filter", '..%1', ClosingDate(Firstdayyear - 1))
                                    else
                                        GLAcc1.SetFilter(GLAcc1."Date Filter", '..%1', Firstdayyear - 1);
                                    if GLAcc1.FindFirst then
                                        repeat
                                            GLAcc1.CalcFields(GLAcc1."Add.-Currency Balance at Date");
                                            if GLAcc1."Debit/Credit" = GLAcc1."Debit/Credit"::Both then begin
                                                if GLAcc1."Add.-Currency Balance at Date" < 0 then
                                                    InitialCreditBalance -= GLAcc1."Add.-Currency Balance at Date"
                                                else
                                                    InitialDebitBalance += GLAcc1."Add.-Currency Balance at Date";
                                            end else
                                                if GLAcc1."Debit/Credit" = GLAcc1."Debit/Credit"::Debit then
                                                    InitialDebitBalance += GLAcc1."Add.-Currency Balance at Date"
                                                else
                                                    InitialCreditBalance -= GLAcc1."Add.-Currency Balance at Date";
                                        until GLAcc1.Next = 0;
                                end;
                            end

                            else begin
                                if InitialBalance > 0 then
                                    InitialDebitBalance := InitialBalance
                                else
                                    if InitialBalance < 0 then
                                        InitialCreditBalance := -InitialBalance;
                            end;
                            if "Account Type" in ["Account Type"::Heading, "Account Type"::"Begin-Total", "Account Type"::"End-Total"] then begin
                                InitialDebitBalance := TotalInitDebitBalance - XTotalInitDebitBalance;
                                InitialCreditBalance := TotalInitCreditBalance - XTotalInitCreditBalance;
                                XTotalInitDebitBalance := TotalInitDebitBalance;
                                XTotalInitCreditBalance := TotalInitCreditBalance;
                            end;

                        end;
                    "Debit/Credit"::Debit:
                        if ShowACY then
                            InitialDebitBalance := ldInitialDebitMovements - ldInitialCreditMovements
                        else
                            InitialDebitBalance := "Debit Amount" - "Credit Amount";
                    "Debit/Credit"::Credit:
                        if ShowACY then
                            InitialCreditBalance := ldInitialCreditMovements - ldInitialDebitMovements
                        else
                            InitialCreditBalance := "Credit Amount" - "Debit Amount";
                end;

                if "Account Type" = "Account Type"::Posting then begin
                    TotalInitDebitBalance := TotalInitDebitBalance + InitialDebitBalance;
                    TotalInitCreditBalance := TotalInitCreditBalance + InitialCreditBalance;
                    TotalDebitMovements := TotalDebitMovements + DebitMovements;
                    TotalCreditMovements := TotalCreditMovements + CreditMovements;
                end;

                SetFilter("Date Filter", Savefilter);

                Clear(fdp);
                fdp := GetRangeMax("Date Filter");

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


                if "Account Type" = "Account Type"::Posting then begin
                    if ShowACY then begin
                        TotalDebit := TotalDebit + DebitAmount;
                        TotalCredit := TotalCredit + CreditAmount;
                    end else begin
                        TotalDebit := TotalDebit + "Debit Amount";
                        TotalCredit := TotalCredit + "Credit Amount";
                    end;
                end;

                case "Debit/Credit" of
                    "Debit/Credit"::Both:
                        begin
                            if ShowACY then
                                TotalBalance := DebitAmount - CreditAmount + InitialDebitBalance - InitialCreditBalance
                                                + DebitMovements - CreditMovements

                            else
                                TotalBalance := "Debit Amount" - "Credit Amount" + InitialDebitBalance - InitialCreditBalance
                                                + DebitMovements - CreditMovements;
                            if "G/L Account".Totaling <> '' then begin
                                if not ShowACY then begin
                                    GLAcc1.Reset;
                                    GLAcc1.SetFilter("No.", "G/L Account".Totaling);
                                    GLAcc1.SetRange(GLAcc1."Account Type", GLAcc1."Account Type"::Posting);
                                    GLAcc1.SetFilter(GLAcc1."Date Filter", '..%1', fdp);
                                    if GlobalDim1 <> '' then
                                        GLAcc1.SetFilter("Global Dimension 1 Filter", GlobalDim1);
                                    if GlobalDim2 <> '' then
                                        GLAcc1.SetFilter("Global Dimension 2 Filter", GlobalDim2);
                                    if GLAcc1.FindFirst then
                                        repeat
                                            GLAcc1.CalcFields("Balance at Date");
                                            if GLAcc1."Debit/Credit" = GLAcc1."Debit/Credit"::Both then begin
                                                if GLAcc1."Balance at Date" < 0 then
                                                    CreditBAlance -= GLAcc1."Balance at Date"
                                                else
                                                    DebitBalance += GLAcc1."Balance at Date";
                                            end else
                                                if GLAcc1."Debit/Credit" = GLAcc1."Debit/Credit"::Debit then
                                                    DebitBalance += GLAcc1."Balance at Date"
                                                else
                                                    CreditBAlance -= GLAcc1."Balance at Date";
                                        until GLAcc1.Next = 0;
                                end
                                else begin
                                    GLAcc1.Reset;
                                    GLAcc1.SetFilter("No.", "G/L Account".Totaling);
                                    GLAcc1.SetRange(GLAcc1."Account Type", GLAcc1."Account Type"::Posting);
                                    GLAcc1.SetFilter(GLAcc1."Date Filter", '..%1', fdp);
                                    if GlobalDim1 <> '' then
                                        GLAcc1.SetFilter("Global Dimension 1 Filter", GlobalDim1);
                                    if GlobalDim2 <> '' then
                                        GLAcc1.SetFilter("Global Dimension 2 Filter", GlobalDim2);
                                    if GLAcc1.FindFirst then
                                        repeat
                                            GLAcc1.CalcFields(GLAcc1."Add.-Currency Balance at Date");
                                            if GLAcc1."Debit/Credit" = GLAcc1."Debit/Credit"::Both then begin
                                                if GLAcc1."Add.-Currency Balance at Date" < 0 then
                                                    CreditBAlance -= GLAcc1."Add.-Currency Balance at Date"
                                                else
                                                    DebitBalance += GLAcc1."Add.-Currency Balance at Date";
                                            end else
                                                if GLAcc1."Debit/Credit" = GLAcc1."Debit/Credit"::Debit then
                                                    DebitBalance += GLAcc1."Add.-Currency Balance at Date"
                                                else
                                                    CreditBAlance -= GLAcc1."Add.-Currency Balance at Date";
                                        until GLAcc1.Next = 0;
                                end;
                            end
                            else begin
                                if TotalBalance > 0 then
                                    DebitBalance := TotalBalance
                                else
                                    if TotalBalance < 0 then
                                        CreditBAlance := -TotalBalance;
                            end;
                            if "Account Type" in ["Account Type"::Heading, "Account Type"::"Begin-Total", "Account Type"::"End-Total"] then begin
                                DebitBalance := TotalDebitBalancePerClass;
                                CreditBAlance := TotalCreditBalancePerClass;
                                TotalDebitBalancePerClass := 0;
                                TotalCreditBalancePerClass := 0;
                            end;
                        end;
                    "Debit/Credit"::Debit:
                        if ShowACY then
                            DebitBalance := DebitAmount - CreditAmount + InitialDebitBalance - InitialCreditBalance
                                            + DebitMovements - CreditMovements
                        else
                            DebitBalance := "Debit Amount" - "Credit Amount" + InitialDebitBalance - InitialCreditBalance
                                            + DebitMovements - CreditMovements;
                    "Debit/Credit"::Credit:
                        if ShowACY then
                            CreditBAlance := CreditAmount - DebitAmount - InitialDebitBalance + InitialCreditBalance
                                             - DebitMovements + CreditMovements
                        else
                            CreditBAlance := "Credit Amount" - "Debit Amount" - InitialDebitBalance + InitialCreditBalance
                                             - DebitMovements + CreditMovements;
                end;

                if "Account Type" = "Account Type"::Posting then begin
                    TotalDebitBalance := TotalDebitBalance + DebitBalance;
                    TotalCreditBalance := TotalCreditBalance + CreditBAlance;

                    TotalDebitBalancePerClass := TotalDebitBalancePerClass + DebitBalance;
                    TotalCreditBalancePerClass := TotalCreditBalancePerClass + CreditBAlance;
                end;

                AccountNo := "No.";
                AccountType := Format("Account Type");

                //verifica sa nu aiba si sold debitor si sold creditor in acelasi timp
                if ("G/L Account"."Debit/Credit" = "G/L Account"."Debit/Credit"::Both) then begin
                    if (InitialDebitBalance <> 0) and (InitialCreditBalance <> 0) then
                        if Abs(InitialDebitBalance) > Abs(InitialCreditBalance) then begin
                            InitialDebitBalance -= InitialCreditBalance;
                            InitialCreditBalance := 0;
                        end else begin
                            InitialCreditBalance -= InitialDebitBalance;
                            InitialDebitBalance := 0;

                        end;

                    if (DebitBalance <> 0) and (CreditBAlance <> 0) then
                        if Abs(DebitBalance) > Abs(CreditBAlance) then begin
                            DebitBalance -= CreditBAlance;
                            CreditBAlance := 0;
                        end else begin
                            CreditBAlance -= DebitBalance;
                            DebitBalance := 0;

                        end;
                end;


                if "Account Type" in ["Account Type"::Heading, "Account Type"::"Begin-Total", "Account Type"::"End-Total"] then
                    Clear(AccountNo);
            end;

            trigger OnPreDataItem()
            begin
                ShowLine := 1;
                Savefilter := GetFilter("Date Filter");

                Fdperiod := GetRangeMin("Date Filter");
                Year := Date2DMY(Fdperiod, 3);
                Firstdayyear := DMY2Date(1, 1, Year);
                Firstdayprevyear := DMY2Date(1, 1, Year - 1);

                SetFilter("Date Filter", Savefilter);
            end;
        }
    }

    requestpage
    {
        Caption = 'Options';

        layout
        {
            area(content)
            {
                field(PrintChartAcc; all)
                {
                    Caption = 'Print Chart of Accounts';
                }
                field(InclClosingEntries; WithClosing)
                {
                    Caption = 'Include Closing Entries';
                }
                field(ShowACY; ShowACY)
                {
                    Caption = 'Print Amounts In Add. Currency';
                }
                field("Analytic/Synthetic1/Synthetic2"; AccountTriaBalance)
                {
                    Caption = 'Analytic / Synthetic1 / Synthetic2';
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

        trigger OnOpenPage()
        var
            lrCurrency: Record Currency;
        begin
            WithClosing := true;
            if lrCurrency.Find('-') then
                gcCurrency := lrCurrency.Code;
        end;
    }

    labels
    {
        lblFilters = 'Filters';
        lblShowACY = 'Amounts in:';
        lCol_AccountNo = 'Acc. No.';
        lCol_AccountName = 'Account Name';
        lCol_Debit = 'Debit';
        lCol_Credit = 'Credit';
        lCol_InitialBalance = 'Initial Balance';
        lCol_PrevMovements = 'Previous Movements';
        lCol_CurrMonthMov = 'Current Movements';
        lCol_TotalAmounts = 'Total Amounts';
        lCol_EndingBalance = 'Ending Balance';
        lCol_AccountType = 'Account Type';
    }

    trigger OnPreReport()
    begin
        if CompanyInfo.Get then;

        GLFilter := "G/L Account".GetFilters;
        PeriodText := "G/L Account".GetFilter("Date Filter");
        case AccountTriaBalance of
            AccountTriaBalance::Analitical:
                BalanceType := Title_Analytical;
            AccountTriaBalance::Synthetic1:
                BalanceType := Title_Synthetic1;
            AccountTriaBalance::Synthetic2:
                BalanceType := Title_Synthetic2;
        end;

        if not ShowACY then
            gcCurr := 'RON'
        else
            gcCurr := gcCurrency;

        GLSetup.Get;

        gcCurrency := GLSetup."Additional Reporting Currency";
        GlobalDim1 := "G/L Account".GetFilter("G/L Account"."Global Dimension 1 Filter");
        GlobalDim2 := "G/L Account".GetFilter("G/L Account"."Global Dimension 2 Filter");
    end;

    var
        GLAcc1: Record "G/L Account";
        CompanyInfo: Record "Company Information";
        grGLEntry: Record "G/L Entry";
        GLSetup: Record "General Ledger Setup";
        Language: Record Language;
        GLFilter: Text[250];
        PeriodText: Text[30];
        Savefilter: Text[30];
        AccountNo: Text[60];
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
        DebitMovements: Decimal;
        CreditMovements: Decimal;
        TotalBalance: Decimal;
        TotalDebitBalance: Decimal;
        TotalCreditBalance: Decimal;
        CreditBAlance: Decimal;
        DebitBalance: Decimal;
        WithClosing: Boolean;
        ShowACY: Boolean;
        Year: Integer;
        AccountTriaBalance: Option Analitical,Synthetic1,Synthetic2;
        gcCurrency: Code[10];
        gcCurr: Code[10];
        LangCode: Code[10];
        Firstdayprevyear: Date;
        TotalDebitMovements: Decimal;
        TotalCreditMovements: Decimal;
        TotalDebitBalancePerClass: Decimal;
        TotalCreditBalancePerClass: Decimal;
        fdp: Date;
        AccountType: Text[30];
        PageGroupNo: Integer;
        XTotalInitDebitBalance: Decimal;
        XTotalInitCreditBalance: Decimal;
        Title_Curr: Label 'Currency: ';
        Title_Period: Label 'Period: ';
        Title_BalType: Label 'Trial Balance Type: ';
        Title_Analytical: Label 'Analytical';
        Title_Synthetic1: Label 'Synthetic1';
        Title_Synthetic2: Label 'Synthetic2';
        Col_AccountNo: Label 'Acc. No.';
        Col_AccountName: Label 'Account Name';
        Col_Debit: Label 'Debit';
        Col_Credit: Label 'Credit';
        Col_InitialBalance: Label 'Initial Balance';
        Col_PrevMovements: Label 'Previous Movements';
        Col_CurrMonthMov: Label 'Current Movements';
        Col_TotalAmounts: Label 'Total Amounts';
        Col_EndingBalance: Label 'Ending Balance';
        Col_AccountType: Label 'Account Type';
        txtSociety: Label 'Company:';
        txtFilters: Label 'Filters:';
        txtWithClosing: Label 'With Closing:';
        txtCurrency: Label 'Amounts in:';
        Text19006072: Label 'Analytic / Synthetic1 / Synthetic2';
        Title_Report: Label 'Trial Balance (5 eq.)';
        Text17: Label 'Page:';

        all: Boolean;

        CreateExcel: Boolean;
        txtPrintAll: Label 'Print Chart of Accounts';
        ExcelTemplate: Text[250];
        ExcelBook: Text[250];
        ExcelSheet: Text[250];
        ExcelRange: Text[250];
        ExcelBookIsNew: Boolean;
        i: Integer;
        j: Integer;
        txtDate: Label 'Report Date:';
        txtUser: Label 'User:';
        ShowLine: Integer;
        FontBold: Integer;
        FontItalic: Integer;
        GlobalDim1: Text[20];
        GlobalDim2: Text[20];
        Col_Init: Text[30];
}

