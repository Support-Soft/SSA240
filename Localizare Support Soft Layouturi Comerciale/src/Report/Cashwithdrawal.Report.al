report 70903 "SSA Cash withdrawal."
{
    DefaultLayout = Word;
    Caption = 'Cash withdrawal';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = all;
    dataset
    {
        dataitem("G/L Register"; "G/L Register")
        {
            DataItemTableView = SORTING("No.");
            dataitem("Employee Ledger Entry"; "Employee Ledger Entry")
            {
                CalcFields = "Amount (LCY)";
                DataItemTableView = SORTING("Entry No.") WHERE("Document Type" = FILTER(" " | Payment | Refund));
                RequestFilterFields = "Document No.";
                column(Document_No_; "Document No.")
                {
                }
                column(PostingDate; PostingDate)
                {
                }
                column(Amount__LCY_; ABS("Amount (LCY)"))
                {
                }
                column(Posting_Date; "Posting Date")
                {
                }
                column(AmoutLCYTxt; AmountLCYTxt)
                {
                }
                column(Reprezentand; Reprezentand)
                {
                }
                column(EmployeeAddr1; EmployeeAddr[1])
                {
                }
                column(EmployeeAddr2; EmployeeAddr[2])
                {
                }
                column(EmployeeAddr3; EmployeeAddr[3])
                {
                }
                column(EmployeeAddr4; EmployeeAddr[4])
                {
                }
                column(CompanyAddr1; CompanyAddr[1])
                {
                }
                column(CompanyAddr2; CompanyAddr[2])
                {
                }
                column(CompanyAddr3; CompanyAddr[3])
                {
                }
                column(CompanyAddr4; CompanyAddr[4])
                {
                }
                column(CompanyAddr5; CompanyAddr[5])
                {
                }
                column(CompanyAddrRes1; CompanyAddrRes[1])
                {
                }
                column(CompanyAddrRes2; CompanyAddrRes[2])
                {
                }
                column(CompanyAddrRes3; CompanyAddrRes[3])
                {
                }
                column(CompanyAddrRes4; CompanyAddrRes[4])
                {
                }
                column(ComTradeNo; CompanyInfo."SSA Commerce Trade No.")
                {
                }
                column(VATRegNo; CompanyInfo."VAT Registration No.")
                {
                }
                column(CapitalStock; CompanyInfo."SSA Capital Stock")
                {
                }
                column(ComTradeNoCaption; ComTradeNoCaption)
                {
                }
                column(VATRegNoCaption; VATRegNoCaption)
                {
                }
                column(CapSocialCaption; CapSocialCaption)
                {
                }
                column(SedSocialCaption; SedSocialCaption)
                {
                }
                column(PunctLucruCaption; PunctLucruCaption)
                {
                }
                column(ChitNrCaption; ChitNrCaption)
                {
                }
                column(DataCaption; DataCaption)
                {
                }
                column(PrimitCaption; PrimitCaption)
                {
                }
                column(AdresaCaption; AdresaCaption)
                {
                }
                column(SumaCaption; SumaCaption)
                {
                }
                column(adicaCaption; adicaCaption)
                {
                }
                column(reprezCaption; reprezCaption)
                {
                }
                column(casierCaption; casierCaption)
                {
                }
                column(UnitateCpn; Unitate)
                {
                }
                column(DispozitieDeCpn; DispozitieDe)
                {
                }
                column(DinCpn; Din)
                {
                }
                column(NumeCpn; Nume)
                {
                }
                column(FunctieCpn; Functie)
                {
                }
                column(SumaCpn; suma)
                {
                }
                column(ScopulPlatiiCpn; ScopulPlatii)
                {
                }
                column(IncasatCpn; IncasatCpn)
                {
                }
                column(SumaDeCpn; SumaDe)
                {
                }
                column(DataCpn; Data)
                {
                }
                column(SemnaturaCpn; Semnatura)
                {
                }
                column(RONCpn; RON)
                {
                }
                column(PlatitCpn; PlatitCpn)
                {
                }
                column(ConducatorCpn; Conducator)
                {
                }
                column(VizaControlCpn; VizaControl)
                {
                }
                column(CompartimentCpn; Compartim)
                {
                }
                column(Incasat; Incasat)
                {
                }
                column(Platit; Platit)
                {
                }
                column(TipDispozitie; TipDispozitie)
                {
                }
                column(Employee_IDNo; Employee."SSA ID No.")
                {

                }
                column(Employee_IDSeries; Employee."SSA ID Series")
                {

                }
                column(Description; Description)
                {

                }
                column(Employee_JobTitle; Employee."Job Title")
                {

                }


                trigger OnAfterGetRecord()
                var
                    CreateEmployeeLedgEntry: Record "Employee Ledger Entry";
                    ELE: Record "Employee Ledger Entry";
                    GeneralFunc: Codeunit "SSA General Functions";
                begin
                    PostingDate := Format("Employee Ledger Entry"."Posting Date");
                    if Employee.Get("Employee Ledger Entry"."Employee No.") then begin
                        FormatAddr.Employee(EmployeeAddr, Employee);
                        //FzComTradeNo := Employee."SSA Commerce Trade No.";
                    end;
                    if "Amount (LCY)" > 0 then begin
                        TipDispozitie := 'PLATA';
                        Incasat := 'Incasat';
                        Platit := 'Platit';
                    end
                    else begin
                        TipDispozitie := 'INCASARE';
                        Incasat := 'Platit';
                        Platit := 'Incasat';
                    end;

                    if "Entry No." <> 0 then begin

                        CreateEmployeeLedgEntry := "Employee Ledger Entry";

                        FindApplnEntriesDtldtLedgEntry(ELE, CreateEmployeeLedgEntry); //
                        ELE.SetCurrentKey("Entry No.");
                        ELE.SetRange("Entry No.");

                        if CreateEmployeeLedgEntry."Closed by Entry No." <> 0 then begin
                            ELE."Entry No." := CreateEmployeeLedgEntry."Closed by Entry No.";
                            ELE.Mark(true);
                        end;

                        ELE.SetCurrentKey("Closed by Entry No.");
                        ELE.SetRange("Closed by Entry No.", CreateEmployeeLedgEntry."Entry No.");
                        if ELE.Find('-') then
                            repeat
                                ELE.Mark(true);
                            until ELE.Next = 0;

                        ELE.SetCurrentKey("Entry No.");
                        ELE.SetRange("Closed by Entry No.");
                    end;

                    ELE.MarkedOnly(true);

                    Clear(Reprezentand);

                    Reprezentand := 'Documentele:  ';

                    if ELE.FindFirst then
                        repeat
                            Reprezentand += ' ' + ELE."Document No." + '/' + Format(ELE."Posting Date") + ',';
                        until ELE.Next = 0;

                    AmountLCYTxt := GeneralFunc.FormatNumberToText(Abs("Amount (LCY)"))
                end;

                trigger OnPreDataItem()
                begin
                    if PaymentDoc <> '' then begin
                        "Employee Ledger Entry".SetRange("Document No.", PaymentDoc);
                    end else
                        SetRange("Entry No.", "G/L Register"."From Entry No.", "G/L Register"."To Entry No.");
                end;
            }

            trigger OnPreDataItem()
            begin
                //HD933>>
                if PaymentDoc <> '' then
                    SetRange("From Entry No.", 1);
                //HD933<<
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field("Nr document plata"; PaymentDoc)
                {
                    Caption = 'Nr document plata';

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        ELE: Record "Employee Ledger Entry";
                        ELEForm: Page "Employee Ledger Entries";
                    begin

                        ELE.SetFilter(ELE."Document Type", '%1|%2|%3', ELE."Document Type"::Payment, ELE."Document Type"::Refund, ELE."Document Type"::" ");
                        ELEForm.SetTableView(ELE);
                        ELEForm.LookupMode(true);
                        ELEForm.RunModal;

                        if ELEForm.LookupMode then begin
                            ELEForm.GetRecord(ELE);
                            PaymentDoc := ELE."Document No.";
                            PaymentDate := ELE."Posting Date";
                        end;
                        Clear(ELEForm);
                    end;
                }
                field("Data plata"; PaymentDate)
                {
                    Caption = 'Data plata';
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

    trigger OnPreReport()
    begin
        GLRegFilter := "G/L Register".GetFilters;
        CompanyInfo.Get;

        if RespCenter.Get(UserMgt.GetSalesFilter()) then begin
            FormatAddr.RespCenter(CompanyAddrRes, RespCenter);
            CompanyInfo."Phone No." := RespCenter."Phone No.";
            CompanyInfo."Fax No." := RespCenter."Fax No.";
        end;

        FormatAddr.Company(CompanyAddr, CompanyInfo);
    end;

    var
        GLRegFilter: Text[250];
        CompanyInfo: Record "Company Information";
        CompanyAddr: array[8] of Text[50];
        CompanyAddrRes: array[8] of Text[50];
        UserMgt: Codeunit "User Setup Management";
        RespCenter: Record "Responsibility Center";
        FormatAddr: Codeunit "Format Address";
        EmployeeAddr: array[8] of Text[50];
        Reprezentand: Text[1000];
        PaymentDoc: Code[20];
        PaymentDate: Date;
        PostingDate: Text;
        PostingDate2: Text;
        AmountLCYTxt: Text[1000];
        ComTradeNoCaption: Label 'Commerce Trade No';
        VATRegNoCaption: Label 'Cod unic de indentificare';
        CapSocialCaption: Label 'Capital Stock';
        SedSocialCaption: Label 'Social Address';
        PunctLucruCaption: Label 'Work Address';
        ChitNrCaption: Label 'Cash receipt no.';
        DataCaption: Label 'Date';
        PrimitCaption: Label 'Received from';
        AdresaCaption: Label 'Address';
        SumaCaption: Label 'Amount';
        adicaCaption: Label 'meaning';
        reprezCaption: Label 'representing';
        casierCaption: Label 'Casier';
        Employee: Record Employee;
        TipDispozitie: Text;
        Incasat: Text;
        Platit: Text;
        Unitate: Label 'Unitate';
        DispozitieDe: Label 'Dispozitie De';
        Din: Label 'Din';
        Nume: Label 'Nume si Prenume';
        Functie: Label 'Functie(Calitate)';
        suma: Label 'Suma';
        ScopulPlatii: Label 'Scopul Platii';
        IncasatCpn: Label 'Incasat';
        SumaDe: Label 'suma de';
        Data: Label 'Data';
        Semnatura: Label 'Semnatura';
        RON: Label 'RON';
        PlatitCpn: Label 'Platit';
        Conducator: Label 'Conducatorul Unitatii';
        VizaControl: Label 'Viza de control financiar preventiv';
        Compartim: Label 'Compartiment financiar contabil';

    procedure FindApplnEntriesDtldtLedgEntry(var ELE: Record "Employee Ledger Entry"; CreateEmployeeLedgEntry: Record "Employee Ledger Entry")
    var
        DtldEmployeeLedgEntry1: Record "Detailed Employee Ledger Entry";
        DtldEmployeeLedgEntry2: Record "Detailed Employee Ledger Entry";
    begin
        DtldEmployeeLedgEntry1.SetCurrentKey("Employee Ledger Entry No.");
        DtldEmployeeLedgEntry1.SetRange("Employee Ledger Entry No.", CreateEmployeeLedgEntry."Entry No.");
        DtldEmployeeLedgEntry1.SetRange(Unapplied, false);
        if DtldEmployeeLedgEntry1.Find('-') then begin
            repeat
                if DtldEmployeeLedgEntry1."Employee Ledger Entry No." =
                  DtldEmployeeLedgEntry1."Applied Empl. Ledger Entry No."
                then begin
                    DtldEmployeeLedgEntry2.Init;
                    DtldEmployeeLedgEntry2.SetCurrentKey("Applied Empl. Ledger Entry No.", "Entry Type");
                    DtldEmployeeLedgEntry2.SetRange("Applied Empl. Ledger Entry No.", DtldEmployeeLedgEntry1."Applied Empl. Ledger Entry No.");
                    DtldEmployeeLedgEntry2.SetRange("Entry Type", DtldEmployeeLedgEntry2."Entry Type"::Application);
                    DtldEmployeeLedgEntry2.SetRange(Unapplied, false);
                    if DtldEmployeeLedgEntry2.Find('-') then begin
                        repeat
                            if DtldEmployeeLedgEntry2."Employee Ledger Entry No." <>
                              DtldEmployeeLedgEntry2."Applied Empl. Ledger Entry No."
                            then begin
                                ELE.SetCurrentKey("Entry No.");
                                ELE.SetRange("Entry No.", DtldEmployeeLedgEntry2."Employee Ledger Entry No.");
                                if ELE.Find('-') then
                                    ELE.Mark(true);
                            end;
                        until DtldEmployeeLedgEntry2.Next = 0;
                    end;
                end else begin
                    ELE.SetCurrentKey("Entry No.");
                    ELE.SetRange("Entry No.", DtldEmployeeLedgEntry1."Applied Empl. Ledger Entry No.");
                    if ELE.Find('-') then
                        ELE.Mark(true);
                end;
            until DtldEmployeeLedgEntry1.Next = 0;
        end;
    end;
}

