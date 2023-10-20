codeunit 70001 "SSA TransferOrder"
{


    [EventSubscriber(ObjectType::Table, 5740, 'OnBeforeInsertEvent', '', false, false)]
    local procedure OnBeforeInsertEvent(var Rec: Record "Transfer Header"; RunTrigger: Boolean)
    var
        SSASetup: Record "SSA Localization Setup";
    begin
        //SSA938>>
        SSASetup.Get();
        SSASetup.TestField("Transfer Gen. Bus. Pstg. Group");
        Rec."SSA Gen. Bus. Posting Group" := SSASetup."Transfer Gen. Bus. Pstg. Group";
        //SSA938
    end;

    [EventSubscriber(ObjectType::Codeunit, 5704, 'OnBeforeTransferOrderPostShipment', '', false, false)]
    local procedure OnBeforeTransferOrderPostShipment(var TransferHeader: Record "Transfer Header"; CommitIsSuppressed: Boolean)
    var
        SSASetup: Record "SSA Localization Setup";
        IntrastatTransaction: Boolean;
    begin
        //SSA938>>
        SSASetup.Get();
        TransferHeader.TestField("SSA Gen. Bus. Posting Group");
        //SSA938<<

        //SSA954>>
        IntrastatTransaction := IsIntrastatTransaction(TransferHeader);
        if IntrastatTransaction then begin
            if SSASetup."Transaction Type Mandatory" then
                TransferHeader.TestField("Transaction Type");
            if SSASetup."Transaction Spec. Mandatory" then
                TransferHeader.TestField("Transaction Specification");
            if SSASetup."Transport Method Mandatory" then
                TransferHeader.TestField("Transport Method");
            if SSASetup."Shipment Method Mandatory" then
                TransferHeader.TestField("Shipment Method Code");
        end;
        //SSA954<<
    end;

    [EventSubscriber(ObjectType::Codeunit, 5705, 'OnBeforeTransferOrderPostReceipt', '', false, false)]
    local procedure OnBeforeTransferOrderPostReceipt(var TransferHeader: Record "Transfer Header"; CommitIsSuppressed: Boolean)
    var
        SSASetup: Record "SSA Localization Setup";
        IntrastatTransaction: Boolean;
    begin
        //SSA938>>
        SSASetup.Get();
        TransferHeader.TestField("SSA Gen. Bus. Posting Group");
        //SSA938<<

        //SSA954>>
        IntrastatTransaction := IsIntrastatTransaction(TransferHeader);
        if IntrastatTransaction then begin
            if SSASetup."Transaction Type Mandatory" then
                TransferHeader.TestField("Transaction Type");
            if SSASetup."Transaction Spec. Mandatory" then
                TransferHeader.TestField("Transaction Specification");
            if SSASetup."Transport Method Mandatory" then
                TransferHeader.TestField("Transport Method");
            if SSASetup."Shipment Method Mandatory" then
                TransferHeader.TestField("Shipment Method Code");
        end;
        //SSA954<<
    end;

    [EventSubscriber(ObjectType::Codeunit, 5704, 'OnAfterCreateItemJnlLine', '', false, false)]
    local procedure TransferShipmentOnAfterCreateItemJnlLine(var ItemJournalLine: Record "Item Journal Line"; TransferLine: Record "Transfer Line"; TransferShipmentHeader: Record "Transfer Shipment Header"; TransferShipmentLine: Record "Transfer Shipment Line")
    begin
        //SSA935>>
        ItemJournalLine."SSA Correction Cost" := TransferShipmentHeader."SSA Correction";
        ItemJournalLine."SSA Correction Cost Inv. Val." := TransferShipmentHeader."SSA Correction";
        //SSA935<<

        //SSA938>>
        ItemJournalLine."Gen. Bus. Posting Group" := TransferShipmentHeader."SSA Gen. Bus. Posting Group";
        //SSA9389<<
    end;

    [EventSubscriber(ObjectType::Codeunit, 5705, 'OnBeforePostItemJournalLine', '', false, false)]
    local procedure TransferReceiptOnAfterCreateItemJnlLine(var ItemJournalLine: Record "Item Journal Line"; TransferLine: Record "Transfer Line"; TransferReceiptHeader: Record "Transfer Receipt Header"; TransferReceiptLine: Record "Transfer Receipt Line"; CommitIsSuppressed: Boolean)
    begin
        //SSA935>>
        ItemJournalLine."SSA Correction Cost" := TransferReceiptHeader."SSA Correction";
        ItemJournalLine."SSA Correction Cost Inv. Val." := TransferReceiptHeader."SSA Correction";
        //SSA935<<

        //SSA938>>
        ItemJournalLine."Gen. Bus. Posting Group" := TransferReceiptHeader."SSA Gen. Bus. Posting Group";
        //SSA938<<
    end;

    [EventSubscriber(ObjectType::Table, 5746, 'OnAfterCopyFromTransferHeader', '', false, false)]
    local procedure TransferShipmentOnAfterCopyFromTransferHeader(var TransferReceiptHeader: Record "Transfer Receipt Header"; TransferHeader: Record "Transfer Header")
    begin
        //SSA935>>
        TransferReceiptHeader."SSA Correction" := TransferHeader."SSA Correction";
        //SSA935<<

        //SSA938>>
        TransferReceiptHeader."SSA Gen. Bus. Posting Group" := TransferHeader."SSA Gen. Bus. Posting Group";
        //SSA938<<
    end;

    [EventSubscriber(ObjectType::Table, 5744, 'OnAfterCopyFromTransferHeader', '', false, false)]
    local procedure TransferReceiptOnAfterCopyFromTransferHeader(var TransferShipmentHeader: Record "Transfer Shipment Header"; TransferHeader: Record "Transfer Header")
    begin
        //SSA935>>
        TransferShipmentHeader."SSA Correction" := TransferHeader."SSA Correction";
        //SSA935<<
        //SSA938>>
        TransferShipmentHeader."SSA Gen. Bus. Posting Group" := TransferHeader."SSA Gen. Bus. Posting Group";
        //SSA938<<
    end;

    local
    procedure IsIntrastatTransaction(var _TransferHeader: Record "Transfer Header"): Boolean
    var
        CompanyInfo: Record "Company Information";
        SSAIntrastat: Codeunit "SSA Intrastat";
    begin
        //SSA954>>
        if _TransferHeader."Trsf.-from Country/Region Code" = _TransferHeader."Trsf.-to Country/Region Code" then
            exit(false);

        CompanyInfo.Get();
        if _TransferHeader."Trsf.-from Country/Region Code" in ['', CompanyInfo."Country/Region Code"] then
            exit(SSAIntrastat.IsCountryRegionIntrastat(_TransferHeader."Trsf.-to Country/Region Code", false));
        if _TransferHeader."Trsf.-to Country/Region Code" in ['', CompanyInfo."Country/Region Code"] then
            exit(SSAIntrastat.IsCountryRegionIntrastat(_TransferHeader."Trsf.-from Country/Region Code", false));
        exit(false);
        //SSA954<<
    end;
}
