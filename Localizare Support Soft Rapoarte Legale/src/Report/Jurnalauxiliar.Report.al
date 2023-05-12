report 71311 "SSA Jurnal auxiliar"
{
    // SSA1010 SSCAT 14.10.2019 41.Rapoarte legale-Registru jurnal (jurnal auxiliar)
    DefaultLayout = RDLC;
    RDLCLayout = './src/rdlc/SSAJurnalauxiliar.rdlc';
    Caption = 'Jurnal Auxiliar';
    UsageCategory = ReportsAndAnalysis;
    dataset
    {
        dataitem("G/L Entry"; "G/L Entry")
        {
            DataItemTableView = SORTING("Posting Date", "Document No.");
            RequestFilterFields = "Posting Date", "G/L Account No.", "Journal Batch Name", "Source Code", "Document No.";
            column(nrcrt; nrcrt)
            {
            }
            column(PostingDate_GLEntry; "G/L Entry"."Posting Date")
            {
            }
            column(DocumentType_GLEntry; "G/L Entry"."Document Type")
            {
            }
            column(DocNo; DocNo)
            {
            }
            column(Description_GLEntry; "G/L Entry".Description)
            {
            }
            column(EntryNo_GLEntry; "G/L Entry"."Entry No.")
            {
            }
            column(DebitAmount_GLEntry; "G/L Entry"."Debit Amount")
            {
            }
            column(CreditAmount_GLEntry; "G/L Entry"."Credit Amount")
            {
            }
            column(SourceCode_GLEntry; "G/L Entry"."Source Code")
            {
            }
            column(Title; Title)
            {
            }
            column(CompName; CompName)
            {
            }
            column(CompNameCaption; CompNameCaption)
            {
            }
            column(CUI; CUI)
            {
            }
            column(CUICaption; CUICaption)
            {
            }
            column(ComTradeNo; ComTradeNo)
            {
            }
            column(ComTrNoCaption; ComTrNoCaption)
            {
            }
            column(PageCaption; PageCaption)
            {
            }
            column(NrCaption; NrCaption)
            {
            }
            column(DateCaption; DateCaption)
            {
            }
            column(TypeCaption; TypeCaption)
            {
            }
            column(NumarCaption; NumarCaption)
            {
            }
            column(DocCaption; DocCaption)
            {
            }
            column(DescrCaption; DescrCaption)
            {
            }
            column(DebitCaption; DebitCaption)
            {
            }
            column(CreditCaption; CreditCaption)
            {
            }
            column(NreCaption; NreCaption)
            {
            }
            column(SumeCaption; SumeCaption)
            {
            }
            column(IntrareCaption; IntrareCaption)
            {
            }
            column(TotalCaption; TotalCaption)
            {
            }
            column(DebitAccounts1; DebitAccounts[1])
            {
            }
            column(CreditAccounts1; CreditAccounts[1])
            {
            }
            column(DebitAmounts1; DebitAmounts[1])
            {
            }
            column(CreditAmounts1; CreditAmounts[1])
            {
            }
            column(Account; Account)
            {
            }
            column(BalAccount; BalAccount)
            {
            }
            column(Show1; show1)
            {
            }
            column(DebitMovements; DebitMovements)
            {
            }
            column(CreditMovements; CreditMovements)
            {
            }
            column(DebitMovements2; DebitMovements2)
            {
            }
            column(CreditMovements2; CreditMovements2)
            {
            }
            column(PostingDate; PostingDate)
            {
            }
            column(show; show)
            {
            }
            column(show3; show3)
            {
            }
            column(n; n)
            {
            }
            dataitem("G/LEntry2"; "G/L Entry")
            {
                DataItemLink = "Posting Date" = FIELD("Posting Date"), "Document Type" = FIELD("Document Type"), "Document No." = FIELD("Document No."), "Transaction No." = FIELD("Transaction No.");
                DataItemTableView = SORTING("Posting Date", "Document No.");
                column(DebitAmount_GLEntry2; "G/LEntry2"."Debit Amount")
                {
                }
                column(CreditAmount_GLEntry2; "G/LEntry2"."Credit Amount")
                {
                }
                column(EntryNo_GLEntry2; "G/LEntry2"."Entry No.")
                {
                }
                column(Account2; Account2)
                {
                }
                column(BalAccount2; BalAccount2)
                {
                }

                trigger OnAfterGetRecord()
                var
                    GLE: Record "G/L Entry";
                    GLEntry2: Record "G/L Entry";
                begin
                    if "Debit Amount" <> 0 then begin
                        DebitMovements1 := DebitMovements1 + "Debit Amount";
                        Account2 := "G/L Account No.";
                        if not ((Count1 = 1) and (Count2 = 1)) then
                            BalAccount2 := '';

                        DebitMovements := DebitMovements + "Debit Amount";
                    end;

                    if "Credit Amount" <> 0 then begin
                        CreditMovements1 := CreditMovements1 + "Credit Amount";
                        BalAccount2 := "G/L Account No.";
                        if not ((Count1 = 1) and (Count2 = 1)) then
                            Account2 := '';

                        CreditMovements := CreditMovements + "Credit Amount";
                    end;
                end;

                trigger OnPreDataItem()
                begin
                    if (not show) or ((Count1 = 1) and (Count2 = 1)) then
                        SetFilter("G/L Account No.", '=%1', BalAcc)
                    else
                        SetFilter("Entry No.", '<>%1', "G/L Entry"."Entry No.");

                    SetFilter("Posting Date", '=%1', "G/L Entry"."Posting Date");
                    if show1 then CurrReport.Break;
                end;
            }
            dataitem("Integer"; "Integer")
            {
                DataItemTableView = SORTING(Number);
                column(number; Number)
                {
                }
                column(DebitAccounts2; DebitAccounts2)
                {
                }
                column(CreditAccounts2; CreditAccounts2)
                {
                }
                column(DebitAmounts2; DebitAmounts2)
                {
                }
                column(CreditAmounts2; CreditAmounts2)
                {
                }

                trigger OnAfterGetRecord()
                var
                    VE: Record "Value Entry";
                begin
                    if Integer.Number > 1 then begin
                        INDEX := Integer.Number;
                        show3 := true;
                        if not show1 then show3 := false;

                        if indexdebit >= INDEX then begin
                            DebitAccounts2 := DebitAccounts[INDEX];
                            DebitAmounts2 := DebitAmounts[INDEX];
                        end
                        else begin
                            Clear(DebitAccounts2);
                            Clear(DebitAmounts2)
                        end;

                        if indexcredit >= INDEX then begin
                            CreditAccounts2 := CreditAccounts[INDEX];
                            CreditAmounts2 := CreditAmounts[INDEX];
                        end
                        else begin
                            Clear(CreditAccounts2);
                            Clear(CreditAmounts2)
                        end;

                    end
                    else
                        show3 := false;
                end;

                trigger OnPreDataItem()
                begin
                    if indexdebit >= indexcredit then
                        Integer.SetRange(Integer.Number, 1, indexdebit)
                    else
                        Integer.SetRange(Integer.Number, 1, indexcredit);
                end;
            }

            trigger OnAfterGetRecord()
            var
                VE: Record "Value Entry";
                DebitEntryNo: Integer;
                CreditEntryNo: Integer;
                TransactionNo: Integer;
            begin
                if Amount = 0 then CurrReport.Skip;
                BalAccount := '';
                show := false;
                n := 0;
                Clear(DebitAccounts);
                Clear(CreditAccounts);
                Clear(DebitAmounts);
                Clear(CreditAmounts);

                Clear(DebitAccounts2);
                Clear(CreditAccounts2);
                Clear(DebitAmounts2);
                Clear(CreditAmounts2);
                show1 := false;
                show3 := false;

                indexdebit := 1;
                indexcredit := 1;
                INDEX := 1;
                PostingDate := Format("Posting Date");

                DebitGLEntry.Reset;
                DebitGLEntry.SetCurrentKey(DebitGLEntry."Transaction No.");
                DebitGLEntry.SetFilter(DebitGLEntry."Transaction No.", '=%1', "Transaction No.");
                DebitGLEntry.SetFilter(DebitGLEntry."Posting Date", '=%1', "Posting Date");
                DebitGLEntry.SetFilter(DebitGLEntry."Debit Amount", '<>0');
                Count1 := DebitGLEntry.Count;

                CreditGLEntry.Reset;
                CreditGLEntry.SetCurrentKey(CreditGLEntry."Transaction No.");
                CreditGLEntry.SetFilter(CreditGLEntry."Transaction No.", '=%1', "Transaction No.");
                CreditGLEntry.SetFilter(CreditGLEntry."Posting Date", '=%1', "Posting Date");
                CreditGLEntry.SetFilter(CreditGLEntry."Credit Amount", '<>0');
                Count2 := CreditGLEntry.Count;

                if (Count2 = 1) and (Count1 = 1) then begin
                    if "Debit Amount" <> 0 then begin
                        CreditGLEntry.Find('-');
                        BalAccount := CreditGLEntry."G/L Account No.";
                        Account := "G/L Account No.";
                    end else begin
                        DebitGLEntry.Find('-');
                        BalAccount := DebitGLEntry."G/L Account No.";
                        Account := "G/L Account No.";
                    end;
                    show := "Debit Amount" <> 0;
                    BalAcc := '000';
                end else begin
                    if ((Count1 = 1) and ("Debit Amount" <> 0)) or ((Count2 = 1) and ("Credit Amount" <> 0)) then begin
                        BalAcc := "G/L Account No.";
                        if "Debit Amount" <> 0 then begin
                            BalAccount := '%';
                            Account := "G/L Account No.";
                        end else begin
                            Account := '%';
                            BalAccount := "G/L Account No.";
                        end;
                        show := true;
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
                        show1 := true;
                        DebitAccounts[1] := '%';
                        CreditAccounts[1] := '%';
                        if CreditGLEntry.Find('-') then;
                        if DebitGLEntry.Find('-') then
                            if (DebitGLEntry."Entry No." < "Entry No.") or (CreditGLEntry."Entry No." < "Entry No.") then
                                show1 := false
                            else
                                repeat
                                    if DebitGLEntry."Debit Amount" <> 0 then begin
                                        if DebitGLEntry."Entry No." <> DebitEntryNo then begin
                                            indexdebit := indexdebit + 1;
                                            DebitAccounts[indexdebit] := DebitGLEntry."G/L Account No.";
                                            DebitAmounts[indexdebit] := DebitGLEntry."Debit Amount";
                                            DebitAmounts[1] := DebitAmounts[1] + DebitGLEntry."Debit Amount";
                                            DebitEntryNo := DebitGLEntry."Entry No.";
                                        end;
                                    end;
                                    if CreditGLEntry."Credit Amount" <> 0 then begin
                                        if CreditGLEntry."Entry No." <> CreditEntryNo then begin
                                            indexcredit := indexcredit + 1;
                                            CreditAccounts[indexcredit] := CreditGLEntry."G/L Account No.";
                                            CreditAmounts[indexcredit] := CreditGLEntry."Credit Amount";
                                            CreditAmounts[1] := CreditAmounts[1] + CreditGLEntry."Credit Amount";
                                            CreditEntryNo := CreditGLEntry."Entry No.";
                                        end;
                                    end;

                                until (DebitGLEntry.Next() = 0) and (CreditGLEntry.Next() = 0);  //mva171216
                    end;
                end;

                if show then begin
                    if not ((Count1 = 1) and (Count2 = 1)) then begin
                        if "Debit Amount" <> 0 then
                            DebitMovements1 := DebitMovements1 + "Debit Amount";
                        if "Credit Amount" <> 0 then
                            CreditMovements1 := CreditMovements1 + "Credit Amount";
                    end;
                    if (Count1 = 1) and (Count2 = 1) then begin
                        if "Debit Amount" <> 0 then begin
                            "Credit Amount" := "Debit Amount";
                            CreditMovements1 := CreditMovements1 + "Debit Amount";
                            DebitMovements1 := DebitMovements1 + "Credit Amount";
                        end else
                            if "Credit Amount" <> 0 then begin
                                "Debit Amount" := "Credit Amount";
                                DebitMovements1 := DebitMovements1 + "Credit Amount";
                                CreditMovements1 := CreditMovements1 + "Debit Amount";
                            end;
                    end;
                end;


                if show1 then begin
                    DebitMovements1 := DebitMovements1 + DebitAmounts[1];
                    CreditMovements1 := CreditMovements1 + CreditAmounts[1];

                end;

                if "G/L Entry"."Source Type" = "G/L Entry"."Source Type"::Vendor then
                    DocNo := "G/L Entry"."External Document No."
                else
                    if ("G/L Entry"."Source Type" = "G/L Entry"."Source Type"::" ") and ("G/L Entry"."External Document No." <> '') then
                        DocNo := "G/L Entry"."External Document No."
                    else
                        DocNo := "G/L Entry"."Document No.";


                if (TransactionNo <> "Transaction No.") and (("Debit Amount" <> 0) or ("Credit Amount" <> 0)) and (show) then
                    nrcrt := nrcrt + 1;

                if (TransactionNo <> "Transaction No.") and ((DebitAmounts[1] <> 0) or (CreditAmounts[1] <> 0)) and (show1) then
                    nrcrt := nrcrt + 1;

                if show1 then begin
                    DebitMovements := DebitMovements + DebitAmounts[1];
                    CreditMovements := CreditMovements + CreditAmounts[1];
                end else

                    if show then begin
                        DebitMovements := DebitMovements + "G/L Entry"."Debit Amount";
                        CreditMovements := CreditMovements + "G/L Entry"."Credit Amount";
                    end;

                TransactionNo := "Transaction No.";
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
        GLFilter := "G/L Entry".GetFilters;

        CompInfo.Get;
        CompName := CompInfo.Name;
        CUI := CompInfo."VAT Registration No.";
        ComTradeNo := CompInfo."SSA Commerce Trade No.";
    end;

    var
        nrcrt: Integer;
        DocNo: Text;
        Title: Label 'Auxiliary Journals';
        CompNameCaption: Label 'Company:';
        CUICaption: Label 'C.U.I.';
        ComTrNoCaption: Label 'Commerce Trade No.';
        PageCaption: Label 'Page';
        NrCaption: Label 'No.';
        DateCaption: Label 'Date';
        TypeCaption: Label 'Type';
        NumarCaption: Label 'No.';
        DocCaption: Label 'Document';
        DescrCaption: Label 'Posting Description';
        DebitCaption: Label 'Debit';
        CreditCaption: Label 'Credit';
        NreCaption: Label 'Account nos.';
        SumeCaption: Label 'Amounts';
        IntrareCaption: Label 'Entry No.';
        TotalCaption: Label 'Total';
        DebitMovements: Decimal;
        CreditMovements: Decimal;
        DebitGLEntry: Record "G/L Entry";
        CreditGLEntry: Record "G/L Entry";
        Count1: Integer;
        Count2: Integer;
        BalAccount: Code[20];
        show: Boolean;
        BalAcc: Code[20];
        Account: Code[20];
        DebitMovements1: Decimal;
        DebitMovements2: Decimal;
        CreditMovements1: Decimal;
        CreditMovements2: Decimal;
        DebitAccounts: array[10000] of Code[20];
        CreditAccounts: array[10000] of Code[20];
        DebitAmounts: array[10000] of Decimal;
        CreditAmounts: array[10000] of Decimal;
        indexdebit: Integer;
        indexcredit: Integer;
        show1: Boolean;
        INDEX: Integer;
        total: Boolean;
        GLFilter: Text[250];
        CompInfo: Record "Company Information";
        CompName: Text;
        CUI: Text;
        ComTradeNo: Text;
        DebitAccounts2: Code[20];
        CreditAccounts2: Code[20];
        DebitAmounts2: Decimal;
        CreditAmounts2: Decimal;
        PostingDate: Text;
        show3: Boolean;
        n: Integer;
        BalAccount2: Code[20];
        Account2: Code[20];
}

