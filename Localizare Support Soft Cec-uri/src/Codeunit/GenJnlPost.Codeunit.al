codeunit 70503 "SSA Gen. Jnl.-Post"
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post", 'OnBeforeCode', '', true, false)]
    local procedure OnBeforeCode(var GenJournalLine: Record "Gen. Journal Line"; var HideDialog: Boolean)
    var
        GenJnlTemplate: Record "Gen. Journal Template";
    begin
        if GenJournalLine.FINDFIRST then
            repeat
                PostCheckApplication(GenJournalLine);
            until GenJournalLine.NEXT = 0;
        if GenJnlTemplate.Type in [GenJnlTemplate.Type::"Cash Receipts", GenJnlTemplate.Type::General] then
            CheckApplicationExist(GenJournalLine);
    end;

    local procedure CheckApplicationExist(var GenJnlLine: Record "Gen. Journal Line")
    var
        CustLE: Record "Cust. Ledger Entry";
        Text50000: Label 'The document %1 is not applied to any invoice.Do you want to continue?';
    begin
        GenJnlLine.SETRANGE("Document Type", GenJnlLine."Document Type"::Payment);
        if GenJnlLine.FINDFIRST then
            repeat
                if (GenJnlLine."Applies-to Doc. No." = '') then begin
                    CustLE.SETCURRENTKEY("Applies-to ID");
                    CustLE.SETRANGE("Applies-to ID", GenJnlLine."Document No.");
                    if CustLE.ISEMPTY then
                        if not CONFIRM(STRSUBSTNO(Text50000, GenJnlLine."Document No.")) then
                            ERROR('')
                        else
                            exit;
                end;
            until GenJnlLine.NEXT = 0;
        GenJnlLine.SETRANGE("Document Type");
    end;

    local procedure PostCheckApplication(var _GenJnlLine: Record "Gen. Journal Line")
    var
        PaymentHeader: Record "SSA Payment Header";
        PaymentLine: Record "SSA Payment Line";
        PaymentStep: Record "SSA Payment Step";
        PaymentMgt: Codeunit "SSA Payment Management";
    begin
        with _GenJnlLine do begin
            if "SSA Applies-to CEC No." = '' then
                exit;

            if not PaymentHeader.GET("SSA Applies-to CEC No.") then
                exit;

            TESTFIELD("Posting Date");
            TESTFIELD("Document No.");
            TESTFIELD("Account Type");
            TESTFIELD("Account No.");
            TESTFIELD("Bal. Account No.");

            PaymentHeader.CALCFIELDS(Amount);
            if Amount <> PaymentHeader.Amount then
                ERROR('Suma introdusa difera de suma din CEC = %1', PaymentHeader.Amount);

            PaymentLine.RESET;
            PaymentLine.SETRANGE("No.", PaymentHeader."No.");
            if PaymentLine.FINDFIRST then begin
                if "Account Type" <> PaymentLine."Account Type" then
                    ERROR('Tip cont introdus este diferit de cel din CEC = %1.', PaymentLine."Account Type");
                if "Account No." <> PaymentLine."Account No." then
                    ERROR('Nr. cont introdus este diferit de cel din CEC = %1.', PaymentLine."Account No.");
                repeat
                    PaymentLine."External Document No." := "Document No.";
                    PaymentLine.MODIFY
                until PaymentLine.NEXT = 0;
            end;
            PaymentHeader."Account No." := "Bal. Account No.";
            PaymentHeader.VALIDATE("Posting Date", "Posting Date");
            PaymentHeader.MODIFY;

            PaymentStep.RESET;
            PaymentStep.SETRANGE("Payment Class", PaymentHeader."Payment Class");
            PaymentStep.SETRANGE("Previous Status", PaymentHeader."Status No.");
            PaymentStep.SETFILTER("Action Type",
              '<>%1&<>%2&<>%3',
              PaymentStep."Action Type"::Report,
              PaymentStep."Action Type"::File,
              PaymentStep."Action Type"::"Create new Document");
            PaymentStep.FINDFIRST;
            PaymentMgt.Valbord(PaymentHeader, PaymentStep);
            DELETE;
        end;
    end;
}