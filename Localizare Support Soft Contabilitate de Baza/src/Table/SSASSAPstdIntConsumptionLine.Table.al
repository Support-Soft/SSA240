table 70003 "SSAPstd. Int. Consumption Line"
{
    // SSA937 SSCAT 16.06.2019 3.Funct. Bonuri de consum-consum intern

    Caption = 'Pstd. Int. Consumption Line';
    DataClassification = CustomerContent;

    fields
    {
        field(2; "Document No."; Code[20])
        {
            Caption = 'Document No.';
        }
        field(3; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(4; "Item No."; Code[20])
        {
            Caption = 'No.';
            TableRelation = Item."No.";
        }
        field(5; "Location Code"; Code[10])
        {
            Caption = 'Location Code';
            TableRelation = Location where("Use As In-Transit" = const(false));
        }
        field(6; "Posting Group"; Code[10])
        {
            Caption = 'Posting Group';
            Editable = false;
            TableRelation = "Inventory Posting Group";
        }
        field(7; "Shipment Date"; Date)
        {
            Caption = 'Shipment Date';
        }
        field(8; Description; Text[100])
        {
            Caption = 'Description';
        }
        field(9; "Description 2"; Text[100])
        {
            Caption = 'Description 2';
        }
        field(10; "Unit of Measure"; Text[10])
        {
            Caption = 'Unit of Measure';
        }
        field(11; Quantity; Decimal)
        {
            Caption = 'Quantity';
            DecimalPlaces = 0 : 5;
        }
        field(12; "Unit Cost (LCY)"; Decimal)
        {
            AutoFormatType = 2;
            Caption = 'Unit Cost (LCY)';
        }
        field(13; "Appl.-to Item Entry"; Integer)
        {
            Caption = 'Appl.-to Item Entry';
        }
        field(14; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Shortcut Dimension 1 Code';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1));
        }
        field(15; "Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2));
        }
        field(16; "Gen. Bus. Posting Group"; Code[10])
        {
            Caption = 'Gen. Bus. Posting Group';
            TableRelation = "Gen. Business Posting Group";
        }
        field(17; "Gen. Prod. Posting Group"; Code[10])
        {
            Caption = 'Gen. Prod. Posting Group';
            TableRelation = "Gen. Product Posting Group";
        }
        field(18; "Attached to Line No."; Integer)
        {
            Caption = 'Attached to Line No.';
            Editable = false;
            TableRelation = "SSAPstd. Int. Consumption Line"."Line No." where("Document No." = field("Document No."));
        }
        field(19; "Unit Cost"; Decimal)
        {
            AutoFormatType = 2;
            Caption = 'Unit Cost';
            Editable = false;
        }
        field(20; "Variant Code"; Code[10])
        {
            Caption = 'Variant Code';
            TableRelation = "Item Variant".Code;
        }
        field(21; "Bin Code"; Code[10])
        {
            Caption = 'Bin Code';
            TableRelation = bin.Code where("Location Code" = field("Location Code"));
        }
        field(22; "Qty. per Unit of Measure"; Decimal)
        {
            Caption = 'Qty. per Unit of Measure';
            DecimalPlaces = 0 : 5;
            Editable = false;
            InitValue = 1;
        }
        field(23; Planned; Boolean)
        {
            Caption = 'Planned';
            Editable = false;
        }
        field(24; "Unit of Measure Code"; Code[10])
        {
            Caption = 'Unit of Measure Code';
            TableRelation = "Item Unit of Measure".Code where("Item No." = field("Item No."));
        }
        field(25; "Quantity (Base)"; Decimal)
        {
            Caption = 'Quantity (Base)';
            DecimalPlaces = 0 : 5;
        }
        field(26; "Responsibility Center"; Code[10])
        {
            Caption = 'Responsibility Center';
            Editable = false;
            TableRelation = "Responsibility Center";
        }
        field(27; "Out-of-Stock Substitution"; Boolean)
        {
            Caption = 'Out-of-Stock Substitution';
            Editable = false;
        }
        field(28; "Substitution Available"; Boolean)
        {
            CalcFormula = exist("Item Substitution" where(Type = const(Item),
                                                           "No." = field("Item No."),
                                                           "Substitute Type" = const(Item)));
            Caption = 'Substitution Available';
            Editable = false;
            FieldClass = FlowField;
        }
        field(29; "Item Category Code"; Code[30])
        {
            Caption = 'Item Category Code';
            TableRelation = "Item Category";
        }
        field(31; "Whse. Outstanding Qty."; Decimal)
        {
            CalcFormula = sum("Warehouse Activity Line"."Qty. Outstanding" where("Activity Type" = filter(<> Pick),
                                                                                  "Source Type" = const(1),
                                                                                  "Source Subtype" = const("0"),
                                                                                  "Source No." = field("Document No."),
                                                                                  "Source Line No." = field("Line No.")));
            Caption = 'Whse. Outstanding Qty.';
            DecimalPlaces = 0 : 5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(32; "Outbound Whse. Handling Time"; DateFormula)
        {
            Caption = 'Outbound Whse. Handling Time';
        }
        field(33; "Planned Delivery Date"; Date)
        {
            Caption = 'Planned Delivery Date';
        }
        field(34; "Appl.-from Item Entry"; Integer)
        {
            Caption = 'Appl.-from Item Entry';
            MinValue = 0;
        }
        field(35; "Appl.-to Service Entry"; Integer)
        {
            Caption = 'Appl.-to Service Entry';
        }
        field(36; "Price Adjustment Group Code"; Code[10])
        {
            Caption = 'Price Adjustment Group Code';
        }
        field(37; "BOM Item No."; Code[20])
        {
            Caption = 'BOM Item No.';
            TableRelation = Item;
        }
        field(38; "External Document No."; Code[20])
        {
            Caption = 'External Document No.';
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
        field(30000; "Item Shpt. Entry No."; Integer)
        {
            Caption = 'Item Shpt. Entry No.';
            Editable = false;
        }
    }

    keys
    {
        key(Key1; "Document No.", "Line No.")
        {
            Clustered = true;
        }
        key(Key2; "Item No.", "Variant Code", "Location Code", "Bin Code", "Shipment Date")
        {
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; Description)
        {
        }
    }

    var
        DimMgt: Codeunit DimensionManagement;

    procedure ShowDimensions()
    begin
        DimMgt.ShowDimensionSet("Dimension Set ID", StrSubstNo('%1 %2 %3', TableCaption, "Document No.", "Line No."));
    end;

    local procedure GetFieldCaption(FieldNumber: Integer): Text[100]
    var
        "Field": Record "Field";
    begin
        Field.Get(Database::"SSAPstd. Int. Consumption Line", FieldNumber);
        exit(Field."Field Caption");
    end;

    local procedure GetCaptionClass(FieldNumber: Integer): Text[80]
    var
        PostedIntConsumptionHeader: Record "SSA Pstd. Int. Cons. Header";
    begin
        if not PostedIntConsumptionHeader.Get("Line No.") then
            PostedIntConsumptionHeader.Init();
        exit('2,0,' + GetFieldCaption(FieldNumber));
    end;
}
