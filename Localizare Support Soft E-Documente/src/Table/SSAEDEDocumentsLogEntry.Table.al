table 72000 "SSAEDE-Documents Log Entry"
{
    Caption = 'RO Factura/Transport Log Entry';
    ReplicateData = false;
    fields
    {
        field(1; "Entry No."; Integer)
        {
            AutoIncrement = true;
            Caption = 'Entry No.';
            DataClassification = SystemMetadata;
        }
        field(10; "RecordID"; RecordId)
        {
            Caption = 'RecordID';
            DataClassification = SystemMetadata;
        }
        field(20; "Document Type"; Option)
        {
            Caption = 'Document Type';
            DataClassification = CustomerContent;
            OptionCaption = ' ,Sales Shipment,Sales Invoice,Transfer Shipment,Sales Credit Memo';
            OptionMembers = " ","Sales Shipment","Sales Invoice","Transfer Shipment","Sales Credit Memo";
        }
        field(30; "Document No."; Code[20])
        {
            Caption = 'Document No.';
            DataClassification = CustomerContent;
            TableRelation = if ("Document Type" = const("Sales Shipment")) "Sales Shipment Header"."No."
            else
            if ("Document Type" = const("Sales Invoice")) "Sales Invoice Header"."No."
            else
            if ("Document Type" = const("Transfer Shipment")) "Transfer Shipment Header"."No."
            else
            if ("Document Type" = const("Sales Credit Memo")) "Sales Cr.Memo Header"."No.";
        }
        field(40; "Customer No."; Code[20])
        {
            Caption = 'Customer No.';
            DataClassification = CustomerContent;
            TableRelation = Customer."No.";
        }
        field(50; Status; Option)
        {
            Caption = 'Status';
            DataClassification = CustomerContent;
            OptionMembers = New,"In Progress",Error,Completed;
        }
        field(60; "Error Message"; Text[250])
        {
            Caption = 'Error Message';
            DataClassification = CustomerContent;
        }
        field(70; "Creation Date"; Date)
        {
            Caption = 'Creation Date';
            DataClassification = CustomerContent;
        }
        field(80; "Creation Time"; Time)
        {
            Caption = 'Creation Time';
            DataClassification = CustomerContent;
        }
        field(90; "Processing DateTime"; DateTime)
        {
            Caption = 'Processing DateTime';
            DataClassification = CustomerContent;
        }
        field(100; ServerFilePath; Text[250])
        {
            Caption = 'ServerFilePath';
            DataClassification = CustomerContent;
        }
        field(110; ClientFileName; Text[250])
        {
            Caption = 'ClientFileName';
            DataClassification = CustomerContent;
        }
        field(120; "Entry Type"; Option)
        {
            Caption = 'Entry Type';
            DataClassification = CustomerContent;
            Description = 'SSM1997';
            OptionCaption = ' ,Export E-Transport,Export E-Factura,Import E-Factura';
            OptionMembers = " ","Export E-Transport","Export E-Factura","Import E-Factura";
        }
        field(130; DateResponse; Text[30])
        {
            Caption = 'Data Raspuns';
            DataClassification = CustomerContent;
        }
        field(140; "Execution Status"; Text[30])
        {
            Caption = 'Status Executie';
            DataClassification = CustomerContent;
        }
        field(150; "Index Incarcare"; Text[30])
        {
            Caption = 'Index Incarcare';
            DataClassification = CustomerContent;
        }
        field(160; "Stare Mesaj"; Text[30])
        {
            Caption = 'Stare Mesaj';
            DataClassification = CustomerContent;
        }
        field(170; "ID Descarcare"; Text[30])
        {
            Caption = 'ID Descarcare';
            DataClassification = CustomerContent;
        }
        field(190; Description; Text[250])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
        field(200; "Issue Date"; Date)
        {
            Caption = 'Issue Date';
            DataClassification = CustomerContent;
        }
        field(220; "Document Currency Code"; Code[10])
        {
            Caption = 'Document Currency Code';
            DataClassification = CustomerContent;
        }
        field(230; "Supplier ID"; Text[30])
        {
            Caption = 'Supplier ID';
            DataClassification = CustomerContent;
        }
        field(240; "Supplier Name"; Text[100])
        {
            Caption = 'Supplier Name';
            DataClassification = CustomerContent;
        }
        field(250; "NAV Vendor No."; Code[20])
        {
            Caption = 'NAV Vendor No.';
            TableRelation = Vendor."No.";
            DataClassification = CustomerContent;
        }
        field(260; "NAV Vendor Name"; Text[100])
        {
            Caption = 'NAV Vendor Name';
            DataClassification = CustomerContent;
        }
        field(270; "Total Tax Amount"; Decimal)
        {
            Caption = 'Total Tax Amount';
            DataClassification = CustomerContent;
        }
        field(280; "Total TaxInclusiveAmount"; Decimal)
        {
            Caption = 'Total TaxInclusiveAmount';
            DataClassification = CustomerContent;
        }
        field(290; "Total TaxExclusiveAmount"; Decimal)
        {
            Caption = 'Total TaxExclusiveAmount';
            DataClassification = CustomerContent;
        }
        field(300; "XML Content"; Blob)
        {
            Caption = 'XML Content';
            DataClassification = CustomerContent;
        }
        field(310; "Due Date"; Date)
        {
            Caption = 'Due Date';
            DataClassification = CustomerContent;
        }
        field(320; "Vendor Invoice No."; Text[50])
        {
            Caption = 'Vendor Invoice No.';
            DataClassification = CustomerContent;
        }
        field(330; "Payment Method Code"; Text[30])
        {
            Caption = 'Payment Method Code';
            DataClassification = CustomerContent;
        }
        field(340; "Import Document Type"; Enum "Sales Document Type")
        {
            Caption = 'Import Document Type';
            DataClassification = CustomerContent;
        }
        field(350; "ZIP Content"; Blob)
        {
            Caption = 'ZIP Content';
            DataClassification = CustomerContent;
        }
        field(10000; "Created Purchase Invoice No."; Code[20])
        {
            Caption = 'Created Purchase Invoice No.';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup("Purchase Header"."No." where("SSAEDID Descarcare EFactura" = field("ID Descarcare")));
        }
        field(10010; "Posted Purchase Invoice No."; Code[20])
        {
            Caption = 'Posted Purchase Invoice No.';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup("Purch. Inv. Header"."No." where("SSAEDID Descarcare EFactura" = field("ID Descarcare")));
        }
        field(10020; "Posted Purch. Credit Memo No."; Code[20])
        {
            Caption = 'Posted Purch. Credit Memo No.';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup("Purch. Cr. Memo Hdr."."No." where("SSAEDID Descarcare EFactura" = field("ID Descarcare")));
        }
        field(10030; "Purchase Invoice Amount"; Decimal)
        {
            Caption = 'Purchase Invoice Amount';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = sum("Purchase Line".Amount where("Document No." = field("Created Purchase Invoice No.")));
        }
        field(10040; "Purch.Inv Amount Including VAT"; Decimal)
        {
            Caption = 'Purch.Inv Amount Including VAT';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = sum("Purchase Line"."Amount Including VAT" where("Document No." = field("Created Purchase Invoice No.")));
        }
    }

    keys
    {
        key(Key1; "Entry No.")
        {
            Clustered = true;
        }
        key(Key2; "Entry Type", Status, "Stare Mesaj")
        {
        }
    }

    fieldgroups
    {
    }


    procedure ResetStatus(var _ETransportLogEntry: Record "SSAEDE-Documents Log Entry")
    var
        ErrorLbl: Label 'Nu este permisa Resetarea liniei de export E-Factura cu statusul "Completed" sau "OK"';
        Confirmed: Boolean;
    begin
        Clear(Confirmed);
        _ETransportLogEntry.FindSet(true);
        repeat
            /*
            if _ETransportLogEntry.Status <> _ETransportLogEntry.Status::Error then begin
                if not Confirmed then begin
                    if not Confirm('Sigur resetati status?', false) then
                        Error('');
                    Confirmed := true;
                end;
            end else
            */
            case _ETransportLogEntry."Entry Type" of
                _ETransportLogEntry."Entry Type"::"Export E-Factura":
                    if (_ETransportLogEntry.Status = _ETransportLogEntry.Status::Completed) and (UpperCase(_ETransportLogEntry."Stare Mesaj") = 'OK') then
                        Error(ErrorLbl);
                _ETransportLogEntry."Entry Type"::"Import E-Factura":
                    _ETransportLogEntry.TestField(Status, Status::Error);
                _ETransportLogEntry."Entry Type"::"Export E-Transport":
                    _ETransportLogEntry.TestField(Status, Status::Error);
            end;

            _ETransportLogEntry.Validate(Status, _ETransportLogEntry.Status::New);
            _ETransportLogEntry.Validate("Error Message", '');
            _ETransportLogEntry.ServerFilePath := '';
            _ETransportLogEntry.ClientFileName := '';
            _ETransportLogEntry."Stare Mesaj" := '';
            _ETransportLogEntry."ID Descarcare" := '';
            Clear(_ETransportLogEntry."ZIP Content");
            Clear(_ETransportLogEntry."XML Content");
            _ETransportLogEntry.Modify(true);

        until _ETransportLogEntry.Next = 0;
    end;

    procedure SetXMLContent(XMLContent: Text)
    var
        OutStr: OutStream;
    begin
        Rec.CalcFields("XML Content");
        if Rec."XML Content".HasValue then
            if GuiAllowed then
                if not Confirm('Do you want to overwrite XML Content?', false) then
                    exit;
        Rec."XML Content".CreateOutStream(OutStr, TextEncoding::UTF8);
        OutStr.WriteText(XMLContent);
        Rec.Modify();
    end;

    procedure GetXMLContent() XMLContent: Text
    var
        InStr: InStream;
    begin
        Rec.CalcFields("XML Content");
        Rec."XML Content".CreateInStream(InStr, TextEncoding::UTF8);
        InStr.ReadText(XMLContent);
        exit(XMLContent);
    end;

    procedure DownloadXMLContent()
    var
        InStr: InStream;
        NoContentLbl: Label 'XML Content is empty';
        FileName: Text;
    begin
        Rec.CalcFields("XML Content");
        if not Rec."XML Content".HasValue then
            Error(NoContentLbl);

        Rec."XML Content".CreateInStream(InStr);
        FileName := 'XMLContent.xml';
        DownloadFromStream(InStr, 'Export', '', 'All Files (*.*)|*.*', FileName);
    end;

    procedure DownloadZIPContent()
    var
        InStr: InStream;
        NoContentLbl: Label 'ZIP Content is empty';
        FileNameLbl: Label '%1.zip', Locked = true;
        FileName: Text;
    begin
        Rec.CalcFields("ZIP Content");
        if not Rec."ZIP Content".HasValue then
            Error(NoContentLbl);

        Rec."ZIP Content".CreateInStream(InStr);
        FileName := StrSubstNo(FileNameLbl, "Index Incarcare");
        DownloadFromStream(InStr, 'Export', '', 'All Files (*.*)|*.*', FileName);
    end;
}

