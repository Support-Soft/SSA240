table 71702 "SSA Domestic Declaration Line"
{
    // SSA973 SSCAT 06.09.2019 39.Rapoarte legale- Localizare Declaratia 394

    LookupPageId = "SSA Domestic Declaration";
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Domestic Declaration Code"; Code[10])
        {
            Caption = 'Domestic Declaration Code';
            Editable = false;
            TableRelation = "SSA Domestic Declaration";
        }
        field(2; "Line No."; Integer)
        {
            Caption = 'Line No.';
            Editable = false;
        }
        field(3; "Source VAT Entry No."; Integer)
        {
            Caption = 'Source VAT Entry No.';
            Editable = false;
            TableRelation = "VAT Entry"."Entry No.";
        }
        field(4; "Posting Date"; Date)
        {
            Caption = 'Posting Date';

            trigger OnValidate()
            begin
                DomesticDeclaration.Get("Domestic Declaration Code");
                DomesticDeclaration.TestField("Starting Date");
                DomesticDeclaration.TestField("Ending Date");

                if ("Posting Date" < DomesticDeclaration."Starting Date") or ("Posting Date" > DomesticDeclaration."Ending Date") then
                    Error(Text004, FieldCaption("Posting Date"), DomesticDeclaration.Code, "Line No.");
            end;
        }
        field(5; "Document No."; Code[20])
        {
            Caption = 'Document No.';
        }
        field(6; "Document Type"; Option)
        {
            Caption = 'Document Type';
            OptionCaption = 'Invoice,Credit Memo';
            OptionMembers = Invoice,"Credit Memo";
        }
        field(7; Type; Option)
        {
            Caption = 'Type';
            OptionCaption = 'Sale,Purchase';
            OptionMembers = Sale,Purchase;

            trigger OnValidate()
            begin
                if Type <> xRec.Type then
                    "Bill-to/Pay-to No." := '';
            end;
        }
        field(8; Base; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Base';

            trigger OnValidate()
            begin
                if (Type = Type::Sale) and ("Document Type" = "Document Type"::Invoice) then
                    if Base > 0 then
                        Error(Text006, FieldCaption(Base), "Domestic Declaration Code", "Line No.", "Document Type", Type);
                if (Type = Type::Sale) and ("Document Type" = "Document Type"::"Credit Memo") then
                    if Base < 0 then
                        Error(Text005, FieldCaption(Base), "Domestic Declaration Code", "Line No.", "Document Type", Type);
                if (Type = Type::Purchase) and ("Document Type" = "Document Type"::Invoice) then
                    if Base < 0 then
                        Error(Text006, FieldCaption(Base), "Domestic Declaration Code", "Line No.", "Document Type", Type);
                if (Type = Type::Purchase) and ("Document Type" = "Document Type"::"Credit Memo") then
                    if Base > 0 then
                        Error(Text006, FieldCaption(Base), "Domestic Declaration Code", "Line No.", "Document Type", Type);
            end;
        }
        field(9; Amount; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Amount';

            trigger OnValidate()
            begin
                if (Type = Type::Sale) and ("Document Type" = "Document Type"::Invoice) then
                    if Amount > 0 then
                        Error(Text006, FieldCaption(Base), "Domestic Declaration Code", "Line No.", "Document Type", Type);
                if (Type = Type::Sale) and ("Document Type" = "Document Type"::"Credit Memo") then
                    if Amount < 0 then
                        Error(Text005, FieldCaption(Base), "Domestic Declaration Code", "Line No.", "Document Type", Type);
                if (Type = Type::Purchase) and ("Document Type" = "Document Type"::Invoice) then
                    if Amount < 0 then
                        Error(Text006, FieldCaption(Base), "Domestic Declaration Code", "Line No.", "Document Type", Type);
                if (Type = Type::Purchase) and ("Document Type" = "Document Type"::"Credit Memo") then
                    if Amount > 0 then
                        Error(Text006, FieldCaption(Base), "Domestic Declaration Code", "Line No.", "Document Type", Type);
            end;
        }
        field(10; "VAT Calculation Type"; Option)
        {
            Caption = 'VAT Calculation Type';
            OptionCaption = 'Normal VAT,Reverse Charge VAT,Full VAT,Sales Tax';
            OptionMembers = "Normal VAT","Reverse Charge VAT","Full VAT","Sales Tax";
        }
        field(12; "Bill-to/Pay-to No."; Code[20])
        {
            Caption = 'Bill-to/Pay-to No.';
            TableRelation = if (Type = const(Purchase)) Vendor
            else
            if (Type = const(Sale)) Customer;

            trigger OnValidate()
            begin
                if "Vendor/Customer Name" <> '' then
                    "Vendor/Customer Name" := '';

                if Type = Type::Sale then
                    if Customer.Get("Bill-to/Pay-to No.") then begin
                        CompanyInfo.Get;
                        "VAT Registration No." := DelChr(UpperCase(Customer."VAT Registration No."), '=', CompanyInfo."Country/Region Code");
                    end;
                if Type = Type::Purchase then
                    if Vendor.Get("Bill-to/Pay-to No.") then begin
                        CompanyInfo.Get;
                        "VAT Registration No." := DelChr(UpperCase(Vendor."VAT Registration No."), '=', CompanyInfo."Country/Region Code");
                    end;

                if "Bill-to/Pay-to No." = '' then
                    "VAT Registration No." := '';
            end;
        }
        field(15; "Source Code"; Code[10])
        {
            Caption = 'Source Code';
            TableRelation = "Source Code";
        }
        field(21; "Transaction No."; Integer)
        {
            Caption = 'Transaction No.';
        }
        field(26; "External Document No."; Code[35])
        {
            Caption = 'External Document No.';
        }
        field(39; "VAT Bus. Posting Group"; Code[20])
        {
            Caption = 'VAT Bus. Posting Group';
            TableRelation = "VAT Business Posting Group";
        }
        field(40; "VAT Prod. Posting Group"; Code[20])
        {
            Caption = 'VAT Prod. Posting Group';
            TableRelation = "VAT Product Posting Group";
        }
        field(55; "VAT Registration No."; Text[20])
        {
            Caption = 'VAT Registration No.';
        }
        field(56; "Vendor/Customer Name"; Text[100])
        {
            Caption = 'Vendor/Customer Name';

            trigger OnValidate()
            begin
                if "Bill-to/Pay-to No." <> '' then
                    Error(Text003, FieldCaption("Vendor/Customer Name"), FieldCaption("Bill-to/Pay-to No."));
            end;
        }
        field(50000; "Detailed 394 Decl."; Code[20])
        {
            Caption = 'Detailed 394 Decl.';
            Editable = false;
        }
        field(50001; "Document Date"; Date)
        {
            Caption = 'Document Date';
        }
        field(50200; "Postponed VAT Payment"; Boolean)
        {
            Caption = 'Postponed VAT Payment';
        }
        field(50201; "Record Document Number"; Text[40])
        {
            Caption = 'Record Document Number';
        }
        field(50202; Correction; Boolean)
        {
            Caption = 'Correction';
        }
        field(92200; "Tip Document D394"; Option)
        {
            OptionCaption = ' ,Factura Fiscala,Bon Fiscal,Factura Simplificata,Borderou,File Carnet,Contract,Alte Documente';
            OptionMembers = " ","Factura Fiscala","Bon Fiscal","Factura Simplificata",Borderou,"File Carnet",Contract,"Alte Documente";
            Caption = 'Tip Document D394';
        }
        field(92201; "Stare Factura"; Option)
        {
            OptionCaption = ' ,0-Factura Emisa,1-Factura Stornata,2-Factura Anulata,3-Autofactura,4-In calidate de beneficiar in numele furnizorului';
            OptionMembers = " ","0-Factura Emisa","1-Factura Stornata","2-Factura Anulata","3-Autofactura","4-In calidate de beneficiar in numele furnizorului";
            Caption = 'Stare Factura';
        }
        field(92210; "Tip Partener"; Option)
        {
            OptionCaption = ' ,1-CUI Valid din RO si din afara inreg. in scopuri de TVA in RO,2-CNP PFA din RO sau CUI neinregistrat in scopuri de TVA,3-Fara CUI valid din UE fara RO,4-Fara CUI valid din afara UE fara RO';
            OptionMembers = " ","1-CUI Valid din RO si din afara inreg. in scopuri de TVA in RO","2-CNP PFA din RO sau CUI neinregistrat in scopuri de TVA","3-Fara CUI valid din UE fara RO","4-Fara CUI valid din afara UE fara RO";
            Caption = 'Tip Partener';
        }
        field(92220; "Tip Operatie"; Option)
        {
            OptionMembers = " ",L,LS,A,AI,AS,ASI,V,C,N;
            Caption = 'Tip Operatie';
        }
        field(92240; "Cod Serie Factura"; Code[20])
        {
            Caption = 'No. Series';
            Editable = false;
            TableRelation = "No. Series";
        }
        field(92250; "Cod CAEN"; Code[10])
        {
            Caption = 'Cod CAEN';
        }
        field(92251; "Tip Operatiune CAEN"; Option)
        {
            OptionMembers = " ","1-livrari de bunuri","2-prestari servicii";
            Caption = 'Tip Operatiune CAEN';
        }
        field(92260; "Tax Group Code"; Code[10])
        {
            Caption = 'Tax Group Code';
            TableRelation = "Tax Group";
        }
        field(92270; "Organization type"; Option)
        {
            Caption = 'Organization type';
            OptionCaption = ' ,Private Legal Person,Natural Person,Authorised Natural Person,Public Legal Person';
            OptionMembers = " ","Private Legal Person","Natural Person","Authorised Natural Person","Public Legal Person";
        }
        field(92280; "VAT to pay"; Boolean)
        {
            Caption = 'VAT to pay';
        }
        field(92290; Cota; Decimal)
        {
            Caption = 'Journals VAT %';
            DecimalPlaces = 0 : 2;
        }
        field(92300; "Cod tara D394"; Text[60])
        {
            Caption = 'Cod tara D394';
        }
        field(92310; "Cod Judet D394"; Option)
        {
            OptionCaption = ' ,1-Alba,2-Arad,3-Arges,4-Bacau,5-Bihor,6-Bistrita-Nasaud,7-Botosani,8-Brasov,9-Braila,10-Buzau,11-Caras-Severin,12-Cluj,13-Constanta,14-Covasna,15-Dambovita,16-Dolj,17-Galati,18-Gorj,19-Harghita,20-Hunedoara,21-Ialomita,22-Iasi,23-Ilfov,24-Maramures,25-Mehedinti,26-Mures,27-Neamt,28-Olt,29-Prahova,30-Satu Mare,31-Salaj,32-Sibiu,33-Suceava,34-Teleorman,35-Timis,36-Tulcea,37-Vaslui,38-Valcea,39-Vrancea,40-Municipiul Bucuresti,,,,,,,,,,,51-Calarasi,52-Giurgiu';
            OptionMembers = " ","1-Alba","2-Arad","3-Arges","4-Bacau","5-Bihor","6-Bistrita-Nasaud","7-Botosani","8-Brasov","9-Braila","10-Buzau","11-Caras-Severin","12-Cluj","13-Constanta","14-Covasna","15-Dambovita","16-Dolj","17-Galati","18-Gorj","19-Harghita","20-Hunedoara","21-Ialomita","22-Iasi","23-Ilfov","24-Maramures","25-Mehedinti","26-Mures","27-Neamt","28-Olt","29-Prahova","30-Satu Mare","31-Salaj","32-Sibiu","33-Suceava","34-Teleorman","35-Timis","36-Tulcea","37-Vaslui","38-Valcea","39-Vrancea","40-Municipiul Bucuresti",,,,,,,,,,,"51-Calarasi","52-Giurgiu";
            Caption = 'Cod Judet D394';
        }
        field(92320; "Unrealized VAT Entry No."; Integer)
        {
            Caption = 'Unrealized VAT Entry No.';
            Editable = false;
            TableRelation = "VAT Entry";
        }
        field(92330; "Not Declaration 394"; Boolean)
        {
            Caption = 'Not Declaration 394';
            Editable = true;
        }
        field(92340; "Persoana Afiliata"; Boolean)
        {
            Caption = 'Persoana Afiliata';
        }
    }

    keys
    {
        key(Key1; "Domestic Declaration Code", "Line No.")
        {
            Clustered = true;
            SumIndexFields = Base, Amount;
        }
        key(Key2; "VAT Registration No.")
        {
        }
        key(Key3; "Bill-to/Pay-to No.", "VAT Registration No.")
        {
        }
        key(Key4; "Domestic Declaration Code", "Cod Serie Factura")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        DomesticDeclaration.Get("Domestic Declaration Code");
        DomesticDeclaration.TestField(Reported, false);
    end;

    trigger OnInsert()
    begin
        DomesticDeclaration.Get("Domestic Declaration Code");
        DomesticDeclaration.TestField(Reported, false);
    end;

    trigger OnModify()
    begin
        DomesticDeclaration.Get("Domestic Declaration Code");
        DomesticDeclaration.TestField(Reported, false);
    end;

    trigger OnRename()
    begin
        DomesticDeclaration.Get("Domestic Declaration Code");
        DomesticDeclaration.TestField(Reported, false);
    end;

    var
        CompanyInfo: Record "Company Information";
        Customer: Record Customer;
        Vendor: Record Vendor;
        DomesticDeclaration: Record "SSA Domestic Declaration";
        Text001: Label 'DEFAULT';
        Text002: Label 'Default Domestic Declaration';
        Text003: Label 'You cannot fill in the %1 field when the %2 field is filled in.';
        Text004: Label '%1 in Domestic Declaration Code = ''%2'', Line No. = ''%3'' is out of the declaration period.\Please correct the value.';
        Text005: Label '%1 in Domestic Declaration Code = ''%2'', Line No. = ''%3'', Document Type = ''%4'', Type = ''%5'' must not be less than 0.';
        Text006: Label '%1 in Domestic Declaration Code = ''%2'', Line No. = ''%3'', Document Type = ''%4'', Type = ''%5'' must not be more than 0.';

    procedure OpenJnl(var CurrentDeclarationNo: Code[10]; var DomesticDeclarationLine: Record "SSA Domestic Declaration Line")
    begin
        DomesticDeclarationLine.Reset();
        DomesticDeclarationLine.CheckName(CurrentDeclarationNo, DomesticDeclarationLine);
        DomesticDeclarationLine.FilterGroup(2);
        DomesticDeclarationLine.SetRange("Domestic Declaration Code", CurrentDeclarationNo);
        DomesticDeclarationLine.FilterGroup(0);
    end;

    procedure CheckName(var CurrentDeclarationNo: Code[10]; var DomesticDeclarationLine: Record "SSA Domestic Declaration Line")
    var
        DomesticDeclaration: Record "SSA Domestic Declaration";
    begin
        if not DomesticDeclaration.Get(CurrentDeclarationNo) then begin
            if not DomesticDeclaration.Find('-') then begin
                DomesticDeclaration.Init;
                DomesticDeclaration.Code := Text001;
                DomesticDeclaration.Description := Text002;
                DomesticDeclaration.Insert;
                Commit;
            end;
            CurrentDeclarationNo := DomesticDeclaration.Code;
        end;
    end;

    procedure SetName(var CurrentDeclarationNo: Code[10]; var DomesticDeclarationLine: Record "SSA Domestic Declaration Line")
    begin
        DomesticDeclarationLine.FilterGroup(2);
        DomesticDeclarationLine.SetRange("Domestic Declaration Code", CurrentDeclarationNo);
        DomesticDeclarationLine.FilterGroup(0);
        if DomesticDeclarationLine.Find('-') then;
    end;

    procedure LookupName(CurrentDeclarationNo: Code[10]; var EntrdDomesticDeclaration: Text[10]): Boolean
    var
        DomesticDeclaration: Record "SSA Domestic Declaration";
    begin
        DomesticDeclaration.Code := CurrentDeclarationNo;
        DomesticDeclaration.FilterGroup(2);
        if PAGE.RunModal(0, DomesticDeclaration) <> ACTION::LookupOK then
            exit(false);

        EntrdDomesticDeclaration := DomesticDeclaration.Code;
        exit(true);
    end;

    procedure GetLine(Number: Integer)
    begin
        if Number = 1 then
            Find('-')
        else
            Next;
    end;
}
