codeunit 70007 "SSA Correct Documents"
{
    // SSA936 SSCAT 16.06.2019 936: 2.Funct. anulare/stornare automata de documente (vanzare, cumparare)
    // SSA973 SSCAT 06.09.2019 39.Rapoarte legale- Localizare Declaratia 394

    Permissions = tabledata "Sales Invoice Header" = rm,
                  tabledata "Sales Cr.Memo Header" = rm,
                  tabledata "Purch. Inv. Header" = rm,
                  tabledata "Purch. Cr. Memo Hdr." = rm,
                  tabledata "VAT Entry" = rm,
                  tabledata "Cust. Ledger Entry" = rm,
                  tabledata "Vendor Ledger Entry" = rm;

    [EventSubscriber(ObjectType::Table, Database::"Cancelled Document", 'OnAfterInsertEvent', '', false, false)]
    local procedure T1900OnAfterInsertEvent(var Rec: Record "Cancelled Document"; RunTrigger: Boolean)
    var
        VATEntry: Record "VAT Entry";
        SalesInvoiceHeader: Record "Sales Invoice Header";
        SalesCrMemoHeader: Record "Sales Cr.Memo Header";
        PurchInvoiceHeader: Record "Purch. Inv. Header";
        PurchCrMemoHeader: Record "Purch. Cr. Memo Hdr.";
        CustLedgerEntry: Record "Cust. Ledger Entry";
        VendLedgerEntry: Record "Vendor Ledger Entry";
    begin
        VATEntry.Reset();
        VATEntry.SetCurrentKey("Document No.", "Posting Date");
        VATEntry.SetRange("Document No.", Rec."Cancelled Doc. No.");

        case Rec."Source ID" of
            112:
                begin
                    SalesInvoiceHeader.Get(Rec."Cancelled Doc. No.");
                    SalesCrMemoHeader.Get(Rec."Cancelled By Doc. No.");
                    if SalesCrMemoHeader."SSA Stare Factura" = SalesCrMemoHeader."SSA Stare Factura"::"2-Factura Anulata" then begin
                        SalesInvoiceHeader."SSA Stare Factura" := SalesCrMemoHeader."SSA Stare Factura";
                        SalesInvoiceHeader.Modify();
                        VATEntry.ModifyAll("SSA Stare Factura", SalesCrMemoHeader."SSA Stare Factura");
                        CustLedgerEntry.Reset();
                        CustLedgerEntry.SetCurrentKey("Document No.");
                        CustLedgerEntry.SetFilter("Document No.", '%1|%2', SalesCrMemoHeader."No.", SalesInvoiceHeader."No.");
                        CustLedgerEntry.ModifyAll("SSA Stare Factura", SalesCrMemoHeader."SSA Stare Factura");
                    end;
                end;
            114:
                begin
                    SalesCrMemoHeader.Get(Rec."Cancelled Doc. No.");
                    SalesInvoiceHeader.Get(Rec."Cancelled By Doc. No.");
                    if SalesInvoiceHeader."SSA Stare Factura" = SalesInvoiceHeader."SSA Stare Factura"::"2-Factura Anulata" then begin
                        SalesCrMemoHeader."SSA Stare Factura" := SalesInvoiceHeader."SSA Stare Factura";
                        SalesCrMemoHeader.Modify();
                        VATEntry.ModifyAll("SSA Stare Factura", SalesInvoiceHeader."SSA Stare Factura");
                        CustLedgerEntry.Reset();
                        CustLedgerEntry.SetCurrentKey("Document No.");
                        CustLedgerEntry.SetFilter("Document No.", '%1|%2', SalesCrMemoHeader."No.", SalesInvoiceHeader."No.");
                        CustLedgerEntry.ModifyAll("SSA Stare Factura", SalesInvoiceHeader."SSA Stare Factura");
                    end;
                end;
            122:
                begin
                    PurchInvoiceHeader.Get(Rec."Cancelled Doc. No.");
                    PurchCrMemoHeader.Get(Rec."Cancelled By Doc. No.");
                    if PurchCrMemoHeader."SSA Stare Factura" = PurchCrMemoHeader."SSA Stare Factura"::"2-Factura Anulata" then begin
                        PurchInvoiceHeader."SSA Stare Factura" := PurchCrMemoHeader."SSA Stare Factura";
                        PurchInvoiceHeader.Modify();
                        VATEntry.ModifyAll("SSA Stare Factura", PurchCrMemoHeader."SSA Stare Factura");
                        VendLedgerEntry.Reset();
                        VendLedgerEntry.SetCurrentKey("Document No.");
                        VendLedgerEntry.SetFilter("Document No.", '%1|%2', PurchCrMemoHeader."No.", PurchInvoiceHeader."No.");
                        VendLedgerEntry.ModifyAll("SSA Stare Factura", PurchCrMemoHeader."SSA Stare Factura");
                    end;
                end;
            124:
                begin
                    PurchCrMemoHeader.Get(Rec."Cancelled Doc. No.");
                    PurchInvoiceHeader.Get(Rec."Cancelled By Doc. No.");
                    if PurchInvoiceHeader."SSA Stare Factura" = PurchInvoiceHeader."SSA Stare Factura"::"2-Factura Anulata" then begin
                        PurchCrMemoHeader."SSA Stare Factura" := PurchInvoiceHeader."SSA Stare Factura";
                        PurchCrMemoHeader.Modify();
                        VATEntry.ModifyAll("SSA Stare Factura", PurchInvoiceHeader."SSA Stare Factura");
                        VendLedgerEntry.Reset();
                        VendLedgerEntry.SetCurrentKey("Document No.");
                        VendLedgerEntry.SetFilter("Document No.", '%1|%2', PurchCrMemoHeader."No.", PurchInvoiceHeader."No.");
                        VendLedgerEntry.ModifyAll("SSA Stare Factura", PurchInvoiceHeader."SSA Stare Factura");
                    end;
                end;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, 6620, 'OnAfterCopyFieldsFromOldSalesHeader', '', false, false)]
    local procedure C6620OnAfterCopyFieldsFromOldSalesHeader(var ToSalesHeader: Record "Sales Header"; OldSalesHeader: Record "Sales Header"; MoveNegLines: Boolean; IncludeHeader: Boolean)
    begin
        if OldSalesHeader."SSA Stare Factura" = OldSalesHeader."SSA Stare Factura"::"2-Factura Anulata" then begin
            ToSalesHeader."SSA Stare Factura" := OldSalesHeader."SSA Stare Factura";
            ToSalesHeader."SSA Tip Document D394" := OldSalesHeader."SSA Tip Document D394";
            if ToSalesHeader."Document Type" = ToSalesHeader."Document Type"::Invoice then
                ToSalesHeader."Due Date" := OldSalesHeader."Posting Date";
        end
        else begin
            ToSalesHeader."SSA Stare Factura" := OldSalesHeader."SSA Stare Factura"::"0-Factura Emisa";
            ToSalesHeader."SSA Tip Document D394" := OldSalesHeader."SSA Tip Document D394"::"Factura Fiscala";
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, 6620, 'OnAfterCopyFieldsFromOldPurchHeader', '', false, false)]
    local procedure C6620OnAfterCopyFieldsFromOldPurchaseHeader(var ToPurchHeader: Record "Purchase Header"; OldPurchHeader: Record "Purchase Header"; MoveNegLines: Boolean; IncludeHeader: Boolean)
    begin
        if OldPurchHeader."SSA Stare Factura" = OldPurchHeader."SSA Stare Factura"::"2-Factura Anulata" then begin
            ToPurchHeader."SSA Stare Factura" := OldPurchHeader."SSA Stare Factura";
            ToPurchHeader."SSA Tip Document D394" := OldPurchHeader."SSA Tip Document D394";
            if ToPurchHeader."Document Type" = ToPurchHeader."Document Type"::Invoice then
                ToPurchHeader."Due Date" := OldPurchHeader."Posting Date";

        end
        else begin
            ToPurchHeader."SSA Stare Factura" := OldPurchHeader."SSA Stare Factura"::"0-Factura Emisa";
            ToPurchHeader."SSA Tip Document D394" := OldPurchHeader."SSA Tip Document D394"::"Factura Fiscala";
            ToPurchHeader."Posting Description" := OldPurchHeader."Posting Description";
        end;
    end;

    local procedure "---"()
    begin
    end;

    [EventSubscriber(ObjectType::Codeunit, 1303, 'OnAfterCreateCorrectiveSalesCrMemo', '', false, false)]
    local procedure OnAfterCreateCorrectiveSalesCrMemo(SalesInvoiceHeader: Record "Sales Invoice Header"; var SalesHeader: Record "Sales Header"; var CancellingOnly: Boolean)
    begin
        if SalesInvoiceHeader."SSA Cancelling Type" = SalesInvoiceHeader."SSA Cancelling Type"::Cancel then begin
            SalesHeader."SSA Tip Document D394" := SalesHeader."SSA Tip Document D394"::"Factura Fiscala"; //SSM973
            SalesHeader."SSA Stare Factura" := SalesHeader."SSA Stare Factura"::"2-Factura Anulata"; //SSM973
            SalesHeader."Posting No." := SalesInvoiceHeader."No.";
            SalesHeader."Posting No. Series" := SalesInvoiceHeader."No. Series";
        end
        else begin
            SalesHeader."SSA Tip Document D394" := SalesHeader."SSA Tip Document D394"::"Factura Fiscala"; //SSM973
            SalesHeader."SSA Stare Factura" := SalesHeader."SSA Stare Factura"::"1-Factura Stornata"; //SSM973
        end;
        SalesHeader.Modify();
        SalesInvoiceHeader."SSA Cancelling Type" := SalesInvoiceHeader."SSA Cancelling Type"::" ";
    end;

    [EventSubscriber(ObjectType::Codeunit, 6620, 'OnBeforeCopySalesDocForCrMemoCancelling', '', false, false)]
    local procedure OnAfterCreateCorrSalesInvoice(FromDocNo: Code[20]; var ToSalesHeader: Record "Sales Header")
    var
        SalesCrMemoHeader: Record "Sales Cr.Memo Header";
    begin
        if SalesCrMemoHeader."SSA Cancelling Type" = SalesCrMemoHeader."SSA Cancelling Type"::Cancel then begin
            ToSalesHeader."SSA Tip Document D394" := ToSalesHeader."SSA Tip Document D394"::"Factura Fiscala"; //SSM973
            ToSalesHeader."SSA Stare Factura" := ToSalesHeader."SSA Stare Factura"::"2-Factura Anulata"; //SSM973
            ToSalesHeader."Posting No." := SalesCrMemoHeader."No.";
            ToSalesHeader."Posting No. Series" := SalesCrMemoHeader."No. Series";
        end
        else begin
            ToSalesHeader."SSA Tip Document D394" := ToSalesHeader."SSA Tip Document D394"::"Factura Fiscala"; //SSM973
            ToSalesHeader."SSA Stare Factura" := ToSalesHeader."SSA Stare Factura"::"1-Factura Stornata"; //SSM973
        end;
        ToSalesHeader.Modify();
        SalesCrMemoHeader."SSA Cancelling Type" := SalesCrMemoHeader."SSA Cancelling Type"::" ";
    end;

    [EventSubscriber(ObjectType::Page, 132, 'OnBeforeActionEvent', 'CancelInvoice', false, false)]
    local procedure P132OnBeforeActionEventCancelInvoice(var Rec: Record "Sales Invoice Header")
    begin
        Rec."SSA Cancelling Type" := Rec."SSA Cancelling Type"::Cancel;
    end;

    [EventSubscriber(ObjectType::Page, 132, 'OnBeforeActionEvent', 'CorrectInvoice', false, false)]
    local procedure P132OnBeforeActionEventCorrectInvoice(var Rec: Record "Sales Invoice Header")
    begin
        Rec."SSA Cancelling Type" := Rec."SSA Cancelling Type"::Correct;
    end;

    [EventSubscriber(ObjectType::Page, 143, 'OnBeforeActionEvent', 'CancelInvoice', false, false)]
    local procedure P143OnBeforeActionEventCancelInvoice(var Rec: Record "Sales Invoice Header")
    begin
        Rec."SSA Cancelling Type" := Rec."SSA Cancelling Type"::Cancel;
    end;

    [EventSubscriber(ObjectType::Page, 143, 'OnBeforeActionEvent', 'CorrectInvoice', false, false)]
    local procedure P143OnBeforeActionEventCorrectInvoice(var Rec: Record "Sales Invoice Header")
    begin
        Rec."SSA Cancelling Type" := Rec."SSA Cancelling Type"::Correct;
    end;

    [EventSubscriber(ObjectType::Page, 134, 'OnBeforeActionEvent', 'CancelCrMemo', false, false)]
    local procedure P134OnBeforeActionEventCancelInvoice(var Rec: Record "Sales Cr.Memo Header")
    begin
        Rec."SSA Cancelling Type" := Rec."SSA Cancelling Type"::Cancel;
    end;

    [EventSubscriber(ObjectType::Page, 144, 'OnBeforeActionEvent', 'CancelCrMemo', false, false)]
    local procedure P144OnBeforeActionEventCancelInvoice(var Rec: Record "Sales Cr.Memo Header")
    begin
        Rec."SSA Cancelling Type" := Rec."SSA Cancelling Type"::Cancel;
    end;

    local procedure "--Purchase"()
    begin
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Cancel Posted Purch. Cr. Memo", 'OnBeforeTestIfCrMemoIsCorrectiveDoc', '', false, false)]
    local procedure OnBeforeTestIfCrMemoIsCorrectiveDoc_CancelPostedPurchCrMemo(PurchCrMemoHdr: Record "Purch. Cr. Memo Hdr."; var IsHandled: Boolean)
    begin
        IsHandled := true;
    end;

    [EventSubscriber(ObjectType::Codeunit, 1313, 'OnAfterCreateCorrectivePurchCrMemo', '', false, false)]
    local procedure OnAfterCreateCorrectivePurchaseCrMemo(PurchInvHeader: Record "Purch. Inv. Header"; var PurchaseHeader: Record "Purchase Header")
    begin
        if PurchInvHeader."SSA Cancelling Type" = PurchInvHeader."SSA Cancelling Type"::Cancel then begin
            PurchaseHeader."SSA Tip Document D394" := PurchaseHeader."SSA Tip Document D394"::"Factura Fiscala"; //SSM973
            PurchaseHeader."SSA Stare Factura" := PurchaseHeader."SSA Stare Factura"::"2-Factura Anulata"; //SSM973
            PurchaseHeader."Posting No." := PurchInvHeader."No.";
            PurchaseHeader."Posting No. Series" := PurchInvHeader."No. Series";
        end
        else begin
            PurchaseHeader."SSA Tip Document D394" := PurchaseHeader."SSA Tip Document D394"::"Factura Fiscala"; //SSM973
            PurchaseHeader."SSA Stare Factura" := PurchaseHeader."SSA Stare Factura"::"1-Factura Stornata"; //SSM973
        end;
        PurchaseHeader.Modify();
        PurchInvHeader."SSA Cancelling Type" := PurchInvHeader."SSA Cancelling Type"::" ";
    end;

    [EventSubscriber(ObjectType::Codeunit, 6620, 'OnBeforeCopyPurchaseDocForInvoiceCancelling', '', false, false)]
    local procedure OnAfterCreateCorrectivePurchInvoice(FromDocNo: Code[20]; var ToPurchaseHeader: Record "Purchase Header")
    /*
    var
        PurchCrMemo: Record "Purch. Cr. Memo Hdr.";
    begin
        PurchCrMemo.Get(FromDocNo);
        if PurchCrMemo."SSA Cancelling Type" = PurchCrMemo."SSA Cancelling Type"::Cancel then begin
            ToPurchaseHeader."SSA Tip Document D394" := ToPurchaseHeader."SSA Tip Document D394"::"Factura Fiscala"; //SSM973
            ToPurchaseHeader."SSA Stare Factura" := ToPurchaseHeader."SSA Stare Factura"::"2-Factura Anulata"; //SSM973
            ToPurchaseHeader."Posting No." := PurchCrMemo."No.";
            ToPurchaseHeader."Posting No. Series" := PurchCrMemo."No. Series";
        end else begin
            ToPurchaseHeader."SSA Tip Document D394" := ToPurchaseHeader."SSA Tip Document D394"::"Factura Fiscala"; //SSM973
            ToPurchaseHeader."SSA Stare Factura" := ToPurchaseHeader."SSA Stare Factura"::"1-Factura Stornata"; //SSM973
        end;
        ToPurchaseHeader.Modify;
        PurchCrMemo."SSA Cancelling Type" := PurchCrMemo."SSA Cancelling Type"::" ";
    end;
    */
    var
        PurchInvHeader: Record "Purch. Inv. Header";
    begin
        PurchInvHeader.Get(FromDocNo);
        if PurchInvHeader."SSA Cancelling Type" = PurchInvHeader."SSA Cancelling Type"::Cancel then begin
            ToPurchaseHeader."SSA Tip Document D394" := ToPurchaseHeader."SSA Tip Document D394"::"Factura Fiscala"; //SSM973
            ToPurchaseHeader."SSA Stare Factura" := ToPurchaseHeader."SSA Stare Factura"::"2-Factura Anulata"; //SSM973
            ToPurchaseHeader."Posting No." := PurchInvHeader."No.";
            ToPurchaseHeader."Posting No. Series" := PurchInvHeader."No. Series";
        end
        else begin
            ToPurchaseHeader."SSA Tip Document D394" := ToPurchaseHeader."SSA Tip Document D394"::"Factura Fiscala"; //SSM973
            ToPurchaseHeader."SSA Stare Factura" := ToPurchaseHeader."SSA Stare Factura"::"1-Factura Stornata"; //SSM973
        end;
        ToPurchaseHeader.Modify();
        PurchInvHeader."SSA Cancelling Type" := PurchInvHeader."SSA Cancelling Type"::" ";
    end;

    [EventSubscriber(ObjectType::Page, 146, 'OnBeforeActionEvent', 'CancelInvoice', false, false)]
    local procedure P146OnBeforeActionEventCancelInvoice(var Rec: Record "Purch. Inv. Header")
    begin
        Rec."SSA Cancelling Type" := Rec."SSA Cancelling Type"::Cancel;
    end;

    [EventSubscriber(ObjectType::Page, 146, 'OnBeforeActionEvent', 'CorrectInvoice', false, false)]
    local procedure P146OnBeforeActionEventCorrectInvoice(var Rec: Record "Purch. Inv. Header")
    begin
        Rec."SSA Cancelling Type" := Rec."SSA Cancelling Type"::Correct;
    end;

    [EventSubscriber(ObjectType::Page, 138, 'OnBeforeActionEvent', 'CancelInvoice', false, false)]
    local procedure P138OnBeforeActionEventCancelInvoice(var Rec: Record "Purch. Inv. Header")
    begin
        Rec."SSA Cancelling Type" := Rec."SSA Cancelling Type"::Cancel;
    end;

    [EventSubscriber(ObjectType::Page, 138, 'OnBeforeActionEvent', 'CorrectInvoice', false, false)]
    local procedure P138OnBeforeActionEventCorrectInvoice(var Rec: Record "Purch. Inv. Header")
    begin
        Rec."SSA Cancelling Type" := Rec."SSA Cancelling Type"::Correct;
    end;

    [EventSubscriber(ObjectType::Page, 140, 'OnBeforeActionEvent', 'CancelCrMemo', false, false)]
    local procedure P140OnBeforeActionEventCancelInvoice(var Rec: Record "Purch. Cr. Memo Hdr.")
    begin
        Rec."SSA Cancelling Type" := Rec."SSA Cancelling Type"::Cancel;
    end;

    [EventSubscriber(ObjectType::Page, 147, 'OnBeforeActionEvent', 'CancelCrMemo', false, false)]
    local procedure P147OnBeforeActionEventCancelInvoice(var Rec: Record "Purch. Cr. Memo Hdr.")
    begin
        Rec."SSA Cancelling Type" := Rec."SSA Cancelling Type"::Cancel;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnAfterPostSalesDoc', '', false, false)]
    local procedure C80_SetCancelled_OnAfterPostSalesDoc(var SalesHeader: Record "Sales Header"; SalesInvHdrNo: Code[20]; SalesCrMemoHdrNo: Code[20])
    var
        VATEntry: Record "VAT Entry";
        SalesInvoiceHeader: Record "Sales Invoice Header";
        SalesCrMemoHeader: Record "Sales Cr.Memo Header";
        CustLedgerEntry: Record "Cust. Ledger Entry";
        CancelledDocNo: Code[20];
    begin
        if SalesHeader."SSA Stare Factura" <> SalesHeader."SSA Stare Factura"::"2-Factura Anulata" then
            exit;

        if SalesInvHdrNo <> '' then
            CancelledDocNo := SalesInvHdrNo;

        if SalesCrMemoHdrNo <> '' then
            CancelledDocNo := SalesCrMemoHdrNo;

        VATEntry.Reset();
        VATEntry.SetCurrentKey("Document No.", "Posting Date");
        VATEntry.SetRange("Document No.", CancelledDocNo);

        if SalesInvHdrNo <> '' then begin
            SalesCrMemoHeader.Get(CancelledDocNo);
            SalesCrMemoHeader."SSA Stare Factura" := SalesCrMemoHeader."SSA Stare Factura"::"2-Factura Anulata";
            SalesCrMemoHeader.Modify();
            VATEntry.ModifyAll("SSA Stare Factura", SalesCrMemoHeader."SSA Stare Factura");
            CustLedgerEntry.Reset();
            CustLedgerEntry.SetCurrentKey("Document No.");
            CustLedgerEntry.SetRange("Document No.", SalesCrMemoHeader."No.");
            CustLedgerEntry.ModifyAll("SSA Stare Factura", SalesCrMemoHeader."SSA Stare Factura");
        end;

        if SalesCrMemoHdrNo <> '' then begin
            SalesInvoiceHeader.Get(CancelledDocNo);
            SalesInvoiceHeader."SSA Stare Factura" := SalesInvoiceHeader."SSA Stare Factura"::"2-Factura Anulata";
            SalesInvoiceHeader.Modify();
            VATEntry.ModifyAll("SSA Stare Factura", SalesInvoiceHeader."SSA Stare Factura");
            CustLedgerEntry.Reset();
            CustLedgerEntry.SetCurrentKey("Document No.");
            CustLedgerEntry.SetRange("Document No.", SalesInvoiceHeader."No.");
            CustLedgerEntry.ModifyAll("SSA Stare Factura", SalesInvoiceHeader."SSA Stare Factura");
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnAfterPostPurchaseDoc', '', false, false)]
    local procedure C90_SetCancelled_OnAfterPostPurchaseDoc(var PurchaseHeader: Record "Purchase Header"; PurchInvHdrNo: Code[20]; PurchCrMemoHdrNo: Code[20])
    var
        VATEntry: Record "VAT Entry";
        PurchInvHeader: Record "Purch. Inv. Header";
        PurchCrMemoHdr: Record "Purch. Cr. Memo Hdr.";
        VendLedgerEntry: Record "Vendor Ledger Entry";
        CancelledDocNo: Code[20];
    begin
        if PurchaseHeader."SSA Stare Factura" <> PurchaseHeader."SSA Stare Factura"::"2-Factura Anulata" then
            exit;

        if PurchInvHdrNo <> '' then
            CancelledDocNo := PurchInvHdrNo;

        if PurchCrMemoHdrNo <> '' then
            CancelledDocNo := PurchCrMemoHdrNo;

        VATEntry.Reset();
        VATEntry.SetCurrentKey("Document No.", "Posting Date");
        VATEntry.SetRange("Document No.", CancelledDocNo);

        if PurchInvHdrNo <> '' then begin
            PurchCrMemoHdr.Get(CancelledDocNo);
            PurchCrMemoHdr."SSA Stare Factura" := PurchCrMemoHdr."SSA Stare Factura"::"2-Factura Anulata";
            PurchCrMemoHdr.Modify();
            VATEntry.ModifyAll("SSA Stare Factura", PurchCrMemoHdr."SSA Stare Factura");
            VendLedgerEntry.Reset();
            VendLedgerEntry.SetCurrentKey("Document No.");
            VendLedgerEntry.SetRange("Document No.", PurchCrMemoHdr."No.");
            VendLedgerEntry.ModifyAll("SSA Stare Factura", PurchCrMemoHdr."SSA Stare Factura");
        end;

        if PurchCrMemoHdrNo <> '' then begin
            PurchInvHeader.Get(CancelledDocNo);
            PurchInvHeader."SSA Stare Factura" := PurchInvHeader."SSA Stare Factura"::"2-Factura Anulata";
            PurchInvHeader.Modify();
            VATEntry.ModifyAll("SSA Stare Factura", PurchInvHeader."SSA Stare Factura");
            VendLedgerEntry.Reset();
            VendLedgerEntry.SetCurrentKey("Document No.");
            VendLedgerEntry.SetRange("Document No.", PurchInvHeader."No.");
            VendLedgerEntry.ModifyAll("SSA Stare Factura", PurchInvHeader."SSA Stare Factura");
        end;
    end;
}
