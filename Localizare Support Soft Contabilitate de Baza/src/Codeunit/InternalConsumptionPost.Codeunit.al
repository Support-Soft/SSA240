codeunit 70003 "SSA Internal Consumption Post"
{
    // SSA937 SSCAT 16.06.2019 3.Funct. Bonuri de consum-consum intern

    TableNo = "SSAInternal Consumption Header";

    trigger OnRun()
    begin

        Window.Open(
              '#1#################################\\' +
              Text000);
        Window.Update(1, StrSubstNo('%1', "No."));

        if ("No. Series" <> '') then
            TestField("Posting No. Series");
        if ("No. Series" <> "Posting No. Series") then begin
            "Posting No." := NoSeriesMgt.GetNextNo("Posting No. Series", "Posting Date", true);
            Modify;
        end;

        SSASetup.Get;

        IntConsHeader := Rec;
        with IntConsHeader do begin
            TestField("Gen. Bus. Posting Group");
            "Last Posting No." := "Posting No.";
            IntPostedConsHeader.Init;
            IntPostedConsHeader.TransferFields(Rec);
            if "Posting No." <> '' then
                IntPostedConsHeader."No." := "Posting No.";
            IntPostedConsHeader.Insert;

            CheckDim;

            IntConsLine.SetRange("Document No.", IntConsHeader."No.");
            if IntConsLine.Find('-') then
                repeat
                    IntConsLine.TestField("Unit of Measure Code");

                    IntPostedConsLine.Init;
                    IntPostedConsLine.TransferFields(IntConsLine);
                    IntPostedConsLine."Document No." := IntPostedConsHeader."No.";
                    IntPostedConsLine.Insert;

                    with ItemJnlLine do begin
                        Validate("Item No.", IntConsLine."Item No.");
                        Validate("Posting Date", IntConsHeader."Posting Date");
                        Validate("Entry Type", "Entry Type"::"Negative Adjmt.");
                        "Shortcut Dimension 1 Code" := IntConsLine."Shortcut Dimension 1 Code";
                        "Shortcut Dimension 2 Code" := IntConsLine."Shortcut Dimension 2 Code";
                        Validate("Location Code", IntConsLine."Location Code");
                        Validate("Variant Code", IntConsLine."Variant Code");
                        Validate("Document No.", IntPostedConsHeader."No.");
                        Validate(Quantity, IntConsLine.Quantity);
                        "Applies-to Entry" := IntConsLine."Appl.-to Item Entry";
                        if IntConsLine.Quantity <> 0 then begin
                            Validate("Unit Amount", IntConsLine."Unit Cost (LCY)");
                            Validate("Unit Cost", IntConsLine."Unit Cost (LCY)");
                        end;
                        if IntConsLine."Appl.-from Item Entry" <> 0 then
                            Validate("Applies-from Entry", IntConsLine."Appl.-from Item Entry");
                        Validate("Gen. Bus. Posting Group", IntConsLine."Gen. Bus. Posting Group");
                        Validate("Gen. Prod. Posting Group", IntConsLine."Gen. Prod. Posting Group");
                        Description := IntConsHeader."Responsibility Center";
                        "SSA Document Type" := "SSA Document Type"::"Internal Consumption";
                        Validate("Item Shpt. Entry No.", 0);
                        "Dimension Set ID" := IntConsLine."Dimension Set ID";

                        "SSA Correction Cost" := IntConsHeader."Correction Cost";
                        "SSA Correction Cost Inv. Val." := IntConsHeader."Correction Cost";

                        ItemJnlPostLine.RunWithCheck(ItemJnlLine);

                        IntPostedConsLine."Item Shpt. Entry No." := ItemJnlLine."Item Shpt. Entry No.";
                        IntPostedConsLine.Modify;
                        Window.Update(1, StrSubstNo('%1', "No."));
                    end;
                until IntConsLine.Next = 0;

            SSACommentLine.Reset;
            SSACommentLine.SetRange("Document Type", SSACommentLine."Document Type"::"Internal Consumption");
            SSACommentLine.SetRange("No.", "No.");
            if SSACommentLine.Find('-') then
                repeat
                    NewSSACommentLine.Init;
                    NewSSACommentLine.Validate("Document Type", SSACommentLine."Document Type"::"Internal Consumption");
                    NewSSACommentLine.Validate("No.", IntPostedConsHeader."No.");
                    NewSSACommentLine.Validate("Line No.", SSACommentLine."Line No.");
                    NewSSACommentLine.Validate(Date, IntPostedConsHeader."Posting Date");
                    NewSSACommentLine.Validate(Code, SSACommentLine.Code);
                    NewSSACommentLine.Validate(Comment, SSACommentLine.Comment);
                    if NewSSACommentLine.Insert then
                        SSACommentLine.Delete;
                until SSACommentLine.Next = 0;

            IntConsLine.Reset;
            IntConsLine.SetRange("Document No.", "No.");
            IntConsLine.DeleteAll;

            Delete;
        end;


        Commit;
        Rec := IntConsHeader;
    end;

    var
        SSASetup: Record "SSA Localization Setup";
        SourceCodeSetup: Record "Source Code Setup";
        SourceCode: Record "Source Code";
        IntConsHeader: Record "SSAInternal Consumption Header";
        IntConsLine: Record "SSAInternal Consumption Line";
        IntPostedConsHeader: Record "SSA Pstd. Int. Cons. Header";
        IntPostedConsLine: Record "SSAPstd. Int. Consumption Line";
        InventorySetup: Record "Inventory Setup";
        ItemJnlLine: Record "Item Journal Line";
        SSACommentLine: Record "SSA Comment Line";
        NewSSACommentLine: Record "SSA Comment Line";
        Window: Dialog;
        ItemJnlPostLine: Codeunit "Item Jnl.-Post Line";
        DimMgt: Codeunit DimensionManagement;
        NoSeriesMgt: Codeunit NoSeriesManagement;
        Text000: Label 'Posting lines              #2######';
        Text001: Label 'The combination of dimensions used in Internal Consumption %1 is blocked. %2';
        Text002: Label 'The combination of dimensions used in Internal Consumption %1, line no. %2 is blocked. %3';
        Text003: Label 'The dimensions used in Internal Consumption %1 are invalid. %2';
        Text004: Label 'The dimensions used in Internal Consumption %1, line no. %2 are invalid. %3';
        Text005: Label 'The combination of dimensions used in transfer order %1 is blocked. %2';
        Text006: Label 'The combination of dimensions used in transfer order %1, line no. %2 is blocked. %3';
        Text007: Label 'The dimensions that are used in transfer order %1, line no. %2 are not valid. %3.';

    procedure TestDeleteHeader(IntConsumptionHeader: Record "SSAInternal Consumption Header"; var PostedIntConsumptionHeader: Record "SSA Pstd. Int. Cons. Header")
    begin
        with IntConsumptionHeader do begin
            Clear(PostedIntConsumptionHeader);
            SourceCodeSetup.Get;
            SourceCodeSetup.TestField("Deleted Document");
            SourceCode.Get(SourceCodeSetup."Deleted Document");

            if ("Posting No." <> '') and
              ("No. Series" = "Posting No. Series")
            then begin
                PostedIntConsumptionHeader.TransferFields(IntConsumptionHeader);
                if "Posting No." <> '' then
                    IntPostedConsHeader."No." := "Posting No."
                else
                    IntPostedConsHeader."No." := "No.";
                IntPostedConsHeader."Pre-Assigned No. Series" := "No. Series";
                IntPostedConsHeader."Pre-Assigned No." := "No.";
                IntPostedConsHeader."Posting Date" := Today;
                IntPostedConsHeader."User ID" := UserId;
                IntPostedConsHeader."Source Code" := SourceCode.Code;
            end;

        end;
    end;

    procedure DeleteHeader(IntConsHeader: Record "SSAInternal Consumption Header"; var PostedIntConsHeader: Record "SSA Pstd. Int. Cons. Header")
    begin
        with IntConsHeader do begin
            TestDeleteHeader(IntConsHeader, PostedIntConsHeader);
            if PostedIntConsHeader."No." <> '' then begin
                if not PostedIntConsHeader.Get("No.") then begin
                    IntPostedConsHeader.Insert;
                    IntPostedConsLine.Init;
                    IntPostedConsLine."Document No." := IntConsHeader."No.";
                    IntPostedConsLine."Line No." := 10000;
                    IntPostedConsLine.Description := SourceCode.Description;
                    IntPostedConsLine.Insert;
                end;
            end;
        end;
    end;

    local procedure CheckDim()
    begin
        IntConsLine."Line No." := 0;
        CheckDimComb(IntConsHeader, IntConsLine);
        CheckDimValuePosting(IntConsHeader, IntConsLine);

        IntConsLine.SetRange("Document No.", IntConsHeader."No.");
        if IntConsLine.FindFirst then begin
            CheckDimComb(IntConsHeader, IntConsLine);
            CheckDimValuePosting(IntConsHeader, IntConsLine);
        end;
    end;

    local procedure CheckDimComb(_IntConsHeader: Record "SSAInternal Consumption Header"; _IntConsLine: Record "SSAInternal Consumption Line")
    begin
        if _IntConsLine."Line No." = 0 then
            if not DimMgt.CheckDimIDComb(_IntConsHeader."Dimension Set ID") then
                Error(
                  Text005,
                  _IntConsHeader."No.", DimMgt.GetDimCombErr);
        if _IntConsLine."Line No." <> 0 then
            if not DimMgt.CheckDimIDComb(_IntConsLine."Dimension Set ID") then
                Error(
                  Text006,
                  _IntConsHeader."No.", _IntConsLine."Line No.", DimMgt.GetDimCombErr);
    end;

    local procedure CheckDimValuePosting(_IntConsHeader: Record "SSAInternal Consumption Header"; _IntConsLine: Record "SSAInternal Consumption Line")
    var
        TableIDArr: array[10] of Integer;
        NumberArr: array[10] of Code[20];
    begin
        TableIDArr[1] := DATABASE::Item;
        NumberArr[1] := _IntConsLine."Item No.";
        if _IntConsLine."Line No." = 0 then
            if not DimMgt.CheckDimValuePosting(TableIDArr, NumberArr, _IntConsHeader."Dimension Set ID") then
                Error(Text007, _IntConsHeader."No.", _IntConsLine."Line No.", DimMgt.GetDimValuePostingErr);

        if _IntConsLine."Line No." <> 0 then
            if not DimMgt.CheckDimValuePosting(TableIDArr, NumberArr, _IntConsLine."Dimension Set ID") then
                Error(Text007, _IntConsHeader."No.", _IntConsLine."Line No.", DimMgt.GetDimValuePostingErr);
    end;
}

