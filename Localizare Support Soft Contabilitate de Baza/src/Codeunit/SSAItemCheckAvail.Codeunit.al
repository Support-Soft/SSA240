codeunit 70020 "SSA Item-Check Avail."
{
    // SSA937 SSCAT 16.06.2019 3.Funct. Bonuri de consum-consum intern

    Permissions = tabledata "My Notifications" = rimd;

    var
        Text000: Label 'The update has been interrupted to respect the warning.';
        AvailableToPromise: Codeunit "Available to Promise";
        NotificationLifecycleMgt: Codeunit "Notification Lifecycle Mgt.";
        ItemNo: Code[20];
        UnitOfMeasureCode: Code[10];
        ItemLocationCode: Code[10];
        NewItemNetChange: Decimal;
        OldItemNetChange: Decimal;
        OldItemNetResChange: Decimal;
        NewItemNetResChange: Decimal;
        ItemNetChange: Decimal;
        QtyPerUnitOfMeasure: Decimal;
        InitialQtyAvailable: Decimal;
        UseOrderPromise: Boolean;
        GrossReq: Decimal;
        ReservedReq: Decimal;
        SchedRcpt: Decimal;
        ReservedRcpt: Decimal;
        EarliestAvailDate: Date;
        InventoryQty: Decimal;
        OldItemShipmentDate: Date;
        NotificationMsg: Label 'The available inventory for item %1 is lower than the entered quantity at this location.', Comment = '%1=Item No.';
        DetailsTxt: Label 'Show details';
        ItemAvailabilityNotificationTxt: Label 'Item availability is low.';
        ItemAvailabilityNotificationDescriptionTxt: Label 'Show a warning when someone creates a sales order or sales invoice for an item that is out of stock.';

    procedure ItemJnlCheckLine(ItemJnlLine: Record "Item Journal Line") Rollback: Boolean
    begin
        NotificationLifecycleMgt.RecallNotificationsForRecordWithAdditionalContext(
          ItemJnlLine.RecordId, GetItemAvailabilityNotificationId(), true);
        if ItemJnlLineShowWarning(ItemJnlLine) then
            Rollback := ShowAndHandleAvailabilityPage(ItemJnlLine.RecordId);
    end;

    procedure SalesLineCheck(SalesLine: Record "Sales Line") Rollback: Boolean
    var
        TempAsmHeader: Record "Assembly Header" temporary;
        TempAsmLine: Record "Assembly Line" temporary;
        ATOLink: Record "Assemble-to-Order Link";
    begin
        NotificationLifecycleMgt.RecallNotificationsForRecordWithAdditionalContext(
          SalesLine.RecordId, GetItemAvailabilityNotificationId(), true);
        if SalesLineShowWarning(SalesLine) then
            Rollback := ShowAndHandleAvailabilityPage(SalesLine.RecordId);

        if not Rollback then
            if ATOLink.SalesLineCheckAvailShowWarning(SalesLine, TempAsmHeader, TempAsmLine) then
                Rollback := ShowAsmWarningYesNo(TempAsmHeader, TempAsmLine);
    end;

    procedure TransferLineCheck(TransLine: Record "Transfer Line") Rollback: Boolean
    begin
        NotificationLifecycleMgt.RecallNotificationsForRecordWithAdditionalContext(
          TransLine.RecordId, GetItemAvailabilityNotificationId(), true);
        if TransferLineShowWarning(TransLine) then
            Rollback := ShowAndHandleAvailabilityPage(TransLine.RecordId);
    end;

    procedure ServiceInvLineCheck(ServInvLine: Record "Service Line") Rollback: Boolean
    begin
        NotificationLifecycleMgt.RecallNotificationsForRecordWithAdditionalContext(
          ServInvLine.RecordId, GetItemAvailabilityNotificationId(), true);
        if ServiceInvLineShowWarning(ServInvLine) then
            Rollback := ShowAndHandleAvailabilityPage(ServInvLine.RecordId);
    end;

    procedure JobPlanningLineCheck(JobPlanningLine: Record "Job Planning Line") Rollback: Boolean
    begin
        NotificationLifecycleMgt.RecallNotificationsForRecordWithAdditionalContext(
          JobPlanningLine.RecordId, GetItemAvailabilityNotificationId(), true);
        if JobPlanningLineShowWarning(JobPlanningLine) then
            Rollback := ShowAndHandleAvailabilityPage(JobPlanningLine.RecordId);
    end;

    procedure AssemblyLineCheck(AssemblyLine: Record "Assembly Line") Rollback: Boolean
    begin
        NotificationLifecycleMgt.RecallNotificationsForRecordWithAdditionalContext(
          AssemblyLine.RecordId, GetItemAvailabilityNotificationId(), true);
        if AsmOrderLineShowWarning(AssemblyLine) then
            Rollback := ShowAndHandleAvailabilityPage(AssemblyLine.RecordId);
    end;

    procedure ShowAsmWarningYesNo(var AsmHeader: Record "Assembly Header"; var AsmLine: Record "Assembly Line") Rollback: Boolean
    var
        AsmLineMgt: Codeunit "Assembly Line Management";
    begin
        Rollback := AsmLineMgt.ShowAvailability(false, AsmHeader, AsmLine);
    end;

    procedure ItemJnlLineShowWarning(ItemJnlLine: Record "Item Journal Line"): Boolean
    begin
        if not ShowWarningForThisItem(ItemJnlLine."Item No.") then
            exit(false);

        case ItemJnlLine."Entry Type" of
            ItemJnlLine."Entry Type"::Purchase, ItemJnlLine."Entry Type"::"Positive Adjmt.":
                ItemNetChange := ItemJnlLine.Quantity;
            ItemJnlLine."Entry Type"::Sale, ItemJnlLine."Entry Type"::"Negative Adjmt.", ItemJnlLine."Entry Type"::Transfer:
                ItemNetChange := -ItemJnlLine.Quantity;
        end;
        exit(
          ShowWarning(
            ItemJnlLine."Item No.",
            ItemJnlLine."Variant Code",
            ItemJnlLine."Location Code",
            ItemJnlLine."Unit of Measure Code",
            ItemJnlLine."Qty. per Unit of Measure",
            ItemNetChange,
            0,
            0D,
            0D));
    end;

    procedure SalesLineShowWarning(SalesLine: Record "Sales Line"): Boolean
    var
        OldSalesLine: Record "Sales Line";
        CompanyInfo: Record "Company Information";
        LookAheadDate: Date;
    begin
        if SalesLine."Drop Shipment" then
            exit(false);
        if SalesLine.IsNonInventoriableItem() then
            exit(false);
        if SalesLine.FullQtyIsForAsmToOrder() then
            exit(false);
        if not ShowWarningForThisItem(SalesLine."No.") then
            exit(false);

        Clear(AvailableToPromise);

        OldItemNetChange := 0;
        OldSalesLine := SalesLine;
        if OldSalesLine.Find() then begin // Find previous quantity within Check-Avail. Period
            CompanyInfo.Get();
            LookAheadDate :=
              AvailableToPromise.GetForwardPeriodEndDate(
                CompanyInfo."Check-Avail. Period Calc.", CompanyInfo."Check-Avail. Time Bucket", SalesLine."Shipment Date");
            if (OldSalesLine."Document Type" = OldSalesLine."Document Type"::Order) and
               (OldSalesLine."No." = SalesLine."No.") and
               (OldSalesLine."Variant Code" = SalesLine."Variant Code") and
               (OldSalesLine."Location Code" = SalesLine."Location Code") and
               (OldSalesLine."Bin Code" = SalesLine."Bin Code") and
               not OldSalesLine."Drop Shipment" and
               (OldSalesLine."Shipment Date" <= LookAheadDate)
            then
                if OldSalesLine."Shipment Date" > SalesLine."Shipment Date" then
                    AvailableToPromise.SetChangedSalesLine(OldSalesLine)
                else begin
                    OldItemNetChange := -OldSalesLine."Outstanding Qty. (Base)";
                    OldSalesLine.CalcFields("Reserved Qty. (Base)");
                    OldItemNetResChange := -OldSalesLine."Reserved Qty. (Base)";
                end;
        end;

        NewItemNetResChange := -(SalesLine."Qty. to Asm. to Order (Base)" - OldSalesLine.QtyBaseOnATO());

        if SalesLine."Document Type" = SalesLine."Document Type"::Order then
            UseOrderPromise := true;
        exit(
          ShowWarning(
            SalesLine."No.",
            SalesLine."Variant Code",
            SalesLine."Location Code",
            SalesLine."Unit of Measure Code",
            SalesLine."Qty. per Unit of Measure",
            -SalesLine."Outstanding Quantity",
            OldItemNetChange,
            SalesLine."Shipment Date",
            OldSalesLine."Shipment Date"));
    end;

    local procedure ShowWarning(ItemNoArg: Code[20]; ItemVariantCodeArg: Code[10]; ItemLocationCodeArg: Code[10]; UnitOfMeasureCodeArg: Code[10]; QtyPerUnitOfMeasureArg: Decimal; NewItemNetChangeArg: Decimal; OldItemNetChangeArg: Decimal; ShipmentDateArg: Date; OldShipmentDateArg: Date): Boolean
    var
        Item: Record Item;
    begin
        ItemNo := ItemNoArg;
        UnitOfMeasureCode := UnitOfMeasureCodeArg;
        QtyPerUnitOfMeasure := QtyPerUnitOfMeasureArg;
        NewItemNetChange := NewItemNetChangeArg;
        OldItemNetChange := ConvertQty(OldItemNetChangeArg);
        OldItemShipmentDate := OldShipmentDateArg;
        ItemLocationCode := ItemLocationCodeArg;

        if NewItemNetChange >= 0 then
            exit(false);

        SetFilterOnItem(Item, ItemNo, ItemVariantCodeArg, ItemLocationCode, ShipmentDateArg);
        Calculate(Item);
        exit(InitialQtyAvailable + ItemNetChange - OldItemNetResChange < 0);
    end;

    local procedure SetFilterOnItem(var Item: Record Item; ItemNo: Code[20]; ItemVariantCode: Code[10]; ItemLocationCode: Code[10]; ShipmentDate: Date)
    begin
        Item.Get(ItemNo);
        Item.SetRange("No.", ItemNo);
        Item.SetRange("Variant Filter", ItemVariantCode);
        Item.SetRange("Location Filter", ItemLocationCode);
        Item.SetRange("Drop Shipment Filter", false);

        if UseOrderPromise then
            Item.SetRange("Date Filter", 0D, ShipmentDate)
        else
            Item.SetRange("Date Filter", 0D, WorkDate());
    end;

    local procedure Calculate(var Item: Record Item)
    var
        CompanyInfo: Record "Company Information";
    begin
        CompanyInfo.Get();
        QtyAvailToPromise(Item, CompanyInfo);
        EarliestAvailDate := EarliestAvailabilityDate(Item, CompanyInfo);

        if not UseOrderPromise then
            SchedRcpt := 0;

        OldItemNetResChange := ConvertQty(OldItemNetResChange);
        NewItemNetResChange := ConvertQty(NewItemNetResChange);

        ItemNetChange := 0;
        if Item."No." = ItemNo then begin
            ItemNetChange := NewItemNetChange;
            if GrossReq + OldItemNetChange >= 0 then
                GrossReq := GrossReq + OldItemNetChange;
        end;

        InitialQtyAvailable :=
          InventoryQty +
          (SchedRcpt - ReservedRcpt) - (GrossReq - ReservedReq) -
          NewItemNetResChange;

        OnAfterCalculate(Item, InitialQtyAvailable);
    end;

    local procedure QtyAvailToPromise(var Item: Record Item; CompanyInfo: Record "Company Information")
    begin
        AvailableToPromise.CalcQtyAvailabletoPromise(
          Item, GrossReq, SchedRcpt, Item.GetRangeMax("Date Filter"),
          CompanyInfo."Check-Avail. Time Bucket", CompanyInfo."Check-Avail. Period Calc.");
        InventoryQty := ConvertQty(AvailableToPromise.CalcAvailableInventory(Item));
        GrossReq := ConvertQty(GrossReq);
        ReservedReq := ConvertQty(AvailableToPromise.CalcReservedRequirement(Item) + OldItemNetResChange);
        SchedRcpt := ConvertQty(SchedRcpt);
        ReservedRcpt := ConvertQty(AvailableToPromise.CalcReservedReceipt(Item));
    end;

    local procedure EarliestAvailabilityDate(var Item: Record Item; CompanyInfo: Record "Company Information"): Date
    var
        AvailableQty: Decimal;
        NewItemNetChangeBase: Decimal;
        OldItemNetChangeBase: Decimal;
    begin
        NewItemNetChangeBase := ConvertQtyToBaseQty(NewItemNetChange);
        OldItemNetChangeBase := ConvertQtyToBaseQty(OldItemNetChange);
        exit(
          AvailableToPromise.CalcEarliestAvailabilityDate(
            Item, -NewItemNetChangeBase, Item.GetRangeMax("Date Filter"), -OldItemNetChangeBase, OldItemShipmentDate, AvailableQty,
            CompanyInfo."Check-Avail. Time Bucket", CompanyInfo."Check-Avail. Period Calc."));
    end;

    local procedure ConvertQty(Qty: Decimal): Decimal
    begin
        if QtyPerUnitOfMeasure = 0 then
            QtyPerUnitOfMeasure := 1;
        exit(Round(Qty / QtyPerUnitOfMeasure, 0.00001));
    end;

    local procedure ConvertQtyToBaseQty(Qty: Decimal): Decimal
    begin
        if QtyPerUnitOfMeasure = 0 then
            QtyPerUnitOfMeasure := 1;
        exit(Round(Qty * QtyPerUnitOfMeasure, 0.00001));
    end;

    procedure TransferLineShowWarning(TransLine: Record "Transfer Line"): Boolean
    var
        OldTransLine: Record "Transfer Line";
    begin
        if not ShowWarningForThisItem(TransLine."Item No.") then
            exit(false);

        UseOrderPromise := true;

        OldTransLine := TransLine;
        if OldTransLine.Find() then // Find previous quantity
            if (OldTransLine."Item No." = TransLine."Item No.") and
               (OldTransLine."Variant Code" = TransLine."Variant Code") and
               (OldTransLine."Transfer-from Code" = TransLine."Transfer-from Code")
            then begin
                OldItemNetChange := -OldTransLine."Outstanding Qty. (Base)";
                OldTransLine.CalcFields("Reserved Qty. Outbnd. (Base)");
                OldItemNetResChange := -OldTransLine."Reserved Qty. Outbnd. (Base)";
            end;

        exit(
          ShowWarning(
            TransLine."Item No.",
            TransLine."Variant Code",
            TransLine."Transfer-from Code",
            TransLine."Unit of Measure Code",
            TransLine."Qty. per Unit of Measure",
            -TransLine."Outstanding Quantity",
            OldItemNetChange,
            TransLine."Shipment Date",
            OldTransLine."Shipment Date"));
    end;

    procedure ServiceInvLineShowWarning(ServLine: Record "Service Line"): Boolean
    var
        OldServLine: Record "Service Line";
    begin
        if not ShowWarningForThisItem(ServLine."No.") then
            exit(false);

        OldItemNetChange := 0;

        OldServLine := ServLine;

        if OldServLine.Find() then // Find previous quantity
            if (OldServLine."Document Type" = OldServLine."Document Type"::Order) and
               (OldServLine."No." = ServLine."No.") and
               (OldServLine."Variant Code" = ServLine."Variant Code") and
               (OldServLine."Location Code" = ServLine."Location Code") and
               (OldServLine."Bin Code" = ServLine."Bin Code")
            then begin
                OldItemNetChange := -OldServLine."Outstanding Qty. (Base)";
                OldServLine.CalcFields("Reserved Qty. (Base)");
                OldItemNetResChange := -OldServLine."Reserved Qty. (Base)";
            end;

        UseOrderPromise := true;
        exit(
          ShowWarning(
            ServLine."No.",
            ServLine."Variant Code",
            ServLine."Location Code",
            ServLine."Unit of Measure Code",
            ServLine."Qty. per Unit of Measure",
            -ServLine."Outstanding Quantity",
            OldItemNetChange,
            ServLine."Needed by Date",
            OldServLine."Needed by Date"));
    end;

    procedure JobPlanningLineShowWarning(JobPlanningLine: Record "Job Planning Line"): Boolean
    var
        OldJobPlanningLine: Record "Job Planning Line";
    begin
        if not ShowWarningForThisItem(JobPlanningLine."No.") then
            exit(false);

        OldItemNetChange := 0;

        OldJobPlanningLine := JobPlanningLine;

        if OldJobPlanningLine.Find() then // Find previous quantity
            if (OldJobPlanningLine.Type = OldJobPlanningLine.Type::Item) and
               (OldJobPlanningLine."No." = JobPlanningLine."No.") and
               (OldJobPlanningLine."Variant Code" = JobPlanningLine."Variant Code") and
               (OldJobPlanningLine."Location Code" = JobPlanningLine."Location Code") and
               (OldJobPlanningLine."Bin Code" = JobPlanningLine."Bin Code")
            then begin
                OldItemNetChange := -OldJobPlanningLine."Quantity (Base)";
                OldJobPlanningLine.CalcFields("Reserved Qty. (Base)");
                OldItemNetResChange := -OldJobPlanningLine."Reserved Qty. (Base)";
            end;

        UseOrderPromise := true;
        exit(
          ShowWarning(
            JobPlanningLine."No.",
            JobPlanningLine."Variant Code",
            JobPlanningLine."Location Code",
            JobPlanningLine."Unit of Measure Code",
            JobPlanningLine."Qty. per Unit of Measure",
            -JobPlanningLine."Remaining Qty.",
            OldItemNetChange,
            JobPlanningLine."Planning Date",
            OldJobPlanningLine."Planning Date"));
    end;

    procedure AsmOrderLineShowWarning(AssemblyLine: Record "Assembly Line"): Boolean
    var
        OldAssemblyLine: Record "Assembly Line";
    begin
        if not ShowWarningForThisItem(AssemblyLine."No.") then
            exit(false);

        Clear(AvailableToPromise);

        OldItemNetChange := 0;

        OldAssemblyLine := AssemblyLine;

        if OldAssemblyLine.Find() then // Find previous quantity
            if (OldAssemblyLine."Document Type" = OldAssemblyLine."Document Type"::Order) and
               (OldAssemblyLine.Type = OldAssemblyLine.Type::Item) and
               (OldAssemblyLine."No." = AssemblyLine."No.") and
               (OldAssemblyLine."Variant Code" = AssemblyLine."Variant Code") and
               (OldAssemblyLine."Location Code" = AssemblyLine."Location Code") and
               (OldAssemblyLine."Bin Code" = AssemblyLine."Bin Code")
            then
                if OldAssemblyLine."Due Date" > AssemblyLine."Due Date" then
                    AvailableToPromise.SetChangedAsmLine(OldAssemblyLine)
                else begin
                    OldItemNetChange := -OldAssemblyLine."Remaining Quantity (Base)";
                    OldAssemblyLine.CalcFields("Reserved Qty. (Base)");
                    OldItemNetResChange := -OldAssemblyLine."Reserved Qty. (Base)";
                end;

        UseOrderPromise := true;
        exit(
          ShowWarning(
            AssemblyLine."No.",
            AssemblyLine."Variant Code",
            AssemblyLine."Location Code",
            AssemblyLine."Unit of Measure Code",
            AssemblyLine."Qty. per Unit of Measure",
            -AssemblyLine."Remaining Quantity",
            OldItemNetChange,
            AssemblyLine."Due Date",
            OldAssemblyLine."Due Date"));
    end;

    procedure AsmOrderCalculate(AssemblyHeader: Record "Assembly Header"; var InventoryQty2: Decimal; var GrossReq2: Decimal; var ReservedReq2: Decimal; var SchedRcpt2: Decimal; var ReservedRcpt2: Decimal)
    var
        OldAssemblyHeader: Record "Assembly Header";
        Item: Record Item;
        CompanyInfo: Record "Company Information";
    begin
        UseOrderPromise := true;

        if AssemblyHeader."Due Date" = 0D then
            AssemblyHeader."Due Date" := WorkDate();
        SetFilterOnItem(Item, AssemblyHeader."Item No.", AssemblyHeader."Variant Code", AssemblyHeader."Location Code", AssemblyHeader."Due Date");
        CompanyInfo.Get();
        QtyAvailToPromise(Item, CompanyInfo);

        OldAssemblyHeader := AssemblyHeader;
        if OldAssemblyHeader.Find() then // Find previous quantity
            if (OldAssemblyHeader."Document Type" = OldAssemblyHeader."Document Type"::Order) and
               (OldAssemblyHeader."No." = AssemblyHeader."No.") and
               (OldAssemblyHeader."Item No." = AssemblyHeader."Item No.") and
               (OldAssemblyHeader."Variant Code" = AssemblyHeader."Variant Code") and
               (OldAssemblyHeader."Location Code" = AssemblyHeader."Location Code") and
               (OldAssemblyHeader."Bin Code" = AssemblyHeader."Bin Code")
            then begin
                OldAssemblyHeader.CalcFields("Reserved Qty. (Base)");
                SchedRcpt :=
                  SchedRcpt - ConvertQty(OldAssemblyHeader."Remaining Quantity (Base)" - OldAssemblyHeader."Reserved Qty. (Base)");
            end;
        FetchCalculation2(InventoryQty2, GrossReq2, ReservedReq2, SchedRcpt2, ReservedRcpt2);
    end;

    procedure FetchCalculation(var ItemNo2: Code[20]; var UnitOfMeasureCode2: Code[10]; var InventoryQty2: Decimal; var GrossReq2: Decimal; var ReservedReq2: Decimal; var SchedRcpt2: Decimal; var ReservedRcpt2: Decimal; var CurrentQuantity2: Decimal; var CurrentReservedQty2: Decimal; var TotalQuantity2: Decimal; var EarliestAvailDate2: Date)
    begin
        ItemNo2 := ItemNo;
        UnitOfMeasureCode2 := UnitOfMeasureCode;
        FetchCalculation2(InventoryQty2, GrossReq2, ReservedReq2, SchedRcpt2, ReservedRcpt2);
        CurrentQuantity2 := -NewItemNetChange;
        CurrentReservedQty2 := -(NewItemNetResChange + OldItemNetResChange);
        TotalQuantity2 := InitialQtyAvailable + ItemNetChange;
        EarliestAvailDate2 := EarliestAvailDate;
    end;

    local procedure FetchCalculation2(var InventoryQty2: Decimal; var GrossReq2: Decimal; var ReservedReq2: Decimal; var SchedRcpt2: Decimal; var ReservedRcpt2: Decimal)
    begin
        InventoryQty2 := InventoryQty;
        GrossReq2 := GrossReq;
        ReservedReq2 := ReservedReq;
        SchedRcpt2 := SchedRcpt;
        ReservedRcpt2 := ReservedRcpt;
    end;

    procedure RaiseUpdateInterruptedError()
    begin
        Error(Text000);
    end;

    local procedure ShowAndHandleAvailabilityPage(RecordId: RecordId) Rollback: Boolean
    var
        ItemNo2: Code[20];
        UnitOfMeasureCode2: Code[10];
        InventoryQty2: Decimal;
        GrossReq2: Decimal;
        ReservedReq2: Decimal;
        SchedRcpt2: Decimal;
        ReservedRcpt2: Decimal;
        CurrentQuantity2: Decimal;
        CurrentReservedQty2: Decimal;
        TotalQuantity2: Decimal;
        EarliestAvailDate2: Date;
    begin
        if not GuiAllowed then
            exit(false);

        FetchCalculation(
          ItemNo2, UnitOfMeasureCode2, InventoryQty2,
          GrossReq2, ReservedReq2, SchedRcpt2, ReservedRcpt2,
          CurrentQuantity2, CurrentReservedQty2, TotalQuantity2, EarliestAvailDate2);
        Rollback := CreateAndSendNotification(UnitOfMeasureCode2, InventoryQty2,
            GrossReq2, ReservedReq2, SchedRcpt2, ReservedRcpt2,
            CurrentQuantity2, CurrentReservedQty2, TotalQuantity2, EarliestAvailDate2, RecordId, ItemLocationCode);
    end;

    local procedure CreateAndSendNotification(UnitOfMeasureCode: Code[20]; InventoryQty: Decimal; GrossReq: Decimal; ReservedReq: Decimal; SchedRcpt: Decimal; ReservedRcpt: Decimal; CurrentQuantity: Decimal; CurrentReservedQty: Decimal; TotalQuantity: Decimal; EarliestAvailDate: Date; RecordId: RecordId; LocationCode: Code[10]): Boolean
    var
        ItemAvailabilityCheck: Page "Item Availability Check";
        AvailabilityCheckNotification: Notification;
    begin
        AvailabilityCheckNotification.Id(CreateGuid());
        AvailabilityCheckNotification.Message(StrSubstNo(NotificationMsg, ItemNo));
        AvailabilityCheckNotification.Scope(NotificationScope::LocalScope);
        AvailabilityCheckNotification.AddAction(DetailsTxt, Codeunit::"SSA Item-Check Avail.", 'ShowNotificationDetails');
        ItemAvailabilityCheck.PopulateDataOnNotification(AvailabilityCheckNotification, ItemNo, UnitOfMeasureCode,
          InventoryQty, GrossReq, ReservedReq, SchedRcpt, ReservedRcpt, CurrentQuantity, CurrentReservedQty,
          TotalQuantity, EarliestAvailDate, LocationCode);
        NotificationLifecycleMgt.SendNotificationWithAdditionalContext(
          AvailabilityCheckNotification, RecordId, GetItemAvailabilityNotificationId());
        exit(false);
    end;

    procedure ShowWarningForThisItem(ItemNo: Code[20]): Boolean
    var
        Item: Record Item;
        SalesSetup: Record "Sales & Receivables Setup";
    begin
        if not Item.Get(ItemNo) then
            exit(false);

        if Item.IsNonInventoriableType() then
            exit(false);

        if not IsItemAvailabilityNotificationEnabled(Item) then
            exit(false);

        case Item."Stockout Warning" of
            Item."Stockout Warning"::No:
                exit(false);
            Item."Stockout Warning"::Yes:
                exit(true);
            Item."Stockout Warning"::Default:
                begin
                    SalesSetup.Get();
                    if SalesSetup."Stockout Warning" then
                        exit(true);
                    exit(false);
                end;
        end;
    end;

    procedure GetItemAvailabilityNotificationId(): Guid
    begin
        exit('2712AD06-C48B-4C20-820E-347A60C9AD00');
    end;

    local procedure IsItemAvailabilityNotificationEnabled(Item: Record Item): Boolean
    var
        MyNotifications: Record "My Notifications";
    begin
        exit(MyNotifications.IsEnabledForRecord(GetItemAvailabilityNotificationId(), Item));
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterCalculate(var Item: Record Item; var InitialQtyAvailable: Decimal)
    begin
    end;

    [EventSubscriber(ObjectType::Page, 1518, 'OnInitializingNotificationWithDefaultState', '', false, false)]
    local procedure OnInitializingNotificationWithDefaultState()
    var
        MyNotifications: Record "My Notifications";
    begin
        MyNotifications.InsertDefaultWithTableNum(GetItemAvailabilityNotificationId(),
          ItemAvailabilityNotificationTxt,
          ItemAvailabilityNotificationDescriptionTxt,
          Database::Item);
    end;

    procedure IntConsLineCheck(_IntConsLine: Record "SSAInternal Consumption Line") Rollback: Boolean
    begin
        //SSA937>>
        NotificationLifecycleMgt.RecallNotificationsForRecordWithAdditionalContext(
          _IntConsLine.RecordId, GetItemAvailabilityNotificationId(), true);
        if IntConsLineShowWarning(_IntConsLine) then
            Rollback := ShowAndHandleAvailabilityPage(_IntConsLine.RecordId);
        //SSA937<<
    end;

    procedure IntConsLineShowWarning(_IntConsLine: Record "SSAInternal Consumption Line"): Boolean
    var
        OldIntConsLine: Record "SSAInternal Consumption Line";
    begin
        //SSA937>>
        if not ShowWarningForThisItem(_IntConsLine."Item No.") then
            exit(false);

        UseOrderPromise := true;

        OldIntConsLine := _IntConsLine;
        if OldIntConsLine.Find() then // Find previous quantity
            if (OldIntConsLine."Item No." = _IntConsLine."Item No.") and
               (OldIntConsLine."Variant Code" = _IntConsLine."Variant Code") and
               (OldIntConsLine."Location Code" = _IntConsLine."Location Code")
            then begin
                OldItemNetChange := -OldIntConsLine.Quantity;
                OldItemNetResChange := 0;
            end;

        exit(
          ShowWarning(
            _IntConsLine."Item No.",
            _IntConsLine."Variant Code",
            _IntConsLine."Location Code",
            _IntConsLine."Unit of Measure Code",
            _IntConsLine."Qty. per Unit of Measure",
            -_IntConsLine.Quantity,
            OldItemNetChange,
            _IntConsLine."Shipment Date",
            OldIntConsLine."Shipment Date"));
        //SSA937<<
    end;
}
