xmlport 72000 "SSAEDE-Transport"
{
    Caption = 'E-Transport';
    Direction = Export;
    Encoding = UTF8;
    Namespaces = "" = 'mfp:anaf:dgti:eTransport:declaratie:v1', xsi = 'http://www.w3.org/2001/XMLSchema-instance', schemaLocation = 'mfp:anaf:dgti:eTransport:declaratie:v1 file:/D:/formInteractive/_inLucru/_proiecte/eTransport/final/SchemaSimtic_model_2022_03_15.xsd';

    schema
    {
        tableelement(shipmentheaderloop; Integer)
        {
            MaxOccurs = Once;
            XmlName = 'eTransport';
            SourceTableView = sorting(Number) where(Number = filter(1 ..));
            textattribute(codDeclarant)
            {
            }
            textelement(notificare)
            {
                textattribute(codTipOperatiune)
                {
                }
                tableelement(shipmentlineloop; Integer)
                {
                    XmlName = 'bunuriTransportate';
                    SourceTableView = sorting(Number) where(Number = filter(1 ..));
                    textattribute(bt_nrcrt)
                    {
                        XmlName = 'nrCrt';
                    }
                    textattribute(bt_codtarifar)
                    {
                        XmlName = 'codTarifar';
                    }
                    textattribute(bt_denumiremarfa)
                    {
                        XmlName = 'denumireMarfa';
                    }
                    textattribute(bt_codscopoperatiune)
                    {
                        XmlName = 'codScopOperatiune';
                    }
                    textattribute(bt_cantitate)
                    {
                        XmlName = 'cantitate';
                    }
                    textattribute(bt_codunitatemasura)
                    {
                        XmlName = 'codUnitateMasura';
                    }
                    textattribute(bt_greutateneta)
                    {
                        XmlName = 'greutateNeta';
                    }
                    textattribute(bt_greutatebruta)
                    {
                        XmlName = 'greutateBruta';
                    }
                    textattribute(bt_valoareleifaratva)
                    {
                        XmlName = 'valoareLeiFaraTva';
                    }

                    trigger OnAfterGetRecord()
                    begin
                        if not FindNextInvoiceLineRec(ShipmentLineLoop.Number) then
                            currXMLport.Break;

                        BT_nrCrt := Format(ShipmentLineLoop.Number);
                        Item.Get(SalesLine."No.");
                        BT_codTarifar := Item."Tariff No.";
                        BT_denumireMarfa := SalesLine.Description;
                        if VATPostingSetup."SSAEDET codTipOperatiune" = '30' then begin
                            if ProcessedDocType in [ProcessedDocType::"Sales Shipment", ProcessedDocType::"Sales Invoice"] then
                                BT_codScopOperatiune := '300101';
                            if ProcessedDocType = ProcessedDocType::"Transfer Shipment" then
                                BT_codScopOperatiune := '300704';
                        end;
                        BT_cantitate := Format(SalesLine.Quantity, 0, 9);
                        UnitofMeasure.Get(SalesLine."Unit of Measure Code");
                        BT_codUnitateMasura := UnitofMeasure."International Standard Code";
                        BT_greutateNeta := Format(SalesLine."Net Weight", 0, 9);
                        BT_greutateBruta := Format(SalesLine."Gross Weight", 0, 9);
                        BT_valoareLeiFaraTva := Format(SalesLine.Amount, 0, 9);
                    end;
                }
                textelement(partenerComercial)
                {
                    textattribute(partenercomercial_codtara)
                    {
                        XmlName = 'codTara';
                    }
                    textattribute(partenercomercial_cod)
                    {
                        XmlName = 'cod';
                    }
                    textattribute(partenercomercial_denumire)
                    {
                        XmlName = 'denumire';
                    }
                }
                textelement(dateTransport)
                {
                    textattribute(datetransport_nrvehicul)
                    {
                        XmlName = 'nrVehicul';
                    }
                    textattribute(datetransport_codtara)
                    {
                        XmlName = 'codTaraTransportator';
                    }
                    textattribute(datetransport_codtransportator)
                    {
                        XmlName = 'codTransportator';
                    }
                    textattribute(datetransport_denumire)
                    {
                        XmlName = 'denumireTransportator';
                    }
                    textattribute(datetransport_datatransport)
                    {
                        XmlName = 'dataTransport';
                    }
                }
                textelement(locIncarcare)
                {
                    textattribute(locinc_codjudet)
                    {
                        XmlName = 'codJudet';
                    }
                    textattribute(locinc_denumirelocalitate)
                    {
                        XmlName = 'denumireLocalitate';
                    }
                    textattribute(locinc_denumirestrada)
                    {
                        XmlName = 'denumireStrada';
                    }
                }
                textelement(locDescarcare)
                {
                    textattribute(locdesc_codjudet)
                    {
                        XmlName = 'codJudet';
                    }
                    textattribute(locdesc_denumirelocalitate)
                    {
                        XmlName = 'denumireLocalitate';
                    }
                    textattribute(locdesc_denumirestrada)
                    {
                        XmlName = 'denumireStrada';
                    }
                }
                textelement(documenteTransport)
                {
                    textattribute(doctrans_tipdocument)
                    {
                        XmlName = 'tipDocument';
                    }
                    textattribute(doctrans_datadocument)
                    {
                        XmlName = 'dataDocument';
                    }
                }
            }

            trigger OnAfterGetRecord()
            begin
                if not FindNextInvoiceRec(ShipmentHeaderLoop.Number) then
                    currXMLport.Break;

                if not FindNextInvoiceLineRec(1) then;

                CompanyInfo.Get;
                codDeclarant := DelChr(CompanyInfo."VAT Registration No.", '=', CompanyInfo."Country/Region Code");
                VATPostingSetup.Get(SalesHeader."VAT Bus. Posting Group", SalesLine."VAT Prod. Posting Group");
                codTipOperatiune := VATPostingSetup."SSAEDET codTipOperatiune";

                partenerComercial_denumire := SalesHeader."Sell-to Customer Name";
                partenerComercial_cod := SalesHeader."VAT Registration No.";
                CountryRegion.Get(SalesHeader."Sell-to Country/Region Code");
                partenerComercial_codTara := CountryRegion."ISO Code";

                ShippingAgent.Get(SalesHeader."Shipping Agent Code");
                dateTransport_nrVehicul := SalesHeader."SSAEDNr. Inmatriculare";

                dateTransport_codTara := SalesHeader."Ship-to Country/Region Code";
                dateTransport_denumire := ShippingAgent.Name;
                dateTransport_dataTransport := Format(SalesHeader."Posting Date", 0, 9);

                Location.Get(SalesHeader."Location Code");
                locInc_codJudet := Format(ETransportMgt.GetJudet(Location.County));
                locInc_denumireLocalitate := Location.City;
                locInc_denumireStrada := Location.Address;

                locDesc_codJudet := Format(ETransportMgt.GetJudet(SalesHeader."Ship-to County"));
                locDesc_denumireLocalitate := SalesHeader."Ship-to City";
                locDesc_denumireStrada := SalesHeader."Ship-to Address";

                case ProcessedDocType of
                    ProcessedDocType::"Sales Shipment":
                        DocTrans_tipDocument := '30';
                    ProcessedDocType::"Sales Invoice":
                        DocTrans_tipDocument := '20';
                    ProcessedDocType::"Transfer Shipment":
                        DocTrans_tipDocument := '30';
                end;
                DocTrans_dataDocument := Format(SalesHeader."Posting Date", 0, 9);
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
                    field(SalesInvoiceHeader_No; SalesInvoiceHeader."No.")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Sales Invoice No.';
                        TableRelation = "Sales Invoice Header";
                        ToolTip = 'Enter the sales invoice number to be exported.';
                    }
                }
            }
        }

        actions
        {
        }
    }

    var
        SalesShipmentHeader: Record "Sales Shipment Header";
        SalesInvoiceHeader: Record "Sales Invoice Header";
        TransferShipmentHeader: Record "Transfer Shipment Header";
        SalesShipmentLine: Record "Sales Shipment Line";
        SalesInvoiceLine: Record "Sales Invoice Line";
        TransferShipmentLine: Record "Transfer Shipment Line";
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
        CompanyInfo: Record "Company Information";
        VATPostingSetup: Record "VAT Posting Setup";
        Item: Record Item;
        UnitofMeasure: Record "Unit of Measure";
        CountryRegion: Record "Country/Region";
        Location: Record Location;
        ShippingAgent: Record "Shipping Agent";
        ETransportMgt: Codeunit "SSAEDETransport Mgt.";
        SpecifyASalesInvoiceNoErr: Label 'You must specify a sales invoice number.';
        UnSupportedTableTypeErr: Label 'The %1 table is not supported.', Comment = '%1 is the table.';
        ProcessedDocType: Option "Sales Invoice","Sales Shipment","Transfer Shipment";
        SpecifyASalesShipmentNoErr: Label 'You must specify a sales Shipment number.';
        SpecifyATransferShipmentNoErr: Label 'You must specify a Transfer Shipment number.';

    local procedure FindNextInvoiceRec(Position: Integer): Boolean
    begin
        exit(
          ETransportMgt.FindNextInvoiceRec(SalesShipmentHeader, SalesInvoiceHeader, TransferShipmentHeader, SalesHeader, ProcessedDocType, Position));
    end;

    local procedure FindNextInvoiceLineRec(Position: Integer): Boolean
    begin
        exit(
          ETransportMgt.FindNextInvoiceLineRec(SalesShipmentLine, SalesInvoiceLine, TransferShipmentLine, SalesLine, ProcessedDocType, Position));
    end;

    procedure Initialize(DocVariant: Variant)
    var
        RecRef: RecordRef;
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
    end;
}

