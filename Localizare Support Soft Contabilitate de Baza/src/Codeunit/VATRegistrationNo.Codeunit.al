codeunit 70017 "SSA VAT Registration No."
{
    [EventSubscriber(ObjectType::Table, Database::"VAT Registration No. Format", 'OnBeforeCheckVend', '', true, false)]
    local procedure SSACheckVendor(VATRegNo: Text[20]; Number: Code[20]; var IsHandled: Boolean)
    var
        Vend: Record Vendor;
        Check: Boolean;
        Finish: Boolean;
        TextString: Text;
        Text003: Label 'This VAT registration number has already been entered for the following vendors:\ %1';
    begin
        IsHandled := true;

        Check := TRUE;
        TextString := '';
        VATRegNo := DelChr(VATRegNo, '=', 'roRO');
        Vend.SETCURRENTKEY("VAT Registration No.");
        Vend.SetFilter("VAT Registration No.", STRSUBSTNO('*%1*', VATRegNo));
        Vend.SETFILTER("No.", '<>%1', Number);
        IF Vend.FINDSET THEN BEGIN
            Check := FALSE;
            Finish := FALSE;
            REPEAT
                AppendString(TextString, Finish, Vend."No.");
            UNTIL (Vend.NEXT = 0) OR Finish;
        END;
        IF NOT Check THEN
            //SSA964>>
            //OC MESSAGE(STRSUBSTNO(Text003,TextString));
            ERROR(STRSUBSTNO(Text003, TextString));
        //SSA964<<
    end;

    local procedure AppendString(var String: Text; var Finish: Boolean; AppendText: Text)
    begin
        CASE TRUE OF
            Finish:
                EXIT;
            String = '':
                String := AppendText;
            STRLEN(String) + STRLEN(AppendText) + 5 <= 250:
                String += ', ' + AppendText;
            ELSE BEGIN
                    String += '...';
                    Finish := TRUE;
                END;
        END;
    end;
}