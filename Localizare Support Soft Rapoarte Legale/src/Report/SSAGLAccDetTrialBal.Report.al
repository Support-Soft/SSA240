report 71310 "SSA GL Acc. Det. Trial Bal."
{
    // SSA979 SSCAT 08.10.2019 46.Rapoarte legale-Fisa contului
    DefaultLayout = RDLC;
    RDLCLayout = './src/rdlc/SSAGLAccDetTrialBal.rdlc';
    Caption = 'G/L Acc. Detailed Trial Bal.';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;

    dataset
    {
        dataitem("G/L Account"; "G/L Account")
        {
            RequestFilterFields = "No.", "Date Filter", "Global Dimension 1 Filter", "Global Dimension 2 Filter", "Business Unit Filter";
            column(G_L_Account__TABLECAPTION__________GLFilter; "G/L Account".TableCaption + ': ' + GLFilter)
            {
            }
            column(COMPANYNAME; CompanyInfo.Name)
            {
            }
            column(WithClosing; WithClosing)
            {
            }
            /*
            column(CurrReport_PAGENO; CurrReport.PageNo)
            {
            }
            */
            column("USERID"; UserId)
            {
            }
            column(Text001_________No_______Name; Text001 + '  ' + "No." + ' ' + Name)
            {
            }
            column(EmptyString; '')
            {
            }
            column(DebitCredit; DebitCredit)
            {
            }
            column(InitialBalance; InitialBalance)
            {
            }
            column(DebitMovements; DebitMovements)
            {
            }
            column(CreditMovements; CreditMovements)
            {
            }
            column(dm; DM)
            {
            }
            column(cm; CM)
            {
            }
            column(im; IM)
            {
            }
            column(DebitCredit_Control1390064; DebitCredit)
            {
            }
            column(DebitMovementst; DebitMovements)
            {
            }
            column(CreditMovements_Control1390067; CreditMovements)
            {
            }
            column(FinalBalance; FinalBalance)
            {
            }
            column(DebitMovements_InitialMovemDebit; DebitMovements - InitialMovemDebit)
            {
            }
            column(CreditMovements_InitialMovemCredit; CreditMovements - InitialMovemCredit)
            {
            }
            column(TotalDebitMovements; TotalDebitMovements)
            {
            }
            column(TotalCreditMovements; TotalCreditMovements)
            {
            }
            column(Include_Closing_EntriesCaption; Include_Closing_EntriesCaptionLbl)
            {
            }
            column(G_L_Acc__Detailed_Trial_Bal_Caption; G_L_Acc__Detailed_Trial_Bal_CaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
            {
            }
            column(DateCaption; DateCaptionLbl)
            {
            }
            column(DocumentCaption; DocumentCaptionLbl)
            {
            }
            column(Posting_DescriptionCaption; Posting_DescriptionCaptionLbl)
            {
            }
            column(Balancing_AccountCaption; Balancing_AccountCaptionLbl)
            {
            }
            column(TypeCaption; TypeCaptionLbl)
            {
            }
            column(NumberCaption; NumberCaptionLbl)
            {
            }
            column(DebitCaption; DebitCaptionLbl)
            {
            }
            column(CreditCaption; CreditCaptionLbl)
            {
            }
            column(D_CCaption; D_CCaptionLbl)
            {
            }
            column(BalanceCaption; BalanceCaptionLbl)
            {
            }
            column(Entry_No_Caption; Entry_No_CaptionLbl)
            {
            }
            column(Previous_AmountCaption; Previous_AmountCaptionLbl)
            {
            }
            column(Movements_in_PeriodCaption; Movements_in_PeriodCaptionLbl)
            {
            }
            column(TotalCaption; TotalCaptionLbl)
            {
            }
            column(Total_Movements_in_PeriodCaption; Total_Movements_in_PeriodCaptionLbl)
            {
            }
            column(G_L_Account_No_; "No.")
            {
            }
            column(G_L_Account_Global_Dimension_1_Filter; "Global Dimension 1 Filter")
            {
            }
            column(G_L_Account_Global_Dimension_2_Filter; "Global Dimension 2 Filter")
            {
            }
            column(G_L_Account_Business_Unit_Filter; "Business Unit Filter")
            {
            }
            column(CompanyInfo_VATRegistrationNumber; CompanyInfo.GetVATRegistrationNumber())
            {
            }
            dataitem("G/L Entry"; "G/L Entry")
            {
                DataItemLink = "G/L Account No." = field("No."), "Global Dimension 1 Code" = field("Global Dimension 1 Filter"), "Global Dimension 2 Code" = field("Global Dimension 2 Filter"), "Business Unit Code" = field("Business Unit Filter");
                DataItemTableView = sorting("G/L Account No.", "Posting Date");
                column(Account_No___________G_L_Account_No________G_L_Account__Name; 'Account No.' + '  ' + "G/L Account No." + ' ' + "G/L Account".Name)
                {
                }
                column(EmptyString_Control1390001; '')
                {
                }
                column(G_L_Entry__Posting_Date_; "Posting Date")
                {
                }
                column(G_L_Entry__Document_Type_; "Document Type")
                {
                }
                column(G_L_Entry__Document_No__; "Document No.")
                {
                }
                column(BalAccount; BalAccount)
                {
                }
                column(DebitAmount; DebitAmount)
                {
                }
                column(CreditAmount; CreditAmount)
                {
                }
                column(G_L_Entry_Description; Description)
                {
                }
                column(FinalBalance_Control1390049; FinalBalance)
                {
                }
                column(DebitCredit_Control1390050; DebitCredit)
                {
                }
                column(G_L_Entry__Entry_No__; "Entry No.")
                {
                }
                column(DateCaption_Control1390079; DateCaption_Control1390079Lbl)
                {
                }
                column(DocumentCaption_Control1390080; DocumentCaption_Control1390080Lbl)
                {
                }
                column(TypeCaption_Control1390081; TypeCaption_Control1390081Lbl)
                {
                }
                column(NumberCaption_Control1390082; NumberCaption_Control1390082Lbl)
                {
                }
                column(Posting_DescriptionCaption_Control1390083; Posting_DescriptionCaption_Control1390083Lbl)
                {
                }
                column(Balancing_AccountCaption_Control1390084; Balancing_AccountCaption_Control1390084Lbl)
                {
                }
                column(DebitCaption_Control1390085; DebitCaption_Control1390085Lbl)
                {
                }
                column(CreditCaption_Control1390086; CreditCaption_Control1390086Lbl)
                {
                }
                column(D_CCaption_Control1390087; D_CCaption_Control1390087Lbl)
                {
                }
                column(BalanceCaption_Control1390088; BalanceCaption_Control1390088Lbl)
                {
                }
                column(Entry_No_Caption_Control1390089; Entry_No_Caption_Control1390089Lbl)
                {
                }
                column(G_L_Entry_G_L_Account_No_; "G/L Account No.")
                {
                }
                column(G_L_Entry_Global_Dimension_1_Code; "Global Dimension 1 Code")
                {
                }
                column(G_L_Entry_Global_Dimension_2_Code; "Global Dimension 2 Code")
                {
                }
                column(G_L_Entry_Business_Unit_Code; "Business Unit Code")
                {
                }
                column(G_L_Entry_Transaction_No_; "Transaction No.")
                {
                }
                dataitem("G/LEntry2"; "G/L Entry")
                {
                    DataItemLink = "Document Type" = field("Document Type"), "Document No." = field("Document No."), "Transaction No." = field("Transaction No.");
                    DataItemTableView = sorting("Document No.", "Posting Date");
                    column(G_LEntry2__Posting_Date_; "Posting Date")
                    {
                    }
                    column(CreditAmount_Control1390053; CreditAmount)
                    {
                    }
                    column(DebitCredit_Control1390054; DebitCredit)
                    {
                    }
                    column(G_LEntry2__G_L_Account_No__; "G/L Account No.")
                    {
                    }
                    column(G_LEntry2__Document_Type_; "Document Type")
                    {
                    }
                    column(G_LEntry2__Document_No__; "Document No.")
                    {
                    }
                    column(G_LEntry2_Description; Description)
                    {
                    }
                    column(DebitAmount_Control1390059; DebitAmount)
                    {
                    }
                    column(G_LEntry2__Entry_No__; "Entry No.")
                    {
                    }
                    column(FinalBalance_Control1390061; FinalBalance)
                    {
                    }
                    column(G_LEntry2_Transaction_No_; "Transaction No.")
                    {
                    }

                    trigger OnAfterGetRecord()
                    begin
                        case "G/L Account"."Debit/Credit" of
                            "G/L Account"."Debit/Credit"::Both:
                                begin
                                    if DebitCredit = 'C' then
                                        FinalBalance := -FinalBalance;
                                    FinalBalance := FinalBalance - "Debit Amount" + "Credit Amount";
                                    if FinalBalance > 0 then
                                        DebitCredit := 'D'
                                    else begin
                                        DebitCredit := 'C';
                                        FinalBalance := -FinalBalance;
                                    end;
                                end;
                            "G/L Account"."Debit/Credit"::Debit:
                                begin
                                    FinalBalance := FinalBalance - "Debit Amount" + "Credit Amount";
                                    DebitCredit := 'D';
                                end;
                            "G/L Account"."Debit/Credit"::Credit:
                                begin
                                    FinalBalance := FinalBalance + "Debit Amount" - "Credit Amount";
                                    DebitCredit := 'C';
                                end;
                        end;
                        if FinalBalance = 0 then
                            DebitCredit := '';

                        DebitAmount := "Credit Amount";
                        CreditAmount := "Debit Amount";
                        CreditMovements := CreditMovements + CreditAmount;
                        DebitMovements := DebitMovements + DebitAmount;
                    end;

                    trigger OnPreDataItem()
                    begin
                        if show then
                            SetFilter("G/L Account No.", '=%1', BalAcc)
                        else
                            SetFilter("Entry No.", '<>%1', "G/L Entry"."Entry No.");
                        "G/L Entry".CopyFilter("G/L Entry"."Posting Date", "Posting Date");
                    end;
                }

                trigger OnAfterGetRecord()
                begin
                    DebitAmount := 0;
                    CreditAmount := 0;
                    BalAccount := '';
                    show := true;
                    DebitGLEntry.Reset;
                    CreditGLEntry.Reset;
                    CreditGLEntry.SetCurrentKey(CreditGLEntry."Transaction No.");
                    DebitGLEntry.SetCurrentKey(DebitGLEntry."Transaction No.");
                    DebitGLEntry.SetFilter(DebitGLEntry."Transaction No.", '=%1', "Transaction No.");
                    CreditGLEntry.SetFilter(CreditGLEntry."Transaction No.", '=%1', "Transaction No.");
                    DebitGLEntry.SetFilter(DebitGLEntry."Debit Amount", '<>0');
                    CreditGLEntry.SetFilter(CreditGLEntry."Credit Amount", '<>0');
                    Count1 := DebitGLEntry.Count;
                    Count2 := CreditGLEntry.Count;

                    if ((Count2 = 1) and (Count1 = 1)) or ((Count2 = 0) and (Count1 = 1)) or ((Count2 = 1) and (Count1 = 0)) then begin
                        if "Debit Amount" <> 0 then begin
                            if CreditGLEntry.Find('-') then
                                BalAccount := CreditGLEntry."G/L Account No.";
                        end else begin
                            if DebitGLEntry.Find('-') then
                                BalAccount := DebitGLEntry."G/L Account No.";
                        end;
                        BalAcc := '000';
                    end else begin
                        if ((Count1 = 1) and ("Debit Amount" <> 0)) or ((Count2 = 1) and ("Credit Amount" <> 0)) then begin
                            BalAcc := "G/L Account No.";
                            show := false;
                        end else begin
                            if (Count1 = 1) and (Count2 <> 1) then begin
                                DebitGLEntry.Find('-');
                                BalAccount := DebitGLEntry."G/L Account No.";
                            end;
                            if (Count2 = 1) and (Count1 <> 1) then begin
                                CreditGLEntry.Find('-');
                                BalAccount := CreditGLEntry."G/L Account No.";
                            end;
                            BalAcc := '000';
                        end;
                        if (Count1 <> 1) and (Count2 <> 1) then begin
                            show := true;
                            BalAcc := '';
                        end;
                    end;

                    if show then begin
                        case "G/L Account"."Debit/Credit" of
                            "G/L Account"."Debit/Credit"::Both:
                                begin
                                    if DebitCredit = 'C' then
                                        FinalBalance := -FinalBalance;
                                    FinalBalance := FinalBalance + "Debit Amount" - "Credit Amount";
                                    if FinalBalance > 0 then
                                        DebitCredit := 'D'
                                    else begin
                                        DebitCredit := 'C';
                                        FinalBalance := -FinalBalance;
                                    end;
                                end;
                            "G/L Account"."Debit/Credit"::Debit:
                                begin
                                    FinalBalance := FinalBalance + "Debit Amount" - "Credit Amount";
                                    DebitCredit := 'D';
                                end;
                            "G/L Account"."Debit/Credit"::Credit:
                                begin
                                    FinalBalance := FinalBalance - "Debit Amount" + "Credit Amount";
                                    DebitCredit := 'C';
                                end;
                        end;

                        if FinalBalance = 0 then
                            DebitCredit := '';

                        DebitAmount := "Debit Amount";
                        CreditAmount := "Credit Amount";
                        DebitMovements := DebitMovements + DebitAmount;
                        CreditMovements := CreditMovements + CreditAmount;
                    end;
                end;

                trigger OnPreDataItem()
                begin
                    "G/L Account".CopyFilter("G/L Account"."Date Filter", "Posting Date");
                end;
            }

            trigger OnAfterGetRecord()
            begin
                SetFilter("Date Filter", SaveFilter);
                SetFilter("Date Filter", '%1..%2', FirstDayYear, ClosingDate(FirstDay - 1));
                CalcFields("Debit Amount", "Credit Amount");

                DebitMovements := "Debit Amount";
                CreditMovements := "Credit Amount";
                SetFilter("Date Filter", '<%1', FirstDayYear);

                if not WithClosing then begin
                    SetFilter("Date Filter", GetFilter("Date Filter") +
                              ' & <>%1 & <>%2 & <>%3 & <>%4 & <>%5 & <>%6 & <>%7',
                              ClosingDate(DMY2Date(1, 2, Year) - 1), ClosingDate(DMY2Date(1, 3, Year) - 1), ClosingDate(DMY2Date(1, 4, Year) - 1),
                              ClosingDate(DMY2Date(1, 5, Year) - 1), ClosingDate(DMY2Date(1, 6, Year) - 1), ClosingDate(DMY2Date(1, 7, Year) - 1),
                              ClosingDate(DMY2Date(1, 8, Year) - 1));
                    SetFilter("Date Filter", GetFilter("Date Filter") +
                              ' & <>%1 & <>%2 & <>%3 & <>%4 & <>%5',
                              ClosingDate(DMY2Date(1, 9, Year) - 1), ClosingDate(DMY2Date(1, 10, Year) - 1), ClosingDate(DMY2Date(1, 11, Year) - 1),
                              ClosingDate(DMY2Date(1, 12, Year) - 1), ClosingDate(DMY2Date(1, 1, Year + 1) - 1));
                end;

                CalcFields("Debit Amount", "Credit Amount");

                case "Debit/Credit" of
                    "Debit/Credit"::Both:
                        begin
                            InitialBalance := "Debit Amount" - "Credit Amount" + DebitMovements - CreditMovements;
                            if InitialBalance > 0 then begin
                                DebitCredit := 'D';
                                DebitMovements := DebitMovements + "Debit Amount" - "Credit Amount";
                            end else
                                if InitialBalance < 0 then begin
                                    DebitCredit := 'C';
                                    InitialBalance := -InitialBalance;
                                    CreditMovements := CreditMovements + "Debit Amount" - "Credit Amount";
                                end else
                                    DebitCredit := ' ';
                        end;
                    "Debit/Credit"::Debit:
                        begin
                            InitialBalance := "Debit Amount" - "Credit Amount" + DebitMovements - CreditMovements;
                            DebitCredit := 'D';
                            DebitMovements := DebitMovements + "Debit Amount" - "Credit Amount";
                        end;
                    "Debit/Credit"::Credit:
                        begin
                            InitialBalance := "Credit Amount" - "Debit Amount" - DebitMovements + CreditMovements;
                            DebitCredit := 'C';
                            CreditMovements := CreditMovements + "Credit Amount" - "Debit Amount";
                        end;
                end;

                SetFilter("Date Filter", SaveFilter);

                if not WithClosing then begin
                    SetFilter("Date Filter", GetFilter("Date Filter") +
                             ' & <>%1 & <>%2 & <>%3 & <>%4 & <>%5 & <>%6 & <>%7',
                             ClosingDate(DMY2Date(1, 2, Year) - 1), ClosingDate(DMY2Date(1, 3, Year) - 1), ClosingDate(DMY2Date(1, 4, Year) - 1),
                             ClosingDate(DMY2Date(1, 5, Year) - 1), ClosingDate(DMY2Date(1, 6, Year) - 1), ClosingDate(DMY2Date(1, 7, Year) - 1),
                             ClosingDate(DMY2Date(1, 8, Year) - 1));
                    SetFilter("Date Filter", GetFilter("Date Filter") +
                              ' & <>%1 & <>%2 & <>%3 & <>%4 & <>%5',
                              ClosingDate(DMY2Date(1, 9, Year) - 1), ClosingDate(DMY2Date(1, 10, Year) - 1), ClosingDate(DMY2Date(1, 11, Year) - 1),
                              ClosingDate(DMY2Date(1, 12, Year) - 1), ClosingDate(DMY2Date(1, 1, Year + 1) - 1));
                end;

                FinalBalance := InitialBalance;
                InitialMovemDebit := DebitMovements;
                InitialMovemCredit := CreditMovements;

                DM := DebitMovements;
                CM := CreditMovements;
                IM := InitialBalance;
                ;
            end;

            trigger OnPreDataItem()
            begin
                SaveFilter := GetFilter("Date Filter");
                FirstDay := GetRangeMin("Date Filter");
                Year := Date2DMY(GetRangeMin("Date Filter"), 3);
                FirstDayYear := DMY2Date(1, 1, Year);
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
                    field(WithClosing; WithClosing)
                    {
                        Caption = 'Include Closing Entries';
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the Include Closing Entries field.';
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnOpenPage()
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
        CompanyInfo.Get();
    end;

    var
        DebitGLEntry: Record "G/L Entry";
        CreditGLEntry: Record "G/L Entry";
        FirstDay: Date;
        FirstDayYear: Date;
        Year: Integer;
        Count1: Integer;
        Count2: Integer;
        InitialBalance: Decimal;
        FinalBalance: Decimal;
        DebitMovements: Decimal;
        CreditMovements: Decimal;
        DebitAmount: Decimal;
        CreditAmount: Decimal;
        InitialMovemDebit: Decimal;
        InitialMovemCredit: Decimal;
        TotalDebitMovements: Decimal;
        TotalCreditMovements: Decimal;
        show: Boolean;
        BalAcc: Code[20];
        BalAccount: Code[20];
        WithClosing: Boolean;
        SaveFilter: Text[30];
        GLFilter: Text[250];
        DebitCredit: Text[1];
        Text001: Label 'Account No.';
        DM: Decimal;
        CM: Decimal;
        IM: Decimal;
        Include_Closing_EntriesCaptionLbl: Label 'Include Closing Entries';
        G_L_Acc__Detailed_Trial_Bal_CaptionLbl: Label 'G/L Acc. Detailed Trial Bal.';
        CurrReport_PAGENOCaptionLbl: Label 'Page';
        DateCaptionLbl: Label 'Date';
        DocumentCaptionLbl: Label 'Document';
        Posting_DescriptionCaptionLbl: Label 'Posting Description';
        Balancing_AccountCaptionLbl: Label 'Balancing Account';
        TypeCaptionLbl: Label 'Type';
        NumberCaptionLbl: Label 'Number';
        DebitCaptionLbl: Label 'Debit';
        CreditCaptionLbl: Label 'Credit';
        D_CCaptionLbl: Label 'D/C';
        BalanceCaptionLbl: Label 'Balance';
        Entry_No_CaptionLbl: Label 'Entry No.';
        Previous_AmountCaptionLbl: Label 'Previous Amount';
        Movements_in_PeriodCaptionLbl: Label 'Movements in Period';
        TotalCaptionLbl: Label 'Total';
        Total_Movements_in_PeriodCaptionLbl: Label 'Total Movements in Period';
        DateCaption_Control1390079Lbl: Label 'Date';
        DocumentCaption_Control1390080Lbl: Label 'Document';
        TypeCaption_Control1390081Lbl: Label 'Type';
        NumberCaption_Control1390082Lbl: Label 'Number';
        Posting_DescriptionCaption_Control1390083Lbl: Label 'Posting Description';
        Balancing_AccountCaption_Control1390084Lbl: Label 'Balancing Account';
        DebitCaption_Control1390085Lbl: Label 'Debit';
        CreditCaption_Control1390086Lbl: Label 'Credit';
        D_CCaption_Control1390087Lbl: Label 'D/C';
        BalanceCaption_Control1390088Lbl: Label 'Balance';
        Entry_No_Caption_Control1390089Lbl: Label 'Entry No.';
        CompanyInfo: Record "Company Information";
}
