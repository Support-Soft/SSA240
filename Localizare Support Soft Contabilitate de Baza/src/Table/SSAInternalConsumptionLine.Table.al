table 70001 "SSAInternal Consumption Line"
{
    // SSA937 SSCAT 16.06.2019 3.Funct. Bonuri de consum-consum intern

    Caption = 'Internal Consumption Line';

    fields
    {
        field(2; "Document No."; Code[20])
        {
            Caption = 'Document No.';
            DataClassification = ToBeClassified;
            TableRelation = "SSAInternal Consumption Header";
        }
        field(3; "Line No."; Integer)
        {
            Caption = 'Line No.';
            DataClassification = ToBeClassified;
        }
        field(4; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            DataClassification = ToBeClassified;
            TableRelation = Item;

            trigger OnValidate()
            begin
                TestStatusOpen;
                CheckItemAvailable(FieldNo("Item No."));

                TempIntConsumptionLine := Rec;
                Init;
                "Item No." := TempIntConsumptionLine."Item No.";
                if "Item No." = '' then
                    exit;

                GetConsumptionHeader;

                "Location Code" := IntConsumptionHeader."Location Code";
                "Gen. Bus. Posting Group" := IntConsumptionHeader."Gen. Bus. Posting Group";
                "Responsibility Center" := IntConsumptionHeader."Responsibility Center";
                "External Document No." := IntConsumptionHeader."External Document No.";

                "Outbound Whse. Handling Time" := IntConsumptionHeader."Outbound Whse. Handling Time";
                "Shipment Date" := IntConsumptionHeader."Posting Date";
                CalcFields("Substitution Available");

                GetItem;
                Item.TestField(Blocked, false);
                Item.TestField("Inventory Posting Group");
                Item.TestField("Gen. Prod. Posting Group");
                Description := Item.Description;
                "Description 2" := Item."Description 2";
                GetUnitCost;
                "Gen. Prod. Posting Group" := Item."Gen. Prod. Posting Group";
                "Item Category Code" := Item."Item Category Code";

                Validate("Unit of Measure Code", Item."Sales Unit of Measure");

                Validate(Quantity, xRec.Quantity);

                CreateDim(
                  DATABASE::Item, "Item No.",
                  DATABASE::"Responsibility Center", "Responsibility Center");
            end;
        }
        field(5; "Location Code"; Code[10])
        {
            Caption = 'Location Code';
            DataClassification = ToBeClassified;
            TableRelation = Location WHERE("Use As In-Transit" = CONST(false));

            trigger OnValidate()
            begin
                TestStatusOpen;
                if "Shipment Date" <> xRec."Shipment Date" then
                    InitItemAppl(true);

                CheckItemAvailable(FieldNo("Location Code"));
                "Bin Code" := '';

                GetUnitCost;
            end;
        }
        field(6; "Posting Group"; Code[10])
        {
            Caption = 'Posting Group';
            DataClassification = ToBeClassified;
            Editable = false;
            TableRelation = "Inventory Posting Group";
        }
        field(7; "Shipment Date"; Date)
        {
            Caption = 'Shipment Date';
            DataClassification = ToBeClassified;

            trigger OnValidate()
            var
                CheckDateConflict: Codeunit "Reservation-Check Date Confl.";
            begin
            end;
        }
        field(8; Description; Text[100])
        {
            Caption = 'Description';
            DataClassification = ToBeClassified;
        }
        field(9; "Description 2"; Text[100])
        {
            Caption = 'Description 2';
            DataClassification = ToBeClassified;
        }
        field(10; "Unit of Measure"; Text[10])
        {
            Caption = 'Unit of Measure';
            DataClassification = ToBeClassified;
        }
        field(11; Quantity; Decimal)
        {
            Caption = 'Quantity';
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 5;

            trigger OnValidate()
            begin
                TestStatusOpen;
                "Quantity (Base)" := CalcBaseQty(Quantity);
                CheckItemAvailable(FieldNo(Quantity));
                if (Quantity * xRec.Quantity < 0) or (Quantity = 0) then
                    InitItemAppl(false);
            end;
        }
        field(12; "Unit Cost (LCY)"; Decimal)
        {
            AutoFormatType = 2;
            Caption = 'Unit Cost (LCY)';
            DataClassification = ToBeClassified;
            Editable = true;

            trigger OnValidate()
            begin
                GetConsumptionHeader;
                "Unit Cost" := "Unit Cost (LCY)"
            end;
        }
        field(13; "Appl.-to Item Entry"; Integer)
        {
            Caption = 'Appl.-to Item Entry';
            DataClassification = ToBeClassified;

            trigger OnLookup()
            var
                ItemLedgEntry: Record "Item Ledger Entry";
            begin
                SelectItemEntry(FieldNo("Appl.-to Item Entry"));
            end;

            trigger OnValidate()
            var
                ItemLedgEntry: Record "Item Ledger Entry";
            begin
                TestField(Quantity);

                ItemLedgEntry.Get("Appl.-to Item Entry");
                ItemLedgEntry.TestField(Positive, true);
                ItemLedgEntry.TestField(Open, true);
                Validate("Unit Cost (LCY)", CalcUnitCost(ItemLedgEntry));

                "Location Code" := ItemLedgEntry."Location Code";
            end;
        }
        field(14; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Shortcut Dimension 1 Code';
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(1, "Shortcut Dimension 1 Code");
            end;
        }
        field(15; "Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(2, "Shortcut Dimension 2 Code");
            end;
        }
        field(16; "Gen. Bus. Posting Group"; Code[10])
        {
            Caption = 'Gen. Bus. Posting Group';
            DataClassification = ToBeClassified;
            TableRelation = "Gen. Business Posting Group";
        }
        field(17; "Gen. Prod. Posting Group"; Code[10])
        {
            Caption = 'Gen. Prod. Posting Group';
            DataClassification = ToBeClassified;
            TableRelation = "Gen. Product Posting Group";
        }
        field(18; "Attached to Line No."; Integer)
        {
            Caption = 'Attached to Line No.';
            DataClassification = ToBeClassified;
            Editable = false;
            TableRelation = "SSAInternal Consumption Line"."Line No." WHERE("Document No." = FIELD("Document No."));
        }
        field(19; "Unit Cost"; Decimal)
        {
            AutoFormatType = 2;
            Caption = 'Unit Cost';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(20; "Variant Code"; Code[10])
        {
            Caption = 'Variant Code';
            DataClassification = ToBeClassified;
            TableRelation = "Item Variant".Code;

            trigger OnValidate()
            begin
                TestStatusOpen;
                GetUnitCost;
                if "Variant Code" = '' then begin
                    Item.Get("Item No.");
                    Description := Item.Description;
                    "Description 2" := Item."Description 2";
                    exit;
                end;

                ItemVariant.Get("Item No.", "Variant Code");
                Description := ItemVariant.Description;
                "Description 2" := ItemVariant."Description 2";

                GetConsumptionHeader;

                CheckItemAvailable(FieldNo("Variant Code"));
            end;
        }
        field(21; "Bin Code"; Code[10])
        {
            Caption = 'Bin Code';
            DataClassification = ToBeClassified;
            TableRelation = Bin.Code WHERE("Location Code" = FIELD("Location Code"));

            trigger OnValidate()
            begin
                TestField("Location Code");
                CheckItemAvailable(FieldNo("Bin Code"));
            end;
        }
        field(22; "Qty. per Unit of Measure"; Decimal)
        {
            Caption = 'Qty. per Unit of Measure';
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 5;
            Editable = false;
            InitValue = 1;
        }
        field(23; Planned; Boolean)
        {
            Caption = 'Planned';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(24; "Unit of Measure Code"; Code[10])
        {
            Caption = 'Unit of Measure Code';
            DataClassification = ToBeClassified;
            TableRelation = "Item Unit of Measure".Code WHERE("Item No." = FIELD("Item No."));

            trigger OnValidate()
            var
                UnitOfMeasureTranslation: Record "Unit of Measure Translation";
            begin
                TestStatusOpen;

                if "Unit of Measure Code" = '' then
                    "Unit of Measure" := ''
                else begin
                    if not UnitOfMeasure.Get("Unit of Measure Code") then
                        UnitOfMeasure.Init;
                    "Unit of Measure" := UnitOfMeasure.Description;
                    GetConsumptionHeader;
                end;
                GetItem;
                GetUnitCost;
                CheckItemAvailable(FieldNo("Unit of Measure Code"));
                Validate(Quantity);
            end;
        }
        field(25; "Quantity (Base)"; Decimal)
        {
            Caption = 'Quantity (Base)';
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 5;

            trigger OnValidate()
            begin
                TestField("Qty. per Unit of Measure", 1);
                Validate(Quantity, "Quantity (Base)");
            end;
        }
        field(26; "Responsibility Center"; Code[10])
        {
            Caption = 'Responsibility Center';
            DataClassification = ToBeClassified;
            Editable = false;
            TableRelation = "Responsibility Center";

            trigger OnValidate()
            begin
                CreateDim(
                  DATABASE::"Responsibility Center", "Responsibility Center",
                  DATABASE::Item, "Item No.");
            end;
        }
        field(27; "Out-of-Stock Substitution"; Boolean)
        {
            Caption = 'Out-of-Stock Substitution';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(28; "Substitution Available"; Boolean)
        {
            CalcFormula = Exist ("Item Substitution" WHERE(Type = CONST(Item),
                                                           "No." = FIELD("Item No."),
                                                           "Substitute Type" = CONST(Item)));
            Caption = 'Substitution Available';
            Editable = false;
            FieldClass = FlowField;
        }
        field(29; "Item Category Code"; Code[30])
        {
            Caption = 'Item Category Code';
            DataClassification = ToBeClassified;
            TableRelation = "Item Category";
        }
        field(31; "Whse. Outstanding Qty."; Decimal)
        {
            CalcFormula = Sum ("Warehouse Activity Line"."Qty. Outstanding" WHERE("Activity Type" = FILTER(<> Pick),
                                                                                  "Source Type" = CONST(1),
                                                                                  "Source Subtype" = CONST("0"),
                                                                                  "Source No." = FIELD("Document No."),
                                                                                  "Source Line No." = FIELD("Line No.")));
            Caption = 'Whse. Outstanding Qty.';
            DecimalPlaces = 0 : 5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(32; "Outbound Whse. Handling Time"; DateFormula)
        {
            Caption = 'Outbound Whse. Handling Time';
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                TestStatusOpen;
            end;
        }
        field(33; "Planned Delivery Date"; Date)
        {
            Caption = 'Planned Delivery Date';
            DataClassification = ToBeClassified;
        }
        field(34; "Appl.-from Item Entry"; Integer)
        {
            Caption = 'Appl.-from Item Entry';
            DataClassification = ToBeClassified;
            MinValue = 0;

            trigger OnLookup()
            begin
                SelectItemEntry(FieldNo("Appl.-from Item Entry"));
            end;

            trigger OnValidate()
            var
                ItemLedgEntry: Record "Item Ledger Entry";
            begin
                if "Appl.-from Item Entry" <> 0 then begin
                    TestField(Quantity);
                    ItemLedgEntry.Get("Appl.-from Item Entry");
                    ItemLedgEntry.TestField(Positive, false);
                    Validate("Unit Cost (LCY)", CalcUnitCost(ItemLedgEntry));
                end;
            end;
        }
        field(35; "Appl.-to Service Entry"; Integer)
        {
            Caption = 'Appl.-to Service Entry';
            DataClassification = ToBeClassified;
        }
        field(36; "Price Adjustment Group Code"; Code[10])
        {
            Caption = 'Price Adjustment Group Code';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(37; "BOM Item No."; Code[20])
        {
            Caption = 'BOM Item No.';
            DataClassification = ToBeClassified;
            TableRelation = Item;
        }
        field(38; "External Document No."; Code[20])
        {
            Caption = 'External Document No.';
            DataClassification = ToBeClassified;
        }
        field(480; "Dimension Set ID"; Integer)
        {
            Caption = 'Dimension Set ID';
            DataClassification = ToBeClassified;
            Editable = false;
            TableRelation = "Dimension Set Entry";

            trigger OnLookup()
            begin
                ShowDimensions;
            end;

            trigger OnValidate()
            begin
                DimMgt.UpdateGlobalDimFromDimSetID("Dimension Set ID", "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code");
            end;
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
    }

    trigger OnDelete()
    begin
        if "Appl.-to Service Entry" <> 0 then
            Error(Text005, FieldCaption("Appl.-to Service Entry"));

        IntConsumptionLine2.Reset;
        IntConsumptionLine2.SetRange("Line No.", "Line No.");
        IntConsumptionLine2.SetRange("Attached to Line No.", "Line No.");
        IntConsumptionLine2.DeleteAll;
    end;

    trigger OnInsert()
    begin
        LockTable;
        IntConsumptionHeader."No." := '';
    end;

    trigger OnRename()
    begin

        Error(Text001, TableCaption);
    end;

    var
        IntConsumptionHeader: Record "SSAInternal Consumption Header";
        IntConsumptionLine2: Record "SSAInternal Consumption Line";
        TempIntConsumptionLine: Record "SSAInternal Consumption Line";
        SalesSetup: Record "Sales & Receivables Setup";
        Item: Record Item;
        VATPostingSetup: Record "VAT Posting Setup";
        StdTxt: Record "Standard Text";
        GenBusPostingGrp: Record "Gen. Business Posting Group";
        GenProdPostingGrp: Record "Gen. Product Posting Group";
        ItemVariant: Record "Item Variant";
        UnitOfMeasure: Record "Unit of Measure";
        InvtSetup: Record "Inventory Setup";
        Location: Record Location;
        ReturnReason: Record "Return Reason";
        ItemCategory: Record "Item Category";
        Currency: Record Currency;
        ItemAvailByDate: Page "Item Availability by Periods";
        ItemAvailByVar: Page "Item Availability by Variant";
        ItemAvailByLoc: Page "Item Availability by Location";
        ItemCheckAvail: Codeunit "SSA Item-Check Avail.";
        DimMgt: Codeunit DimensionManagement;
        ItemSubstitutionMgt: Codeunit "Item Subst.";
        DistIntegration: Codeunit "Dist. Integration";
        NonstockItemMgt: Codeunit "Catalog Item Management";
        WhseValidateSourceLine: Codeunit "Whse. Validate Source Line";
        TransferExtendedText: Codeunit "Transfer Extended Text";
        UOMMgt: Codeunit "Unit of Measure Management";
        ItemPriceInclVAT: Boolean;
        StatusCheckSuspended: Boolean;
        Text001: Label 'You cannot rename a %1.';
        Text002: Label 'must not be less than %1';
        Text003: Label ' must be 0 when %1 is %2.';
        Text004: Label 'Change %1 from %2 to %3?';
        Text005: Label 'You cannot delete the internal consumption line because %1 is not empty.';
        Text006: Label '%1 %2 is before Work Date %3';
        Text007: Label 'must not be less than zero';
        Text008: Label '%1 %2 cannot be found in the %3 or %4 table.';
        Text009: Label '%1 and %2 cannot both be empty when %3 is used.';
        Text010: Label 'No %1 has been posted for %2 %3 and %4 %5.';
        Text011: Label 'must be positive';
        Text012: Label 'must be negative';

    local procedure InitItemAppl(OnlyApplTo: Boolean)
    begin
        "Appl.-to Item Entry" := 0;
        if not OnlyApplTo then
            "Appl.-from Item Entry" := 0;
    end;

    local procedure CalcBaseQty(Qty: Decimal): Decimal
    begin
        TestField("Qty. per Unit of Measure");
        exit(Round(Qty * "Qty. per Unit of Measure", 0.00001));
    end;

    local procedure SelectItemEntry(CurrentFieldNo: Integer)
    var
        ItemLedgEntry: Record "Item Ledger Entry";
    begin
        ItemLedgEntry.Reset;
        ItemLedgEntry.SetCurrentKey("Item No.", Open, "Variant Code", Positive);
        ItemLedgEntry.SetRange("Item No.", "Item No.");
        if CurrentFieldNo = FieldNo("Appl.-to Item Entry") then begin
            ItemLedgEntry.SetRange(Positive, true);
            ItemLedgEntry.SetRange(Open, true);
        end else
            ItemLedgEntry.SetRange(Positive, false);
        ItemLedgEntry.SetRange(ItemLedgEntry."Location Code", "Location Code");
        ItemLedgEntry.FilterGroup(2);

        if PAGE.RunModal(PAGE::"Item Ledger Entries", ItemLedgEntry) = ACTION::LookupOK then begin
            if CurrentFieldNo = FieldNo("Appl.-to Item Entry") then
                Validate("Appl.-to Item Entry", ItemLedgEntry."Entry No.")
            else
                Validate("Appl.-from Item Entry", ItemLedgEntry."Entry No.");
            CheckItemAvailable(CurrentFieldNo);
        end;
    end;

    local
    procedure SetConsumptionHeader(NewIntConsumptionHeader: Record "SSAInternal Consumption Header")
    begin
        IntConsumptionHeader := NewIntConsumptionHeader;
        Currency.InitRoundingPrecision
    end;

    local procedure GetConsumptionHeader()
    begin
        TestField("Document No.");
        if "Document No." <> IntConsumptionHeader."No." then begin
            IntConsumptionHeader.Get("Document No.");
            Currency.InitRoundingPrecision;
        end;
    end;

    local procedure GetItem()
    begin
        TestField("Item No.");
        if "Item No." <> Item."No." then
            Item.Get("Item No.");
    end;

    local procedure CheckItemAvailable(CalledByFieldNo: Integer)
    begin
        if "Shipment Date" = 0D then begin
            GetConsumptionHeader;
            if IntConsumptionHeader."Posting Date" <> 0D then
                Validate("Shipment Date", IntConsumptionHeader."Posting Date")
            else
                Validate("Shipment Date", WorkDate);
        end;

        if ((CalledByFieldNo = CurrFieldNo) or (CalledByFieldNo = FieldNo("Shipment Date"))) and ("Item No." <> '') then
            ItemCheckAvail.IntConsLineCheck(Rec);
    end;

    local
    procedure GetDate(): Date
    begin
        exit(IntConsumptionHeader."Posting Date");
    end;

    local
    procedure SignedXX(Value: Decimal): Decimal
    begin
        exit(-Value);
    end;

    procedure ItemAvailability(AvailabilityType: Option Date,Variant,Location,Bin)
    begin
        TestField("Item No.");
        Item.Reset;
        Item.Get("Item No.");
        Item.SetRange("No.", "Item No.");
        Item.SetRange("Date Filter", 0D, "Shipment Date");


        case AvailabilityType of
            AvailabilityType::Date:
                begin
                    Item.SetRange("Variant Filter", "Variant Code");
                    Item.SetRange("Location Filter", "Location Code");
                    Item.SetRange("Bin Filter", "Bin Code");
                    Clear(ItemAvailByDate);
                    ItemAvailByDate.LookupMode(true);
                    ItemAvailByDate.SetRecord(Item);
                    ItemAvailByDate.SetTableView(Item);
                    if ItemAvailByDate.RunModal = ACTION::LookupOK then
                        if "Shipment Date" <> ItemAvailByDate.GetLastDate then
                            if Confirm(
                                 Text004, true, FieldCaption("Shipment Date"), "Shipment Date",
                                 ItemAvailByDate.GetLastDate)
                            then
                                Validate("Shipment Date", ItemAvailByDate.GetLastDate);
                end;
            AvailabilityType::Variant:
                begin
                    Item.SetRange("Location Filter", "Location Code");
                    Item.SetRange("Bin Filter", "Bin Code");
                    Clear(ItemAvailByVar);
                    ItemAvailByVar.LookupMode(true);
                    ItemAvailByVar.SetRecord(Item);
                    ItemAvailByVar.SetTableView(Item);
                    if ItemAvailByVar.RunModal = ACTION::LookupOK then
                        if "Variant Code" <> ItemAvailByVar.GetLastVariant then
                            if Confirm(
                                 Text004, true, FieldCaption("Variant Code"), "Variant Code",
                                 ItemAvailByVar.GetLastVariant)
                            then
                                Validate("Variant Code", ItemAvailByVar.GetLastVariant);
                end;
            AvailabilityType::Location:
                begin
                    Item.SetRange("Variant Filter", "Variant Code");
                    Item.SetRange("Bin Filter", "Bin Code");
                    Clear(ItemAvailByLoc);
                    ItemAvailByLoc.LookupMode(true);
                    ItemAvailByLoc.SetRecord(Item);
                    ItemAvailByLoc.SetTableView(Item);
                    if ItemAvailByLoc.RunModal = ACTION::LookupOK then
                        if "Location Code" <> ItemAvailByLoc.GetLastLocation then
                            if Confirm(
                                 Text004, true, FieldCaption("Location Code"), "Location Code",
                                 ItemAvailByLoc.GetLastLocation)
                            then
                                Validate("Location Code", ItemAvailByLoc.GetLastLocation);
                end;
        end;
    end;

    procedure OpenItemTrackingLines()
    var
        SalesShptLine: Record "Sales Shipment Line";
        ReturnRcptLine: Record "Return Receipt Line";
    begin
    end;

    local
    procedure AssignItemTrackingNo()
    begin
    end;

    local procedure GetFieldCaption(FieldNo: Integer): Text[30]
    var
        "Field": Record "Field";
    begin
        Field.Get(DATABASE::"SSAInternal Consumption Line", FieldNo);
        exit(Field."Field Caption");
    end;

    local procedure GetCaptionClass(FieldNo: Integer): Text[80]
    begin
        if not IntConsumptionHeader.Get("Document No.") then begin
            IntConsumptionHeader."Your Reference" := '';
            IntConsumptionHeader.Init;
        end;
        exit('2,0,' + GetFieldCaption(FieldNo));
    end;

    local procedure GetUnitCost()
    begin
        TestField("Item No.");
        GetItem;
        "Qty. per Unit of Measure" := UOMMgt.GetQtyPerUnitOfMeasure(Item, "Unit of Measure Code");
        "Posting Group" := Item."Inventory Posting Group";
        Validate("Unit Cost (LCY)", Item."Unit Cost" * "Qty. per Unit of Measure");
    end;

    local procedure CalcUnitCost(ItemLedgEntry: Record "Item Ledger Entry"): Decimal
    var
        ValueEntry: Record "Value Entry";
        InvdAdjustedCost: Decimal;
        ExpAdjustedCost: Decimal;
        UnitCost: Decimal;
    begin
        ValueEntry.Reset;
        ValueEntry.SetCurrentKey("Item Ledger Entry No.");
        ValueEntry.SetRange("Item Ledger Entry No.", ItemLedgEntry."Entry No.");
        if ItemLedgEntry."Completely Invoiced" then
            ValueEntry.SetRange("Expected Cost", false);
        if ValueEntry.Find('-') then
            repeat
                if ValueEntry."Expected Cost" then
                    ExpAdjustedCost := ExpAdjustedCost + ValueEntry."Cost Amount (Expected)"
                else
                    InvdAdjustedCost := InvdAdjustedCost + ValueEntry."Cost Amount (Actual)";
            until ValueEntry.Next = 0;
        UnitCost :=
          ((ExpAdjustedCost / ItemLedgEntry.Quantity *
           (ItemLedgEntry.Quantity - ItemLedgEntry."Invoiced Quantity")) +
          InvdAdjustedCost) / ItemLedgEntry.Quantity;
        exit(Abs(UnitCost * "Qty. per Unit of Measure"));
    end;

    local procedure TestStatusOpen()
    begin
        if StatusCheckSuspended then
            exit;
        GetConsumptionHeader;
    end;

    procedure SuspendStatusCheck(Suspend: Boolean)
    begin
        StatusCheckSuspended := Suspend;
    end;

    procedure ShowDimensions()
    begin
        "Dimension Set ID" :=
          DimMgt.EditDimensionSet("Dimension Set ID", StrSubstNo('%1 %2 %3', TableCaption, "Document No.", "Line No."));

        DimMgt.UpdateGlobalDimFromDimSetID("Dimension Set ID", "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code");
    end;

    procedure CreateDim(Type1: Integer; No1: Code[20]; Type2: Integer; No2: Code[20])
    var
        SourceCodeSetup: Record "Source Code Setup";
        TableID: array[10] of Integer;
        No: array[10] of Code[20];
    begin
        SourceCodeSetup.Get;
        TableID[1] := Type1;
        No[1] := No1;

        TableID[2] := Type2;
        No[2] := No2;

        "Shortcut Dimension 1 Code" := '';
        "Shortcut Dimension 2 Code" := '';
        "Dimension Set ID" :=
          DimMgt.GetRecDefaultDimID(
            Rec, CurrFieldNo, TableID, No, SourceCodeSetup.Transfer,
            "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code", IntConsumptionHeader."Dimension Set ID", DATABASE::Item);
    end;

    procedure ValidateShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20])
    begin
        DimMgt.ValidateShortcutDimValues(FieldNumber, ShortcutDimCode, "Dimension Set ID");
    end;

    procedure LookupShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20])
    begin
        DimMgt.LookupDimValueCode(FieldNumber, ShortcutDimCode);
        ValidateShortcutDimCode(FieldNumber, ShortcutDimCode);
    end;

    procedure ShowShortcutDimCode(var ShortcutDimCode: array[8] of Code[20])
    begin
        DimMgt.GetShortcutDimensions("Dimension Set ID", ShortcutDimCode);
    end;
}

