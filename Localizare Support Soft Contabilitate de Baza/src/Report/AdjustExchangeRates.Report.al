report 70002 "SSA Adjust Exchange Rates"
{
    // SSA960 SSCAT 17.06.2019 26.Funct. reevaluare solduri valutare
    DefaultLayout = RDLC;
    RDLCLayout = './src/rdlc/SSAAdjustExchangeRates.rdlc';

    ApplicationArea = All;
    Caption = 'Adjust Exchange Rates';
    Permissions = TableData "Cust. Ledger Entry" = rimd,
                  TableData "Vendor Ledger Entry" = rimd,
                  TableData "Exch. Rate Adjmt. Reg." = rimd,
                  TableData "VAT Entry" = rimd,
                  TableData "Detailed Cust. Ledg. Entry" = rimd,
                  TableData "Detailed Vendor Ledg. Entry" = rimd;
    UsageCategory = Tasks;

    dataset
    {
        dataitem(Currency; Currency)
        {
            DataItemTableView = SORTING(Code);
            RequestFilterFields = "Code";
            column(COMPANYNAME; CompanyName)
            {
            }
            column(ReportTitle_lbl; ReportTitle_lbl)
            {
            }
            column(PageCaption_lbl; PageCaption_lbl)
            {
            }
            column(TestMode_lbl; TestMode_lbl)
            {
            }
            column(TestMode; TestMode)
            {
            }
            column(AdjBank; AdjBank)
            {
            }
            column(AdjCust; AdjCust)
            {
            }
            column(AdjVend; AdjVend)
            {
            }
            column(CurrencyFactor_Lbl; CurrencyFactor_Lbl)
            {
            }
            column(AdjBalanceAtDateLCY_lbl; AdjBalanceAtDateLCY_lbl)
            {
            }
            column(AdjustedFactorCaption; AdjustedFactorCaptionLbl)
            {
            }
            column(AdjDebitCaption; AdjDebit_CaptionLbl)
            {
            }
            column(AdjCreditCaption; AdjCredit_CaptionLbl)
            {
            }
            column(GainOrLossCaption; GainOrLoss_CaptionLbl)
            {
            }
            column(TotalCrAmtCaption; TotalCrAmt_CaptionLbl)
            {
            }
            column(Document_Type_Caption; Document_Type_CaptionLbl)
            {
            }
            column(Document_No_Caption; Document_No_CaptionLbl)
            {
            }
            column(Posting_Date_Caption; Posting_Date_CaptionLbl)
            {
            }
            column(Currency_Code_Caption; Currency_Code_CaptionLbl)
            {
            }
            column(Original_Currency_Factor_Caption; Original_Currency_Factor_CaptionLbl)
            {
            }
            column(Remaining_Amount_Caption; Remaining_Amount_CaptionLbl)
            {
            }
            column(Remaining_Amt_LCY_Caption; Remaining_Amt_LCY_CaptionLbl)
            {
            }
            column(Remaining_Amt_LCY___AdjAmountCaption; Remaining_Amt_LCY___AdjAmountCaptionLbl)
            {
            }
            column(Currency_Code; Code)
            {
            }
            column(TotalDtAmt; TotalDtAmtCum)
            {
            }
            column(TotalCrAmt; -TotalCrAmtCum)
            {
            }
            dataitem("Bank Account"; "Bank Account")
            {
                DataItemLink = "Currency Code" = FIELD(Code);
                DataItemTableView = SORTING("Bank Acc. Posting Group");
                RequestFilterFields = "No.";
                column(Bank_Account_TABLECAPTION; "Bank Account".TableCaption)
                {
                }
                column(Bank_Account_No_Caption; "Bank Account".FieldCaption("No."))
                {
                }
                column(Bank_Account_Name_Caption; "Bank Account".FieldCaption(Name))
                {
                }
                column(Bank_Account_Currency_Code_Caption; "Bank Account".FieldCaption("Currency Code"))
                {
                }
                column(Bank_Account_Balance_at_Date_Caption; "Bank Account".FieldCaption("Balance at Date"))
                {
                }
                column(Bank_Account_Balance_at_Date_LCY_Caption; "Bank Account".FieldCaption("Balance at Date (LCY)"))
                {
                }
                column(Bank_Account_No; "No.")
                {
                }
                column(Bank_Account_Name; Name)
                {
                }
                column(Bank_Account_Bank_Acc_Posting_Group; "Bank Acc. Posting Group")
                {
                }
                column(Bank_Account_Currency_Code; "Currency Code")
                {
                }
                column(Bank_Account_Balance_at_Date; "Balance at Date")
                {
                }
                column(Bank_Account_Balance_at_Date_LCY; "Balance at Date (LCY)")
                {
                }
                column(Bank_Account_Currency_Factor; Round(1 / Currency."Currency Factor", 0.0001))
                {
                }
                column(AdjAmount_Balance_at_Date_LCY; AdjAmount + "Balance at Date (LCY)")
                {
                }
                column(AdjDebit; AdjDebitCum)
                {
                }
                column(AdjCredit; -AdjCreditCum)
                {
                }
                column(AdjAmount; AdjAmount)
                {
                }
                column(GainOrLoss; GainOrLossCum)
                {
                }
                dataitem(BankAccountGroupTotal; "Integer")
                {
                    DataItemTableView = SORTING(Number);
                    MaxIteration = 1;

                    trigger OnAfterGetRecord()
                    var
                        BankAccount: Record "Bank Account";
                        GroupTotal: Boolean;
                    begin
                        BankAccount.Copy("Bank Account");
                        if BankAccount.Next = 1 then begin
                            if BankAccount."Bank Acc. Posting Group" <> "Bank Account"."Bank Acc. Posting Group" then
                                GroupTotal := true;
                        end else
                            GroupTotal := true;

                        if GroupTotal then
                            if TotalAdjAmount <> 0 then begin
                                //SSA960>>
                                /* //OC
                                AdjExchRateBufferUpdate(
                                  "Bank Account"."Currency Code","Bank Account"."Bank Acc. Posting Group",
                                  TotalAdjBase,TotalAdjBaseLCY,TotalAdjAmount,0,0,0,PostingDate,'');
                                InsertExchRateAdjmtReg(3,"Bank Account"."Bank Acc. Posting Group","Bank Account"."Currency Code");
                                */
                                AdjExchRateBufferUpdate(
                                  "Bank Account"."Currency Code", "Bank Account"."Bank Acc. Posting Group",
                                  TotalAdjBase, TotalAdjBaseLCY, TotalAdjAmount, 0, 0, 0, PostingDate, '', 0, 3, "Bank Account"."No.");

                                InsertExchRateAdjmtReg(3, "Bank Account"."Bank Acc. Posting Group", "Bank Account"."Currency Code", 3, "Bank Account"."No.");
                                //SSA960<<

                                TotalBankAccountsAdjusted += 1;
                                AdjExchRateBuffer.Reset;
                                AdjExchRateBuffer.DeleteAll;
                                TotalAdjBase := 0;
                                TotalAdjBaseLCY := 0;
                                TotalAdjAmount := 0;
                            end;

                    end;
                }

                trigger OnAfterGetRecord()
                begin
                    TempEntryNoAmountBuf.DeleteAll;
                    //SSA960>>
                    AdjDebitCum := 0;
                    AdjCreditCum := 0;
                    //SSA960<<

                    BankAccNo := BankAccNo + 1;
                    Window.Update(1, Round(BankAccNo / BankAccNoTotal * 10000, 1));

                    TempDimSetEntry.Reset;
                    TempDimSetEntry.DeleteAll;
                    TempDimBuf.Reset;
                    TempDimBuf.DeleteAll;

                    CalcFields("Balance at Date", "Balance at Date (LCY)");
                    AdjBase := "Balance at Date";
                    AdjBaseLCY := "Balance at Date (LCY)";
                    AdjAmount :=
                      Round(
                        CurrExchRate.ExchangeAmtFCYToLCYAdjmt(
                          PostingDate, Currency.Code, "Balance at Date", Currency."Currency Factor")) -
                      "Balance at Date (LCY)";

                    if AdjAmount <> 0 then begin
                        GenJnlLine.Validate("Posting Date", PostingDate);
                        GenJnlLine."Document No." := PostingDocNo;
                        GenJnlLine."Account Type" := GenJnlLine."Account Type"::"Bank Account";
                        GenJnlLine.Validate("Account No.", "No.");
                        //SSA960>>
                        //OC GenJnlLine.Description := PADSTR(STRSUBSTNO(PostingDescription,Currency.Code,AdjBase),MAXSTRLEN(GenJnlLine.Description));
                        GenJnlLine.Description := PadStr(StrSubstNo(PostingDescription, Currency.Code, AdjBase, '', ''), MaxStrLen(GenJnlLine.Description));
                        //SSA960<<
                        GenJnlLine.Validate(Amount, 0);
                        GenJnlLine."Amount (LCY)" := AdjAmount;
                        GenJnlLine."Source Currency Code" := Currency.Code;
                        if Currency.Code = GLSetup."Additional Reporting Currency" then
                            GenJnlLine."Source Currency Amount" := 0;
                        GenJnlLine."Source Code" := SourceCodeSetup."Exchange Rate Adjmt.";
                        GenJnlLine."System-Created Entry" := true;
                        if not TestMode then begin//SSA960
                            GetJnlLineDefDim(GenJnlLine, TempDimSetEntry);
                            CopyDimSetEntryToDimBuf(TempDimSetEntry, TempDimBuf);
                            PostGenJnlLine(GenJnlLine, TempDimSetEntry);
                            with TempEntryNoAmountBuf do begin
                                Init;
                                "Business Unit Code" := '';
                                "Entry No." := "Entry No." + 1;
                                Amount := AdjAmount;
                                Amount2 := AdjBase;
                                Insert;
                            end;
                            TempDimBuf2.Init;
                            TempDimBuf2."Table ID" := TempEntryNoAmountBuf."Entry No.";
                            TempDimBuf2."Entry No." := GetDimCombID(TempDimBuf);
                            TempDimBuf2.Insert;
                        end; //SSA960
                             //SSA960>>
                        if AdjAmount > 0 then begin
                            GainOrLossCum := Text45013658;
                            GainsOrLossAccNo := Currency."Unrealized Losses Acc.";
                        end else begin
                            GainOrLossCum := Text45013657;
                            GainsOrLossAccNo := Currency."Unrealized Gains Acc.";
                        end;
                        SetAdjDebitCredit(AdjAmount, AdjCreditCum, AdjDebitCum);

                        if AdjCreditCum <> 0 then begin
                            GainsOrLossAccNo := Currency."Unrealized Losses Acc.";
                            GainOrLossCum := Text45013658;
                        end else
                            if AdjDebitCum <> 0 then begin
                                GainsOrLossAccNo := Currency."Unrealized Gains Acc.";
                                GainOrLossCum := Text45013657;
                            end;
                        //SSA960<<
                        TotalAdjBase := TotalAdjBase + AdjBase;
                        TotalAdjBaseLCY := TotalAdjBaseLCY + AdjBaseLCY;
                        TotalAdjAmount := TotalAdjAmount + AdjAmount;
                        Window.Update(4, TotalAdjAmount);

                        if TempEntryNoAmountBuf.Amount <> 0 then begin
                            TempDimSetEntry.Reset;
                            TempDimSetEntry.DeleteAll;
                            TempDimBuf.Reset;
                            TempDimBuf.DeleteAll;
                            TempDimBuf2.SetRange("Table ID", TempEntryNoAmountBuf."Entry No.");
                            if TempDimBuf2.FindFirst then
                                DimBufMgt.GetDimensions(TempDimBuf2."Entry No.", TempDimBuf);
                            DimMgt.CopyDimBufToDimSetEntry(TempDimBuf, TempDimSetEntry);
                            //SSA960>>
                            /* //OC
                            IF TempEntryNoAmountBuf.Amount > 0 THEN
                              PostAdjmt(
                                Currency.GetRealizedGainsAccount,-TempEntryNoAmountBuf.Amount,TempEntryNoAmountBuf.Amount2,
                                "Currency Code",TempDimSetEntry,PostingDate,'')
                            ELSE
                              PostAdjmt(
                                Currency.GetRealizedLossesAccount,-TempEntryNoAmountBuf.Amount,TempEntryNoAmountBuf.Amount2,
                                "Currency Code",TempDimSetEntry,PostingDate,'');
                            */
                            PostAdjmt(
                              GainsOrLossAccNo, -TempEntryNoAmountBuf.Amount, TempEntryNoAmountBuf.Amount2,
                              "Currency Code", TempDimSetEntry, PostingDate, '', 3, "Bank Account"."No.")
                            //SSA960<<
                        end;
                    end;
                    TempDimBuf2.DeleteAll;

                end;

                trigger OnPreDataItem()
                begin
                    //SSA960>>
                    if not AdjBank then
                        CurrReport.Break;
                    //SSA960<<

                    SetRange("Date Filter", StartDate, EndDate);
                    TempDimBuf2.DeleteAll;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                "Last Date Adjusted" := PostingDate;
                if not TestMode then //SSA960
                    Modify;

                "Currency Factor" :=
                  CurrExchRate.ExchangeRateAdjmt(PostingDate, Code);

                Currency2 := Currency;
                Currency2.Insert;
            end;

            trigger OnPostDataItem()
            begin
                //SSA960>>
                //IF (Code = '') AND AdjCustVendBank THEN
                if (Code = '') and AdjBank then
                    //SSA960<<
                    Error(Text011);
            end;

            trigger OnPreDataItem()
            begin
                CheckPostingDate;

                //SSA960>>
                /*
                
                  CurrReport.BREAK;
                */
                //SSA960<<

                Window.Open(
                  Text006 +
                  Text007 +
                  Text008 +
                  Text009 +
                  Text010);

                CustNoTotal := Customer.Count;
                VendNoTotal := Vendor.Count;
                CopyFilter(Code, "Bank Account"."Currency Code");
                FilterGroup(2);
                "Bank Account".SetFilter("Currency Code", '<>%1', '');
                FilterGroup(0);
                BankAccNoTotal := "Bank Account".Count;
                "Bank Account".Reset;

                //SSA960>>
                TotalDtAmtCum := 0;
                TotalCrAmtCum := 0;
                //SSA960<<

            end;
        }
        dataitem(Customer; Customer)
        {
            DataItemTableView = SORTING("No.");
            RequestFilterFields = "No.", "Customer Posting Group";
            column(CustLedgerEntry_TABLECAPTION; CustLedgerEntry.TableCaption)
            {
            }
            column(Customer_TotalDtAmt; TotalDtAmtCum)
            {
            }
            column(Customer_TotalCrAmt; -TotalCrAmtCum)
            {
            }
            column(Customer_No; "No.")
            {
            }
            column(Customer_Name; Name)
            {
            }
            dataitem(CustomerLedgerEntryLoop; "Integer")
            {
                DataItemTableView = SORTING(Number);
                column(CustLedgerEntry_Currency_Code; CustLedgerEntry."Currency Code")
                {
                }
                column(CustLedgerEntry_Original_Currency_Factor; Round(CustLedgerEntry."Remaining Amt. (LCY)" / CustLedgerEntry."Remaining Amount", 0.0001))
                {
                }
                column(CustLedgerEntry_AdjustedFactor; AdjustedFactor)
                {
                }
                column(CustLedgerEntry_AdjDebitCum; AdjDebitCum)
                {
                }
                column(CustLedgerEntry_AdjCreditCum; -AdjCreditCum)
                {
                }
                column(CustLedgerEntry_GainOrLossCum; GainOrLossCum)
                {
                }
                column(CustLedgerEntry_Document_Type; Format(CustLedgerEntry."Document Type"))
                {
                }
                column(CustLedgerEntry_Document_No; CustLedgerEntry."Document No.")
                {
                }
                column(CustLedgerEntry_Posting_Date; CustLedgerEntry."Posting Date")
                {
                }
                column(CustLedgerEntry_Remaining_Amount; CustLedgerEntry."Remaining Amount")
                {
                }
                column(CustLedgerEntry_Remaining_Amt_LCY; CustLedgerEntry."Remaining Amt. (LCY)")
                {
                }
                column(CustLedgerEntry_Remaining_Amt_LCY___AdjAmountCum; CustLedgerEntry."Remaining Amt. (LCY)" - AdjDebitCum - AdjCreditCum)
                {
                }
                column(CustomerLedgerEntryLoop_Number; Number)
                {
                }
                column(CustLedgerEntry_AdjAmount; AdjAmount)
                {
                }
                column(CustTotalGainsAmount; AdjExchRateBuffer.TotalGainsAmount)
                {
                }
                column(CustTotalLossesAmount; AdjExchRateBuffer.TotalLossesAmount)
                {
                }
                dataitem("Detailed Cust. Ledg. Entry"; "Detailed Cust. Ledg. Entry")
                {
                    DataItemTableView = SORTING("Cust. Ledger Entry No.", "Posting Date");

                    trigger OnAfterGetRecord()
                    begin
                        AdjustCustomerLedgerEntry(CustLedgerEntry, "Posting Date");
                    end;

                    trigger OnPreDataItem()
                    begin
                        SetCurrentKey("Cust. Ledger Entry No.");
                        SetRange("Cust. Ledger Entry No.", CustLedgerEntry."Entry No.");
                        SetFilter("Posting Date", '%1..', CalcDate('<+1D>', PostingDate));
                        //SSA960>>
                        if CustPostGrFilter <> '' then
                            SetFilter("SSA Customer Posting Group", CustPostGrFilter);
                        //SSA960<<
                    end;
                }

                trigger OnAfterGetRecord()
                begin
                    TempDtldCustLedgEntrySums.DeleteAll;

                    //SSA960>>
                    InitAdjDebitCredit;
                    //SSA960<<

                    if FirstEntry then begin
                        TempCustLedgerEntry.Find('-');
                        FirstEntry := false
                    end else
                        if TempCustLedgerEntry.Next = 0 then
                            CurrReport.Break;
                    CustLedgerEntry.Get(TempCustLedgerEntry."Entry No.");
                    CustLedgerEntry.SetFilter("Date Filter", '..%1', EndDateReq);
                    CustLedgerEntry.CalcFields("Remaining Amount", "Remaining Amt. (LCY)");
                    CustLedgerEntry.SetRange("Date Filter");
                    //SSA960>>
                    if CustPostGrFilter <> '' then
                        CustLedgerEntry.SetFilter("Customer Posting Group", CustPostGrFilter);
                    //SSA960<<
                    AdjustCustomerLedgerEntry(CustLedgerEntry, PostingDate);

                    UpdateAdjDebitCredit; //SSA960
                end;

                trigger OnPreDataItem()
                begin
                    if not TempCustLedgerEntry.Find('-') then
                        CurrReport.Break;
                    FirstEntry := true;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                CustNo := CustNo + 1;
                Window.Update(2, Round(CustNo / CustNoTotal * 10000, 1));

                TempCustLedgerEntry.DeleteAll;

                Currency.CopyFilter(Code, CustLedgerEntry."Currency Code");
                CustLedgerEntry.FilterGroup(2);
                CustLedgerEntry.SetFilter("Currency Code", '<>%1', '');
                CustLedgerEntry.FilterGroup(0);

                DtldCustLedgEntry.Reset;
                DtldCustLedgEntry.SetCurrentKey("Customer No.", "Posting Date", "Entry Type");
                DtldCustLedgEntry.SetRange("Customer No.", "No.");
                DtldCustLedgEntry.SetRange("Posting Date", CalcDate('<+1D>', EndDate), DMY2Date(31, 12, 9999));
                //SSA960>>
                if CustPostGrFilter <> '=' then
                    DtldCustLedgEntry.SetFilter("SSA Customer Posting Group", CustPostGrFilter);
                //SSA960<<
                if DtldCustLedgEntry.Find('-') then
                    repeat
                        CustLedgerEntry."Entry No." := DtldCustLedgEntry."Cust. Ledger Entry No.";
                        if CustLedgerEntry.Find('=') then
                            if (CustLedgerEntry."Posting Date" >= StartDate) and
                               (CustLedgerEntry."Posting Date" <= EndDate)
                            then begin
                                TempCustLedgerEntry."Entry No." := CustLedgerEntry."Entry No.";
                                if TempCustLedgerEntry.Insert then;
                            end;
                    until DtldCustLedgEntry.Next = 0;

                CustLedgerEntry.SetCurrentKey("Customer No.", Open);
                CustLedgerEntry.SetRange("Customer No.", "No.");
                CustLedgerEntry.SetRange(Open, true);
                CustLedgerEntry.SetRange("Posting Date", 0D, EndDate);
                //SSA960>>
                if CustPostGrFilter <> '' then
                    CustLedgerEntry.SetFilter("Customer Posting Group", CustPostGrFilter);
                //SSA960<<
                if CustLedgerEntry.Find('-') then
                    repeat
                        TempCustLedgerEntry."Entry No." := CustLedgerEntry."Entry No.";
                        if TempCustLedgerEntry.Insert then;
                    until CustLedgerEntry.Next = 0;
                CustLedgerEntry.Reset;
            end;

            trigger OnPostDataItem()
            begin
                //SSA960>>
                //OC IF CustNo <> 0 THEN
                if (CustNo <> 0) and AdjCust and (not TestMode) then
                    //SSA960<<
                    HandlePostAdjmt(1); // Customer
            end;

            trigger OnPreDataItem()
            begin
                //SSA960>>
                /*//OC
                IF NOT AdjCustVendBank THEN
                  CurrReport.BREAK;
                */

                if not AdjCust then
                    CurrReport.Break;
                //SSA960<<

                DtldCustLedgEntry.LockTable;
                CustLedgerEntry.LockTable;

                CustNo := 0;

                if DtldCustLedgEntry.Find('+') then
                    NewEntryNo := DtldCustLedgEntry."Entry No." + 1
                else
                    NewEntryNo := 1;

                Clear(DimMgt);
                TempEntryNoAmountBuf.DeleteAll;

                SetRange("Customer Posting Group"); //SSA960

                //SSA960>>
                TotalDtAmtCum := 0;
                TotalCrAmtCum := 0;
                //SSA960<<

            end;
        }
        dataitem(Vendor; Vendor)
        {
            DataItemTableView = SORTING("No.");
            RequestFilterFields = "No.", "Vendor Posting Group";
            column(VendorLedgerEntry_TABLECAPTION; VendorLedgerEntry.TableCaption)
            {
            }
            column(Vendor_No; "No.")
            {
            }
            column(Vendor_Name; Name)
            {
            }
            dataitem(VendorLedgerEntryLoop; "Integer")
            {
                DataItemTableView = SORTING(Number);
                column(VendorLedgerEntry_Currency_Code; VendorLedgerEntry."Currency Code")
                {
                }
                column(VendorLedgerEntry_Original_Currency_Factor; Round(VendorLedgerEntry."Remaining Amt. (LCY)" / VendorLedgerEntry."Remaining Amount", 0.0001))
                {
                }
                column(VendorLedgerEntry_AdjustedFactor; AdjustedFactor)
                {
                }
                column(VendorLedgerEntry_AdjDebitCum; AdjDebitCum)
                {
                }
                column(VendorLedgerEntry_AdjCreditCum; -AdjCreditCum)
                {
                }
                column(VendorLedgerEntry_GainOrLossCum; GainOrLossCum)
                {
                }
                column(VendorLedgerEntry_Document_Type; Format(VendorLedgerEntry."Document Type"))
                {
                }
                column(VendorLedgerEntry_Document_No; VendorLedgerEntry."Document No.")
                {
                }
                column(VendorLedgerEntry_Posting_Date; VendorLedgerEntry."Posting Date")
                {
                }
                column(VendorLedgerEntry_Remaining_Amount; VendorLedgerEntry."Remaining Amount")
                {
                }
                column(VendorLedgerEntry_Remaining_Amt_LCY; VendorLedgerEntry."Remaining Amt. (LCY)")
                {
                }
                column(VendorLedgerEntry_Remaining_Amt_LCY___AdjAmountCum; VendorLedgerEntry."Remaining Amt. (LCY)" - AdjDebitCum - AdjCreditCum)
                {
                }
                column(VendorLedgerEntryLoop_Number; Number)
                {
                }
                column(VendorLedgerEntry_AdjAmount; AdjAmount)
                {
                }
                column(VendTotalGainsAmount; AdjExchRateBuffer.TotalGainsAmount)
                {
                }
                column(VendTotalLossesAmount; AdjExchRateBuffer.TotalLossesAmount)
                {
                }
                column(Vendor_TotalDtAmt; TotalDtAmtCum)
                {
                }
                column(Vendor_TotalCrAmt; -TotalCrAmtCum)
                {
                }
                dataitem("Detailed Vendor Ledg. Entry"; "Detailed Vendor Ledg. Entry")
                {
                    DataItemTableView = SORTING("Vendor Ledger Entry No.", "Posting Date");

                    trigger OnAfterGetRecord()
                    begin
                        AdjustVendorLedgerEntry(VendorLedgerEntry, "Posting Date");
                    end;

                    trigger OnPreDataItem()
                    begin
                        SetCurrentKey("Vendor Ledger Entry No.");
                        SetRange("Vendor Ledger Entry No.", VendorLedgerEntry."Entry No.");
                        SetFilter("Posting Date", '%1..', CalcDate('<+1D>', PostingDate));
                        //SSA960>>
                        if VendPostGrFilter <> '' then
                            SetFilter("SSA Vendor Posting Group", VendPostGrFilter);
                        //SSA960<<
                    end;
                }

                trigger OnAfterGetRecord()
                begin
                    TempDtldVendLedgEntrySums.DeleteAll;

                    //SSA960>>
                    InitAdjDebitCredit;
                    //SSA960<<

                    if FirstEntry then begin
                        TempVendorLedgerEntry.Find('-');
                        FirstEntry := false
                    end else
                        if TempVendorLedgerEntry.Next = 0 then
                            CurrReport.Break;
                    VendorLedgerEntry.Get(TempVendorLedgerEntry."Entry No.");
                    VendorLedgerEntry.SetFilter("Date Filter", '..%1', EndDateReq);
                    VendorLedgerEntry.CalcFields("Remaining Amount", "Remaining Amt. (LCY)");
                    VendorLedgerEntry.SetRange("Date Filter");
                    //SSA960>>
                    if VendPostGrFilter <> '' then
                        VendorLedgerEntry.SetFilter("Vendor Posting Group", VendPostGrFilter);
                    //SSA960<<
                    AdjustVendorLedgerEntry(VendorLedgerEntry, PostingDate);

                    UpdateAdjDebitCredit; //SSA960
                end;

                trigger OnPreDataItem()
                begin
                    if not TempVendorLedgerEntry.Find('-') then
                        CurrReport.Break;
                    FirstEntry := true;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                VendNo := VendNo + 1;
                Window.Update(3, Round(VendNo / VendNoTotal * 10000, 1));

                TempVendorLedgerEntry.DeleteAll;

                Currency.CopyFilter(Code, VendorLedgerEntry."Currency Code");
                VendorLedgerEntry.FilterGroup(2);
                VendorLedgerEntry.SetFilter("Currency Code", '<>%1', '');
                VendorLedgerEntry.FilterGroup(0);

                DtldVendLedgEntry.Reset;
                DtldVendLedgEntry.SetCurrentKey("Vendor No.", "Posting Date", "Entry Type");
                DtldVendLedgEntry.SetRange("Vendor No.", "No.");
                DtldVendLedgEntry.SetRange("Posting Date", CalcDate('<+1D>', EndDate), DMY2Date(31, 12, 9999));
                //SSA960>>
                if VendPostGrFilter <> '=' then
                    DtldVendLedgEntry.SetFilter("SSA Vendor Posting Group", VendPostGrFilter);
                //SSA960<<
                if DtldVendLedgEntry.Find('-') then
                    repeat
                        VendorLedgerEntry."Entry No." := DtldVendLedgEntry."Vendor Ledger Entry No.";
                        if VendorLedgerEntry.Find('=') then
                            if (VendorLedgerEntry."Posting Date" >= StartDate) and
                               (VendorLedgerEntry."Posting Date" <= EndDate)
                            then begin
                                TempVendorLedgerEntry."Entry No." := VendorLedgerEntry."Entry No.";
                                if TempVendorLedgerEntry.Insert then;
                            end;
                    until DtldVendLedgEntry.Next = 0;

                VendorLedgerEntry.SetCurrentKey("Vendor No.", Open);
                VendorLedgerEntry.SetRange("Vendor No.", "No.");
                VendorLedgerEntry.SetRange(Open, true);
                VendorLedgerEntry.SetRange("Posting Date", 0D, EndDate);
                //SSA960>>
                if VendPostGrFilter <> '' then
                    VendorLedgerEntry.SetFilter("Vendor Posting Group", VendPostGrFilter);
                //SSA960<<
                if VendorLedgerEntry.Find('-') then
                    repeat
                        TempVendorLedgerEntry."Entry No." := VendorLedgerEntry."Entry No.";
                        if TempVendorLedgerEntry.Insert then;
                    until VendorLedgerEntry.Next = 0;
                VendorLedgerEntry.Reset;
            end;

            trigger OnPostDataItem()
            begin
                //SSA960>>
                //IF VendNo <> 0 THEN
                if (VendNo <> 0) and AdjVend and (not TestMode) then
                    //SSA960<<
                    HandlePostAdjmt(2); // Vendor
            end;

            trigger OnPreDataItem()
            begin
                //SSA960>>
                /*//OC
                IF NOT AdjCustVendBank THEN
                  CurrReport.BREAK;
                */

                if not AdjVend then
                    CurrReport.Break;
                //SSA960<<

                DtldVendLedgEntry.LockTable;
                VendorLedgerEntry.LockTable;

                VendNo := 0;
                if DtldVendLedgEntry.Find('+') then
                    NewEntryNo := DtldVendLedgEntry."Entry No." + 1
                else
                    NewEntryNo := 1;

                Clear(DimMgt);
                TempEntryNoAmountBuf.DeleteAll;

                SetRange("Vendor Posting Group"); //SSA960
                //SSA960>>
                TotalDtAmtCum := 0;
                TotalCrAmtCum := 0;
                //SSA960<<

            end;
        }
        dataitem("VAT Posting Setup"; "VAT Posting Setup")
        {
            DataItemTableView = SORTING("VAT Bus. Posting Group", "VAT Prod. Posting Group");

            trigger OnAfterGetRecord()
            begin
                VATEntryNo := VATEntryNo + 1;
                Window.Update(1, Round(VATEntryNo / VATEntryNoTotal * 10000, 1));

                VATEntry.SetRange("VAT Bus. Posting Group", "VAT Bus. Posting Group");
                VATEntry.SetRange("VAT Prod. Posting Group", "VAT Prod. Posting Group");

                if "VAT Calculation Type" <> "VAT Calculation Type"::"Sales Tax" then begin
                    AdjustVATEntries(VATEntry.Type::Purchase, false);
                    if (VATEntry2.Amount <> 0) or (VATEntry2."Additional-Currency Amount" <> 0) then begin
                        AdjustVATAccount(
                          GetPurchAccount(false),
                          VATEntry2.Amount, VATEntry2."Additional-Currency Amount",
                          VATEntryTotalBase.Amount, VATEntryTotalBase."Additional-Currency Amount");
                        if "VAT Calculation Type" = "VAT Calculation Type"::"Reverse Charge VAT" then
                            AdjustVATAccount(
                              GetRevChargeAccount(false),
                              -VATEntry2.Amount, -VATEntry2."Additional-Currency Amount",
                              -VATEntryTotalBase.Amount, -VATEntryTotalBase."Additional-Currency Amount");
                    end;
                    if (VATEntry2."Remaining Unrealized Amount" <> 0) or
                       (VATEntry2."Add.-Curr. Rem. Unreal. Amount" <> 0)
                    then begin
                        TestField("Unrealized VAT Type");
                        AdjustVATAccount(
                          GetPurchAccount(true),
                          VATEntry2."Remaining Unrealized Amount",
                          VATEntry2."Add.-Curr. Rem. Unreal. Amount",
                          VATEntryTotalBase."Remaining Unrealized Amount",
                          VATEntryTotalBase."Add.-Curr. Rem. Unreal. Amount");
                        if "VAT Calculation Type" = "VAT Calculation Type"::"Reverse Charge VAT" then
                            AdjustVATAccount(
                              GetRevChargeAccount(true),
                              -VATEntry2."Remaining Unrealized Amount",
                              -VATEntry2."Add.-Curr. Rem. Unreal. Amount",
                              -VATEntryTotalBase."Remaining Unrealized Amount",
                              -VATEntryTotalBase."Add.-Curr. Rem. Unreal. Amount");
                    end;

                    AdjustVATEntries(VATEntry.Type::Sale, false);
                    if (VATEntry2.Amount <> 0) or (VATEntry2."Additional-Currency Amount" <> 0) then
                        AdjustVATAccount(
                          GetSalesAccount(false),
                          VATEntry2.Amount, VATEntry2."Additional-Currency Amount",
                          VATEntryTotalBase.Amount, VATEntryTotalBase."Additional-Currency Amount");
                    if (VATEntry2."Remaining Unrealized Amount" <> 0) or
                       (VATEntry2."Add.-Curr. Rem. Unreal. Amount" <> 0)
                    then begin
                        TestField("Unrealized VAT Type");
                        AdjustVATAccount(
                          GetSalesAccount(true),
                          VATEntry2."Remaining Unrealized Amount",
                          VATEntry2."Add.-Curr. Rem. Unreal. Amount",
                          VATEntryTotalBase."Remaining Unrealized Amount",
                          VATEntryTotalBase."Add.-Curr. Rem. Unreal. Amount");
                    end;
                end else begin
                    if TaxJurisdiction.Find('-') then
                        repeat
                            VATEntry.SetRange("Tax Jurisdiction Code", TaxJurisdiction.Code);
                            AdjustVATEntries(VATEntry.Type::Purchase, false);
                            AdjustPurchTax(false);
                            AdjustVATEntries(VATEntry.Type::Purchase, true);
                            AdjustPurchTax(true);
                            AdjustVATEntries(VATEntry.Type::Sale, false);
                            AdjustSalesTax;
                        until TaxJurisdiction.Next = 0;
                    VATEntry.SetRange("Tax Jurisdiction Code");
                end;
                Clear(VATEntryTotalBase);
            end;

            trigger OnPreDataItem()
            begin
                if not AdjGLAcc or
                   (GLSetup."VAT Exchange Rate Adjustment" = GLSetup."VAT Exchange Rate Adjustment"::"No Adjustment")
                then
                    CurrReport.Break;

                Window.Open(
                  Text012 +
                  Text013);

                VATEntryNoTotal := VATEntry.Count;
                if not
                   VATEntry.SetCurrentKey(
                     Type, Closed, "VAT Bus. Posting Group", "VAT Prod. Posting Group", "Posting Date")
                then
                    VATEntry.SetCurrentKey(
                      Type, Closed, "Tax Jurisdiction Code", "Use Tax", "Posting Date");
                VATEntry.SetRange(Closed, false);
                VATEntry.SetRange("Posting Date", StartDate, EndDate);
            end;
        }
        dataitem("G/L Account"; "G/L Account")
        {
            DataItemTableView = SORTING("No.") WHERE("Exchange Rate Adjustment" = FILTER("Adjust Amount" .. "Adjust Additional-Currency Amount"));

            trigger OnAfterGetRecord()
            begin
                GLAccNo := GLAccNo + 1;
                Window.Update(1, Round(GLAccNo / GLAccNoTotal * 10000, 1));
                if "Exchange Rate Adjustment" = "Exchange Rate Adjustment"::"No Adjustment" then
                    CurrReport.Skip;

                TempDimSetEntry.Reset;
                TempDimSetEntry.DeleteAll;
                CalcFields("Net Change", "Additional-Currency Net Change");
                case "Exchange Rate Adjustment" of
                    "Exchange Rate Adjustment"::"Adjust Amount":
                        PostGLAccAdjmt(
                          "No.", "Exchange Rate Adjustment"::"Adjust Amount",
                          Round(
                            CurrExchRate2.ExchangeAmtFCYToLCYAdjmt(
                              PostingDate, GLSetup."Additional Reporting Currency",
                              "Additional-Currency Net Change", AddCurrCurrencyFactor) -
                            "Net Change"),
                          "Net Change",
                          "Additional-Currency Net Change");
                    "Exchange Rate Adjustment"::"Adjust Additional-Currency Amount":
                        PostGLAccAdjmt(
                          "No.", "Exchange Rate Adjustment"::"Adjust Additional-Currency Amount",
                          Round(
                            CurrExchRate2.ExchangeAmtLCYToFCY(
                              PostingDate, GLSetup."Additional Reporting Currency",
                              "Net Change", AddCurrCurrencyFactor) -
                            "Additional-Currency Net Change",
                            Currency3."Amount Rounding Precision"),
                          "Net Change",
                          "Additional-Currency Net Change");
                end;
            end;

            trigger OnPostDataItem()
            begin
                if AdjGLAcc then begin
                    GenJnlLine."Document No." := PostingDocNo;
                    GenJnlLine."Account Type" := GenJnlLine."Account Type"::"G/L Account";
                    GenJnlLine."Posting Date" := PostingDate;
                    GenJnlLine."Source Code" := SourceCodeSetup."Exchange Rate Adjmt.";

                    if GLAmtTotal <> 0 then begin
                        if GLAmtTotal < 0 then
                            GenJnlLine."Account No." := Currency3.GetRealizedGLLossesAccount
                        else
                            GenJnlLine."Account No." := Currency3.GetRealizedGLGainsAccount;
                        //SSA960>>
                        /*



                            GLSetup."Additional Reporting Currency",
                            GLAddCurrNetChangeTotal);
                        */
                        GenJnlLine.Description :=
                          StrSubstNo(
                            PostingDescription,
                            GLSetup."Additional Reporting Currency",
                            GLAddCurrNetChangeTotal, '', '');
                        //SSA960<<
                        GenJnlLine."Additional-Currency Posting" := GenJnlLine."Additional-Currency Posting"::"Amount Only";
                        GenJnlLine."Currency Code" := '';
                        GenJnlLine.Amount := -GLAmtTotal;
                        GenJnlLine."Amount (LCY)" := -GLAmtTotal;
                        if not TestMode then begin //SSA960
                            GetJnlLineDefDim(GenJnlLine, TempDimSetEntry);
                            PostGenJnlLine(GenJnlLine, TempDimSetEntry);
                        end; //SSA960
                    end;
                    if GLAddCurrAmtTotal <> 0 then begin
                        if GLAddCurrAmtTotal < 0 then
                            GenJnlLine."Account No." := Currency3.GetRealizedGLLossesAccount
                        else
                            GenJnlLine."Account No." := Currency3.GetRealizedGLGainsAccount;
                        //SSA960>>
                        /*//OC
                        GenJnlLine.Description :=
                          STRSUBSTNO(
                            PostingDescription,'',
                            GLNetChangeTotal);
                        */
                        GenJnlLine.Description :=
                          StrSubstNo(
                            PostingDescription, '',
                            GLNetChangeTotal, '', '');
                        //SSA960<<
                        GenJnlLine."Additional-Currency Posting" := GenJnlLine."Additional-Currency Posting"::"Additional-Currency Amount Only";
                        GenJnlLine."Currency Code" := GLSetup."Additional Reporting Currency";
                        GenJnlLine.Amount := -GLAddCurrAmtTotal;
                        GenJnlLine."Amount (LCY)" := 0;
                        if not TestMode then begin //SSA960
                            GetJnlLineDefDim(GenJnlLine, TempDimSetEntry);
                            PostGenJnlLine(GenJnlLine, TempDimSetEntry);
                        end; //SSA960
                    end;

                    with ExchRateAdjReg do begin
                        "No." := "No." + 1;
                        "Creation Date" := PostingDate;
                        "Account Type" := "Account Type"::"G/L Account";
                        "Posting Group" := '';
                        "Currency Code" := GLSetup."Additional Reporting Currency";
                        "Currency Factor" := CurrExchRate2."Adjustment Exch. Rate Amount";
                        "Adjusted Base" := 0;
                        "Adjusted Base (LCY)" := GLNetChangeBase;
                        "Adjusted Amt. (LCY)" := GLAmtTotal;
                        "Adjusted Base (Add.-Curr.)" := GLAddCurrNetChangeBase;
                        "Adjusted Amt. (Add.-Curr.)" := GLAddCurrAmtTotal;
                        if not TestMode then //SSA960
                            Insert;
                    end;

                    TotalGLAccountsAdjusted += 1;
                end;

            end;

            trigger OnPreDataItem()
            begin
                if not AdjGLAcc then
                    CurrReport.Break;

                Window.Open(
                  Text014 +
                  Text015);

                GLAccNoTotal := Count;
                SetRange("Date Filter", StartDate, EndDate);
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
                group(Options)
                {
                    Caption = 'Options';
                    group("Adjustment Period")
                    {
                        Caption = 'Adjustment Period';
                        field(StartingDate; StartDate)
                        {
                            ApplicationArea = All;
                            Caption = 'Starting Date';
                            ToolTip = 'Specifies the beginning of the period for which entries are adjusted. This field is usually left blank, but you can enter a date.';
                        }
                        field(EndingDate; EndDateReq)
                        {
                            ApplicationArea = All;
                            Caption = 'Ending Date';
                            ToolTip = 'Specifies the last date for which entries are adjusted. This date is usually the same as the posting date in the Posting Date field.';

                            trigger OnValidate()
                            begin
                                PostingDate := EndDateReq;
                            end;
                        }
                    }
                    field(PostingDescription; PostingDescription)
                    {
                        ApplicationArea = All;
                        Caption = 'Posting Description';
                        ToolTip = 'Specifies text for the general ledger entries that are created by the batch job. The default text is Exchange Rate Adjmt. of %1 %2, in which %1 is replaced by the currency code and %2 is replaced by the currency amount that is adjusted. For example, Exchange Rate Adjmt. of DEM 38,000.';
                    }
                    field(PostingDate; PostingDate)
                    {
                        ApplicationArea = All;
                        Caption = 'Posting Date';
                        ToolTip = 'Specifies the date on which the general ledger entries are posted. This date is usually the same as the ending date in the Ending Date field.';

                        trigger OnValidate()
                        begin
                            CheckPostingDate;
                        end;
                    }
                    field(DocumentNo; PostingDocNo)
                    {
                        ApplicationArea = All;
                        Caption = 'Document No.';
                        ToolTip = 'Specifies the document number that will appear on the general ledger entries that are created by the batch job.';
                    }
                    field(AdjCustVendBank; AdjCustVendBank)
                    {
                        ApplicationArea = All;
                        Caption = 'Adjust Customer, Vendor and Bank Accounts';
                        MultiLine = true;
                        ToolTip = 'Specifies if you want to adjust customer, vendor, and bank accounts for currency fluctuations.';
                        Visible = false;
                    }
                    field(AdjGLAcc; AdjGLAcc)
                    {
                        ApplicationArea = All;
                        Caption = 'Adjust G/L Accounts for Add.-Reporting Currency';
                        MultiLine = true;
                        ToolTip = 'Specifies if you want to post in an additional reporting currency and adjust general ledger accounts for currency fluctuations between LCY and the additional reporting currency.';
                    }
                    field(AdjBank; AdjBank)
                    {
                        ApplicationArea = All;
                        Caption = 'Adjust Bank Accounts';
                    }
                    field(AdjCust; AdjCust)
                    {
                        ApplicationArea = All;
                        Caption = 'Adjust Customer';
                    }
                    field(AdjVend; AdjVend)
                    {
                        ApplicationArea = All;
                        Caption = 'Adjust Vendor';
                    }
                    field(SummarizeEntries; SummarizeEntries)
                    {
                        ApplicationArea = All;
                        Caption = 'Summarize Entries';
                    }
                    field(TestMode; TestMode)
                    {
                        ApplicationArea = All;
                        Caption = 'Test Mode';
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnOpenPage()
        begin
            //
            /*//OC
            IF PostingDescription = '' THEN
              PostingDescription := Text016;
            IF NOT (AdjCustVendBank OR AdjGLAcc) THEN
              AdjCustVendBank := TRUE;
            */

            PostingDescription := Text45013656;

            if not (AdjCust or AdjVend or AdjBank or AdjGLAcc) then begin
                AdjCust := true;
                AdjVend := true;
                AdjBank := true;
            end;

            TestMode := true;
            //SSA960<<

        end;
    }

    labels
    {
    }

    trigger OnInitReport()
    var
        IsHandled: Boolean;
    begin
        IsHandled := false;
        OnBeforeOnInitReport(IsHandled);
        if IsHandled then
            exit;
    end;

    trigger OnPostReport()
    begin
        UpdateAnalysisView.UpdateAll(0, true);

        if TotalCustomersAdjusted + TotalVendorsAdjusted + TotalBankAccountsAdjusted + TotalGLAccountsAdjusted < 1 then
            Message(NothingToAdjustMsg)
        else
            Message(RatesAdjustedMsg);
    end;

    trigger OnPreReport()
    begin
        if EndDateReq = 0D then
            EndDate := DMY2Date(31, 12, 9999)
        else
            EndDate := EndDateReq;

        //SSA960>>
        AdjCustVendBank :=
          AdjCust or AdjVend or AdjBank;

        if not TestMode then
            if not Confirm(Text45013654, false) then
                Error(Text005);

        if (not TestMode) and (PostingDocNo = '-') then
            Error(Text000, GenJnlLine.FieldCaption("Document No."));


        if TestMode and SummarizeEntries then
            Error(Text45013655);
        //SSA960<<

        if PostingDocNo = '' then
            Error(Text000, GenJnlLine.FieldCaption("Document No."));
        if not AdjCustVendBank and AdjGLAcc then
            if not Confirm(Text001 + Text004, false) then
                Error(Text005);

        SourceCodeSetup.Get;

        if ExchRateAdjReg.FindLast then
            ExchRateAdjReg.Init;

        GLSetup.Get;

        if AdjGLAcc then begin
            GLSetup.TestField("Additional Reporting Currency");

            Currency3.Get(GLSetup."Additional Reporting Currency");
            "G/L Account".Get(Currency3.GetRealizedGLGainsAccount);
            "G/L Account".TestField("Exchange Rate Adjustment", "G/L Account"."Exchange Rate Adjustment"::"No Adjustment");

            "G/L Account".Get(Currency3.GetRealizedGLLossesAccount);
            "G/L Account".TestField("Exchange Rate Adjustment", "G/L Account"."Exchange Rate Adjustment"::"No Adjustment");

            with VATPostingSetup2 do
                if Find('-') then
                    repeat
                        if "VAT Calculation Type" <> "VAT Calculation Type"::"Sales Tax" then begin
                            CheckExchRateAdjustment(
                              "Purchase VAT Account", TableCaption, FieldCaption("Purchase VAT Account"));
                            CheckExchRateAdjustment(
                              "Reverse Chrg. VAT Acc.", TableCaption, FieldCaption("Reverse Chrg. VAT Acc."));
                            CheckExchRateAdjustment(
                              "Purch. VAT Unreal. Account", TableCaption, FieldCaption("Purch. VAT Unreal. Account"));
                            CheckExchRateAdjustment(
                              "Reverse Chrg. VAT Unreal. Acc.", TableCaption, FieldCaption("Reverse Chrg. VAT Unreal. Acc."));
                            CheckExchRateAdjustment(
                              "Sales VAT Account", TableCaption, FieldCaption("Sales VAT Account"));
                            CheckExchRateAdjustment(
                              "Sales VAT Unreal. Account", TableCaption, FieldCaption("Sales VAT Unreal. Account"));
                        end;
                    until Next = 0;

            with TaxJurisdiction2 do
                if Find('-') then
                    repeat
                        CheckExchRateAdjustment(
                          "Tax Account (Purchases)", TableCaption, FieldCaption("Tax Account (Purchases)"));
                        CheckExchRateAdjustment(
                          "Reverse Charge (Purchases)", TableCaption, FieldCaption("Reverse Charge (Purchases)"));
                        CheckExchRateAdjustment(
                          "Unreal. Tax Acc. (Purchases)", TableCaption, FieldCaption("Unreal. Tax Acc. (Purchases)"));
                        CheckExchRateAdjustment(
                          "Unreal. Rev. Charge (Purch.)", TableCaption, FieldCaption("Unreal. Rev. Charge (Purch.)"));
                        CheckExchRateAdjustment(
                          "Tax Account (Sales)", TableCaption, FieldCaption("Tax Account (Sales)"));
                        CheckExchRateAdjustment(
                          "Unreal. Tax Acc. (Sales)", TableCaption, FieldCaption("Unreal. Tax Acc. (Sales)"));
                    until Next = 0;

            AddCurrCurrencyFactor :=
              CurrExchRate2.ExchangeRateAdjmt(PostingDate, GLSetup."Additional Reporting Currency");
        end;

        //SSA960>>
        CustPostGrFilter := Customer.GetFilter("Customer Posting Group");
        VendPostGrFilter := Vendor.GetFilter("Vendor Posting Group");
        //SSA960<<
    end;

    local procedure PostAdjmt(GLAccNo: Code[20]; PostingAmount: Decimal; AdjBase2: Decimal; CurrencyCode2: Code[10]; var DimSetEntry: Record "Dimension Set Entry"; PostingDate2: Date; ICCode: Code[20]; _SourceType: Option " ",Customer,Vendor,"Bank Account","Fixed Asset"; _SourceNo: Code[20]) TransactionNo: Integer
    var
        DocNo: Code[20];
        DocType: Text[30];
    begin
        with GenJnlLine do
            if PostingAmount <> 0 then begin
                Init;
                Validate("Posting Date", PostingDate2);
                "Document No." := PostingDocNo;
                "Account Type" := "Account Type"::"G/L Account";
                Validate("Account No.", GLAccNo);

                //SSA960>>
                if SummarizeEntries then begin
                    DocNo := '';
                    DocType := '';
                end else begin
                    DocNo := CVLedgEntryBuffer."Document No.";
                    DocType := Format(CVLedgEntryBuffer."Document Type");
                end;
                //OC Description := PADSTR(STRSUBSTNO(PostingDescription,CurrencyCode2,AdjBase2),MAXSTRLEN(Description));
                Description := PadStr(StrSubstNo(PostingDescription, CurrencyCode2, AdjBase2, DocType, DocNo), MaxStrLen(Description));
                //SSA960<<


                Validate(Amount, PostingAmount);
                "Source Currency Code" := CurrencyCode2;
                "IC Partner Code" := ICCode;
                if CurrencyCode2 = GLSetup."Additional Reporting Currency" then
                    "Source Currency Amount" := 0;
                "Source Code" := SourceCodeSetup."Exchange Rate Adjmt.";
                "System-Created Entry" := true;

                //SSA960>>
                "Source Type" := _SourceType;
                "Source No." := _SourceNo;
                if not TestMode then
                    //SSA960<<
                    TransactionNo := PostGenJnlLine(GenJnlLine, DimSetEntry);
            end;
    end;

    local procedure InsertExchRateAdjmtReg(AdjustAccType: Integer; PostingGrCode: Code[20]; CurrencyCode: Code[10]; _SourceType: Option " ",Customer,Vendor,"Bank Account","Fixed Asset"; _SourceNo: Code[20])
    begin
        if Currency2.Code <> CurrencyCode then
            Currency2.Get(CurrencyCode);

        with ExchRateAdjReg do begin
            "No." := "No." + 1;
            "Creation Date" := PostingDate;
            "Account Type" := AdjustAccType;
            "Posting Group" := PostingGrCode;
            "Currency Code" := Currency2.Code;
            "Currency Factor" := Currency2."Currency Factor";
            "Adjusted Base" := AdjExchRateBuffer.AdjBase;
            "Adjusted Base (LCY)" := AdjExchRateBuffer.AdjBaseLCY;
            "Adjusted Amt. (LCY)" := AdjExchRateBuffer.AdjAmount;
            //SSA960>>
            "SSA Source Type" := _SourceType;
            "SSA Source No." := _SourceNo;
            if not TestMode then
                //SSA960<<
                Insert;
        end;
    end;

    procedure InitializeRequest(NewStartDate: Date; NewEndDate: Date; NewPostingDescription: Text[100]; NewPostingDate: Date)
    begin
        StartDate := NewStartDate;
        EndDate := NewEndDate;
        PostingDescription := NewPostingDescription;
        PostingDate := NewPostingDate;
        if EndDate = 0D then
            EndDateReq := DMY2Date(31, 12, 9999)
        else
            EndDateReq := EndDate;
    end;

    procedure InitializeRequest2(NewStartDate: Date; NewEndDate: Date; NewPostingDescription: Text[100]; NewPostingDate: Date; NewPostingDocNo: Code[20]; NewAdjCustVendBank: Boolean; NewAdjGLAcc: Boolean; _NewAdjBank: Boolean; _NewAdjCust: Boolean; _NewAdjVend: Boolean; _NewTestMode: Boolean; _NewSummarizeEntries: Boolean)
    begin
        InitializeRequest(NewStartDate, NewEndDate, NewPostingDescription, NewPostingDate);
        PostingDocNo := NewPostingDocNo;
        AdjCustVendBank := NewAdjCustVendBank;
        AdjGLAcc := NewAdjGLAcc;
        //SSA960>>
        AdjVend := _NewAdjVend;
        AdjBank := _NewAdjBank;
        AdjCust := _NewAdjCust;
        TestMode := _NewTestMode;
        SummarizeEntries := _NewSummarizeEntries;
        //SSA960<<
    end;

    local procedure AdjExchRateBufferUpdate(CurrencyCode2: Code[10]; PostingGroup2: Code[20]; AdjBase2: Decimal; AdjBaseLCY2: Decimal; AdjAmount2: Decimal; GainsAmount2: Decimal; LossesAmount2: Decimal; DimEntryNo: Integer; Postingdate2: Date; ICCode: Code[20]; _EntryNo: Integer; _SourceType: Option " ",Customer,Vendor,"Bank Account","Fixed Asset"; _SourceNo: Code[20]): Integer
    begin
        AdjExchRateBuffer.Init;

        OK := AdjExchRateBuffer.Get(CurrencyCode2, PostingGroup2, DimEntryNo, Postingdate2, ICCode, _EntryNo);

        AdjExchRateBuffer.AdjBase := AdjExchRateBuffer.AdjBase + AdjBase2;
        AdjExchRateBuffer.AdjBaseLCY := AdjExchRateBuffer.AdjBaseLCY + AdjBaseLCY2;
        AdjExchRateBuffer.AdjAmount := AdjExchRateBuffer.AdjAmount + AdjAmount2;
        AdjExchRateBuffer.TotalGainsAmount := AdjExchRateBuffer.TotalGainsAmount + GainsAmount2;
        AdjExchRateBuffer.TotalLossesAmount := AdjExchRateBuffer.TotalLossesAmount + LossesAmount2;

        if not OK then begin
            AdjExchRateBuffer."Currency Code" := CurrencyCode2;
            AdjExchRateBuffer."Posting Group" := PostingGroup2;
            AdjExchRateBuffer."Dimension Entry No." := DimEntryNo;
            AdjExchRateBuffer."Posting Date" := Postingdate2;
            AdjExchRateBuffer."IC Partner Code" := ICCode;
            MaxAdjExchRateBufIndex += 1;
            //SSA960>>
            if SummarizeEntries then
                MaxAdjExchRateBufIndex := 0;
            //SSA960<<
            AdjExchRateBuffer.Index := MaxAdjExchRateBufIndex;

            //SSA960>>
            AdjExchRateBuffer."Entry No." := _EntryNo;
            AdjExchRateBuffer."SSA Source Type" := _SourceType;
            AdjExchRateBuffer."SSA Source No." := _SourceNo;
            //SSA960<<

            AdjExchRateBuffer.Insert;
        end else
            AdjExchRateBuffer.Modify;

        exit(AdjExchRateBuffer.Index);
    end;

    local procedure HandlePostAdjmt(AdjustAccType: Integer)
    var
        GLEntry: Record "G/L Entry";
        TempDtldCVLedgEntryBuf: Record "Detailed CV Ledg. Entry Buffer" temporary;
        GainsOrLossAccNo: Code[20];
    begin
        //SSA960>>
        if AdjustAccType = 1 then
            AdjExchRateBuffer.SetRange(AdjExchRateBuffer."SSA Source Type", AdjExchRateBuffer."SSA Source Type"::Customer);
        if AdjustAccType = 2 then
            AdjExchRateBuffer.SetRange(AdjExchRateBuffer."SSA Source Type", AdjExchRateBuffer."SSA Source Type"::Vendor);
        // Summarize per currency and dimension combination
        //SSA960<<
        if AdjExchRateBuffer.Find('-') then begin
            // Post per posting group and per currency
            repeat
                AdjExchRateBuffer2.Init;
                OK :=
                  AdjExchRateBuffer2.Get(
                    AdjExchRateBuffer."Currency Code",
                    '-', //SSA960 //OC '',
                    AdjExchRateBuffer."Dimension Entry No.",
                    AdjExchRateBuffer."Posting Date",
                    AdjExchRateBuffer."IC Partner Code",
                    AdjExchRateBuffer."Entry No."); //SSA960
                AdjExchRateBuffer2.AdjBase := AdjExchRateBuffer2.AdjBase + AdjExchRateBuffer.AdjBase;
                AdjExchRateBuffer2.TotalGainsAmount := AdjExchRateBuffer2.TotalGainsAmount + AdjExchRateBuffer.TotalGainsAmount;
                AdjExchRateBuffer2.TotalLossesAmount := AdjExchRateBuffer2.TotalLossesAmount + AdjExchRateBuffer.TotalLossesAmount;
                if not OK then begin
                    AdjExchRateBuffer2."Currency Code" := AdjExchRateBuffer."Currency Code";
                    AdjExchRateBuffer2."Dimension Entry No." := AdjExchRateBuffer."Dimension Entry No.";
                    AdjExchRateBuffer2."Posting Date" := AdjExchRateBuffer."Posting Date";
                    AdjExchRateBuffer2."IC Partner Code" := AdjExchRateBuffer."IC Partner Code";

                    //SSA960>>
                    AdjExchRateBuffer2."Entry No." := AdjExchRateBuffer."Entry No.";
                    AdjExchRateBuffer2."SSA Source Type" := AdjExchRateBuffer."SSA Source Type";
                    AdjExchRateBuffer2."SSA Source No." := AdjExchRateBuffer."SSA Source No.";
                    //SSA960<< Customer

                    AdjExchRateBuffer2.Insert;
                end else
                    AdjExchRateBuffer2.Modify;
            until AdjExchRateBuffer.Next = 0;

            //SSA960>>

            // Post per posting group and per currency
            if AdjExchRateBuffer2.Find('-') then

                // Vendor
                //IF AdjExchRateBuffer2.FIND(' Customer') THEN
                //SSA960<<
                repeat
                    with AdjExchRateBuffer do begin
                        SetRange("Currency Code", AdjExchRateBuffer2."Currency Code");
                        SetRange("Dimension Entry No.", AdjExchRateBuffer2."Dimension Entry No.");
                        SetRange("Posting Date", AdjExchRateBuffer2."Posting Date");
                        SetRange("IC Partner Code", AdjExchRateBuffer2."IC Partner Code");
                        //SSA960>>
                        if not SummarizeEntries then
                            SetRange("Entry No.", AdjExchRateBuffer2."Entry No.");
                        //SSA960 Vendor

                        TempDimBuf.Reset;
                        TempDimBuf.DeleteAll;
                        TempDimSetEntry.Reset;
                        TempDimSetEntry.DeleteAll;
                        Find('-');
                        DimBufMgt.GetDimensions("Dimension Entry No.", TempDimBuf);
                        DimMgt.CopyDimBufToDimSetEntry(TempDimBuf, TempDimSetEntry);
                        repeat
                            TempDtldCVLedgEntryBuf.Init;
                            TempDtldCVLedgEntryBuf."Entry No." := Index;
                            if AdjAmount <> 0 then
                                case AdjustAccType of
                                    1: // Customer
                                        begin
                                            //SSA960>>
                                            if not SummarizeEntries then
                                                CustLedgEntryToCVLedgEntry("Entry No.");
                                            //SSA960<<

                                            CustPostingGr.Get("Posting Group");
                                            TempDtldCVLedgEntryBuf."Transaction No." :=
                                              //SSA960>>
                                              /* //OC
                                              PostAdjmt(
                                                CustPostingGr.GetReceivablesAccount,AdjAmount,AdjBase,"Currency Code",TempDimSetEntry,
                                                AdjExchRateBuffer2."Posting Date","IC Partner Code");
                                              */
                                              PostAdjmt(
                                                CustPostingGr.GetReceivablesAccount, AdjAmount, AdjBase, "Currency Code", TempDimSetEntry,
                                                AdjExchRateBuffer2."Posting Date", "IC Partner Code", AdjExchRateBuffer2."SSA Source Type", AdjExchRateBuffer2."SSA Source No.");
                                            //SSA960<<
                                            if TempDtldCVLedgEntryBuf.Insert then;
                                            //SSA960>>
                                            //InsertExchRateAdjmtReg(1,"Posting Group","Currency Code");
                                            InsertExchRateAdjmtReg(1, "Posting Group", "Currency Code", AdjExchRateBuffer2."SSA Source Type", AdjExchRateBuffer2."SSA Source No.");
                                            //SSA960<<
                                            TotalCustomersAdjusted += 1;
                                        end;
                                    2: // Vendor
                                        begin
                                            //SSA960>>
                                            if not SummarizeEntries then
                                                VendLedgEntryToCVLedgEntry("Entry No.");
                                            //SSA960<<

                                            VendPostingGr.Get("Posting Group");
                                            TempDtldCVLedgEntryBuf."Transaction No." :=
                                              //SSA960>>
                                              /* //OC
                                              PostAdjmt(
                                                VendPostingGr.GetPayablesAccount,AdjAmount,AdjBase,"Currency Code",TempDimSetEntry,
                                                AdjExchRateBuffer2."Posting Date","IC Partner Code");
                                              */
                                              PostAdjmt(
                                                VendPostingGr.GetPayablesAccount, AdjAmount, AdjBase, "Currency Code", TempDimSetEntry,
                                                AdjExchRateBuffer2."Posting Date", "IC Partner Code", AdjExchRateBuffer2."SSA Source Type", AdjExchRateBuffer2."SSA Source No.");
                                            //SSA960<<
                                            if TempDtldCVLedgEntryBuf.Insert then;
                                            //SSA960>>
                                            //InsertExchRateAdjmtReg(2,"Posting Group","Currency Code");
                                            InsertExchRateAdjmtReg(2, "Posting Group", "Currency Code", AdjExchRateBuffer2."SSA Source Type", AdjExchRateBuffer2."SSA Source No.");
                                            //SSA960<<
                                            TotalVendorsAdjusted += 1;
                                        end;
                                end;
                        until Next = 0;
                    end;

                    with AdjExchRateBuffer2 do begin
                        Currency2.Get("Currency Code");
                        if TotalGainsAmount <> 0 then begin
                            //SSA960>>
                            /* //OC
                            PostAdjmt(
                              Currency2.GetUnrealizedGainsAccount,-TotalGainsAmount,AdjBase,"Currency Code",TempDimSetEntry,
                              "Posting Date","IC Partner Code");
                            */
                            GainsOrLossAccNo := Currency2.GetUnrealizedGainsAccount;
                            if TotalGainsAmount < 0 then begin
                                Currency2.TestField("Unrealized Losses Acc.");
                                GainsOrLossAccNo := Currency2.GetUnrealizedLossesAccount;
                            end;
                            PostAdjmt(
                              GainsOrLossAccNo, -TotalGainsAmount, AdjBase, "Currency Code", TempDimSetEntry,
                              "Posting Date", "IC Partner Code", AdjExchRateBuffer2."SSA Source Type", AdjExchRateBuffer2."SSA Source No.");
                            //SSA960<<
                        end;
                        if TotalLossesAmount <> 0 then begin
                            //SSA960>>
                            /*//OC
                            PostAdjmt(
                              Currency2.GetUnrealizedLossesAccount,-TotalLossesAmount,AdjBase,"Currency Code",TempDimSetEntry,
                              "Posting Date","IC Partner Code");
                            */

                            Currency2.TestField("Unrealized Losses Acc.");
                            GainsOrLossAccNo := Currency2.GetUnrealizedLossesAccount;
                            if TotalLossesAmount > 0 then begin
                                Currency2.TestField("Unrealized Gains Acc.");
                                GainsOrLossAccNo := Currency2.GetUnrealizedGainsAccount;
                            end;
                            PostAdjmt(
                             GainsOrLossAccNo, -TotalLossesAmount, AdjBase, "Currency Code", TempDimSetEntry,
                             "Posting Date", "IC Partner Code", AdjExchRateBuffer2."SSA Source Type", AdjExchRateBuffer2."SSA Source No.");
                            //SSA960<<
                        end;
                    end;
                until AdjExchRateBuffer2.Next = 0;

            if not TestMode then begin //SSA960
                GLEntry.FindLast;
                case AdjustAccType of
                    1: // Customer
                        if TempDtldCustLedgEntry.Find('-') then
                            repeat
                                if TempDtldCVLedgEntryBuf.Get(TempDtldCustLedgEntry."Transaction No.") then
                                    TempDtldCustLedgEntry."Transaction No." := TempDtldCVLedgEntryBuf."Transaction No."
                                else
                                    TempDtldCustLedgEntry."Transaction No." := GLEntry."Transaction No.";
                                DtldCustLedgEntry := TempDtldCustLedgEntry;
                                DtldCustLedgEntry.Insert(true);
                            until TempDtldCustLedgEntry.Next = 0;
                    2: // Vendor
                        if TempDtldVendLedgEntry.Find('-') then
                            repeat
                                if TempDtldCVLedgEntryBuf.Get(TempDtldVendLedgEntry."Transaction No.") then
                                    TempDtldVendLedgEntry."Transaction No." := TempDtldCVLedgEntryBuf."Transaction No."
                                else
                                    TempDtldVendLedgEntry."Transaction No." := GLEntry."Transaction No.";
                                DtldVendLedgEntry := TempDtldVendLedgEntry;
                                DtldVendLedgEntry.Insert(true);
                            until TempDtldVendLedgEntry.Next = 0;
                end;
            end; //SSA960
            AdjExchRateBuffer.Reset;
            AdjExchRateBuffer.DeleteAll;
            AdjExchRateBuffer2.Reset;
            AdjExchRateBuffer2.DeleteAll;
            TempDtldCustLedgEntry.Reset;
            TempDtldCustLedgEntry.DeleteAll;
            TempDtldVendLedgEntry.Reset;
            TempDtldVendLedgEntry.DeleteAll;
        end;

    end;

    local procedure AdjustVATEntries(VATType: Integer; UseTax: Boolean)
    begin
        Clear(VATEntry2);
        with VATEntry do begin
            SetRange(Type, VATType);
            SetRange("Use Tax", UseTax);
            if Find('-') then
                repeat
                    Accumulate(VATEntry2.Base, Base);
                    Accumulate(VATEntry2.Amount, Amount);
                    Accumulate(VATEntry2."Unrealized Amount", "Unrealized Amount");
                    Accumulate(VATEntry2."Unrealized Base", "Unrealized Base");
                    Accumulate(VATEntry2."Remaining Unrealized Amount", "Remaining Unrealized Amount");
                    Accumulate(VATEntry2."Remaining Unrealized Base", "Remaining Unrealized Base");
                    Accumulate(VATEntry2."Additional-Currency Amount", "Additional-Currency Amount");
                    Accumulate(VATEntry2."Additional-Currency Base", "Additional-Currency Base");
                    Accumulate(VATEntry2."Add.-Currency Unrealized Amt.", "Add.-Currency Unrealized Amt.");
                    Accumulate(VATEntry2."Add.-Currency Unrealized Base", "Add.-Currency Unrealized Base");
                    Accumulate(VATEntry2."Add.-Curr. Rem. Unreal. Amount", "Add.-Curr. Rem. Unreal. Amount");
                    Accumulate(VATEntry2."Add.-Curr. Rem. Unreal. Base", "Add.-Curr. Rem. Unreal. Base");

                    Accumulate(VATEntryTotalBase.Base, Base);
                    Accumulate(VATEntryTotalBase.Amount, Amount);
                    Accumulate(VATEntryTotalBase."Unrealized Amount", "Unrealized Amount");
                    Accumulate(VATEntryTotalBase."Unrealized Base", "Unrealized Base");
                    Accumulate(VATEntryTotalBase."Remaining Unrealized Amount", "Remaining Unrealized Amount");
                    Accumulate(VATEntryTotalBase."Remaining Unrealized Base", "Remaining Unrealized Base");
                    Accumulate(VATEntryTotalBase."Additional-Currency Amount", "Additional-Currency Amount");
                    Accumulate(VATEntryTotalBase."Additional-Currency Base", "Additional-Currency Base");
                    Accumulate(VATEntryTotalBase."Add.-Currency Unrealized Amt.", "Add.-Currency Unrealized Amt.");
                    Accumulate(VATEntryTotalBase."Add.-Currency Unrealized Base", "Add.-Currency Unrealized Base");
                    Accumulate(
                      VATEntryTotalBase."Add.-Curr. Rem. Unreal. Amount", "Add.-Curr. Rem. Unreal. Amount");
                    Accumulate(VATEntryTotalBase."Add.-Curr. Rem. Unreal. Base", "Add.-Curr. Rem. Unreal. Base");

                    AdjustVATAmount(Base, "Additional-Currency Base");
                    AdjustVATAmount(Amount, "Additional-Currency Amount");
                    AdjustVATAmount("Unrealized Amount", "Add.-Currency Unrealized Amt.");
                    AdjustVATAmount("Unrealized Base", "Add.-Currency Unrealized Base");
                    AdjustVATAmount("Remaining Unrealized Amount", "Add.-Curr. Rem. Unreal. Amount");
                    AdjustVATAmount("Remaining Unrealized Base", "Add.-Curr. Rem. Unreal. Base");
                    if not TestMode then //SSA960
                        Modify;

                    Accumulate(VATEntry2.Base, -Base);
                    Accumulate(VATEntry2.Amount, -Amount);
                    Accumulate(VATEntry2."Unrealized Amount", -"Unrealized Amount");
                    Accumulate(VATEntry2."Unrealized Base", -"Unrealized Base");
                    Accumulate(VATEntry2."Remaining Unrealized Amount", -"Remaining Unrealized Amount");
                    Accumulate(VATEntry2."Remaining Unrealized Base", -"Remaining Unrealized Base");
                    Accumulate(VATEntry2."Additional-Currency Amount", -"Additional-Currency Amount");
                    Accumulate(VATEntry2."Additional-Currency Base", -"Additional-Currency Base");
                    Accumulate(VATEntry2."Add.-Currency Unrealized Amt.", -"Add.-Currency Unrealized Amt.");
                    Accumulate(VATEntry2."Add.-Currency Unrealized Base", -"Add.-Currency Unrealized Base");
                    Accumulate(VATEntry2."Add.-Curr. Rem. Unreal. Amount", -"Add.-Curr. Rem. Unreal. Amount");
                    Accumulate(VATEntry2."Add.-Curr. Rem. Unreal. Base", -"Add.-Curr. Rem. Unreal. Base");
                until Next = 0;
        end;
    end;

    local procedure AdjustVATAmount(var AmountLCY: Decimal; var AmountAddCurr: Decimal)
    begin
        case GLSetup."VAT Exchange Rate Adjustment" of
            GLSetup."VAT Exchange Rate Adjustment"::"Adjust Amount":
                AmountLCY :=
                  Round(
                    CurrExchRate2.ExchangeAmtFCYToLCYAdjmt(
                      PostingDate, GLSetup."Additional Reporting Currency",
                      AmountAddCurr, AddCurrCurrencyFactor));
            GLSetup."VAT Exchange Rate Adjustment"::"Adjust Additional-Currency Amount":
                AmountAddCurr :=
                  Round(
                    CurrExchRate2.ExchangeAmtLCYToFCY(
                      PostingDate, GLSetup."Additional Reporting Currency",
                      AmountLCY, AddCurrCurrencyFactor));
        end;
    end;

    local procedure AdjustVATAccount(AccNo: Code[20]; AmountLCY: Decimal; AmountAddCurr: Decimal; BaseLCY: Decimal; BaseAddCurr: Decimal)
    begin
        "G/L Account".Get(AccNo);
        "G/L Account".SetRange("Date Filter", StartDate, EndDate);
        case GLSetup."VAT Exchange Rate Adjustment" of
            GLSetup."VAT Exchange Rate Adjustment"::"Adjust Amount":
                PostGLAccAdjmt(
                  AccNo, GLSetup."VAT Exchange Rate Adjustment"::"Adjust Amount",
                  -AmountLCY, BaseLCY, BaseAddCurr);
            GLSetup."VAT Exchange Rate Adjustment"::"Adjust Additional-Currency Amount":
                PostGLAccAdjmt(
                  AccNo, GLSetup."VAT Exchange Rate Adjustment"::"Adjust Additional-Currency Amount",
                  -AmountAddCurr, BaseLCY, BaseAddCurr);
        end;
    end;

    local procedure AdjustPurchTax(UseTax: Boolean)
    begin
        if (VATEntry2.Amount <> 0) or (VATEntry2."Additional-Currency Amount" <> 0) then begin
            TaxJurisdiction.TestField("Tax Account (Purchases)");
            AdjustVATAccount(
              TaxJurisdiction."Tax Account (Purchases)",
              VATEntry2.Amount, VATEntry2."Additional-Currency Amount",
              VATEntryTotalBase.Amount, VATEntryTotalBase."Additional-Currency Amount");
            if UseTax then begin
                TaxJurisdiction.TestField("Reverse Charge (Purchases)");
                AdjustVATAccount(
                  TaxJurisdiction."Reverse Charge (Purchases)",
                  -VATEntry2.Amount, -VATEntry2."Additional-Currency Amount",
                  -VATEntryTotalBase.Amount, -VATEntryTotalBase."Additional-Currency Amount");
            end;
        end;
        if (VATEntry2."Remaining Unrealized Amount" <> 0) or
           (VATEntry2."Add.-Curr. Rem. Unreal. Amount" <> 0)
        then begin
            TaxJurisdiction.TestField("Unrealized VAT Type");
            TaxJurisdiction.TestField("Unreal. Tax Acc. (Purchases)");
            AdjustVATAccount(
              TaxJurisdiction."Unreal. Tax Acc. (Purchases)",
              VATEntry2."Remaining Unrealized Amount", VATEntry2."Add.-Curr. Rem. Unreal. Amount",
              VATEntryTotalBase."Remaining Unrealized Amount", VATEntry2."Add.-Curr. Rem. Unreal. Amount");

            if UseTax then begin
                TaxJurisdiction.TestField("Unreal. Rev. Charge (Purch.)");
                AdjustVATAccount(
                  TaxJurisdiction."Unreal. Rev. Charge (Purch.)",
                  -VATEntry2."Remaining Unrealized Amount",
                  -VATEntry2."Add.-Curr. Rem. Unreal. Amount",
                  -VATEntryTotalBase."Remaining Unrealized Amount",
                  -VATEntryTotalBase."Add.-Curr. Rem. Unreal. Amount");
            end;
        end;
    end;

    local procedure AdjustSalesTax()
    begin
        TaxJurisdiction.TestField("Tax Account (Sales)");
        AdjustVATAccount(
          TaxJurisdiction."Tax Account (Sales)",
          VATEntry2.Amount, VATEntry2."Additional-Currency Amount",
          VATEntryTotalBase.Amount, VATEntryTotalBase."Additional-Currency Amount");
        if (VATEntry2."Remaining Unrealized Amount" <> 0) or
           (VATEntry2."Add.-Curr. Rem. Unreal. Amount" <> 0)
        then begin
            TaxJurisdiction.TestField("Unrealized VAT Type");
            TaxJurisdiction.TestField("Unreal. Tax Acc. (Sales)");
            AdjustVATAccount(
              TaxJurisdiction."Unreal. Tax Acc. (Sales)",
              VATEntry2."Remaining Unrealized Amount",
              VATEntry2."Add.-Curr. Rem. Unreal. Amount",
              VATEntryTotalBase."Remaining Unrealized Amount",
              VATEntryTotalBase."Add.-Curr. Rem. Unreal. Amount");
        end;
    end;

    local procedure Accumulate(var TotalAmount: Decimal; AmountToAdd: Decimal)
    begin
        TotalAmount := TotalAmount + AmountToAdd;
    end;

    local procedure PostGLAccAdjmt(GLAccNo: Code[20]; ExchRateAdjmt: Integer; Amount: Decimal; NetChange: Decimal; AddCurrNetChange: Decimal)
    begin
        GenJnlLine.Init;
        case ExchRateAdjmt of
            "G/L Account"."Exchange Rate Adjustment"::"Adjust Amount":
                begin
                    GenJnlLine."Additional-Currency Posting" := GenJnlLine."Additional-Currency Posting"::"Amount Only";
                    GenJnlLine."Currency Code" := '';
                    GenJnlLine.Amount := Amount;
                    GenJnlLine."Amount (LCY)" := GenJnlLine.Amount;
                    GLAmtTotal := GLAmtTotal + GenJnlLine.Amount;
                    GLAddCurrNetChangeTotal := GLAddCurrNetChangeTotal + AddCurrNetChange;
                    GLNetChangeBase := GLNetChangeBase + NetChange;
                end;
            "G/L Account"."Exchange Rate Adjustment"::"Adjust Additional-Currency Amount":
                begin
                    GenJnlLine."Additional-Currency Posting" := GenJnlLine."Additional-Currency Posting"::"Additional-Currency Amount Only";
                    GenJnlLine."Currency Code" := GLSetup."Additional Reporting Currency";
                    GenJnlLine.Amount := Amount;
                    GenJnlLine."Amount (LCY)" := 0;
                    GLAddCurrAmtTotal := GLAddCurrAmtTotal + GenJnlLine.Amount;
                    GLNetChangeTotal := GLNetChangeTotal + NetChange;
                    GLAddCurrNetChangeBase := GLAddCurrNetChangeBase + AddCurrNetChange;
                end;
        end;
        if GenJnlLine.Amount <> 0 then begin
            GenJnlLine."Document No." := PostingDocNo;
            GenJnlLine."Account Type" := GenJnlLine."Account Type"::"G/L Account";
            GenJnlLine."Account No." := GLAccNo;
            GenJnlLine."Posting Date" := PostingDate;
            case GenJnlLine."Additional-Currency Posting" of
                GenJnlLine."Additional-Currency Posting"::"Amount Only":
                    //
                    /*//OC
                    GenJnlLine.Description :=
                      STRSUBSTNO(
                        PostingDescription,
                        GLSetup."Additional Reporting Currency",
                        AddCurrNetChange);
                    */
                    GenJnlLine.Description :=
                      StrSubstNo(
                        PostingDescription,
                        GLSetup."Additional Reporting Currency",
                        AddCurrNetChange, '', '');
                //SSA960<<
                GenJnlLine."Additional-Currency Posting"::"Additional-Currency Amount Only":
                    //SSA960>>
                    /*//OC
                    GenJnlLine.Description :=
                      STRSUBSTNO(
                        PostingDescription,
                        '',
                        NetChange);
                    */
                    GenJnlLine.Description :=
                      StrSubstNo(
                        PostingDescription,
                        '',
                        NetChange, '', '');
            //SSA960<<
            end;
            GenJnlLine."System-Created Entry" := true;
            GenJnlLine."Source Code" := SourceCodeSetup."Exchange Rate Adjmt.";
            if not TestMode then begin //SSA960
                GetJnlLineDefDim(GenJnlLine, TempDimSetEntry);
                PostGenJnlLine(GenJnlLine, TempDimSetEntry);
            end; //SSA960
        end;

    end;

    local procedure CheckExchRateAdjustment(AccNo: Code[20]; SetupTableName: Text[100]; SetupFieldName: Text[100])
    var
        GLAcc: Record "G/L Account";
        GLSetup: Record "General Ledger Setup";
    begin
        if AccNo = '' then
            exit;
        GLAcc.Get(AccNo);
        if GLAcc."Exchange Rate Adjustment" <> GLAcc."Exchange Rate Adjustment"::"No Adjustment" then begin
            GLAcc."Exchange Rate Adjustment" := GLAcc."Exchange Rate Adjustment"::"No Adjustment";
            Error(
              Text017,
              GLAcc.FieldCaption("Exchange Rate Adjustment"), GLAcc.TableCaption,
              GLAcc."No.", GLAcc."Exchange Rate Adjustment",
              SetupTableName, GLSetup.FieldCaption("VAT Exchange Rate Adjustment"),
              GLSetup.TableCaption, SetupFieldName);
        end;
    end;

    local procedure HandleCustDebitCredit(Amount: Decimal; AmountLCY: Decimal; Correction: Boolean; AdjAmount: Decimal)
    begin
        if ((Amount > 0) or (AmountLCY > 0)) and (not Correction) or
           ((Amount < 0) or (AmountLCY < 0)) and Correction
        then begin
            TempDtldCustLedgEntry."Debit Amount (LCY)" := AdjAmount;
            TempDtldCustLedgEntry."Credit Amount (LCY)" := 0;
        end else begin
            TempDtldCustLedgEntry."Debit Amount (LCY)" := 0;
            TempDtldCustLedgEntry."Credit Amount (LCY)" := -AdjAmount;
        end;
    end;

    local procedure HandleVendDebitCredit(Amount: Decimal; AmountLCY: Decimal; Correction: Boolean; AdjAmount: Decimal)
    begin
        if ((Amount > 0) or (AmountLCY > 0)) and (not Correction) or
           ((Amount < 0) or (AmountLCY < 0)) and Correction
        then begin
            TempDtldVendLedgEntry."Debit Amount (LCY)" := AdjAmount;
            TempDtldVendLedgEntry."Credit Amount (LCY)" := 0;
        end else begin
            TempDtldVendLedgEntry."Debit Amount (LCY)" := 0;
            TempDtldVendLedgEntry."Credit Amount (LCY)" := -AdjAmount;
        end;
    end;

    local procedure GetJnlLineDefDim(var GenJnlLine: Record "Gen. Journal Line"; var DimSetEntry: Record "Dimension Set Entry")
    var
        DimSetID: Integer;
        TableID: array[10] of Integer;
        No: array[10] of Code[20];
    begin
        with GenJnlLine do begin
            case "Account Type" of
                "Account Type"::"G/L Account":
                    TableID[1] := DATABASE::"G/L Account";
                "Account Type"::"Bank Account":
                    TableID[1] := DATABASE::"Bank Account";
            end;
            No[1] := "Account No.";
            DimSetID :=
              DimMgt.GetDefaultDimID(
                TableID, No, "Source Code", "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code", "Dimension Set ID", 0);
        end;
        DimMgt.GetDimensionSet(DimSetEntry, DimSetID);
    end;

    local procedure CopyDimSetEntryToDimBuf(var DimSetEntry: Record "Dimension Set Entry"; var DimBuf: Record "Dimension Buffer")
    begin
        if DimSetEntry.Find('-') then
            repeat
                DimBuf."Table ID" := DATABASE::"Dimension Buffer";
                DimBuf."Entry No." := 0;
                DimBuf."Dimension Code" := DimSetEntry."Dimension Code";
                DimBuf."Dimension Value Code" := DimSetEntry."Dimension Value Code";
                DimBuf.Insert;
            until DimSetEntry.Next = 0;
    end;

    local procedure GetDimCombID(var DimBuf: Record "Dimension Buffer"): Integer
    var
        DimEntryNo: Integer;
    begin
        DimEntryNo := DimBufMgt.FindDimensions(DimBuf);
        if DimEntryNo = 0 then
            DimEntryNo := DimBufMgt.InsertDimensions(DimBuf);
        exit(DimEntryNo);
    end;

    local procedure PostGenJnlLine(var GenJnlLine: Record "Gen. Journal Line"; var DimSetEntry: Record "Dimension Set Entry"): Integer
    begin
        GenJnlLine."Shortcut Dimension 1 Code" := GetGlobalDimVal(GLSetup."Global Dimension 1 Code", DimSetEntry);
        GenJnlLine."Shortcut Dimension 2 Code" := GetGlobalDimVal(GLSetup."Global Dimension 2 Code", DimSetEntry);
        GenJnlLine."Dimension Set ID" := DimMgt.GetDimensionSetID(TempDimSetEntry);
        GenJnlPostLine.Run(GenJnlLine);
        exit(GenJnlPostLine.GetNextTransactionNo);
    end;

    local procedure GetGlobalDimVal(GlobalDimCode: Code[20]; var DimSetEntry: Record "Dimension Set Entry"): Code[20]
    var
        DimVal: Code[20];
    begin
        if GlobalDimCode = '' then
            DimVal := ''
        else begin
            DimSetEntry.SetRange("Dimension Code", GlobalDimCode);
            if DimSetEntry.Find('-') then
                DimVal := DimSetEntry."Dimension Value Code"
            else
                DimVal := '';
            DimSetEntry.SetRange("Dimension Code");
        end;
        exit(DimVal);
    end;

    procedure CheckPostingDate()
    begin
        if PostingDate < StartDate then
            Error(Text018);
        if PostingDate > EndDateReq then
            Error(Text018);
    end;

    procedure AdjustCustomerLedgerEntry(CusLedgerEntry: Record "Cust. Ledger Entry"; PostingDate2: Date)
    var
        DimSetEntry: Record "Dimension Set Entry";
        DimEntryNo: Integer;
        OldAdjAmount: Decimal;
        Adjust: Boolean;
        AdjExchRateBufIndex: Integer;
    begin
        with CusLedgerEntry do begin
            SetRange("Date Filter", 0D, PostingDate2);
            Currency2.Get("Currency Code");
            GainsAmount := 0;
            LossesAmount := 0;
            OldAdjAmount := 0;
            Adjust := false;

            TempDimSetEntry.Reset;
            TempDimSetEntry.DeleteAll;
            TempDimBuf.Reset;
            TempDimBuf.DeleteAll;
            DimSetEntry.SetRange("Dimension Set ID", "Dimension Set ID");
            CopyDimSetEntryToDimBuf(DimSetEntry, TempDimBuf);
            DimEntryNo := GetDimCombID(TempDimBuf);

            CalcFields(
              Amount, "Amount (LCY)", "Remaining Amount", "Remaining Amt. (LCY)", "Original Amt. (LCY)",
              "Debit Amount", "Credit Amount", "Debit Amount (LCY)", "Credit Amount (LCY)");

            // Calculate Old Unrealized Gains and Losses
            SetUnrealizedGainLossFilterCust(DtldCustLedgEntry, "Entry No.");
            DtldCustLedgEntry.CalcSums("Amount (LCY)");

            SetUnrealizedGainLossFilterCust(TempDtldCustLedgEntrySums, "Entry No.");
            TempDtldCustLedgEntrySums.CalcSums("Amount (LCY)");
            OldAdjAmount := DtldCustLedgEntry."Amount (LCY)" + TempDtldCustLedgEntrySums."Amount (LCY)";
            "Remaining Amt. (LCY)" := "Remaining Amt. (LCY)" + TempDtldCustLedgEntrySums."Amount (LCY)";
            "Debit Amount (LCY)" := "Debit Amount (LCY)" + TempDtldCustLedgEntrySums."Amount (LCY)";
            "Credit Amount (LCY)" := "Credit Amount (LCY)" + TempDtldCustLedgEntrySums."Amount (LCY)";
            TempDtldCustLedgEntrySums.Reset;

            // Modify Currency factor on Customer Ledger Entry
            if "Adjusted Currency Factor" <> Currency2."Currency Factor" then begin
                "Adjusted Currency Factor" := Currency2."Currency Factor";
                if not TestMode then // Calculate New Unrealized Gains and Losses
                    Modify;
            end;

            AdjustedFactor := Round(1 / "Adjusted Currency Factor", 0.0001); //SSA960

            // Calculate New Unrealized Gains and Losses
            AdjAmount :=
              Round(
                CurrExchRate.ExchangeAmtFCYToLCYAdjmt(
                  PostingDate2, Currency2.Code, "Remaining Amount", Currency2."Currency Factor")) -
              "Remaining Amt. (LCY)";

            if AdjAmount <> 0 then begin
                InitDtldCustLedgEntry(CusLedgerEntry, TempDtldCustLedgEntry);
                TempDtldCustLedgEntry."Entry No." := NewEntryNo;
                TempDtldCustLedgEntry."Posting Date" := PostingDate2;
                TempDtldCustLedgEntry."Document No." := PostingDocNo;

                Correction :=
                  ("Debit Amount" < 0) or
                  ("Credit Amount" < 0) or
                  ("Debit Amount (LCY)" < 0) or
                  ("Credit Amount (LCY)" < 0);

                if OldAdjAmount > 0 then
                    case true of
                        (AdjAmount > 0):
                            begin
                                TempDtldCustLedgEntry."Amount (LCY)" := AdjAmount;
                                TempDtldCustLedgEntry."Entry Type" := TempDtldCustLedgEntry."Entry Type"::"Unrealized Gain";
                                HandleCustDebitCredit(
                                  Amount, "Amount (LCY)", Correction, TempDtldCustLedgEntry."Amount (LCY)");
                                InsertTempDtldCustomerLedgerEntry;
                                NewEntryNo := NewEntryNo + 1;
                                GainsAmount := AdjAmount;
                                Adjust := true;
                            end;
                        (AdjAmount < 0):
                            if -AdjAmount <= OldAdjAmount then begin
                                TempDtldCustLedgEntry."Amount (LCY)" := AdjAmount;
                                TempDtldCustLedgEntry."Entry Type" := TempDtldCustLedgEntry."Entry Type"::"Unrealized Loss";
                                HandleCustDebitCredit(
                                  Amount, "Amount (LCY)", Correction, TempDtldCustLedgEntry."Amount (LCY)");
                                InsertTempDtldCustomerLedgerEntry;
                                NewEntryNo := NewEntryNo + 1;
                                LossesAmount := AdjAmount;
                                Adjust := true;
                            end else begin
                                AdjAmount := AdjAmount + OldAdjAmount;
                                TempDtldCustLedgEntry."Amount (LCY)" := -OldAdjAmount;
                                TempDtldCustLedgEntry."Entry Type" := TempDtldCustLedgEntry."Entry Type"::"Unrealized Gain";
                                HandleCustDebitCredit(
                                  Amount, "Amount (LCY)", Correction, TempDtldCustLedgEntry."Amount (LCY)");
                                InsertTempDtldCustomerLedgerEntry;
                                NewEntryNo := NewEntryNo + 1;
                                AdjExchRateBufIndex :=
                                  //SSA960>>
                                  /*//OC
                                  AdjExchRateBufferUpdate(
                                    "Currency Code",Customer."Customer Posting Group",
                                    0,0,-OldAdjAmount,-OldAdjAmount,0,DimEntryNo,PostingDate2,Customer."IC Partner Code");
                                  */

                                  AdjExchRateBufferUpdate(
                                    "Currency Code", Customer."Customer Posting Group",
                                    0, 0, -OldAdjAmount, -OldAdjAmount, 0, DimEntryNo, PostingDate2, Customer."IC Partner Code", "Entry No.", 1, Customer."No.");
                                //SSA960<<

                                TempDtldCustLedgEntry."Transaction No." := AdjExchRateBufIndex;
                                ModifyTempDtldCustomerLedgerEntry;
                                Adjust := false;
                            end;
                    end;
                if OldAdjAmount < 0 then
                    case true of
                        (AdjAmount < 0):
                            begin
                                TempDtldCustLedgEntry."Amount (LCY)" := AdjAmount;
                                TempDtldCustLedgEntry."Entry Type" := TempDtldCustLedgEntry."Entry Type"::"Unrealized Loss";
                                HandleCustDebitCredit(
                                  Amount, "Amount (LCY)", Correction, TempDtldCustLedgEntry."Amount (LCY)");
                                InsertTempDtldCustomerLedgerEntry;
                                NewEntryNo := NewEntryNo + 1;
                                LossesAmount := AdjAmount;
                                Adjust := true;
                            end;
                        (AdjAmount > 0):
                            if AdjAmount <= -OldAdjAmount then begin
                                TempDtldCustLedgEntry."Amount (LCY)" := AdjAmount;
                                TempDtldCustLedgEntry."Entry Type" := TempDtldCustLedgEntry."Entry Type"::"Unrealized Gain";
                                HandleCustDebitCredit(
                                  Amount, "Amount (LCY)", Correction, TempDtldCustLedgEntry."Amount (LCY)");
                                InsertTempDtldCustomerLedgerEntry;
                                NewEntryNo := NewEntryNo + 1;
                                GainsAmount := AdjAmount;
                                Adjust := true;
                            end else begin
                                AdjAmount := OldAdjAmount + AdjAmount;
                                TempDtldCustLedgEntry."Amount (LCY)" := -OldAdjAmount;
                                TempDtldCustLedgEntry."Entry Type" := TempDtldCustLedgEntry."Entry Type"::"Unrealized Loss";
                                HandleCustDebitCredit(
                                  Amount, "Amount (LCY)", Correction, TempDtldCustLedgEntry."Amount (LCY)");
                                InsertTempDtldCustomerLedgerEntry;
                                NewEntryNo := NewEntryNo + 1;
                                AdjExchRateBufIndex :=
                                  //SSA960>>
                                  /*//OC
                                  AdjExchRateBufferUpdate(
                                    "Currency Code",Customer."Customer Posting Group",
                                    0,0,-OldAdjAmount,0,-OldAdjAmount,DimEntryNo,PostingDate2,Customer."IC Partner Code");
                                  */
                                  AdjExchRateBufferUpdate(
                                    "Currency Code", Customer."Customer Posting Group",
                                    0, 0, -OldAdjAmount, 0, -OldAdjAmount, DimEntryNo, PostingDate2, Customer."IC Partner Code", "Entry No.", 1, Customer."No.");
                                //SSA960<<
                                TempDtldCustLedgEntry."Transaction No." := AdjExchRateBufIndex;
                                ModifyTempDtldCustomerLedgerEntry;
                                Adjust := false;
                            end;
                    end;
                if not Adjust then begin
                    TempDtldCustLedgEntry."Amount (LCY)" := AdjAmount;
                    HandleCustDebitCredit(Amount, "Amount (LCY)", Correction, TempDtldCustLedgEntry."Amount (LCY)");
                    TempDtldCustLedgEntry."Entry No." := NewEntryNo;
                    if AdjAmount < 0 then begin
                        TempDtldCustLedgEntry."Entry Type" := TempDtldCustLedgEntry."Entry Type"::"Unrealized Loss";
                        GainsAmount := 0;
                        LossesAmount := AdjAmount;
                    end else
                        if AdjAmount > 0 then begin
                            TempDtldCustLedgEntry."Entry Type" := TempDtldCustLedgEntry."Entry Type"::"Unrealized Gain";
                            GainsAmount := AdjAmount;
                            LossesAmount := 0;
                        end;
                    InsertTempDtldCustomerLedgerEntry;
                    NewEntryNo := NewEntryNo + 1;
                end;

                TotalAdjAmount := TotalAdjAmount + AdjAmount;
                Window.Update(4, TotalAdjAmount);
                AdjExchRateBufIndex :=
                  //SSA960>>
                  /*//OC
                  AdjExchRateBufferUpdate(
                    "Currency Code",Customer."Customer Posting Group",
                    "Remaining Amount","Remaining Amt. (LCY)",TempDtldCustLedgEntry."Amount (LCY)",
                    GainsAmount,LossesAmount,DimEntryNo,PostingDate2,Customer."IC Partner Code");
                  */
                  AdjExchRateBufferUpdate(
                    "Currency Code", Customer."Customer Posting Group",
                    "Remaining Amount", "Remaining Amt. (LCY)", TempDtldCustLedgEntry."Amount (LCY)",
                    GainsAmount, LossesAmount, DimEntryNo, PostingDate2, Customer."IC Partner Code", "Entry No.", 1, Customer."No.");
                //SSA960<<
                TempDtldCustLedgEntry."Transaction No." := AdjExchRateBufIndex;
                ModifyTempDtldCustomerLedgerEntry;
            end;
        end;

    end;

    procedure AdjustVendorLedgerEntry(VendLedgerEntry: Record "Vendor Ledger Entry"; PostingDate2: Date)
    var
        DimSetEntry: Record "Dimension Set Entry";
        DimEntryNo: Integer;
        OldAdjAmount: Decimal;
        Adjust: Boolean;
        AdjExchRateBufIndex: Integer;
    begin
        with VendLedgerEntry do begin
            SetRange("Date Filter", 0D, PostingDate2);
            Currency2.Get("Currency Code");
            GainsAmount := 0;
            LossesAmount := 0;
            OldAdjAmount := 0;
            Adjust := false;

            TempDimBuf.Reset;
            TempDimBuf.DeleteAll;
            DimSetEntry.SetRange("Dimension Set ID", "Dimension Set ID");
            CopyDimSetEntryToDimBuf(DimSetEntry, TempDimBuf);
            DimEntryNo := GetDimCombID(TempDimBuf);

            CalcFields(
              Amount, "Amount (LCY)", "Remaining Amount", "Remaining Amt. (LCY)", "Original Amt. (LCY)",
              "Debit Amount", "Credit Amount", "Debit Amount (LCY)", "Credit Amount (LCY)");

            // Calculate Old Unrealized GainLoss
            SetUnrealizedGainLossFilterVend(DtldVendLedgEntry, "Entry No.");
            DtldVendLedgEntry.CalcSums("Amount (LCY)");

            SetUnrealizedGainLossFilterVend(TempDtldVendLedgEntrySums, "Entry No.");
            TempDtldVendLedgEntrySums.CalcSums("Amount (LCY)");
            OldAdjAmount := DtldVendLedgEntry."Amount (LCY)" + TempDtldVendLedgEntrySums."Amount (LCY)";
            "Remaining Amt. (LCY)" := "Remaining Amt. (LCY)" + TempDtldVendLedgEntrySums."Amount (LCY)";
            "Debit Amount (LCY)" := "Debit Amount (LCY)" + TempDtldVendLedgEntrySums."Amount (LCY)";
            "Credit Amount (LCY)" := "Credit Amount (LCY)" + TempDtldVendLedgEntrySums."Amount (LCY)";
            TempDtldVendLedgEntrySums.Reset;

            // Modify Currency factor on Vendor Ledger Entry
            if "Adjusted Currency Factor" <> Currency2."Currency Factor" then begin
                "Adjusted Currency Factor" := Currency2."Currency Factor";
                if not TestMode then // Calculate New Unrealized Gains and Losses
                    Modify;
            end;

            AdjustedFactor := Round(1 / "Adjusted Currency Factor", 0.0001); //SSA960

            // Calculate New Unrealized Gains and Losses
            AdjAmount :=
              Round(
                CurrExchRate.ExchangeAmtFCYToLCYAdjmt(
                  PostingDate2, Currency2.Code, "Remaining Amount", Currency2."Currency Factor")) -
              "Remaining Amt. (LCY)";

            if AdjAmount <> 0 then begin
                InitDtldVendLedgEntry(VendLedgerEntry, TempDtldVendLedgEntry);
                TempDtldVendLedgEntry."Entry No." := NewEntryNo;
                TempDtldVendLedgEntry."Posting Date" := PostingDate2;
                TempDtldVendLedgEntry."Document No." := PostingDocNo;

                Correction :=
                  ("Debit Amount" < 0) or
                  ("Credit Amount" < 0) or
                  ("Debit Amount (LCY)" < 0) or
                  ("Credit Amount (LCY)" < 0);

                if OldAdjAmount > 0 then
                    case true of
                        (AdjAmount > 0):
                            begin
                                TempDtldVendLedgEntry."Amount (LCY)" := AdjAmount;
                                TempDtldVendLedgEntry."Entry Type" := TempDtldVendLedgEntry."Entry Type"::"Unrealized Gain";
                                HandleVendDebitCredit(Amount, "Amount (LCY)", Correction, TempDtldVendLedgEntry."Amount (LCY)");
                                InsertTempDtldVendorLedgerEntry;
                                NewEntryNo := NewEntryNo + 1;
                                GainsAmount := AdjAmount;
                                Adjust := true;
                            end;
                        (AdjAmount < 0):
                            if -AdjAmount <= OldAdjAmount then begin
                                TempDtldVendLedgEntry."Amount (LCY)" := AdjAmount;
                                TempDtldVendLedgEntry."Entry Type" := TempDtldVendLedgEntry."Entry Type"::"Unrealized Loss";
                                HandleVendDebitCredit(
                                  Amount, "Amount (LCY)", Correction, TempDtldVendLedgEntry."Amount (LCY)");
                                InsertTempDtldVendorLedgerEntry;
                                NewEntryNo := NewEntryNo + 1;
                                LossesAmount := AdjAmount;
                                Adjust := true;
                            end else begin
                                AdjAmount := AdjAmount + OldAdjAmount;
                                TempDtldVendLedgEntry."Amount (LCY)" := -OldAdjAmount;
                                TempDtldVendLedgEntry."Entry Type" := TempDtldVendLedgEntry."Entry Type"::"Unrealized Gain";
                                HandleVendDebitCredit(
                                  Amount, "Amount (LCY)", Correction, TempDtldVendLedgEntry."Amount (LCY)");
                                InsertTempDtldVendorLedgerEntry;
                                NewEntryNo := NewEntryNo + 1;
                                AdjExchRateBufIndex :=
                                  //SSA960>>
                                  /* //OC
                                  AdjExchRateBufferUpdate(
                                    "Currency Code",Vendor."Vendor Posting Group",
                                    0,0,-OldAdjAmount,-OldAdjAmount,0,DimEntryNo,PostingDate2,Vendor."IC Partner Code");
                                  */
                                  AdjExchRateBufferUpdate(
                                    "Currency Code", "Vendor Posting Group",
                                    0, 0, -OldAdjAmount, -OldAdjAmount, 0, DimEntryNo, PostingDate2, Vendor."IC Partner Code", "Entry No.", 2, Vendor."No.");
                                //SSA960<<
                                TempDtldVendLedgEntry."Transaction No." := AdjExchRateBufIndex;
                                ModifyTempDtldVendorLedgerEntry;
                                Adjust := false;
                            end;
                    end;
                if OldAdjAmount < 0 then
                    case true of
                        (AdjAmount < 0):
                            begin
                                TempDtldVendLedgEntry."Amount (LCY)" := AdjAmount;
                                TempDtldVendLedgEntry."Entry Type" := TempDtldVendLedgEntry."Entry Type"::"Unrealized Loss";
                                HandleVendDebitCredit(Amount, "Amount (LCY)", Correction, TempDtldVendLedgEntry."Amount (LCY)");
                                InsertTempDtldVendorLedgerEntry;
                                NewEntryNo := NewEntryNo + 1;
                                LossesAmount := AdjAmount;
                                Adjust := true;
                            end;
                        (AdjAmount > 0):
                            if AdjAmount <= -OldAdjAmount then begin
                                TempDtldVendLedgEntry."Amount (LCY)" := AdjAmount;
                                TempDtldVendLedgEntry."Entry Type" := TempDtldVendLedgEntry."Entry Type"::"Unrealized Gain";
                                HandleVendDebitCredit(
                                  Amount, "Amount (LCY)", Correction, TempDtldVendLedgEntry."Amount (LCY)");
                                InsertTempDtldVendorLedgerEntry;
                                NewEntryNo := NewEntryNo + 1;
                                GainsAmount := AdjAmount;
                                Adjust := true;
                            end else begin
                                AdjAmount := OldAdjAmount + AdjAmount;
                                TempDtldVendLedgEntry."Amount (LCY)" := -OldAdjAmount;
                                TempDtldVendLedgEntry."Entry Type" := TempDtldVendLedgEntry."Entry Type"::"Unrealized Loss";
                                HandleVendDebitCredit(
                                  Amount, "Amount (LCY)", Correction, TempDtldVendLedgEntry."Amount (LCY)");
                                InsertTempDtldVendorLedgerEntry;
                                NewEntryNo := NewEntryNo + 1;
                                AdjExchRateBufIndex :=
                                  //SSA960>>
                                  /*//OC
                                  AdjExchRateBufferUpdate(
                                    "Currency Code",Vendor."Vendor Posting Group",
                                    0,0,-OldAdjAmount,0,-OldAdjAmount,DimEntryNo,PostingDate2,Vendor."IC Partner Code");
                                  */
                                  AdjExchRateBufferUpdate(
                                    "Currency Code", "Vendor Posting Group",
                                    0, 0, -OldAdjAmount, 0, -OldAdjAmount, DimEntryNo, PostingDate2, Vendor."IC Partner Code", "Entry No.", 2, Vendor."No.");
                                //SSA960<<
                                TempDtldVendLedgEntry."Transaction No." := AdjExchRateBufIndex;
                                ModifyTempDtldVendorLedgerEntry;
                                Adjust := false;
                            end;
                    end;

                if not Adjust then begin
                    TempDtldVendLedgEntry."Amount (LCY)" := AdjAmount;
                    HandleVendDebitCredit(Amount, "Amount (LCY)", Correction, TempDtldVendLedgEntry."Amount (LCY)");
                    TempDtldVendLedgEntry."Entry No." := NewEntryNo;
                    if AdjAmount < 0 then begin
                        TempDtldVendLedgEntry."Entry Type" := TempDtldVendLedgEntry."Entry Type"::"Unrealized Loss";
                        GainsAmount := 0;
                        LossesAmount := AdjAmount;
                    end else
                        if AdjAmount > 0 then begin
                            TempDtldVendLedgEntry."Entry Type" := TempDtldVendLedgEntry."Entry Type"::"Unrealized Gain";
                            GainsAmount := AdjAmount;
                            LossesAmount := 0;
                        end;
                    InsertTempDtldVendorLedgerEntry;
                    NewEntryNo := NewEntryNo + 1;
                end;

                TotalAdjAmount := TotalAdjAmount + AdjAmount;
                Window.Update(4, TotalAdjAmount);
                AdjExchRateBufIndex :=
                  //SSA960>>
                  /* //OC
                  AdjExchRateBufferUpdate(
                    "Currency Code",Vendor."Vendor Posting Group",
                    "Remaining Amount","Remaining Amt. (LCY)",
                    TempDtldVendLedgEntry."Amount (LCY)",GainsAmount,LossesAmount,DimEntryNo,PostingDate2,Vendor."IC Partner Code");
                  */
                  AdjExchRateBufferUpdate(
                    "Currency Code", "Vendor Posting Group",
                    "Remaining Amount", "Remaining Amt. (LCY)",
                    TempDtldVendLedgEntry."Amount (LCY)", GainsAmount, LossesAmount, DimEntryNo, PostingDate2, Vendor."IC Partner Code", "Entry No.", 2, Vendor."No.");
                //SSA960
                TempDtldVendLedgEntry."Transaction No." := AdjExchRateBufIndex;
                ModifyTempDtldVendorLedgerEntry;
            end;
        end;

    end;

    local procedure InitDtldCustLedgEntry(CustLedgEntry: Record "Cust. Ledger Entry"; var DtldCustLedgEntry: Record "Detailed Cust. Ledg. Entry")
    begin
        with CustLedgEntry do begin
            DtldCustLedgEntry.Init;
            DtldCustLedgEntry."Cust. Ledger Entry No." := "Entry No.";
            DtldCustLedgEntry.Amount := 0;
            DtldCustLedgEntry."Customer No." := "Customer No.";
            DtldCustLedgEntry."Currency Code" := "Currency Code";
            DtldCustLedgEntry."User ID" := UserId;
            DtldCustLedgEntry."Source Code" := SourceCodeSetup."Exchange Rate Adjmt.";
            DtldCustLedgEntry."Journal Batch Name" := "Journal Batch Name";
            DtldCustLedgEntry."Reason Code" := "Reason Code";
            DtldCustLedgEntry."Initial Entry Due Date" := "Due Date";
            DtldCustLedgEntry."Initial Entry Global Dim. 1" := "Global Dimension 1 Code";
            DtldCustLedgEntry."Initial Entry Global Dim. 2" := "Global Dimension 2 Code";
            DtldCustLedgEntry."Initial Document Type" := "Document Type";
            DtldCustLedgEntry."SSA Customer Posting Group" := "Customer Posting Group";
        end;

        OnAfterInitDtldCustLedgerEntry(DtldCustLedgEntry);
    end;

    local procedure InitDtldVendLedgEntry(VendLedgEntry: Record "Vendor Ledger Entry"; var DtldVendLedgEntry: Record "Detailed Vendor Ledg. Entry")
    begin
        with VendLedgEntry do begin
            DtldVendLedgEntry.Init;
            DtldVendLedgEntry."Vendor Ledger Entry No." := "Entry No.";
            DtldVendLedgEntry.Amount := 0;
            DtldVendLedgEntry."Vendor No." := "Vendor No.";
            DtldVendLedgEntry."Currency Code" := "Currency Code";
            DtldVendLedgEntry."User ID" := UserId;
            DtldVendLedgEntry."Source Code" := SourceCodeSetup."Exchange Rate Adjmt.";
            DtldVendLedgEntry."Journal Batch Name" := "Journal Batch Name";
            DtldVendLedgEntry."Reason Code" := "Reason Code";
            DtldVendLedgEntry."Initial Entry Due Date" := "Due Date";
            DtldVendLedgEntry."Initial Entry Global Dim. 1" := "Global Dimension 1 Code";
            DtldVendLedgEntry."Initial Entry Global Dim. 2" := "Global Dimension 2 Code";
            DtldVendLedgEntry."Initial Document Type" := "Document Type";
            DtldVendLedgEntry."SSA Vendor Posting Group" := "Vendor Posting Group";
        end;

        OnAfterInitDtldVendLedgerEntry(DtldVendLedgEntry);
    end;

    local procedure SetUnrealizedGainLossFilterCust(var DtldCustLedgEntry: Record "Detailed Cust. Ledg. Entry"; EntryNo: Integer)
    begin
        with DtldCustLedgEntry do begin
            Reset;
            SetCurrentKey("Cust. Ledger Entry No.", "Entry Type");
            SetRange("Cust. Ledger Entry No.", EntryNo);
            SetRange("Entry Type", "Entry Type"::"Unrealized Loss", "Entry Type"::"Unrealized Gain");
        end;
    end;

    local procedure SetUnrealizedGainLossFilterVend(var DtldVendLedgEntry: Record "Detailed Vendor Ledg. Entry"; EntryNo: Integer)
    begin
        with DtldVendLedgEntry do begin
            Reset;
            SetCurrentKey("Vendor Ledger Entry No.", "Entry Type");
            SetRange("Vendor Ledger Entry No.", EntryNo);
            SetRange("Entry Type", "Entry Type"::"Unrealized Loss", "Entry Type"::"Unrealized Gain");
        end;
    end;

    local procedure InsertTempDtldCustomerLedgerEntry()
    begin
        TempDtldCustLedgEntry.Insert;
        TempDtldCustLedgEntrySums := TempDtldCustLedgEntry;
        TempDtldCustLedgEntrySums.Insert;
    end;

    local procedure InsertTempDtldVendorLedgerEntry()
    begin
        TempDtldVendLedgEntry.Insert;
        TempDtldVendLedgEntrySums := TempDtldVendLedgEntry;
        TempDtldVendLedgEntrySums.Insert;
    end;

    local procedure ModifyTempDtldCustomerLedgerEntry()
    begin
        TempDtldCustLedgEntry.Modify;
        TempDtldCustLedgEntrySums := TempDtldCustLedgEntry;
        TempDtldCustLedgEntrySums.Modify;
    end;

    local procedure ModifyTempDtldVendorLedgerEntry()
    begin
        TempDtldVendLedgEntry.Modify;
        TempDtldVendLedgEntrySums := TempDtldVendLedgEntry;
        TempDtldVendLedgEntrySums.Modify;
    end;

    [IntegrationEvent(TRUE, false)]
    local procedure OnBeforeOnInitReport(var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterInitDtldCustLedgerEntry(var DetailedCustLedgEntry: Record "Detailed Cust. Ledg. Entry")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterInitDtldVendLedgerEntry(var DetailedVendorLedgEntry: Record "Detailed Vendor Ledg. Entry")
    begin
    end;

    local procedure CustLedgEntryToCVLedgEntry(_EntryNo: Integer)
    begin
        //SSA960>>
        if CustLedgerEntry.Get(_EntryNo) then begin
            CVLedgEntryBuffer."Document Type" := CustLedgerEntry."Document Type";
            CVLedgEntryBuffer."Document No." := CustLedgerEntry."Document No.";
        end;
        //SSA960<<
    end;

    local procedure VendLedgEntryToCVLedgEntry(_EntryNo: Integer)
    begin
        //SSA960>>
        if VendorLedgerEntry.Get(_EntryNo) then begin
            CVLedgEntryBuffer."Document Type" := VendorLedgerEntry."Document Type";
            CVLedgEntryBuffer."Document No." := VendorLedgerEntry."Document No.";
        end;
        //SSA960<<
    end;

    local procedure UpdateAdjDebitCredit()
    var
        TotalCastig: Decimal;
        TotalPierdere: Decimal;
    begin
        //SSA960>>

        with AdjExchRateBuffer do begin
            if AdjAmount <> 0 then begin
                /*
                if TotalGainsAmount <> 0 then begin
                    //GainsOrLossAccNo := CurrencyForAcc."Unrealized Gains Acc.";
                    GainOrLoss := Text45013657;
                    if TotalGainsAmount < 0 then begin
                        //GainsOrLossAccNo := CurrencyForAcc."Unrealized Losses Acc.";
                        GainOrLoss := Text45013658;
                    end;
                    SetAdjDebitCredit(-TotalGainsAmount, AdjCredit, AdjDebit);
                end;
                if TotalLossesAmount <> 0 then begin
                    //GainsOrLossAccNo2 := CurrencyForAcc."Unrealized Losses Acc.";
                    GainOrLoss2 := Text45013658;
                    if TotalLossesAmount > 0 then begin
                        //GainsOrLossAccNo2 := CurrencyForAcc."Unrealized Gains Acc.";
                        GainOrLoss2 := Text45013657;
                    end;
                    SetAdjDebitCredit(-TotalLossesAmount, AdjCredit2, AdjDebit2);
                end;
                */
                clear(TotalCastig);
                Clear(TotalPierdere);
                if TotalGainsAmount > 0 then
                    TotalCastig += TotalGainsAmount;
                if TotalGainsAmount < 0 then
                    TotalPierdere += TotalGainsAmount;
                if TotalLossesAmount < 0 then
                    TotalPierdere += TotalLossesAmount;
                if TotalLossesAmount > 0 then
                    TotalCastig += TotalLossesAmount;

                TotalCum := TotalCastig + TotalPierdere;
                if TotalCum <> 0 then begin
                    GainOrLossCum := Text45013657;
                    if TotalCum < 0 then begin
                        GainOrLossCum := Text45013658;
                    end;
                    SetAdjDebitCredit(-TotalCum, AdjCreditCum, AdjDebitCum);
                end;
            end;
        end;
        //SSA960<<
    end;

    local procedure SetAdjDebitCredit(TotalCreditDebitAmount: Decimal; var VarAdjCredit: Decimal; var VarAdjDebit: Decimal)
    begin
        //SSA960>>
        if TotalCreditDebitAmount > 0 then
            VarAdjDebit := TotalCreditDebitAmount
        else
            VarAdjCredit := TotalCreditDebitAmount;
        TotalDtAmtCum := TotalDtAmtCum + VarAdjDebit;
        TotalCrAmtCum := TotalCrAmtCum + VarAdjCredit;
        //SSA960<<
    end;

    local procedure InitAdjDebitCredit()
    begin
        AdjDebitCum := 0;
        AdjCreditCum := 0;
        /*
        AdjDebit2 := 0;
        AdjCredit2 := 0;
        */
    end;

    var
        Text000: Label '%1 must be entered.';
        Text001: Label 'Do you want to adjust general ledger entries for currency fluctuations without adjusting customer, vendor and bank ledger entries? This may result in incorrect currency adjustments to payables, receivables and bank accounts.\\ ';
        Text004: Label 'Do you wish to continue?';
        Text005: Label 'The adjustment of exchange rates has been canceled.';
        Text006: Label 'Adjusting exchange rates...\\';
        Text007: Label 'Bank Account    @1@@@@@@@@@@@@@\\';
        Text008: Label 'Customer        @2@@@@@@@@@@@@@\';
        Text009: Label 'Vendor          @3@@@@@@@@@@@@@\';
        Text010: Label 'Adjustment      #4#############';
        Text011: Label 'No currencies have been found.';
        Text012: Label 'Adjusting VAT Entries...\\';
        Text013: Label 'VAT Entry    @1@@@@@@@@@@@@@';
        Text014: Label 'Adjusting general ledger...\\';
        Text015: Label 'G/L Account    @1@@@@@@@@@@@@@';
        Text016: Label 'Adjmt. of %1 %2, Ex.Rate Adjust.', Comment = '%1 = Currency Code, %2= Adjust Amount';
        Text017: Label '%1 on %2 %3 must be %4. When this %2 is used in %5, the exchange rate adjustment is defined in the %6 field in the %7. %2 %3 is used in the %8 field in the %5. ';
        DtldCustLedgEntry: Record "Detailed Cust. Ledg. Entry";
        TempDtldCustLedgEntry: Record "Detailed Cust. Ledg. Entry" temporary;
        TempDtldCustLedgEntrySums: Record "Detailed Cust. Ledg. Entry" temporary;
        DtldVendLedgEntry: Record "Detailed Vendor Ledg. Entry";
        TempDtldVendLedgEntry: Record "Detailed Vendor Ledg. Entry" temporary;
        TempDtldVendLedgEntrySums: Record "Detailed Vendor Ledg. Entry" temporary;
        ExchRateAdjReg: Record "Exch. Rate Adjmt. Reg.";
        CustPostingGr: Record "Customer Posting Group";
        VendPostingGr: Record "Vendor Posting Group";
        GenJnlLine: Record "Gen. Journal Line";
        SourceCodeSetup: Record "Source Code Setup";
        AdjExchRateBuffer: Record "SSA Adjust Exch. Rate Buffer" temporary;
        AdjExchRateBuffer2: Record "SSA Adjust Exch. Rate Buffer" temporary;
        Currency2: Record Currency temporary;
        Currency3: Record Currency;
        CurrExchRate: Record "Currency Exchange Rate";
        CurrExchRate2: Record "Currency Exchange Rate";
        GLSetup: Record "General Ledger Setup";
        VATEntry: Record "VAT Entry";
        VATEntry2: Record "VAT Entry";
        VATEntryTotalBase: Record "VAT Entry";
        TaxJurisdiction: Record "Tax Jurisdiction";
        VATPostingSetup2: Record "VAT Posting Setup";
        TaxJurisdiction2: Record "Tax Jurisdiction";
        TempDimBuf: Record "Dimension Buffer" temporary;
        TempDimBuf2: Record "Dimension Buffer" temporary;
        TempDimSetEntry: Record "Dimension Set Entry" temporary;
        TempEntryNoAmountBuf: Record "Entry No. Amount Buffer" temporary;
        CustLedgerEntry: Record "Cust. Ledger Entry";
        TempCustLedgerEntry: Record "Cust. Ledger Entry" temporary;
        VendorLedgerEntry: Record "Vendor Ledger Entry";
        TempVendorLedgerEntry: Record "Vendor Ledger Entry" temporary;
        CVLedgEntryBuffer: Record "CV Ledger Entry Buffer" temporary;
        GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line";
        UpdateAnalysisView: Codeunit "Update Analysis View";
        DimMgt: Codeunit DimensionManagement;
        DimBufMgt: Codeunit "Dimension Buffer Management";
        Window: Dialog;
        TotalAdjBase: Decimal;
        TotalAdjBaseLCY: Decimal;
        TotalAdjAmount: Decimal;
        GainsAmount: Decimal;
        LossesAmount: Decimal;
        PostingDate: Date;
        PostingDescription: Text[100];
        AdjBase: Decimal;
        AdjBaseLCY: Decimal;
        AdjAmount: Decimal;
        CustNo: Decimal;
        CustNoTotal: Decimal;
        VendNo: Decimal;
        VendNoTotal: Decimal;
        BankAccNo: Decimal;
        BankAccNoTotal: Decimal;
        GLAccNo: Decimal;
        GLAccNoTotal: Decimal;
        GLAmtTotal: Decimal;
        GLAddCurrAmtTotal: Decimal;
        GLNetChangeTotal: Decimal;
        GLAddCurrNetChangeTotal: Decimal;
        GLNetChangeBase: Decimal;
        GLAddCurrNetChangeBase: Decimal;
        PostingDocNo: Code[20];
        StartDate: Date;
        EndDate: Date;
        EndDateReq: Date;
        Correction: Boolean;
        OK: Boolean;
        AdjCustVendBank: Boolean;
        AdjGLAcc: Boolean;
        AddCurrCurrencyFactor: Decimal;
        VATEntryNoTotal: Decimal;
        VATEntryNo: Decimal;
        NewEntryNo: Integer;
        Text018: Label 'This posting date cannot be entered because it does not occur within the adjustment period. Reenter the posting date.';
        FirstEntry: Boolean;
        MaxAdjExchRateBufIndex: Integer;
        RatesAdjustedMsg: Label 'One or more currency exchange rates have been adjusted.';
        NothingToAdjustMsg: Label 'There is nothing to adjust.';
        TotalBankAccountsAdjusted: Integer;
        TotalCustomersAdjusted: Integer;
        TotalVendorsAdjusted: Integer;
        TotalGLAccountsAdjusted: Integer;
        CustPostGrFilter: Text;
        VendPostGrFilter: Text;
        TestMode: Boolean;
        AdjCust: Boolean;
        AdjVend: Boolean;
        AdjBank: Boolean;
        Text45013654: Label 'Do you want to calculate and post the adjustment?';
        SummarizeEntries: Boolean;
        Text45013655: Label 'To run the report in Test Mode, set Summarize Entries to No.';
        Text45013656: Label 'Exchange Rate Adjmt. of %1 %2 %3 %4';
        Text45013657: Label 'Gain';
        Text45013658: Label 'Loss';
        GainsOrLossAccNo: Code[10];
        /*
        GainOrLoss: Text[30];
        AdjDebit: Decimal;
        AdjDebit2: Decimal;
        AdjCredit: Decimal;
        AdjCredit2: Decimal;
        GainOrLoss2: Text[30];
        TotalDtAmt: Decimal;
        TotalCrAmt: Decimal;
        */
        GainOrLossCum: Text[30];
        AdjDebitCum: Decimal;
        AdjCreditCum: Decimal;
        TotalDtAmtCum: Decimal;
        TotalCrAmtCum: Decimal;
        TotalCum: Decimal;
        //
        ReportTitle_lbl: Label 'Adjust Exchange Rates';
        PageCaption_lbl: Label 'Page';
        TestMode_lbl: Label 'Test Mode:';
        Gain_lbl: Label 'Gain';
        Loss_lbl: Label 'Loss';
        CurrencyFactor_Lbl: Label 'Factor';
        AdjBalanceAtDateLCY_lbl: Label 'Adj. Balance at Date (LCY)';
        AdjDebit_CaptionLbl: Label 'Adj. Amount - Debit';
        AdjCredit_CaptionLbl: Label 'Adj. Amount - Credit';
        GainOrLoss_CaptionLbl: Label 'Gain / Loss';
        TotalCrAmt_CaptionLbl: Label 'Total';
        Document_Type_CaptionLbl: Label 'Document Type';
        Document_No_CaptionLbl: Label 'Document No.';
        Posting_Date_CaptionLbl: Label 'Posting Date';
        Currency_Code_CaptionLbl: Label 'Currency Code';
        Original_Currency_Factor_CaptionLbl: Label 'Original Currency';
        AdjustedFactorCaptionLbl: Label 'Adjusted';
        Remaining_Amount_CaptionLbl: Label 'Remaining Amount';
        Remaining_Amt_LCY_CaptionLbl: Label 'Remaining Amt.(LCY)';
        Remaining_Amt_LCY___AdjAmountCaptionLbl: Label 'Adj. Remaining Amt.(LCY)';
        AdjustedFactor: Decimal;
}

