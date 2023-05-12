report 71501 "SSA VAT- VIES Declaration"
{
    // SSA974 SSCAT 11.10.2019 40.Rapoarte legale-Declaratia 390
    DefaultLayout = RDLC;
    RDLCLayout = './src/rdlc/SSAVATVIESDeclaration.rdlc';

    Caption = 'VAT- VIES Declaration';
    PreviewMode = PrintLayout;

    dataset
    {
        dataitem("SSA VIES Header"; "SSA VIES Header")
        {
            DataItemTableView = SORTING("No.");
            RequestFilterFields = "No.";
            column(VIES_Declaration_Header_No_; "SSA VIES Header"."No.")
            {
            }
            column(total; "SSA VIES Header"."Amount (LCY)")
            {
            }
            column(RECAPITULATIVECaption; RECAPITULATIVECaptionLbl)
            {
            }
            column(STATEMENT_FOR_INTRA_COMMUNITYCaption; STATEMENT_FOR_INTRA_COMMUNITYCaptionLbl)
            {
            }
            column(SUPPLIES_ACQUISITIONSCaption; SUPPLIES_ACQUISITIONSCaptionLbl)
            {
            }
            column(VIESCaption; VIESCaptionLbl)
            {
            }
            column(V390Caption; V390CaptionLbl)
            {
            }
            dataitem("SSA VIES Line"; "SSA VIES Line")
            {
                DataItemLink = "VIES Declaration No." = FIELD("No.");
                DataItemTableView = SORTING("VAT Registration No.");
                column(VIES_Declaration_Header___Period_No__; "SSA VIES Header"."Period No.")
                {
                }
                column(VIES_Declaration_Header__Year; "SSA VIES Header".Year)
                {
                }
                column(CompanyInfo__Country_Region_Code_; CompanyInfo."Country/Region Code")
                {
                }
                column(CVATRegNo; CVATRegNo)
                {
                }
                column(CompanyInfo__Country_Region_Code__Control1000000022; CompanyInfo."Country/Region Code")
                {
                }
                column(CVATRegNo_Control1000000024; CVATRegNo)
                {
                }
                column(VIES_Declaration_Header__Year_Control1000000026; "SSA VIES Header".Year)
                {
                }
                column(VIES_Declaration_Header___Period_No___Control1000000028; "SSA VIES Header"."Period No.")
                {
                }
                column(FORMAT_SaleToEUCust_0_2_; Format(SaleToEUCust, 0, 2))
                {
                }
                column(VIES_Declaration_Line__Country_Region_Code_; "Country/Region Code")
                {
                }
                column(VATRegNo; VATRegNo)
                {
                }
                column(FORMAT_SaleToEUCust3Party_0_2_; Format(SaleToEUCust3Party, 0, 2))
                {
                }
                column(VATRegNo_Control1000000045; VATRegNo)
                {
                }
                column(VIES_Declaration_Line__Country_Region_Code__Control1000000046; "Country/Region Code")
                {
                }
                column(FORMAT_PurchEuVend_0_2_; Format(PurchEuVend, 0, 2))
                {
                }
                column(VATRegNo_Control1000000051; VATRegNo)
                {
                }
                column(VIES_Declaration_Line__Country_Region_Code__Control1000000052; "Country/Region Code")
                {
                }
                column(VATRegNo_Control1000000055; VATRegNo)
                {
                }
                column(VIES_Declaration_Line__Country_Region_Code__Control1000000056; "Country/Region Code")
                {
                }
                column(FORMAT_SaleServiceToEUCust_0_2_; Format(SaleServiceToEUCust, 0, 2))
                {
                }
                column(VATRegNo_Control1000000061; VATRegNo)
                {
                }
                column(VIES_Declaration_Line__Country_Region_Code__Control1000000062; "Country/Region Code")
                {
                }
                column(FORMAT_PurchServiceEUVend_0_2_; Format(PurchServiceEUVend, 0, 2))
                {
                }
                column(FORMAT_PageTotal_0_2_; Format(PageTotal, 0, 2))
                {
                }
                column(FORMAT_PageTotal_0_2__Control1000000069; Format(PageTotal, 0, 2))
                {
                }
                column(FORMAT_GenTotal_0_2_; Format(GenTotal, 0, 2))
                {
                }
                column(LIST_OF_INTRA_COMMUNITY_TRANSACTIONSCaption; LIST_OF_INTRA_COMMUNITY_TRANSACTIONSCaptionLbl)
                {
                }
                column(MONTHCaption; MONTHCaptionLbl)
                {
                }
                column(YEARCaption; YEARCaptionLbl)
                {
                }
                column(APPENDIX_TO_THE_STATEMENTCaption; APPENDIX_TO_THE_STATEMENTCaptionLbl)
                {
                }
                column(CODECaption; CODECaptionLbl)
                {
                }
                column(COMPANYCaption; COMPANYCaptionLbl)
                {
                }
                column(PAGECaption; PAGECaptionLbl)
                {
                }
                column(COUNTRY_CODECaption; COUNTRY_CODECaptionLbl)
                {
                }
                column(VAT_REGISTRATION_NOCaption; VAT_REGISTRATION_NOCaptionLbl)
                {
                }
                column(NAME_OF_INTRA_COMMUNITY_OPERATORCaption; NAME_OF_INTRA_COMMUNITY_OPERATORCaptionLbl)
                {
                }
                column(TRANSACTION_CODECaption; TRANSACTION_CODECaptionLbl)
                {
                }
                column(AMOUNTCaption; AMOUNTCaptionLbl)
                {
                }
                column(COMPANYCaption_Control1000000019; COMPANYCaption_Control1000000019Lbl)
                {
                }
                column(PAGECaption_Control1000000020; PAGECaption_Control1000000020Lbl)
                {
                }
                column(CODECaption_Control1000000023; CODECaption_Control1000000023Lbl)
                {
                }
                column(YEARCaption_Control1000000025; YEARCaption_Control1000000025Lbl)
                {
                }
                column(MONTHCaption_Control1000000027; MONTHCaption_Control1000000027Lbl)
                {
                }
                column(AMOUNTCaption_Control1000000031; AMOUNTCaption_Control1000000031Lbl)
                {
                }
                column(TRANSACTION_CODECaption_Control1000000032; TRANSACTION_CODECaption_Control1000000032Lbl)
                {
                }
                column(NAME_OF_INTRA_COMMUNITY_OPERATORCaption_Control1000000033; NAME_OF_INTRA_COMMUNITY_OPERATORCaption_Control1000000033Lbl)
                {
                }
                column(VAT_REGISTRATION_NOCaption_Control1000000034; VAT_REGISTRATION_NOCaption_Control1000000034Lbl)
                {
                }
                column(COUNTRY_CODECaption_Control1000000035; COUNTRY_CODECaption_Control1000000035Lbl)
                {
                }
                column(LCaption; LCaptionLbl)
                {
                }
                column(TCaption; TCaptionLbl)
                {
                }
                column(ACaption; ACaptionLbl)
                {
                }
                column(PCaption; PCaptionLbl)
                {
                }
                column(SCaption; SCaptionLbl)
                {
                }
                column(PAGE_TOTALCaption; PAGE_TOTALCaptionLbl)
                {
                }
                column(PAGE_TOTALCaption_Control1000000068; PAGE_TOTALCaption_Control1000000068Lbl)
                {
                }
                column(GENERAL_TOTALCaption; GENERAL_TOTALCaptionLbl)
                {
                }
                column(VIES_Declaration_Line_VIES_Declaration_No_; "VIES Declaration No.")
                {
                }
                column(VIES_Declaration_Line_Line_No_; "Line No.")
                {
                }
                column(custvendname; custvendname)
                {
                }
                column(custvendnamebun; "SSA VIES Line"."Cust/Vend Name")
                {
                }
                column(transtype; transtype)
                {
                }
                column(suma; suma)
                {
                }
                column(T_P; Total_P)
                {
                }
                column(T_S; Total_S)
                {
                }
                column(T_T; Total_T)
                {
                }
                column(T_L; Total_L)
                {
                }
                column(T_A; Total_A)
                {
                }
                column(total_general; Total_total)
                {
                }

                trigger OnAfterGetRecord()
                var
                    TaxGroup: Record "Tax Group";
                    OldTransType: Text[30];
                begin
                    VATRegNo := DelCountryCode("Country/Region Code", "VAT Registration No.");
                    if Country.Get("SSA VIES Line"."Country/Region Code") then;
                    if not CustomOper.Get("VAT Registration No.") then begin
                        CustomOper.Init;
                        CustomOper."No." := "VAT Registration No.";
                        CustomOper.Insert;
                    end;

                    clear(suma);
                    Total_total := 0;
                    Clear(SalesR);
                    clear(SaleToEUCust);
                    clear(SaleServiceToEUCust);
                    clear(SaleToEUCust3Party);
                    clear(PurchServiceEUVend);
                    clear(PurchEuVend);

                    if "Trade Type" = "Trade Type"::Sale then begin
                        if "EU Service" then begin
                            SaleServiceToEUCust := "Amount (LCY)";
                            transtype := 'P';
                        end else
                            if "EU 3-Party Trade" then begin
                                SaleToEUCust3Party := "Amount (LCY)";
                                transtype := 'T';
                            end else begin
                                if TaxGroup.get("Tax Group Code") and (TaxGroup."SSA 390 Type" = TaxGroup."SSA 390 Type"::"Special Agriculture 390") then begin
                                    SalesR := ("Amount (LCY)");
                                    transtype := 'R';
                                end else begin
                                    SaleToEUCust := "Amount (LCY)";
                                    transtype := 'L';
                                end;
                            end;

                    end else begin
                        if "EU Service" then begin
                            PurchServiceEUVend := -"Amount (LCY)";
                            transtype := 'S';
                        end else begin
                            PurchEuVend := -"Amount (LCY)";
                            transtype := 'A';
                        end;
                    end;

                    SaleToEUCust := Round(SaleToEUCust, 1);
                    Supplies := Supplies + SaleToEUCust;

                    SaleToEUCust3Party := Round(SaleToEUCust3Party, 1);
                    Supplies3Party := Supplies3Party + SaleToEUCust3Party;

                    PurchEuVend := Round(PurchEuVend, 1);
                    Acquis := Acquis + PurchEuVend;

                    SaleServiceToEUCust := Round(SaleServiceToEUCust, 1);
                    SuppliesService := SuppliesService + SaleServiceToEUCust;

                    PurchServiceEUVend := Round(PurchServiceEUVend, 1);
                    AcquisService := AcquisService + PurchServiceEUVend;

                    SalesR := Round(SalesR, 1);
                    Total_R += SalesR;

                    if SalesR <> 0 then
                        suma := SalesR;

                    if SaleToEUCust <> 0 then begin
                        suma := SaleToEUCust;
                        Total_L := Total_L + suma;
                    end;

                    if SaleToEUCust3Party <> 0 then begin
                        suma := SaleToEUCust3Party;
                        Total_T := Total_T + suma;
                    end;

                    if PurchEuVend <> 0 then begin
                        suma := PurchEuVend;
                        Total_A := Total_A + suma;
                    end;

                    if SaleServiceToEUCust <> 0 then begin
                        suma := SaleServiceToEUCust;
                        Total_P := Total_P + suma;
                    end;

                    if PurchServiceEUVend <> 0 then begin
                        suma := PurchServiceEUVend;
                        Total_S := Total_S + suma;
                    end;
                    Total_total := Total_A + Total_S - Total_L - Total_P - Total_T + Total_R;

                    if (oldvatregno <> VATRegNo) or (OldTransType <> transtype) then begin
                        if (transtype <> '') and (suma <> 0) and (Country."EU Country/Region Code" <> '') then begin
                            if ItemTemp.Get(VATRegNo) then begin
                                //CustomerTemp."No." := VATRegNo;
                                ItemTemp."Unit Price" := ItemTemp."Unit Price" + SaleToEUCust; //L
                                ItemTemp."Unit Cost" := ItemTemp."Unit Cost" + SaleToEUCust3Party; //T
                                ItemTemp."Standard Cost" := ItemTemp."Standard Cost" + PurchEuVend; //A
                                ItemTemp."Last Direct Cost" := ItemTemp."Last Direct Cost" + SaleServiceToEUCust; //P
                                ItemTemp."Unit List Price" := ItemTemp."Unit List Price" + PurchServiceEUVend; //S
                                ItemTemp."Gross Weight" += SalesR; //R
                                ItemTemp.Modify;
                            end else begin
                                ItemTemp.Init;
                                ItemTemp."No." := VATRegNo;
                                ItemTemp.Description := custvendname;
                                ItemTemp."Description 2" := Country."EU Country/Region Code";
                                ItemTemp."Unit Price" := SaleToEUCust; //L
                                ItemTemp."Unit Cost" := SaleToEUCust3Party; //T
                                ItemTemp."Standard Cost" := PurchEuVend; //A
                                ItemTemp."Last Direct Cost" := SaleServiceToEUCust; //P
                                ItemTemp."Unit List Price" := PurchServiceEUVend; //S
                                ItemTemp."Gross Weight" := SalesR; //R
                                ItemTemp.Insert;

                            end;
                        end;

                        VrCrName := "SSA VIES Line"."Cust/Vend Name";
                        Position0 := StrPos(VrCrName, '"');

                        if (Position0 <> 0) then begin
                            VrCrName := DelChr(VrCrName, '=', '"');
                            VrCrName := InsStr(VrCrName, '&quot;', Position0);
                        end;

                        Position1 := StrPos(VrCrName, '&');

                        if (Position1 <> 0) then
                            VrCrName := InsStr(VrCrName, 'amp;', Position1 + 1);

                        Position2 := StrPos(VrCrName, Text010);
                        if Position2 <> 0 then begin
                            VrCrName := DelChr(VrCrName, '=', Text010);
                            VrCrName := InsStr(VrCrName, '&apos;', Position2);

                        end;

                        if (transtype <> '') and (suma <> 0) and (Country."EU Country/Region Code" <> '') then begin
                            if CreateXmlFile then begin
                                StringToFile := '<operatie tip="' + Format(transtype) + '" tara="' + Format(Country."EU Country/Region Code") + '" codO="' +
                                             Format(VATRegNo) + '" denO="' + Format(VrCrName) + '" baza="' + Format(suma, 0, 2) + '" />';
                                TempFile.Write(StringToFile);
                            end;
                        end;
                        oldvatregno := VATRegNo;
                        OldTransType := TransType;
                    end;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                FormatAddr.FormatAddr(ViesDeclAddr, CopyStr(Name, 1, 90), "Name 2", '', Street, CopyStr(DelChr("House No.", '<>', ' ') +
                  DelChr("Apartment No.", '<>', ' '), 1, 50), City, "Post Code", County, CompanyInfo."Country/Region Code");

                "SSA VIES Header".CalcFields("Number of Lines", "Number of Supplies");

                if "Declaration Type" = "Declaration Type"::Normal then begin
                    DeclarationNormal := 'X';
                    DeclarationCorrective := ''
                end else begin
                    DeclarationNormal := '';
                    DeclarationCorrective := 'X'
                end
            end;

            trigger OnPreDataItem()
            begin
                CompanyInfo.Get;
            end;
        }
        dataitem("Integer"; "Integer")
        {
            DataItemTableView = SORTING(Number) WHERE(Number = CONST(1));
            column(Nume_companie; CompanyInfo.Name)
            {
            }
            column(CompanyInfo__Fax_No__; CompanyInfo."Fax No.")
            {
            }
            column(CompanyInfo__E_Mail_; CompanyInfo."E-Mail")
            {
            }
            column(CompsnyInfo_Anaflogo; SSASetup."SSA ANAF Logo")
            {
            }
            column(StatReportingSetup__House_No__; StatReportingSetup."SSA House No.")
            {
            }
            column(StatReportingSetup_Street; StatReportingSetup."SSA Street")
            {
            }
            column(CompanyInfo_City; CompanyInfo.City)
            {
            }
            column(CompanyInfo__Phone_No__; CompanyInfo."Phone No.")
            {
            }
            column(StatReportingSetup_Sector; SSASetup."SSA Sector")
            {
            }
            column(CompanyInfo_County; CompanyInfo.County)
            {
            }
            column(CompanyInfo__Post_Code_; CompanyInfo."Post Code")
            {
            }
            column(CompanyInfo_Name; CompanyInfo.Name)
            {
            }
            column(VIES_Declaration_Header__Year_Control1000000093; "SSA VIES Header".Year)
            {
            }
            column(VIES_Declaration_Header___Period_No___Control1000000095; "SSA VIES Header"."Period No.")
            {
            }
            column(FORMAT_Acquis_0_2_; Format(Acquis, 0, 2))
            {
            }
            column(VIES_Declaration_Header___Number_of_Lines_; "SSA VIES Header"."Number of Lines")
            {
            }
            column(FORMAT_Supplies_0_2_; Format(Supplies, 0, 2))
            {
            }
            column(FORMAT_Supplies3Party_0_2_; Format(Supplies3Party, 0, 2))
            {
            }
            column(StatReportingSetup_Building; SSASetup."SSA Building")
            {
            }
            column(StatReportingSetup__Apartment_No__; SSASetup."SSA Apartment No.")
            {
            }
            column(StatReportingSetup_Floor; SSASetup."SSA Floor")
            {
            }
            column(StatReportingSetup_Unit; SSASetup."SSA Unit")
            {
            }
            column(FORMAT__VIES_Declaration_Header___Number_of_Supplies__0_2_; Format("SSA VIES Header"."Number of Supplies", 0, 2))
            {
            }
            column(CVATRegNo_Control1000000142; CVATRegNo)
            {
            }
            column(CompanyInfo__Country_Region_Code__Control1000000143; CompanyInfo."Country/Region Code")
            {
            }
            column(FORMAT_SuppliesService_0_2_; Format(SuppliesService, 0, 2))
            {
            }
            column(FORMAT_AcquisService_0_2_; Format(AcquisService, 0, 2))
            {
            }
            column(DeclarationNormal; DeclarationNormal)
            {
            }
            column(DeclarationCorrective; DeclarationCorrective)
            {
            }
            column(APCaption; APCaptionLbl)
            {
            }
            column(BLCaption; BLCaptionLbl)
            {
            }
            column(FAXCaption; FAXCaptionLbl)
            {
            }
            column(NOCaption; NOCaptionLbl)
            {
            }
            column(SECTORCaption; SECTORCaptionLbl)
            {
            }
            column(ETCaption; ETCaptionLbl)
            {
            }
            column(VAT_REGISTRATION_NOCaption_Control1000000088; VAT_REGISTRATION_NOCaption_Control1000000088Lbl)
            {
            }
            column(INITIAL_DECLARATIONCaption; INITIAL_DECLARATIONCaptionLbl)
            {
            }
            column(CORRECTIVE_DECLARATIONCaption; CORRECTIVE_DECLARATIONCaptionLbl)
            {
            }
            column(DECLARATION_TYPECaption; DECLARATION_TYPECaptionLbl)
            {
            }
            column(MONTHCaption_Control1000000094; MONTHCaption_Control1000000094Lbl)
            {
            }
            column(FISCAL_ADDRESSCaption; FISCAL_ADDRESSCaptionLbl)
            {
            }
            column(COUNTYCaption; COUNTYCaptionLbl)
            {
            }
            column(CITY_TOWNCaption; CITY_TOWNCaptionLbl)
            {
            }
            column(POST_CODECaption; POST_CODECaptionLbl)
            {
            }
            column(STREETCaption; STREETCaptionLbl)
            {
            }
            column(SCCaption; SCCaptionLbl)
            {
            }
            column(PHONECaption; PHONECaptionLbl)
            {
            }
            column(E_MAILCaption; E_MAILCaptionLbl)
            {
            }
            column(REPORTING_PERIODCaption; REPORTING_PERIODCaptionLbl)
            {
            }
            column(YEARCaption_Control1000000107; YEARCaption_Control1000000107Lbl)
            {
            }
            column(NAMECaption; NAMECaptionLbl)
            {
            }
            column(IDENTIFICATION_DATACaption; IDENTIFICATION_DATACaptionLbl)
            {
            }
            column(SUMMARY_OF_STATEMENTCaption; SUMMARY_OF_STATEMENTCaptionLbl)
            {
            }
            column(TOTAL_NO_OF_ANNEXES_TO_THE_DECLARATIONCaption; TOTAL_NO_OF_ANNEXES_TO_THE_DECLARATIONCaptionLbl)
            {
            }
            column(TOTAL_NUMBER_OF_INTRA_COMMUNITY_OPERATORSCaption; TOTAL_NUMBER_OF_INTRA_COMMUNITY_OPERATORSCaptionLbl)
            {
            }
            column(TOTAL_OF_INTRA_COMMUNITY_SUPPLIES_ACQUISITIONS_OF_GOODS_SERVICECaption; TOTAL_OF_INTRA_COMMUNITY_SUPPLIES_ACQUISITIONS_OF_GOODS_SERVICECaptionLbl)
            {
            }
            column(SUPPLIES_OF_GOODSCaption; SUPPLIES_OF_GOODSCaptionLbl)
            {
            }
            column(ACQUISITIONS_OF_GOODSCaption; ACQUISITIONS_OF_GOODSCaptionLbl)
            {
            }
            column(SUPPLIES_OF_GOODS_IN_A_TRIANGULATION_SCHEMECaption; SUPPLIES_OF_GOODS_IN_A_TRIANGULATION_SCHEMECaptionLbl)
            {
            }
            column(Under_the_penalties_of_law__I_declare_that_the_data_in_this_form_are_correct_and_completeCaption; Under_the_penalties_of_law__I_declare_that_the_data_in_this_form_are_correct_and_completeCaptionLbl)
            {
            }
            column(Name_of_the_responsible_personCaption; Name_of_the_responsible_personCaptionLbl)
            {
            }
            column(PositionCaption; PositionCaptionLbl)
            {
            }
            column(SignatureCaption; SignatureCaptionLbl)
            {
            }
            column(For_the_fiscal_authorities_useCaption; For_the_fiscal_authorities_useCaptionLbl)
            {
            }
            column(Registration_NoCaption; Registration_NoCaptionLbl)
            {
            }
            column(Registration_DateCaption; Registration_DateCaptionLbl)
            {
            }
            column(StampCaption; StampCaptionLbl)
            {
            }
            column(SUPPLIES_OF_SERVICESCaption; SUPPLIES_OF_SERVICESCaptionLbl)
            {
            }
            column(ACQUISITIONS_OF_SERVICESCaption; ACQUISITIONS_OF_SERVICESCaptionLbl)
            {
            }
            column(Integer_Number; Number)
            {
            }
            column(Fiscal_LBL; For_the_fiscal_authorities_useCaptionLbl)
            {
            }
            column(nume_; FirstName)
            {
            }
            column(pozitie_; Position)
            {
            }
            column(prenume_; LastName)
            {
            }
            column(MONTHCaptionn; MONTHCaptionLbl)
            {
            }
            column(YEARCaptionn; YEARCaptionLbl)
            {
            }
            column(numarpag; nrpag)
            {
            }
            column(Total_R; Total_R)
            {

            }

            trigger OnAfterGetRecord()
            begin
                CurrReport.NewPage;
            end;

            trigger OnPreDataItem()
            begin
                nrpag := CurrReport.PageNo - 1;
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(FirstName; FirstName)
                    {
                        Caption = 'First Name';
                    }
                    field(LastName; LastName)
                    {
                        Caption = 'Last Name';
                    }
                    field(Position; Position)
                    {
                        Caption = 'Job Title';
                    }
                    field(CreateXmlFile; CreateXmlFile)
                    {
                        Caption = 'Export to XML File';
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
        CompanyInfo.Get;
        SSASetup.Get;
        CVATRegNo := DelCountryCode(CompanyInfo."Country/Region Code", CompanyInfo."VAT Registration No.");
        StatReportingSetup.Get;
    end;

    trigger OnPostReport()
    begin

        nrOPI := 0;
        if ItemTemp.FindFirst then begin
            repeat
                if (ItemTemp."Unit Price" <> 0) then begin
                    nrOPI := nrOPI + 1;
                    BazaL := BazaL + ItemTemp."Unit Price";
                end;

                if ItemTemp."Unit Cost" <> 0 then begin
                    nrOPI := nrOPI + 1;
                    BazaT := BazaT + ItemTemp."Unit Cost";
                end;

                if ItemTemp."Standard Cost" <> 0 then begin
                    nrOPI := nrOPI + 1;
                    BazaA := BazaA + ItemTemp."Standard Cost";
                end;

                if ItemTemp."Last Direct Cost" <> 0 then begin
                    nrOPI := nrOPI + 1;
                    BazaP := BazaP + ItemTemp."Last Direct Cost";
                end;

                if ItemTemp."Unit List Price" <> 0 then begin
                    nrOPI := nrOPI + 1;
                    BazaS := BazaS + ItemTemp."Unit List Price";
                end;

                if ItemTemp."Gross Weight" <> 0 then begin
                    nrOPI += 1;
                    BazaR += ItemTemp."Gross Weight";
                end;

            until ItemTemp.Next = 0;

        end;
        totalbaza := BazaA + BazaT + BazaL + BazaP + BazaS + BazaR;
        totalA := totalbaza + nrOPI;

        CustomOper.Reset;
        TotalNoOper1 := CustomOper.Count;
        if CreateXmlFile then begin

            OutFile.Create(FileName);
            OutFile.TextMode(true);

            StringToFile := '<?xml version="1.0" ?>';
            OutFile.Write(StringToFile);
            if drec then begin
                drecc := 1;
            end else begin
                drecc := 0;
            end;


            StringToFile := '<declaratie390 luna="' + Format("SSA VIES Header"."Period No.") + '" an="' + Format("SSA VIES Header".Year) + '" d_rec="' + Format(drecc) + '"' + ' nume_declar="' +
                           Format(LastName) + '"' + ' prenume_declar="' + Format(FirstName) + '"' + ' functie_declar="' + Format(Position) + '"' + ' cui="' +
                           Format(CVATRegNo) + '"' + ' den="' +
                           Format(CompanyInfo.Name) + '"' + ' adresa="' + Format(CompanyInfo.Address) + '"' + ' totalPlata_A="' + Format(totalA, 0, 2) + '"' +
                           ' xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"' +
                           ' xsi:schemaLocation="mfp:anaf:dgti:d390:declaratie:v3 D390.xsd"' +
                           ' xmlns="mfp:anaf:dgti:d390:declaratie:v3">';

            OutFile.Write(StringToFile);


            StringToFile := '<rezumat nr_pag="' + Format(nrpag) + '" nrOPI="' + Format(nrOPI, 0, 2) + '" bazaL="' +
                              Format(BazaL, 0, 2) + '" bazaT="' + Format(BazaT, 0, 2) + '" bazaA="' +
                              Format(BazaA, 0, 2) + '" bazaP="' + Format(BazaP, 0, 2) +
                              '" bazaS="' + Format(BazaS, 0, 2) +
                              '" bazaR="' + Format(BazaR, 0, 2) +
                              '" total_baza="' + Format(totalbaza, 0, 2) + '" />';
            OutFile.Write(StringToFile);

            TempFile.Seek(0);
            TempFile.TextMode(true);
            FileLength := TempFile.Len;

            while FileLength > TempFile.Pos do begin
                TempFile.Read(StringToFile);
                OutFile.Write(StringToFile)
            end;
            StringToFile := '</declaratie390>';
            OutFile.Write(StringToFile);

            TempFile.Close;
            Erase(FileName + 'temp');
            OutFile.Close;

        end;

        if CreateXmlFile then begin
            ToFile := DefaultFileNameTxt + '.xml';
            Download(FileName, Text011, '', FileTypeFilterTxt, ToFile);
        end;
    end;

    trigger OnPreReport()
    begin
        SaleToEUCust := 0;
        SaleToEUCust3Party := 0;
        SaleServiceToEUCust := 0;
        PurchEuVend := 0;
        PurchServiceEUVend := 0;
        if CreateXmlFile then begin
            FileName := TierMgt.ServerTempFileName('');

            OutFile.Create(FileName);
            OutFile.Close;
            OutFile.WriteMode := true;
            OutFile.TextMode := true;

            TempFile.Create(FileName + 'temp');
            TempFile.Close;
            TempFile.WriteMode := true;
            TempFile.TextMode(true);
            TempFile.Open(FileName + 'temp');
        end;
    end;

    var
        SSASetup: Record "SSA Localization Setup";
        CompanyInfo: Record "Company Information";
        StatReportingSetup: Record "SSA Localization Setup";
        Country: Record "Country/Region";
        Text001: Label '<M-1M>';
        Text002: Label '<M-1D>';
        Text003: Label '%1 is not filled in for some VAT entries. Do you really want to print?';
        FormatAddr: Codeunit "Format Address";
        ErrorText: Text[100];
        CVATRegNo: Text[30];
        VATRegNo: Text[30];
        Text004: Label 'Export to Text File';
        Text005: Label 'TXT Files (*.txt)|*.txt|All Files (*.*)|*.*';
        Text006: Label 'Please enter the file name.';
        Text007: Label 'Please enter the year.';
        ViesDeclAddr: array[8] of Text[50];
        Text000: Label 'Page %1';
        SaleToEUCust: Decimal;
        SaleToEUCust3Party: Decimal;
        SaleServiceToEUCust: Decimal;
        PurchServiceEUVend: Decimal;
        PurchEuVend: Decimal;
        Supplies: Decimal;
        Supplies3Party: Decimal;
        SuppliesService: Decimal;
        AcquisService: Decimal;
        Acquis: Decimal;
        PageTotal: Decimal;
        GenTotal: Decimal;
        DeclarationNormal: Code[1];
        DeclarationCorrective: Code[1];
        LIST_OF_INTRA_COMMUNITY_TRANSACTIONSCaptionLbl: Label 'LIST OF INTRA-COMMUNITY TRANSACTIONS';
        MONTHCaptionLbl: Label 'MONTH';
        YEARCaptionLbl: Label 'YEAR';
        APPENDIX_TO_THE_STATEMENTCaptionLbl: Label 'APPENDIX TO THE STATEMENT';
        CODECaptionLbl: Label 'CODE';
        COMPANYCaptionLbl: Label 'COMPANY';
        PAGECaptionLbl: Label 'PAGE';
        COUNTRY_CODECaptionLbl: Label 'COUNTRY CODE';
        VAT_REGISTRATION_NOCaptionLbl: Label 'VAT REGISTRATION NO';
        NAME_OF_INTRA_COMMUNITY_OPERATORCaptionLbl: Label 'NAME OF INTRA-COMMUNITY OPERATOR';
        TRANSACTION_CODECaptionLbl: Label 'TRANSACTION CODE';
        AMOUNTCaptionLbl: Label 'AMOUNT';
        COMPANYCaption_Control1000000019Lbl: Label 'COMPANY';
        PAGECaption_Control1000000020Lbl: Label 'PAGE';
        CODECaption_Control1000000023Lbl: Label 'CODE';
        YEARCaption_Control1000000025Lbl: Label 'YEAR';
        MONTHCaption_Control1000000027Lbl: Label 'MONTH';
        AMOUNTCaption_Control1000000031Lbl: Label 'AMOUNT';
        TRANSACTION_CODECaption_Control1000000032Lbl: Label 'TRANSACTION CODE';
        NAME_OF_INTRA_COMMUNITY_OPERATORCaption_Control1000000033Lbl: Label 'NAME OF INTRA-COMMUNITY OPERATOR';
        VAT_REGISTRATION_NOCaption_Control1000000034Lbl: Label 'VAT REGISTRATION NO';
        COUNTRY_CODECaption_Control1000000035Lbl: Label 'COUNTRY CODE';
        LCaptionLbl: Label 'L';
        TCaptionLbl: Label 'T';
        ACaptionLbl: Label 'A';
        PCaptionLbl: Label 'P';
        SCaptionLbl: Label 'S';
        PAGE_TOTALCaptionLbl: Label 'PAGE TOTAL';
        PAGE_TOTALCaption_Control1000000068Lbl: Label 'PAGE TOTAL';
        GENERAL_TOTALCaptionLbl: Label 'GENERAL TOTAL';
        APCaptionLbl: Label 'AP';
        BLCaptionLbl: Label 'BL';
        FAXCaptionLbl: Label 'FAX';
        NOCaptionLbl: Label 'No.';
        SECTORCaptionLbl: Label 'SECTOR';
        ETCaptionLbl: Label 'ET';
        VAT_REGISTRATION_NOCaption_Control1000000088Lbl: Label 'VAT REGISTRATION NO';
        INITIAL_DECLARATIONCaptionLbl: Label 'INITIAL DECLARATION';
        CORRECTIVE_DECLARATIONCaptionLbl: Label 'CORRECTIVE DECLARATION';
        DECLARATION_TYPECaptionLbl: Label 'DECLARATION TYPE';
        MONTHCaption_Control1000000094Lbl: Label 'MONTH';
        FISCAL_ADDRESSCaptionLbl: Label 'FISCAL ADDRESS';
        COUNTYCaptionLbl: Label 'COUNTY';
        CITY_TOWNCaptionLbl: Label 'CITY/TOWN';
        POST_CODECaptionLbl: Label 'POST CODE';
        STREETCaptionLbl: Label 'STREET';
        SCCaptionLbl: Label 'SC';
        PHONECaptionLbl: Label 'PHONE';
        E_MAILCaptionLbl: Label 'E-MAIL';
        REPORTING_PERIODCaptionLbl: Label 'REPORTING PERIOD';
        SUPPLIES_ACQUISITIONSCaptionLbl: Label 'SUPPLIES/ACQUISITIONS';
        VIESCaptionLbl: Label 'VIES';
        YEARCaption_Control1000000107Lbl: Label 'YEAR';
        NAMECaptionLbl: Label 'NAME';
        STATEMENT_FOR_INTRA_COMMUNITYCaptionLbl: Label 'STATEMENT FOR INTRA-COMMUNITY';
        V390CaptionLbl: Label '390';
        RECAPITULATIVECaptionLbl: Label 'RECAPITULATIVE';
        IDENTIFICATION_DATACaptionLbl: Label 'IDENTIFICATION DATA';
        SUMMARY_OF_STATEMENTCaptionLbl: Label 'SUMMARY OF STATEMENT';
        TOTAL_NO_OF_ANNEXES_TO_THE_DECLARATIONCaptionLbl: Label 'TOTAL NO OF ANNEXES TO THE DECLARATION';
        TOTAL_NUMBER_OF_INTRA_COMMUNITY_OPERATORSCaptionLbl: Label 'TOTAL NUMBER OF INTRA-COMMUNITY OPERATORS';
        TOTAL_OF_INTRA_COMMUNITY_SUPPLIES_ACQUISITIONS_OF_GOODS_SERVICECaptionLbl: Label 'TOTAL OF INTRA-COMMUNITY SUPPLIES/ACQUISITIONS OF GOODS/SERVICE';
        SUPPLIES_OF_GOODSCaptionLbl: Label 'SUPPLIES OF GOODS';
        ACQUISITIONS_OF_GOODSCaptionLbl: Label 'ACQUISITIONS OF GOODS';
        SUPPLIES_OF_GOODS_IN_A_TRIANGULATION_SCHEMECaptionLbl: Label 'SUPPLIES OF GOODS IN A TRIANGULATION SCHEME';
        Under_the_penalties_of_law__I_declare_that_the_data_in_this_form_are_correct_and_completeCaptionLbl: Label 'Under the penalties of law, I declare that the data in this form are correct and complete';
        Name_of_the_responsible_personCaptionLbl: Label 'Name of the responsible person';
        PositionCaptionLbl: Label 'Position';
        SignatureCaptionLbl: Label 'Signature';
        For_the_fiscal_authorities_useCaptionLbl: Label 'For the fiscal authorities use';
        Registration_NoCaptionLbl: Label 'Registration No';
        Registration_DateCaptionLbl: Label 'Registration Date';
        StampCaptionLbl: Label 'Stamp';
        SUPPLIES_OF_SERVICESCaptionLbl: Label 'SUPPLIES OF SERVICES';
        ACQUISITIONS_OF_SERVICESCaptionLbl: Label 'ACQUISITIONS OF SERVICES';
        custvendname: Text[250];
        transtype: Text[30];
        suma: Decimal;
        TierMgt: Codeunit "File Management";
        ToFile: Text[1024];
        CreateXmlFile: Boolean;
        FirstName: Text[50];
        LastName: Text[50];
        Position: Text[100];
        FileName: Text[250];
        OutFile: File;
        TempFile: File;
        StringToFile: Text;
        DefaultFileNameTxt: Label 'Default';
        Text011: Label 'Export to XML File';
        FileTypeFilterTxt: Label 'XML Files (*.xml)|*.xml|All Files (*.*)|*.*';
        ItemTemp: Record Item temporary;
        VrCrName: Text[300];
        Position0: Integer;
        Position1: Integer;
        Position2: Integer;
        Text010: Label '''';
        nrOPI: Integer;
        BazaA: Decimal;
        BazaT: Decimal;
        BazaL: Decimal;
        BazaP: Decimal;
        BazaS: Decimal;
        totalbaza: Decimal;
        totalA: Decimal;
        TotalNoOper1: Integer;
        CustomOper: Record Customer temporary;
        drec: Boolean;
        drecc: Integer;
        nrpag: Integer;
        FileLength: Decimal;
        oldvatregno: Code[30];
        Total_A: Decimal;
        Total_L: Decimal;
        Total_T: Decimal;
        Total_P: Decimal;
        Total_S: Decimal;
        Total_total: Decimal;
        BazaR: Decimal;
        SalesR: Decimal;
        Total_R: Decimal;

    local
    procedure DelCountryCode(CountryCode: Text[10]; VATRegNo: Text[30]): Text[30]
    begin
        if CountryCode = CopyStr(VATRegNo, 1, 2) then
            exit(DelStr(VATRegNo, 1, 2))
        else
            exit(VATRegNo);
    end;

    local
    procedure UpdateFileName()
    begin
        FileName := '390_' + Format("SSA VIES Header"."Period No.") + CopyStr(Format("SSA VIES Header".Year), 3, 2) + '_J' +
                    CVATRegNo + '.xml';
    end;
}

