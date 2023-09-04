codeunit 72008 "SSAEDProcess Import E-Doc"
{
    TableNo = "SSAEDE-Documents Log Entry";

    var
        GlobalEFTLog: Record "SSAEDE-Documents Log Entry";

    trigger OnRun()
    begin
        GlobalEFTLog.COPY(Rec);
        //test
        Code;
        //TestCode;
        Rec := GlobalEFTLog;

    end;

    local procedure Code()
    var
        ANAFAPIMgt: Codeunit "SSAEDANAF API Mgt";
        TempBlobZip: Codeunit "Temp Blob";
        TempBlobXML: Codeunit "Temp Blob";
    begin
        ANAFAPIMgt.DescarcareMesaj(GlobalEFTLog."ID Descarcare", TempBlobZip);
        UnzippFiles(TempBlobZip, TempBlobXML);
        ProcessXMLFile(TempBlobXML);
    end;

    local procedure TestCode()
    var
        TempBlobZip: Codeunit "Temp Blob";
        TempBlobXML: Codeunit "Temp Blob";
        ZipOutStream: OutStream;
        InStr: InStream;
        FileName: Text;
    begin
        //ANAFAPIMgt.DescarcareMesaj(GlobalEFTLog."ID Descarcare",TempBlobZip);
        //test

        if not CONFIRM('run test') then
            exit;

        UploadIntoStream('Select File...', '', '', FileName, InStr);

        TempBlobZip.CREATEOUTSTREAM(ZipOutStream);
        COPYSTREAM(ZipOutStream, InStr);

        UnzippFiles(TempBlobZip, TempBlobXML);
        ProcessXMLFile(TempBlobXML);
    end;

    local procedure UnzippFiles(var _TempBlobZIP: Codeunit "Temp Blob"; var _TempBlobXML: Codeunit "Temp Blob")
    var
        DataCompression: Codeunit "Data Compression";
        XMLOutStream: OutStream;
        ZipInStr: InStream;
        ZipEntryList: List of [Text];
        ZipEntry: Text;
        ZipEntryLength: Integer;
    begin
        _TempBlobZIP.CreateInStream(ZipInStr);
        DataCompression.OpenZipArchive(ZipInStr, false);
        DataCompression.GetEntryList(ZipEntryList);

        foreach ZipEntry in ZipEntryList do
            if STRPOS(ZipEntry, 'semnatura') = 0 then begin
                Clear(_TempBlobXML);
                _TempBlobXML.CreateOutStream(XMLOutStream);
                DataCompression.ExtractEntry(ZipEntry, XMLOutStream, ZipEntryLength);
                exit;
            end;
    end;

    local procedure ProcessXMLFile(var _TempBlobXML: Codeunit "Temp Blob")
    var
        TempXMLBuffer: Record "XML Buffer" temporary;
        TempXMLBufferLines: Record "XML Buffer" temporary;
        EFTDetails: Record "SSAEDE-Documents Details";
        XMLDOMManagement: Codeunit "XML DOM Management";
        XMLInStream: InStream;
        XMLText: Text;
        TextVar: Text;
        XmlOutText: Text;
        LineNo: Integer;

    begin
        _TempBlobXML.CREATEINSTREAM(XMLInStream);
        while not XMLInStream.EOS do begin
            XMLInStream.READTEXT(TextVar);
            XMLText += TextVar;
        end;

        XmlOutText := XMLDOMManagement.RemoveNamespaces(XMLText); //TextVar

        TempXMLBuffer.LoadFromText(XmlOutText);

        TempXMLBuffer.FindNodesByXPath(TempXMLBuffer, 'IssueDate');
        Evaluate(GlobalEFTLog."Issue Date", TempXMLBuffer.GetValue());

        TempXMLBuffer.FindNodesByXPath(TempXMLBuffer, 'DocumentCurrencyCode');
        GlobalEFTLog."Document Currency Code" := TempXMLBuffer.GetValue();

        TempXMLBuffer.FindNodesByXPath(TempXMLBuffer, 'AccountingSupplierParty/Party/PartyTaxScheme/CompanyID');
        GlobalEFTLog."Supplier ID" := TempXMLBuffer.GetValue();

        TempXMLBuffer.FindNodesByXPath(TempXMLBuffer, 'AccountingSupplierParty/Party/PartyLegalEntity/RegistrationName');
        GlobalEFTLog."Supplier Name" := TempXMLBuffer.GetValue();

        TempXMLBuffer.FindNodesByXPath(TempXMLBuffer, 'TaxTotal/TaxAmount');
        Evaluate(GlobalEFTLog."Total Tax Amount", TempXMLBuffer.GetValue());

        TempXMLBuffer.FindNodesByXPath(TempXMLBuffer, 'LegalMonetaryTotal/TaxInclusiveAmount');
        Evaluate(GlobalEFTLog."Total TaxInclusiveAmount", TempXMLBuffer.GetValue());

        TempXMLBuffer.FindNodesByXPath(TempXMLBuffer, 'LegalMonetaryTotal/TaxExclusiveAmount');
        Evaluate(GlobalEFTLog."Total TaxExclusiveAmount", TempXMLBuffer.GetValue());
        GetVendorNo(GlobalEFTLog."Supplier ID", GlobalEFTLog."NAV Vendor No.", GlobalEFTLog."NAV Vendor Name");

        EFTDetails.RESET;
        EFTDetails.SETRANGE("Log Entry No.", GlobalEFTLog."Entry No.");
        EFTDetails.DELETEALL;
        CLEAR(LineNo);


        TempXMLBuffer.FindNodesByXPath(TempXMLBufferLines, 'Invoice/PaymentMeans');
        if TempXMLBufferLines.FindSet() then
            repeat

                if TempXMLBufferLines.Name = 'ID' then begin
                    LineNo += 10000;
                    EFTDetails.INIT;
                    EFTDetails."Log Entry No." := GlobalEFTLog."Entry No.";
                    EFTDetails."Line No." := LineNo;
                    EFTDetails.INSERT(true);
                    TempXMLBufferLines.Next();
                    EFTDetails.Note := TempXMLBufferLines.Value;
                    TempXMLBufferLines.Next();
                    EFTDetails."Item Name" := TempXMLBufferLines.GetValue();
                    EFTDetails."Type of Line" := EFTDetails."Type of Line"::"PaymentMeans Line";
                    EFTDetails.MODIFY;
                    EFTDetails.Note := TempXMLBufferLines.GetValue();
                end;

            until TempXMLBufferLines.Next = 0;

        TempXMLBuffer.FindNodesByXPath(TempXMLBufferLines, 'Invoice/InvoiceLine');
        if TempXMLBufferLines.FindSet() then
            repeat

                if TempXMLBufferLines.Name = 'ID' then begin
                    LineNo += 10000;
                    EFTDetails.INIT;
                    EFTDetails."Log Entry No." := GlobalEFTLog."Entry No.";
                    EFTDetails."Line No." := LineNo;
                    EFTDetails.INSERT(true);
                    /*
                    EFTDetails."Line ID" := Get_IntegerFromNode(XMLNode, 'ID');
                    EFTDetails.Note := Get_TextFromNode(XMLNode, 'Note');
                    EFTDetails."Invoice Quantity" := Get_DecimalFromNode(XMLNode, 'InvoicedQuantity');
                    EFTDetails."Unit Code" := Get_TextFromNode(XMLNode, 'InvoicedQuantity/@unitCode');
                    EFTDetails."Line Amount" := Get_DecimalFromNode(XMLNode, 'LineExtensionAmount');
                    EFTDetails."Currency ID" := Get_TextFromNode(XMLNode, 'LineExtensionAmount/@currencyID');
                    EFTDetails."Item Description" := Get_TextFromNode(XMLNode, 'Item/Description');
                    EFTDetails."Item Name" := Get_TextFromNode(XMLNode, 'Item/Name');
                    EFTDetails."ClassifiedTaxCategory ID" := Get_TextFromNode(XMLNode, 'Item/ClassifiedTaxCategory/ID');
                    EFTDetails."ClassifiedTaxCategory Percent" := Get_DecimalFromNode(XMLNode, 'Item/ClassifiedTaxCategory/Percent');
                    EFTDetails."TaxScheme ID" := Get_TextFromNode(XMLNode, 'Item/ClassifiedTaxCategory/TaxScheme/ID');
                    EFTDetails."Price Amount" := Get_DecimalFromNode(XMLNode, 'Price/PriceAmount');
                    EFTDetails."Price Currency ID" := Get_TextFromNode(XMLNode, 'Price/PriceAmount/@currencyID');
                    EFTDetails."Type of Line" := EFTDetails."Type of Line"::"Invoice Line";
                    EFTDetails.MODIFY;
                    */
                end;

            until TempXMLBufferLines.Next = 0;

        /*
        XMLNodeListLines := XMLdocIn.SelectNodes('Invoice/PaymentMeans');
        NoOfLines := XMLNodeListLines.Count();
        for i := 0 to NoOfLines - 1 do begin
            XMLNode := XMLNodeListLines.ItemOf(i);
            if Get_TextFromNode(XMLNode, 'PayeeFinancialAccount/ID') <> '' then begin
                LineNo += 10000;
                EFTDetails.INIT;
                EFTDetails."Log Entry No." := GlobalEFTLog."Entry No.";
                EFTDetails."Line No." := LineNo;
                EFTDetails.INSERT(true);
                EFTDetails.Note := Get_TextFromNode(XMLNode, 'PayeeFinancialAccount/ID');
                EFTDetails."Item Name" := Get_TextFromNode(XMLNode, 'PayeeFinancialAccount/Name');
                EFTDetails."Type of Line" := EFTDetails."Type of Line"::"PaymentMeans Line";
                EFTDetails.MODIFY;
            end;
        end;
        

        XMLNodeListLines := XMLdocIn.SelectNodes('Invoice/InvoiceLine');
        NoOfLines := XMLNodeListLines.Count();
        for i := 0 to NoOfLines - 1 do begin
            XMLNode := XMLNodeListLines.ItemOf(i);
            if Get_IntegerFromNode(XMLNode, 'ID') <> 0 then begin
                LineNo += 10000;
                EFTDetails.INIT;
                EFTDetails."Log Entry No." := GlobalEFTLog."Entry No.";
                EFTDetails."Line No." := LineNo;
                EFTDetails.INSERT(true);

                EFTDetails."Line ID" := Get_IntegerFromNode(XMLNode, 'ID');
                EFTDetails.Note := Get_TextFromNode(XMLNode, 'Note');
                EFTDetails."Invoice Quantity" := Get_DecimalFromNode(XMLNode, 'InvoicedQuantity');
                EFTDetails."Unit Code" := Get_TextFromNode(XMLNode, 'InvoicedQuantity/@unitCode');
                EFTDetails."Line Amount" := Get_DecimalFromNode(XMLNode, 'LineExtensionAmount');
                EFTDetails."Currency ID" := Get_TextFromNode(XMLNode, 'LineExtensionAmount/@currencyID');
                EFTDetails."Item Description" := Get_TextFromNode(XMLNode, 'Item/Description');
                EFTDetails."Item Name" := Get_TextFromNode(XMLNode, 'Item/Name');
                EFTDetails."ClassifiedTaxCategory ID" := Get_TextFromNode(XMLNode, 'Item/ClassifiedTaxCategory/ID');
                EFTDetails."ClassifiedTaxCategory Percent" := Get_DecimalFromNode(XMLNode, 'Item/ClassifiedTaxCategory/Percent');
                EFTDetails."TaxScheme ID" := Get_TextFromNode(XMLNode, 'Item/ClassifiedTaxCategory/TaxScheme/ID');
                EFTDetails."Price Amount" := Get_DecimalFromNode(XMLNode, 'Price/PriceAmount');
                EFTDetails."Price Currency ID" := Get_TextFromNode(XMLNode, 'Price/PriceAmount/@currencyID');
                EFTDetails."Type of Line" := EFTDetails."Type of Line"::"Invoice Line";
                EFTDetails.MODIFY;
            end;
        end;
        */
    end;

    procedure ProcessPurchInvoice(var _EFTEntry: Record "SSAEDE-Documents Log Entry")
    var
        GLSetup: Record "General Ledger Setup";
        PH: Record "Purchase Header";
        PIH: Record "Purch. Inv. Header";
        PCMH: Record "Purch. Cr. Memo Hdr.";
        PL: Record "Purchase Line";
        UOM: Record "Unit of Measure";
        EFTDetails: Record "SSAEDE-Documents Details";
        ConfirmMsg: Label 'A fost creat %1 %2. Doriti sa deschideti?';
        LineNo: Integer;
    begin
        GLSetup.GET;

        PH.RESET;
        PH.SETRANGE("SSAEDID Descarcare EFactura", _EFTEntry."ID Descarcare");
        if PH.FINDFIRST then
            ERROR('Exista deja %1 %2.', PH."Document Type", PH."No.");

        PIH.RESET;
        PIH.SETRANGE("SSAEDID Descarcare EFactura", _EFTEntry."ID Descarcare");
        if PIH.FINDFIRST then
            ERROR('Exista deja factura inreg. %1.', PIH."No.");

        PCMH.RESET;
        PCMH.SETRANGE("SSAEDID Descarcare EFactura", _EFTEntry."ID Descarcare");
        if PCMH.FINDFIRST then
            ERROR('Exista deja nota de credit inreg. %1.', PCMH."No.");

        _EFTEntry.TESTFIELD("NAV Vendor No.");

        EFTDetails.RESET;
        EFTDetails.SETRANGE("Log Entry No.", _EFTEntry."Entry No.");
        EFTDetails.SETRANGE("Type of Line", EFTDetails."Type of Line"::"PaymentMeans Line");
        if EFTDetails.FINDSET then
            repeat
                InsertVBA(_EFTEntry."NAV Vendor No.", EFTDetails.Note, EFTDetails."Item Name");
            until EFTDetails.NEXT = 0;

        PH.INIT;
        if _EFTEntry."Total TaxInclusiveAmount" < 0 then
            PH.VALIDATE("Document Type", PH."Document Type"::"Credit Memo")
        else
            PH.VALIDATE("Document Type", PH."Document Type"::Invoice);
        PH.INSERT(true);
        PH.VALIDATE("Buy-from Vendor No.", _EFTEntry."NAV Vendor No.");
        PH.VALIDATE("SSAEDID Descarcare EFactura", _EFTEntry."ID Descarcare");
        PH.VALIDATE("Posting Date", _EFTEntry."Issue Date");
        if GLSetup."LCY Code" = _EFTEntry."Document Currency Code" then
            PH.VALIDATE("Currency Code", '')
        else
            PH.VALIDATE("Currency Code", _EFTEntry."Document Currency Code");
        PH.MODIFY(true);

        CLEAR(LineNo);
        EFTDetails.SETRANGE("Type of Line", EFTDetails."Type of Line"::"Invoice Line");
        if EFTDetails.FINDSET then
            repeat
                LineNo += 10000;
                EFTDetails.TESTFIELD("NAV Type");
                EFTDetails.TESTFIELD("NAV No.");

                PL.INIT;
                PL."Document Type" := PH."Document Type";
                PL."Document No." := PH."No.";
                PL."Line No." := LineNo;
                PL.INSERT(true);
                PL.VALIDATE(Type, EFTDetails."NAV Type");
                PL.VALIDATE("No.", EFTDetails."NAV No.");
                UOM.SETRANGE("International Standard Code", EFTDetails."Unit Code");
                if UOM.FINDFIRST then
                    PL.VALIDATE("Unit of Measure Code", UOM.Code);
                PL.VALIDATE(Quantity, EFTDetails."Invoice Quantity");
                if PL."Document Type" = PL."Document Type"::"Credit Memo" then
                    PL.VALIDATE("Direct Unit Cost", -EFTDetails."Price Amount")
                else
                    PL.VALIDATE("Direct Unit Cost", EFTDetails."Price Amount");
                PL.VALIDATE("VAT %", EFTDetails."ClassifiedTaxCategory Percent");
                PL.MODIFY(true);

            until EFTDetails.NEXT = 0;

        if CONFIRM(STRSUBSTNO(ConfirmMsg, PH."Document Type", PH."No.")) then
            if PH."Document Type" = PH."Document Type"::Invoice then
                page.RUN(page::"Purchase Invoice", PH)
            else
                page.RUN(page::"Purchase Credit Memo", PH);
    end;

    local procedure InsertVBA(_VendorNo: Code[20]; _IBAN: Text; _Name: Text)
    var
        VBA: Record "Vendor Bank Account";
        NextNo: Code[20];
        IntVar: Integer;
    begin
        VBA.RESET;
        VBA.SETRANGE(VBA."Vendor No.", _VendorNo);
        VBA.SETRANGE(IBAN, _IBAN);
        if not VBA.ISEMPTY then
            exit;

        VBA.SETRANGE(IBAN);
        if VBA.FINDLAST then
            if EVALUATE(IntVar, VBA.Code) then
                NextNo := INCSTR(VBA.Code)
            else
                NextNo := '001';

        VBA.INIT;
        VBA.VALIDATE("Vendor No.", _VendorNo);
        VBA.VALIDATE(Code, NextNo);
        VBA.VALIDATE(Name, _Name);
        VBA.VALIDATE(IBAN, _IBAN);
        VBA.INSERT(true);

    end;

    local procedure GetVendorNo(_VATRegNo: Text; var _VendorNo: Code[20]; var _VendorName: Text)
    var
        Vendor: Record Vendor;
        VATFilter: Label '*%1*', Locked = true;
    begin
        Vendor.SETCURRENTKEY("VAT Registration No.");
        Vendor.SETFILTER("VAT Registration No.", STRSUBSTNO(VATFilter, DELCHR(_VATRegNo, '=', 'ROro ')));
        if Vendor.FINDSET then
            repeat
                if DELCHR(Vendor."VAT Registration No.", '=', 'ROro ') = DELCHR(_VATRegNo, '=', 'ROro ') then begin
                    _VendorNo := Vendor."No.";
                    _VendorName := Vendor.Name;
                    exit;
                end;
            until (Vendor.NEXT = 0);

        exit;
    end;

}