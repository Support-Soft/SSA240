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
        TempBlobXML: Codeunit "Temp Blob";
    begin
        ANAFAPIMgt.DescarcareMesaj(GlobalEFTLog);

        UnzippFiles(GlobalEFTLog, TempBlobXML);
        ProcessXMLFile(TempBlobXML);
    end;

    procedure UnzippFiles(_GlobalEFTLog: Record "SSAEDE-Documents Log Entry"; var _TempBlobXML: Codeunit "Temp Blob")
    var
        DataCompression: Codeunit "Data Compression";
        XMLOutStream: OutStream;
        ZipInStr: InStream;
        ZipEntryList: List of [Text];
        ZipEntry: Text;
        ZipEntryLength: Integer;
    begin
        _GlobalEFTLog.CalcFields("ZIP Content");
        _GlobalEFTLog."ZIP Content".CreateInStream(ZipInStr);
        DataCompression.OpenZipArchive(ZipInStr, false);
        DataCompression.GetEntryList(ZipEntryList);

        foreach ZipEntry in ZipEntryList do
            if STRPOS(ZipEntry, 'semnatura') = 0 then begin
                Clear(_TempBlobXML);
                _TempBlobXML.CreateOutStream(XMLOutStream, TextEncoding::UTF8);
                ZipEntryLength := DataCompression.ExtractEntry(ZipEntry, XMLOutStream);
                exit;
            end;
    end;

    local procedure ProcessXMLFile(var _TempBlobXML: Codeunit "Temp Blob")
    var
        TempXMLBuffer: Record "XML Buffer" temporary;
        TempXMLBufferParrent: Record "XML Buffer" temporary;
        TempXMLBufferLines: Record "XML Buffer" temporary;
        EFTDetails: Record "SSAEDE-Documents Details";
        XMLDOMManagement: Codeunit "XML DOM Management";
        GenFunctions: Codeunit "SSA General Functions";
        XMLInStream: InStream;
        XMLText: Text;
        TextVar: Text;
        XmlOutText: Text;
        LineNo: Integer;
        AmountSign: Integer;
        LinesXPath: Text;
        LinesIDXPath: Text;

    begin
        _TempBlobXML.CREATEINSTREAM(XMLInStream, TextEncoding::UTF8);
        XMLInStream.Read(XMLText);
        while not XMLInStream.EOS do begin
            XMLInStream.READ(TextVar);
            XMLText += TextVar;
        end;

        //TempBlobXMLProcessed.CREATEOUTSTREAM(XMLOutStreamProcessed);
        //XMLOutStreamProcessed.WriteText(XMLText);
        GlobalEFTLog.SetXMLFactura(XMLText);
        Commit;
        XmlOutText := XMLDOMManagement.RemoveNamespaces(XMLText); //TextVar

        TempXMLBuffer.LoadFromText(XmlOutText);
        TempXMLBufferParrent.LoadFromText(XmlOutText);

        if TempXMLBuffer.FindNodesByXPath(TempXMLBuffer, '/Invoice/IssueDate') then
            Evaluate(GlobalEFTLog."Issue Date", TempXMLBuffer.GetValue());

        if TempXMLBuffer.FindNodesByXPath(TempXMLBuffer, '/Invoice/InvoiceTypeCode') then begin
            AmountSign := 1;
            LinesXPath := 'InvoiceLine*';
            LinesIDXPath := '/Invoice/InvoiceLine/ID';
        end;

        if TempXMLBuffer.FindNodesByXPath(TempXMLBuffer, '/Invoice/CreditNoteTypeCode') then begin
            AmountSign := -1;
            LinesXPath := 'CreditNoteLine*';
            LinesIDXPath := '/CreditNote/CreditNoteLine/ID';
        end;

        if TempXMLBuffer.FindNodesByXPath(TempXMLBuffer, '/Invoice/DocumentCurrencyCode') then
            GlobalEFTLog."Document Currency Code" := CopyStr(TempXMLBuffer.GetValue(), 1, MaxStrLen(GlobalEFTLog."Document Currency Code"));

        if TempXMLBuffer.FindNodesByXPath(TempXMLBuffer, 'AccountingSupplierParty/Party/PartyTaxScheme/CompanyID') then
            GlobalEFTLog."Supplier ID" := CopyStr(TempXMLBuffer.GetValue(), 1, MaxStrLen(GlobalEFTLog."Supplier ID"));

        if TempXMLBuffer.FindNodesByXPath(TempXMLBuffer, 'AccountingSupplierParty/Party/PartyLegalEntity/RegistrationName') then
            GlobalEFTLog."Supplier Name" := CopyStr(TempXMLBuffer.GetValue(), 1, MaxStrLen(GlobalEFTLog."Supplier Name"));

        if TempXMLBuffer.FindNodesByXPath(TempXMLBuffer, 'TaxTotal/TaxAmount') then
            GlobalEFTLog."Total Tax Amount" := GenFunctions.ConvertTextToDecimal(TempXMLBuffer.GetValue());

        if TempXMLBuffer.FindNodesByXPath(TempXMLBuffer, 'LegalMonetaryTotal/TaxInclusiveAmount') then begin
            GlobalEFTLog."Total TaxInclusiveAmount" := GenFunctions.ConvertTextToDecimal(TempXMLBuffer.GetValue());
            GlobalEFTLog."Total TaxInclusiveAmount" := GlobalEFTLog."Total TaxInclusiveAmount" * AmountSign;
        end;

        if TempXMLBuffer.FindNodesByXPath(TempXMLBuffer, 'LegalMonetaryTotal/TaxExclusiveAmount') then
            GlobalEFTLog."Total TaxExclusiveAmount" := GenFunctions.ConvertTextToDecimal(TempXMLBuffer.GetValue());

        //SSM2434>>
        if TempXMLBuffer.FindNodesByXPath(TempXMLBuffer, '/Invoice/DueDate') then
            Evaluate(GlobalEFTLog."Due Date", TempXMLBuffer.GetValue());

        if TempXMLBuffer.FindNodesByXPath(TempXMLBuffer, '/Invoice/ID') then
            GlobalEFTLog."Vendor Invoice No." := CopyStr(TempXMLBuffer.GetValue(), 1, MaxStrLen(GlobalEFTLog."Vendor Invoice No."));

        if TempXMLBuffer.FindNodesByXPath(TempXMLBuffer, 'PaymentMeans/PaymentMeansCode') then
            GlobalEFTLog."Payment Method Code" := CopyStr(TempXMLBuffer.GetValue(), 1, MaxStrLen(GlobalEFTLog."Payment Method Code"));
        //SSM2434<<

        GetVendorNo(GlobalEFTLog."Supplier ID", GlobalEFTLog."NAV Vendor No.", GlobalEFTLog."NAV Vendor Name");

        //SSM2434>>
        if GlobalEFTLog."Total TaxInclusiveAmount" > 0 then
            GlobalEFTLog."Import Document Type" := GlobalEFTLog."Import Document Type"::Invoice
        else
            GlobalEFTLog."Import Document Type" := GlobalEFTLog."Import Document Type"::"Credit Memo";
        //SSM2434<<

        EFTDetails.RESET;
        EFTDetails.SETRANGE("Log Entry No.", GlobalEFTLog."Entry No.");
        EFTDetails.DELETEALL;
        CLEAR(LineNo);

        TempXMLBuffer.Reset();
        if TempXMLBuffer.FindNodesByXPath(TempXMLBufferLines, 'PaymentMeans*') then
            if TempXMLBufferLines.FindSet() then
                repeat
                    if TempXMLBufferLines.Path = '/Invoice/PaymentMeans/PayeeFinancialAccount/ID' then begin
                        LineNo += 10000;
                        EFTDetails.INIT;
                        EFTDetails."Log Entry No." := GlobalEFTLog."Entry No.";
                        EFTDetails."Line No." := LineNo;
                        EFTDetails."Type of Line" := EFTDetails."Type of Line"::"PaymentMeans Line";
                        EFTDetails.INSERT(true);
                        EFTDetails.Note := CopyStr(TempXMLBufferLines.GetValue(), 1, MaxStrLen(EFTDetails.Note)); //IBAN
                        EFTDetails.MODIFY;
                    end;
                    if TempXMLBufferLines.Path = '/Invoice/PaymentMeans/PayeeFinancialAccount/Name' then begin
                        EFTDetails."Item Name" := CopyStr(TempXMLBufferLines.GetValue(), 1, MaxStrLen(EFTDetails."Item Name"));
                        EFTDetails.MODIFY;
                    end;
                until TempXMLBufferLines.Next = 0;

        TempXMLBuffer.Reset();
        if TempXMLBuffer.FindNodesByXPath(TempXMLBufferLines, LinesXPath) then
            if TempXMLBufferLines.FindSet() then
                repeat


                    if TempXMLBufferLines.Path = LinesIDXPath then begin
                        LineNo += 10000;
                        EFTDetails.INIT;
                        EFTDetails."Log Entry No." := GlobalEFTLog."Entry No.";
                        EFTDetails."Line No." := LineNo;
                        EFTDetails."Line ID Decimal" := GenFunctions.ConvertTextToDecimal(TempXMLBufferLines.GetValue());
                        EFTDetails."Type of Line" := EFTDetails."Type of Line"::"Invoice Line";
                        EFTDetails.INSERT(true);
                    end;
                    if TempXMLBufferLines.Name = 'Note' then begin
                        EFTDetails.Note := CopyStr(TempXMLBufferLines.GetValue(), 1, MaxStrLen(EFTDetails.Note));
                        EFTDetails.MODIFY;
                    end;
                    if (TempXMLBufferLines.Name = 'InvoicedQuantity') or (TempXMLBufferLines.Name = 'CreditedQuantity') then begin
                        EFTDetails."Invoice Quantity" := GenFunctions.ConvertTextToDecimal(TempXMLBufferLines.GetValue());
                        EFTDetails.MODIFY;
                    end;
                    if TempXMLBufferLines.Name = 'unitCode' then begin
                        EFTDetails."Unit Code" := CopyStr(TempXMLBufferLines.GetValue(), 1, MaxStrLen(EFTDetails."Unit Code"));
                        EFTDetails.MODIFY;
                    end;
                    if TempXMLBufferLines.Name = 'LineExtensionAmount' then begin
                        EFTDetails."Line Amount" := GenFunctions.ConvertTextToDecimal(TempXMLBufferLines.GetValue());
                        EFTDetails.MODIFY;
                    end;
                    if TempXMLBufferLines.Name = 'currencyID' then begin
                        TempXMLBufferParrent.Get(TempXMLBufferLines."Parent Entry No.");
                        if TempXMLBufferParrent.Name = 'LineExtensionAmount' then begin
                            EFTDetails."Currency ID" := CopyStr(TempXMLBufferLines.GetValue(), 1, MaxStrLen(EFTDetails."Currency ID"));
                            EFTDetails.MODIFY;
                        end;
                    end;
                    if TempXMLBufferLines.Name = 'Description' then begin
                        EFTDetails."Item Description" := CopyStr(TempXMLBufferLines.GetValue(), 1, MaxStrLen(EFTDetails."Item Description"));
                        EFTDetails.MODIFY;
                    end;
                    if TempXMLBufferLines.Name = 'Name' then begin
                        EFTDetails."Item Name" := CopyStr(TempXMLBufferLines.GetValue(), 1, MaxStrLen(EFTDetails."Item Name"));
                        EFTDetails.MODIFY;
                    end;
                    if TempXMLBufferLines.Name = 'ID' then begin
                        TempXMLBufferParrent.Get(TempXMLBufferLines."Parent Entry No.");
                        if TempXMLBufferParrent.Name = 'ClassifiedTaxCategory' then begin
                            EFTDetails."ClassifiedTaxCategory ID" := CopyStr(TempXMLBufferLines.GetValue(), 1, MaxStrLen(EFTDetails."ClassifiedTaxCategory ID"));
                            EFTDetails.MODIFY;
                        end;
                    end;
                    if TempXMLBufferLines.Name = 'Percent' then begin
                        TempXMLBufferParrent.Get(TempXMLBufferLines."Parent Entry No.");
                        if TempXMLBufferParrent.Name = 'ClassifiedTaxCategory' then begin
                            EFTDetails."ClassifiedTaxCategory Percent" := GenFunctions.ConvertTextToDecimal(TempXMLBufferLines.GetValue());
                            EFTDetails.MODIFY;
                        end;
                    end;
                    if TempXMLBufferLines.Name = 'ID' then begin
                        TempXMLBufferParrent.Get(TempXMLBufferLines."Parent Entry No.");
                        if TempXMLBufferParrent.Name = 'TaxScheme' then begin
                            EFTDetails."TaxScheme ID" := CopyStr(TempXMLBufferLines.GetValue(), 1, MaxStrLen(EFTDetails."TaxScheme ID"));
                            EFTDetails.MODIFY;
                        end;
                    end;
                    if TempXMLBufferLines.Name = 'PriceAmount' then begin
                        EFTDetails."Price Amount" := GenFunctions.ConvertTextToDecimal(TempXMLBufferLines.GetValue());
                        EFTDetails."Price Amount" := EFTDetails."Price Amount" * AmountSign;
                        EFTDetails.MODIFY;
                    end;

                    if TempXMLBufferLines.Name = 'currencyID' then begin
                        TempXMLBufferParrent.Get(TempXMLBufferLines."Parent Entry No.");
                        if TempXMLBufferParrent.Name = 'PriceAmount' then begin
                            EFTDetails."Price Currency ID" := CopyStr(TempXMLBufferLines.GetValue(), 1, MaxStrLen(EFTDetails."Price Currency ID"));
                            EFTDetails.MODIFY;
                        end;
                    end;

                until TempXMLBufferLines.Next = 0;
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
        NextNo: Code[20];
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
                InsertVBA(_EFTEntry."NAV Vendor No.", EFTDetails.Note, EFTDetails."Item Name", NextNo);
            until EFTDetails.NEXT = 0;

        _EFTEntry.TESTFIELD("Import Document Type"); //SSM2434

        PH.INIT;
        PH.VALIDATE("Document Type", _EFTEntry."Import Document Type"); //SSM2434
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
                if PH.IsCreditDocType() then
                    PL.VALIDATE(Quantity, -EFTDetails."Invoice Quantity")
                else
                    PL.VALIDATE(Quantity, EFTDetails."Invoice Quantity");
                PL.VALIDATE("Direct Unit Cost", EFTDetails."Price Amount");
                PL.VALIDATE("VAT %", EFTDetails."ClassifiedTaxCategory Percent");
                PL.MODIFY(true);

            until EFTDetails.NEXT = 0;

        if GuiAllowed then
            if CONFIRM(STRSUBSTNO(ConfirmMsg, PH."Document Type", PH."No.")) then
                case PH."Document Type" of
                    PH."Document Type"::Order:
                        PAGE.RUN(PAGE::"Purchase Order", PH);
                    PH."Document Type"::Invoice:
                        PAGE.RUN(PAGE::"Purchase Invoice", PH);
                    PH."Document Type"::"Credit Memo":
                        PAGE.RUN(PAGE::"Purchase Credit Memo", PH);
                    PH."Document Type"::"Return Order":
                        PAGE.RUN(PAGE::"Purchase Return Order", PH);
                end;
    end;

    local procedure InsertVBA(_VendorNo: Code[20]; _IBAN: Text; _Name: Text; _NextNo: Code[20])
    var
        VBA: Record "Vendor Bank Account";
        IntVar: Integer;
    begin
        VBA.RESET;
        VBA.SETRANGE(VBA."Vendor No.", _VendorNo);
        VBA.SETRANGE(IBAN, _IBAN);
        if not VBA.ISEMPTY then
            exit;

        if _NextNo = '' then begin
            VBA.SETRANGE(IBAN);
            if VBA.FINDLAST then
                if EVALUATE(IntVar, VBA.Code) then
                    _NextNo := INCSTR(VBA.Code)
                else
                    _NextNo := '001'
            else
                _NextNo := '001';
        end else
            _NextNo := INCSTR(_NextNo);

        VBA.INIT;
        VBA.VALIDATE("Vendor No.", _VendorNo);
        VBA.VALIDATE(Code, _NextNo);
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