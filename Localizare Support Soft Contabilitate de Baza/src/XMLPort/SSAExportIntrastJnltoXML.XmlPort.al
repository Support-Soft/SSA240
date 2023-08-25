xmlport 70001 "SSAExport Intrast Jnl to XML"
{
    Caption = 'Export Intrastat Jnl to XML';
    Direction = Export;
    UseRequestPage = true;

    schema
    {
        textelement(root)
        {
            XmlName = 'InsNewDispatch';
            textelement(InsCodeVersions)
            {
                textelement(CountryVer)
                {

                    trigger OnBeforePassVariable()
                    begin
                        CountryVer := VerCountry;
                    end;
                }
                textelement(EuCountryVer)
                {

                    trigger OnBeforePassVariable()
                    begin
                        EuCountryVer := VerEuCountry
                    end;
                }
                textelement(CnVer)
                {

                    trigger OnBeforePassVariable()
                    begin
                        CnVer := VerCn
                    end;
                }
                textelement(ModeOfTransportVer)
                {

                    trigger OnBeforePassVariable()
                    begin
                        ModeOfTransportVer := VerModeOfTransport
                    end;
                }
                textelement(DeliveryTermsVer)
                {

                    trigger OnBeforePassVariable()
                    begin
                        DeliveryTermsVer := VerDeliveryTerms;
                    end;
                }
                textelement(NatureOfTransactionAVer)
                {

                    trigger OnBeforePassVariable()
                    begin
                        NatureOfTransactionAVer := VerNatureOfTransactionA;
                    end;
                }
                textelement(NatureOfTransactionBVer)
                {

                    trigger OnBeforePassVariable()
                    begin
                        NatureOfTransactionBVer := VerNatureOfTransactionB;
                    end;
                }
                textelement(CountyVer)
                {

                    trigger OnBeforePassVariable()
                    begin
                        CountyVer := VerCounty;
                    end;
                }
                textelement(LocalityVer)
                {

                    trigger OnBeforePassVariable()
                    begin
                        LocalityVer := VerLocality;
                    end;
                }
                textelement(UnitVer)
                {

                    trigger OnBeforePassVariable()
                    begin
                        UnitVer := VerUnit;
                    end;
                }
            }
            tableelement("Company Information"; "Company Information")
            {
                XmlName = 'InsDeclarationHeader';
                fieldelement(VatNr; "Company Information"."VAT Registration No.")
                {
                }
                fieldelement(FirmName; "Company Information".Name)
                {
                }
                textelement(refperiod)
                {
                    XmlName = 'RefPeriod';

                    trigger OnBeforePassVariable()
                    begin
                        if IntrastatJnlBatch.Get(Template, Batch) then begin
                            if IntrastatJnlBatch."Statistics Period" = '' then
                                Error(Text010, IntrastatJnlBatch.FieldCaption("Statistics Period"),
                                              IntrastatJnlLine.FieldCaption("Journal Batch Name"),
                                              IntrastatJnlBatch.Name);
                            Year := CopyStr(IntrastatJnlBatch."Statistics Period", 1, 2);
                            Month := CopyStr(IntrastatJnlBatch."Statistics Period", 3, 2);
                            RefPeriod := '20' + Year + '-' + Month;
                        end;
                    end;
                }
                textelement(createdt)
                {
                    XmlName = 'CreateDt';

                    trigger OnBeforePassVariable()
                    begin
                        CreateDt := Format(CreateDate);
                    end;
                }
                textelement(ApplicationRef)
                {

                    trigger OnBeforePassVariable()
                    begin
                        ApplicationRef := Text003 + ' ' + ApplicationManagement.OriginalApplicationVersion;
                    end;
                }
                tableelement(Contact; Contact)
                {
                    XmlName = 'ContactPerson';
                    textelement(respprsnlastname)
                    {
                        XmlName = 'LastName';
                    }
                    textelement(respprsnfirstname)
                    {
                        XmlName = 'FirstName';
                    }
                    textelement(respprsnemail)
                    {
                        XmlName = 'Email';
                    }
                    textelement(respprsnphoneno)
                    {
                        XmlName = 'PhoneNo';
                    }
                    textelement(respprsnfax)
                    {
                        XmlName = 'Fax';
                    }
                    textelement(respprsnposition)
                    {
                        XmlName = 'Position';
                    }
                }
            }
            tableelement("Intrastat Jnl. Line"; "Intrastat Jnl. Line")
            {
                XmlName = 'InsDispatchItem';
                SourceTableView = sorting("Journal Template Name", "Journal Batch Name", "Line No.") where("Journal Template Name" = filter('TEMPLATE'), "Journal Batch Name" = filter('BATCH'));
                textelement(OrderNr)
                {

                    trigger OnBeforePassVariable()
                    begin
                        NrCrt += 1;
                        OrderNr := Format(NrCrt);
                    end;
                }
                fieldelement(Cn8Code; "Intrastat Jnl. Line"."Tariff No.")
                {
                }
                fieldelement(InvoiceValue; "Intrastat Jnl. Line".Amount)
                {
                }
                fieldelement(StatisticalValue; "Intrastat Jnl. Line"."Statistical Value")
                {
                }
                textelement("<netmass>")
                {
                    XmlName = 'NetMass';
                }
                textelement(NatureOfTransactionACode)
                {

                    trigger OnBeforePassVariable()
                    begin
                        NatureOfTransactionACode := CopyStr("Intrastat Jnl. Line"."Transaction Type", 1, 1);
                    end;
                }
                textelement(NatureOfTransactionBCode)
                {

                    trigger OnBeforePassVariable()
                    begin
                        NatureOfTransactionBCode := InsStr("Intrastat Jnl. Line"."Transaction Type", '.', 2);
                    end;
                }
                fieldelement(DeliveryTermsCode; "Intrastat Jnl. Line"."Transaction Specification")
                {
                }
                fieldelement(ModeOfTransportCode; "Intrastat Jnl. Line"."Transport Method")
                {
                }

                fieldelement(CountryOfOrigin; "Intrastat Jnl. Line"."Country/Region of Origin Code")
                {
                }
                fieldelement(CountryOfDestination; "Intrastat Jnl. Line"."Country/Region Code")
                {
                }

            }
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group("<Control1900000002>")
                {
                    Caption = 'Options';
                    field("<Control11>"; CreateDate)
                    {
                        Caption = 'Creation Date';
                    }
                    group("<Control50>")
                    {
                        Caption = 'Filter';
                        field("<Control24>"; Template)
                        {
                            Caption = 'Intrastat Journal Template';
                            TableRelation = "Intrastat Jnl. Template";
                        }
                        field("<Control12>"; Batch)
                        {
                            Caption = 'Intrastat Journal Batch';
                        }
                        field(DocType; DocumentType)
                        {
                            Caption = 'Document Type';
                            OptionCaption = 'Receipt,Shipment';
                        }
                    }
                    group("<Control14>")
                    {
                        Caption = 'Responsible Person';
                        field("<Control18>"; RespPrsnFirstName)
                        {
                            Caption = 'First Name';
                        }
                        field("<Control16>"; RespPrsnLastName)
                        {
                            Caption = 'Last Name';
                        }
                        field("<Control2>"; RespPrsnPhoneNo)
                        {
                            Caption = 'Phone No.';
                        }
                        field("<Control4>"; RespPrsnFax)
                        {
                            Caption = 'Fax';
                        }
                        field("<Control1>"; RespPrsnEmail)
                        {
                            Caption = 'E-Mail';
                        }
                        field("<Control20>"; RespPrsnPosition)
                        {
                            Caption = 'Position';
                        }
                    }
                    group("<Control28>")
                    {
                        Caption = 'Code Versions';
                        field("<Control30>"; VerCountry)
                        {
                            Caption = 'Country';
                        }
                        field("<Control34>"; VerEuCountry)
                        {
                            Caption = 'EU Country';
                        }
                        field("<Control38>"; VerCn)
                        {
                            Caption = 'Company';
                        }
                        field("<Control42>"; VerModeOfTransport)
                        {
                            Caption = 'Mode of Transport';
                        }
                        field("<Control46>"; VerDeliveryTerms)
                        {
                            Caption = 'Delivery Terms';
                        }
                        field("<Control32>"; VerNatureOfTransactionA)
                        {
                            Caption = 'Nature of Transaction A';
                        }
                        field("<Control36>"; VerNatureOfTransactionB)
                        {
                            Caption = 'Nature of Transaction B';
                        }
                        field("<Control40>"; VerCounty)
                        {
                            Caption = 'County';
                        }
                        field("<Control44>"; VerLocality)
                        {
                            Caption = 'City';
                        }
                        field("<Control48>"; VerUnit)
                        {
                            Caption = 'Unit';
                        }
                    }
                    field("<Control22>"; FileName)
                    {
                        Caption = 'File Name';
                    }
                    group("<Control3>")
                    {
                        Caption = 'Declaration Type';
                        field(DecTypeNew; DeclarationType)
                        {
                            OptionCaption = 'New,Corrective,Nil';
                        }
                    }
                }
            }
        }

        actions
        {
        }
    }

    trigger OnInitXmlPort()
    begin
        //UpdateControls;
    end;

    trigger OnPreXmlPort()
    begin
        "Intrastat Jnl. Line".SetRange(Type, DocumentType);
    end;

    var
        CompanyInfo: Record "Company Information";
        IntrastatJnlBatch: Record "Intrastat Jnl. Batch";
        IntrastatJnlLine: Record "Intrastat Jnl. Line";
        ApplicationManagement: Codeunit "Application System Constants";
        IntraJnlManagement: Codeunit IntraJnlManagement;
        Template: Code[20];
        Batch: Code[20];
        TmpTemplate: Code[10];
        TmpBatch: Code[10];
        DocumentType: Option Receipt,Shipment;
        CreateDate: DateTime;
        VATNr: Text[10];
        Year: Text[30];
        Month: Text[30];
        MonthWzero: Text[30];
        ApplicationName: Text[50];
        XMLNameSpace: Text[250];
        VerCountry: Text[30];
        VerEuCountry: Text[30];
        VerCn: Text[30];
        VerModeOfTransport: Text[30];
        VerDeliveryTerms: Text[30];
        VerNatureOfTransactionA: Text[30];
        VerNatureOfTransactionB: Text[30];
        VerCounty: Text[30];
        VerLocality: Text[30];
        VerUnit: Text[30];
        DeclarationType: Option New,Corrective,Nill;
        FileName: Text[200];
        NetMass: Integer;
        TestFileName: File;
        JnlLineAmount: Decimal;
        JnlLineStatisticalValue: Decimal;
        JnlLineSupUOMQty: Decimal;
        NetMassValue: Decimal;
        xIntrastatJnlLine: Record "Intrastat Jnl. Line";
        [InDataSet]
        DecTypeNewEnable: Boolean;
        [InDataSet]
        DecTypeCorrectiveEnable: Boolean;
        [InDataSet]
        DecTypeNilEnable: Boolean;
        Text001: Label 'Export to XML File';
        Text002: Label 'XML Files (*.xml)|*.xml|All Files (*.*)|*.*';
        Text003: Label 'Microsoft Dynamics NAV';
        Text004: Label 'Please select the correct %1 %2 or %3.';
        Text005: Label 'You must specify %1.';
        Text006: Label 'You must specify First Name, Last Name and Phone No. for the responsible person.';
        Text007: Label 'All code versions must be filled in.';
        Text008: Label 'Please enter the file name.';
        Text009: Label '%1 %2 does not exist.';
        Text010: Label 'You must specify %1 for %2 %3';
        Text011: Label '%1 already exists.\Do you want to replace it?';
        Text012: Label '%1 in Intrastat Jnl. Line Journal Template Name = ''%2'', Journal Batch Name = ''%3'', Line No. = ''%4''\is out of the statistics period.\Please correct the value.';
        Text666: Label '%1 is not a valid selection.';
        NrCrt: Integer;
        Customer: Record Customer;
        Vendor: Record Vendor;

    procedure SetParam(TemplateName: Code[10]; BatchName: Code[10])
    begin
        TmpBatch := BatchName;
        TmpTemplate := TemplateName;
    end;

    local procedure NewDeclarationTypeOnValidate()
    begin
        if not (DecTypeNewEnable) then
            Error(Text666, DeclarationType);
    end;

    local procedure CorrectiveDeclarationTypeOnVal()
    begin
        if not (DecTypeCorrectiveEnable) then
            Error(Text666, DeclarationType);
    end;

    local procedure NillDeclarationTypeOnValidate()
    begin
        if not (DecTypeNilEnable) then
            Error(Text666, DeclarationType);
    end;
}

