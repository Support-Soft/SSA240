tableextension 70009 "SSA Customer 70009" extends Customer
{
    // SSA973 SSCAT 06.09.2019 39.Rapoarte legale- Localizare Declaratia 394
    // SSA966 SSCAT 03.10.2019 32.Funct. verificare TVA (ANAF, verificaretva.ro) - TVA la plata, split TVA
    // SSA968 SSCAT 04.10.2019 34.Funct. Operatiuni triunghiulare, delivery, cod registru comertului, numar comanda client
    // SSA1197 SSCAT 23.10.2019 cont bancar TVA split
    fields
    {
        field(70000; "SSA Tip Partener"; Option)
        {
            Caption = 'Tip Partener';
            DataClassification = ToBeClassified;
            Description = 'SSA973';
            OptionCaption = ' ,1-CUI Valid din RO si din afara inreg. in scopuri de TVA in RO,2-CNP PFA din RO sau CUI neinregistrat in scopuri de TVA,3-Fara CUI valid din UE fara RO,4-Fara CUI valid din afara UE fara RO';
            OptionMembers = " ","1-CUI Valid din RO si din afara inreg. in scopuri de TVA in RO","2-CNP PFA din RO sau CUI neinregistrat in scopuri de TVA","3-Fara CUI valid din UE fara RO","4-Fara CUI valid din afara UE fara RO";
        }
        field(70001; "SSA Cod Judet D394"; Option)
        {
            Caption = 'Cod Judet D394';
            DataClassification = ToBeClassified;
            Description = 'SSA973';
            OptionCaption = ' ,1-Alba,2-Arad,3-Arges,4-Bacau,5-Bihor,6-Bistrita-Nasaud,7-Botosani,8-Brasov,9-Braila,10-Buzau,11-Caras-Severin,12-Cluj,13-Constanta,14-Covasna,15-Dambovita,16-Dolj,17-Galati,18-Gorj,19-Harghita,20-Hunedoara,21-Ialomita,22-Iasi,23-Ilfov,24-Maramures,25-Mehedinti,26-Mures,27-Neamt,28-Olt,29-Prahova,30-Satu Mare,31-Salaj,32-Sibiu,33-Suceava,34-Teleorman,35-Timis,36-Tulcea,37-Vaslui,38-Valcea,39-Vrancea,40-Municipiul Bucuresti,,,,,,,,,,,51-Calarasi,52-Giurgiu';
            OptionMembers = " ","1-Alba","2-Arad","3-Arges","4-Bacau","5-Bihor","6-Bistrita-Nasaud","7-Botosani","8-Brasov","9-Braila","10-Buzau","11-Caras-Severin","12-Cluj","13-Constanta","14-Covasna","15-Dambovita","16-Dolj","17-Galati","18-Gorj","19-Harghita","20-Hunedoara","21-Ialomita","22-Iasi","23-Ilfov","24-Maramures","25-Mehedinti","26-Mures","27-Neamt","28-Olt","29-Prahova","30-Satu Mare","31-Salaj","32-Sibiu","33-Suceava","34-Teleorman","35-Timis","36-Tulcea","37-Vaslui","38-Valcea","39-Vrancea","40-Municipiul Bucuresti",,,,,,,,,,,"51-Calarasi","52-Giurgiu";
        }
        field(70002; "SSA Organization type"; Option)
        {
            Caption = 'Organization type';
            DataClassification = ToBeClassified;
            Description = 'SSA973';
            OptionCaption = ' ,Private Legal Person,Natural Person,Authorised Natural Person,Public Legal Person';
            OptionMembers = " ","Private Legal Person","Natural Person","Authorised Natural Person","Public Legal Person";

            trigger OnValidate()
            begin
                /*
                 IF "Organization type"=2 THEN
                 BEGIN
                   "VAT Registration No." := 'X';
                   "Commerce Trade No." := 'X';
                   "Not VAT Registered" := TRUE;
                 END
                 ELSE
                   BEGIN
                     IF "VAT Registration No." = 'X' THEN
                     BEGIN
                         "VAT Registration No." := '';
                         "Not VAT Registered" := TRUE;
                     END;
                     IF "Commerce Trade No." = 'X' THEN
                         "Commerce Trade No." := '';
                   END;
               */

            end;
        }
        field(70003; "SSA Commerce Trade No."; Code[20])
        {
            Caption = 'Commerce Trade No.';
            DataClassification = ToBeClassified;
            Description = 'SSA966';
        }
        field(70004; "SSA Not VAT Registered"; Boolean)
        {
            Caption = 'Not VAT Registered';
            DataClassification = ToBeClassified;
            Description = 'SSA966';
        }
        field(70005; "SSA Last Date Modified VAT"; Date)
        {
            Caption = 'Last Date Modified VAT';
            DataClassification = ToBeClassified;
            Description = 'SSA966';
        }
        field(70006; "SSA Split VAT Bank Account No."; Code[20])
        {
            Caption = 'Split VAT Bank Account No.';
            DataClassification = ToBeClassified;
            Description = 'SSA1197';
            TableRelation = "Customer Bank Account".Code WHERE("Customer No." = FIELD("No."));
        }
        field(70007; "SSA Customer Pstg. Grp. Filter"; code[20])
        {
            Caption = 'Customer Posting Group Filter';
            FieldClass = FlowFilter;
            TableRelation = "Customer Posting Group";
        }
        field(70008; "SSA Net Change (LCY)"; Decimal)
        {
            Caption = 'SSA Net Change (LCY)';
            FieldClass = FlowField;
            CalcFormula = Sum ("Detailed Cust. Ledg. Entry"."Amount (LCY)" WHERE("Customer No." = FIELD("No."), "Initial Entry Global Dim. 1" = FIELD("Global Dimension 1 Filter"), "Initial Entry Global Dim. 2" = FIELD("Global Dimension 2 Filter"), "Posting Date" = FIELD("Date Filter"), "Currency Code" = FIELD("Currency Filter"), "SSA Customer Posting Group" = field("SSA Customer Pstg. Grp. Filter")));
        }
        field(70009; "SSA Net Change"; Decimal)
        {
            Caption = 'SSA Net Change';
            FieldClass = FlowField;
            CalcFormula = Sum ("Detailed Cust. Ledg. Entry"."Amount" WHERE("Customer No." = FIELD("No."), "Initial Entry Global Dim. 1" = FIELD("Global Dimension 1 Filter"), "Initial Entry Global Dim. 2" = FIELD("Global Dimension 2 Filter"), "Posting Date" = FIELD("Date Filter"), "Currency Code" = FIELD("Currency Filter"), "SSA Customer Posting Group" = field("SSA Customer Pstg. Grp. Filter")));
        }
        field(70010; "SSA Persoana Afiliata"; Boolean)
        {
            Caption = 'Persoana Afiliata';
        }
    }
}

