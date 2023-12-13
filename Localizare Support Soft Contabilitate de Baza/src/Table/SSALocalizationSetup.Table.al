table 70006 "SSA Localization Setup"
{
    // SSA937 SSCAT 16.06.2019 3.Funct. Bonuri de consum-consum intern
    // SSA951 SSCAT 05.07.2019 17.Funct. Inreg. in rosu la cantitati negative
    // SSA957 SSCAT 23.08.2019 23.Funct. Obiecte de inventar: lista si fisa obiecte de inventar, punere in functiune, full description
    // SSA958 SSCAT 23.08.2019 24.Funct. verificare sa nu posteze sell to diferit de bill to
    // SSA973 SSCAT 06.09.2019 39.Rapoarte legale- Localizare Declaratia 394
    // SSA946 SSCAT 26.09.2019 12.Funct. functionalitate DVI la achizitii
    // SSA947 SSCAT 10.01.2019 13.Funct. “TVA la incasare”
    // SSA970 SSCAT 07.10.2019 36.Funct. UOM Mandatory, dimensiuni pe rounding, intercompany, denumire, conturi bancare
    // SSA1196 SSCAT 04.11.2019 Leasing

    Caption = 'Localization Setup';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            Caption = 'Primary Key';
        }
        field(10; "Internal Consumption Nos."; Code[10])
        {
            Caption = 'Internal Consumption Nos.';
            TableRelation = "No. Series";
        }
        field(20; "Posted Int. Consumption Nos."; Code[10])
        {
            Caption = 'Posted Int. Consumption Nos.';
            TableRelation = "No. Series";
        }
        field(30; "Outbound Whse. Handling Time"; DateFormula)
        {
            Caption = 'Outbound Whse. Handling Time';
        }
        field(40; "Transfer Gen. Bus. Pstg. Group"; Code[10])
        {
            Caption = 'Transfer Gen. Bus. Pstg. Group';
            TableRelation = "Gen. Business Posting Group";
        }
        field(50; "Assembly Gen. Bus. Pstg. Group"; Code[10])
        {
            Caption = 'Assembly Gen. Bus. Pstg. Group';
            TableRelation = "Gen. Business Posting Group";
        }
        field(60; "Sales Negative Line Correction"; Boolean)
        {
            Caption = 'Sales Negative Line Correction';
            Description = 'SSA951';
        }
        field(70; "Purch Negative Line Correction"; Boolean)
        {
            Caption = 'Purch Negative Line Correction';
            Description = 'SSA951';
        }
        field(80; "Transaction Type Mandatory"; Boolean)
        {
            Caption = 'Transaction Type Mandatory';
            Description = 'SSA954';
        }
        field(90; "Transaction Spec. Mandatory"; Boolean)
        {
            Caption = 'Transaction Spec. Mandatory';
            Description = 'SSA954';
        }
        field(100; "Transport Method Mandatory"; Boolean)
        {
            Caption = 'Transport Method Mandatory';
            Description = 'SSA954';
        }
        field(110; "Shipment Method Mandatory"; Boolean)
        {
            Caption = 'Shipment Method Mandatory';
            Description = 'SSA954';
        }
        field(120; "Fixed Asset Nos."; Code[20])
        {
            Caption = 'Fixed Asset Nos.';
            Description = 'SSA957';
            TableRelation = "No. Series";
        }
        field(130; "Fixed Asset Inventory Nos."; Code[20])
        {
            Caption = 'Fixed Asset Inventory Nos.';
            Description = 'SSA957';
            TableRelation = "No. Series";
        }
        field(140; "Allow Diff. Sell-to Bill-to"; Boolean)
        {
            Caption = 'Allow Diff. Sell-to Bill-to';
            Description = 'SSA958';
        }
        field(150; "Allow Diff. Buy-from Pay-to"; Boolean)
        {
            Caption = 'Allow Diff. Buy-from Pay-to';
            Description = 'SSA958';
        }
        field(160; "Sistem TVA"; Option)
        {
            Caption = 'VAT System';
            Description = 'SSA973';
            OptionCaption = ' ,Sistem Normal de TVA,Sistem de TVA la Incasare,Neplatitor de TVA';
            OptionMembers = " ","Sistem Normal de TVA","Sistem de TVA la Incasare","Neplatitor de TVA";
            trigger OnValidate()
            begin
                if "Sistem TVA" = "Sistem TVA"::"Neplatitor de TVA" then begin
                    TestField("Cust. Nepl. VAT Posting Group");
                    TestField("Vendor Nepl. VAT Posting Group");
                end;
            end;
        }
        field(170; "Skip Errors before date"; Date)
        {
            Caption = 'Skip Errors before date';
            Description = 'SSA973';
        }
        field(180; "CAEN Code"; Code[4])
        {
            Caption = 'CAEN Code';
            Description = 'SSA973';
        }
        field(190; "Custom Invoice No. Mandatory"; Boolean)
        {
            Caption = 'Custom Invoice No. Mandatory';
            Description = 'SSA946';
        }
        field(200; "Vendor Neex. VAT Posting Group"; Code[10])
        {
            Caption = 'Vendor Neex. VAT Posting Group';
            Description = 'SSA947';
            TableRelation = "VAT Business Posting Group";
        }
        field(210; "Vendor Ex. VAT Posting Group"; Code[10])
        {
            Caption = 'Vendor Ex. VAT Posting Group';
            Description = 'SSA947';
            TableRelation = "VAT Business Posting Group";
        }
        field(220; "Cust. Neex. VAT Posting Group"; Code[10])
        {
            Caption = 'Cust. Neex. VAT Posting Group';
            Description = 'SSA947';
            TableRelation = "VAT Business Posting Group";
        }
        field(230; "Cust. Ex. VAT Posting Group"; Code[10])
        {
            Caption = 'Cust. Ex. VAT Posting Group';
            Description = 'SSA947';
            TableRelation = "VAT Business Posting Group";
        }
        field(290; "Unit of Measure Mandatory"; Boolean)
        {
            Caption = 'Unit of Measure Mandatory';
            Description = 'SSA970';
        }
        field(300; "Rounding Dimension Set ID"; Integer)
        {
            Caption = 'Rounding Dimension Set ID';
            Description = 'SSA970';
            Editable = false;
            TableRelation = "Dimension Set Entry";

            trigger OnLookup()
            begin
                ShowDimensions(); //SSA970
            end;
        }
        field(470; "Leasing Journal Template"; Code[20])
        {
            Caption = 'Leasing Journal Template 2';
            Description = 'SSA1196';
            TableRelation = "Gen. Journal Template";
        }
        field(480; "Advance Journal Template"; Code[20])
        {
            Caption = 'Advance Journal Template';
            Description = 'SSA1196';
            TableRelation = "Gen. Journal Template";
        }
        field(490; "Vendor Nepl. VAT Posting Group"; Code[10])
        {
            Caption = 'Vendor Nepl. VAT Posting Group';
            TableRelation = "VAT Business Posting Group";
        }
        field(500; "Cust. Nepl. VAT Posting Group"; Code[10])
        {
            Caption = 'Cust. Nepl. VAT Posting Group';
            TableRelation = "VAT Business Posting Group";
        }
        field(510; "Allow Post Inv. Wh Gen Bus."; Boolean)
        {
            Caption = 'Allow Post Inv. Wh Gen Bus. Grp';
        }
    }

    keys
    {
        key(Key1; "Primary Key")
        {
            Clustered = true;
        }
    }

    procedure ShowDimensions()
    var
        DimMgt: Codeunit DimensionManagement;
        Dim1Code: Code[20];
        Dim2Code: Code[20];
    begin
        //SSA970>>
        "Rounding Dimension Set ID" :=
          DimMgt.EditDimensionSet(
            "Rounding Dimension Set ID", 'Rounding Dimension',
            Dim1Code, Dim2Code);
        //SSA970<<
    end;
}
