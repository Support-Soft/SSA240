codeunit 70027 "SSA Charge Assignment"
{
    var
        Text001: Label 'Assign only the same Posting Groups.';

    [EventSubscriber(ObjectType::Page, Page::"Item Charge Assignment (Sales)", 'OnOpenPageEvent', '', true, false)]
    local procedure OnAfterOpenPageSales()
    begin
        Message(Text001);
    end;

    [EventSubscriber(ObjectType::Page, Page::"Item Charge Assignment (Purch)", 'OnOpenPageEvent', '', true, false)]
    local procedure OnAfterOpenPagePurch()
    begin
        Message(Text001);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnBeforePostItemJnlLine', '', true, false)]
    local procedure SalesOnBeforePostItemJnlLine(SalesHeader: Record "Sales Header"; VAR SalesLine: Record "Sales Line"; VAR QtyToBeShipped: Decimal;
        VAR QtyToBeShippedBase: Decimal; VAR QtyToBeInvoiced: Decimal; VAR QtyToBeInvoicedBase: Decimal; VAR ItemLedgShptEntryNo: Integer;
        var ItemChargeNo: Code[20]; var TrackingSpecification: Record "Tracking Specification"; var IsATO: Boolean; CommitIsSuppressed: Boolean)
    var
        ILE: Record "Item Ledger Entry";
        PRL: Record "Purch. Rcpt. Line";
        PAL: Record "Posted Assembly Line";
        PCML: Record "Purch. Cr. Memo Line";
        PIL: Record "Purch. Inv. Line";
        RSL: Record "Return Shipment Line";
        SCML: Record "Sales Cr.Memo Line";
        SIL: Record "Sales Invoice Line";
        RRL: Record "Return Receipt Line";
        SSL: Record "Sales Shipment Line";
        SSCML: Record "Service Cr.Memo Line";
        SSIL: Record "Service Invoice Line";
        SSSL: Record "Service Shipment Line";
        TRL: Record "Transfer Receipt Line";
        TSL: Record "Transfer Shipment Line";
    begin
        if ItemChargeNo = '' then
            exit;

        ILE.Get(ItemLedgShptEntryNo);
        case ILE."Document Type" of
            Ile."Document Type"::"Posted Assembly":
                begin
                    PAL.Get(ILE."Document No.", ILE."Document Line No.");
                    SalesLine.TestField("Gen. Prod. Posting Group", PAL."Gen. Prod. Posting Group");
                end;
            Ile."Document Type"::"Purchase Credit Memo":
                begin
                    PCML.Get(ILE."Document No.", ILE."Document Line No.");
                    SalesLine.TestField("Gen. Prod. Posting Group", PCML."Gen. Prod. Posting Group");
                end;
            Ile."Document Type"::"Purchase Invoice":
                begin
                    PIL.Get(ILE."Document No.", ILE."Document Line No.");
                    SalesLine.TestField("Gen. Prod. Posting Group", PIL."Gen. Prod. Posting Group");
                end;
            Ile."Document Type"::"Purchase Receipt":
                begin
                    PRL.Get(ILE."Document No.", ILE."Document Line No.");
                    SalesLine.TestField("Gen. Prod. Posting Group", PRL."Gen. Prod. Posting Group");
                end;
            Ile."Document Type"::"Purchase Return Shipment":
                begin
                    RSL.Get(ILE."Document No.", ILE."Document Line No.");
                    SalesLine.TestField("Gen. Prod. Posting Group", RSL."Gen. Prod. Posting Group");
                end;
            Ile."Document Type"::"Sales Credit Memo":
                begin
                    SCML.Get(ILE."Document No.", ILE."Document Line No.");
                    SalesLine.TestField("Gen. Prod. Posting Group", SCML."Gen. Prod. Posting Group");
                end;
            Ile."Document Type"::"Sales Invoice":
                begin
                    SIL.Get(ILE."Document No.", ILE."Document Line No.");
                    SalesLine.TestField("Gen. Prod. Posting Group", SIL."Gen. Prod. Posting Group");
                end;
            Ile."Document Type"::"Sales Return Receipt":
                begin
                    RRL.Get(ILE."Document No.", ILE."Document Line No.");
                    SalesLine.TestField("Gen. Prod. Posting Group", RRL."Gen. Prod. Posting Group");
                end;
            Ile."Document Type"::"Sales Shipment":
                begin
                    SSL.Get(ILE."Document No.", ILE."Document Line No.");
                    SalesLine.TestField("Gen. Prod. Posting Group", SSL."Gen. Prod. Posting Group");
                end;
            Ile."Document Type"::"Service Credit Memo":
                begin
                    SSCML.Get(ILE."Document No.", ILE."Document Line No.");
                    SalesLine.TestField("Gen. Prod. Posting Group", SSCML."Gen. Prod. Posting Group");
                end;
            Ile."Document Type"::"Service Invoice":
                begin
                    SSIL.Get(ILE."Document No.", ILE."Document Line No.");
                    SalesLine.TestField("Gen. Prod. Posting Group", SSIL."Gen. Prod. Posting Group");
                end;
            Ile."Document Type"::"Service Shipment":
                begin
                    SSSL.Get(ILE."Document No.", ILE."Document Line No.");
                    SalesLine.TestField("Gen. Prod. Posting Group", SSSL."Gen. Prod. Posting Group");
                end;
            Ile."Document Type"::"Transfer Receipt":
                begin
                    TRL.Get(ILE."Document No.", ILE."Document Line No.");
                    SalesLine.TestField("Gen. Prod. Posting Group", TRL."Gen. Prod. Posting Group");
                end;
            Ile."Document Type"::"Transfer Shipment":
                begin
                    TSL.Get(ILE."Document No.", ILE."Document Line No.");
                    SalesLine.TestField("Gen. Prod. Posting Group", TSL."Gen. Prod. Posting Group");
                end;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnBeforePostItemJnlLine', '', true, false)]
    local procedure PurchOnBeforePostItemJnlLine(PurchHeader: Record "Purchase Header"; var ItemChargeNo: Code[20]; var ItemLedgShptEntryNo: Integer; var PurchLine: Record "Purchase Line")
    var
        ILE: Record "Item Ledger Entry";
        PRL: Record "Purch. Rcpt. Line";
        PAL: Record "Posted Assembly Line";
        PCML: Record "Purch. Cr. Memo Line";
        PIL: Record "Purch. Inv. Line";
        RSL: Record "Return Shipment Line";
        SCML: Record "Sales Cr.Memo Line";
        SIL: Record "Sales Invoice Line";
        RRL: Record "Return Receipt Line";
        SSL: Record "Sales Shipment Line";
        SSCML: Record "Service Cr.Memo Line";
        SSIL: Record "Service Invoice Line";
        SSSL: Record "Service Shipment Line";
        TRL: Record "Transfer Receipt Line";
        TSL: Record "Transfer Shipment Line";
    begin
        if ItemChargeNo = '' then
            exit;

        ILE.Get(ItemLedgShptEntryNo);
        case ILE."Document Type" of
            Ile."Document Type"::"Posted Assembly":
                begin
                    PAL.Get(ILE."Document No.", ILE."Document Line No.");
                    PurchLine.TestField("Gen. Prod. Posting Group", PAL."Gen. Prod. Posting Group");
                end;
            Ile."Document Type"::"Purchase Credit Memo":
                begin
                    PCML.Get(ILE."Document No.", ILE."Document Line No.");
                    PurchLine.TestField("Gen. Prod. Posting Group", PCML."Gen. Prod. Posting Group");
                end;
            Ile."Document Type"::"Purchase Invoice":
                begin
                    PIL.Get(ILE."Document No.", ILE."Document Line No.");
                    PurchLine.TestField("Gen. Prod. Posting Group", PIL."Gen. Prod. Posting Group");
                end;
            Ile."Document Type"::"Purchase Receipt":
                begin
                    PRL.Get(ILE."Document No.", ILE."Document Line No.");
                    PurchLine.TestField("Gen. Prod. Posting Group", PRL."Gen. Prod. Posting Group");
                end;
            Ile."Document Type"::"Purchase Return Shipment":
                begin
                    RSL.Get(ILE."Document No.", ILE."Document Line No.");
                    PurchLine.TestField("Gen. Prod. Posting Group", RSL."Gen. Prod. Posting Group");
                end;
            Ile."Document Type"::"Sales Credit Memo":
                begin
                    SCML.Get(ILE."Document No.", ILE."Document Line No.");
                    PurchLine.TestField("Gen. Prod. Posting Group", SCML."Gen. Prod. Posting Group");
                end;
            Ile."Document Type"::"Sales Invoice":
                begin
                    SIL.Get(ILE."Document No.", ILE."Document Line No.");
                    PurchLine.TestField("Gen. Prod. Posting Group", SIL."Gen. Prod. Posting Group");
                end;
            Ile."Document Type"::"Sales Return Receipt":
                begin
                    RRL.Get(ILE."Document No.", ILE."Document Line No.");
                    PurchLine.TestField("Gen. Prod. Posting Group", RRL."Gen. Prod. Posting Group");
                end;
            Ile."Document Type"::"Sales Shipment":
                begin
                    SSL.Get(ILE."Document No.", ILE."Document Line No.");
                    PurchLine.TestField("Gen. Prod. Posting Group", SSL."Gen. Prod. Posting Group");
                end;
            Ile."Document Type"::"Service Credit Memo":
                begin
                    SSCML.Get(ILE."Document No.", ILE."Document Line No.");
                    PurchLine.TestField("Gen. Prod. Posting Group", SSCML."Gen. Prod. Posting Group");
                end;
            Ile."Document Type"::"Service Invoice":
                begin
                    SSIL.Get(ILE."Document No.", ILE."Document Line No.");
                    PurchLine.TestField("Gen. Prod. Posting Group", SSIL."Gen. Prod. Posting Group");
                end;
            Ile."Document Type"::"Service Shipment":
                begin
                    SSSL.Get(ILE."Document No.", ILE."Document Line No.");
                    PurchLine.TestField("Gen. Prod. Posting Group", SSSL."Gen. Prod. Posting Group");
                end;
            Ile."Document Type"::"Transfer Receipt":
                begin
                    TRL.Get(ILE."Document No.", ILE."Document Line No.");
                    PurchLine.TestField("Gen. Prod. Posting Group", TRL."Gen. Prod. Posting Group");
                end;
            Ile."Document Type"::"Transfer Shipment":
                begin
                    TSL.Get(ILE."Document No.", ILE."Document Line No.");
                    PurchLine.TestField("Gen. Prod. Posting Group", TSL."Gen. Prod. Posting Group");
                end;
        end;
    end;
}