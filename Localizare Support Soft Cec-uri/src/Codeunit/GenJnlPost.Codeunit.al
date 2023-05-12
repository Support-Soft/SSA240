codeunit 70503 "SSA Gen. Jnl.-Post"
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post", 'OnBeforeCode', '', true, false)]
    local procedure OnBeforeCode(var GenJournalLine: Record "Gen. Journal Line"; var HideDialog: Boolean)
    var
        GenJnlTemplate: Record "Gen. Journal Template";
    begin
        IF GenJournalLine.FINDFIRST THEN
            REPEAT
                PostCheckApplication(GenJournalLine);
            UNTIL GenJournalLine.NEXT = 0;
        IF GenJnlTemplate.Type IN [GenJnlTemplate.Type::"Cash Receipts", GenJnlTemplate.Type::General] THEN
            CheckApplicationExist(GenJournalLine);
    end;

    local procedure CheckApplicationExist(VAR GenJnlLine: Record "Gen. Journal Line")
    var
        CustLE: Record "Cust. Ledger Entry";
        Text50000: Label 'The document %1 is not applied to any invoice.Do you want to continue?';
    begin
        GenJnlLine.SETRANGE("Document Type", GenJnlLine."Document Type"::Payment);
        IF GenJnlLine.FINDFIRST THEN
            REPEAT
                IF (GenJnlLine."Applies-to Doc. No." = '') THEN BEGIN
                    CustLE.SETCURRENTKEY("Applies-to ID");
                    CustLE.SETRANGE("Applies-to ID", GenJnlLine."Document No.");
                    IF CustLE.ISEMPTY THEN
                        IF NOT CONFIRM(STRSUBSTNO(Text50000, GenJnlLine."Document No.")) THEN
                            ERROR('')
                        ELSE
                            EXIT;
                END;
            UNTIL GenJnlLine.NEXT = 0;
        GenJnlLine.SETRANGE("Document Type");
    end;

    LOCAL procedure PostCheckApplication(VAR _GenJnlLine: Record "Gen. Journal Line")
    var
        PaymentHeader: Record "SSA Payment Header";
        PaymentLine: Record "SSA Payment Line";
        PaymentStep: Record "SSA Payment Step";
        PaymentMgt: Codeunit "SSA Payment Management";
    begin
        WITH _GenJnlLine DO BEGIN
            IF "SSA Applies-to CEC No." = '' THEN
                EXIT;

            IF NOT PaymentHeader.GET("SSA Applies-to CEC No.") THEN
                EXIT;

            TESTFIELD("Posting Date");
            TESTFIELD("Document No.");
            TESTFIELD("Account Type");
            TESTFIELD("Account No.");
            TESTFIELD("Bal. Account No.");

            PaymentHeader.CALCFIELDS(Amount);
            IF Amount <> PaymentHeader.Amount THEN
                ERROR('Suma introdusa difera de suma din CEC = %1', PaymentHeader.Amount);

            PaymentLine.RESET;
            PaymentLine.SETRANGE("No.", PaymentHeader."No.");
            IF PaymentLine.FINDFIRST THEN BEGIN
                IF "Account Type" <> PaymentLine."Account Type" THEN
                    ERROR('Tip cont introdus este diferit de cel din CEC = %1.', PaymentLine."Account Type");
                IF "Account No." <> PaymentLine."Account No." THEN
                    ERROR('Nr. cont introdus este diferit de cel din CEC = %1.', PaymentLine."Account No.");
                REPEAT
                    PaymentLine."External Document No." := "Document No.";
                    PaymentLine.MODIFY
                UNTIL PaymentLine.NEXT = 0;
            END;
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
        END;
    end;
}