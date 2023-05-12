codeunit 70028 "SSA D394 Subscribers"
{
    // SSA973 SSCAT 06.09.2019 39.Rapoarte legale- Localizare Declaratia 394


    trigger OnRun()
    begin
    end;

    var
        Text001: Label 'Cancelled documents should have the same amount.';

    [EventSubscriber(ObjectType::Table, 36, 'OnBeforeInitRecord', '', false, false)]
    local procedure T36OnBeforeInitRecord(var SalesHeader: Record "Sales Header"; var IsHandled: Boolean)
    begin
        with SalesHeader do begin
            if "SSA Tip Document D394" = "SSA Tip Document D394"::" " then
                if "Document Type" in ["Document Type"::Order, "Document Type"::Invoice, "Document Type"::"Credit Memo",
                  "Document Type"::"Return Order"]
                then
                    "SSA Tip Document D394" := "SSA Tip Document D394"::"Factura Fiscala";

            if "SSA Stare Factura" = "SSA Stare Factura"::" " then begin
                if "Document Type" in ["Document Type"::Order, "Document Type"::Invoice] then
                    "SSA Stare Factura" := "SSA Stare Factura"::"0-Factura Emisa";

                if "Document Type" in ["Document Type"::"Credit Memo", "Document Type"::"Return Order"] then
                    "SSA Stare Factura" := "SSA Stare Factura"::"1-Factura Stornata";
            end;
        end;
    end;

    [EventSubscriber(ObjectType::Table, 38, 'OnBeforeInitRecord', '', false, false)]
    local procedure T38OnBeforeInitRecord(var PurchaseHeader: Record "Purchase Header"; var IsHandled: Boolean)
    begin
        if PurchaseHeader."SSA Tip Document D394" = PurchaseHeader."SSA Tip Document D394"::" " then
            PurchaseHeader."SSA Tip Document D394" := PurchaseHeader."SSA Tip Document D394"::"Factura Fiscala";
        if PurchaseHeader."SSA Stare Factura" = PurchaseHeader."SSA Stare Factura"::" " then
            PurchaseHeader."SSA Stare Factura" := PurchaseHeader."SSA Stare Factura"::"0-Factura Emisa";

    end;

    [EventSubscriber(ObjectType::Table, 81, 'OnBeforeValidateGenPostingType', '', false, false)]
    local procedure T81OnBeforeValidateGenPostingType(var GenJournalLine: Record "Gen. Journal Line"; var CheckIfFieldIsEmpty: Boolean)
    begin
        with GenJournalLine do
            if "Gen. Posting Type" = "Gen. Posting Type"::Purchase then
                "SSA Stare Factura" := "SSA Stare Factura"::"0-Factura Emisa";
    end;

    [EventSubscriber(ObjectType::Table, 81, 'OnAfterCopyGenJnlLineFromPurchHeader', '', false, false)]
    local procedure T81OnAfterCopyGenJnlLineFromPurchHeader(PurchaseHeader: Record "Purchase Header"; var GenJournalLine: Record "Gen. Journal Line")
    var
        Vendor: Record Vendor;
    begin
        GenJournalLine."SSA Stare Factura" := PurchaseHeader."SSA Stare Factura";
        GenJournalLine."SSA Tip Document D394" := PurchaseHeader."SSA Tip Document D394";
        if Vendor.Get(PurchaseHeader."Buy-from Vendor No.") then
            GenJournalLine."SSA Tip Partener" := Vendor."SSA Tip Partener";
    end;

    [EventSubscriber(ObjectType::Table, 81, 'OnAfterCopyGenJnlLineFromSalesHeader', '', false, false)]
    local procedure T81OnAfterCopyGenJnlLineFromSalesHeader(SalesHeader: Record "Sales Header"; var GenJournalLine: Record "Gen. Journal Line")
    var
        Customer: Record Customer;
    begin
        GenJournalLine."SSA Stare Factura" := SalesHeader."SSA Stare Factura";
        GenJournalLine."SSA Tip Document D394" := SalesHeader."SSA Tip Document D394";
        if Customer.Get(SalesHeader."Sell-to Customer No.") then
            GenJournalLine."SSA Tip Partener" := Customer."SSA Tip Partener";
    end;

    [EventSubscriber(ObjectType::Table, 254, 'OnAfterCopyFromGenJnlLine', '', false, false)]
    local procedure T254OnAfterCopyFromGenJnlLine(var VATEntry: Record "VAT Entry"; GenJournalLine: Record "Gen. Journal Line")
    begin
        VATEntry."SSA Tip Document D394" := GenJournalLine."SSA Tip Document D394";
        VATEntry."SSA Stare Factura" := GenJournalLine."SSA Stare Factura";
        VATEntry."SSA Tip Partener" := GenJournalLine."SSA Tip Partener";
    end;

    [EventSubscriber(ObjectType::Codeunit, 12, 'OnBeforeInsertTempVATEntry', '', false, false)]
    local procedure c12OnBeforeInsertTempVATEntry(var TempVATEntry: Record "VAT Entry" temporary; GenJournalLine: Record "Gen. Journal Line")
    begin
        TempVATEntry."SSA Tip Document D394" := GenJournalLine."SSA Tip Document D394";
        TempVATEntry."SSA Stare Factura" := GenJournalLine."SSA Stare Factura";
        TempVATEntry."SSA Tip Partener" := GenJournalLine."SSA Tip Partener";
    end;

    [EventSubscriber(ObjectType::Codeunit, 12, 'OnBeforeInsertPostUnrealVATEntry', '', false, false)]
    local procedure c12OnBeforeInsertPostUnrealVATEntry(var VATEntry: Record "VAT Entry"; GenJournalLine: Record "Gen. Journal Line")
    begin
        VATEntry."SSA Tip Document D394" := GenJournalLine."SSA Tip Document D394";
        VATEntry."SSA Stare Factura" := GenJournalLine."SSA Stare Factura";
        VATEntry."SSA Tip Partener" := GenJournalLine."SSA Tip Partener";
    end;

    [EventSubscriber(ObjectType::Codeunit, 12, 'OnInsertTempVATEntryOnBeforeInsert', '', false, false)]
    local procedure c12OnInsertTempVATEntryOnBeforeInsert(var VATEntry: Record "VAT Entry"; GenJournalLine: Record "Gen. Journal Line")
    begin
        VATEntry."SSA Tip Document D394" := GenJournalLine."SSA Tip Document D394";
        VATEntry."SSA Stare Factura" := GenJournalLine."SSA Stare Factura";
        VATEntry."SSA Tip Partener" := GenJournalLine."SSA Tip Partener";
    end;

    [EventSubscriber(ObjectType::Table, 36, 'OnCheckSalesPostRestrictions', '', false, false)]
    local procedure T36OnCheckSalesPostRestrictions(var Sender: Record "Sales Header")
    var
        SSASetup: Record "SSA Localization Setup";
        Cust: Record Customer;
    begin
        with Sender do begin
            SSASetup.Get;
            SSASetup.TestField("Skip Errors before date");
            if (SSASetup."Skip Errors before date" < "Posting Date") and Invoice then begin
                TestField("SSA Tip Document D394");
                TestField("SSA Stare Factura");
                CheckApplicationSales(Sender);

                TestField("Posting No. Series");

                Cust.Get(Sender."Sell-to Customer No.");
                Cust.TestField("SSA Tip Partener");
                if (Cust."SSA Tip Partener" = Cust."SSA Tip Partener"::"2-CNP PFA din RO sau CUI neinregistrat in scopuri de TVA") and
                  (Cust."VAT Registration No." = '')
                then begin
                    Cust.TestField("SSA Cod Judet D394");
                end;
            end;
        end;
    end;

    local procedure CheckApplicationSales(var _SalesHeader: Record "Sales Header")
    var
        SalesInvoiceHeader: Record "Sales Invoice Header";
        SalesCrMemoHeader: Record "Sales Cr.Memo Header";
    begin
        if _SalesHeader."SSA Stare Factura" <> _SalesHeader."SSA Stare Factura"::"2-Factura Anulata" then
            exit;

        _SalesHeader.CalcFields("Amount Including VAT");
        case _SalesHeader."Applies-to Doc. Type" of
            _SalesHeader."Applies-to Doc. Type"::Invoice:
                begin
                    SalesInvoiceHeader.Get(_SalesHeader."Applies-to Doc. No.");
                    SalesInvoiceHeader.CalcFields("Amount Including VAT");
                    if SalesInvoiceHeader."Amount Including VAT" <> _SalesHeader."Amount Including VAT" then
                        Error(Text001);
                end;
            _SalesHeader."Applies-to Doc. Type"::"Credit Memo":
                begin
                    SalesCrMemoHeader.Get(_SalesHeader."Applies-to Doc. No.");
                    SalesCrMemoHeader.CalcFields("Amount Including VAT");
                    if SalesCrMemoHeader."Amount Including VAT" <> _SalesHeader."Amount Including VAT" then
                        Error(Text001);
                end;

        end;
    end;

    [EventSubscriber(ObjectType::Table, 38, 'OnCheckPurchasePostRestrictions', '', false, false)]
    local procedure T38OnCheckPurchasePostRestrictions(var Sender: Record "Purchase Header")
    var
        SSASetup: Record "SSA Localization Setup";
        Vendor: Record Vendor;
    begin
        with Sender do begin
            SSASetup.Get;
            SSASetup.TestField("Skip Errors before date");
            if (SSASetup."Skip Errors before date" < "Posting Date") and Invoice then begin
                TestField("SSA Tip Document D394");
                TestField("SSA Stare Factura");
                CheckApplicationPurchase(Sender);

                TestField("Posting No. Series");

                Vendor.Get(Sender."Buy-from Vendor No.");
                Vendor.TestField("SSA Tip Partener");
                if (Vendor."SSA Tip Partener" = Vendor."SSA Tip Partener"::"2-CNP PFA din RO sau CUI neinregistrat in scopuri de TVA") and
                  (Vendor."VAT Registration No." = '')
                then begin
                    Vendor.TestField("SSA Cod Judet D394");
                end;
            end;
        end;
    end;

    local
    procedure CheckApplicationPurchase(_PurchHeader: Record "Purchase Header")
    var
        PurchInvoiceHeader: Record "Purch. Inv. Header";
        PurchCrMemoHeader: Record "Purch. Cr. Memo Hdr.";
    begin
        if _PurchHeader."SSA Stare Factura" <> _PurchHeader."SSA Stare Factura"::"2-Factura Anulata" then
            exit;

        _PurchHeader.CalcFields("Amount Including VAT");
        case _PurchHeader."Applies-to Doc. Type" of
            _PurchHeader."Applies-to Doc. Type"::Invoice:
                begin
                    PurchInvoiceHeader.Get(_PurchHeader."Applies-to Doc. No.");
                    PurchInvoiceHeader.CalcFields("Amount Including VAT");
                    if PurchInvoiceHeader."Amount Including VAT" <> _PurchHeader."Amount Including VAT" then
                        Error(Text001);
                end;
            _PurchHeader."Applies-to Doc. Type"::"Credit Memo":
                begin
                    PurchCrMemoHeader.Get(_PurchHeader."Applies-to Doc. No.");
                    PurchCrMemoHeader.CalcFields("Amount Including VAT");
                    if PurchCrMemoHeader."Amount Including VAT" <> _PurchHeader."Amount Including VAT" then
                        Error(Text001);
                end;

        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, 231, 'OnBeforeCode', '', false, false)]
    local procedure C231OnBeforeCode(var GenJournalLine: Record "Gen. Journal Line"; var HideDialog: Boolean)
    var
        SSASetup: Record "SSA Localization Setup";
        NoSeries: Record "No. Series";
    begin
        SSASetup.Get;
        SSASetup.TestField("Skip Errors before date");
        if SSASetup."Skip Errors before date" < GenJournalLine."Posting Date" then begin
            with GenJournalLine do
                if FindSet then
                    repeat
                        if (("VAT Bus. Posting Group" <> '') and ("VAT Prod. Posting Group" <> '')) or
                          (("Bal. VAT Bus. Posting Group" <> '') and ("Bal. VAT Prod. Posting Group" <> ''))
                        then begin
                            if ("Document Type" in ["Document Type"::Invoice, "Document Type"::"Credit Memo"]) then begin
                                if ("Gen. Posting Type" = "Gen. Posting Type"::Sale) or
                                  ("Bal. Gen. Posting Type" = "Bal. Gen. Posting Type"::Sale)
                                then begin //Seria doar la vanzare
                                    NoSeries.Get("Posting No. Series");

                                    if NoSeries."SSA Tip Serie" = NoSeries."SSA Tip Serie"::Autofactura then
                                        "SSA Stare Factura" := "SSA Stare Factura"::"3-Autofactura";
                                    if NoSeries."SSA Tip Serie" = NoSeries."SSA Tip Serie"::"Emise de Beneficiari" then
                                        "SSA Stare Factura" := "SSA Stare Factura"::"4-In calidate de beneficiar in numele furnizorului";
                                    Modify;
                                end;
                                TestField("SSA Tip Partener");
                                TestField("SSA Tip Document D394");
                                TestField("SSA Stare Factura");
                            end;
                        end;

                    until Next = 0;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, 338, 'OnBeforeVATEntryModify', '', false, false)]
    local procedure C338OnBeforeVATEntryModify(var VATEntry: Record "VAT Entry"; FromVATEntry: Record "VAT Entry")
    begin
        VATEntry."SSA Tip Document D394" := FromVATEntry."SSA Tip Document D394";
        VATEntry."SSA Stare Factura" := FromVATEntry."SSA Stare Factura";
        VATEntry."SSA Tip Partener" := FromVATEntry."SSA Tip Partener";
    end;
}

