report 70008 "SSA Generare cor 6D 7C"
{
    // SSA940 SSCAT 26.09.2019 6.Funct. corectii rulaje clasa 7-6
    Caption = 'Corectie Rulaje Clasa 6 Clasa 7';
    ProcessingOnly = true;
    UsageCategory = Tasks;
    ApplicationArea = All;

    dataset
    {
        dataitem("G/L Account"; "G/L Account")
        {
            DataItemTableView = sorting("No.") where("SSA Check Posting Debit/Credit" = const(true));
            RequestFilterFields = "No.", "Date Filter";
            dataitem("G/L Entry"; "G/L Entry")
            {
                DataItemLink = "G/L Account No." = field("No."), "Posting Date" = field("Date Filter");
                DataItemTableView = sorting("G/L Account No.", "Posting Date");

                trigger OnAfterGetRecord()
                var
                    ok: Boolean;
                    i: Integer;
                begin
                    ok := false;
                    if (("G/L Account"."Debit/Credit" = "G/L Account"."Debit/Credit"::Debit) and
                       ("G/L Entry"."Credit Amount" <> 0)) or
                       (("G/L Account"."Debit/Credit" = "G/L Account"."Debit/Credit"::Credit) and ("G/L Entry"."Debit Amount" <> 0))
                    then begin
                        if nr <> 0 then begin
                            for i := 1 to nr do begin
                                if (Cont[i] = "G/L Entry"."G/L Account No.") and
                                   (DimSetID[i] = "G/L Entry"."Dimension Set ID")
                                then begin
                                    debit[i] += "G/L Entry"."Debit Amount";
                                    ;
                                    credit[i] += "G/L Entry"."Credit Amount";
                                    ok := true;
                                end;
                            end;
                            if not ok then begin
                                nr += 1;
                                Cont[nr] := "G/L Entry"."G/L Account No.";
                                GlobalDim[nr] [1] := "G/L Entry"."Global Dimension 1 Code";
                                GlobalDim[nr] [2] := "G/L Entry"."Global Dimension 2 Code";
                                DimSetID[nr] := "G/L Entry"."Dimension Set ID";
                                debit[nr] := "G/L Entry"."Debit Amount";
                                credit[nr] := "G/L Entry"."Credit Amount";
                            end;
                        end else begin
                            nr += 1;
                            Cont[nr] := "G/L Entry"."G/L Account No.";
                            GlobalDim[nr] [1] := "G/L Entry"."Global Dimension 1 Code";
                            GlobalDim[nr] [2] := "G/L Entry"."Global Dimension 2 Code";
                            DimSetID[nr] := "G/L Entry"."Dimension Set ID";
                            debit[nr] := "G/L Entry"."Debit Amount";
                            credit[nr] := "G/L Entry"."Credit Amount";
                        end;
                    end;
                end;
            }
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group(Parameter)
                {
                    field(Template; Template)
                    {
                        TableRelation = "Gen. Journal Template";
                        ApplicationArea = All;
                    }
                    field(Lot; Batch)
                    {
                        TableRelation = "Gen. Journal Batch".Name;
                        ApplicationArea = All;

                        trigger OnLookup(var Text: Text): Boolean
                        var
                            GenJnlTemplate: Record "Gen. Journal Template";
                            GenJnlBatch: Record "Gen. Journal Batch";
                        begin

                            GenJnlTemplate.Get(Template);
                            GenJnlBatch.SetRange("Journal Template Name", Template);
                            if PAGE.RunModal(0, GenJnlBatch) = ACTION::LookupOK then begin
                                Batch := GenJnlBatch.Name;
                            end;
                        end;
                    }
                    field("Data inregistrare"; postingDate)
                    {
                        ApplicationArea = All;
                    }
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnPostReport()
    var
        GenJnlLine: Record "Gen. Journal Line";
        nextLine: Integer;
        i: Integer;
    begin

        GenJnlLine.SetRange(GenJnlLine."Journal Template Name", Template);
        GenJnlLine.SetRange(GenJnlLine."Journal Batch Name", Batch);
        if GenJnlLine.FindLast then
            nextLine := GenJnlLine."Line No.";
        if nr <> 0 then
            for i := 1 to nr do begin
                if not ((debit[i] = 0) and (credit[i] = 0)) then begin
                    GenJnlLine.Init;
                    GenJnlLine."Journal Template Name" := Template;
                    GenJnlLine."Journal Batch Name" := Batch;
                    nextLine += 10000;
                    GenJnlLine."Line No." := nextLine;
                    GenJnlLine.Validate("Account Type", GenJnlLine."Account Type"::"G/L Account");
                    GenJnlLine.Validate("Account No.", Cont[i]);
                    GenJnlLine.Validate("Bal. Account Type", GenJnlLine."Bal. Account Type"::"G/L Account");
                    GenJnlLine.Validate("Bal. Account No.", Cont[i]);
                    GenJnlLine.Validate("Posting Date", postingDate);
                    GenJnlLine."Document No." := 'CORECTIE RULAJ';
                    if debit[i] <> 0 then
                        GenJnlLine.Validate("Debit Amount", -debit[i]);
                    if credit[i] <> 0 then
                        GenJnlLine.Validate("Credit Amount", -credit[i]);
                    GenJnlLine.Insert;

                    if GlobalDim[i] [1] <> '' then
                        GenJnlLine.Validate("Shortcut Dimension 1 Code", GlobalDim[i] [1]);
                    if GlobalDim[i] [2] <> '' then
                        GenJnlLine.Validate("Shortcut Dimension 2 Code", GlobalDim[i] [2]);
                    GenJnlLine.Validate("Dimension Set ID", DimSetID[i]);
                    GenJnlLine.Modify;
                end;
            end;
        Message('corectii rulaje generate. Trebuie inregistrate');
    end;

    trigger OnPreReport()
    begin
        GLSetup.Get;
        filtrudata := "G/L Account".GetFilter("Date Filter");
        if filtrudata = '' then
            Error('Nu ati specificat perioada');
    end;

    var
        Cont: array[2000] of Code[20];
        debit: array[2000] of Decimal;
        credit: array[2000] of Decimal;
        nr: Integer;
        Template: Code[20];
        Batch: Code[20];
        postingDate: Date;
        GLSetup: Record "General Ledger Setup";
        filtrudata: Text;
        DimSetID: array[2000] of Integer;
        GlobalDim: array[2000, 2] of Code[20];
}

