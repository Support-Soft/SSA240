report 70900 "SSA Cash receipt"
{
    DefaultLayout = RDLC;
    RDLCLayout = './src/rdlc/Cash receipt.rdlc';
    Caption = 'Cash Receipt Report';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    dataset
    {
        dataitem("G/L Register"; "G/L Register")
        {
            DataItemTableView = sorting("No.");
            dataitem("Cust. Ledger Entry"; "Cust. Ledger Entry")
            {
                CalcFields = "Amount (LCY)";
                DataItemTableView = sorting("Entry No.") where("Document Type" = filter(" " | Payment | Refund));
                column(DocumentNo_CustLedgerEntry; "Cust. Ledger Entry"."Document No.")
                {
                }
                column(PostingDate; PostingDate)
                {
                }
                column(AmountLCY_CustLedgerEntry; Abs("Cust. Ledger Entry"."Amount (LCY)"))
                {
                }
                column(PostingDate_CustLedgerEntry; Format("Cust. Ledger Entry"."Posting Date", 0, '<Day,2>.<Month,2>.<Year4>'))
                {
                }
                column(AmoutLCYTxt; AmountLCYTxt)
                {
                }
                column(Reprezentand; Reprezentand)
                {
                }
                column(CustAddr1; CustAddr[1])
                {
                }
                column(CustomerAddress; Customer.Address)
                {
                }
                column(CustomerAddress2; Customer."Address 2")
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
                column(CustVatRegNo; Customer."VAT Registration No.")
                {
                }
                column(CustComTradeNo; Customer."SSA Commerce Trade No.")
                {
                }
                column(Reprezentand1; Reprezentand1)
                {
                }

                trigger OnAfterGetRecord()
                var
                    CreateCustLedgEntry: Record "Cust. Ledger Entry";
                    CLE: Record "Cust. Ledger Entry";
                begin
                    PostingDate := Format("Cust. Ledger Entry"."Posting Date", 0, '<Day,2>.<Month,2>.<Year4>');
                    if Customer.Get("Cust. Ledger Entry"."Customer No.") then
                        FormatAddr.Customer(CustAddr, Customer);

                    if "Entry No." <> 0 then begin
                        CreateCustLedgEntry := "Cust. Ledger Entry";

                        FindApplnEntriesDtldtLedgEntry(CLE, CreateCustLedgEntry);
                        CLE.SetCurrentKey("Entry No.");
                        CLE.SetRange("Entry No.");

                        if CreateCustLedgEntry."Closed by Entry No." <> 0 then begin
                            CLE."Entry No." := CreateCustLedgEntry."Closed by Entry No.";
                            CLE.Mark(true);
                        end;

                        CLE.SetCurrentKey("Closed by Entry No.");
                        CLE.SetRange("Closed by Entry No.", CreateCustLedgEntry."Entry No.");
                        if CLE.Find('-') then
                            repeat
                                CLE.Mark(true);
                            until CLE.Next = 0;

                        CLE.SetCurrentKey("Entry No.");
                        CLE.SetRange("Closed by Entry No.");
                    end;

                    CLE.MarkedOnly(true);

                    Clear(Reprezentand);

                    if CLE.FindFirst then
                        repeat
                            Reprezentand += ' ' + CLE."Document No." + '/' + Format(CLE."Document Date") + ',';
                        until CLE.Next = 0;

                    AmountLCYTxt := GeneralFunctions.FormatNumberToText(Abs("Amount (LCY)"))
                end;

                trigger OnPreDataItem()
                begin
                    if PaymentDoc <> '' then begin
                        "Cust. Ledger Entry".SetRange("Cust. Ledger Entry"."Document No.", PaymentDoc);
                    end else
                        SetRange("Entry No.", "G/L Register"."From Entry No.", "G/L Register"."To Entry No.");
                    //SSM853>>
                    if Count > 1 then
                        CurrReport.Quit;
                    //SSM853<<
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
                    Caption = 'Document No.';
                    ToolTip = 'Specifies the value of the Document No. field.';
                    ApplicationArea = All;
                    trigger OnLookup(var Text: Text): Boolean
                    var
                        CLE: Record "Cust. Ledger Entry";
                        CLEForm: Page "Customer Ledger Entries";
                    begin

                        CLE.SetFilter("Document Type", '%1|%2|%3', CLE."Document Type"::Payment, CLE."Document Type"::" ", CLE."Document Type"::Refund);
                        CLE.SetFilter("Amount (LCY)", '<%1', 0);
                        CLEForm.SetTableView(CLE);
                        CLEForm.LookupMode(true);
                        CLEForm.RunModal;

                        if CLEForm.LookupMode then begin
                            CLEForm.GetRecord(CLE);
                            PaymentDoc := CLE."Document No.";
                            PaymentDate := CLE."Posting Date";
                        end;
                        Clear(CLEForm);
                    end;
                }
                field("Data plata"; PaymentDate)
                {
                    Caption = 'Document Date';
                    ToolTip = 'Specifies the value of the Document Date field.';
                    ApplicationArea = All;
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
        GeneralFunctions: Codeunit "SSA General Functions";
        RespCenter: Record "Responsibility Center";
        FormatAddr: Codeunit "Format Address";
        CustAddr: array[8] of Text[50];
        Customer: Record Customer;
        Reprezentand: Text[1000];
        PaymentDoc: Code[20];
        PaymentDate: Date;
        PostingDate: Text;
        AmountLCYTxt: Text[1000];
        ComTradeNoCaption: Label 'Commerce Trade No';
        VATRegNoCaption: Label 'VAT REg. No.';
        CapSocialCaption: Label 'Capital Stock';
        SedSocialCaption: Label 'Social Address';
        PunctLucruCaption: Label 'Work Address';
        ChitNrCaption: Label 'Cash receipt no.';
        DataCaption: Label 'Date';
        PrimitCaption: Label 'Received from';
        AdresaCaption: Label 'Address';
        SumaCaption: Label 'Amount';
        adicaCaption: Label 'meaning';
        reprezCaption: Label 'Representing';
        casierCaption: Label 'Cashier person';
        Reprezentand1: Label 'Documents:';

    procedure SetParameters(_PaymentDoc: Code[20]; _PaymentDate: Date)
    begin
        //SSM1045>>
        PaymentDoc := _PaymentDoc;
        PaymentDate := _PaymentDate;
        //SSM1045<<
    end;

    procedure FindApplnEntriesDtldtLedgEntry(var CLE: Record "Cust. Ledger Entry"; CreateCustLedgEntry: Record "Cust. Ledger Entry")
    var
        DtldCustLedgEntry1: Record "Detailed Cust. Ledg. Entry";
        DtldCustLedgEntry2: Record "Detailed Cust. Ledg. Entry";
    begin
        DtldCustLedgEntry1.SetCurrentKey("Cust. Ledger Entry No.");
        DtldCustLedgEntry1.SetRange("Cust. Ledger Entry No.", CreateCustLedgEntry."Entry No.");
        DtldCustLedgEntry1.SetRange(Unapplied, false);
        if DtldCustLedgEntry1.Find('-') then begin
            repeat
                if DtldCustLedgEntry1."Cust. Ledger Entry No." =
                  DtldCustLedgEntry1."Applied Cust. Ledger Entry No."
                then begin
                    DtldCustLedgEntry2.Init;
                    DtldCustLedgEntry2.SetCurrentKey("Applied Cust. Ledger Entry No.", "Entry Type");
                    DtldCustLedgEntry2.SetRange(
                      "Applied Cust. Ledger Entry No.", DtldCustLedgEntry1."Applied Cust. Ledger Entry No.");
                    DtldCustLedgEntry2.SetRange("Entry Type", DtldCustLedgEntry2."Entry Type"::Application);
                    DtldCustLedgEntry2.SetRange(Unapplied, false);
                    if DtldCustLedgEntry2.Find('-') then begin
                        repeat
                            if DtldCustLedgEntry2."Cust. Ledger Entry No." <>
                              DtldCustLedgEntry2."Applied Cust. Ledger Entry No."
                            then begin
                                CLE.SetCurrentKey("Entry No.");
                                CLE.SetRange("Entry No.", DtldCustLedgEntry2."Cust. Ledger Entry No.");
                                if CLE.Find('-') then
                                    CLE.Mark(true);
                            end;
                        until DtldCustLedgEntry2.Next = 0;
                    end;
                end else begin
                    CLE.SetCurrentKey("Entry No.");
                    CLE.SetRange("Entry No.", DtldCustLedgEntry1."Applied Cust. Ledger Entry No.");
                    if CLE.Find('-') then
                        CLE.Mark(true);
                end;
            until DtldCustLedgEntry1.Next = 0;
        end;
    end;
}
