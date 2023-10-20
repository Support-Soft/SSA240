tableextension 70010 "SSA Vendor70010" extends Vendor
{
    // SSA973 SSCAT 06.09.2019 39.Rapoarte legale- Localizare Declaratia 394
    // SSA947 SSCAT 10.01.2019 13.Funct. “TVA la incasare”
    // SSA966 SSCAT 03.10.2019 32.Funct. verificare TVA (ANAF, verificaretva.ro) - TVA la plata, split TVA
    // SSA1197 SSCAT 26.10.2019 cont bancar TVA split
    fields
    {
        field(70000; "SSA Tip Partener"; Option)
        {
            Caption = 'Tip Partener';
            DataClassification = CustomerContent;
            Description = 'SSA973';
            OptionCaption = ' ,1-CUI Valid din RO si din afara inreg. in scopuri de TVA in RO,2-CNP PFA din RO sau CUI neinregistrat in scopuri de TVA,3-Fara CUI valid din UE fara RO,4-Fara CUI valid din afara UE fara RO';
            OptionMembers = " ","1-CUI Valid din RO si din afara inreg. in scopuri de TVA in RO","2-CNP PFA din RO sau CUI neinregistrat in scopuri de TVA","3-Fara CUI valid din UE fara RO","4-Fara CUI valid din afara UE fara RO";
        }
        field(70001; "SSA Cod Judet D394"; Option)
        {
            Caption = 'Cod Judet D394';
            DataClassification = CustomerContent;
            Description = 'SSA973';
            OptionCaption = ' ,1-Alba,2-Arad,3-Arges,4-Bacau,5-Bihor,6-Bistrita-Nasaud,7-Botosani,8-Brasov,9-Braila,10-Buzau,11-Caras-Severin,12-Cluj,13-Constanta,14-Covasna,15-Dambovita,16-Dolj,17-Galati,18-Gorj,19-Harghita,20-Hunedoara,21-Ialomita,22-Iasi,23-Ilfov,24-Maramures,25-Mehedinti,26-Mures,27-Neamt,28-Olt,29-Prahova,30-Satu Mare,31-Salaj,32-Sibiu,33-Suceava,34-Teleorman,35-Timis,36-Tulcea,37-Vaslui,38-Valcea,39-Vrancea,40-Municipiul Bucuresti,,,,,,,,,,,51-Calarasi,52-Giurgiu';
            OptionMembers = " ","1-Alba","2-Arad","3-Arges","4-Bacau","5-Bihor","6-Bistrita-Nasaud","7-Botosani","8-Brasov","9-Braila","10-Buzau","11-Caras-Severin","12-Cluj","13-Constanta","14-Covasna","15-Dambovita","16-Dolj","17-Galati","18-Gorj","19-Harghita","20-Hunedoara","21-Ialomita","22-Iasi","23-Ilfov","24-Maramures","25-Mehedinti","26-Mures","27-Neamt","28-Olt","29-Prahova","30-Satu Mare","31-Salaj","32-Sibiu","33-Suceava","34-Teleorman","35-Timis","36-Tulcea","37-Vaslui","38-Valcea","39-Vrancea","40-Municipiul Bucuresti",,,,,,,,,,,"51-Calarasi","52-Giurgiu";
        }
        field(70002; "SSA Organization type"; Option)
        {
            Caption = 'Organization type';
            DataClassification = CustomerContent;
            Description = 'SSA973';
            OptionCaption = ' ,Private Legal Person,Natural Person,Authorised Natural Person,Public Legal Person';
            OptionMembers = " ","Private Legal Person","Natural Person","Authorised Natural Person","Public Legal Person";
        }
        field(70003; "SSA VAT to Pay"; Boolean)
        {
            Caption = 'VAT to Pay';
            DataClassification = CustomerContent;
            Description = 'SSA947';

            trigger OnValidate()
            var
                SSASetup: Record "SSA Localization Setup";
                CompanyInformation: Record "Company Information";
            begin
                //SSA947>>
                CompanyInformation.Get();
                TestField("Country/Region Code", CompanyInformation."Country/Region Code");
                SSASetup.Get();
                SSASetup.TestField("Vendor Neex. VAT Posting Group");
                SSASetup.TestField("Vendor Ex. VAT Posting Group");
                if "SSA VAT to Pay" then
                    Validate("VAT Bus. Posting Group", SSASetup."Vendor Neex. VAT Posting Group")
                else
                    Validate("VAT Bus. Posting Group", SSASetup."Vendor Ex. VAT Posting Group");
                //SSA947<<
            end;
        }
        field(70004; "SSA Commerce Trade No."; Code[20])
        {
            Caption = 'Commerce Trade No.';
            DataClassification = CustomerContent;
            Description = 'SSA966';
        }
        field(70005; "SSA Not VAT Registered"; Boolean)
        {
            Caption = 'Not VAT Registered';
            DataClassification = CustomerContent;
            Description = 'SSA966';
        }
        field(70006; "SSA Split VAT"; Boolean)
        {
            Caption = 'Split VAT';
            DataClassification = CustomerContent;
            Description = 'SSA966';
        }
        field(70007; "SSA Last Date Modified VAT"; Date)
        {
            Caption = 'Last Date Modified VAT';
            DataClassification = CustomerContent;
            Description = 'SSA966';
        }
        field(70008; "SSA Split VAT Bank Account No."; Code[20])
        {
            Caption = 'Split VAT Bank Account No.';
            DataClassification = CustomerContent;
            Description = 'SSA1197';
            TableRelation = "Vendor Bank Account".Code where("Vendor No." = field("No."));

            trigger OnValidate()
            begin
                //SSM1197>>
                TestField("SSA Split VAT", true);
                //SSM1197<<
            end;
        }
        field(70009; "SSA Vendor Pstg. Grp. Filter"; Code[20])
        {
            Caption = 'Vendor Posting Group Filter';
            FieldClass = FlowFilter;
            TableRelation = "Vendor Posting Group";
        }
        field(70010; "SSA Net Change (LCY)"; Decimal)
        {
            Caption = 'Net Change (LCY)';
            FieldClass = FlowField;
            CalcFormula = sum("Detailed Vendor Ledg. Entry"."Amount (LCY)" where("Vendor No." = field("No."), "Initial Entry Global Dim. 1" = field("Global Dimension 1 Filter"), "Initial Entry Global Dim. 2" = field("Global Dimension 2 Filter"), "Posting Date" = field("Date Filter"), "Currency Code" = field("Currency Filter"), "SSA Vendor Posting Group" = field("SSA Vendor Pstg. Grp. Filter")));
            Editable = false;
        }
        field(70011; "SSA Net Change"; Decimal)
        {
            Caption = 'Net Change';
            FieldClass = FlowField;
            CalcFormula = sum("Detailed Vendor Ledg. Entry".Amount where("Vendor No." = field("No."), "Initial Entry Global Dim. 1" = field("Global Dimension 1 Filter"), "Initial Entry Global Dim. 2" = field("Global Dimension 2 Filter"), "Posting Date" = field("Date Filter"), "Currency Code" = field("Currency Filter"), "SSA Vendor Posting Group" = field("SSA Vendor Pstg. Grp. Filter")));
            Editable = false;
        }
        field(70012; "SSA Persoana Afiliata"; Boolean)
        {
            Caption = 'Persoana Afiliata';
            DataClassification = CustomerContent;
        }
    }
}
