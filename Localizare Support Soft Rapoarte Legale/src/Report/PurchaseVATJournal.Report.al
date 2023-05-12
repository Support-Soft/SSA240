report 71313 "SSA Purchase VAT Journal"
{
    // SSA1002 SSCAT 08.10.2019 69.Rapoarte legale-Jurnal cumparari neexigibil
    DefaultLayout = RDLC;
    RDLCLayout = './src/rdlc/SSAPurchaseVATJournal.rdlc';
    Caption = 'Purchase VAT Journal 2013';
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem("Integer"; "Integer")
        {
            DataItemTableView = SORTING(Number) WHERE(Number = CONST(1));
            column(COMPANYNAME; CompanyInfo.Name)
            {
            }
            column(DateFilt; gTxtVATFilter)
            {
            }
            column(gTxcValPlat; gTxcValPlat)
            {
            }
            column(gtxcOperatEx; gtxcOperatEx)
            {
            }
            column(gtxcOperatNeex; gtxcOperatNeex)
            {
            }
            column(gTxcAquisition; gTxcAquisition)
            {
            }
            column(gTxcIntracomAquisition; gTxcIntracomAquisition)
            {
            }
            column(gTxcForResale; gTxcForResale)
            {
            }
            column(gTxcExempt; gTxcExempt)
            {
            }
            column(gTxcFreeVAT; gTxcFreeVAT)
            {
            }
            column(gTxcGoodsServices150; gTxcGoodsServices150)
            {
            }
            column(gTxcGoodsServices; gTxcGoodsServices)
            {
            }
            column(gTxcAchizitii; gTxcAchizitii)
            {
            }
            column(gTxcCrtNo; gTxcCrtNo)
            {
            }
            column(gTxcOrderNo; gTxcOrderNo)
            {
            }
            column(gTxcDate; gTxcDate)
            {
            }
            column(gTxcVendor; gTxcVendor)
            {
            }
            column(gTxcRegNo; gTxcRegNo)
            {
            }
            column(gTxcDocAmount; gTxcDocAmount)
            {
            }
            column(gTxc19; gTxc19)
            {
            }
            column(gTxc20; gTxc20)
            {
            }
            column(gTxc9; gTxc9)
            {
            }
            column(gTxcBaseAmount; gTxcBaseAmount)
            {
            }
            column(gTxcVATAmount; gTxcVATAmount)
            {
            }
            column(gTxcDocument; gTxcDocument)
            {
            }
            column(gTxcPaymentNo; gTxcPaymentNo)
            {
            }
            column(gTxcPurchaseVAT; gTxcPurchaseVAT)
            {
            }
            column(gTxcAquisition2; gTxcAquisition2)
            {
            }
            column(CompanyInfo_VATRegistrationNumber; CompanyInfo.GetVATRegistrationNumber())
            {

            }
            dataitem(VUnreal; "VAT Entry")
            {
                DataItemTableView = SORTING("Posting Date", "Document No.") ORDER(Ascending) WHERE(Type = FILTER(Purchase));
                column(CrtNo; CrtNo)
                {
                }
                column(DocumentNo; DocumentNo1)
                {
                }
                column(PDate; VUnreal."Posting Date")
                {
                }
                column(BilltoPaytoNo_VUnreal; VUnreal."Bill-to/Pay-to No.")
                {
                }
                column(gTxtVendorName; gTxtVendorName)
                {
                }
                column(gTxtFiscalCode; gTxtFiscalCode)
                {
                }
                column(PayNo; PayNo)
                {
                }
                column(gDecTotalAmount; gDecTotalAmount)
                {
                }
                column(basea1_2_3_15; gDecBaseAmount[1] + gDecBaseAmount[2] + gDecBaseAmount[3] + gDecBaseAmount[15])
                {
                }
                column(vata1_2_3_12; gDecVATAmount[1] + gDecVATAmount[2] + gDecVATAmount[3] + gDecVATAmount[12])
                {
                }
                column(BaseA_20; gDecBaseAmount[23] + gDecBaseAmount[24] + gDecBaseAmount[25] + gDecBaseAmount[26])
                {
                }
                column(VATA_20; gDecVATAmount[23] + gDecVATAmount[24] + gDecVATAmount[25] + gDecVATAmount[26])
                {
                }
                column(basea4_5_16; gDecBaseAmount[4] + gDecBaseAmount[5] + gDecBaseAmount[16])
                {
                }
                column(vata4_5_16; gDecVATAmount[4] + gDecVATAmount[5] + gDecVATAmount[13])
                {
                }
                column(gDecTotalAmountEx; gDecTotalAmountEx)
                {
                }
                column(basea22; gDecBaseAmount[22])
                {
                }
                column(vata22; gDecVATAmount[22])
                {
                }
                column(basea21; gDecBaseAmount[21])
                {
                }
                column(vata21; gDecVATAmount[21])
                {
                }
                column(basea13; gDecBaseAmount[13])
                {
                }
                column(basea6_9; gDecBaseAmount[6] + gDecBaseAmount[9])
                {
                }
                column(vata7_8; gDecVATAmount[7] + gDecVATAmount[8])
                {
                }
                column(basea7_10; gDecBaseAmount[7] + gDecBaseAmount[10])
                {
                }
                column(basea8_11; gDecBaseAmount[8] + gDecBaseAmount[11])
                {
                }
                column(basea14; gDecBaseAmount[14])
                {
                }
                column(vata11; gDecVATAmount[11])
                {
                }
                column(basea12; gDecBaseAmount[12])
                {
                }
                column(vata9; gDecVATAmount[9])
                {
                }
                column(basea17; gDecBaseAmount[17])
                {
                }
                column(vata10; gDecVATAmount[10])
                {
                }
                column(Transaction_No_VU; "Transaction No.")
                {
                }
                column(DocumentDate_VUnreal; VUnreal."Document Date")
                {
                }

                trigger OnAfterGetRecord()
                begin

                    if WithoutNonDeductibleVAT then
                        if VATProductPostingGroup.Get("VAT Prod. Posting Group") and VATProductPostingGroup."SSA Non-Deductible VAT" then
                            CurrReport.Skip;
                    if Reversed then
                        CurrReport.skip;

                    gIntCrtNo := 0;
                    gDecTotalAmount := 0;
                    gDecTotalAmountEx := 0;
                    Clear(gDecBaseAmount);
                    Clear(gDecVATAmount);
                    clear(PayNo);

                    CalcFields("SSA Realized Amount", "SSA Realized Base");
                    if ("SSA Realized Amount" = "Unrealized Amount") and
                       ("SSA Realized Base" = "Unrealized Base")
                    then
                        CurrReport.Skip
                    else begin
                        if gRecVendor.Get("Bill-to/Pay-to No.") then begin
                            gTxtVendorName := gRecVendor.Name;
                            gTxtFiscalCode := gRecVendor."VAT Registration No.";
                        end else begin
                            gTxtFiscalCode := '';
                            gRecGLE.SetCurrentKey("Transaction No.");
                            gRecGLE.SetRange("Transaction No.", "Transaction No.");
                            if gRecGLE.Find('-') then
                                gTxtVendorName := gRecGLE.Description;
                        end;

                        gDecBaseAmount[21] := "Unrealized Base" - "SSA Realized Base";
                        gDecVATAmount[21] := "Unrealized Amount" - "SSA Realized Amount";
                        gDecTotalAmount := gDecVATAmount[21] + gDecBaseAmount[21];
                    end;

                    DocumentNo1 := '';

                    DocumentNo1 := "External Document No.";
                    if (nrdoc <> DocumentNo1) or (PayToSellTo <> "Bill-to/Pay-to No.") then begin
                        CrtNo += 1;
                        nrdoc := DocumentNo1;
                        PayToSellTo := "Bill-to/Pay-to No.";
                    end;
                end;

                trigger OnPreDataItem()
                begin
                    SetFilter("Posting Date", '<=%1', "VAT Entry".GetRangeMax("Posting Date"));
                    SetFilter(VUnreal."SSA Date Filter", '<%1', "VAT Entry".GetRangeMin("Posting Date"));
                    SetFilter(VUnreal."Unrealized Base", '<>0');
                end;
            }
            dataitem("VAT Entry"; "VAT Entry")
            {
                DataItemTableView = SORTING("Posting Date", "Document No.") ORDER(Ascending) WHERE(Type = FILTER(Purchase));
                RequestFilterFields = "Posting Date";
                column(CrtNo1; CrtNo)
                {
                }
                column(DocumentNo1; DocumentNo1)
                {
                }
                column(Pdate1; "VAT Entry"."Posting Date")
                {
                }
                column(BilltoPaytoNo_VATEntry; "VAT Entry"."Bill-to/Pay-to No.")
                {
                }
                column(gTxtVendorName1; gTxtVendorName)
                {
                }
                column(gTxtFiscalCode1; gTxtFiscalCode)
                {
                }
                column(PayNo1; PayNo)
                {
                }
                column(gDecTotalAmount1; gDecTotalAmount)
                {
                }
                column(basea1_2_3_15_1; gDecBaseAmount[1] + gDecBaseAmount[2] + gDecBaseAmount[3] + gDecBaseAmount[15])
                {
                }
                column(vata1_2_3_12_1; gDecVATAmount[1] + gDecVATAmount[2] + gDecVATAmount[3] + gDecVATAmount[12])
                {
                }
                column(BaseA_20_1; gDecBaseAmount[23] + gDecBaseAmount[24] + gDecBaseAmount[25] + gDecBaseAmount[26])
                {
                }
                column(VATA_20_1; gDecVATAmount[23] + gDecVATAmount[24] + gDecVATAmount[25] + gDecVATAmount[26])
                {
                }
                column(basea4_5_16_1; gDecBaseAmount[4] + gDecBaseAmount[5] + gDecBaseAmount[16])
                {
                }
                column(vata4_5_16_1; gDecVATAmount[4] + gDecVATAmount[5] + gDecVATAmount[13])
                {
                }
                column(gDecTotalAmountEx1; gDecTotalAmountEx)
                {
                }
                column(basea22_1; gDecBaseAmount[22])
                {
                }
                column(vata22_1; gDecVATAmount[22])
                {
                }
                column(basea21_1; gDecBaseAmount[21])
                {
                }
                column(vata21_1; gDecVATAmount[21])
                {
                }
                column(basea13_1; gDecBaseAmount[13])
                {
                }
                column(basea6_9_1; gDecBaseAmount[6] + gDecBaseAmount[9])
                {
                }
                column(vata7_8_1; gDecVATAmount[7] + gDecVATAmount[8])
                {
                }
                column(basea7_10_1; gDecBaseAmount[7] + gDecBaseAmount[10])
                {
                }
                column(basea8_11_1; gDecBaseAmount[8] + gDecBaseAmount[11])
                {
                }
                column(basea14_1; gDecBaseAmount[14])
                {
                }
                column(vata11_1; gDecVATAmount[11])
                {
                }
                column(basea12_1; gDecBaseAmount[12])
                {
                }
                column(vata9_1; gDecVATAmount[9])
                {
                }
                column(basea17_1; gDecBaseAmount[17])
                {
                }
                column(vata10_1; gDecVATAmount[10])
                {
                }
                column(Transaction_No_VATEntry; "Transaction No.")
                {
                }
                column(DocumentDate_VATEntry; "Document Date")
                {
                }

                trigger OnAfterGetRecord()
                begin
                    if WithoutNonDeductibleVAT then
                        if VATProductPostingGroup.Get("VAT Prod. Posting Group") and VATProductPostingGroup."SSA Non-Deductible VAT" then
                            CurrReport.Skip;

                    if ("Document Type" = "Document Type"::"Credit Memo") and ("Unrealized VAT Entry No." <> 0) then
                        CurrReport.Skip;

                    if Reversed then
                        CurrReport.skip;

                    gDecTotalAmount := 0;
                    gDecTotalAmountEx := 0;
                    Clear(gDecBaseAmount);
                    Clear(gDecVATAmount);
                    gTxtFiscalCode := '';
                    gTxtVendorName := '';
                    DocumentNo1 := '';
                    clear(PayNo);

                    DocumentNo1 := "External Document No.";

                    SetFilter("SSA Date Filter", '%1..%2', 0D, CalcDate(Text001, GetRangeMin("Posting Date")));
                    CalcFields("SSA Realized Amount", "SSA Realized Base", "SSA Unrealized Purch. Doc. No.");

                    if gRecVendor.Get("Bill-to/Pay-to No.") then begin
                        gTxtVendorName := gRecVendor.Name;
                        gTxtFiscalCode := gRecVendor."VAT Registration No.";
                    end else begin
                        gTxtFiscalCode := '';
                        gRecGLE.SetCurrentKey("Transaction No.");
                        gRecGLE.SetRange("Transaction No.", "Transaction No.");
                        if gRecGLE.Find('-') then
                            gTxtVendorName := gRecGLE.Description;
                    end;

                    if "Unrealized Amount" <> 0 then begin
                        CurrReport.Skip;
                        gDecBaseAmount[21] := "Unrealized Base" - "SSA Realized Base";
                        gDecVATAmount[21] := "Unrealized Amount" - "SSA Realized Amount";
                        gDecTotalAmount := Base + Amount;
                        gDecBaseAmount[22] := 0;
                        gDecVATAmount[22] := 0;
                        gDecBaseAmount[16] := 0;
                        gDecVATAmount[13] := 0;
                        gDecBaseAmount[4] := 0;
                        gDecVATAmount[4] := 0;
                        gDecBaseAmount[5] := 0;
                        gDecVATAmount[5] := 0;
                    end;

                    if "Unrealized VAT Entry No." <> 0 then begin
                        gDecBaseAmount[22] := Base;
                        gDecVATAmount[22] := Amount;
                        gDecBaseAmount[1] := 0;
                        gDecVATAmount[1] := 0;
                        gDecBaseAmount[2] := 0;
                        gDecVATAmount[2] := 0;
                        gDecBaseAmount[3] := 0;
                        gDecVATAmount[3] := 0;
                        gDecBaseAmount[15] := 0;
                        gDecVATAmount[12] := 0;
                        gDecBaseAmount[21] := 0;
                        gDecVATAmount[21] := 0;
                        gDecBaseAmount[16] := 0;
                        gDecVATAmount[13] := 0;
                        gDecBaseAmount[4] := 0;
                        gDecVATAmount[4] := 0;
                        gDecBaseAmount[5] := 0;
                        gDecVATAmount[5] := 0;
                        gDecBaseAmount[23] := 0;
                        gDecVATAmount[23] := 0;
                        gDecBaseAmount[24] := 0;
                        gDecVATAmount[24] := 0;
                        gDecBaseAmount[25] := 0;
                        gDecVATAmount[25] := 0;
                        gDecBaseAmount[26] := 0;
                        gDecVATAmount[26] := 0;

                        gDecTotalAmountEx := Base + Amount;
                        CalcFields("SSA Unrealized Purch. Doc. No.");

                    end;

                    if not gRecVATPostinGroup.Get("VAT Bus. Posting Group", "VAT Prod. Posting Group") then begin
                        gRecVATPostinGroup.SetCurrentKey("VAT Bus. Posting Group", "VAT Prod. Posting Group");
                        gRecVATPostinGroup.SetFilter("VAT Bus. Posting Group", '=%1', "VAT Bus. Posting Group");
                        gRecVATPostinGroup.SetFilter("VAT Prod. Posting Group", '=%1', "VAT Prod. Posting Group");
                        if gRecVATPostinGroup.Find('-') then;
                    end;

                    case gRecVATPostinGroup."SSA Column Type" of
                        gRecVATPostinGroup."SSA Column Type"::"Capital 24%":
                            begin
                                case gRecVATPostinGroup."VAT %" of
                                    19, 0:
                                        begin
                                            gDecBaseAmount[1] := Base;
                                            gDecVATAmount[1] := Amount;
                                        end;
                                    20, 5:
                                        begin
                                            gDecBaseAmount[23] := Base;
                                            gDecVATAmount[23] := Amount;
                                        end;
                                end;
                            end;
                        gRecVATPostinGroup."SSA Column Type"::"VAT 24%":
                            begin
                                case gRecVATPostinGroup."VAT %" of
                                    19, 0:
                                        begin
                                            gDecBaseAmount[15] := Base;
                                            gDecVATAmount[12] := Amount;
                                        end;
                                    20, 5:
                                        begin
                                            gDecBaseAmount[26] := Base;
                                            gDecVATAmount[26] := Amount;
                                        end;
                                end;
                            end;
                        gRecVATPostinGroup."SSA Column Type"::"Resale 24%":
                            begin
                                case gRecVATPostinGroup."VAT %" of
                                    19, 0:
                                        begin
                                            gDecBaseAmount[2] := Base;
                                            gDecVATAmount[2] := Amount;
                                        end;
                                    20, 5:
                                        begin
                                            gDecBaseAmount[24] := Base;
                                            gDecVATAmount[24] := Amount;
                                        end;
                                end;
                            end;
                        gRecVATPostinGroup."SSA Column Type"::"Needs 24%":
                            begin
                                case gRecVATPostinGroup."VAT %" of
                                    19, 0:
                                        begin
                                            gDecBaseAmount[3] := Base;
                                            gDecVATAmount[3] := Amount;
                                        end;
                                    20, 5:
                                        begin
                                            gDecBaseAmount[25] := Base;
                                            gDecVATAmount[25] := Amount;
                                        end;
                                end;
                            end;
                        gRecVATPostinGroup."SSA Column Type"::"VAT 9%":
                            begin
                                gDecBaseAmount[16] := Base;
                                gDecVATAmount[13] := Amount;
                            end;
                        gRecVATPostinGroup."SSA Column Type"::"Resale 9%":
                            begin
                                gDecBaseAmount[4] := Base;
                                gDecVATAmount[4] := Amount;
                            end;
                        gRecVATPostinGroup."SSA Column Type"::"Needs 9%":
                            begin
                                gDecBaseAmount[5] := Base;
                                gDecVATAmount[5] := Amount;
                            end;
                        gRecVATPostinGroup."SSA Column Type"::"Free of VAT":
                            begin
                                gDecBaseAmount[13] := Base;
                            end;
                        gRecVATPostinGroup."SSA Column Type"::"ICA Resale":
                            begin
                                gDecBaseAmount[6] := Base;
                                gDecVATAmount[7] := Amount;
                            end;
                        gRecVATPostinGroup."SSA Column Type"::"ICA Needs":
                            begin
                                gDecBaseAmount[9] := Base;
                                gDecVATAmount[8] := Amount;
                            end;
                        gRecVATPostinGroup."SSA Column Type"::"ICA Resale Free of VAT":
                            gDecBaseAmount[7] := Base;
                        gRecVATPostinGroup."SSA Column Type"::"ICA Needs Free of VAT":
                            gDecBaseAmount[10] := Base;
                        gRecVATPostinGroup."SSA Column Type"::"ICA Resale Not Taxable":
                            gDecBaseAmount[8] := Base;
                        gRecVATPostinGroup."SSA Column Type"::"ICA Needs Not Taxable":
                            gDecBaseAmount[11] := Base;
                        gRecVATPostinGroup."SSA Column Type"::"Art 150 FC":
                            begin
                                gDecBaseAmount[14] := Base;
                                gDecVATAmount[11] := Amount;
                            end;
                        gRecVATPostinGroup."SSA Column Type"::"Simplified VAT":
                            begin
                                gDecBaseAmount[12] := Base;
                                gDecVATAmount[9] := Amount;
                            end;
                        gRecVATPostinGroup."SSA Column Type"::"ICA Services":
                            begin
                                gDecBaseAmount[17] := Base;
                                gDecVATAmount[10] := Amount;
                            end;
                    end;
                    gDecTotalAmount := gDecBaseAmount[1] + gDecBaseAmount[2] + gDecBaseAmount[3] + gDecBaseAmount[4] +
                      gDecBaseAmount[5] + gDecBaseAmount[6] + gDecBaseAmount[7] + gDecBaseAmount[8] + gDecBaseAmount[9] +
                      gDecBaseAmount[10] + gDecBaseAmount[11] + gDecBaseAmount[12] + gDecBaseAmount[17] +
                      gDecBaseAmount[13] + gDecBaseAmount[14] + gDecBaseAmount[15] + gDecBaseAmount[16] +
                      gDecVATAmount[1] + gDecVATAmount[2] + gDecVATAmount[3] + gDecVATAmount[4] + gDecVATAmount[5] +
                      gDecVATAmount[7] + gDecVATAmount[8] + gDecVATAmount[9] + gDecVATAmount[10] + gDecVATAmount[11] +
                      gDecVATAmount[12] + gDecVATAmount[13];

                    gDecTotalAmount := gDecTotalAmount + gDecBaseAmount[23] + gDecBaseAmount[24] + gDecBaseAmount[25] + gDecBaseAmount[26] +
                      gDecVATAmount[23] + gDecVATAmount[24] + gDecVATAmount[25] + gDecVATAmount[26];

                    if "Unrealized VAT Entry No." <> 0 then begin
                        gDecBaseAmount[22] := Base;
                        gDecVATAmount[22] := Amount;
                        gDecBaseAmount[1] := 0;
                        gDecVATAmount[1] := 0;
                        gDecBaseAmount[2] := 0;
                        gDecVATAmount[2] := 0;
                        gDecBaseAmount[3] := 0;
                        gDecVATAmount[3] := 0;
                        gDecBaseAmount[15] := 0;
                        gDecVATAmount[12] := 0;
                        gDecBaseAmount[21] := 0;
                        gDecVATAmount[21] := 0;
                        gDecBaseAmount[16] := 0;
                        gDecVATAmount[13] := 0;
                        gDecBaseAmount[4] := 0;
                        gDecVATAmount[4] := 0;
                        gDecBaseAmount[5] := 0;
                        gDecVATAmount[5] := 0;
                        gDecTotalAmount := 0;
                        gDecTotalAmountEx := gDecVATAmount[22] + gDecBaseAmount[22];

                        CalcFields("SSA Unrealized Purch. Doc. No.", "SSA Unrealized Document Date");

                        PayNo := "SSA Unrealized Purch. Doc. No." + ' / ' + Format("SSA Unrealized Document Date");
                        DocumentNo1 := "Document No.";
                    end;

                    if "Unrealized Amount" <> 0 then begin
                        gDecBaseAmount[21] := "Unrealized Base" - "SSA Realized Base";
                        gDecVATAmount[21] := "Unrealized Amount" - "SSA Realized Amount";
                        gDecTotalAmount := gDecVATAmount[21] + gDecBaseAmount[21];
                        gDecBaseAmount[22] := 0;
                        gDecVATAmount[22] := 0;
                        gDecTotalAmountEx := 0;
                        gDecBaseAmount[16] := 0;
                        gDecVATAmount[13] := 0;
                        gDecBaseAmount[4] := 0;
                        gDecVATAmount[4] := 0;
                        gDecBaseAmount[5] := 0;
                        gDecVATAmount[5] := 0;
                    end;


                    if (nrdoc <> DocumentNo1) or (PayToSellTo <> "Bill-to/Pay-to No.") then begin
                        CrtNo += 1;
                        nrdoc := DocumentNo1;
                        PayToSellTo := "Bill-to/Pay-to No.";
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
                group(Control70001)
                {
                    ShowCaption = false;
                    field(WithoutNonDeductibleVAT; WithoutNonDeductibleVAT)
                    {
                        Caption = 'Without Non-Deductible VAT';
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

    trigger OnInitReport()
    begin
        gIntRow := 2;
        gIntCol := 0;
    end;

    trigger OnPreReport()
    begin
        gTxtVATFilter := "VAT Entry".GetFilters;

        DateFilt := "VAT Entry".GetRangeMin("Posting Date");

        DateFilt := CalcDate(Text001, DateFilt);
        nrdoc := '';
        Clear(PayToSellTo);
        CompanyInfo.Get();
    end;

    var
        gRecGLE: Record "G/L Entry";
        gRecVendor: Record Vendor;
        gRecVATPostinGroup: Record "VAT Posting Setup";
        VATProductPostingGroup: Record "VAT Product Posting Group";
        gIntCrtNo: Integer;
        gDecTotalAmount: Decimal;
        gDecBaseAmount: array[26] of Decimal;
        gDecVATAmount: array[26] of Decimal;
        gTxtVATFilter: Text[250];
        gTxtVendorName: Text[50];
        gTxtFiscalCode: Text[20];
        gIntRow: Integer;
        gIntCol: Integer;
        gTxcCrtNo: Label 'Nr. Crt';
        gTxcOrderNo: Label 'Nr document';
        gTxcDate: Label 'Data';
        gTxcVendor: Label 'Furnizorul/Prestatorul';
        gTxcRegNo: Label 'Codul de inregistrare in scopuri de T.V.A. al furnizorului/prestatorului';
        gTxcDocAmount: Label 'Total  document (inclusiv T.V.A.)';
        gTxcCapitalGoods: Label 'Capital goods';
        gTxc19: Label 'Cota de 19%';
        gTxc20: Label 'Cota de 20%|5%';
        gTxc9: Label 'Cota de 9%';
        gTxcBaseAmount: Label 'Baza de impozitare';
        gTxcVATAmount: Label 'Valoare T.V.A.';
        gTxcAquisition: Label 'Achizitii de bunuri din tara si din import scutite, alte achizitii neimpozabile in Romania';
        gTxcIntracomAquisition: Label 'Achizitii intracomunitare de bunuri';
        gTxcForResale: Label 'Taxabile';
        gTxcCompanyNeeds: Label 'For company needs';
        gTxcExempt: Label 'Scutite';
        gTxcGoodsServices: Label 'Bunuri si servicii pentru care cumparatorul este obligat la plata taxei cf. art. 160';
        gTxcGoodsServices150: Label 'Bunuri si servicii pentru care cumparatorul este obligat la plata taxei cf. art. 150';
        gTxcPurchaseVAT: Label 'JURNAL PENTRU CUMPARARI';
        gTxcDocument: Label 'Documentul';
        gTxcAquisition2: Label 'Achizitii de bunuri si servicii din tara si importul de bunuri taxabile';
        gTxcFreeVAT: Label 'Neimpozabile';
        gTxcAchizitii: Label 'Achizitii servicii UE';
        gTxcPaymentNo: Label 'Plată la document -  numar/data';
        gTxcValPlat: Label 'Valoarea platita inclusiv TVA';
        gtxcOperatEx: Label 'Operatiuni exigibile';
        gtxcOperatNeex: Label 'Operatiuni neexigibile';
        gDecTotalAmountEx: Decimal;
        DocumentNo1: Text[35];
        PayNo: Text[100];
        DateFilt: Date;
        Text001: Label '<-1D>';
        CrtNo: Integer;
        nrdoc: Code[35];
        PayToSellTo: Code[20];
        WithoutNonDeductibleVAT: Boolean;
        CompanyInfo: Record "Company Information";
}

