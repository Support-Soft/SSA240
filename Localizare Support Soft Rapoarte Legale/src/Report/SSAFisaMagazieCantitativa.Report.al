report 71307 "SSA Fisa Magazie Cantitativa"
{
    // SSA1011 SSCAT 14.10.2019 77.Rapoarte legale-Fisa de magazie
    DefaultLayout = RDLC;
    RDLCLayout = './src/rdlc/SSAFisaMagazieCantitativa.rdlc';
    Caption = 'Warehouse/Item Trial Balance';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;

    dataset
    {
        dataitem(IntegerLoop; "Integer")
        {
            DataItemTableView = sorting(Number);
            PrintOnlyIfDetail = true;
            column(Number_IntegerLoop; IntegerLoop.Number)
            {
            }
            column(Name_CompanyInformation; CompanyInformation.Name)
            {
            }
            column(ItemFilter; ItemFilter)
            {
            }
            column(TODAY; Today)
            {
            }
            /*
            column(PAGENO_CurrReport; CurrReport.PageNo)
            {
            }
            */
            column("USERID"; UserId)
            {
            }
            column(LocationName; LocationName)
            {
            }
            column(LocationCode; LocationCode)
            {
            }
            column(HasMovement; HasMovement)
            {
            }
            column(ItemFooter; ItemFooter)
            {
            }
            column(CompanyInfo_VATRegistrationNumber; CompanyInformation.GetVATRegistrationNumber())
            {
            }
            dataitem(Item; Item)
            {
                DataItemTableView = sorting("Inventory Posting Group");
                PrintOnlyIfDetail = false;
                RequestFilterFields = "No.", "Date Filter", "Location Filter";
                column(InventoryPostingGroup_Item; Item."Inventory Posting Group")
                {
                }
                column(No_Item; Item."No.")
                {
                }
                column(Description_Item; Item.Description)
                {
                }
                column(BaseUnitofMeasure_Item; Item."Base Unit of Measure")
                {
                }
                column(InitialStockQuantityPerItem; InitialStockQuantityPerItem)
                {
                }
                dataitem("Item Ledger Entry"; "Item Ledger Entry")
                {
                    DataItemLink = "Item No." = field("No."), "Posting Date" = field("Date Filter"), "Location Code" = field("Location Filter");
                    DataItemTableView = sorting("Item No.", "Posting Date", "Entry Type", "Variant Code", "Drop Shipment", "Location Code");
                    column(PostingDate_ItemLedgerEntry; "Item Ledger Entry"."Posting Date")
                    {
                    }
                    column(DocumentNo_ItemLedgerEntry; "Item Ledger Entry"."Document No.")
                    {
                    }
                    column(DocumentType; DocumentType)
                    {
                    }
                    column(Description1; Description1)
                    {
                    }
                    column(InputQuantityPerItem; InputQuantityPerItem)
                    {
                    }
                    column(OutputQuantityPerItem; OutputQuantityPerItem)
                    {
                    }
                    column(StockQuantityPerItem; StockQuantityPerItem)
                    {
                    }
                    column(ItemNo_ItemLedgerEntry; "Item Ledger Entry"."Item No.")
                    {
                    }

                    trigger OnAfterGetRecord()
                    begin
                        InputQuantityPerItem := 0;
                        OutputQuantityPerItem := 0;
                        InputAmountPerItem := 0;
                        OutputAmountPerItem := 0;
                        Cost := 0;
                        HasMovement := true;
                        DocumentType := Format("Entry Type");

                        case "Entry Type" of
                            "Entry Type"::Purchase, "Entry Type"::"Positive Adjmt.", "Entry Type"::Output:
                                begin
                                    InputQuantityPerItem := Quantity;
                                    CalcFields("Cost Amount (Actual)", "Cost Amount (Actual) (ACY)");
                                    if ShowACY then
                                        InputAmountPerItem := "Cost Amount (Actual) (ACY)"
                                    else
                                        InputAmountPerItem := "Cost Amount (Actual)";

                                    if InputQuantityPerItem <> 0
                                          then
                                        Cost := InputAmountPerItem / InputQuantityPerItem;

                                    TotalInputQuantityPerItem := TotalInputQuantityPerItem + InputQuantityPerItem;
                                end;
                            "Entry Type"::Sale, "Entry Type"::"Negative Adjmt.", "Entry Type"::Consumption:
                                begin
                                    OutputQuantityPerItem := -Quantity;
                                    CalcFields("Cost Amount (Actual)", "Cost Amount (Actual) (ACY)");
                                    if ShowACY then
                                        OutputAmountPerItem := -"Cost Amount (Actual) (ACY)"
                                    else
                                        OutputAmountPerItem := -"Cost Amount (Actual)";

                                    if OutputQuantityPerItem <> 0
                                         then
                                        Cost := OutputAmountPerItem / OutputQuantityPerItem;

                                    TotalOutputQuantityPerItem := TotalOutputQuantityPerItem + OutputQuantityPerItem;
                                end;
                            "Entry Type"::Transfer:
                                begin
                                    if Quantity > 0 then begin
                                        InputQuantityPerItem := Quantity;
                                        CalcFields("Cost Amount (Actual)", "Cost Amount (Actual) (ACY)");
                                        if ShowACY then
                                            InputAmountPerItem := "Cost Amount (Actual) (ACY)"
                                        else
                                            InputAmountPerItem := "Cost Amount (Actual)";

                                        if InputQuantityPerItem <> 0
                                            then
                                            Cost := InputAmountPerItem / InputQuantityPerItem;

                                        TotalInputQuantityPerItem := TotalInputQuantityPerItem + InputQuantityPerItem;
                                    end else begin
                                        OutputQuantityPerItem := -Quantity;
                                        CalcFields("Cost Amount (Actual)", "Cost Amount (Actual) (ACY)");
                                        if ShowACY then
                                            OutputAmountPerItem := -"Cost Amount (Actual) (ACY)"
                                        else
                                            OutputAmountPerItem := -"Cost Amount (Actual)";

                                        if OutputQuantityPerItem <> 0
                                            then
                                            Cost := OutputAmountPerItem / OutputQuantityPerItem;

                                        TotalOutputQuantityPerItem := TotalOutputQuantityPerItem + OutputQuantityPerItem;
                                    end;
                                end;
                        end;

                        StockQuantityPerItem := StockQuantityPerItem + InputQuantityPerItem - OutputQuantityPerItem;
                        Clear(Description1);
                        if "Source Type" = "Source Type"::Item then
                            if Item1.Get("Source No.") then Description1 := Item1.Description + Item1."Description 2";
                        if "Source Type" = "Source Type"::Customer then
                            if Customer.Get("Source No.") then Description1 := Customer.Name + ' ' + Customer."Name 2";
                        if "Source Type" = "Source Type"::Vendor then
                            if Vendor.Get("Source No.") then Description1 := Vendor.Name + Vendor."Name 2";
                    end;
                }
                dataitem("Integer"; "Integer")
                {
                    DataItemTableView = sorting(Number) where(Number = const(1));
                    PrintOnlyIfDetail = false;
                    column(TotalInputQuantityPerItem; TotalInputQuantityPerItem)
                    {
                    }
                    column(TotalOutputQuantityPerItem; TotalOutputQuantityPerItem)
                    {
                    }
                    column(StockQuantityPerItem_Integer; StockQuantityPerItem)
                    {
                    }
                    column(Cost_Integer; Cost)
                    {
                    }
                }

                trigger OnAfterGetRecord()
                begin
                    TotalInputQuantityPerItem := 0;
                    TotalOutputQuantityPerItem := 0;
                    if LocationCode = 'NOLOCATION' then
                        SetFilter("Location Filter", '=%1', '')
                    else
                        SetFilter("Location Filter", LocationCode);

                    SetFilter("Date Filter", '%1..%2', 0D, GetRangeMin("Date Filter") - 1);
                    CalcFields("Net Change");
                    InitialStockQuantityPerItem := "Net Change";

                    SetFilter("Date Filter", SaveDateFilter);

                    ValueEntry.Reset;
                    ValueEntry.SetCurrentKey("Item No.", "Item Ledger Entry No.", "Posting Date", "Entry Type", "Item Ledger Entry Type",
                                             "Item Charge No.", "Location Code", "Variant Code", "Expected Cost");
                    ValueEntry.SetRange("Item No.", "No.");
                    ValueEntry.SetRange("Posting Date", DateMin, DateMax);

                    if LocationCode = 'NOLOCATION' then
                        ValueEntry.SetFilter("Location Code", '=%1', '')
                    else
                        ValueEntry.SetRange("Location Code", LocationCode);

                    if (not ValueEntry.FindFirst) and (InitialStockQuantityPerItem = 0) then
                        CurrReport.Skip;

                    StockQuantityPerItem := InitialStockQuantityPerItem;

                    HasMovement := false;
                end;

                trigger OnPreDataItem()
                begin
                    ItemFooter := true;
                end;
            }

            trigger OnAfterGetRecord()
            begin

                CounterLoop := CounterLoop + 1;

                if CounterLoop = ArrayLength + 1 then
                    CurrReport.Break;

                LocationCode := LocationArray[CounterLoop];

                if LocationCode = 'NOLOCATION' then begin
                    LocationName := '';
                    LocationAddress := '';
                end else
                    if LocationArray[CounterLoop] <> '' then begin
                        LocationRec.Get(LocationArray[CounterLoop]);
                        LocationName := LocationRec.Name;
                        LocationAddress := LocationRec.Address;
                    end;

                ItemLedgerEntry.Reset;

                if LocationCode = 'NOLOCATION' then
                    ItemLedgerEntry.SetFilter("Location Code", '=%1', '')
                else
                    ItemLedgerEntry.SetRange("Location Code", LocationCode);

                if not ItemLedgerEntry.FindFirst then CurrReport.Skip;

                if LocationCode = '' then
                    LocationCode := 'NOLOCATION';
            end;

            trigger OnPreDataItem()
            begin
                SetRange(Number, 1, ArrayLength);
                CounterLoop := 0;
            end;
        }
    }

    requestpage
    {
        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
        lbl_Company = 'Company:';
        lbl_ReportTitle = 'WAREHOUSE / ITEM TRIAL BALANCE';
        lbl_ReportDate = 'Report Date:';
        lbl_Page = 'Page:';
        lbl_User = 'User:';
        lbl_UnitOfMeasure = 'Unit of Measure';
        lbl_Date = 'Date';
        lbl_DocNo = 'Doc. No.';
        lbl_DocType = 'Doc. Type';
        lbl_SourceDescription = 'Source Description';
        lbl_Input_Qty = 'Input (Qty.)';
        lbl_Output_Qty = 'Output (Qty.)';
        lbl_InitialStock = 'Initial Stock';
        lbl_Inventory_Qty = 'Inventory (Qty.)';
        lbl_Cost = 'Unit Cost Calc.';
        lbl_TotalItemNo = 'Total Item No.';
        lbl_PreparedBy = 'Prepared by,';
        lbl_CheckedBy = 'Checked by,';
        lbl_Text008 = 'Location Code: ';
        lbl_Text009 = 'Location Name: ';
        lbl_Text011 = 'Inventory Posting Group ';
        lbl_Text012 = 'Item No. ';
        lbl_Text013 = 'Description: ';
        lbl_GeneralTotalItemNo = 'General Total Item No.';
    }

    trigger OnInitReport()
    begin
        ArrayLength := 0;
    end;

    trigger OnPreReport()
    begin
        if Item.GetFilter("No.") = '' then
            Error(Text015);

        CompanyInformation.Get;
        if LocationRec.ReadPermission then begin
            if Item.GetFilter("Location Filter") <> '' then begin
                LocationRec.SetFilter(Code, Item.GetFilter("Location Filter"));
                if LocationRec.FindFirst then begin
                    repeat
                        ArrayLength := ArrayLength + 1;
                        LocationArray[ArrayLength] := LocationRec.Code;
                    until LocationRec.Next = 0;
                end;
            end else begin
                "Item Ledger Entry".SetFilter("Item No.", '=%1', Item.GetFilter("No."));
                if "Item Ledger Entry".FindFirst then begin
                    repeat
                        if (ArrayLength > 0)
                          then begin
                            FoundNewLocation := true;
                            for index1 := 1 to ArrayLength do begin
                                if (LocationArray[index1] = "Item Ledger Entry"."Location Code") then
                                    FoundNewLocation := false;
                            end;

                            if FoundNewLocation then begin
                                ArrayLength := ArrayLength + 1;
                                LocationArray[ArrayLength] := "Item Ledger Entry"."Location Code";
                            end;
                        end
                        else begin
                            ArrayLength := ArrayLength + 1;
                            LocationArray[ArrayLength] := "Item Ledger Entry"."Location Code";
                        end;
                    until "Item Ledger Entry".Next = 0;
                end else
                    if LocationRec.FindFirst then begin
                        ArrayLength := 1;
                        LocationArray[1] := '';
                        repeat
                            ArrayLength := ArrayLength + 1;
                            LocationArray[ArrayLength] := LocationRec.Code;
                        until LocationRec.Next = 0;
                    end;
            end;
        end else begin
            ArrayLength := 1;
            LocationArray[1] := '';
        end;

        SaveDateFilter := Item.GetFilter("Date Filter");
        DateMin := Item.GetRangeMin("Date Filter");
        DateMax := Item.GetRangeMax("Date Filter");
        ItemFilter := Item.GetFilters;

        if ShowACY then
            CaptionCost := Text003
        else
            CaptionCost := Text007;

        ItemLedgerEntryf := "Item Ledger Entry".GetFilters;
        ItemLedgerEntryFilter := CopyStr(ItemLedgerEntryf, 15, 200);
        test := CopyStr(ItemLedgerEntryf, 1, 12);
    end;

    var
        ItemLedgerEntry: Record "Item Ledger Entry";
        CompanyInformation: Record "Company Information";
        ValueEntry: Record "Value Entry";
        Item1: Record Item;
        Vendor: Record Vendor;
        Customer: Record Customer;
        LocationRec: Record Location;
        SaveDateFilter: Text[250];
        ItemFilter: Text[250];
        ItemLedgerEntryFilter: Text[250];
        DocumentType: Text[30];
        CaptionCost: Text[50];
        LocationName: Text[50];
        LocationAddress: Text[250];
        Description1: Text[90];
        LocationArray: array[1000000] of Code[150];
        LocationCode: Code[150];
        TotalInputQuantityPerItem: Decimal;
        TotalOutputQuantityPerItem: Decimal;
        InitialStockQuantityPerItem: Decimal;
        InputQuantityPerItem: Decimal;
        OutputQuantityPerItem: Decimal;
        InputAmountPerItem: Decimal;
        OutputAmountPerItem: Decimal;
        StockQuantityPerItem: Decimal;
        Cost: Decimal;
        ArrayLength: Integer;
        CounterLoop: Integer;
        HasMovement: Boolean;
        ShowACY: Boolean;
        ItemFooter: Boolean;
        DateMin: Date;
        DateMax: Date;
        ItemLedgerEntryf: Text[1024];
        test: Text[50];
        Text003: Label 'Unit Cost Calc. (ACY)';
        Text007: Label 'Unit Cost Calc.';
        index1: Integer;
        FoundNewLocation: Boolean;
        Text015: Label 'You must specify an item.';
}
