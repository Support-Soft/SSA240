report 71314 "SSA Sales VAT Journal"
{
    // SSA1003 SSCAT 03.11.2019 70.Rapoarte legale- Jurnal vanzari
    DefaultLayout = RDLC;
    RDLCLayout = './src/rdlc/SSASalesVATJournal.rdlc';
    Caption = 'SSA Sales VAT Journal';
    PreviewMode = PrintLayout;
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem("Integer"; "Integer")
        {
            DataItemTableView = SORTING(Number) WHERE(Number = CONST(1));
            column(gTxcCrtNo; gTxcCrtNo)
            {
            }
            column(gTxcOrderNo; gTxcOrderNo)
            {
            }
            column(gTxcDate; gTxcDate)
            {
            }
            column(gTxcCust; gTxcCust)
            {
            }
            column(gTxcRegNo; gTxcRegNo)
            {
            }
            column(gTxcVAT24; gTxcVAT24)
            {
            }
            column(gTxcVAT9; gTxcVAT9)
            {
            }
            column(VAT20; VAT20)
            {
            }
            column(VAT19; VAT19)
            {
            }
            column(gTxcBaseAmount; gTxcBaseAmount)
            {
            }
            column(gTxcVATAmount; gTxcVATAmount)
            {
            }
            column(gTxcDocumentAmount; gTxcDocumentAmount)
            {
            }
            column(gTxcSalesVAT; gTxcSalesVAT)
            {
            }
            column(gTxcDocument; gTxcDocument)
            {
            }
            column(gTxcDeliveryHM; gTxcDeliveryHM)
            {
            }
            column(gTxcDeliveryNO; gTxcDeliveryNO)
            {
            }
            column(gTxcDeliveryPR; gTxcDeliveryPR)
            {
            }
            column(gTxcDeliveryS; gTxcDeliveryS)
            {
            }
            column(gTxcOperFreeVAT; gTxcOperFreeVAT)
            {
            }
            column(gTxcGoodsServRevCharge; gTxcGoodsServRevCharge)
            {
            }
            column(gTxcIntracomDelivery; gTxcIntracomDelivery)
            {
            }
            column(gTxcOtherDelivery; gTxcOtherDelivery)
            {
            }
            column(gTxcExemptP; gTxcExemptP)
            {
            }
            column(gTxcExemptQ; gTxcExemptQ)
            {
            }
            column(gTxcValue; gTxcValue)
            {
            }
            column(gTxcIntracomAquisition; gTxcIntracomAquisition)
            {
            }
            column(gTxcWDedRights; gTxcWDedRights)
            {
            }
            column(gTxcWODedRights; gTxcWODedRights)
            {
            }
            column(gTxcValue1; gTxcValue1)
            {
            }
            column(gTxcICServ; gTxcICServ)
            {
            }
            column(gTxcICAquiz; gTxcICAquiz)
            {
            }
            column(COMPANYNAME; CompanyInfo.Name)
            {
            }
            column(CompanyInfo_VATRegistrationNumber; CompanyInfo.GetVATRegistrationNumber())
            {

            }
            dataitem(VUnreal; "VAT Entry")
            {
                DataItemTableView = SORTING("Posting Date", "Document No.") ORDER(Ascending) WHERE(Type = FILTER(Sale));
                column(CrtNo_VUnreal; CrtNo)
                {
                }
                column(DocumentNo_VUnreal; NrDocument)
                {
                }
                column(PostingDate_VUnreal; "Posting Date")
                {
                }
                column(BilltoPaytoNo_VUnreal; VUnreal."Bill-to/Pay-to No.")
                {
                }
                column(gTxtPayNo_VUnreal; gTxtPayNo)
                {
                }
                column(gTxtCustomerName_VUnreal; gTxtCustomerName)
                {
                }
                column(gTxtFiscalCode_VUnreal; gTxtFiscalCode)
                {
                }
                column(gDecBaseAmount_1_VUnreal; gDecBaseAmount[1])
                {
                }
                column(gDecVATAmount_1_VUnreal; gDecVATAmount[1])
                {
                }
                column(gDecBaseAmount_2_VUnreal; gDecBaseAmount[2])
                {
                }
                column(gDecVATAmount_2_VUnreal; gDecVATAmount[2])
                {
                }
                column(gDecBaseAmount_4_VUnreal; -gDecBaseAmount[4])
                {
                }
                column(gDecBaseAmount_3_VUnreal; -gDecBaseAmount[3])
                {
                }
                column(gDecBaseAmount_22_VUnreal; gDecBaseAmount[22])
                {
                }
                column(gDecVATAmount_22_VUnreal; gDecVATAmount[22])
                {
                }
                column(gDecBaseAmount_21_VUnreal; gDecBaseAmount[21])
                {
                }
                column(gDecVATAmount_21_VUnreal; gDecVATAmount[21])
                {
                }
                column(gDecBaseAmount_5_VUnreal; gDecBaseAmount[5])
                {
                }
                column(gDecBaseAmount_6_VUnreal; gDecBaseAmount[6])
                {
                }
                column(gDecBaseAmount_7_VUnreal; gDecBaseAmount[7])
                {
                }
                column(gDecBaseAmount_8_VUnreal; gDecBaseAmount[8])
                {
                }
                column(gDecBaseAmount_9_VUnreal; gDecBaseAmount[9])
                {
                }
                column(gDecBaseAmount_10_VUnreal; gDecBaseAmount[10])
                {
                }
                column(gDecBaseAmount_11_VUnreal; gDecBaseAmount[11])
                {
                }
                column(gDecBaseAmount_12_VUnreal; gDecBaseAmount[12])
                {
                }
                column(gDecBaseAmount_13_VUnreal; -gDecBaseAmount[13])
                {
                }
                column(gDecVATAmount_13_VUnreal; -gDecVATAmount[13])
                {
                }
                column(gDecBaseAmount_14_VUnreal; gDecBaseAmount[14])
                {
                }
                column(gDecVATAmount_14_VUnreal; gDecVATAmount[14])
                {
                }
                column(gDecBaseAmount_15_VUnreal; gDecBaseAmount[15])
                {
                }
                column(gDecVATAmount_15_VUnreal; gDecVATAmount[15])
                {
                }
                column(gDecTotalAmountEx_VUnreal; gDecTotalAmountEx)
                {
                }
                column(gDecTotalAmount_VUnreal; gDecTotalAmount)
                {
                }
                column(Document_Date_VUnreal; "Document Date")
                {

                }

                trigger OnAfterGetRecord()
                begin

                    gIntCrtNo := 0;
                    Clear(gDecBaseAmount);
                    Clear(gDecVATAmount);
                    clear(gDecTotalAmount);
                    Clear(gDecTotalAmountEx);
                    clear(gTxtPayNo);

                    VUnreal.CalcFields("SSA Realized Amount", "SSA Realized Base");
                    if ("SSA Realized Amount" = "Unrealized Amount") and ("SSA Realized Amount" = "Unrealized Base") then
                        CurrReport.Skip
                    else begin
                        if gRecCustomer.Get("Bill-to/Pay-to No.") then begin
                            gTxtCustomerName := gRecCustomer.Name;
                            gTxtFiscalCode := gRecCustomer."VAT Registration No.";
                        end else begin
                            gTxtFiscalCode := '';
                            gRecGLE.SetCurrentKey("Transaction No.");
                            gRecGLE.SetRange("Transaction No.", "Transaction No.");
                            if gRecGLE.Find('-') then
                                gTxtCustomerName := gRecGLE.Description;
                        end;
                        gDecBaseAmount[21] := -("Unrealized Base" - "SSA Realized Base");
                        gDecVATAmount[21] := -("Unrealized Amount" - "SSA Realized Amount");
                        gDecTotalAmount := gDecVATAmount[21] + gDecBaseAmount[21];
                    end;
                    if (gDecTotalAmount <> 0) then begin
                        if type <> type::Sale then begin
                            if (NrDocument <> "External Document No.") then begin
                                CrtNo += 1;
                                NrDocument := "External Document No.";
                            end;
                        end else begin
                            if (NrDocument <> "Document No.") then begin
                                CrtNo += 1;
                                NrDocument := "Document No.";
                            end;
                        end;
                    end;

                end;

                trigger OnPreDataItem()
                begin
                    SetRange("Posting Date", 0D, DateFilterMax);
                    SetRange("SSA Date Filter", 0D, DateFilter);
                    SetFilter("Unrealized Base", '<>0');
                    SetRange("Unrealized VAT Entry No.", 0);
                    Clear(NrDocument);
                end;
            }
            dataitem("VAT Entry"; "VAT Entry")
            {
                DataItemTableView = SORTING("Posting Date", "Document No.") ORDER(Ascending) WHERE(Type = FILTER(Sale | Purchase));
                RequestFilterFields = "Posting Date";
                column(CrtNo; CrtNo)
                {
                }
                column(DocumentNo; NrDocument)
                {
                }
                column(PostingDate; "VAT Entry"."Posting Date")
                {
                }
                column(BilltoPaytoNo_VATEntry; "VAT Entry"."Bill-to/Pay-to No.")
                {
                }
                column(gTxtPayNo_VATEntry; gTxtPayNo)
                {
                }
                column(gTxtCustomerName; gTxtCustomerName)
                {
                }
                column(gTxtFiscalCode; gTxtFiscalCode)
                {
                }
                column(basea1; gDecBaseAmount[1])
                {
                }
                column(vata1; gDecVATAmount[1])
                {
                }
                column(basea2; gDecBaseAmount[2])
                {
                }
                column(vata2; gDecVATAmount[2])
                {
                }
                column(basea4; gDecBaseAmount[4])
                {
                }
                column(vata3; gDecBaseAmount[3])
                {
                }
                column(basea5; gDecBaseAmount[5])
                {
                }
                column(basea6; gDecBaseAmount[6])
                {
                }
                column(basea7; gDecBaseAmount[7])
                {
                }
                column(basea8; gDecBaseAmount[8])
                {
                }
                column(basea9; gDecBaseAmount[9])
                {
                }
                column(basea10; gDecBaseAmount[10])
                {
                }
                column(basea11; gDecBaseAmount[11])
                {
                }
                column(basea12; gDecBaseAmount[12])
                {
                }
                column(basea13; -gDecBaseAmount[13])
                {
                }
                column(vata13; -gDecVATAmount[13])
                {
                }
                column(basea14; gDecBaseAmount[14])
                {
                }
                column(vata14; gDecVATAmount[14])
                {
                }
                column(basea15; gDecBaseAmount[15])
                {
                }
                column(vata15; gDecVATAmount[15])
                {
                }
                column(gDecBaseAmount_22_VATEntry; gDecBaseAmount[22])
                {
                }
                column(gDecVATAmount_22_VATEntry; gDecVATAmount[22])
                {
                }
                column(gDecBaseAmount_21_VATEntry; gDecBaseAmount[21])
                {
                }
                column(gDecVATAmount_21_VATEntry; gDecVATAmount[21])
                {
                }
                column(gTxtVATFilter; gTxtVATFilter)
                {
                }
                column(gDecTotalAmountEx_VATEntry; gDecTotalAmountEx)
                {
                }
                column(gDecTotalAmount; gDecTotalAmount)
                {
                }
                column(Document_Date_VATEntry; "Document Date")
                {

                }

                trigger OnAfterGetRecord()
                begin
                    gDecTotalAmount := 0;
                    gDecTotalAmountEx := 0;
                    Clear(gDecBaseAmount);
                    Clear(gDecVATAmount);
                    clear(gTxtPayNo);

                    gTxtCustomerName := '';
                    gTxtFiscalCode := '';


                    if gRecCustomer.Get("VAT Entry"."Bill-to/Pay-to No.") then begin
                        gTxtCustomerName := gRecCustomer.Name;
                        gTxtFiscalCode := gRecCustomer."VAT Registration No.";
                    end else begin
                        if gRecVendor.Get("VAT Entry"."Bill-to/Pay-to No.") then begin
                            gTxtCustomerName := gRecVendor.Name;
                            gTxtFiscalCode := gRecVendor."VAT Registration No.";
                        end else begin
                            gTxtFiscalCode := '';
                            gRecGLE.SetCurrentKey("Transaction No.");
                            gRecGLE.SetRange("Transaction No.", "VAT Entry"."Transaction No.");
                            if gRecGLE.Find('-') then
                                gTxtCustomerName := gRecGLE.Description;
                        end;
                    end;

                    //VUNREAL>>

                    "VAT Entry".CalcFields("SSA Realized Amount", "SSA Realized Base", "SSA Unrealized Document Date");

                    if ("Unrealized Amount" <> 0) and (Type = Type::Sale) and ("Unrealized VAT Entry No." = 0) then begin
                        CurrReport.Skip();
                        gDecBaseAmount[21] := -"Unrealized Base" + "SSA Realized Base";
                        gDecVATAmount[21] := -"Unrealized Amount" + "SSA Realized Amount";
                    end;

                    if ("Unrealized VAT Entry No." <> 0) and (Type = Type::Sale) then begin
                        gDecBaseAmount[22] := -Base;
                        gDecVATAmount[22] := -Amount;
                        gDecBaseAmount[1] := 0;
                        gDecVATAmount[1] := 0;
                        gDecBaseAmount[2] := 0;
                        gDecVATAmount[2] := 0;
                        gDecBaseAmount[3] := 0;
                        gDecVATAmount[3] := 0;
                        gDecBaseAmount[15] := 0;
                        gDecVATAmount[12] := 0;
                        gDecTotalAmountEX := -Base - Amount;

                        CalcFields("SSA Unrealized Sales Doc. No.", "SSA Unrealized Document Date");

                        gTxtPayNo := "SSA Unrealized Sales Doc. No." + ' / ' + Format("SSA Unrealized Document Date")
                    end;

                    if ("Unrealized Amount" = 0) and ("Unrealized Base" = 0) and ("Unrealized VAT Entry No." = 0) then begin
                        //VUNREAL<<

                        if not gRecVATPostinGroup.Get("VAT Bus. Posting Group", "VAT Prod. Posting Group") then begin
                            gRecVATPostinGroup.SetCurrentKey("VAT Bus. Posting Group", "VAT Prod. Posting Group");
                            gRecVATPostinGroup.SetFilter("VAT Bus. Posting Group", '=%1', "VAT Bus. Posting Group");
                            gRecVATPostinGroup.SetFilter("VAT Prod. Posting Group", '=%1', "VAT Prod. Posting Group");
                            if gRecVATPostinGroup.Find('-') then;
                        end;

                        if Type = Type::Purchase then begin
                            case gRecVATPostinGroup."VAT Calculation Type" of
                                gRecVATPostinGroup."VAT Calculation Type"::"Reverse Charge VAT":
                                    begin
                                        if (gRecVATPostinGroup."SSA Column Type" = gRecVATPostinGroup."SSA Column Type"::"ICA Resale Free of VAT")
                                         or (gRecVATPostinGroup."SSA Column Type" = gRecVATPostinGroup."SSA Column Type"::"ICA Needs Free of VAT")
                                         or (gRecVATPostinGroup."SSA Column Type" = gRecVATPostinGroup."SSA Column Type"::"ICA Resale Not Taxable") //IP
                                         or (gRecVATPostinGroup."SSA Column Type" = gRecVATPostinGroup."SSA Column Type"::"ICA Needs Not Taxable")  //IP
                                        then begin
                                            gDecBaseAmount[4] := Base;
                                            gDecVATAmount[4] := Amount;
                                        end else
                                            if (gRecVATPostinGroup."SSA Column Type" <> gRecVATPostinGroup."SSA Column Type"::"Simplified VAT") then begin
                                                gDecBaseAmount[13] := -Base;
                                                gDecVATAmount[13] := -Amount;
                                            end;
                                    end;
                            end;
                        end else begin
                            case gRecVATPostinGroup."SSA Column Type" of

                                gRecVATPostinGroup."SSA Column Type"::"VAT 24%":
                                    begin
                                        case gRecVATPostinGroup."VAT %" of
                                            19:
                                                begin
                                                    gDecBaseAmount[15] := -Base;
                                                    gDecVATAmount[15] := -Amount;
                                                end;
                                            20, 5:
                                                begin
                                                    gDecBaseAmount[14] := -Base;
                                                    gDecVATAmount[14] := -Amount;
                                                end;
                                            24:
                                                begin
                                                    gDecBaseAmount[1] := -Base;
                                                    gDecVATAmount[1] := -Amount;
                                                end;
                                        end;
                                    end;

                                gRecVATPostinGroup."SSA Column Type"::"VAT 9%":
                                    begin
                                        gDecBaseAmount[2] := -Base;
                                        gDecVATAmount[2] := -Amount;
                                    end;

                                gRecVATPostinGroup."SSA Column Type"::"Special Regime":
                                    begin
                                        gDecBaseAmount[3] := -Base;
                                    end;

                                gRecVATPostinGroup."SSA Column Type"::"Simplified VAT":
                                    begin
                                        gDecBaseAmount[4] := -Base;
                                    end;

                                gRecVATPostinGroup."SSA Column Type"::"Drop Ship Ded":
                                    begin
                                        gDecBaseAmount[5] := -Base;

                                    end;

                                gRecVATPostinGroup."SSA Column Type"::"Drop Ship Not Ded":
                                    begin
                                        gDecBaseAmount[6] := -Base;
                                    end;

                                gRecVATPostinGroup."SSA Column Type"::"ICS Free of VAT AD":
                                    begin
                                        gDecBaseAmount[7] := -Base;
                                    end;

                                gRecVATPostinGroup."SSA Column Type"::"ICS Free of VAT BC":
                                    begin
                                        gDecBaseAmount[8] := -Base;
                                    end;

                                gRecVATPostinGroup."SSA Column Type"::"Free of VAT Deductible":
                                    begin
                                        gDecBaseAmount[9] := -Base;

                                    end;

                                gRecVATPostinGroup."SSA Column Type"::"Free of VAT Not Deductible":
                                    begin
                                        gDecBaseAmount[10] := -Base;
                                    end;

                                gRecVATPostinGroup."SSA Column Type"::"Not Taxable":
                                    begin
                                        gDecBaseAmount[11] := -Base;
                                    end;

                                gRecVATPostinGroup."SSA Column Type"::"ICS Services":
                                    begin
                                        gDecBaseAmount[12] := -Base;
                                    end;

                            end;
                        end;
                    end;
                    gDecTotalAmount := gDecBaseAmount[1] + gDecBaseAmount[2] + gDecBaseAmount[3] + gDecBaseAmount[4] + gDecBaseAmount[5] +
                    gDecBaseAmount[6] + gDecBaseAmount[7] + gDecBaseAmount[8] + gDecBaseAmount[9] + gDecBaseAmount[10] +
                    gDecBaseAmount[11] + gDecBaseAmount[12] - gDecBaseAmount[13] +
                    gDecVATAmount[1] + gDecVATAmount[2] + gDecVATAmount[3] + gDecVATAmount[4] - gDecVATAmount[13];

                    gDecTotalAmount := gDecTotalAmount + gDecBaseAmount[14] + gDecBaseAmount[15] + gDecVATAmount[14] + gDecVATAmount[15];
                    gDecTotalAmount := gDecTotalAmount + gDecVATAmount[21] + gDecBaseAmount[21];

                    if ((gDecTotalAmount <> 0) or (gDecTotalAmountEx <> 0)) then begin
                        if type <> type::Sale then begin
                            if (NrDocument <> "External Document No.") then begin
                                CrtNo += 1;
                                NrDocument := "External Document No.";
                            end;
                        end else begin
                            if (NrDocument <> "Document No.") then begin
                                CrtNo += 1;
                                NrDocument := "Document No.";
                            end;
                        end;

                    end;
                end;

                trigger OnPreDataItem()
                begin

                    Clear(NrDocument);
                end;
            }
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnInitReport()
    begin
        gIntiRow := 2;
        ginticol := 0;
    end;

    trigger OnPreReport()
    begin
        gTxtVATFilter := "VAT Entry".GetFilters;

        DateFilterMax := "VAT Entry".GetRangeMax("Posting Date");
        DateFilter := "VAT Entry".GetRangeMin("Posting Date");
        DateFilter := CalcDate('<-1D>', DateFilter);

        CompanyInfo.Get();
    end;

    var
        gIntCrtNo: Integer;
        gDecTotalAmount: Decimal;
        gDecBaseAmount: array[22] of Decimal;
        gDecVATAmount: array[22] of Decimal;
        gRecCustomer: Record Customer;
        gRecVendor: Record Vendor;
        gRecVATPostinGroup: Record "VAT Posting Setup";
        gTxtVATFilter: Text[250];
        gTxtCustomerName: Text[100];
        gTxtFiscalCode: Text[100];
        gRecGLE: Record "G/L Entry";
        gIntiRow: Integer;
        ginticol: Integer;
        i: Integer;
        gTxcCrtNo: Label 'Nr. Crt';
        gTxcOrderNo: Label 'Nr. document';
        gTxcDate: Label 'Data';
        gTxcCust: Label 'Denumirea/numele clientului/beneficiarului';
        gTxcRegNo: Label 'Codul de inregistrare in scopuri de T.V.A. al clientului/beneficiarului';
        gTxcDocumentAmount: Label 'Total  document (inclusiv T.V.A.)';
        gTxcVAT24: Label 'Cota 24%';
        gTxcVAT9: Label 'Cota 9%';
        gTxcBaseAmount: Label 'Baza de impozitare';
        gTxcVATAmount: Label 'Valoare T.V.A.';
        gTxcSalesVAT: Label 'JURNAL DE VANZARI CU T.V.A';
        gTxcDocument: Label 'Document';
        gTxcDeliveryHM: Label 'Livrari de bunuri si prestari de servicii taxabile';
        gTxcDeliveryNO: Label 'Livrari de bunuri si prestari de servicii pentru care locul livrarii/prestarii este in afara Romaniei';
        gTxcDeliveryPR: Label 'Livrari de bunuri si prestari de servicii scutite cu drept de deducere';
        gTxcDeliveryS: Label 'Livrari de bunuri si prestari de servicii scutite fara drept de deducere';
        gTxcOperFreeVAT: Label 'Operatiuni neimpozabile/Sume neincluse in baza de impozitare (optional)';
        gTxcGoodsServRevCharge: Label 'Bunuri si servicii cu "taxare inversa"';
        gTxcIntracomDelivery: Label 'Livrari intracomunitare de bunuri';
        gTxcOtherDelivery: Label 'Alte livrari de bunuri si prestari de servicii scutite cu drept de deducere';
        gTxcExemptP: Label 'Scutite conform art. 143 alin. (2) lit. a) si d) din Codul Fiscal';
        gTxcExemptQ: Label 'Scutite conform art. 143 alin. (2) lit. b) si c) din Codul Fiscal';
        gTxcWithWOSimplifiedVAT: Label 'Purchases without Simplified VAT';
        gTxcValue: Label 'Valoarea';
        gTxcIntracomAquisition: Label 'Bunuri si servicii pentru care s-a aplicat un regim special, conform art. 152/1 sau 152/2 din Codul fiscal';
        gTxcDeliveryT4: Label 'Alte livrari de bunuri si prestari de servicii scutite cu drept de deducere';
        gTxcWDedRights: Label 'Cu drept de deducere';
        gTxcWODedRights: Label 'Fara drept de deducere';
        gTxcValue1: Label 'Valoarea de impozitare';
        gTxcICServ: Label 'Servicii prestate UE';
        gTxcICAquiz: Label 'Achizitii supuse taxarii inverse';
        CrtNo: Integer;
        NrDocument: Code[20];
        VAT20: Label 'Cota de 20%|5%';
        VAT19: Label 'Cota 19%';
        DateFilter: Date;
        DateFilterMax: Date;
        gDecTotalAmountEx: Decimal;
        gTxtPayNo: Text;
        CompanyInfo: Record "Company Information";
}

