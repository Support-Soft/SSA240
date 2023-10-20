table 70002 "SSA Pstd. Int. Cons. Header"
{
    // SSA937 SSCAT 16.06.2019 3.Funct. Bonuri de consum-consum intern
    // SSA1097 SSCAT 07.10.2019 Anulare bon consum

    Caption = 'Pstd. Int. Cons. Header';
    DrillDownPageId = "SSA Pstd Int. Cons. List";
    LookupPageId = "SSA Pstd Int. Cons. List";
    DataClassification = CustomerContent;

    fields
    {
        field(2; "No."; Code[20])
        {
            Caption = 'No.';
        }
        field(3; "Your Reference"; Text[30])
        {
            Caption = 'Your Reference';
        }
        field(4; "Order Date"; Date)
        {
            Caption = 'Order Date';
        }
        field(5; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
        }
        field(6; "Posting Description"; Text[50])
        {
            Caption = 'Posting Description';
        }
        field(7; "Location Code"; Code[10])
        {
            Caption = 'Location Code';
            TableRelation = Location where("Use As In-Transit" = const(false));
        }
        field(8; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Shortcut Dimension 1 Code';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1));
        }
        field(9; "Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2));
        }
        field(10; Comment; Boolean)
        {
            CalcFormula = exist("SSA Comment Line" where("Document Type" = filter("Internal Consumption"),
                                                          "No." = field("No.")));
            Caption = 'Comment';
            Editable = false;
            FieldClass = FlowField;
        }
        field(11; "No. Printed"; Integer)
        {
            Caption = 'No. Printed';
            Editable = false;
        }
        field(12; "Posting No."; Code[20])
        {
            Caption = 'Posting No.';
        }
        field(13; "Last Posting No."; Code[20])
        {
            Caption = 'Last Posting No.';
            Editable = false;
            TableRelation = "SSA Pstd. Int. Cons. Header";
        }
        field(14; "Reason Code"; Code[10])
        {
            Caption = 'Reason Code';
            TableRelation = "Reason Code";
        }
        field(15; "Gen. Bus. Posting Group"; Code[10])
        {
            Caption = 'Gen. Bus. Posting Group';
            TableRelation = "Gen. Business Posting Group";
        }
        field(16; Correction; Boolean)
        {
            Caption = 'Correction';
        }
        field(17; "Document Date"; Date)
        {
            Caption = 'Document Date';
        }
        field(18; "External Document No."; Code[20])
        {
            Caption = 'External Document No.';
        }
        field(19; "No. Series"; Code[10])
        {
            Caption = 'No. Series';
            Editable = false;
            TableRelation = "No. Series";
        }
        field(20; "Posting No. Series"; Code[10])
        {
            Caption = 'Posting No. Series';
            TableRelation = "No. Series";
        }
        field(21; "VAT Bus. Posting Group"; Code[10])
        {
            Caption = 'VAT Bus. Posting Group';
            TableRelation = "VAT Business Posting Group";
        }
        field(22; "Responsibility Center"; Code[10])
        {
            Caption = 'Responsibility Center';
            TableRelation = "Responsibility Center";
        }
        field(23; "Location Filter"; Code[10])
        {
            Caption = 'Location Filter';
            FieldClass = FlowFilter;
            TableRelation = Location;
        }
        field(24; "Shipping Time"; DateFormula)
        {
            Caption = 'Shipping Time';
        }
        field(25; "Outbound Whse. Handling Time"; DateFormula)
        {
            Caption = 'Outbound Whse. Handling Time';
        }
        field(26; "Date Filter"; Date)
        {
            Caption = 'Date Filter';
            FieldClass = FlowFilter;
        }
        field(109; "Pre-Assigned No. Series"; Code[10])
        {
            Caption = 'Pre-Assigned No. Series';
            TableRelation = "No. Series";
        }
        field(110; "Source Code"; Code[10])
        {
            Caption = 'Source Code';
            TableRelation = "Source Code";
        }
        field(111; "Pre-Assigned No."; Code[20])
        {
            Caption = 'Pre-Assigned No.';
        }
        field(480; "Dimension Set ID"; Integer)
        {
            Caption = 'Dimension Set ID';
            Editable = false;
            TableRelation = "Dimension Set Entry";

            trigger OnLookup()
            begin
                ShowDimensions();
            end;

            trigger OnValidate()
            begin
                DimMgt.UpdateGlobalDimFromDimSetID("Dimension Set ID", "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code");
            end;
        }
        field(5901; "User ID"; Code[50])
        {
            Caption = 'User ID';
            DataClassification = EndUserIdentifiableInformation;
            TableRelation = User."User Name";
            //This property is currently not supported
            //TestTableRelation = false;
        }
        field(70000; Cancelled; Boolean)
        {
            Caption = 'Cancelled';
            Description = 'SSA1097';
        }
        field(70001; "Cancelled from No."; Code[20])
        {
            Caption = 'Cancelled from No.';
            Description = 'SSA1097';
            TableRelation = "SSA Pstd. Int. Cons. Header";
        }
    }

    keys
    {
        key(Key1; "No.")
        {
            Clustered = true;
        }
    }


    var
        DimMgt: Codeunit DimensionManagement;

    procedure Navigate()
    var
        NavigateForm: Page Navigate;
    begin
        NavigateForm.SetDoc("Posting Date", "No.");
        NavigateForm.Run();
    end;

    procedure ShowDimensions()
    begin
        DimMgt.ShowDimensionSet("Dimension Set ID", StrSubstNo('%1 %2', TableCaption, "No."));
    end;
}
