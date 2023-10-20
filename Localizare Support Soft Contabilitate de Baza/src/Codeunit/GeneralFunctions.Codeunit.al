codeunit 70010 "SSA General Functions"
{


    procedure FormatNumberToText(_Number: Decimal): Text
    var
        x: BigInteger;
        c: Text;
        Cifre: array[25] of Text;
        i: Integer;
        Zec: Integer;
        OK: Integer;
    begin
        Evaluate(x, DelChr(Format(_Number * 100), '=', '.,'));
        Zec := x mod 100;
        x := (x - (x mod 100)) / 100;
        Cifre[20] := ' doi';
        Cifre[1] := ' o';
        Cifre[2] := ' doua';
        Cifre[3] := ' trei';
        Cifre[4] := ' patru';
        Cifre[5] := ' cinci';
        Cifre[6] := ' sase';
        Cifre[7] := ' sapte';
        Cifre[8] := ' opt';
        Cifre[9] := ' noua';
        Cifre[10] := ' zece';
        Cifre[11] := ' unsprezece';
        Cifre[12] := ' doisprezece';
        Cifre[13] := ' treisprezece';
        Cifre[14] := ' paisprezece';
        Cifre[15] := ' cincisprezece';
        Cifre[16] := ' saisprezece';
        Cifre[17] := 'saptesprezece';
        Cifre[18] := 'optsprezece';
        Cifre[19] := 'nouasprezece';

        OK := 1;

        if (x >= 1000000) then begin
            i := (x - (x mod 1000000)) / 1000000;
            c := c + Cifre[i];
            if (i = 1) then
                c := c + ' milion'
            else
                c := c + ' milioane';
            if (((x - (x mod 100000)) / 100000) mod 100 = 0) then
                c := c + ' de mii';
            if (((x - (x mod 100000)) / 100000) mod 10 = 1) then begin
                OK := 0;
                c := c + ' unu';
            end;
            x := x mod 1000000;
        end;

        if (x >= 100000) then begin
            i := (x - (x mod 100000)) / 100000;
            c := c + Cifre[i];
            if (i = 1) then
                c := c + ' suta'
            else
                c := c + ' sute';
            if (((x - (x mod 1000)) / 1000) mod 100 = 0) then
                c := c + ' de mii';
            if (((x - (x mod 10000)) / 10000) mod 10 = 1) then begin
                OK := 0;
                c := c + ' unu';
            end;
            x := x mod 100000;
        end;

        if (x >= 10000) then begin
            i := (x - (x mod 10000)) / 10000;
            if (i <> 1) then begin
                c := c + Cifre[i];
                c := c + 'zeci';
                x := x mod 10000;
                if (x >= 1000) then begin
                    c := c + ' si';
                    if ((x - (x mod 1000)) / 1000 = 1) then
                        c := c + ' una'
                    else
                        c := c + Cifre[(x - (x mod 1000)) / 1000];
                end;
                c := c + ' de mii';
            end
            else begin
                i := (x - (x mod 1000)) / 1000;
                c := c + Cifre[i];
                c := c + ' mii';
            end;
            x := x mod 1000;
        end;

        if (x >= 1000) then begin
            i := (x - (x mod 1000)) / 1000;
            if (i = 1) then
                if (OK = 1) then
                    c := c + ' o mie'
                else begin
                    c := c + ' mii';
                end
            else begin
                c := c + Cifre[i];
                c := c + ' mii';
            end;
            x := x mod 1000;
        end;

        if (x >= 100) then begin
            i := (x - (x mod 100)) / 100;
            c := c + Cifre[i];
            if (i = 1) then
                c := c + ' suta'
            else
                c := c + ' sute';
            x := x mod 100;
        end;

        if (x >= 20) then begin
            i := (x - (x mod 10)) / 10;
            c := c + Cifre[i];
            c := c + 'zeci';
            x := x mod 10;
            if (x <> 0) then begin
                c := c + ' si';
                if (x = 1) then
                    c := c + ' unu'
                else
                    if (x = 2) then
                        c := c + ' doi'
                    else
                        c := c + Cifre[x];
            end;
        end

        else
            if (x = 1) then
                c := c + ' unu'
            else
                if (x = 2) then
                    c := c + ' doi'
                else
                    if (x <> 0) then
                        c := c + Cifre[x];

        c := c + ' lei';
        if (Zec > 0) then begin
            c := c + ' si ';

            if (Zec >= 20) then begin
                i := (Zec - (Zec mod 10)) / 10;
                c := c + Cifre[i];
                c := c + 'zeci';
                Zec := Zec mod 10;
                if (Zec <> 0) then begin
                    c := c + ' si';
                    if (Zec = 1) then
                        c := c + ' unu'
                    else
                        if (Zec = 2) then
                            c := c + ' doi'
                        else
                            c := c + Cifre[Zec];
                end;
            end

            else
                if (Zec = 1) then
                    c := c + ' unu'
                else
                    if (Zec = 2) then
                        c := c + ' doi'
                    else
                        if (Zec <> 0) then
                            c := c + Cifre[Zec];
            c := c + ' bani';
        end;
        exit(c);
    end;

    procedure ReplaceDiacriticeCHR(TotalString: Text): Text;
    var
        finalString: Text;
        spatiudublu: Label '  ';
        spatiusimplu: Label ' ';
        altch: Label ' ';
    begin

        finalString := TotalString;
        finalString := Replacechr(finalString, spatiudublu, spatiusimplu);
        finalString := Replacechr(finalString, altch, spatiusimplu);
        finalString := Replacechr(finalString, 'ă', 'a');
        finalString := Replacechr(finalString, 'â', 'a');
        finalString := Replacechr(finalString, 'ş', 's');
        finalString := Replacechr(finalString, 'ţ', 't');
        finalString := Replacechr(finalString, 'î', 'i');
        finalString := Replacechr(finalString, 'Ă', 'A');
        finalString := Replacechr(finalString, 'Â', 'A');
        finalString := Replacechr(finalString, 'Ş', 'S');
        finalString := Replacechr(finalString, 'Î', 'I');
        finalString := Replacechr(finalString, '®', '(R)');
        finalString := Replacechr(finalString, '™', '(TM)');
        finalString := Replacechr(finalString, '™', '(TM)');
        finalString := Replacechr(finalString, '°', ' ');
        finalString := Replacechr(finalString, '±', '+');
        finalString := Replacechr(finalString, '×', 'x');
        finalString := Replacechr(finalString, '¦', 's');
        finalString := Replacechr(finalString, '–', '-');
        finalString := Replacechr(finalString, '—', '-');
        finalString := Replacechr(finalString, '•', '-');

        finalString := ReplacechrASCII(finalString, 536, 83); //S
        finalString := ReplacechrASCII(finalString, 538, 'T');

        finalString := ReplacechrASCII(finalString, 258, 'A');
        finalString := ReplacechrASCII(finalString, 194, 'A');
        finalString := ReplacechrASCII(finalString, 206, 'I');
        finalString := ReplacechrASCII(finalString, 536, 'S');
        finalString := ReplacechrASCII(finalString, 538, 'T');
        finalString := ReplacechrASCII(finalString, 354, 'T');
        finalString := ReplacechrASCII(finalString, 355, 't');
        finalString := ReplacechrASCII(finalString, 199, 'C');
        finalString := ReplacechrASCII(finalString, 350, 'S');
        finalString := ReplacechrASCII(finalString, 209, 'N');
        finalString := ReplacechrASCII(finalString, 195, 'A');
        finalString := ReplacechrASCII(finalString, 268, 'C');
        finalString := ReplacechrASCII(finalString, 352, 'S');
        finalString := ReplacechrASCII(finalString, 196, 'A');
        finalString := ReplacechrASCII(finalString, 214, 'O');
        finalString := ReplacechrASCII(finalString, 200, 'E');
        finalString := ReplacechrASCII(finalString, 210, 'O');
        finalString := ReplacechrASCII(finalString, 211, 'O');
        finalString := ReplacechrASCII(finalString, 336, 'O');
        finalString := ReplacechrASCII(finalString, 201, 'E');
        finalString := ReplacechrASCII(finalString, 193, 'A');
        finalString := ReplacechrASCII(finalString, 259, 'a');
        finalString := ReplacechrASCII(finalString, 226, 'a');
        finalString := ReplacechrASCII(finalString, 238, 'i');
        finalString := ReplacechrASCII(finalString, 537, 's');
        finalString := ReplacechrASCII(finalString, 539, 't');
        finalString := ReplacechrASCII(finalString, 231, 'c');
        finalString := ReplacechrASCII(finalString, 351, 's');
        finalString := ReplacechrASCII(finalString, 241, 'n');
        finalString := ReplacechrASCII(finalString, 227, 'a');
        finalString := ReplacechrASCII(finalString, 269, 'c');
        finalString := ReplacechrASCII(finalString, 353, 's');
        finalString := ReplacechrASCII(finalString, 228, 'a');
        finalString := ReplacechrASCII(finalString, 246, 'o');
        finalString := ReplacechrASCII(finalString, 232, 'e');
        finalString := ReplacechrASCII(finalString, 242, 'o');
        finalString := ReplacechrASCII(finalString, 233, 'e');
        finalString := ReplacechrASCII(finalString, 225, 'a');

        //Hungarian
        finalString := ReplacechrASCII(finalString, 205, 'I');
        finalString := ReplacechrASCII(finalString, 237, 'i');
        finalString := ReplacechrASCII(finalString, 243, 'o');
        finalString := ReplacechrASCII(finalString, 218, 'U');
        finalString := ReplacechrASCII(finalString, 250, 'u');
        finalString := ReplacechrASCII(finalString, 220, 'U');
        finalString := ReplacechrASCII(finalString, 252, 'u');
        finalString := ReplacechrASCII(finalString, 237, 'o');
        finalString := ReplacechrASCII(finalString, 368, 'U');
        finalString := ReplacechrASCII(finalString, 369, 'u');

        finalString := ReplacechrASCII(finalString, 323, 'O');
        finalString := ReplacechrASCII(finalString, 341, 'a');
        finalString := ReplacechrASCII(finalString, 355, 'i');
        finalString := ReplacechrASCII(finalString, 366, 'o');
        finalString := ReplacechrASCII(finalString, 363, 'o');
        finalString := ReplacechrASCII(finalString, 374, 'u');
        finalString := ReplacechrASCII(finalString, 372, 'u');
        finalString := ReplacechrASCII(finalString, 213, 'i');
        finalString := ReplacechrASCII(finalString, 197, 'o');
        finalString := ReplacechrASCII(finalString, 145, 'o');
        finalString := Replacechr(finalString, '‹', 'i');

        exit(finalString);
    end;

    local procedure Replacechr(TotalString: Text; FromChr: Text; WithChr: Text): Text
    var
        poz: Integer;
        remainingstr: Text;
        finalString: Text;
    begin
        finalString := TotalString;
        remainingstr := TotalString;
        while (StrPos(remainingstr, FromChr) <> 0) do begin
            poz := StrPos(finalString, FromChr);
            finalString := DelStr(finalString, poz, StrLen(FromChr));
            remainingstr := CopyStr(finalString, poz + 1, StrLen(finalString) - poz + 1);
            finalString := InsStr(finalString, WithChr, poz);
        end;
        exit(finalString);
    end;

    local procedure ReplacechrASCII(InputStr: Text; FromChr: Char; WithChr: Char): Text
    var
        OutputString: Text;
        i: Integer;
    begin
        i := 1;
        while i <= StrLen(InputStr) do begin
            if InputStr[i] = FromChr then
                OutputString[i] := WithChr
            else
                OutputString[i] := InputStr[i];
            i += 1
        end;
        exit(OutputString);
    end;

    procedure ConvertTextToDecimal(_TextNeformatat: Text): Decimal
    var
        i: Integer;
        c: Text;
        ThousandSeparator: Text;
        DecimalSeparator: Text;
        TextFormatat: Text;
        DecVar: Decimal;
    begin
        ThousandSeparator := CopyStr(Format(1000.01, 0, 0), 2, 1);
        DecimalSeparator := CopyStr(Format(1000.01, 0, 0), 6, 1);
        if DecimalSeparator = '.' then begin
            Evaluate(DecVar, _TextNeformatat);
            exit(DecVar);
        end
        else begin
            for i := 1 to StrLen(_TextNeformatat) do begin
                c := CopyStr(_TextNeformatat, i, 1);
                if c = ThousandSeparator then
                    TextFormatat := TextFormatat + DecimalSeparator;
                if c = DecimalSeparator then
                    TextFormatat := TextFormatat + ThousandSeparator;
                if (c <> ThousandSeparator) and (c <> DecimalSeparator) then
                    TextFormatat := TextFormatat + c;
            end;
            Evaluate(DecVar, TextFormatat);
            exit(DecVar);
        end;
    end;
}