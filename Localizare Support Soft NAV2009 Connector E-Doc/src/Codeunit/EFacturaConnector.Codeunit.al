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

    procedure GetDataEntriesList(LastEntryID: Integer) Response: Text
    var
        EFTDoc: Record "SSAEDE-Documents Log Entry";
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

        if EFTDoc.FindSet() then begin
            XMLBuffer.AddGroupElement('EFT');
            repeat
                XMLBuffer.AddGroupElement('EFTDoc');
                XMLBuffer.AddElement('Id', Format(EFTDoc."Entry No."));
                XMLBuffer.AddElement('DocumentType', Format(EFTDoc."Document Type"));
                XMLBuffer.AddElement('DocumentNo', EFTDoc."Document No.");
                XMLBuffer.AddElement('CustomerNo', EFTDoc."Customer No.");
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

                XMLBuffer.AddElement('XMLFile', EFTDoc.GetXMLContent());
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