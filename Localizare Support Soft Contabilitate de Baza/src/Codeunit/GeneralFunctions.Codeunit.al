codeunit 70010 "SSA General Functions"
{
    trigger OnRun()
    begin

    end;

    procedure FormatNumberToText(_Number: Decimal): Text
    var
        x: BigInteger;
        c: Text;
        Cifre: array[25] of Text;
        i: Integer;
        Zec: Integer;
        OK: Integer;
    begin
        EVALUATE(x, DelChr(FORMAT(_Number * 100), '=', '.,'));
        zec := x mod 100;
        x := (x - (x mod 100)) / 100;
        cifre[20] := ' doi';
        cifre[1] := ' o';
        cifre[2] := ' doua';
        cifre[3] := ' trei';
        cifre[4] := ' patru';
        cifre[5] := ' cinci';
        cifre[6] := ' sase';
        cifre[7] := ' sapte';
        cifre[8] := ' opt';
        cifre[9] := ' noua';
        cifre[10] := ' zece';
        cifre[11] := ' unsprezece';
        cifre[12] := ' doisprezece';
        cifre[13] := ' treisprezece';
        cifre[14] := ' paisprezece';
        cifre[15] := ' cincisprezece';
        cifre[16] := ' saisprezece';
        cifre[17] := 'saptesprezece';
        cifre[18] := 'optsprezece';
        cifre[19] := 'nouasprezece';

        ok := 1;

        if (x >= 1000000) then begin
            i := (x - (x mod 1000000)) / 1000000;
            c := c + cifre[i];
            if (i = 1) then
                c := c + ' milion'
            else
                c := c + ' milioane';
            if (((x - (x mod 100000)) / 100000) mod 100 = 0) then
                c := c + ' de mii';
            if (((x - (x mod 100000)) / 100000) mod 10 = 1) then begin
                ok := 0;
                c := c + ' unu';
            end;
            x := x mod 1000000;
        end;

        if (x >= 100000) then begin
            i := (x - (x mod 100000)) / 100000;
            c := c + cifre[i];
            if (i = 1) then
                c := c + ' suta'
            else
                c := c + ' sute';
            if (((x - (x mod 1000)) / 1000) mod 100 = 0) then
                c := c + ' de mii';
            if (((x - (x mod 10000)) / 10000) mod 10 = 1) then begin
                ok := 0;
                c := c + ' unu';
            end;
            x := x mod 100000;
        end;

        if (x >= 10000) then begin
            i := (x - (x mod 10000)) / 10000;
            if (i <> 1) then begin
                c := c + cifre[i];
                c := c + 'zeci';
                x := x mod 10000;
                if (x >= 1000) then begin
                    c := c + ' si';
                    if ((x - (x mod 1000)) / 1000 = 1) then
                        c := c + ' una'
                    else
                        c := c + cifre[(x - (x mod 1000)) / 1000];
                end;
                c := c + ' de mii';
            end
            else begin
                i := (x - (x mod 1000)) / 1000;
                c := c + cifre[i];
                c := c + ' mii';
            end;
            x := x mod 1000;
        end;

        if (x >= 1000) then begin
            i := (x - (x mod 1000)) / 1000;
            if (i = 1) then
                if (ok = 1) then
                    c := c + ' o mie'
                else begin
                    c := c + ' mii';
                end
            else begin
                c := c + cifre[i];
                c := c + ' mii';
            end;
            x := x mod 1000;
        end;

        if (x >= 100) then begin
            i := (x - (x mod 100)) / 100;
            c := c + cifre[i];
            if (i = 1) then
                c := c + ' suta'
            else
                c := c + ' sute';
            x := x mod 100;
        end;

        if (x >= 20) then begin
            i := (x - (x mod 10)) / 10;
            c := c + cifre[i];
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
                        c := c + cifre[x];
            end;
        end

        else begin
            if (x = 1) then
                c := c + ' unu'
            else
                if (x = 2) then
                    c := c + ' doi'
                else
                    if (x <> 0) then
                        c := c + cifre[x];
        end;

        c := c + ' lei';
        if (zec > 0) then begin
            c := c + ' si ';

            if (zec >= 20) then begin
                i := (zec - (zec mod 10)) / 10;
                c := c + cifre[i];
                c := c + 'zeci';
                zec := zec mod 10;
                if (zec <> 0) then begin
                    c := c + ' si';
                    if (zec = 1) then
                        c := c + ' unu'
                    else
                        if (zec = 2) then
                            c := c + ' doi'
                        else
                            c := c + cifre[zec];
                end;
            end

            else begin
                if (zec = 1) then
                    c := c + ' unu'
                else
                    if (zec = 2) then
                        c := c + ' doi'
                    else
                        if (zec <> 0) then
                            c := c + cifre[zec];
            end;
            c := c + ' bani';
        end;
        exit(c);
    end;

    procedure ReplaceDiacriticeCHR(TotalString: Text): Text;
    var
        finalString: text;
        spatiudublu: label '  ';
        spatiusimplu: label ' ';
        altch: label ' ';
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
        remainingstr: text;
        finalString: text;
    begin
        finalString := TotalString;
        remainingstr := TotalString;
        while (STRPOS(remainingstr, FromChr) <> 0) do begin
            poz := STRPOS(finalString, FromChr);
            finalString := DELSTR(finalString, poz, STRLEN(FromChr));
            remainingstr := COPYSTR(finalString, poz + 1, STRLEN(finalString) - poz + 1);
            finalString := INSSTR(finalString, WithChr, poz);
        end;
        exit(finalString);
    end;

    local procedure ReplacechrASCII(InputStr: Text; FromChr: Char; WithChr: Char): Text
    var
        OutputString: text;
        i: Integer;
    begin
        i := 1;
        while i <= STRLEN(InputStr) do begin
            if InputStr[i] = FromChr then
                OutputString[i] := WithChr
            else begin
                OutputString[i] := InputStr[i];
            end;
            i += 1
        end;
        exit(OutputString);
    end;

    procedure ConvertTextToDecimal(_Text: Text): Decimal
    var
        i: Integer;
        c: Text;
        ThousandSeparator: Text;
        DecimalSeparator: Text;
        DecVar: Decimal;
    begin

        ThousandSeparator := COPYSTR(FORMAT(1000.01, 0, 0), 2, 1);
        DecimalSeparator := COPYSTR(FORMAT(1000.01, 0, 0), 6, 1);
        IF DecimalSeparator = '.' THEN begin
            Evaluate(DecVar, _Text);
            EXIT(DecVar);
        end ELSE BEGIN
            FOR i := 1 TO STRLEN(_Text) DO BEGIN
                c := COPYSTR(_Text, i, 1);
                IF c = ThousandSeparator THEN
                    _Text := _Text + DecimalSeparator;
                IF c = DecimalSeparator THEN
                    _Text := _Text + ThousandSeparator;
                IF (c <> ThousandSeparator) AND (c <> DecimalSeparator) THEN
                    _Text := _Text + c;
            END;
            Evaluate(DecVar, _Text);
            EXIT(DecVar);
        END;
    end;
}