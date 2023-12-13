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
        NewVATRegNo: Text;
        i: Integer;
        TextVar: Text;
        IntVar: Integer;
    begin
        IsHandled := true;

        Check := true;
        TextString := '';
        VATRegNo := DelChr(VATRegNo, '=', 'roRO');
        Vend.SetCurrentKey("VAT Registration No.");
        Vend.SetFilter("VAT Registration No.", StrSubstNo('*%1*', VATRegNo));
        Vend.SetFilter("No.", '<>%1', Number);
        if Vend.FindSet() then begin
            Finish := false;
            repeat
                CLEAR(NewVATRegNo);
                for i := 1 to STRLEN(Vend."VAT Registration No.") do begin
                    TextVar := COPYSTR(Vend."VAT Registration No.", i, 1);
                    if EVALUATE(IntVar, TextVar) then
                        NewVATRegNo += TextVar;
                end;
                if (NewVATRegNo = VATRegNo) then begin
                    Check := false;
                    AppendString(TextString, Finish, Vend."No.");
                end;
            until (Vend.Next() = 0) or Finish;
        end;
        if not Check then
            //SSA964>>
            //OC MESSAGE(STRSUBSTNO(Text003,TextString));
            Error(StrSubstNo(Text003, TextString));
        //SSA964<<
    end;

    local procedure AppendString(var String: Text; var Finish: Boolean; AppendText: Text)
    begin
        case true of
            Finish:
                exit;
            String = '':
                String := AppendText;
            StrLen(String) + StrLen(AppendText) + 5 <= 250:
                String += ', ' + AppendText;
            else begin
                String += '...';
                Finish := true;
            end;
        end;
    end;
}