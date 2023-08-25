table 70000 "SSAInternal Consumption Header"
{
    // SSA937 SSCAT 16.06.2019 3.Funct. Bonuri de consum-consum intern
    // SSA1097 SSCAT 07.10.2019 Anulare bon consum

    Caption = 'Internal Consumption Header';
    DrillDownPageID = "SSAInternal Consumption List";
    LookupPageID = "SSAInternal Consumption List";

    fields
    {
        field(2; "No."; Code[20])
        {
            Caption = 'No.';
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                if "No." <> xRec."No." then begin
                    SalesSetup.Get;
                    NoSeriesMgt.TestManual(GetNoSeriesCode);
                    "No. Series" := '';
                end;
            end;
        }
        field(3; "Your Reference"; Text[30])
        {
            Caption = 'Your Reference';
            DataClassification = ToBeClassified;
        }
        field(4; "Order Date"; Date)
        {
            Caption = 'Order Date';
            DataClassification = ToBeClassified;
        }
        field(5; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                Validate("Document Date", "Posting Date");
                if ConsumptionLinesExist then begin
                    IntConsumptionLine.Reset;
                    IntConsumptionLine.SetRange("Document No.", "No.");
                    IntConsumptionLine.Find('-');
                    repeat
                        IntConsumptionLine.Validate("Shipment Date", "Posting Date");
                        IntConsumptionLine.Modify;
                    until IntConsumptionLine.Next = 0;
                end;
            end;
        }
        field(6; "Posting Description"; Text[50])
        {
            Caption = 'Posting Description';
            DataClassification = ToBeClassified;
        }
        field(7; "Location Code"; Code[10])
        {
            Caption = 'Location Code';
            DataClassification = ToBeClassified;
            TableRelation = Location where("Use As In-Transit" = const(false));

            trigger OnValidate()
            begin
                if "Location Code" <> xRec."Location Code" then
                    MessageIfConsumptionLinesExist(FieldCaption("Location Code"));

                if "Location Code" <> '' then begin
                    if Location.Get("Location Code") then
                        "Outbound Whse. Handling Time" := Location."Outbound Whse. Handling Time";
                end else begin
                    if SSASetup.Get then
                        "Outbound Whse. Handling Time" := SSASetup."Outbound Whse. Handling Time";
                end;
            end;
        }
        field(8; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Shortcut Dimension 1 Code';
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(1, "Shortcut Dimension 1 Code");
                Modify;
            end;
        }
        field(9; "Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(2, "Shortcut Dimension 2 Code");
                Modify;
            end;
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
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(12; "Posting No."; Code[20])
        {
            Caption = 'Posting No.';
            DataClassification = ToBeClassified;
        }
        field(13; "Last Posting No."; Code[20])
        {
            Caption = 'Last Posting No.';
            DataClassification = ToBeClassified;
            Editable = false;
            TableRelation = "SSA Pstd. Int. Cons. Header";
        }
        field(14; "Reason Code"; Code[10])
        {
            Caption = 'Reason Code';
            DataClassification = ToBeClassified;
            TableRelation = "Reason Code";
        }
        field(15; "Gen. Bus. Posting Group"; Code[10])
        {
            Caption = 'Gen. Bus. Posting Group';
            DataClassification = ToBeClassified;
            TableRelation = "Gen. Business Posting Group";

            trigger OnValidate()
            begin
                if xRec."Gen. Bus. Posting Group" <> "Gen. Bus. Posting Group" then
                    if GenBusPostingGrp.ValidateVatBusPostingGroup(GenBusPostingGrp, "Gen. Bus. Posting Group") then begin
                        "VAT Bus. Posting Group" := GenBusPostingGrp."Def. VAT Bus. Posting Group";
                        RecreateConsumptionLines(FieldCaption("Gen. Bus. Posting Group"));
                    end;
            end;
        }
        field(16; Correction; Boolean)
        {
            Caption = 'Correction';
            DataClassification = ToBeClassified;
        }
        field(17; "Document Date"; Date)
        {
            Caption = 'Document Date';
            DataClassification = ToBeClassified;
        }
        field(18; "External Document No."; Code[20])
        {
            Caption = 'External Document No.';
            DataClassification = ToBeClassified;
        }
        field(19; "No. Series"; Code[10])
        {
            Caption = 'No. Series';
            DataClassification = ToBeClassified;
            Editable = false;
            TableRelation = "No. Series";
        }
        field(20; "Posting No. Series"; Code[10])
        {
            Caption = 'Posting No. Series';
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";

            trigger OnLookup()
            begin
                with IntConsumptionHeader do begin
                    IntConsumptionHeader := Rec;
                    SalesSetup.Get;
                    TestNoSeries;
                    if NoSeriesMgt.LookupSeries(GetPostingNoSeriesCode, "Posting No. Series") then
                        Validate("Posting No. Series");
                    Rec := IntConsumptionHeader;
                end;
            end;

            trigger OnValidate()
            begin
                if "Posting No. Series" <> '' then begin
                    SalesSetup.Get;
                    TestNoSeries;
                    NoSeriesMgt.TestSeries(GetPostingNoSeriesCode, "Posting No. Series");
                end;
                TestField("Posting No.", '');
            end;
        }
        field(21; "VAT Bus. Posting Group"; Code[10])
        {
            Caption = 'VAT Bus. Posting Group';
            DataClassification = ToBeClassified;
            TableRelation = "VAT Business Posting Group";

            trigger OnValidate()
            begin
                if xRec."VAT Bus. Posting Group" <> "VAT Bus. Posting Group" then
                    RecreateConsumptionLines(FieldCaption("VAT Bus. Posting Group"));
            end;
        }
        field(22; "Responsibility Center"; Code[10])
        {
            Caption = 'Responsibility Center';
            DataClassification = ToBeClassified;
            TableRelation = "Responsibility Center";

            trigger OnValidate()
            begin
                if not UserMgt.CheckRespCenter(3, "Responsibility Center") then
                    Error(
                      Text013,
                       RespCenter.TableCaption, SSAUserMgt.GetIntConsumptionFilter());
                "Location Code" := UserMgt.GetLocation(3, '', "Responsibility Center");

                if "Location Code" <> '' then begin
                    if Location.Get("Location Code") then
                        "Outbound Whse. Handling Time" := Location."Outbound Whse. Handling Time";
                end else begin
                    if SSASetup.Get then
                        "Outbound Whse. Handling Time" := SSASetup."Outbound Whse. Handling Time";
                end;

                CreateDim(
                  DATABASE::"Responsibility Center", "Responsibility Center");


                if (xRec."Responsibility Center" <> "Responsibility Center") then
                    RecreateConsumptionLines(FieldCaption("Responsibility Center"));
            end;
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
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                if "Shipping Time" <> xRec."Shipping Time" then
                    UpdateConsumptionLines(FieldCaption("Shipping Time"), CurrFieldNo <> 0);
            end;
        }
        field(25; "Outbound Whse. Handling Time"; DateFormula)
        {
            Caption = 'Outbound Whse. Handling Time';
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                if "Outbound Whse. Handling Time" <> xRec."Outbound Whse. Handling Time" then
                    UpdateConsumptionLines(FieldCaption("Outbound Whse. Handling Time"), CurrFieldNo <> 0);
            end;
        }
        field(26; "Date Filter"; Date)
        {
            Caption = 'Date Filter';
            FieldClass = FlowFilter;
        }
        field(30; "Correction Cost"; Boolean)
        {
            Caption = 'Correction Cost';
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
                ShowDocDim;
            end;

            trigger OnValidate()
            begin
                DimMgt.UpdateGlobalDimFromDimSetID("Dimension Set ID", "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code");
            end;
        }
        field(70000; Cancelled; Boolean)
        {
            Caption = 'Cancelled';
            DataClassification = ToBeClassified;
            Description = 'SSA1097';
        }
        field(70001; "Cancelled from No."; Code[20])
        {
            Caption = 'Cancelled from No.';
            DataClassification = ToBeClassified;
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

    fieldgroups
    {
        fieldgroup(DropDown; "No.", "Posting Date", "Location Code")
        {
        }
    }

    trigger OnDelete()
    begin
        if not UserMgt.CheckRespCenter(0, "Responsibility Center") then
            Error(
              Text011,
              RespCenter.TableCaption, SSAUserMgt.GetIntConsumptionFilter());

        IntConsumptionPost.DeleteHeader(Rec, PostedIntConsumptionHeader);

        IntConsumptionLine.LockTable;
        IntConsumptionLine.SetRange("Document No.", "No.");
        DeleteConsumtionLines;

        ConsCommentLine.SetRange("Document Type", ConsCommentLine."Document Type"::"Internal Consumption");
        ConsCommentLine.SetRange("No.", "No.");
        ConsCommentLine.DeleteAll;
    end;

    trigger OnInsert()
    begin
        SSASetup.Get;
        if "No." = '' then begin
            TestNoSeries;
            NoSeriesMgt.InitSeries(GetNoSeriesCode, xRec."No. Series", "Posting Date", "No.", "No. Series");
        end;
        InitRecord;
    end;

    trigger OnRename()
    begin

        Error(Text002, TableCaption);
    end;

    var
        SalesSetup: Record "Sales & Receivables Setup";
        GLSetup: Record "General Ledger Setup";
        IntConsumptionHeader: Record "SSAInternal Consumption Header";
        IntConsumptionLine: Record "SSAInternal Consumption Line";
        ConsCommentLine: Record "SSA Comment Line";
        PostedIntConsumptionHeader: Record "SSA Pstd. Int. Cons. Header";
        GenBusPostingGrp: Record "Gen. Business Posting Group";
        RespCenter: Record "Responsibility Center";
        SSASetup: Record "SSA Localization Setup";
        Location: Record Location;
        WhseRequest: Record "Warehouse Request";
        UserMgt: Codeunit "User Setup Management";
        SSAUserMgt: Codeunit "SSA User Setup Management";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        TransferExtendedText: Codeunit "Transfer Extended Text";
        DimMgt: Codeunit DimensionManagement;
        WhseSourceHeader: Codeunit "Whse. Validate Source Header";
        IntConsumptionPost: Codeunit "SSA Internal Consumption Post";
        HideValidationDialog: Boolean;
        Confirmed: Boolean;
        Text001: Label 'Do you want to print internal consumption doc %1?';
        Text002: Label 'You cannot rename an %1.';
        Text003: Label 'Do you want to change %1?';
        Text004: Label 'Do you want to continue?';
        Text005: Label 'Deleting this document will cause a gap in the number series for posted internal consumption docs. ';
        Text006: Label 'An empty posted internal consumption doc %1 will be created to fill this gap in the number series.\\';
        Text007: Label 'If you change %1, the existing internal consumption lines will have change by user manually.';
        Text008: Label 'You must delete the existing internal consumption lines before you can change %1.';
        Text009: Label 'You have changed %1 on the internal consumption header, but it has not been changed on the existing internal consumption lines.\';
        Text010: Label 'You must update the existing internal consumption lines manually.';
        Text011: Label 'You cannot delete this document. Your identification is set up to process from %1 %2 only.';
        Text012: Label 'Do you want to update the %2 field on the lines to reflect the new value of %1?';
        Text013: Label 'Your identification is set up to process from %1 %2 only.';
        Text014: Label 'You cannot change the %1 when the %2 has been filled in';
        Text015: Label 'You have modified %1.\\';
        Text016: Label 'Do you want to update the lines?';
        Text16100: Label 'Internal Consumption';
        Text064: Label 'You may have changed a dimension.\\Do you want to update the lines?';
        Text45013654: Label 'Cancel Internal Consumption %1';

    local
    procedure InitRecord()
    begin
        if ("No. Series" <> '') and
           (SSASetup."Internal Consumption Nos." = SSASetup."Posted Int. Consumption Nos.")
        then
            "Posting No. Series" := "No. Series"
        else
            NoSeriesMgt.SetDefaultSeries("Posting No. Series", SSASetup."Posted Int. Consumption Nos.");

        "Order Date" := WorkDate;

        if "Posting Date" = 0D then
            "Posting Date" := WorkDate;
        "Document Date" := WorkDate;

        Validate("Location Code", UserMgt.GetLocation(0, "Location Code", "Responsibility Center"));

        "Posting Description" := Text16100 + ' ' + "Your Reference";

        SSASetup.Get;
        Validate("Outbound Whse. Handling Time", SSASetup."Outbound Whse. Handling Time");
    end;


    procedure AssistEdit(OldIntConsumptionHeader: Record "SSAInternal Consumption Header"): Boolean
    begin
        with IntConsumptionHeader do begin
            IntConsumptionHeader := Rec;
            SalesSetup.Get;
            TestNoSeries;
            if NoSeriesMgt.SelectSeries(GetNoSeriesCode, OldIntConsumptionHeader."No. Series", "No. Series") then begin
                SalesSetup.Get;
                TestNoSeries;
                NoSeriesMgt.SetSeries("No.");
                Rec := IntConsumptionHeader;
                exit(true);
            end;
        end;
    end;

    local procedure TestNoSeries(): Boolean
    begin
        SSASetup.TestField("Internal Consumption Nos.");
        SSASetup.TestField("Posted Int. Consumption Nos.");
    end;

    local procedure GetNoSeriesCode(): Code[10]
    begin
        exit(SSASetup."Internal Consumption Nos.");
    end;

    local procedure GetPostingNoSeriesCode(): Code[10]
    begin
        exit(SSASetup."Posted Int. Consumption Nos.");
    end;


    procedure ConfirmDeletion(): Boolean
    begin
        IntConsumptionPost.TestDeleteHeader(Rec, PostedIntConsumptionHeader);
        if PostedIntConsumptionHeader."No." <> '' then
            if not Confirm(
                 Text005 +
                 Text006 +
                 Text004, true,
                 PostedIntConsumptionHeader."No.")
            then
                exit;
        exit(true);
    end;

    local
    procedure ConsumptionLinesExist(): Boolean
    begin
        IntConsumptionLine.Reset;
        IntConsumptionLine.SetRange("Document No.", "No.");
        exit(IntConsumptionLine.Find('-'));
    end;

    local
    procedure RecreateConsumptionLines(ChangedFieldName: Text[30])
    var
        IntConsumptionLineTmp: Record "SSAInternal Consumption Line" temporary;
        ItemChargeAssgntSales: Record "Item Charge Assignment (Sales)";
        TempItemChargeAssgntSales: Record "Item Charge Assignment (Sales)" temporary;
        TempInteger: Record "Integer" temporary;
        ExtendedTextAdded: Boolean;
    begin
        if ConsumptionLinesExist then begin
            if HideValidationDialog then
                Confirmed := true
            else
                Confirmed :=
                  Confirm(
                    Text007 +
                    Text003, false, ChangedFieldName);
            if Confirmed then begin
                IntConsumptionLine.LockTable;
                Modify;

                IntConsumptionLine.Reset;
                IntConsumptionLine.SetRange("Document No.", "No.");
                if IntConsumptionLine.Find('-') then begin
                    repeat
                        IntConsumptionLineTmp := IntConsumptionLine;
                        IntConsumptionLineTmp.Insert;
                    until IntConsumptionLine.Next = 0;
                end;
            end;
        end;
    end;

    local
    procedure MessageIfConsumptionLinesExist(ChangedFieldName: Text[30])
    begin
        if ConsumptionLinesExist and not HideValidationDialog then
            Message(
              Text009 +
              Text010,
              ChangedFieldName);
    end;


    procedure SetHideValidationDialog(NewHideValidationDialog: Boolean)
    begin
        HideValidationDialog := NewHideValidationDialog;
    end;

    local
    procedure UpdateConsumptionLines(ChangedFieldName: Text[30]; AskQuestion: Boolean)
    var
        Question: Text[250];
        UpdateLines: Boolean;
    begin
        if ConsumptionLinesExist and AskQuestion then begin
            Question := StrSubstNo(
              Text015 +
              Text016, ChangedFieldName);
            if not DIALOG.Confirm(Question, true) then
                exit
            else
                UpdateLines := true;
        end;
    end;

    procedure CreateDim(Type1: Integer; No1: Code[20])
    var
        SourceCodeSetup: Record "Source Code Setup";
        TableID: array[10] of Integer;
        No: array[10] of Code[20];
        OldDimSetID: Integer;
    begin
        SourceCodeSetup.Get;
        TableID[1] := Type1;
        No[1] := No1;

        "Shortcut Dimension 1 Code" := '';
        "Shortcut Dimension 2 Code" := '';
        OldDimSetID := "Dimension Set ID";
        "Dimension Set ID" :=
          DimMgt.GetRecDefaultDimID(
            Rec, CurrFieldNo, TableID, No, SourceCodeSetup.Sales, "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code", 0, 0);

        if (OldDimSetID <> "Dimension Set ID") and ConsumptionLinesExist then begin
            Modify;
            UpdateAllLineDim("Dimension Set ID", OldDimSetID);
        end;
    end;

    procedure ValidateShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20])
    var
        OldDimSetID: Integer;
    begin
        OldDimSetID := "Dimension Set ID";
        DimMgt.ValidateShortcutDimValues(FieldNumber, ShortcutDimCode, "Dimension Set ID");
        if "No." <> '' then
            Modify;

        if OldDimSetID <> "Dimension Set ID" then begin
            Modify;
            if ConsumptionLinesExist then
                UpdateAllLineDim("Dimension Set ID", OldDimSetID);
        end;
    end;

    procedure ShowDocDim()
    var
        OldDimSetID: Integer;
    begin
        OldDimSetID := "Dimension Set ID";
        "Dimension Set ID" :=
          DimMgt.EditDimensionSet(
            "Dimension Set ID", StrSubstNo('%1', "No."),
            "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code");
        if OldDimSetID <> "Dimension Set ID" then begin
            Modify;
            if ConsumptionLinesExist then
                UpdateAllLineDim("Dimension Set ID", OldDimSetID);
        end;
    end;

    procedure UpdateAllLineDim(NewParentDimSetID: Integer; OldParentDimSetID: Integer)
    var
        ATOLink: Record "Assemble-to-Order Link";
        NewDimSetID: Integer;
        ShippedReceivedItemLineDimChangeConfirmed: Boolean;
    begin
        // Update all lines with changed dimensions.

        if NewParentDimSetID = OldParentDimSetID then
            exit;
        if not HideValidationDialog and GuiAllowed then
            if not Confirm(Text064) then
                exit;

        IntConsumptionLine.Reset;
        IntConsumptionLine.SetRange("Document No.", "No.");
        IntConsumptionLine.LockTable;
        if IntConsumptionLine.Find('-') then
            repeat
                NewDimSetID := DimMgt.GetDeltaDimSetID(IntConsumptionLine."Dimension Set ID", NewParentDimSetID, OldParentDimSetID);
                if IntConsumptionLine."Dimension Set ID" <> NewDimSetID then begin
                    IntConsumptionLine."Dimension Set ID" := NewDimSetID;

                    DimMgt.UpdateGlobalDimFromDimSetID(
                      IntConsumptionLine."Dimension Set ID", IntConsumptionLine."Shortcut Dimension 1 Code", IntConsumptionLine."Shortcut Dimension 2 Code");
                    IntConsumptionLine.Modify;
                end;
            until IntConsumptionLine.Next = 0;
    end;

    local procedure DeleteConsumtionLines()
    begin
        if IntConsumptionLine.Find('-') then
            repeat
                IntConsumptionLine.SuspendStatusCheck(true);
                IntConsumptionLine.Delete(true);
            until IntConsumptionLine.Next = 0;
    end;

    procedure StornoFrom()
    var
        PostedIntConsHeader: Record "SSA Pstd. Int. Cons. Header";
        PostedIntConsLine: Record "SSAPstd. Int. Consumption Line";
        NewLine: Record "SSAInternal Consumption Line";
        DimMgt: Codeunit DimensionManagement;
    begin
        //SSA1097>>
        PostedIntConsHeader.FilterGroup := 2;
        PostedIntConsHeader.SetRange(Cancelled, false);
        PostedIntConsHeader.FilterGroup := 0;
        if PAGE.RunModal(PAGE::"SSA Pstd Int. Cons. List", PostedIntConsHeader) = ACTION::LookupOK then begin
            PostedIntConsLine.SetFilter("Document No.", '=%1', PostedIntConsHeader."No.");
            if PostedIntConsLine.Find('-') then
                repeat
                    NewLine.Init;
                    NewLine.TransferFields(PostedIntConsLine);
                    NewLine."Document No." := "No.";
                    NewLine."Shipment Date" := "Posting Date";
                    NewLine.Validate(Quantity, -NewLine.Quantity);
                    if NewLine.Quantity < 0 then
                        NewLine.Validate(NewLine."Appl.-from Item Entry", PostedIntConsLine."Item Shpt. Entry No.")
                    else
                        NewLine.Validate(NewLine."Appl.-to Item Entry", PostedIntConsLine."Item Shpt. Entry No.");
                    NewLine.Insert;
                until PostedIntConsLine.Next() = 0;
            "Posting Description" := StrSubstNo(Text45013654, PostedIntConsHeader."No.");
            "Shortcut Dimension 1 Code" := PostedIntConsHeader."Shortcut Dimension 1 Code";
            "Shortcut Dimension 2 Code" := PostedIntConsHeader."Shortcut Dimension 2 Code";
            "Responsibility Center" := PostedIntConsHeader."Responsibility Center";
            "Location Code" := PostedIntConsHeader."Location Code";
            "Gen. Bus. Posting Group" := PostedIntConsHeader."Gen. Bus. Posting Group";
            "Posting Date" := PostedIntConsHeader."Posting Date";
            Cancelled := true;
            "Correction Cost" := Cancelled;
            "Cancelled from No." := PostedIntConsHeader."No.";
            Modify;

        end;
        //SSA1097<<
    end;

    procedure SendToPosting(_PostingCodeunitID: Integer) isSuccess: Boolean
    var
        ErrorMessageMgt: Codeunit "Error Message Management";
        ErrorMessageHandler: Codeunit "Error Message Handler";
    begin
        COMMIT;
        ErrorMessageMgt.Activate(ErrorMessageHandler);
        IsSuccess := CODEUNIT.RUN(_PostingCodeunitID, Rec);
        if not IsSuccess then
            ErrorMessageHandler.ShowErrors;
    end;
}

