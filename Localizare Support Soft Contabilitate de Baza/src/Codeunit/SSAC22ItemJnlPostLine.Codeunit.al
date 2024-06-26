codeunit 70000 "SSA C22 Item Jnl.-Post Line"
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Jnl.-Post Line", 'OnBeforePostItemJnlLine', '', false, false)]
    local procedure OnBeforePostItemJnlLine(var ItemJournalLine: Record "Item Journal Line")
    var
        LocalizationSetup: Record "SSA Localization Setup";
    begin
        LocalizationSetup.SetLoadFields("Allow Post Inv. Wh Gen Bus.");
        LocalizationSetup.Get();
        if not LocalizationSetup."Allow Post Inv. Wh Gen Bus." then
            ItemJournalLine.TestField("Gen. Bus. Posting Group"); //SSA938
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Jnl.-Post Line", 'OnPostOutputOnBeforePostItem', '', false, false)]
    local procedure OnPostOutputOnBeforePostItem(var ItemJournalLine: Record "Item Journal Line")
    var
        LocalizationSetup: Record "SSA Localization Setup";
    begin
        LocalizationSetup.SetLoadFields("Allow Post Inv. Wh Gen Bus.");
        LocalizationSetup.Get();
        if not LocalizationSetup."Allow Post Inv. Wh Gen Bus." then
            ItemJournalLine.TestField("Gen. Bus. Posting Group"); //SSA938
    end;

    [EventSubscriber(ObjectType::Codeunit, 22, 'OnAfterInitValueEntry', '', false, false)]
    local procedure OnAfterInitValueEntry(var ValueEntry: Record "Value Entry"; ItemJournalLine: Record "Item Journal Line"; var ValueEntryNo: Integer)
    begin
        //SSA935>>
        ValueEntry."SSA Correction Cost" := ItemJournalLine."SSA Correction Cost";
        ValueEntry."SSA Correction Cost Inv. Val." := ItemJournalLine."SSA Correction Cost Inv. Val.";
        //SA935<<

        //SSA946>>
        ValueEntry."SSA Custom Invoice No." := ItemJournalLine."SSA Custom Invoice No.";
        //SSA946<<
    end;

    [EventSubscriber(ObjectType::Codeunit, 22, 'OnAfterInitItemLedgEntry', '', false, false)]
    local procedure OnAfterInitItemLedgEntry(var NewItemLedgEntry: Record "Item Ledger Entry"; ItemJournalLine: Record "Item Journal Line"; var ItemLedgEntryNo: Integer)
    begin
        //SSA946>>
        NewItemLedgEntry."SSA Custom Invoice No." := ItemJournalLine."SSA Custom Invoice No.";
        //SSA946<<
        NewItemLedgEntry."SSA Document Type" := ItemJournalLine."SSA Document Type";
    end;

    [EventSubscriber(ObjectType::Codeunit, 22, 'OnBeforeInsertCapValueEntry', '', false, false)]
    local procedure OnBeforeInsertCapValueEntry(var ValueEntry: Record "Value Entry"; ItemJnlLine: Record "Item Journal Line")
    begin
        //SSA946>>
        ValueEntry."SSA Custom Invoice No." := ItemJnlLine."SSA Custom Invoice No.";
        //SSA946<<
    end;

    [EventSubscriber(ObjectType::Codeunit, 22, 'OnBeforeInsertCorrValueEntry', '', false, false)]
    local procedure C22_OnBeforeInsertCorrValueEntry(var NewValueEntry: Record "Value Entry"; OldValueEntry: Record "Value Entry"; var ItemJournalLine: Record "Item Journal Line"; Sign: Integer)
    begin
        if Sign < 0 then begin
            NewValueEntry."SSA Correction Cost" := not OldValueEntry."SSA Correction Cost";
            NewValueEntry."SSA Correction Cost Inv. Val." := not OldValueEntry."SSA Correction Cost Inv. Val.";
        end
        else begin
            NewValueEntry."SSA Correction Cost" := OldValueEntry."SSA Correction Cost";
            NewValueEntry."SSA Correction Cost Inv. Val." := OldValueEntry."SSA Correction Cost Inv. Val.";
        end;
    end;
}
