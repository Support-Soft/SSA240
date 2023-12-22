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
        exit('OK');
    end;

    procedure GetData(DateFilter: Date) Response: Text
    var
        EFTDoc: Record "SSAEDE-Documents Log Entry";
        XMLBuffer: Record "XML Buffer" temporary;
        TempBlob: Codeunit "Temp Blob";
        InStr: InStream;

    begin
        XMLBuffer.Reset();
        XMLBuffer.DeleteAll();
        XMLBuffer.AddGroupElement('EFT');

        EFTDoc.Reset;
        EFTDoc.SetCurrentKey("Entry Type", Status, "Stare Mesaj");
        EFTDoc.SetRange("Entry Type", EFTDoc."Entry Type"::"Import E-Factura");

        if DateFilter <> 0D then
            EFTDoc.SetRange("Creation Date", DateFilter)

        else
            EFTDoc.SetRange("SSAEDNXML Exported", false);

        if EFTDoc.FindSet(true) then
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
                EFTDoc.Validate("SSAEDNXML Exported", true);
                EFTDoc.Modify(true);
            until EFTDoc.Next() = 0;

        XMLBuffer.Save(TempBlob);
        TempBlob.CreateInStream(InStr);
        InStr.Read(Response);

    end;
}