report 71702 "SSA Get VAT Entries D394"
{
    // SSA973 SSCAT 06.09.2019 39.Rapoarte legale- Localizare Declaratia 394
    // SSA947 SSCAT 10.01.2019 13.Funct. “TVA la incasare”

    ProcessingOnly = true;
    ApplicationArea = All;

    dataset
    {
        dataitem("VAT Entry"; "VAT Entry")
        {
            DataItemTableView = sorting("Entry No.") order(ascending);
            RequestFilterFields = "Posting Date", "Document Date";

            trigger OnAfterGetRecord()
            var
                Customer: Record Customer;
                Vendor: Record Vendor;
            begin
                RecNo += 1;

                DomesticDeclarationLine.SetRange("Source VAT Entry No.", "Entry No.");
                if DomesticDeclarationLine.FindFirst then
                    CurrReport.Skip;

                if "Posting Date" < DomesticDeclaration."Starting Date" then
                    CurrReport.Skip;
                if ("Posting Date" > DomesticDeclaration."Ending Date") and
                   (("Document Date" < DomesticDeclaration."Starting Date") or ("Document Date" > DomesticDeclaration."Ending Date"))
                then
                    CurrReport.Skip;

                if ("Posting Date" > DomesticDeclaration."Ending Date") and
                    ("Document Date" >= DomesticDeclaration."Starting Date") and
                    ("Document Date" <= DomesticDeclaration."Ending Date") and
                    ("Unrealized VAT Entry No." <> 0)
                then
                    CurrReport.skip;

                VATPostingSetup.Get("VAT Bus. Posting Group", "VAT Prod. Posting Group");
                //IF ("Country/Region Code" = 'RO') OR (("Country/Region Code" = '') AND ("Bill-to/Pay-to No." = ''))
                if (IsValidCountryForDeclaration("Country/Region Code")) or (("Country/Region Code" = '') and ("Bill-to/Pay-to No." = ''))
                then begin
                    LineNo := LineNo + 10000;
                    DomesticDeclarationLine.Init;
                    DomesticDeclarationLine."Domestic Declaration Code" := CurrentDeclarationNo;
                    DomesticDeclarationLine."Line No." := LineNo;
                    DomesticDeclarationLine."Source VAT Entry No." := "Entry No.";
                    DomesticDeclarationLine."Posting Date" := "Posting Date";
                    DomesticDeclarationLine."Document Date" := "Document Date";
                    DomesticDeclarationLine."Document No." := "Document No.";
                    if "Document Type" = "Document Type"::Invoice then
                        DomesticDeclarationLine."Document Type" := DomesticDeclarationLine."Document Type"::Invoice;
                    if "Document Type" = "Document Type"::"Credit Memo" then
                        DomesticDeclarationLine."Document Type" := DomesticDeclarationLine."Document Type"::"Credit Memo";
                    if Type = Type::Sale then
                        DomesticDeclarationLine.Type := DomesticDeclarationLine.Type::Sale;
                    if Type = Type::Purchase then
                        DomesticDeclarationLine.Type := DomesticDeclarationLine.Type::Purchase;
                    DomesticDeclarationLine.Base := Base;
                    DomesticDeclarationLine.Amount := Amount;

                    if ((SSASetup."Vendor Neex. VAT Posting Group" = "VAT Bus. Posting Group") or
                       (SSASetup."Cust. Neex. VAT Posting Group" = "VAT Bus. Posting Group")) and
                       ("Unrealized VAT Entry No." = 0)
                    then begin
                        DomesticDeclarationLine.Base := "Unrealized Base";
                        DomesticDeclarationLine.Amount := "Unrealized Amount";
                    end;

                    DomesticDeclarationLine."VAT Calculation Type" := "VAT Calculation Type";
                    DomesticDeclarationLine."Bill-to/Pay-to No." := "Bill-to/Pay-to No.";
                    DomesticDeclarationLine."Source Code" := "Source Code";
                    DomesticDeclarationLine."Transaction No." := "Transaction No.";
                    DomesticDeclarationLine."External Document No." := "External Document No.";
                    DomesticDeclarationLine."VAT Bus. Posting Group" := "VAT Bus. Posting Group";
                    DomesticDeclarationLine."VAT Prod. Posting Group" := "VAT Prod. Posting Group";
                    DomesticDeclarationLine."VAT Registration No." := DelChr(UpperCase("VAT Registration No."), '=',
                    CompanyInfo."Country/Region Code");
                    DomesticDeclarationLine."Vendor/Customer Name" := "SSA Vendor/Customer Name";
                    if "SSA Vendor/Customer Name" = '' then
                        if "VAT Entry".Type = "VAT Entry".Type::Sale then begin
                            if Customer.Get("VAT Entry"."Bill-to/Pay-to No.") then begin
                                DomesticDeclarationLine."Vendor/Customer Name" := Customer.Name;
                                DomesticDeclarationLine."Organization type" := Customer."SSA Organization type";
                                DomesticDeclarationLine."Tip Partener" := Customer."SSA Tip Partener";
                                DomesticDeclarationLine."Cod Judet D394" := Customer."SSA Cod Judet D394";
                                DomesticDeclarationLine."Persoana Afiliata" := Customer."SSA Persoana Afiliata";
                            end;
                        end else
                            if Vendor.Get("VAT Entry"."Bill-to/Pay-to No.") then begin
                                DomesticDeclarationLine."Vendor/Customer Name" := Vendor.Name;
                                DomesticDeclarationLine."Organization type" := Vendor."SSA Organization type";
                                DomesticDeclarationLine."VAT to pay" := Vendor."SSA VAT to Pay";
                                DomesticDeclarationLine."VAT to pay" := VATPostingSetup."SSA VAT to pay";
                                DomesticDeclarationLine."Tip Partener" := Vendor."SSA Tip Partener";
                                DomesticDeclarationLine."Cod Judet D394" := Vendor."SSA Cod Judet D394";
                                DomesticDeclarationLine."Persoana Afiliata" := Vendor."SSA Persoana Afiliata";
                            end;

                    DomesticDeclarationLine."Tip Operatie" := VATPostingSetup."SSA Tip Operatie";
                    DomesticDeclarationLine.Cota := VATPostingSetup."SSA Journals VAT %";
                    DomesticDeclarationLine."Tip Document D394" := "SSA Tip Document D394";
                    DomesticDeclarationLine."Tax Group Code" := "Tax Group Code";
                    DomesticDeclarationLine."Cod Serie Factura" := "No. Series";
                    DomesticDeclarationLine."Stare Factura" := "SSA Stare Factura";
                    DomesticDeclarationLine."Cod tara D394" := "Country/Region Code";
                    DomesticDeclarationLine."Unrealized VAT Entry No." := "Unrealized VAT Entry No.";
                    DomesticDeclarationLine."Not Declaration 394" := "SSA Not Declaration 394";
                    DomesticDeclarationLine.Insert;
                    //    IF Type = Type::Sale THEN
                    //      InsertNoSeriesBuffer("No. Series");
                end;

                w.Update(1, Round(RecNo / TotalRecNo * 10000, 1));
            end;

            trigger OnPostDataItem()
            begin
                TransferTemp;
            end;

            trigger OnPreDataItem()
            begin

                DomesticDeclaration.Get(CurrentDeclarationNo);
                DomesticDeclaration.TestField("Starting Date");
                DomesticDeclaration.TestField("Ending Date");
                DomesticDeclarationLine.SetRange("Domestic Declaration Code", CurrentDeclarationNo);
                DomesticDeclarationLine.SetFilter("Cod CAEN", '%1', '');
                DomesticDeclarationLine.DeleteAll;
                DomesticDeclarationLine.Reset;

                SetFilter("Posting Date", '>=%1', DomesticDeclaration."Starting Date");
                SetFilter("VAT Calculation Type", '%1|%2|%3', "VAT Calculation Type"::"Normal VAT", "VAT Calculation Type"::"Full VAT",
                "VAT Calculation Type"::"Reverse Charge VAT");

                SetFilter("Document Type", '%1|%2|%3|%4', "Document Type"::Invoice, "Document Type"::"Credit Memo", "Document Type"::" ",
                  "Document Type"::Payment);
                SetRange("SSA Not Declaration 394", false);

                SetFilter(Type, '%1|%2', Type::Sale, Type::Purchase);
                TotalRecNo := Count;
            end;
        }
    }

    requestpage
    {
        layout
        {
            area(content)
            {
                group(Control2)
                {
                    ShowCaption = false;
                    field(ChangePOSCustomer; ChangePOSCustomer)
                    {
                        Caption = 'Change POS Transactions';
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the Change POS Transactions field.';
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

    trigger OnInitReport()
    begin
        CompanyInfo.Get;

        SSASetup.Get;
        SSASetup.TestField("Vendor Neex. VAT Posting Group");
        SSASetup.TestField("Cust. Neex. VAT Posting Group");
    end;

    trigger OnPostReport()
    begin
        w.Close;
    end;

    trigger OnPreReport()
    begin
        SerieBuffer.DeleteAll;
        TempDecLine.DeleteAll;
        w.Open(Text002);
        w.Update(1, 0);
    end;

    var
        SSASetup: Record "SSA Localization Setup";
        TempDecLine: Record "SSA Domestic Declaration Line" temporary;
        SerieBuffer: Record "SSA D394 Buffer" temporary;
        CompanyInfo: Record "Company Information";
        DomesticDeclaration: Record "SSA Domestic Declaration";
        DomesticDeclarationLine: Record "SSA Domestic Declaration Line";
        VATPostingSetup: Record "VAT Posting Setup";
        CurrentDeclarationNo: Code[10];
        LineNo: Integer;
        w: Dialog;
        Text002: Label 'Getting Lines... @1@@@@@@@@';
        RecNo: Integer;
        TotalRecNo: Integer;
        ChangePOSCustomer: Boolean;

    procedure SetCurrDeclarationNo(DeclarationNo: Code[10])
    begin
        CurrentDeclarationNo := DeclarationNo;
    end;

    local
    procedure InsertNoSeriesBuffer(_NoSeries: Code[10])
    var
        DomesticDeclarations: Record "SSA Domestic Declaration";
        VATEntry: Record "VAT Entry";
        NoSeries: Record "No. Series";
        NoSeriesLine: Record "No. Series Line";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        StartDate: Date;
        EndDate: Date;
        StartDocNo: Code[20];
        EndDocNo: Code[20];
        DocNo: Code[20];
        LineNo: Integer;
    begin

        if SerieBuffer.Get(0, 0, '', _NoSeries) then
            exit;

        SerieBuffer.Pk1 := 0;
        SerieBuffer.Pk2 := 0;
        SerieBuffer.Pk3 := '';
        SerieBuffer.PK4 := _NoSeries;
        SerieBuffer.Insert;

        DomesticDeclarations.Get(CurrentDeclarationNo);
        StartDate := DomesticDeclaration."Starting Date";
        EndDate := CalcDate('<1D>', DomesticDeclaration."Ending Date");

        if not NoSeries.Get(_NoSeries) then
            exit;

        NoSeriesMgt.SetNoSeriesLineFilter(NoSeriesLine, _NoSeries, StartDate);
        NoSeriesLine.FindFirst;
        VATEntry.Reset;
        VATEntry.SetCurrentKey("Document No.", "Posting Date");
        VATEntry.SetRange("Posting Date", StartDate, EndDate);
        VATEntry.SetRange(Type, VATEntry.Type::Sale);
        VATEntry.SetRange("No. Series", _NoSeries);
        VATEntry.SetRange("Document No.", NoSeriesLine."Starting No.", NoSeriesLine."Last No. Used");
        if VATEntry.FindFirst then
            StartDocNo := VATEntry."Document No.";

        if VATEntry.FindLast then
            EndDocNo := VATEntry."Document No.";

        if (StartDocNo = '') or (EndDocNo = '') then
            exit;

        TempDecLine.Reset;
        TempDecLine.SetRange("Domestic Declaration Code", CurrentDeclarationNo);
        if TempDecLine.FindLast then
            LineNo := TempDecLine."Line No."
        else
            LineNo := 0;

        VATEntry.Reset;
        VATEntry.SetCurrentKey("Document No.", "Posting Date");

        DocNo := StartDocNo;
        while DocNo <> EndDocNo do begin
            VATEntry.SetRange("Document No.", DocNo);
            if VATEntry.IsEmpty then begin
                LineNo += 10000;
                TempDecLine.Init;
                TempDecLine."Domestic Declaration Code" := CurrentDeclarationNo;
                TempDecLine."Line No." := LineNo;
                TempDecLine.Insert;
                TempDecLine."Document No." := DocNo;
                TempDecLine."Document Type" := TempDecLine."Document Type"::Invoice;
                //TempDecLine."Vendor/Customer Name" := 'TEST';//test
                TempDecLine."Tip Document D394" := TempDecLine."Tip Document D394"::"Factura Fiscala";
                TempDecLine."Stare Factura" := TempDecLine."Stare Factura"::"2-Factura Anulata";
                TempDecLine."Cod Serie Factura" := _NoSeries;
                TempDecLine."Tip Operatie" := TempDecLine."Tip Operatie"::L;
                TempDecLine."Posting Date" := DomesticDeclaration."Ending Date";
                TempDecLine.Modify;
            end;

            DocNo := IncStr(DocNo);
        end;
    end;

    local
    procedure TransferTemp()
    var
        LineNo: Integer;
    begin
        DomesticDeclarationLine.Reset;
        DomesticDeclarationLine.SetRange("Domestic Declaration Code", CurrentDeclarationNo);
        if DomesticDeclarationLine.FindLast then
            LineNo := DomesticDeclarationLine."Line No."
        else
            LineNo := 0;

        TempDecLine.Reset;
        if TempDecLine.FindSet then
            repeat
                LineNo += 10000;
                DomesticDeclarationLine.Init;
                DomesticDeclarationLine.TransferFields(TempDecLine);
                DomesticDeclarationLine."Line No." := LineNo;
                DomesticDeclarationLine.Insert(true);
            until TempDecLine.Next = 0;
    end;

    local
    procedure IsValidCountryForDeclaration(_CountryRegionCode: Code[10]): Boolean
    var
        CountryRegion: Record "Country/Region";
    begin
        if _CountryRegionCode = 'RO' then
            exit(true);

        if CountryRegion.Get(_CountryRegionCode) then begin
            if CountryRegion."EU Country/Region Code" = '' then
                exit(true)
            else
                exit(VATPostingSetup."SSA Nu Apare in 390");
        end else
            exit(true);
    end;
}
