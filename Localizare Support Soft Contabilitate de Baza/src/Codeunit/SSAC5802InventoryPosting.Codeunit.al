codeunit 70002 "SSA C5802 Inventory Posting"
{
    [EventSubscriber(ObjectType::Codeunit, 5802, 'OnAfterInitTempInvtPostBuf', '', false, false)]
    local procedure OnAfterInitTempInvtPostBuf(var Sender: Codeunit "Inventory Posting To G/L"; var TempInvtPostBuf: array[20] of Record "Invt. Posting Buffer" temporary; ValueEntry: Record "Value Entry")
    begin
        //SSA935>>
        TempInvtPostBuf[1]."SSA Correction Cost" := ValueEntry."SSA Correction Cost";
        TempInvtPostBuf[2]."SSA Correction Cost" := ValueEntry."SSA Correction Cost";
        TempInvtPostBuf[3]."SSA Correction Cost" := ValueEntry."SSA Correction Cost";
        TempInvtPostBuf[4]."SSA Correction Cost" := ValueEntry."SSA Correction Cost";
        TempInvtPostBuf[5]."SSA Correction Cost" := ValueEntry."SSA Correction Cost";
        TempInvtPostBuf[6]."SSA Correction Cost" := ValueEntry."SSA Correction Cost";
        TempInvtPostBuf[7]."SSA Correction Cost" := ValueEntry."SSA Correction Cost";
        TempInvtPostBuf[8]."SSA Correction Cost" := ValueEntry."SSA Correction Cost";
        TempInvtPostBuf[9]."SSA Correction Cost" := ValueEntry."SSA Correction Cost";
        TempInvtPostBuf[10]."SSA Correction Cost" := ValueEntry."SSA Correction Cost";
        TempInvtPostBuf[11]."SSA Correction Cost" := ValueEntry."SSA Correction Cost";
        TempInvtPostBuf[12]."SSA Correction Cost" := ValueEntry."SSA Correction Cost";
        TempInvtPostBuf[13]."SSA Correction Cost" := ValueEntry."SSA Correction Cost";
        TempInvtPostBuf[14]."SSA Correction Cost" := ValueEntry."SSA Correction Cost";
        TempInvtPostBuf[15]."SSA Correction Cost" := ValueEntry."SSA Correction Cost";
        TempInvtPostBuf[16]."SSA Correction Cost" := ValueEntry."SSA Correction Cost";
        TempInvtPostBuf[17]."SSA Correction Cost" := ValueEntry."SSA Correction Cost";
        TempInvtPostBuf[18]."SSA Correction Cost" := ValueEntry."SSA Correction Cost";
        TempInvtPostBuf[19]."SSA Correction Cost" := ValueEntry."SSA Correction Cost";
        TempInvtPostBuf[20]."SSA Correction Cost" := ValueEntry."SSA Correction Cost";
        //SSA935<<
    end;

    [EventSubscriber(ObjectType::Codeunit, 5802, 'OnBeforePostInvtPostBuf', '', false, false)]
    local procedure OnBeforePostInvtPostBuf(var GenJournalLine: Record "Gen. Journal Line"; var InvtPostingBuffer: Record "Invt. Posting Buffer"; ValueEntry: Record "Value Entry"; var GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line")
    begin
        //SSA935>
        GenJournalLine.Correction := InvtPostingBuffer."SSA Correction Cost";
        //SSA935<<
    end;

    [EventSubscriber(ObjectType::Table, 48, 'OnBeforeModifyEvent', '', false, false)]
    local procedure OnModify(var Rec: Record "Invt. Posting Buffer"; var xRec: Record "Invt. Posting Buffer"; RunTrigger: Boolean)
    begin
        //SSA935>>
        Rec."SSA Correction Cost" := false;
        //SSA935<<
    end;

    [EventSubscriber(ObjectType::Codeunit, 5802, 'OnAfterSetAccNo', '', false, false)]
    local procedure OnAfterSetAccNo(var InvtPostingBuffer: Record "Invt. Posting Buffer"; ValueEntry: Record "Value Entry"; CalledFromItemPosting: Boolean)
    begin
        //SSA935>>
        InvtPostingBuffer."SSA Correction Cost" := ValueEntry."SSA Correction Cost";
        //SA935<<
    end;

    local procedure "----------CostAdjust"()
    begin
    end;

    [EventSubscriber(ObjectType::Codeunit, 5895, 'OnPostItemJnlLineCopyFromValueEntry', '', false, false)]
    local procedure OnPostItemJnlLineCopyFromValueEntry(var ItemJournalLine: Record "Item Journal Line"; ValueEntry: Record "Value Entry")
    begin
        //SSA95>>
        ItemJournalLine."SSA Correction Cost" := SetCorrectionCost(ValueEntry, ItemJournalLine.Amount);
        ItemJournalLine."SSA Correction Cost Inv. Val." := ItemJournalLine."SSA Correction Cost";
        //SSA935<<
    end;

    local procedure SetCorrectionCost(ValueEntry: Record "Value Entry"; NewAdjustedCost: Decimal): Boolean
    begin
        //SSA35>>
        if ValueEntry."Item Ledger Entry Type" in
          [ValueEntry."Item Ledger Entry Type"::Transfer,
          ValueEntry."Item Ledger Entry Type"::"Positive Adjmt.",
          ValueEntry."Item Ledger Entry Type"::"Negative Adjmt."] then begin
            if (NewAdjustedCost < 0) and (ValueEntry."Valued Quantity" > 0) then
                exit(not ValueEntry."SSA Correction Cost");
            if (NewAdjustedCost > 0) and (ValueEntry."Valued Quantity" < 0) then
                exit(not ValueEntry."SSA Correction Cost");
            if (NewAdjustedCost > 0) and (ValueEntry."Valued Quantity" > 0) then
                exit(ValueEntry."SSA Correction Cost");
            if (NewAdjustedCost < 0) and (ValueEntry."Valued Quantity" < 0) then
                exit(ValueEntry."SSA Correction Cost");
        end;
        if ValueEntry."Item Ledger Entry Type" in
          [ValueEntry."Item Ledger Entry Type"::Sale] then begin
            if (NewAdjustedCost < 0) and (ValueEntry."Valued Quantity" > 0) then
                exit(not ValueEntry."SSA Correction Cost");
            if (NewAdjustedCost > 0) and (ValueEntry."Valued Quantity" < 0) then
                exit(not ValueEntry."SSA Correction Cost");
            if (NewAdjustedCost > 0) and (ValueEntry."Valued Quantity" > 0) then
                exit(ValueEntry."SSA Correction Cost");
            if (NewAdjustedCost < 0) and (ValueEntry."Valued Quantity" < 0) then
                exit(ValueEntry."SSA Correction Cost");
        end;
        if ValueEntry."Item Ledger Entry Type" in
          [ValueEntry."Item Ledger Entry Type"::Purchase] then begin
            if (NewAdjustedCost < 0) and (ValueEntry."Valued Quantity" > 0) then
                exit(not ValueEntry."SSA Correction Cost");
            if (NewAdjustedCost > 0) and (ValueEntry."Valued Quantity" < 0) then
                exit(not ValueEntry."SSA Correction Cost");
            if (NewAdjustedCost > 0) and (ValueEntry."Valued Quantity" > 0) then
                exit(ValueEntry."SSA Correction Cost");
            if (NewAdjustedCost < 0) and (ValueEntry."Valued Quantity" < 0) then
                exit(ValueEntry."SSA Correction Cost");
        end;
        exit(false);
        //SSA935<<
    end;
}
