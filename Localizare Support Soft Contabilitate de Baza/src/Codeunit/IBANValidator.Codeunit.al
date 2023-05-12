codeunit 70029 "SSA IBAN Validator"
{

    trigger OnRun()
    begin
    end;

    local
    procedure IsIBANValid(_IBAN: Code[50])
    begin
        if ValidateIBAN(_IBAN) then
            Message('%1 a fost validat', _IBAN)
        else
            Error('%1 nu este valid', _IBAN);
    end;

    local procedure ValidateIBAN(_IBAN: Code[50]): Boolean
    var
        TextIban: Text;
        TextIbanDec: Text;
        IntVal: Integer;
        BigIntVal: BigInteger;
    begin
        //https://en.wikipedia.org/wiki/International_Bank_Account_Number#Validating_the_IBAN
        _IBAN := DelChr(_IBAN, '=', ' ');
        TextIban := CopyStr(_IBAN, 5) + CopyStr(_IBAN, 1, 4);

        Clear(TextIbanDec);
        while StrLen(TextIban) <> 0 do begin
            if not Evaluate(IntVal, CopyStr(TextIban, 1, 1)) then begin
                Evaluate(IntVal, Format(TextIban[1], 0, '<Number>'));
                TextIbanDec += Format(IntVal - 55);
            end else
                TextIbanDec += CopyStr(TextIban, 1, 1);

            TextIban := CopyStr(TextIban, 2);
        end;

        while StrLen(CopyStr(TextIbanDec, 10)) > 0 do begin
            Evaluate(BigIntVal, CopyStr(TextIbanDec, 1, 9));
            TextIbanDec := Format(BigIntVal mod 97) + CopyStr(TextIbanDec, 10);
            //TextIbanDec := ;
        end;

        Evaluate(BigIntVal, TextIbanDec);
        if BigIntVal mod 97 <> 1 then
            exit(false);
        exit(true);
    end;
}

