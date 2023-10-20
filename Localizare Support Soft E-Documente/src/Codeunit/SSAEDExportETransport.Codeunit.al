codeunit 72000 "SSAEDExport ETransport"
{
    TableNo = "SSAEDE-Documents Log Entry";

    trigger OnRun()
    var
        SalesShipmentHeader: Record "Sales Shipment Header";
        SalesInvoiceHeader: Record "Sales Invoice Header";
        TransferShipmentHeader: Record "Transfer Shipment Header";
        RecordRef: RecordRef;
        TempBlob: Codeunit "Temp Blob";
        InStr: InStream;
        FileName: Text;
    begin
        RecordRef.Get(Rec.RecordID);
        case RecordRef.Number of
            DATABASE::"Sales Shipment Header":
                begin
                    RecordRef.SetTable(SalesShipmentHeader);
                    GenerateXMLFile(SalesShipmentHeader, TempBlob);
                    FileName := 'SalesShipment_' + SalesShipmentHeader."No." + '.xml';
                end;
            DATABASE::"Sales Invoice Header":
                begin
                    RecordRef.SetTable(SalesInvoiceHeader);
                    GenerateXMLFile(SalesInvoiceHeader, TempBlob);
                    FileName := 'SalesInvoice_' + SalesInvoiceHeader."No." + '.xml';
                end;
            DATABASE::"Transfer Shipment Header":
                begin
                    RecordRef.SetTable(TransferShipmentHeader);
                    GenerateXMLFile(TransferShipmentHeader, TempBlob);
                    FileName := 'TransferShipment_' + TransferShipmentHeader."No." + '.xml';
                end;
            else
                Error('Not allowed %1', RecordRef.Number);
        end;
        Rec.Status := Rec.Status::Completed;

        Rec.Modify;
        TempBlob.CreateInStream(InStr);
        DownloadFromStream(InStr, 'Save XML File', '', '', FileName);
    end;

    var
        SpecifyASalesInvoiceNoErr: Label 'You must specify a sales invoice number.';
        UnSupportedTableTypeErr: Label 'The %1 table is not supported.', Comment = '%1 is the table.';
        SpecifyASalesShipmentNoErr: Label 'You must specify a sales Shipment number.';
        SpecifyATransferShipmentNoErr: Label 'You must specify a Transfer Shipment number.';


    procedure AddETransportLogEntry(DocumentVariant: Variant)
    var
        ETransportLogEntry: Record "SSAEDE-Documents Log Entry";
        SalesHeader: Record "Sales Header";
        TransferHeader: Record "Transfer Header";
        RecRef: RecordRef;
        FldRef: FieldRef;
    begin
        ValidateData(DocumentVariant);

        RecRef.GetTable(DocumentVariant);

        ETransportLogEntry.LockTable;
        if RecRef.FindSet then
            repeat
                Clear(ETransportLogEntry);
                ETransportLogEntry.RecordID := RecRef.RecordId;
                case RecRef.Number of
                    DATABASE::"Sales Shipment Header":
                        begin
                            ETransportLogEntry."Document Type" := ETransportLogEntry."Document Type"::"Sales Shipment";
                            FldRef := RecRef.Field(SalesHeader.FieldNo("No."));
                            ETransportLogEntry."Document No." := FldRef.Value;
                            FldRef := RecRef.Field(SalesHeader.FieldNo("Sell-to Customer No."));
                            ETransportLogEntry."Customer No." := FldRef.Value;
                        end;
                    DATABASE::"Sales Invoice Header":
                        begin
                            ETransportLogEntry."Document Type" := ETransportLogEntry."Document Type"::"Sales Invoice";
                            FldRef := RecRef.Field(SalesHeader.FieldNo("No."));
                            ETransportLogEntry."Document No." := FldRef.Value;
                            FldRef := RecRef.Field(SalesHeader.FieldNo("Sell-to Customer No."));
                            ETransportLogEntry."Customer No." := FldRef.Value;
                        end;
                    DATABASE::"Transfer Shipment Header":
                        begin
                            ETransportLogEntry."Document Type" := ETransportLogEntry."Document Type"::"Transfer Shipment";
                            FldRef := RecRef.Field(TransferHeader.FieldNo("No."));
                            ETransportLogEntry."Document No." := FldRef.Value;
                        end;
                end;
                ETransportLogEntry."Creation Date" := Today;
                ETransportLogEntry."Creation Time" := Time;
                ETransportLogEntry."Entry Type" := ETransportLogEntry."Entry Type"::"Export E-Transport";
                ETransportLogEntry.Insert(true);
            until RecRef.Next = 0;
    end;


    procedure GenerateXMLFile(VariantRec: Variant; var _TempBlob: Codeunit "Temp Blob")
    var
        ETransportXML: XmlPort "SSAEDE-Transport";
        OutStream: OutStream;
    begin
        _TempBlob.CreateOutStream(OutStream);
        ETransportXML.Initialize(VariantRec);
        ETransportXML.SetDestination(OutStream);
        ETransportXML.Export;
    end;

    procedure ValidateData(_DocVariant: Variant)
    var
        SH: Record "Sales Header";
        SalesShipmentLine: Record "Sales Shipment Line";
        SalesInvoiceLine: Record "Sales Invoice Line";
        TransferShipmentLine: Record "Transfer Shipment Line";
        SL: Record "Sales Line";
        CompanyInfo: Record "Company Information";
        VATPostingSetup: Record "VAT Posting Setup";
        Item: Record Item;
        UnitofMeasure: Record "Unit of Measure";
        CountryRegion: Record "Country/Region";
        Location: Record Location;
        ShippingAgent: Record "Shipping Agent";
        ETransportMgt: Codeunit "SSAEDETransport Mgt.";
        i: Integer;
        ProcessedDocType: Option "Sales Invoice","Sales Shipment","Transfer Shipment";
        ValidItemFound: Boolean;
    begin
        InitializeValidateData(_DocVariant, SH, SalesShipmentLine, SalesInvoiceLine, TransferShipmentLine, ProcessedDocType);

        CompanyInfo.Get;
        CompanyInfo.TestField("VAT Registration No.");

        SH.TestField("Sell-to Customer Name");
        SH.TestField("VAT Registration No.");
        CountryRegion.Get(SH."Sell-to Country/Region Code");
        CountryRegion.TestField("ISO Code");
        //
        // ShippingAgent.GET(SH."Shipping Agent Code");
        // IF ShippingAgent."Agent Vanzari" THEN BEGIN
        //  SalespersonPurchaser.GET(SH."Salesperson Code");
        //  SalespersonPurchaser.TESTFIELD("Nr. Masina");
        // END;

        SH.TestField("SSAEDNr. Inmatriculare");

        SH.TestField("Ship-to Country/Region Code");
        ShippingAgent.Get(SH."Shipping Agent Code");
        ShippingAgent.TestField(Name);
        SH.TestField("Posting Date");

        if ETransportMgt.GetJudet(SH."Ship-to County") = 0 then
            Error('Judetul %1 nu a fost gasit in lista', SH."Ship-to County");
        SH.TestField("Ship-to City");
        SH.TestField("Ship-to Address");

        Location.Get(SH."Location Code");
        Location.TestField(City);
        if ETransportMgt.GetJudet(Location.County) = 0 then
            Error('Judetul %1 nu a fost gasit in lista', Location.County);
        Location.TestField(Address);

        i := 1;
        Clear(ValidItemFound);
        while ETransportMgt.FindNextInvoiceLineRec(SalesShipmentLine, SalesInvoiceLine, TransferShipmentLine, SL, ProcessedDocType, i) do begin
            if i = 1 then begin
                VATPostingSetup.Get(SH."VAT Bus. Posting Group", SL."VAT Prod. Posting Group");
                VATPostingSetup.TestField("SSAEDET codTipOperatiune");
            end;
            Item.Get(SL."No.");
            if not ValidItemFound then
                ValidItemFound := Item."SSAEDProdus cu Risc";
            Item.TestField("Tariff No.");
            SL.TestField(Description);
            UnitofMeasure.Get(SL."Unit of Measure Code");
            UnitofMeasure.TestField("International Standard Code");
            SL.TestField("Net Weight");
            SL.TestField("Gross Weight");

            i += 1;
        end;

        if not ValidItemFound then
            Error('Nu a fost gasit un articol eligibil pentru E-Transport.');
    end;

    local procedure InitializeValidateData(DocVariant: Variant; var SalesHeader: Record "Sales Header"; var SalesShipmentLine: Record "Sales Shipment Line"; var SalesInvoiceLine: Record "Sales Invoice Line"; var TransferShipmentLine: Record "Transfer Shipment Line"; var ProcessedDocType: Option "Sales Invoice","Sales Shipment","Transfer Shipment")
    var
        RecRef: RecordRef;
        SalesShipmentHeader: Record "Sales Shipment Header";
        SalesInvoiceHeader: Record "Sales Invoice Header";
        TransferShipmentHeader: Record "Transfer Shipment Header";
        ETransportMgt: Codeunit "SSAEDETransport Mgt.";
    begin
        RecRef.GetTable(DocVariant);
        case RecRef.Number of
            DATABASE::"Sales Invoice Header":
                begin
                    RecRef.SetTable(SalesInvoiceHeader);
                    if SalesInvoiceHeader."No." = '' then
                        Error(SpecifyASalesInvoiceNoErr);
                    SalesInvoiceHeader.SetRecFilter;
                    SalesInvoiceLine.SetRange("Document No.", SalesInvoiceHeader."No.");
                    SalesInvoiceLine.SetRange(Type, SalesInvoiceLine.Type::Item);
                    SalesInvoiceLine.SetFilter(Quantity, '<>%1', 0);

                    ProcessedDocType := ProcessedDocType::"Sales Invoice";
                end;
            DATABASE::"Sales Shipment Header":
                begin
                    RecRef.SetTable(SalesShipmentHeader);
                    if SalesShipmentHeader."No." = '' then
                        Error(SpecifyASalesShipmentNoErr);
                    SalesShipmentHeader.SetRange("No.", SalesShipmentHeader."No.");
                    SalesShipmentHeader.SetRecFilter;
                    SalesShipmentLine.SetRange("Document No.", SalesShipmentHeader."No.");
                    SalesShipmentLine.SetRange(Type, SalesShipmentLine.Type::Item);
                    SalesShipmentLine.SetFilter(Quantity, '<>%1', 0);

                    ProcessedDocType := ProcessedDocType::"Sales Shipment";
                end;
            DATABASE::"Transfer Shipment Header":
                begin
                    RecRef.SetTable(TransferShipmentHeader);
                    if TransferShipmentHeader."No." = '' then
                        Error(SpecifyATransferShipmentNoErr);
                    TransferShipmentHeader.SetRange("No.", TransferShipmentHeader."No.");
                    TransferShipmentHeader.SetRecFilter;
                    TransferShipmentLine.SetRange("Document No.", TransferShipmentHeader."No.");
                    TransferShipmentLine.SetFilter(Quantity, '<>%1', 0);

                    ProcessedDocType := ProcessedDocType::"Transfer Shipment";
                end;
            else
                Error(UnSupportedTableTypeErr, RecRef.Number);
        end;

        ETransportMgt.FindNextInvoiceRec(SalesShipmentHeader, SalesInvoiceHeader, TransferShipmentHeader, SalesHeader, ProcessedDocType, 1);
    end;
}

