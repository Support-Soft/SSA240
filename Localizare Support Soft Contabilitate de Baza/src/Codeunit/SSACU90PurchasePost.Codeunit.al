codeunit 70015 "SSA CU90 Purchase-Post"
{
    [EventSubscriber(ObjectType::Codeunit, 90, 'OnBeforePostPurchaseDoc', '', false, false)]
    local procedure OnBeforePostPurchaseDoc(var Sender: Codeunit "Purch.-Post"; var PurchaseHeader: Record "Purchase Header"; PreviewMode: Boolean; CommitIsSupressed: Boolean)
    var
        SSASetup: Record "SSA Localization Setup";
        IntrastatTransaction: Boolean;
    begin
        //SSA954>>
        SSASetup.Get();
        IntrastatTransaction := IsIntrastatTransaction(PurchaseHeader);
        if IntrastatTransaction then begin
            if SSASetup."Transaction Type Mandatory" then
                PurchaseHeader.TestField("Transaction Type");
            if SSASetup."Transaction Spec. Mandatory" then
                PurchaseHeader.TestField("Transaction Specification");
            if SSASetup."Transport Method Mandatory" then
                PurchaseHeader.TestField("Transport Method");
            if SSASetup."Shipment Method Mandatory" then
                PurchaseHeader.TestField("Shipment Method Code");
        end;
        //SSA954<<

        //SSA958>>
        if not SSASetup."Allow Diff. Buy-from Pay-to" then
            PurchaseHeader.TestField("Buy-from Vendor No.", PurchaseHeader."Pay-to Vendor No.");
        //SSA958<<
    end;

    local procedure IsIntrastatTransaction(_PurchaseHeader: Record "Purchase Header"): Boolean
    var
        SSAIntrastat: Codeunit "SSA Intrastat";
    begin
        //SSA954>>
        exit(SSAIntrastat.IsCountryRegionIntrastat(_PurchaseHeader."VAT Country/Region Code", false));
        //SSA954<<
    end;

    [EventSubscriber(ObjectType::Table, 38, 'OnCheckPurchasePostRestrictions', '', false, false)]
    local procedure T38OnCheckPurchasePostRestrictions(var Sender: Record "Purchase Header")
    var
        SSASetup: Record "SSA Localization Setup";
    begin
        //SSA946>>
        if not Sender.Invoice then
            exit;
        SSASetup.Get();
        if SSASetup."Custom Invoice No. Mandatory" then
            Sender.TestField("SSA Custom Invoice No.");
        //SSA946<<
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch. Post Invoice Events", 'OnPostLinesOnAfterGenJnlLinePost', '', false, false)]
    local procedure OnAfterPostInvPostBuffer(var GenJnlLine: Record "Gen. Journal Line"; PurchHeader: Record "Purchase Header"; GLEntryNo: Integer; var GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line"; TempInvoicePostingBuffer: Record "Invoice Posting Buffer" temporary)
    var
        OldGenJnlLine: Record "Gen. Journal Line";
        VATPostingSetup: Record "VAT Posting Setup";
        FirstLineAmount: Decimal;
    begin
        //SSA948>>
        if not TempInvoicePostingBuffer."SSA Distribute Non-Ded VAT" then
            exit;
        TempInvoicePostingBuffer.TestField("SSA Non-Ded VAT Expense Acc 1");
        TempInvoicePostingBuffer.TestField("SSA Non-Ded VAT Expense Acc 2");
        OldGenJnlLine := GenJnlLine;
        if not VATPostingSetup.Get(TempInvoicePostingBuffer."VAT Bus. Posting Group", TempInvoicePostingBuffer."VAT Prod. Posting Group") then
            Clear(VATPostingSetup);

        GenJnlLine.InitNewLine(
  PurchHeader."Posting Date", PurchHeader."Document Date", PurchHeader."Posting Description",
  TempInvoicePostingBuffer."Global Dimension 1 Code", TempInvoicePostingBuffer."Global Dimension 2 Code",
  TempInvoicePostingBuffer."Dimension Set ID", PurchHeader."Reason Code");

        GenJnlLine.CopyDocumentFields(OldGenJnlLine."Document Type", OldGenJnlLine."Document No.", OldGenJnlLine."External Document No.", OldGenJnlLine."Source Code", '');
        GenJnlLine.CopyFromPurchHeader(PurchHeader);
        GenJnlLine.CopyFromInvoicePostBuffer(InvoicePostBuffer);

        GenJnlLine."Account Type" := GenJnlLine."Account Type"::"G/L Account";
        GenJnlLine."Account No." := InvoicePostBuffer."SSA Non-Ded VAT Expense Acc 1";
        GenJnlLine."Gen. Posting Type" := GenJnlLine."Gen. Posting Type"::" ";
        GenJnlLine."Gen. Bus. Posting Group" := '';
        GenJnlLine."Gen. Prod. Posting Group" := '';
        GenJnlLine."VAT Calculation Type" := 0;
        GenJnlLine."VAT Bus. Posting Group" := '';
        GenJnlLine."VAT Prod. Posting Group" := '';
        GenJnlLine."Posting Group" := '';
        GenJnlLine."Bal. Account Type" := GenJnlLine."Bal. Account Type"::"G/L Account";
        GenJnlLine."Bal. Account No." := VATPostingSetup."Purchase VAT Account";
        GenJnlLine."Currency Code" := OldGenJnlLine."Currency Code";
        GenJnlLine.Amount := Round(InvoicePostBuffer."VAT Amount" / 2, 0.01);
        FirstLineAmount := Round(InvoicePostBuffer."VAT Amount" / 2, 0.01);
        GenJnlLine."Amount (LCY)" := Round(InvoicePostBuffer."VAT Amount" / 2, 0.01);
        GenJnlLine."Allow Zero-Amount Posting" := true;
        GenJnlPostLine.RunWithCheck(GenJnlLine);

        GenJnlLine.InitNewLine(
  PurchHeader."Posting Date", PurchHeader."Document Date", PurchHeader."Posting Description",
  InvoicePostBuffer."Global Dimension 1 Code", InvoicePostBuffer."Global Dimension 2 Code",
  InvoicePostBuffer."Dimension Set ID", PurchHeader."Reason Code");

        GenJnlLine.CopyDocumentFields(OldGenJnlLine."Document Type", OldGenJnlLine."Document No.", OldGenJnlLine."External Document No.", OldGenJnlLine."Source Code", '');
        GenJnlLine.CopyFromPurchHeader(PurchHeader);
        GenJnlLine.CopyFromInvoicePostBuffer(InvoicePostBuffer);

        GenJnlLine."Account Type" := GenJnlLine."Account Type"::"G/L Account";
        GenJnlLine."Account No." := InvoicePostBuffer."SSA Non-Ded VAT Expense Acc 2";
        GenJnlLine."Gen. Posting Type" := 0;
        GenJnlLine."Gen. Bus. Posting Group" := '';
        GenJnlLine."Gen. Prod. Posting Group" := '';
        GenJnlLine."VAT Calculation Type" := 0;
        GenJnlLine."VAT Bus. Posting Group" := '';
        GenJnlLine."VAT Prod. Posting Group" := '';
        GenJnlLine."Posting Group" := '';
        GenJnlLine."Bal. Account Type" := GenJnlLine."Bal. Account Type"::"G/L Account";
        GenJnlLine."Bal. Account No." := VATPostingSetup."Purchase VAT Account";
        GenJnlLine."Currency Code" := OldGenJnlLine."Currency Code";
        GenJnlLine.Amount := InvoicePostBuffer."VAT Amount" - FirstLineAmount;
        GenJnlLine."Amount (LCY)" := InvoicePostBuffer."VAT Amount" - FirstLineAmount;
        GenJnlLine."Allow Zero-Amount Posting" := true;
        GenJnlPostLine.RunWithCheck(GenJnlLine);
        //SSA948<<
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnBeforePurchRcptHeaderInsert', '', true, false)]
    local procedure OnBeforePurchRcptHeaderInsert(var PurchRcptHeader: Record "Purch. Rcpt. Header"; var PurchaseHeader: Record "Purchase Header")
    begin
        PurchRcptHeader."SSA Vendor Invoice No." := PurchaseHeader."Vendor Invoice No.";
    end;
}
