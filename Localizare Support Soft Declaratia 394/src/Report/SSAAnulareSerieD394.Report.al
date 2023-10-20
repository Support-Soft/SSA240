report 71700 "SSA Anulare Serie D394"
{
    // SSA973 SSCAT 06.09.2019 39.Rapoarte legale- Localizare Declaratia 394
    ProcessingOnly = true;
    ApplicationArea = All;
    dataset
    {
    }

    requestpage
    {
        layout
        {
            area(content)
            {
                group(Control2)
                {
                    ShowCaption = false;
                    field("Cod Declaratie interna"; CurrentDeclarationNo)
                    {
                        Caption = 'Domestic Declaration Code';
                        TableRelation = "SSA Domestic Declaration";
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the Domestic Declaration Code field.';
                    }
                    field(NoSeriesCode; NoSeriesCode)
                    {
                        Caption = 'No Series Code';
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the No Series Code field.';
                        trigger OnLookup(var Text: Text): Boolean
                        var
                            NoSeriesLine: Record "No. Series Line";
                            FNoSeriesLines: Page "No. Series Lines";
                        begin

                            Clear(FNoSeriesLines);
                            FNoSeriesLines.LookupMode(true);

                            if FNoSeriesLines.RunModal = ACTION::LookupOK then begin
                                FNoSeriesLines.GetRecord(NoSeriesLine);
                                NoSeriesCode := NoSeriesLine."Series Code";
                                NoSeriesLineNo := NoSeriesLine."Line No.";
                            end;
                        end;
                    }
                    field("Tip Operatie"; TipOperatie)
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the TipOperatie field.';
                    }
                    field("Procent TVA"; VATPercent)
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the VATPercent field.';
                    }
                    field("Nr. Client"; CustomerNo)
                    {
                        TableRelation = Customer;
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the CustomerNo field.';
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnInit()
        begin

            TipOperatie := TipOperatie::L;
            VATPercent := 20;
            OldTimestamp := Time;
        end;
    }

    labels
    {
    }

    trigger OnPreReport()
    begin

        w.Open('Anulare Document... #1##########');
        AnulareSerie;

        w.Close
    end;

    var
        DomesticDeclarations: Record "SSA Domestic Declaration";
        CurrentDeclarationNo: Code[20];
        NoSeriesCode: Code[20];
        NoSeriesLineNo: Integer;
        TipOperatie: Option " ",L,LS,A,AI,AS,ASI,V,C,N;
        VATPercent: Decimal;
        CustomerNo: Code[20];
        w: Dialog;
        OldTimestamp: Time;
        isTime: Boolean;
        Text010: Label 'The number %1 cannot be extended to more than 20 characters.';

    local
    procedure AnulareSerie()
    var
        DomesticDeclarationLine: Record "SSA Domestic Declaration Line";
        NoSeriesLine: Record "No. Series Line";
        LineNo: Integer;
    begin

        DomesticDeclarations.Get(CurrentDeclarationNo);
        DomesticDeclarationLine.SetRange(DomesticDeclarationLine."Domestic Declaration Code", CurrentDeclarationNo);
        if DomesticDeclarationLine.FindLast then
            LineNo := DomesticDeclarationLine."Line No."
        else
            LineNo := 0;

        NoSeriesLine.Get(NoSeriesCode, NoSeriesLineNo);
        while (NoSeriesLine."Last No. Used" < NoSeriesLine."Ending No.") do begin
            if NoSeriesLine."Last No. Used" = '' then begin
                NoSeriesLine.TestField("Starting No.");
                NoSeriesLine."Last No. Used" := NoSeriesLine."Starting No.";
            end else
                if NoSeriesLine."Increment-by No." <= 1 then
                    NoSeriesLine."Last No. Used" := IncStr(NoSeriesLine."Last No. Used")
                else
                    IncrementNoText(NoSeriesLine."Last No. Used", NoSeriesLine."Increment-by No.");

            LineNo += 10000;
            InsertDecLine(CurrentDeclarationNo, LineNo, NoSeriesLine."Series Code", NoSeriesLine."Last No. Used");

            isTime := (Time - OldTimestamp) > 1000;
            if isTime then begin
                w.Update(1, NoSeriesLine."Last No. Used");
                OldTimestamp := Time;
            end;
        end;

        NoSeriesLine.Modify(true);
    end;

    local
    procedure InsertDecLine(_CurrDeclNo: Code[20]; _LineNo: Integer; _NoSeriesCode: Code[20]; _DocNo: Code[20])
    var
        DecLine: Record "SSA Domestic Declaration Line";
        Customer: Record Customer;
    begin

        DecLine.Init;
        DecLine."Domestic Declaration Code" := _CurrDeclNo;
        DecLine."Line No." := _LineNo;
        DecLine.Insert;

        DecLine.Validate(Type, DecLine.Type::Sale);
        DecLine.Validate("Document No.", _DocNo);
        DecLine.Validate("Document Date", DomesticDeclarations."Ending Date");
        DecLine.Validate("Document Type", DecLine."Document Type"::Invoice);
        DecLine.Validate("Tip Document D394", DecLine."Tip Document D394"::"Factura Fiscala");
        DecLine.Validate("Stare Factura", DecLine."Stare Factura"::"2-Factura Anulata");
        DecLine.Validate("Cod Serie Factura", _NoSeriesCode);
        DecLine.Validate("Tip Operatie", TipOperatie);
        DecLine.Validate("Posting Date", DomesticDeclarations."Ending Date");
        DecLine.Validate(Cota, VATPercent);
        Customer.Get(CustomerNo);
        DecLine.Validate("Bill-to/Pay-to No.", Customer."No.");
        DecLine.Validate("Organization type", Customer."SSA Organization type");
        DecLine.Validate("Tip Partener", Customer."SSA Tip Partener");
        DecLine.Validate("Cod tara D394", Customer."Country/Region Code");
        DecLine.Validate("Cod Judet D394", Customer."SSA Cod Judet D394");

        DecLine.Modify;
    end;

    local procedure IncrementNoText(var No: Code[20]; IncrementByNo: Decimal)
    var
        DecimalNo: Decimal;
        StartPos: Integer;
        EndPos: Integer;
        NewNo: Text[30];
    begin
        GetIntegerPos(No, StartPos, EndPos);
        Evaluate(DecimalNo, CopyStr(No, StartPos, EndPos - StartPos + 1));
        NewNo := Format(DecimalNo + IncrementByNo, 0, 1);
        ReplaceNoText(No, NewNo, 0, StartPos, EndPos);
    end;

    local procedure GetIntegerPos(No: Code[20]; var StartPos: Integer; var EndPos: Integer)
    var
        IsDigit: Boolean;
        i: Integer;
    begin
        StartPos := 0;
        EndPos := 0;
        if No <> '' then begin
            i := StrLen(No);
            repeat
                IsDigit := No[i] in ['0' .. '9'];
                if IsDigit then begin
                    if EndPos = 0 then
                        EndPos := i;
                    StartPos := i;
                end;
                i := i - 1;
            until (i = 0) or (StartPos <> 0) and not IsDigit;
        end;
    end;

    local procedure ReplaceNoText(var No: Code[20]; NewNo: Code[20]; FixedLength: Integer; StartPos: Integer; EndPos: Integer)
    var
        StartNo: Code[20];
        EndNo: Code[20];
        ZeroNo: Code[20];
        NewLength: Integer;
        OldLength: Integer;
    begin
        if StartPos > 1 then
            StartNo := CopyStr(No, 1, StartPos - 1);
        if EndPos < StrLen(No) then
            EndNo := CopyStr(No, EndPos + 1);
        NewLength := StrLen(NewNo);
        OldLength := EndPos - StartPos + 1;
        if FixedLength > OldLength then
            OldLength := FixedLength;
        if OldLength > NewLength then
            ZeroNo := PadStr('', OldLength - NewLength, '0');
        if StrLen(StartNo) + StrLen(ZeroNo) + StrLen(NewNo) + StrLen(EndNo) > 20 then
            Error(
              Text010,
              No);
        No := StartNo + ZeroNo + NewNo + EndNo;
    end;
}
