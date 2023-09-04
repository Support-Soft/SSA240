codeunit 72001 "SSAEDETransport Mgt."
{

    procedure TransferHeaderToSalesHeader(TransferShipmentHeader: Record "Transfer Shipment Header"; var ToSalesHeader: Record "Sales Header")
    var
        CompanyInfo: Record "Company Information";
        FromLocation: Record Location;
        ToLocation: Record Location;
    begin
        CompanyInfo.Get;
        FromLocation.Get(TransferShipmentHeader."Transfer-from Code");
        ToLocation.Get(TransferShipmentHeader."Transfer-to Code");
        ToSalesHeader."No." := TransferShipmentHeader."No.";
        ToSalesHeader."Posting Date" := TransferShipmentHeader."Posting Date";
        ToSalesHeader."Sell-to Customer Name" := TransferShipmentHeader."Transfer-to Name";
        ToSalesHeader."VAT Registration No." := CompanyInfo."VAT Registration No.";
        ToSalesHeader."Sell-to Country/Region Code" := ToLocation."Country/Region Code";
        ToSalesHeader."Ship-to Country/Region Code" := ToLocation."Country/Region Code";
        ToSalesHeader."Location Code" := TransferShipmentHeader."Transfer-from Code";
        ToSalesHeader."Ship-to City" := TransferShipmentHeader."Transfer-to City";
        ToSalesHeader."Ship-to County" := TransferShipmentHeader."Transfer-to County";
        ToSalesHeader."Ship-to Address" := TransferShipmentHeader."Transfer-to Address";
        ToSalesHeader."Shipping Agent Code" := TransferShipmentHeader."Shipping Agent Code";
        ToSalesHeader."VAT Bus. Posting Group" := TransferShipmentHeader."SSA Gen. Bus. Posting Group";
        ToSalesHeader."SSAEDNr. Inmatriculare" := TransferShipmentHeader."Shipping Agent Code";
    end;


    procedure TransferLineToSalesLine(TransferShipmentLine: Record "Transfer Shipment Line"; var ToSalesLine: Record "Sales Line")
    var
        Item: Record Item;
    begin
        ToSalesLine."Document No." := TransferShipmentLine."Document No.";
        ToSalesLine.Type := ToSalesLine.Type::Item;
        ToSalesLine."No." := TransferShipmentLine."Item No.";
        ToSalesLine.Description := TransferShipmentLine.Description;
        ToSalesLine.Quantity := TransferShipmentLine.Quantity;
        ToSalesLine."Quantity (Base)" := TransferShipmentLine."Quantity (Base)";
        ToSalesLine."Unit of Measure Code" := TransferShipmentLine."Unit of Measure Code";
        ToSalesLine."Net Weight" := TransferShipmentLine."Net Weight";
        ToSalesLine."Gross Weight" := TransferShipmentLine."Gross Weight";
        Item.Get(TransferShipmentLine."Item No.");
        ToSalesLine."Unit Price" := Item."Unit Cost";
        ToSalesLine.Amount := ToSalesLine."Unit Price" * ToSalesLine.Quantity;
        ToSalesLine."VAT Prod. Posting Group" := Item."VAT Prod. Posting Group";
    end;

    procedure FindNextInvoiceRec(var SalesShipmentHeader: Record "Sales Shipment Header"; var SalesInvoiceHeader: Record "Sales Invoice Header"; var TransferShipmentHeader: Record "Transfer Shipment Header"; var SalesHeader: Record "Sales Header"; ProcessedDocType: Option "Sales Invoice","Sales Shipment","Transfer Shipment"; Position: Integer): Boolean
    var
        Found: Boolean;
    begin
        case ProcessedDocType of
            ProcessedDocType::"Sales Invoice":
                begin
                    if Position = 1 then
                        Found := SalesInvoiceHeader.Find('-')
                    else
                        Found := SalesInvoiceHeader.Next <> 0;
                    if Found then
                        SalesHeader.TransferFields(SalesInvoiceHeader);
                end;
            ProcessedDocType::"Sales Shipment":
                begin
                    if Position = 1 then
                        Found := SalesShipmentHeader.Find('-')
                    else
                        Found := SalesShipmentHeader.Next <> 0;
                    if Found then
                        SalesHeader.TransferFields(SalesShipmentHeader);
                end;
            ProcessedDocType::"Transfer Shipment":
                begin
                    if Position = 1 then
                        Found := TransferShipmentHeader.Find('-')
                    else
                        Found := TransferShipmentHeader.Next <> 0;
                    if Found then
                        TransferHeaderToSalesHeader(TransferShipmentHeader, SalesHeader);
                end;
        end;
        SalesHeader."Document Type" := SalesHeader."Document Type"::Invoice;

        exit(Found);
    end;

    procedure FindNextInvoiceLineRec(var SalesShipmentLine: Record "Sales Shipment Line"; var SalesInvoiceLine: Record "Sales Invoice Line"; var TransferShipmentLine: Record "Transfer Shipment Line"; var SalesLine: Record "Sales Line"; ProcessedDocType: Option "Sales Invoice","Sales Shipment","Transfer Shipment"; Position: Integer): Boolean
    var
        Found: Boolean;
    begin
        case ProcessedDocType of
            ProcessedDocType::"Sales Invoice":
                begin
                    if Position = 1 then
                        Found := SalesInvoiceLine.Find('-')
                    else
                        Found := SalesInvoiceLine.Next <> 0;
                    if Found then
                        SalesLine.TransferFields(SalesInvoiceLine);
                end;
            ProcessedDocType::"Sales Shipment":
                begin
                    if Position = 1 then
                        Found := SalesShipmentLine.Find('-')
                    else
                        Found := SalesShipmentLine.Next <> 0;
                    if Found then
                        SalesLine.TransferFields(SalesShipmentLine);
                    SalesLine.Amount := SalesLine.Quantity * SalesLine."Unit Price";
                end;
            ProcessedDocType::"Transfer Shipment":
                begin
                    if Position = 1 then
                        Found := TransferShipmentLine.Find('-')
                    else
                        Found := TransferShipmentLine.Next <> 0;
                    if Found then
                        TransferLineToSalesLine(TransferShipmentLine, SalesLine);
                end;
        end;

        exit(Found);
    end;


    procedure GetJudet(_Judet: Text): Integer
    begin
        case UpperCase(_Judet) of
            'ALBA':
                exit(1);
            'ARAD':
                exit(2);
            'ARGES':
                exit(3);
            'BACAU',
            'BACĂU':
                exit(4);
            'BIHOR':
                exit(5);
            'BISTRITA-NASAUD',
            'BISTRITA NASAUD',
            'BISTRIŢA-NĂSĂUD':
                exit(6);
            'BOTOSANI',
            'BOTOŞANI':
                exit(7);
            'BRASOV',
            'BRAŞOV':
                exit(8);
            'BRAILA',
            'BRĂILA':
                exit(9);
            'BUZAU',
            'BUZĂU':
                exit(10);
            'CARAS-SEVERIN',
            'CARAS SEVERIN',
            'CARAŞ-SEVERIN',
            'CARAŞ SEVERIN':
                exit(11);
            'CALARASI',
            'CĂLĂRAŞI':
                exit(51);
            'CLUJ':
                exit(12);
            'CONSTANTA',
            'CONSTANŢA':
                exit(13);
            'COVASNA':
                exit(14);
            'DAMBOVITA',
            'DÂMBOVIŢA':
                exit(15);
            'DOLJ':
                exit(16);
            'GALATI',
            'GALAŢI':
                exit(17);
            'GIURGIU':
                exit(52);
            'GORJ':
                exit(18);
            'HARGHITA':
                exit(19);
            'HUNEDOARA':
                exit(20);
            'IALOMITA',
            'IALOMIŢA':
                exit(21);
            'IASI',
            'IAŞI':
                exit(22);
            'ILFOV':
                exit(23);
            'MARAMURES',
            'MARAMUREŞ':
                exit(24);
            'MEHEDINTI',
            'MEHEDINŢI':
                exit(25);
            'MURES',
            'MUREŞ':
                exit(26);
            'NEAMT',
            'NEAMŢ':
                exit(27);
            'OLT':
                exit(28);
            'PRAHOVA':
                exit(29);
            'SATU MARE':
                exit(30);
            'SALAJ':
                exit(31);
            'SIBIU':
                exit(32);
            'SUCEAVA':
                exit(33);
            'TELEORMAN':
                exit(34);
            'TIMIS',
            'TIMIŞ':
                exit(35);
            'TULCEA':
                exit(36);
            'VASLUI':
                exit(37);
            'VALCEA',
            'VÂLCEA':
                exit(38);
            'VRANCEA':
                exit(39);
            'BUCURESTI',
            'BUCUREŞTI',
            'MUNICIPIUL BUCUREŞTI',
            'MUNICIPIUL BUCURESTI':
                exit(40);
            else
                exit(0);
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnAfterCopyShipToCustomerAddressFieldsFromCustomer', '', false, false)]
    local procedure ShipToSector_OnAfterCopyShipToCustomerAddressFieldsFromCustomer(var SalesHeader: Record "Sales Header"; SellToCustomer: Record Customer)
    begin
        //SSM1997>>
        SalesHeader."SSAEDShip-to Sector" := SellToCustomer."SSAEDSector Bucuresti";
        //SSM1997<<
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnAfterCopyShipToCustomerAddressFieldsFromShipToAddr', '', false, false)]
    local procedure ShipToSector_OnAfterCopyShipToCustomerAddressFieldsFromShipToAddr(var SalesHeader: Record "Sales Header"; ShipToAddress: Record "Ship-to Address")
    begin
        //SSM1997>>
        SalesHeader."SSAEDShip-to Sector" := ShipToAddress."SSAEDSector Bucuresti";
        //SSM1997<<
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnAfterAssignItemValues', '', false, false)]
    local procedure ProdusCuRisc_OnAfterAssignItemValues(var SalesLine: Record "Sales Line"; Item: Record Item)
    begin
        //SSM1997>>
        SalesLine."SSAEDProdus cu Risc" := Item."SSAEDProdus cu Risc";
        //SSM1997<<
    end;

    [EventSubscriber(ObjectType::Codeunit, codeunit::"Shipment Header - Edit", 'OnBeforeSalesShptHeaderModify', '', false, false)]
    local procedure OnBeforeSalesShptHeaderModify(FromSalesShptHeader: Record "Sales Shipment Header"; var SalesShptHeader: Record "Sales Shipment Header")
    begin
        //SSM1997>>
        SalesShptHeader."SSAEDNr. Inmatriculare" := FromSalesShptHeader."SSAEDNr. Inmatriculare";
        //SSM1997<<
    end;

}

