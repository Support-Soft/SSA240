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
        zec := x MOD 100;
        x := (x - (x MOD 100)) / 100;
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

        IF (x >= 1000000) THEN BEGIN
            i := (x - (x MOD 1000000)) / 1000000;
            c := c + cifre[i];
            IF (i = 1) THEN
                c := c + ' milion'
            ELSE
                c := c + ' milioane';
            IF (((x - (x MOD 100000)) / 100000) MOD 100 = 0) THEN
                c := c + ' de mii';
            IF (((x - (x MOD 100000)) / 100000) MOD 10 = 1) THEN BEGIN
                ok := 0;
                c := c + ' unu';
            END;
            x := x MOD 1000000;
        END;

        IF (x >= 100000) THEN BEGIN
            i := (x - (x MOD 100000)) / 100000;
            c := c + cifre[i];
            IF (i = 1) THEN
                c := c + ' suta'
            ELSE
                c := c + ' sute';
            IF (((x - (x MOD 1000)) / 1000) MOD 100 = 0) THEN
                c := c + ' de mii';
            IF (((x - (x MOD 10000)) / 10000) MOD 10 = 1) THEN BEGIN
                ok := 0;
                c := c + ' unu';
            END;
            x := x MOD 100000;
        END;

        IF (x >= 10000) THEN BEGIN
            i := (x - (x MOD 10000)) / 10000;
            IF (i <> 1) THEN BEGIN
                c := c + cifre[i];
                c := c + 'zeci';
                x := x MOD 10000;
                IF (x >= 1000) THEN BEGIN
                    c := c + ' si';
                    IF ((x - (x MOD 1000)) / 1000 = 1) THEN
                        c := c + ' una'
                    ELSE
                        c := c + cifre[(x - (x MOD 1000)) / 1000];
                END;
                c := c + ' de mii';
            END
            ELSE BEGIN
                i := (x - (x MOD 1000)) / 1000;
                c := c + cifre[i];
                c := c + ' mii';
            END;
            x := x MOD 1000;
        END;

        IF (x >= 1000) THEN BEGIN
            i := (x - (x MOD 1000)) / 1000;
            IF (i = 1) THEN
                IF (ok = 1) THEN
                    c := c + ' o mie'
                ELSE BEGIN
                    c := c + ' mii';
                END
            ELSE BEGIN
                c := c + cifre[i];
                c := c + ' mii';
            END;
            x := x MOD 1000;
        END;

        IF (x >= 100) THEN BEGIN
            i := (x - (x MOD 100)) / 100;
            c := c + cifre[i];
            IF (i = 1) THEN
                c := c + ' suta'
            ELSE
                c := c + ' sute';
            x := x MOD 100;
        END;

        IF (x >= 20) THEN BEGIN
            i := (x - (x MOD 10)) / 10;
            c := c + cifre[i];
            c := c + 'zeci';
            x := x MOD 10;
            IF (x <> 0) THEN BEGIN
                c := c + ' si';
                IF (x = 1) THEN
                    c := c + ' unu'
                ELSE
                    IF (x = 2) THEN
                        c := c + ' doi'
                    ELSE
                        c := c + cifre[x];
            END;
        END

        ELSE BEGIN
            IF (x = 1) THEN
                c := c + ' unu'
            ELSE
                IF (x = 2) THEN
                    c := c + ' doi'
                ELSE
                    IF (x <> 0) THEN
                        c := c + cifre[x];
        END;

        c := c + ' lei';
        IF (zec > 0) THEN BEGIN
            c := c + ' si ';

            IF (zec >= 20) THEN BEGIN
                i := (zec - (zec MOD 10)) / 10;
                c := c + cifre[i];
                c := c + 'zeci';
                zec := zec MOD 10;
                IF (zec <> 0) THEN BEGIN
                    c := c + ' si';
                    IF (zec = 1) THEN
                        c := c + ' unu'
                    ELSE
                        IF (zec = 2) THEN
                            c := c + ' doi'
                        ELSE
                            c := c + cifre[zec];
                END;
            END

            ELSE BEGIN
                IF (zec = 1) THEN
                    c := c + ' unu'
                ELSE
                    IF (zec = 2) THEN
                        c := c + ' doi'
                    ELSE
                        IF (zec <> 0) THEN
                            c := c + cifre[zec];
            END;
            c := c + ' bani';
        END;
        EXIT(c);
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

        EXIT(finalString);

    end;

    local procedure Replacechr(TotalString: Text; FromChr: Text; WithChr: Text): Text
    var
        poz: Integer;
        remainingstr: text;
        finalString: text;
    begin
        finalString := TotalString;
        remainingstr := TotalString;
        WHILE (STRPOS(remainingstr, FromChr) <> 0) DO BEGIN
            poz := STRPOS(finalString, FromChr);
            finalString := DELSTR(finalString, poz, STRLEN(FromChr));
            remainingstr := COPYSTR(finalString, poz + 1, STRLEN(finalString) - poz + 1);
            finalString := INSSTR(finalString, WithChr, poz);
        END;
        EXIT(finalString);
    end;

    local procedure ReplacechrASCII(InputStr: Text; FromChr: Char; WithChr: Char): Text
    var
        OutputString: text;
        i: Integer;
    begin
        i := 1;
        WHILE i <= STRLEN(InputStr) DO BEGIN
            IF InputStr[i] = FromChr THEN
                OutputString[i] := WithChr
            ELSE BEGIN
                OutputString[i] := InputStr[i];
            END;
            i += 1
        END;
        EXIT(OutputString);
    end;
}