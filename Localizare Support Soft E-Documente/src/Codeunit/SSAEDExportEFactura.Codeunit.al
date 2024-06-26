codeunit 72002 "SSAEDExport EFactura"
{
    TableNo = "SSAEDE-Documents Log Entry";

    trigger OnRun()
    var
        SalesInvoiceHeader: Record "Sales Invoice Header";
        SalesCrMemoHeader: Record "Sales Cr.Memo Header";
        EFacturaSetup: Record "SSAEDEDocuments Setup";
        RecordRef: RecordRef;
        ANAFAPIMgt: Codeunit "SSAEDANAF API Mgt";
        TempBlob: Codeunit "Temp Blob";
    begin
        Rec.TestField("Entry Type", Rec."Entry Type"::"Export E-Factura");
        if Rec."XML Content".HasValue then
            TempBlob.FromRecord(Rec, rec.FieldNo("XML Content"))
        else begin
            RecordRef.Get(Rec.RecordID);
            case RecordRef.Number of
                DATABASE::"Sales Invoice Header":
                    begin
                        RecordRef.SetTable(SalesInvoiceHeader);
                        GenerateXMLFile(SalesInvoiceHeader, TempBlob);
                    end;
                DATABASE::"Sales Cr.Memo Header":
                    begin
                        RecordRef.SetTable(SalesCrMemoHeader);
                        GenerateXMLFile(SalesCrMemoHeader, TempBlob);
                    end;
                else
                    Error('Not allowed %1', RecordRef.Number);
            end;
        end;
        EFacturaSetup.Get();
        if EFacturaSetup."EFactura Enable API" then
            ANAFAPIMgt.PostEFactura(TempBlob, Rec.DateResponse, Rec."Execution Status", Rec."Index Incarcare");

        Rec.Status := Rec.Status::Completed;

        Rec.Modify;

    end;

    procedure ExportXMLFile(var ROFactura: Record "SSAEDE-Documents Log Entry")
    var
        SalesInvoiceHeader: Record "Sales Invoice Header";
        SalesCrMemoHeader: Record "Sales Cr.Memo Header";
        RecordRef: RecordRef;
        TempBlob: Codeunit "Temp Blob";
        InStr: InStream;
        FileName: Text;
    begin
        RecordRef.Get(ROFactura.RecordID);
        case RecordRef.Number of
            DATABASE::"Sales Invoice Header":
                begin
                    RecordRef.SetTable(SalesInvoiceHeader);
                    GenerateXMLFile(SalesInvoiceHeader, TempBlob);
                    FileName := SalesInvoiceHeader."No." + '.xml';
                end;
            DATABASE::"Sales Cr.Memo Header":
                begin
                    RecordRef.SetTable(SalesCrMemoHeader);
                    GenerateXMLFile(SalesCrMemoHeader, TempBlob);
                    FileName := SalesCrMemoHeader."No." + '.xml';
                end;
            else
                Error('Not allowed %1', RecordRef.Number);
        end;
        TempBlob.CreateInStream(InStr);
        DownloadFromStream(InStr, 'Save XML File', '', '', FileName);
        ROFactura.ClientFileName := FileName;

        ROFactura.Status := ROFactura.Status::Completed;

        ROFactura.Modify;
    end;


    procedure AddEFacturaLogEntry(DocumentVariant: Variant)
    var
        ROFacturaTransportLogEntry: Record "SSAEDE-Documents Log Entry";
        SalesHeader: Record "Sales Header";
        RecRef: RecordRef;
        FldRef: FieldRef;
    begin
        RecRef.GetTable(DocumentVariant);

        ROFacturaTransportLogEntry.LockTable;
        if RecRef.FindSet then
            repeat
                Clear(ROFacturaTransportLogEntry);
                ROFacturaTransportLogEntry.RecordID := RecRef.RecordId;
                case RecRef.Number of
                    DATABASE::"Sales Invoice Header":
                        begin
                            ROFacturaTransportLogEntry."Document Type" := ROFacturaTransportLogEntry."Document Type"::"Sales Invoice";
                            FldRef := RecRef.Field(SalesHeader.FieldNo("No."));
                            ROFacturaTransportLogEntry."Document No." := FldRef.Value;
                            FldRef := RecRef.Field(SalesHeader.FieldNo("Sell-to Customer No."));
                            ROFacturaTransportLogEntry."Customer No." := FldRef.Value;
                        end;
                    DATABASE::"Sales Cr.Memo Header":
                        begin
                            ROFacturaTransportLogEntry."Document Type" := ROFacturaTransportLogEntry."Document Type"::"Sales Credit Memo";
                            FldRef := RecRef.Field(SalesHeader.FieldNo("No."));
                            ROFacturaTransportLogEntry."Document No." := FldRef.Value;
                            FldRef := RecRef.Field(SalesHeader.FieldNo("Sell-to Customer No."));
                            ROFacturaTransportLogEntry."Customer No." := FldRef.Value;
                        end;
                end;
                ROFacturaTransportLogEntry."Creation Date" := Today;
                ROFacturaTransportLogEntry."Creation Time" := Time;
                ROFacturaTransportLogEntry."Entry Type" := ROFacturaTransportLogEntry."Entry Type"::"Export E-Factura";
                ROFacturaTransportLogEntry.Insert(true);
            until RecRef.Next = 0;
    end;


    procedure GenerateXMLFile(VariantRec: Variant; var _TempBlob: Codeunit "Temp Blob")
    var
        EFacturaXML: XmlPort "SSAEDE-Factura";
        OutStream: OutStream;
    begin
        _TempBlob.CreateOutStream(OutStream);
        EFacturaXML.Initialize(VariantRec);
        EFacturaXML.SetDestination(OutStream);
        EFacturaXML.Export;

        ProcessXMLFile(_TempBlob);
    end;

    procedure ProcessXMLFile(var _TempBlob: Codeunit "Temp Blob")
    var
        XMLDomManagement: Codeunit "XML DOM Management";
        XMLInStream: InStream;
        TempBlobProcessed: Codeunit "Temp Blob";
        TempBlobXSL: Codeunit "Temp Blob";
        ProcessedOutStream: OutStream;
        ProcessedInStream: InStream;
        XSLOutStream: OutStream;
        XSLInStream: InStream;
        FinalOutStream: OutStream;
    begin
        TempBlobXSL.CreateOutStream(XSLOutStream);
        XSLOutStream.WriteText(GetXSLText);
        TempBlobXSL.CreateInStream(XSLInStream);

        _TempBlob.CreateInStream(XMLInStream);
        TempBlobProcessed.CreateOutStream(ProcessedOutStream);

        if not XMLDomManagement.TryTransformXMLToOutStream(XMLInStream, XSLInStream, ProcessedOutStream) then
            Error(GetLastErrorText());
        TempBlobProcessed.CreateInStream(ProcessedInStream);
        _TempBlob.CreateOutStream(FinalOutStream);
        CopyStream(FinalOutStream, ProcessedInStream);
    end;

    local procedure GetXSLText(): Text
    begin
        exit(
            '<?xml version="1.0" encoding="UTF-8"?>' +
            '<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">' +
            '<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>' +
            '<xsl:template match="node()">' +
                '<xsl:if test="normalize-space(string(.)) != ''''' +
                                'or count(@*[normalize-space(string(.)) != '''']) > 0' +
                                'or count(descendant::*[normalize-space(string(.)) != '''']) > 0' +
                                'or count(descendant::*/@*[normalize-space(string(.)) != '''']) > 0">' +
                    '<xsl:copy>' +
                        '<xsl:apply-templates select="@*|node()"/>' +
                    '</xsl:copy>' +
                '</xsl:if>' +
            '</xsl:template>' +
            '<xsl:template match="@*">' +
                '<xsl:if test="normalize-space(string(.)) != ''''">' +
                    '<xsl:copy>' +
                        '<xsl:apply-templates select="@*"/>' +
                    '</xsl:copy>' +
                '</xsl:if>' +
            '</xsl:template>' +
        '</xsl:stylesheet>'
                );

    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", OnBeforePostSalesDoc, '', false, false)]
    local procedure TestPostingDate_OnBeforePostSalesDoc(var SalesHeader: Record "Sales Header")
    var
        EFTSetupLocal: Record "SSAEDEDocuments Setup";
        ReversedDaysLbl: Label '<-%1D>', Locked = true;
        ErrorLbl: Label 'You cannot Invoice document older than %1 days.', Comment = '%1 = No. of Days';
    begin
        if not SalesHeader.Invoice then
            exit;

        EFTSetupLocal.SetLoadFields("Block Posting Sales Doc Before");
        EFTSetupLocal.Get();

        if SalesHeader."Posting Date" < CalcDate(StrSubstNo(ReversedDaysLbl, EFTSetupLocal."Block Posting Sales Doc Before"), Today) then
            Error(ErrorLbl, EFTSetupLocal."Block Posting Sales Doc Before");
    end;

    [EventSubscriber(ObjectType::Codeunit, 80, 'OnAfterFinalizePostingOnBeforeCommit', '', false, false)]
    local procedure TestAnulare_OnAfterFinalizePostingOnBeforeCommit(var SalesHeader: Record "Sales Header"; var SalesShipmentHeader: Record "Sales Shipment Header"; var SalesInvoiceHeader: Record "Sales Invoice Header"; var SalesCrMemoHeader: Record "Sales Cr.Memo Header"; var ReturnReceiptHeader: Record "Return Receipt Header"; var GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line"; CommitIsSuppressed: Boolean; PreviewMode: Boolean)
    var
        ROFacturaTransportLogEntry: Record "SSAEDE-Documents Log Entry";
    begin
        if SalesHeader."SSA Stare Factura" <> SalesHeader."SSA Stare Factura"::"2-Factura Anulata" then
            exit;
        ROFacturaTransportLogEntry.SetRange("Entry Type", ROFacturaTransportLogEntry."Entry Type"::"Export E-Factura");
        if SalesHeader."Document Type" = SalesHeader."Document Type"::Invoice then
            ROFacturaTransportLogEntry.SetRange("Document Type", ROFacturaTransportLogEntry."Document Type"::"Sales Credit Memo");
        if SalesHeader."Document Type" = SalesHeader."Document Type"::"Credit Memo" then
            ROFacturaTransportLogEntry.SetRange("Document Type", ROFacturaTransportLogEntry."Document Type"::"Sales Invoice");
        ROFacturaTransportLogEntry.SetRange("Document No.", SalesHeader."Last Posting No.");
        ROFacturaTransportLogEntry.SetRange(Status, ROFacturaTransportLogEntry.Status::Completed);
        if ROFacturaTransportLogEntry.FindFirst() then
            Error('Documentul %1 %2 a fost trimis catre Anaf si nu mai poate fi anulat.', ROFacturaTransportLogEntry."Document Type", ROFacturaTransportLogEntry."Document No.");
        ROFacturaTransportLogEntry.SetRange(Status);
        ROFacturaTransportLogEntry.DeleteAll();

    end;

    [EventSubscriber(ObjectType::Codeunit, 80, 'OnAfterFinalizePostingOnBeforeCommit', '', false, false)]
    local procedure SendDocuments_OnAfterPostSalesDoc(var SalesHeader: Record "Sales Header"; var SalesShipmentHeader: Record "Sales Shipment Header"; var SalesInvoiceHeader: Record "Sales Invoice Header"; var SalesCrMemoHeader: Record "Sales Cr.Memo Header"; var ReturnReceiptHeader: Record "Return Receipt Header"; var GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line"; CommitIsSuppressed: Boolean; PreviewMode: Boolean)
    var
        Customer: Record Customer;
    begin
        if SalesHeader."Sell-to Customer No." <> SalesHeader."Bill-to Customer No." then
            exit;
        if SalesHeader."SSA Stare Factura" = SalesHeader."SSA Stare Factura"::"2-Factura Anulata" then
            exit;
        if SalesInvoiceHeader."No." <> '' then begin
            SalesInvoiceHeader.Get(SalesInvoiceHeader."No.");
            SalesInvoiceHeader.CalcFields("SSAEDProdus cu Risc");
            Customer.Get(SalesInvoiceHeader."Sell-to Customer No.");
            if Customer."SSAEDPrin EFactura" or SalesInvoiceHeader."SSAEDProdus cu Risc" then begin
                SalesInvoiceHeader.SetRecFilter;
                AddEFacturaLogEntry(SalesInvoiceHeader);
            end;
        end;

        if SalesCrMemoHeader."No." <> '' then begin
            SalesCrMemoHeader.Get(SalesCrMemoHeader."No.");
            SalesCrMemoHeader.CalcFields("SSAEDProdus cu Risc");
            Customer.Get(SalesCrMemoHeader."Sell-to Customer No.");
            if Customer."SSAEDPrin EFactura" or SalesCrMemoHeader."SSAEDProdus cu Risc" then begin
                SalesCrMemoHeader.SetRecFilter;
                AddEFacturaLogEntry(SalesCrMemoHeader);
            end;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales Inv. Header - Edit", 'OnOnRunOnBeforeTestFieldNo', '', false, false)]
    local procedure OnBeforeSalesInvoiceHeaderModify(SalesInvoiceHeaderRec: Record "Sales Invoice Header"; var SalesInvoiceHeader: Record "Sales Invoice Header")
    var
        UserSetup: Record "User Setup";
    begin
        UserSetup.Get(UserId);
        UserSetup.TestField("SSAEDAllow Edit PostedSalesDoc");

        SalesInvoiceHeader."Bill-to City" := SalesInvoiceHeaderRec."Bill-to City";
        SalesInvoiceHeader."Sell-to City" := SalesInvoiceHeaderRec."Sell-to City";
        SalesInvoiceHeader."Ship-to City" := SalesInvoiceHeaderRec."Ship-to City";
        SalesInvoiceHeader."Bill-to County" := SalesInvoiceHeaderRec."Bill-to County";
        SalesInvoiceHeader."Sell-to County" := SalesInvoiceHeaderRec."Sell-to County";
        SalesInvoiceHeader."Ship-to County" := SalesInvoiceHeaderRec."Ship-to County";
        SalesInvoiceHeader."SSAEDShip-to Sector" := SalesInvoiceHeaderRec."SSAEDShip-to Sector";
        SalesInvoiceHeader."SSAEDNr. Inmatriculare" := SalesInvoiceHeaderRec."SSAEDNr. Inmatriculare";
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales Credit Memo Hdr. - Edit", OnBeforeSalesCrMemoHeaderModify, '', false, false)]
    local procedure OnBeforeSalesCrMemoHeaderModify(var SalesCrMemoHeader: Record "Sales Cr.Memo Header"; FromSalesCrMemoHeader: Record "Sales Cr.Memo Header")
    var
        UserSetup: Record "User Setup";
    begin
        UserSetup.Get(UserId);
        UserSetup.TestField("SSAEDAllow Edit PostedSalesDoc");

        SalesCrMemoHeader."Bill-to City" := FromSalesCrMemoHeader."Bill-to City";
        SalesCrMemoHeader."Sell-to City" := FromSalesCrMemoHeader."Sell-to City";
        SalesCrMemoHeader."Ship-to City" := FromSalesCrMemoHeader."Ship-to City";
        SalesCrMemoHeader."Bill-to County" := FromSalesCrMemoHeader."Bill-to County";
        SalesCrMemoHeader."Sell-to County" := FromSalesCrMemoHeader."Sell-to County";
        SalesCrMemoHeader."Ship-to County" := FromSalesCrMemoHeader."Ship-to County";
        SalesCrMemoHeader."SSAEDShip-to Sector" := FromSalesCrMemoHeader."SSAEDShip-to Sector";
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnAfterUpdateShipToAddress', '', false, false)]
    local procedure SalesHeader_OnAfterUpdateShipToAddress(var SalesHeader: Record "Sales Header"; xSalesHeader: Record "Sales Header"; CurrentFieldNo: Integer)
    var
        Location: Record "Location";
    begin
        if not SalesHeader.IsCreditDocType then
            exit;
        if SalesHeader."Location Code" = '' then
            exit;

        Location.SetLoadFields("SSAEDSector Bucuresti");
        Location.GET(SalesHeader."Location Code");
        SalesHeader."SSAEDShip-to Sector" := Location."SSAEDSector Bucuresti";
    end;


}

