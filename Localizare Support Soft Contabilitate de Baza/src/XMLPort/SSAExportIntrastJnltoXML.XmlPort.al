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
                            refperiod := '20' + Year + '-' + Month;
                        end;
                    end;
                }
                textelement(createdt)
                {
                    XmlName = 'CreateDt';

                    trigger OnBeforePassVariable()
                    begin
                        createdt := Format(CreateDate);
                    end;
                }
                textelement(ApplicationRef)
                {
                    trigger OnBeforePassVariable()
                    begin
                        ApplicationRef := Text003 + ' ' + ApplicationManagement.OriginalApplicationVersion();
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
            area(Content)
            {
                group("<Control1900000002>")
                {
                    Caption = 'Options';
                    field("<Control11>"; CreateDate)
                    {
                        Caption = 'Creation Date';
                        ToolTip = 'Specifies the value of the Creation Date field.';
                        ApplicationArea = All;
                    }
                    group("<Control50>")
                    {
                        Caption = 'Filter';
                        field("<Control24>"; Template)
                        {
                            Caption = 'Intrastat Journal Template';
                            TableRelation = "Intrastat Jnl. Template";
                            ToolTip = 'Specifies the value of the Intrastat Journal Template field.';
                            ApplicationArea = All;
                        }
                        field("<Control12>"; Batch)
                        {
                            Caption = 'Intrastat Journal Batch';
                            ToolTip = 'Specifies the value of the Intrastat Journal Batch field.';
                            ApplicationArea = All;
                        }
                        field(DocType; DocumentType)
                        {
                            Caption = 'Document Type';
                            OptionCaption = 'Receipt,Shipment';
                            ToolTip = 'Specifies the value of the Document Type field.';
                            ApplicationArea = All;
                        }
                    }
                    group("<Control14>")
                    {
                        Caption = 'Responsible Person';
                        field("<Control18>"; respprsnfirstname)
                        {
                            Caption = 'First Name';
                            ToolTip = 'Specifies the value of the First Name field.';
                            ApplicationArea = All;
                        }
                        field("<Control16>"; respprsnlastname)
                        {
                            Caption = 'Last Name';
                            ToolTip = 'Specifies the value of the Last Name field.';
                            ApplicationArea = All;
                        }
                        field("<Control2>"; respprsnphoneno)
                        {
                            Caption = 'Phone No.';
                            ToolTip = 'Specifies the value of the Phone No. field.';
                            ApplicationArea = All;
                        }
                        field("<Control4>"; respprsnfax)
                        {
                            Caption = 'Fax';
                            ToolTip = 'Specifies the value of the Fax field.';
                            ApplicationArea = All;
                        }
                        field("<Control1>"; respprsnemail)
                        {
                            Caption = 'E-Mail';
                            ToolTip = 'Specifies the value of the E-Mail field.';
                            ApplicationArea = All;
                        }
                        field("<Control20>"; respprsnposition)
                        {
                            Caption = 'Position';
                            ToolTip = 'Specifies the value of the Position field.';
                            ApplicationArea = All;
                        }
                    }
                    group("<Control28>")
                    {
                        Caption = 'Code Versions';
                        field("<Control30>"; VerCountry)
                        {
                            Caption = 'Country';
                            ToolTip = 'Specifies the value of the Country field.';
                            ApplicationArea = All;
                        }
                        field("<Control34>"; VerEuCountry)
                        {
                            Caption = 'EU Country';
                            ToolTip = 'Specifies the value of the EU Country field.';
                            ApplicationArea = All;
                        }
                        field("<Control38>"; VerCn)
                        {
                            Caption = 'Company';
                            ToolTip = 'Specifies the value of the Company field.';
                            ApplicationArea = All;
                        }
                        field("<Control42>"; VerModeOfTransport)
                        {
                            Caption = 'Mode of Transport';
                            ToolTip = 'Specifies the value of the Mode of Transport field.';
                            ApplicationArea = All;
                        }
                        field("<Control46>"; VerDeliveryTerms)
                        {
                            Caption = 'Delivery Terms';
                            ToolTip = 'Specifies the value of the Delivery Terms field.';
                            ApplicationArea = All;
                        }
                        field("<Control32>"; VerNatureOfTransactionA)
                        {
                            Caption = 'Nature of Transaction A';
                            ToolTip = 'Specifies the value of the Nature of Transaction A field.';
                            ApplicationArea = All;
                        }
                        field("<Control36>"; VerNatureOfTransactionB)
                        {
                            Caption = 'Nature of Transaction B';
                            ToolTip = 'Specifies the value of the Nature of Transaction B field.';
                            ApplicationArea = All;
                        }
                        field("<Control40>"; VerCounty)
                        {
                            Caption = 'County';
                            ToolTip = 'Specifies the value of the County field.';
                            ApplicationArea = All;
                        }
                        field("<Control44>"; VerLocality)
                        {
                            Caption = 'City';
                            ToolTip = 'Specifies the value of the City field.';
                            ApplicationArea = All;
                        }
                        field("<Control48>"; VerUnit)
                        {
                            Caption = 'Unit';
                            ToolTip = 'Specifies the value of the Unit field.';
                            ApplicationArea = All;
                        }
                    }
                    field("<Control22>"; FileName)
                    {
                        Caption = 'File Name';
                        ToolTip = 'Specifies the value of the File Name field.';
                        ApplicationArea = All;
                    }
                    group("<Control3>")
                    {
                        Caption = 'Declaration Type';
                        field(DecTypeNew; DeclarationType)
                        {
                            OptionCaption = 'New,Corrective,Nil';
                            ToolTip = 'Specifies the value of the DeclarationType field.';
                            ApplicationArea = All;
                        }
                    }
                }
            }
        }

    }


    trigger OnPreXmlPort()
    begin
        "Intrastat Jnl. Line".SetRange(Type, DocumentType);
    end;

    var
        IntrastatJnlBatch: Record "Intrastat Jnl. Batch";
        IntrastatJnlLine: Record "Intrastat Jnl. Line";
        ApplicationManagement: Codeunit "Application System Constants";
        Template: Code[20];
        Batch: Code[20];
        TmpTemplate: Code[10];
        TmpBatch: Code[10];
        DocumentType: Option Receipt,Shipment;
        CreateDate: DateTime;
        Year: Text[30];
        Month: Text[30];
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

        DecTypeNewEnable: Boolean;

        DecTypeCorrectiveEnable: Boolean;

        DecTypeNilEnable: Boolean;
        Text003: Label 'Microsoft Dynamics NAV';
        Text010: Label 'You must specify %1 for %2 %3';
        Text666: Label '%1 is not a valid selection.';
        NrCrt: Integer;

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
