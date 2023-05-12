tableextension 70012 "SSA VAT Entry70012" extends "VAT Entry"
{
    // SSA973 SSCAT 06.09.2019 39.Rapoarte legale- Localizare Declaratia 394
    // SSA946 SSCAT 26.09.2019 12.Funct. functionalitate DVI la achizitii
    // SSA1002 SSCAT 08.10.2019 69.Rapoarte legale-Jurnal cumparari neexigibil
    // SSA1003 SSCAT 03.11.2019 70.Rapoarte legale- Jurnal vanzari
    fields
    {
        field(70000; "SSA Tip Document D394"; Option)
        {
            Caption = 'Tip Document D394';
            DataClassification = ToBeClassified;
            Description = 'SSA973';
            OptionCaption = ' ,Factura Fiscala,Bon Fiscal,Factura Simplificata,Borderou,File Carnet,Contract,Alte Documente';
            OptionMembers = " ","Factura Fiscala","Bon Fiscal","Factura Simplificata",Borderou,"File Carnet",Contract,"Alte Documente";
        }
        field(70001; "SSA Stare Factura"; Option)
        {
            Caption = 'Stare Factura';
            DataClassification = ToBeClassified;
            Description = 'SSA973';
            OptionCaption = ' ,0-Factura Emisa,1-Factura Stornata,2-Factura Anulata,3-Autofactura,4-In calidate de beneficiar in numele furnizorului';
            OptionMembers = " ","0-Factura Emisa","1-Factura Stornata","2-Factura Anulata","3-Autofactura","4-In calidate de beneficiar in numele furnizorului";
        }
        field(70002; "SSA Tip Partener"; Option)
        {
            Caption = 'Tip Partener';
            DataClassification = ToBeClassified;
            Description = 'SSA973';
            OptionCaption = ' ,1-CUI Valid din RO si din afara inreg. in scopuri de TVA in RO,2-CNP PFA din RO sau CUI neinregistrat in scopuri de TVA,3-Fara CUI valid din UE fara RO,4-Fara CUI valid din afara UE fara RO';
            OptionMembers = " ","1-CUI Valid din RO si din afara inreg. in scopuri de TVA in RO","2-CNP PFA din RO sau CUI neinregistrat in scopuri de TVA","3-Fara CUI valid din UE fara RO","4-Fara CUI valid din afara UE fara RO";
        }
        field(70003; "SSA Not Declaration 394"; Boolean)
        {
            Caption = 'Not Declaration 394';
            DataClassification = ToBeClassified;
            Description = 'SSA973';
            Editable = false;
        }
        field(70004; "SSA Vendor/Customer Name"; Text[100])
        {
            Caption = 'Vendor/Customer Name';
            DataClassification = ToBeClassified;
            Description = 'SSA973';
        }
        field(70005; "SSA Custom Invoice No."; Code[20])
        {
            Caption = 'Custom Invoice No.';
            DataClassification = ToBeClassified;
            Description = 'SSA946';
        }
        field(70006; "SSA Realized Amount"; Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = Sum("VAT Entry".Amount WHERE("Unrealized VAT Entry No." = FIELD("Entry No."),
                                                        "Posting Date" = FIELD("SSA Date Filter")));
            Caption = 'Realized Amount';
            Description = 'SSA1002';
            Editable = false;
            FieldClass = FlowField;
        }
        field(70007; "SSA Realized Base"; Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = Sum("VAT Entry".Base WHERE("Unrealized VAT Entry No." = FIELD("Entry No."),
                                                      "Posting Date" = FIELD("SSA Date Filter")));
            Caption = 'Realized Base';
            Description = 'SSA1002';
            Editable = false;
            FieldClass = FlowField;
        }
        field(70008; "SSA Date Filter"; Date)
        {
            Caption = 'Date Filter';
            Description = 'SSA1002';
            FieldClass = FlowFilter;
        }
        field(70009; "SSA Unrealized Purch. Doc. No."; Code[35])
        {
            CalcFormula = Lookup("VAT Entry"."External Document No." WHERE("Entry No." = FIELD("Unrealized VAT Entry No.")));
            Caption = 'Unrealized Purchase Document No.';
            Description = 'SSA1002';
            Editable = false;
            FieldClass = FlowField;
        }
        field(70010; "SSA Unrealized Document Date"; Date)
        {
            CalcFormula = Lookup("VAT Entry"."Posting Date" WHERE("Entry No." = FIELD("Unrealized VAT Entry No.")));
            Caption = 'Unrealized Document Date';
            Description = 'SSA1003';
            Editable = false;
            FieldClass = FlowField;
        }
        field(70011; "SSA Unrealized Sales Doc. No."; Code[20])
        {
            CalcFormula = Lookup("VAT Entry"."Document No." WHERE("Entry No." = FIELD("Unrealized VAT Entry No.")));
            Caption = 'Unrealized Sales Document No.';
            Description = 'SSA1002';
            Editable = false;
            FieldClass = FlowField;
        }
    }
}

