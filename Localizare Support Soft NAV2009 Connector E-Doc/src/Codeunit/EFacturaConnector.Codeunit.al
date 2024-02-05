codeunit 72300 "SSAEDNEFactura Connector"
{
    procedure SetData(XML: Text): Text
    var
        EFTDoc: Record "SSAEDE-Documents Log Entry";
        LastEntryNo: Integer;
    begin

        EFTDoc.LockTable();
        EFTDoc.Reset;
        if EFTDoc.FindLast() then
            LastEntryNo := EFTDoc."Entry No."
        else
            LastEntryNo := 0;

        LastEntryNo += 1;
        EFTDoc.Init();
        EFTDoc."Entry No." := LastEntryNo;
        EFTDoc."Entry Type" := EFTDoc."Entry Type"::"Export E-Factura";
        EFTDoc.Insert(true);
        EFTDoc.SetXMLContent(XML);
        EFTDoc.Modify(true);
        exit(Format(EFTDoc."Entry No."));
    end;

    procedure GetDataEntriesList(LastDT: DateTime) Response: Text
    var
        EFTDoc: Record "SSAEDE-Documents Log Entry";
        EFTDocDetails: Record "SSAEDE-Documents Details";
        XMLBuffer: Record "XML Buffer" temporary;
        TempBlob: Codeunit "Temp Blob";
        InStr: InStream;

    begin
        XMLBuffer.Reset();
        XMLBuffer.DeleteAll();

        EFTDoc.Reset;
        //EFTDoc.SetCurrentKey("Entry Type", Status, "Stare Mesaj");
        if LastDT <> 0DT then
            EFTDoc.SetFilter(SystemModifiedAt, '>%1', LastDT);
        EFTDoc.SetRange("Entry Type", EFTDoc."Entry Type"::"Import E-Factura");
        EFTDoc.Setrange(Status, EFTDoc.Status::Completed);
        if EFTDoc.FindSet() then begin
            XMLBuffer.AddGroupElement('EFT');
            repeat
                XMLBuffer.AddGroupElement('EFTDoc');
                XMLBuffer.AddElement('Id', Format(EFTDoc."Entry No."));
                XMLBuffer.AddElement('Status', Format(EFTDoc."Status"));
                XMLBuffer.AddElement('ErrorMessage', EFTDoc."Error Message");
                XMLBuffer.AddElement('CreationDate', Format(EFTDoc."Creation Date", 0, 9));
                XMLBuffer.AddElement('CreationTime', Format(EFTDoc."Creation Time", 0, 9));
                XMLBuffer.AddElement('IndexIncarcare', Format(EFTDoc."Index Incarcare"));
                XMLBuffer.AddElement('IDDescarcare', Format(EFTDoc."ID Descarcare"));
                XMLBuffer.AddElement('Description', EFTDoc."Description");
                XMLBuffer.AddElement('IssueDate', Format(EFTDoc."Issue Date", 0, 9));
                XMLBuffer.AddElement('DocumentCurrency', EFTDoc."Document Currency Code");
                XMLBuffer.AddElement('SupplierID', EFTDoc."Supplier ID");
                XMLBuffer.AddElement('SupplierName', EFTDoc."Supplier Name");
                XMLBuffer.AddElement('NAVVendorNo.', EFTDoc."NAV Vendor No.");
                XMLBuffer.AddElement('NAVVendorName', EFTDoc."NAV Vendor Name");
                XMLBuffer.AddElement('TotalTaxAmount', Format(EFTDoc."Total Tax Amount", 0, 9));
                XMLBuffer.AddElement('TotalTaxInclAmount', Format(EFTDoc."Total TaxInclusiveAmount", 0, 9));
                XMLBuffer.AddElement('TotalTaxExclAmount', Format(EFTDoc."Total TaxExclusiveAmount", 0, 9));
                XMLBuffer.AddElement('DueDate', Format(EFTDoc."Due Date", 0, 9));
                XMLBuffer.AddElement('VendorInvoiceNo', EFTDoc."Vendor Invoice No.");
                XMLBuffer.AddElement('PaymentMethod', Format(EFTDoc."Payment Method Code"));
                XMLBuffer.AddElement('XMLFile', EFTDoc.GetXMLContent());
                EFTDocDetails.SetRange("Log Entry No.", EFTDoc."Entry No.");
                if EFTDocDetails.FindSet() then begin
                    XMLBuffer.AddGroupElement('EFTLines');
                    repeat
                        XMLBuffer.AddGroupElement('EFTDocLine');
                        XMLBuffer.AddElement('TypeOfLine', Format(EFTDocDetails."Type Of Line"));
                        XMLBuffer.AddElement('LineID', Format(EFTDocDetails."Line ID"));
                        XMLBuffer.AddElement('Note', EFTDocDetails."Note");
                        XMLBuffer.AddElement('InvoiceQuantity', Format(EFTDocDetails."Invoice Quantity", 0, 9));
                        XMLBuffer.AddElement('UnitCode', EFTDocDetails."Unit Code");
                        XMLBuffer.AddElement('LineAmount', Format(EFTDocDetails."Line Amount", 0, 9));
                        XMLBuffer.AddElement('CurrencyID', EFTDocDetails."Currency ID");
                        XMLBuffer.AddElement('ItemDescription', EFTDocDetails."Item Description");
                        XMLBuffer.AddElement('ItemName', EFTDocDetails."Item Name");
                        XMLBuffer.AddElement('ClassTaxCategID', EFTDocDetails."ClassifiedTaxCategory ID");
                        XMLBuffer.AddElement('ClassTaxCategPercent', Format(EFTDocDetails."ClassifiedTaxCategory Percent", 0, 9));
                        XMLBuffer.AddElement('TaxSchemeID', EFTDocDetails."TaxScheme ID");
                        XMLBuffer.AddElement('PriceAmount', Format(EFTDocDetails."Price Amount", 0, 9));
                        XMLBuffer.AddElement('PriceCurrencyID', EFTDocDetails."Price Currency ID");

                        XMLBuffer.GetParent();
                    until EFTDocDetails.Next() = 0;
                    XMLBuffer.GetParent();
                end;
                XMLBuffer.GetParent();
            until EFTDoc.Next() = 0;
        end;
        XMLBuffer.Save(TempBlob);
        TempBlob.CreateInStream(InStr, TextEncoding::UTF8);
        InStr.Read(Response);

    end;

    procedure GetDataAllEntries(LastEntryID: Integer) Response: Text
    var
        EFTDoc: Record "SSAEDE-Documents Log Entry";
        EFTDocDetails: Record "SSAEDE-Documents Details";
        XMLBuffer: Record "XML Buffer" temporary;
        TempBlob: Codeunit "Temp Blob";
        InStr: InStream;

    begin
        XMLBuffer.Reset();
        XMLBuffer.DeleteAll();

        EFTDoc.Reset;
        //EFTDoc.SetCurrentKey("Entry Type", Status, "Stare Mesaj");
        if LastEntryID <> 0 then
            EFTDoc.SetFilter("Entry No.", '>%1', LastEntryID);
        EFTDoc.SetRange("Entry Type", EFTDoc."Entry Type"::"Import E-Factura");
        //EFTDoc.SetFilter(Status, '<>%1', EFTDoc.Status::New);
        if EFTDoc.FindSet() then begin
            XMLBuffer.AddGroupElement('EFT');
            repeat
                XMLBuffer.AddGroupElement('EFTDoc');
                XMLBuffer.AddElement('Id', Format(EFTDoc."Entry No."));
                XMLBuffer.AddElement('Status', Format(EFTDoc."Status"));
                XMLBuffer.AddElement('ErrorMessage', EFTDoc."Error Message");
                XMLBuffer.AddElement('CreationDate', Format(EFTDoc."Creation Date"));
                XMLBuffer.AddElement('CreationTime', Format(EFTDoc."Creation Time"));
                XMLBuffer.AddElement('IndexIncarcare', Format(EFTDoc."Index Incarcare"));
                XMLBuffer.AddElement('IDDescarcare', Format(EFTDoc."ID Descarcare"));
                XMLBuffer.AddElement('Description', EFTDoc."Description");
                XMLBuffer.AddElement('IssueDate', Format(EFTDoc."Issue Date"));
                XMLBuffer.AddElement('DocumentCurrency', EFTDoc."Document Currency Code");
                XMLBuffer.AddElement('SupplierID', EFTDoc."Supplier ID");
                XMLBuffer.AddElement('SupplierName', EFTDoc."Supplier Name");
                XMLBuffer.AddElement('NAVVendorNo.', EFTDoc."NAV Vendor No.");
                XMLBuffer.AddElement('NAVVendorName', EFTDoc."NAV Vendor Name");
                XMLBuffer.AddElement('TotalTaxAmount', Format(EFTDoc."Total Tax Amount", 0, 9));
                XMLBuffer.AddElement('TotalTaxInclAmount', Format(EFTDoc."Total TaxInclusiveAmount", 0, 9));
                XMLBuffer.AddElement('TotalTaxExclAmount', Format(EFTDoc."Total TaxExclusiveAmount", 0, 9));
                XMLBuffer.AddElement('DueDate', Format(EFTDoc."Due Date"));
                XMLBuffer.AddElement('VendorInvoiceNo', EFTDoc."Vendor Invoice No.");
                XMLBuffer.AddElement('PaymentMethod', Format(EFTDoc."Payment Method Code"));
                XMLBuffer.AddElement('XMLFile', EFTDoc.GetXMLContent());
                EFTDocDetails.SetRange("Log Entry No.", EFTDoc."Entry No.");
                if EFTDocDetails.FindSet() then begin
                    XMLBuffer.AddGroupElement('EFTLines');
                    repeat
                        XMLBuffer.AddGroupElement('EFTDocLine');
                        XMLBuffer.AddElement('TypeOfLine', Format(EFTDocDetails."Type Of Line"));
                        XMLBuffer.AddElement('LineID', Format(EFTDocDetails."Line ID"));
                        XMLBuffer.AddElement('Note', EFTDocDetails."Note");
                        XMLBuffer.AddElement('InvoiceQuantity', Format(EFTDocDetails."Invoice Quantity", 0, 9));
                        XMLBuffer.AddElement('UnitCode', EFTDocDetails."Unit Code");
                        XMLBuffer.AddElement('LineAmount', Format(EFTDocDetails."Line Amount", 0, 9));
                        XMLBuffer.AddElement('CurrencyID', EFTDocDetails."Currency ID");
                        XMLBuffer.AddElement('ItemDescription', EFTDocDetails."Item Description");
                        XMLBuffer.AddElement('ItemName', EFTDocDetails."Item Name");
                        XMLBuffer.AddElement('ClassTaxCategID', EFTDocDetails."ClassifiedTaxCategory ID");
                        XMLBuffer.AddElement('ClassTaxCategPercent', Format(EFTDocDetails."ClassifiedTaxCategory Percent", 0, 9));
                        XMLBuffer.AddElement('TaxSchemeID', EFTDocDetails."TaxScheme ID");
                        XMLBuffer.AddElement('PriceAmount', Format(EFTDocDetails."Price Amount", 0, 9));
                        XMLBuffer.AddElement('PriceCurrencyID', EFTDocDetails."Price Currency ID");

                        XMLBuffer.GetParent();
                    until EFTDocDetails.Next() = 0;
                    XMLBuffer.GetParent();
                end;
                XMLBuffer.GetParent();
            until EFTDoc.Next() = 0;
        end;
        XMLBuffer.Save(TempBlob);
        TempBlob.CreateInStream(InStr, TextEncoding::UTF8);
        InStr.Read(Response);

    end;

    procedure GetDataEntry(_EntryNo: Integer) Response: Text
    var
        EFTDoc: Record "SSAEDE-Documents Log Entry";
    begin
        EFTDoc.Reset;
        EFTDoc.SetRange("Entry Type", EFTDoc."Entry Type"::"Import E-Factura");
        EFTDoc.SetRange("Entry No.", _EntryNo);

        if EFTDoc.FindFirst() then
            Response := EFTDoc.GetXMLContent();

    end;
}