codeunit 70015 "SSA CU90 Purchase-Post"
{
    // SSA958 SSCAT 23.08.2019 24.Funct. verificare sa nu posteze sell to diferit de bill to
    // SSA946 SSCAT 26.09.2019 12.Funct. functionalitate DVI la achizitii
    // SSA948 SSCAT 08.10.2019 14.Funct. Functionalitatea deductibilitate cheltuieli 50% /100%


    trigger OnRun()
    begin
    end;

    [EventSubscriber(ObjectType::Codeunit, 90, 'OnBeforePostPurchaseDoc', '', false, false)]
    local procedure OnBeforePostPurchaseDoc(var Sender: Codeunit "Purch.-Post"; var PurchaseHeader: Record "Purchase Header"; PreviewMode: Boolean; CommitIsSupressed: Boolean)
    var
        SSASetup: Record "SSA Localization Setup";
        IntrastatTransaction: Boolean;
    begin
        //SSA954>>
        SSASetup.Get;
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
        SSASetup.Get;
        if SSASetup."Custom Invoice No. Mandatory" then
            Sender.TestField("SSA Custom Invoice No.");
        //SSA946<<
    end;

    [EventSubscriber(ObjectType::Codeunit, 90, 'OnAfterPostInvPostBuffer', '', false, false)]
    local procedure OnAfterPostInvPostBuffer(var GenJnlLine: Record "Gen. Journal Line"; var InvoicePostBuffer: Record "Invoice Post. Buffer" temporary; PurchHeader: Record "Purchase Header"; GLEntryNo: Integer; CommitIsSupressed: Boolean; var GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line")
    var
        OldGenJnlLine: Record "Gen. Journal Line";
        VATPostingSetup: Record "VAT Posting Setup";
        FirstLineAmount: Decimal;
    begin
        //SSA948>>
        if not InvoicePostBuffer."SSA Distribute Non-Ded VAT" then
            exit;
        InvoicePostBuffer.TestField("SSA Non-Ded VAT Expense Acc 1");
        InvoicePostBuffer.TestField("SSA Non-Ded VAT Expense Acc 2");
        OldGenJnlLine := GenJnlLine;
        if not VATPostingSetup.Get(InvoicePostBuffer."VAT Bus. Posting Group", InvoicePostBuffer."VAT Prod. Posting Group") then
            Clear(VATPostingSetup);

        with GenJnlLine do begin
            InitNewLine(
              PurchHeader."Posting Date", PurchHeader."Document Date", PurchHeader."Posting Description",
              InvoicePostBuffer."Global Dimension 1 Code", InvoicePostBuffer."Global Dimension 2 Code",
              InvoicePostBuffer."Dimension Set ID", PurchHeader."Reason Code");

            CopyDocumentFields(OldGenJnlLine."Document Type", OldGenJnlLine."Document No.", OldGenJnlLine."External Document No.", OldGenJnlLine."Source Code", '');
            CopyFromPurchHeader(PurchHeader);
            CopyFromInvoicePostBuffer(InvoicePostBuffer);

            "Account Type" := GenJnlLine."Account Type"::"G/L Account";
            "Account No." := InvoicePostBuffer."SSA Non-Ded VAT Expense Acc 1";
            "Gen. Posting Type" := "Gen. Posting Type"::" ";
            "Gen. Bus. Posting Group" := '';
            "Gen. Prod. Posting Group" := '';
            "VAT Calculation Type" := 0;
            "VAT Bus. Posting Group" := '';
            "VAT Prod. Posting Group" := '';
            "Posting Group" := '';
            "Bal. Account Type" := "Bal. Account Type"::"G/L Account";
            "Bal. Account No." := VATPostingSetup."Purchase VAT Account";
            "Currency Code" := OldGenJnlLine."Currency Code";
            Amount := Round(InvoicePostBuffer."VAT Amount" / 2, 0.01);
            FirstLineAmount := Round(InvoicePostBuffer."VAT Amount" / 2, 0.01);
            "Amount (LCY)" := Round(InvoicePostBuffer."VAT Amount" / 2, 0.01);
            "Allow Zero-Amount Posting" := true;
            GenJnlPostLine.RunWithCheck(GenJnlLine);
        end;

        with GenJnlLine do begin
            InitNewLine(
              PurchHeader."Posting Date", PurchHeader."Document Date", PurchHeader."Posting Description",
              InvoicePostBuffer."Global Dimension 1 Code", InvoicePostBuffer."Global Dimension 2 Code",
              InvoicePostBuffer."Dimension Set ID", PurchHeader."Reason Code");

            CopyDocumentFields(OldGenJnlLine."Document Type", OldGenJnlLine."Document No.", OldGenJnlLine."External Document No.", OldGenJnlLine."Source Code", '');
            CopyFromPurchHeader(PurchHeader);
            CopyFromInvoicePostBuffer(InvoicePostBuffer);

            "Account Type" := GenJnlLine."Account Type"::"G/L Account";
            "Account No." := InvoicePostBuffer."SSA Non-Ded VAT Expense Acc 2";
            "Gen. Posting Type" := 0;
            "Gen. Bus. Posting Group" := '';
            "Gen. Prod. Posting Group" := '';
            "VAT Calculation Type" := 0;
            "VAT Bus. Posting Group" := '';
            "VAT Prod. Posting Group" := '';
            "Posting Group" := '';
            "Bal. Account Type" := "Bal. Account Type"::"G/L Account";
            "Bal. Account No." := VATPostingSetup."Purchase VAT Account";
            "Currency Code" := OldGenJnlLine."Currency Code";
            Amount := InvoicePostBuffer."VAT Amount" - FirstLineAmount;
            "Amount (LCY)" := InvoicePostBuffer."VAT Amount" - FirstLineAmount;
            "Allow Zero-Amount Posting" := true;
            GenJnlPostLine.RunWithCheck(GenJnlLine);
        end;
        //SSA948<<
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnBeforePurchRcptHeaderInsert', '', true, false)]
    local procedure OnBeforePurchRcptHeaderInsert(var PurchRcptHeader: Record "Purch. Rcpt. Header"; var PurchaseHeader: Record "Purchase Header")
    begin
        PurchRcptHeader."SSA Vendor Invoice No." := PurchaseHeader."Vendor Invoice No.";
    end;
}

