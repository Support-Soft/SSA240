codeunit 70501 "SSA Payment-Apply"
{
    // SSM729 SSCAT 22.06.2018 Nr.crt.76-Limita valorica pentru instrumente de plata neincasate- fin

    Permissions = TableData "Cust. Ledger Entry" = rm,
                  TableData "Vendor Ledger Entry" = rm;
    TableNo = "SSA Payment Line";

    trigger OnRun()
    var
        Header: Record "SSA Payment Header";
    begin
        Header.Get("No.");

        GenJnlLine."Account Type" := "Account Type";
        GenJnlLine."Account No." := "Account No.";
        GenJnlLine.Amount := Amount;
        GenJnlLine."Amount (LCY)" := "Amount (LCY)";
        GenJnlLine."Currency Code" := "Currency Code";
        GenJnlLine."Posting Date" := Header."Posting Date";

        with GenJnlLine do begin
            GetCurrency;
            AccType := "Account Type";
            AccNo := "Account No.";

            case AccType of
                AccType::Customer:
                    begin
                        CustLedgEntry.SetCurrentKey("Customer No.", Open, Positive);
                        CustLedgEntry.SetRange("Customer No.", AccNo);
                        CustLedgEntry.SetRange(Open, true);
                        if "Applies-to ID" = '' then
                            "Applies-to ID" := "No." + '/' + Format(Rec."Line No.");
                        ApplyCustEntries.SetGenJnlLine(GenJnlLine, GenJnlLine.FieldNo("Applies-to ID"));
                        ApplyCustEntries.SetRecord(CustLedgEntry);
                        ApplyCustEntries.SetTableView(CustLedgEntry);
                        ApplyCustEntries.LookupMode(true);
                        OK := ApplyCustEntries.RunModal = ACTION::LookupOK;
                        Clear(ApplyCustEntries);
                        if not OK then
                            exit;
                        CustLedgEntry.Reset;
                        CustLedgEntry.SetCurrentKey("Customer No.", Open, Positive);
                        CustLedgEntry.SetRange("Customer No.", AccNo);
                        CustLedgEntry.SetRange(Open, true);
                        CustLedgEntry.SetRange("Applies-to ID", "Applies-to ID");
                        if CustLedgEntry.Find('-') then begin
                            CurrencyCode2 := CustLedgEntry."Currency Code";
                            if Amount = 0 then begin
                                repeat
                                    CheckAgainstApplnCurrency(CurrencyCode2, CustLedgEntry."Currency Code", AccType::Customer, true);
                                    CustLedgEntry.CalcFields("Remaining Amount");
                                    CustLedgEntry."Remaining Amount" :=
                                      ExchAmount(
                                        CustLedgEntry."Remaining Amount",
                                        CustLedgEntry."Currency Code", "Currency Code", "Posting Date");
                                    CustLedgEntry."Remaining Amount" :=
                                      Round(CustLedgEntry."Remaining Amount", Currency."Amount Rounding Precision");
                                    CustLedgEntry."Original Pmt. Disc. Possible" :=
                                      ExchAmount(
                                        CustLedgEntry."Original Pmt. Disc. Possible",
                                        CustLedgEntry."Currency Code", "Currency Code", "Posting Date");
                                    CustLedgEntry."Original Pmt. Disc. Possible" :=
                                      Round(CustLedgEntry."Original Pmt. Disc. Possible", Currency."Amount Rounding Precision");
                                    if (CustLedgEntry."Document Type" = CustLedgEntry."Document Type"::Invoice) and
                                       ("Posting Date" <= CustLedgEntry."Pmt. Discount Date")
                                    then
                                        Amount := Amount - (CustLedgEntry."Amount to Apply" - CustLedgEntry."Original Pmt. Disc. Possible")
                                    else
                                        Amount := Amount - CustLedgEntry."Amount to Apply";
                                until CustLedgEntry.Next = 0;
                                "Amount (LCY)" := Amount;
                                "Currency Factor" := 1;
                                if ("Bal. Account Type" = "Bal. Account Type"::Customer) or
                                   ("Bal. Account Type" = "Bal. Account Type"::Vendor)
                                then begin
                                    Amount := -Amount;
                                    "Amount (LCY)" := -"Amount (LCY)";
                                end;
                                Validate(Amount);
                                Validate("Amount (LCY)");
                            end else
                                repeat
                                    CheckAgainstApplnCurrency(CurrencyCode2, CustLedgEntry."Currency Code", AccType::Customer, true);
                                until CustLedgEntry.Next = 0;
                            if "Currency Code" <> CurrencyCode2 then
                                if Amount = 0 then begin
                                    if not
                                       Confirm(
                                         Text001 +
                                         Text002, true,
                                         FieldCaption("Currency Code"), TableCaption, "Currency Code",
                                         CustLedgEntry."Currency Code")
                                    then
                                        Error(Text003);
                                    "Currency Code" := CustLedgEntry."Currency Code"
                                end else
                                    CheckAgainstApplnCurrency("Currency Code", CustLedgEntry."Currency Code", AccType::Customer, true);
                            "Applies-to Doc. Type" := 0;
                            "Applies-to Doc. No." := '';
                        end else
                            "Applies-to ID" := '';
                        "Due Date" := CustLedgEntry."Due Date";
                    end;
                AccType::Vendor:
                    begin
                        VendLedgEntry.SetCurrentKey("Vendor No.", Open, Positive);
                        VendLedgEntry.SetRange("Vendor No.", AccNo);
                        VendLedgEntry.SetRange(Open, true);
                        if "Applies-to ID" = '' then
                            "Applies-to ID" := "No." + '/' + Format(Rec."Line No.");
                        if "Applies-to ID" = '' then
                            "Applies-to ID" := "Document No.";
                        if "Applies-to ID" = '' then
                            Error(
                              Text000,
                              FieldCaption("Document No."), FieldCaption("Applies-to ID"));
                        ApplyVendEntries.SetGenJnlLine(GenJnlLine, GenJnlLine.FieldNo("Applies-to ID"));
                        ApplyVendEntries.SetRecord(VendLedgEntry);
                        ApplyVendEntries.SetTableView(VendLedgEntry);
                        ApplyVendEntries.LookupMode(true);
                        OK := ApplyVendEntries.RunModal = ACTION::LookupOK;
                        Clear(ApplyVendEntries);
                        if not OK then
                            exit;
                        VendLedgEntry.Reset;
                        VendLedgEntry.SetCurrentKey("Vendor No.", Open, Positive);
                        VendLedgEntry.SetRange("Vendor No.", AccNo);
                        VendLedgEntry.SetRange(Open, true);
                        VendLedgEntry.SetRange("Applies-to ID", "Applies-to ID");
                        if VendLedgEntry.Find('-') then begin
                            CurrencyCode2 := VendLedgEntry."Currency Code";
                            if Amount = 0 then begin
                                repeat
                                    CheckAgainstApplnCurrency(CurrencyCode2, VendLedgEntry."Currency Code", AccType::Vendor, true);
                                    VendLedgEntry.CalcFields("Remaining Amount");
                                    VendLedgEntry."Remaining Amount" :=
                                      ExchAmount(
                                        VendLedgEntry."Remaining Amount",
                                        VendLedgEntry."Currency Code", "Currency Code", "Posting Date");
                                    VendLedgEntry."Remaining Amount" :=
                                      Round(VendLedgEntry."Remaining Amount", Currency."Amount Rounding Precision");
                                    VendLedgEntry."Original Pmt. Disc. Possible" :=
                                      ExchAmount(
                                        VendLedgEntry."Original Pmt. Disc. Possible",
                                        VendLedgEntry."Currency Code", "Currency Code", "Posting Date");
                                    VendLedgEntry."Original Pmt. Disc. Possible" :=
                                      Round(VendLedgEntry."Original Pmt. Disc. Possible", Currency."Amount Rounding Precision");
                                    if (VendLedgEntry."Document Type" = VendLedgEntry."Document Type"::Invoice) and
                                       ("Posting Date" <= VendLedgEntry."Pmt. Discount Date")
                                    then
                                        Amount := Amount - (VendLedgEntry."Amount to Apply" - VendLedgEntry."Original Pmt. Disc. Possible")
                                    else
                                        Amount := Amount - VendLedgEntry."Amount to Apply";
                                until VendLedgEntry.Next = 0;
                                "Amount (LCY)" := Amount;
                                "Currency Factor" := 1;
                                if ("Bal. Account Type" = "Bal. Account Type"::Customer) or
                                   ("Bal. Account Type" = "Bal. Account Type"::Vendor)
                                then begin
                                    Amount := -Amount;
                                    "Amount (LCY)" := -"Amount (LCY)";
                                end;
                                Validate(Amount);
                                Validate("Amount (LCY)");
                            end else
                                repeat
                                    CheckAgainstApplnCurrency(CurrencyCode2, VendLedgEntry."Currency Code", AccType::Vendor, true);
                                until VendLedgEntry.Next = 0;
                            if "Currency Code" <> CurrencyCode2 then
                                if Amount = 0 then begin
                                    if not
                                       Confirm(
                                         Text001 +
                                         Text002, true,
                                         FieldCaption("Currency Code"), TableCaption, "Currency Code",
                                         VendLedgEntry."Currency Code")
                                    then
                                        Error(Text003);
                                    "Currency Code" := VendLedgEntry."Currency Code"
                                end else
                                    CheckAgainstApplnCurrency("Currency Code", VendLedgEntry."Currency Code", AccType::Vendor, true);
                            "Applies-to Doc. Type" := 0;
                            "Applies-to Doc. No." := '';
                        end else
                            "Applies-to ID" := '';
                        "Due Date" := VendLedgEntry."Due Date";
                    end;
                else
                    Error(
                      Text005,
                      FieldCaption("Account Type"), FieldCaption("Bal. Account Type"));
            end;
        end;
        "Applies-to Doc. Type" := GenJnlLine."Applies-to Doc. Type";
        "Applies-to Doc. No." := GenJnlLine."Applies-to Doc. No.";
        "Applies-to ID" := GenJnlLine."Applies-to ID";
        "Due Date" := GenJnlLine."Due Date";
        Amount := GenJnlLine.Amount;
        "Amount (LCY)" := GenJnlLine."Amount (LCY)";
        Validate(Amount);
        Validate("Amount (LCY)");
    end;

    var
        Text000: Label 'You must specify %1 or %2.';
        Text001: Label 'The %1 in the %2 will be changed from %3 to %4.\';
        Text002: Label 'Do you wish to continue?';
        Text003: Label 'The update has been interrupted to respect the warning.';
        Text005: Label 'The %1 or %2 must be Customer or Vendor.';
        Text006: Label 'All entries in one application must be in the same currency.';
        Text007: Label 'All entries in one application must be in the same currency or one or more of the EMU currencies. ';
        GenJnlLine: Record "Gen. Journal Line";
        CustLedgEntry: Record "Cust. Ledger Entry";
        VendLedgEntry: Record "Vendor Ledger Entry";
        GLSetup: Record "General Ledger Setup";
        Currency: Record Currency;
        ApplyCustEntries: Page "Apply Customer Entries";
        ApplyVendEntries: Page "Apply Vendor Entries";
        AccNo: Code[20];
        CurrencyCode2: Code[10];
        OK: Boolean;
        AccType: Option "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset";

    procedure CheckAgainstApplnCurrency(ApplnCurrencyCode: Code[10]; CompareCurrencyCode: Code[10]; AccType: Option "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset"; Message: Boolean): Boolean
    var
        Currency: Record Currency;
        Currency2: Record Currency;
        SalesSetup: Record "Sales & Receivables Setup";
        PurchSetup: Record "Purchases & Payables Setup";
        CurrencyAppln: Option No,EMU,All;
    begin
        if (ApplnCurrencyCode = CompareCurrencyCode) then
            exit(true);

        case AccType of
            AccType::Customer:
                begin
                    SalesSetup.Get;
                    CurrencyAppln := SalesSetup."Appln. between Currencies";
                    case CurrencyAppln of
                        CurrencyAppln::No:
                            begin
                                if ApplnCurrencyCode <> CompareCurrencyCode then
                                    if Message then
                                        Error(Text006)
                                    else
                                        exit(false);
                            end;
                        CurrencyAppln::EMU:
                            begin
                                GLSetup.Get;
                                if not Currency.Get(ApplnCurrencyCode) then
                                    Currency."EMU Currency" := GLSetup."EMU Currency";
                                if not Currency2.Get(CompareCurrencyCode) then
                                    Currency2."EMU Currency" := GLSetup."EMU Currency";
                                if not Currency."EMU Currency" or not Currency2."EMU Currency" then
                                    if Message then
                                        Error(Text007)
                                    else
                                        exit(false);
                            end;
                    end;
                end;
            AccType::Vendor:
                begin
                    PurchSetup.Get;
                    CurrencyAppln := PurchSetup."Appln. between Currencies";
                    case CurrencyAppln of
                        CurrencyAppln::No:
                            begin
                                if ApplnCurrencyCode <> CompareCurrencyCode then
                                    if Message then
                                        Error(Text006)
                                    else
                                        exit(false);
                            end;
                        CurrencyAppln::EMU:
                            begin
                                GLSetup.Get;
                                if not Currency.Get(ApplnCurrencyCode) then
                                    Currency."EMU Currency" := GLSetup."EMU Currency";
                                if not Currency2.Get(CompareCurrencyCode) then
                                    Currency2."EMU Currency" := GLSetup."EMU Currency";
                                if not Currency."EMU Currency" or not Currency2."EMU Currency" then
                                    if Message then
                                        Error(Text007)
                                    else
                                        exit(false);
                            end;
                    end;
                end;
        end;

        exit(true);
    end;

    procedure GetCurrency()
    begin
        with GenJnlLine do begin
            if "Currency Code" = '' then
                Currency.InitRoundingPrecision
            else begin
                Currency.Get("Currency Code");
                Currency.TestField("Amount Rounding Precision");
            end;
        end;
    end;

    procedure DeleteApply(Rec: Record "SSA Payment Line")
    begin
        //SSM729>>
        if Rec."Applies-to ID" = '' then
            exit;
        //SSM729<<

        case Rec."Account Type" of
            Rec."Account Type"::Customer:
                begin
                    //SSM729>>
                    /*//OC
                    CustLedgEntry.INIT;
                    CustLedgEntry.SETCURRENTKEY("Applies-to ID");
                    CustLedgEntry.SETRANGE("Applies-to ID", Rec."Applies-to ID");
                    CustLedgEntry.MODIFYALL("Applies-to ID", '');
                    CustLedgEntry.SETFILTER("Applies-to ID",Rec."Applies-to ID" + '/' + FORMAT(Rec."Line No."));
                    CustLedgEntry.MODIFYALL("Applies-to ID",'');
                    */
                    CustLedgEntry.Reset;
                    CustLedgEntry.SetCurrentKey("Customer No.", "Applies-to ID", Open, Positive, "Due Date");
                    CustLedgEntry.SetRange("Customer No.", Rec."Account No.");
                    CustLedgEntry.SetFilter("Applies-to ID", '@*%1*', Rec."Applies-to ID");
                    CustLedgEntry.ModifyAll("Applies-to ID", '');
                    //SSM729<<
                end;
            Rec."Account Type"::Vendor:
                begin
                    //SSM729>>
                    /*//OC
                    VendLedgEntry.INIT;
                    VendLedgEntry.SETCURRENTKEY("Applies-to ID");
                    VendLedgEntry.SETRANGE("Applies-to ID", Rec."Applies-to ID");
                    VendLedgEntry.MODIFYALL("Applies-to ID", '');
                    VendLedgEntry.SETFILTER("Applies-to ID",Rec."Applies-to ID" + '/' + FORMAT(Rec."Line No."));
                    VendLedgEntry.MODIFYALL("Applies-to ID",'');
                    */
                    VendLedgEntry.Reset;
                    VendLedgEntry.SetCurrentKey("Vendor No.", "Applies-to ID", Open, Positive, "Due Date");
                    VendLedgEntry.SetRange("Vendor No.", Rec."Account No.");
                    VendLedgEntry.SetFilter("Applies-to ID", '@*%1*', Rec."Applies-to ID");
                    VendLedgEntry.ModifyAll("Applies-to ID", '');
                    //SSM729<<
                end;
        end;

    end;

    procedure ExchAmount(Amount: Decimal; FromCurrencyCode: Code[10]; ToCurrencyCode: Code[10]; UsePostingDate: Date): Decimal
    var
        ToCurrency: Record Currency;
        CurrExchRate: Record "Currency Exchange Rate";
    begin
        if (FromCurrencyCode = ToCurrencyCode) or (Amount = 0) then
            exit(Amount);

        Amount :=
          CurrExchRate.ExchangeAmtFCYToFCY(
            UsePostingDate, FromCurrencyCode, ToCurrencyCode, Amount);

        if ToCurrencyCode <> '' then begin
            ToCurrency.Get(ToCurrencyCode);
            Amount := Round(Amount, ToCurrency."Amount Rounding Precision");
        end else
            Amount := Round(Amount);

        exit(Amount);
    end;
}

