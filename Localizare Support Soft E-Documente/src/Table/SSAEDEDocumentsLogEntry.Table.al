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
        field(10; "RecordID"; RecordID)
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
        field(120; "Export Type"; Option)
        {
            Caption = 'Export Type';
            DataClassification = CustomerContent;
            Description = 'SSM1997';
            OptionCaption = ' ,E-Transport,E-Factura';
            OptionMembers = " ","E-Transport","E-Factura";
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
        key(Key2; "Export Type", Status)
        {

        }
    }

    fieldgroups
    {
    }


    procedure ResetStatus(var _ETransportLogEntry: Record "SSAEDE-Documents Log Entry")
    var
        Confirmed: Boolean;
    begin
        Clear(Confirmed);
        _ETransportLogEntry.FindSet(true);
        repeat
            if _ETransportLogEntry.Status <> _ETransportLogEntry.Status::Error then begin
                if not Confirmed then begin
                    if not Confirm('Sigur resetati status?', false) then
                        Error('');
                    Confirmed := true;
                end;
            end else
                _ETransportLogEntry.TestField(Status, Status::Error);

            _ETransportLogEntry.Validate(Status, _ETransportLogEntry.Status::New);
            _ETransportLogEntry.Validate("Error Message", '');
            _ETransportLogEntry.ServerFilePath := '';
            _ETransportLogEntry.ClientFileName := '';
            _ETransportLogEntry."Stare Mesaj" := '';
            _ETransportLogEntry."ID Descarcare" := '';
            _ETransportLogEntry.Modify(true);

        until _ETransportLogEntry.Next = 0;
    end;
}

