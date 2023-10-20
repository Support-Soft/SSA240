report 71500 "SSA Suggest VIES Lines"
{
    // SSA974 SSCAT 11.10.2019 40.Rapoarte legale-Declaratia 390

    Caption = 'Suggest SSA VIES Lines';
    ProcessingOnly = true;

    dataset
    {
        dataitem("SSA VIES Header"; "SSA VIES Header")
        {
            DataItemTableView = SORTING("No.");
            PrintOnlyIfDetail = true;
            dataitem(VATEntrySale; "VAT Entry")
            {
                DataItemTableView = SORTING(Type, "Country/Region Code", "VAT Registration No.", "VAT Bus. Posting Group", "VAT Prod. Posting Group", "Posting Date") WHERE(Type = CONST(Sale));

                trigger OnAfterGetRecord()
                begin
                    UpdateProgressBar;
                    AddVIESLine(VATEntrySale);
                end;

                trigger OnPreDataItem()
                begin
                    if "SSA VIES Header"."Trade Type" = "SSA VIES Header"."Trade Type"::Purchases then
                        CurrReport.Break;

                    SetFilters(VATEntrySale);

                    RecordNo := 0;
                    NoOfRecords := Count;
                    OldTime := Time;
                end;
            }
            dataitem(VATEntryPurchase; "VAT Entry")
            {
                DataItemTableView = SORTING(Type, "Country/Region Code", "VAT Registration No.", "VAT Bus. Posting Group", "VAT Prod. Posting Group", "Posting Date") WHERE(Type = CONST(Purchase));

                trigger OnAfterGetRecord()
                begin
                    UpdateProgressBar;
                    AddVIESLine(VATEntryPurchase);
                end;

                trigger OnPreDataItem()
                begin
                    if "SSA VIES Header"."Trade Type" = "SSA VIES Header"."Trade Type"::Sales then
                        CurrReport.Break;

                    SetFilters(VATEntryPurchase);

                    RecordNo := 0;
                    NoOfRecords := Count;
                    OldTime := Time;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                Window.Update(1, "Period No.");
                Window.Update(2, Year);
            end;

            trigger OnPostDataItem()
            begin
                SaveBuffer;
                Window.Close;
            end;

            trigger OnPreDataItem()
            begin
                if GetRangeMin("No.") <> GetRangeMax("No.") then
                    Error(Text006);

                LastLineNo := 0;

                TempVIESLine.DeleteAll;
                TempVIESLine.Reset;
                TransBuffer.DeleteAll;

                if DeleteLines then begin
                    VIESLine.Reset;
                    VIESLine.SetRange("VIES Declaration No.", GetRangeMin("No."));
                    if VIESLine.FindFirst then begin
                        VIESLine.DeleteAll;
                        Commit;
                    end;
                end;

                Window.Open(Text001 + Text002 + Text004);
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
                    field(DeleteLines; DeleteLines)
                    {
                        Caption = 'Delete Existing Lines';
                    }
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    var
        Text001: Label 'Quarter/Month #1##';
        Text004: Label 'Suggesting lines @3@@@@@@@@@@@@@';
        VIESLine: Record "SSA VIES Line";
        TempVIESLine: Record "SSA VIES Line" temporary;
        TransBuffer: Record "Integer" temporary;
        Window: Dialog;
        NoOfRecords: Integer;
        RecordNo: Integer;
        NewProgress: Integer;
        OldProgress: Integer;
        NewTime: Time;
        OldTime: Time;
        Text002: Label 'Year #2####';
        LastLineNo: Integer;
        DeleteLines: Boolean;
        Text006: Label 'You can process one declaration only.';
        Cust: Record Customer;
        Vend: Record Vendor;

    local
    procedure AddBuffer(TransactionNo: Integer)
    begin
        TempVIESLine.SetCurrentKey("Trade Type");
        TempVIESLine.SetRange("Trade Type", VIESLine."Trade Type");
        TempVIESLine.SetRange("Country/Region Code", VIESLine."Country/Region Code");
        TempVIESLine.SetRange("VAT Registration No.", VIESLine."VAT Registration No.");
        TempVIESLine.SetRange("Commerce Trade No.", VIESLine."Commerce Trade No.");
        TempVIESLine.SetRange("Trade Role Type", VIESLine."Trade Role Type");
        TempVIESLine.SetRange("EU 3-Party Trade", VIESLine."EU 3-Party Trade");
        TempVIESLine.SetRange("EU 3-Party Intermediate Role", VIESLine."EU 3-Party Intermediate Role");
        TempVIESLine.SetRange("EU Service", VIESLine."EU Service");
        TempVIESLine.SetRange("Tax Group Code", VIESLine."Tax Group Code");
        if TempVIESLine.FindFirst then begin
            TempVIESLine."Amount (LCY)" += VIESLine."Amount (LCY)";
            UpdateNumberOfSupplies(TempVIESLine, TransactionNo);
            TempVIESLine.Modify;
        end else begin
            LastLineNo += 10000;
            TempVIESLine := VIESLine;
            TempVIESLine."Line No." := LastLineNo;
            UpdateNumberOfSupplies(TempVIESLine, TransactionNo);
            TempVIESLine.Insert;
        end;
    end;

    local
    procedure SaveBuffer()
    begin
        TempVIESLine.Reset;
        VIESLine.SetRange("VIES Declaration No.", "SSA VIES Header"."No.");
        if VIESLine.FindLast then;
        LastLineNo := VIESLine."Line No.";

        if TempVIESLine.FindSet then
            repeat
                LastLineNo += 10000;
                VIESLine := TempVIESLine;
                VIESLine."Amount (LCY)" := Round(TempVIESLine."Amount (LCY)", 1, '>');
                VIESLine."Line No." := LastLineNo;
                VIESLine.Insert;
            until TempVIESLine.Next = 0;
    end;

    local
    procedure GetCountryCode(VATEntry: Record "VAT Entry") CountryCode: Code[10]
    var
        Customer: Record Customer;
        CustLedgerEntry: Record "Cust. Ledger Entry";
        Vendor: Record Vendor;
        VendLedgerEntry: Record "Vendor Ledger Entry";
    begin
        CountryCode := VATEntry."Country/Region Code";

        CustLedgerEntry.Reset;
        CustLedgerEntry.SetCurrentKey("Transaction No.");
        CustLedgerEntry.SetRange("Transaction No.", VATEntry."Transaction No.");
        if CustLedgerEntry.FindFirst then begin
            Customer.Get(CustLedgerEntry."Customer No.");
            CountryCode := Customer."Country/Region Code";
            exit;
        end;

        VendLedgerEntry.Reset;
        VendLedgerEntry.SetCurrentKey("Transaction No.");
        VendLedgerEntry.SetRange("Transaction No.", VATEntry."Transaction No.");
        if VendLedgerEntry.FindFirst then begin
            Vendor.Get(VendLedgerEntry."Vendor No.");
            CountryCode := Vendor."Country/Region Code";
            exit;
        end;
    end;

    local
    procedure GetTradeRoleType(EU3PartyTrade: Boolean): Integer
    begin
        if EU3PartyTrade then
            exit(VIESLine."Trade Role Type"::"Intermediate Trade")
        else
            exit(VIESLine."Trade Role Type"::"Direct Trade");
    end;

    local
    procedure UpdateNumberOfSupplies(var VIESLine: Record "SSA VIES Line"; TransactionNo: Integer)
    begin
        if not TransBuffer.Get(TransactionNo) then begin
            VIESLine."Number of Supplies" := VIESLine."Number of Supplies" + 1;
            TransBuffer.Number := TransactionNo;
            TransBuffer.Insert;
        end;
    end;

    local
    procedure IsEUCountry(VATEntry: Record "VAT Entry"): Boolean
    var
        Country: Record "Country/Region";
    begin
        if VATEntry."Country/Region Code" <> '' then begin
            Country.Get(VATEntry."Country/Region Code");
            exit(Country."EU Country/Region Code" <> '');
        end;
        exit(false);
    end;

    local
    procedure AddVIESLine(VATEntry: Record "VAT Entry")
    var
        VATPostingSetup: Record "VAT Posting Setup";
    begin
        if not IsEUCountry(VATEntry) then
            exit;

        VATPostingSetup.Get(VATEntry."VAT Bus. Posting Group", VATEntry."VAT Prod. Posting Group");
        if ((VATEntry.Type = VATEntry.Type::Sale) and VATPostingSetup."SSA VIES Sales" or
           (VATEntry.Type = VATEntry.Type::Purchase) and VATPostingSetup."SSA VIES Purchases")
        then begin
            VIESLine.Init;
            VIESLine."VIES Declaration No." := "SSA VIES Header"."No.";
            case VATEntry.Type of
                VATEntry.Type::Sale:
                    begin
                        VIESLine."Trade Type" := VIESLine."Trade Type"::Sale;
                        if Cust.Get(VATEntry."Bill-to/Pay-to No.") then begin
                            VIESLine."Cust/Vend Name" := Cust.Name;
                            VIESLine."Commerce Trade No." := Cust."SSA Commerce Trade No.";
                        end;
                    end;
                VATEntry.Type::Purchase:
                    begin
                        VIESLine."Trade Type" := VIESLine."Trade Type"::Purchase;
                        if Vend.Get(VATEntry."Bill-to/Pay-to No.") then begin
                            VIESLine."Cust/Vend Name" := Vend.Name;
                            VIESLine."Commerce Trade No." := Vend."SSA Commerce Trade No.";
                        end;
                    end;
            end;
            VIESLine."Country/Region Code" := GetCountryCode(VATEntry);
            VIESLine."VAT Registration No." := VATEntry."VAT Registration No.";

            VIESLine."Amount (LCY)" := -VATEntry.Base;
            VIESLine."EU 3-Party Trade" := VATEntry."EU 3-Party Trade";
            //"EU 3-Party Intermediate Role" := VATEntry."EU 3-Party Intermediate Role";
            VIESLine."Trade Role Type" := GetTradeRoleType(VATEntry."EU 3-Party Trade");
            VIESLine."EU Service" := VATEntry."EU Service";
            VIESLine."System-Created" := true;
            VIESLine."Tax Group Code" := VATEntry."Tax Group Code";
            AddBuffer(VATEntry."Transaction No.");
        end;
    end;

    local
    procedure UpdateProgressBar()
    begin
        RecordNo := RecordNo + 1;
        NewTime := Time;
        if (NewTime - OldTime > 100) or (NewTime < OldTime) then begin
            NewProgress := Round(RecordNo / NoOfRecords * 100, 1);
            if NewProgress <> OldProgress then begin
                OldProgress := NewProgress;
                Window.Update(3, NewProgress)
            end;
            OldTime := Time;
        end;
    end;

    local
    procedure SetFilters(var VATEntry: Record "VAT Entry")
    begin
        case "SSA VIES Header"."EU Goods/Services" of
            "SSA VIES Header"."EU Goods/Services"::Goods:
                VATEntry.SetRange("EU Service", false);
            "SSA VIES Header"."EU Goods/Services"::Services:
                VATEntry.SetRange("EU Service", true);
        end;
        VATEntry.SetRange("Posting Date", "SSA VIES Header"."Start Date", "SSA VIES Header"."End Date");
    end;
}

