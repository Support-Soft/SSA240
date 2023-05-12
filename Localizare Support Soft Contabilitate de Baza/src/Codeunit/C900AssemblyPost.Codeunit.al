codeunit 70008 "SSA C900 Assembly-Post"
{
    // SSA938 SSCAT 16.06.2019 4.Funct. business posting group obligatoriu la transferuri si asamblari


    trigger OnRun()
    begin
    end;

    [EventSubscriber(ObjectType::Table, 900, 'OnBeforeInsertEvent', '', false, false)]
    local procedure OnBeforeInsertEvent(var Rec: Record "Assembly Header"; RunTrigger: Boolean)
    var
        SSASetup: Record "SSA Localization Setup";
    begin
        SSASetup.Get;
        Rec."SSA Gen. Bus. Posting Group" := SSASetup."Assembly Gen. Bus. Pstg. Group";
    end;

    [EventSubscriber(ObjectType::Codeunit, 900, 'OnBeforeInitPost', '', false, false)]
    local procedure OnBeforeInitPost(var AssemblyHeader: Record "Assembly Header")
    var
        SSASetup: Record "SSA Localization Setup";
    begin
        //SSA938>>
        SSASetup.Get;
        AssemblyHeader.TestField("SSA Gen. Bus. Posting Group");
        //SSA938<<
    end;

    [EventSubscriber(ObjectType::Codeunit, 900, 'OnBeforePostItemConsumption', '', false, false)]
    local procedure OnBeforePostItemConsumption(var AssemblyHeader: Record "Assembly Header"; var AssemblyLine: Record "Assembly Line"; var ItemJournalLine: Record "Item Journal Line")
    begin
        //SSA938>>
        ItemJournalLine."Gen. Bus. Posting Group" := AssemblyHeader."SSA Gen. Bus. Posting Group";
        //SSA938<<
    end;

    [EventSubscriber(ObjectType::Codeunit, 900, 'OnAfterCreateItemJnlLineFromAssemblyLine', '', false, false)]
    local procedure OnAfterCreateItemJnlLineFromAssemblyLine(var ItemJournalLine: Record "Item Journal Line"; AssemblyLine: Record "Assembly Line")
    var
        AssemblyHeader: Record "Assembly Header";
    begin
        //SSA938>>
        AssemblyHeader.Get(AssemblyLine."Document Type", AssemblyLine."Document No.");
        ItemJournalLine."Gen. Bus. Posting Group" := AssemblyHeader."SSA Gen. Bus. Posting Group";
        //SSA938<<
    end;

    [EventSubscriber(ObjectType::Codeunit, 900, 'OnAfterCreateResJnlLineFromItemJnlLine', '', false, false)]
    local procedure OnAfterCreateResJnlLineFromItemJnlLine(var ResJournalLine: Record "Res. Journal Line"; ItemJournalLine: Record "Item Journal Line"; AssemblyLine: Record "Assembly Line")
    begin
        //SSA938>>
        ResJournalLine."Gen. Bus. Posting Group" := ItemJournalLine."Gen. Bus. Posting Group";
        //SSA938<<
    end;

    [EventSubscriber(ObjectType::Codeunit, 900, 'OnAfterCreateItemJnlLineFromAssemblyHeader', '', false, false)]
    local procedure OnAfterCreateItemJnlLineFromAssemblyHeader(var ItemJournalLine: Record "Item Journal Line"; AssemblyHeader: Record "Assembly Header")
    begin
        //SSA938>>
        ItemJournalLine."Gen. Bus. Posting Group" := AssemblyHeader."SSA Gen. Bus. Posting Group";
        //SSA938<<
    end;
}

