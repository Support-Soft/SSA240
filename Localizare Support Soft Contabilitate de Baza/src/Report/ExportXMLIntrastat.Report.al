report 70001 "SSA Export XML Intrastat"
{
    // SSA953 SSCAT 05.07.2019 19.Funct. intrastat

    ProcessingOnly = true;
    dataset
    {
        dataitem("Intrastat Jnl. Batch"; "Intrastat Jnl. Batch")
        {
            DataItemTableView = SORTING("Journal Template Name", Name);
            dataitem("Intrastat Jnl. Line"; "Intrastat Jnl. Line")
            {
                DataItemLink = "Journal Template Name" = FIELD("Journal Template Name"), "Journal Batch Name" = FIELD(Name);
                DataItemTableView = SORTING(Type, "Country/Region Code", "Tariff No.", "Transaction Type", "Transport Method");

                trigger OnAfterGetRecord()
                begin
                    if ("Tariff No." = '') and
                       ("Country/Region Code" = '') and
                       ("Transaction Type" = '') and
                       ("Transport Method" = '') and
                       ("Total Weight" = 0)
                    then
                        CurrReport.Skip;

                    if not CheckDateInStatisticPeriod("Intrastat Jnl. Line") then
                        Error(Text012, FieldCaption(Date), "Journal Template Name", "Journal Batch Name", "Line No.");

                    TestField("Tariff No.");
                    TestField(Amount);
                    TestField("Transaction Type");
                    TestField("Shpt. Method Code");
                    TestField("Transport Method");

                    if "Supplementary Units" then
                        TestField(Quantity);

                    CompoundField :=
                      Format("Country/Region Code", 10) + Format(DelChr("Tariff No."), 10) +
                      Format("Transaction Type", 10) + Format("Transport Method", 10);

                    if (TempType <> Type) or (StrLen(TempCompoundField) = 0) then begin
                        TempType := Type;
                        TempCompoundField := CompoundField;
                        IntraReferenceNo := CopyStr(IntraReferenceNo, 1, 4) + Format(Type, 1, 2) + '01001';
                    end else
                        if TempCompoundField <> CompoundField then begin
                            TempCompoundField := CompoundField;
                            if CopyStr(IntraReferenceNo, 8, 3) = '999' then
                                IntraReferenceNo := IncStr(CopyStr(IntraReferenceNo, 1, 7)) + '001'
                            else
                                IntraReferenceNo := IncStr(IntraReferenceNo);
                        end;

                    "Internal Ref. No." := IntraReferenceNo;
                    Modify;
                end;

                trigger OnPreDataItem()
                begin

                    CurrReport.CreateTotals(Amount, "Statistical Value", Quantity, "Total Weight");

                    SetRange(Type, DocumentType);
                end;
            }
            dataitem(IntrastatJnlLine2; "Intrastat Jnl. Line")
            {
                DataItemTableView = SORTING("Internal Ref. No.");

                trigger OnAfterGetRecord()
                begin
                    if ("Tariff No." = '') and
                       ("Country/Region Code" = '') and
                       ("Transaction Type" = '') and
                       ("Transport Method" = '') and
                       ("Total Weight" = 0)
                    then
                        CurrReport.Skip;

                    "Tariff No." := DelChr("Tariff No.");
                    OrderNr := OrderNr + 1;

                    if ("Total Weight" < 1) and ("Total Weight" >= 0) then
                        NetMass := 1
                    else
                        NetMass := Round("Total Weight", 1);

                    case Type of
                        Type::Receipt:
                            XMLDOMMgt.AddElement(XMLRootNode, 'InsArrivalItem', '', XMLRootNode.NamespaceURI, XMLCurrNode);
                        Type::Shipment:
                            XMLDOMMgt.AddElement(XMLRootNode, 'InsDispatchItem', '', XMLRootNode.NamespaceURI, XMLCurrNode);
                    end;

                    XMLDOMMgt.AddAttribute(XMLCurrNode, 'OrderNr', Format(OrderNr));

                    XMLDOMMgt.AddElement(XMLCurrNode, 'Cn8Code', DelChr("Tariff No."), XMLRootNode.NamespaceURI, XMLReturnedNode);
                    XMLDOMMgt.AddElement(XMLCurrNode, 'InvoiceValue', Format(Amount, 0, 1), XMLRootNode.NamespaceURI, XMLReturnedNode);
                    if "Statistical Value" <> 0 then
                        XMLDOMMgt.AddElement(XMLCurrNode, 'StatisticalValue', Format("Statistical Value", 0, 1), XMLRootNode.NamespaceURI, XMLReturnedNode);
                    XMLDOMMgt.AddElement(XMLCurrNode, 'NetMass', Format(NetMass, 0, 1), XMLRootNode.NamespaceURI, XMLReturnedNode);
                    XMLDOMMgt.AddElement(XMLCurrNode, 'NatureOfTransactionACode', CopyStr("Transaction Type", 1, 1), XMLRootNode.NamespaceURI, XMLReturnedNode);
                    XMLDOMMgt.AddElement(XMLCurrNode, 'NatureOfTransactionBCode', InsStr("Transaction Type", '.', 2), XMLRootNode.NamespaceURI, XMLReturnedNode);
                    XMLDOMMgt.AddElement(XMLCurrNode, 'DeliveryTermsCode', "Shpt. Method Code", XMLRootNode.NamespaceURI, XMLReturnedNode);
                    XMLDOMMgt.AddElement(XMLCurrNode, 'ModeOfTransportCode', "Transport Method", XMLRootNode.NamespaceURI, XMLReturnedNode);
                    /*
                     IF ("Base Unit of Measure" <> '') AND (Quantity <> 0)
                     THEN BEGIN
                       XMLDOMMgt.AddElement(XMLCurrNode,'InsSupplUnitsInfo','',XMLRootNode.NamespaceURI,XMLReturnedNode);
                       XMLDOMMgt.AddElement(XMLReturnedNode,'SupplUnitCode',"Base Unit of Measure",XMLRootNode.NamespaceURI,XMLReturnedNode2);
                       XMLDOMMgt.AddElement(XMLReturnedNode,'QtyInSupplUnits',FORMAT(Quantity),XMLRootNode.NamespaceURI,XMLReturnedNode2);
                     END;
                    */
                    /*
                     IF ("Supplem. UoM Code" <> '') AND (Quantity <> 0)
                     THEN BEGIN
                       XMLDOMMgt.AddElement(XMLCurrNode,'InsSupplUnitsInfo','',XMLRootNode.NamespaceURI,XMLReturnedNode);
                       XMLDOMMgt.AddElement(XMLReturnedNode,'SupplUnitCode',"Supplem. UoM Code",XMLRootNode.NamespaceURI,XMLReturnedNode2);
                       XMLDOMMgt.AddElement(XMLReturnedNode,'QtyInSupplUnits',FORMAT(Quantity),XMLRootNode.NamespaceURI,XMLReturnedNode2);
                     END;
                     */

                    case Type of
                        Type::Receipt:
                            begin
                                TestField("Country/Region of Origin Code");
                                XMLDOMMgt.AddElement(XMLCurrNode, 'CountryOfOrigin', "Country/Region of Origin Code", XMLRootNode.NamespaceURI, XMLReturnedNode);
                                if "Country/Region Code" <> '' then
                                    XMLDOMMgt.AddElement(XMLCurrNode, 'CountryOfConsignment', "Country/Region Code", XMLRootNode.NamespaceURI, XMLReturnedNode);
                            end;
                        Type::Shipment:
                            begin
                                TestField("Country/Region Code");
                                XMLDOMMgt.AddElement(XMLCurrNode, 'CountryOfDestination', "Country/Region Code", XMLRootNode.NamespaceURI, XMLReturnedNode);
                            end;
                    end;

                end;

                trigger OnPreDataItem()
                begin
                    SetRange("Internal Ref. No.", CopyStr(IntraReferenceNo, 1, 4), CopyStr(IntraReferenceNo, 1, 4) + '9');
                    CurrReport.CreateTotals(Quantity, "Statistical Value", "Total Weight");
                end;
            }

            trigger OnAfterGetRecord()
            begin
                TestField(Reported, false);
                IntraReferenceNo := "Statistics Period" + '000000';
            end;

            trigger OnPreDataItem()
            begin
                SetRange("Journal Template Name", Template);
                SetRange(Name, Batch);
            end;
        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                group(Control21)
                {
                    ShowCaption = false;
                    field(CreateDate; CreateDate)
                    {
                        Caption = 'Creation Date';
                        ApplicationArea = All;
                    }
                    group(Filters)
                    {
                        Caption = 'Filters';
                        //The GridLayout property is only supported on controls of type Grid
                        //GridLayout = Rows;
                        field(Template; Template)
                        {
                            Caption = 'Intrastat Journal Template';
                            ApplicationArea = All;
                        }
                        field(Batch; Batch)
                        {
                            Caption = 'Intrastat Journal Batch';
                            ApplicationArea = All;
                        }
                        field(DeclarationType; DeclarationType)
                        {
                            Caption = 'Declaration Type';
                            ApplicationArea = All;
                        }
                        field(DocumentType; DocumentType)
                        {
                            Caption = 'Documnet Type';
                            ApplicationArea = All;
                        }
                    }
                    group(Responsibility)
                    {
                        Caption = 'Responsibility';
                        field(RespPrsnFirstName; RespPrsnFirstName)
                        {
                            Caption = 'First Name';
                            ApplicationArea = All;
                        }
                        field(RespPrsnLastName; RespPrsnLastName)
                        {
                            Caption = 'Last Name';
                            ApplicationArea = All;
                        }
                        field(RespPrsnPhoneNo; RespPrsnPhoneNo)
                        {
                            Caption = 'Phone No.';
                            ApplicationArea = All;
                        }
                        field(RespPrsnFax; RespPrsnFax)
                        {
                            Caption = 'Fax';
                            ApplicationArea = All;
                        }
                        field(RespPrsnEmail; RespPrsnEmail)
                        {
                            Caption = 'E-Mail';
                            ApplicationArea = All;
                        }
                        field(RespPrsnPosition; RespPrsnPosition)
                        {
                            Caption = 'Position';
                            ApplicationArea = All;
                        }
                    }
                    group("Code Versions")
                    {
                        Caption = 'Code Versions';
                        field(VerCountry; VerCountry)
                        {
                            Caption = 'Country';
                            ApplicationArea = All;
                        }
                        field(VerEuCountry; VerEuCountry)
                        {
                            Caption = 'EU Country';
                            ApplicationArea = All;
                        }
                        field(VerCn; VerCn)
                        {
                            Caption = 'Company';
                            ApplicationArea = All;
                        }
                        field(VerModeOfTransport; VerModeOfTransport)
                        {
                            Caption = 'Mode of Transport';
                            ApplicationArea = All;
                        }
                        field(VerDeliveryTerms; VerDeliveryTerms)
                        {
                            Caption = 'Delivery Terms';
                            ApplicationArea = All;
                        }
                        field(VerNatureOfTransactionA; VerNatureOfTransactionA)
                        {
                            Caption = 'Nature of Transaction A';
                            ApplicationArea = All;
                        }
                        field(VerNatureOfTransactionB; VerNatureOfTransactionB)
                        {
                            Caption = 'Nature of Transaction B';
                            ApplicationArea = All;
                        }
                        field(VerCounty; VerCounty)
                        {
                            Caption = 'County';
                            ApplicationArea = All;
                        }
                        field(VerLocality; VerLocality)
                        {
                            Caption = 'City';
                            ApplicationArea = All;
                        }
                        field(VerUnit; VerUnit)
                        {
                            Caption = 'Unit';
                            ApplicationArea = All;
                        }
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnOpenPage()
        begin
            CreateDate := CurrentDateTime;
            Template := TmpTemplate;
            Batch := TmpBatch;
            UpdateFileName;
        end;
    }

    labels
    {
    }

    trigger OnInitReport()
    begin

        XMLNameSpace := 'http://www.intrastat.ro/xml/InsSchema';
        ApplicationName := Text003 + ' ' + ApplicationSystemConstants.ApplicationVersion;

        CompanyInfo.Get;
        CompanyInfo.TestField(Name);
        CompanyInfo.TestField("VAT Registration No.");

        if 'RO' = CopyStr(CompanyInfo."VAT Registration No.", 1, 2) then
            VATNr := CopyStr(CompanyInfo."VAT Registration No.", 3)
        else
            VATNr := CompanyInfo."VAT Registration No.";
        while StrLen(VATNr) < 8 do
            VATNr := InsStr(VATNr, '0', 1);
    end;

    trigger OnPostReport()
    begin
        XMLResultDoc.Save(FileName);
        FileMgt.DownloadTempFile(FileName);
        Message(Text013);
    end;

    trigger OnPreReport()
    begin
        FileName := FileMgt.ServerTempFileName('xml');

        if Template = '' then
            Error(Text005, "Intrastat Jnl. Line".FieldCaption("Journal Template Name"));

        if Batch = '' then
            Error(Text005, "Intrastat Jnl. Line".FieldCaption("Journal Batch Name"));

        if (RespPrsnFirstName = '') or (RespPrsnLastName = '') or (RespPrsnPhoneNo = '') then
            Error(Text006);

        if (VerCountry = '') or (VerEuCountry = '') or (VerCn = '') or (VerModeOfTransport = '') or
           (VerDeliveryTerms = '') or (VerNatureOfTransactionA = '') or (VerNatureOfTransactionB = '') or
           (VerCounty = '') or (VerLocality = '') or (VerUnit = '') then
            Error(Text007);

        if FileName = '' then
            Error(Text008);

        IntrastatJnlBatch.SetFilter("Journal Template Name", Template);
        IntrastatJnlBatch.SetFilter(Name, Batch);
        IntrastatJnlBatch.FindFirst;

        XMLResultDoc := XMLResultDoc.XmlDocument;

        if DocumentType = DocumentType::Receipt
        then
            case DeclarationType of
                DeclarationType::New:

                    XMLResultDoc.LoadXml := '<?xml version="1.0" encoding="UTF-8"?><InsNewArrival/>';
                DeclarationType::Corrective:
                    XMLResultDoc.LoadXml := '<?xml version="1.0" encoding="UTF-8"?><InsRevisedArrival/>';
                DeclarationType::Nill:
                    XMLResultDoc.LoadXml := '<?xml version="1.0" encoding="UTF-8"?><InsNillArrival/>';
            end
        else
            case DeclarationType of
                DeclarationType::New:
                    XMLResultDoc.LoadXml := '<?xml version="1.0" encoding="UTF-8"?><InsNewDispatch/>';
                DeclarationType::Corrective:
                    XMLResultDoc.LoadXml := '<?xml version="1.0" encoding="UTF-8"?><InsRevisedDispatch/>';
                DeclarationType::Nill:
                    XMLResultDoc.LoadXml := '<?xml version="1.0" encoding="UTF-8"?><InsNillDispatch/>';
            end;

        XMLRootNode := XMLResultDoc.DocumentElement;
        XMLDOMMgt.AddAttribute(XMLRootNode, 'SchemaVersion', '1.0');
        XMLDOMMgt.AddAttribute(XMLRootNode, 'xmlns', XMLNameSpace);

        XMLDOMMgt.AddElement(XMLRootNode, 'InsCodeVersions', '', XMLRootNode.NamespaceURI, XMLCurrNode);
        XMLDOMMgt.AddElement(XMLCurrNode, 'CountryVer', VerCountry, XMLRootNode.NamespaceURI, XMLReturnedNode);

        XMLDOMMgt.AddElement(XMLCurrNode, 'EuCountryVer', VerEuCountry, XMLRootNode.NamespaceURI, XMLReturnedNode);
        XMLDOMMgt.AddElement(XMLCurrNode, 'CnVer', VerCn, XMLRootNode.NamespaceURI, XMLReturnedNode);
        XMLDOMMgt.AddElement(XMLCurrNode, 'ModeOfTransportVer', VerModeOfTransport, XMLRootNode.NamespaceURI, XMLReturnedNode);
        XMLDOMMgt.AddElement(XMLCurrNode, 'DeliveryTermsVer', VerDeliveryTerms, XMLRootNode.NamespaceURI, XMLReturnedNode);
        XMLDOMMgt.AddElement(XMLCurrNode, 'NatureOfTransactionAVer', VerNatureOfTransactionA, XMLRootNode.NamespaceURI, XMLReturnedNode);
        XMLDOMMgt.AddElement(XMLCurrNode, 'NatureOfTransactionBVer', VerNatureOfTransactionB, XMLRootNode.NamespaceURI, XMLReturnedNode);
        XMLDOMMgt.AddElement(XMLCurrNode, 'CountyVer', VerCounty, XMLRootNode.NamespaceURI, XMLReturnedNode);
        XMLDOMMgt.AddElement(XMLCurrNode, 'LocalityVer', VerLocality, XMLRootNode.NamespaceURI, XMLReturnedNode);
        XMLDOMMgt.AddElement(XMLCurrNode, 'UnitVer', VerUnit, XMLRootNode.NamespaceURI, XMLReturnedNode);

        XMLDOMMgt.AddElement(XMLRootNode, 'InsDeclarationHeader', '', XMLRootNode.NamespaceURI, XMLCurrNode);
        XMLDOMMgt.AddElement(XMLCurrNode, 'VatNr', VATNr, XMLRootNode.NamespaceURI, XMLReturnedNode);
        XMLDOMMgt.AddElement(XMLCurrNode, 'FirmName', CompanyInfo.Name, XMLRootNode.NamespaceURI, XMLReturnedNode);
        XMLDOMMgt.AddElement(XMLCurrNode, 'RefPeriod', '20' + Year + '-' + Month, XMLRootNode.NamespaceURI, XMLReturnedNode);
        XMLDOMMgt.AddElement(XMLCurrNode, 'CreateDt', Format(CreateDate, 0, 9), XMLRootNode.NamespaceURI, XMLReturnedNode);
        XMLDOMMgt.AddElement(XMLCurrNode, 'ApplicationRef', ApplicationName, XMLRootNode.NamespaceURI, XMLReturnedNode);

        XMLDOMMgt.AddElement(XMLCurrNode, 'ContactPerson', '', XMLRootNode.NamespaceURI, XMLCurrNode);

        XMLDOMMgt.AddElement(XMLCurrNode, 'LastName', RespPrsnLastName, XMLRootNode.NamespaceURI, XMLReturnedNode);
        XMLDOMMgt.AddElement(XMLCurrNode, 'FirstName', RespPrsnFirstName, XMLRootNode.NamespaceURI, XMLReturnedNode);
        if RespPrsnEmail <> '' then
            XMLDOMMgt.AddElement(XMLCurrNode, 'Email', RespPrsnEmail, XMLRootNode.NamespaceURI, XMLReturnedNode);
        XMLDOMMgt.AddElement(XMLCurrNode, 'Phone', RespPrsnPhoneNo, XMLRootNode.NamespaceURI, XMLReturnedNode);
        if RespPrsnFax <> '' then
            XMLDOMMgt.AddElement(XMLCurrNode, 'Fax', RespPrsnFax, XMLRootNode.NamespaceURI, XMLReturnedNode);
        if RespPrsnPosition <> '' then
            XMLDOMMgt.AddElement(XMLCurrNode, 'Position', RespPrsnPosition, XMLRootNode.NamespaceURI, XMLReturnedNode);
    end;

    var
        CompanyInfo: Record "Company Information";
        IntrastatJnlBatch: Record "Intrastat Jnl. Batch";
        IntrastatJnlLine: Record "Intrastat Jnl. Line";
        IntrastatJnlLineGroup: Record "Intrastat Jnl. Line";
        IntraJnlManagement: Codeunit IntraJnlManagement;
        ApplicationSystemConstants: Codeunit "Application System Constants";
        FileMgt: Codeunit "File Management";
        XMLDOMMgt: Codeunit "XML DOM Management";
        XMLResultDoc: DotNet XmlDocument;
        XMLCreateNode: DotNet XmlNode;
        XMLRootNode: DotNet XmlNode;
        XMLCurrNode: DotNet XmlNode;
        XMLReturnedNode: DotNet XmlNode;
        XMLReturnedNode2: DotNet XmlNode;
        Template: Code[20];
        Batch: Code[20];
        TmpTemplate: Code[10];
        TmpBatch: Code[10];
        DocumentType: Option Receipt,Shipment;
        CreateDate: DateTime;
        VATNr: Text[20];
        Year: Text[30];
        Month: Text[30];
        MonthWzero: Text[30];
        RespPrsnFirstName: Text[30];
        RespPrsnLastName: Text[30];
        RespPrsnPhoneNo: Text[30];
        RespPrsnFax: Text[30];
        RespPrsnEmail: Text[30];
        RespPrsnPosition: Text[30];
        ApplicationName: Text[50];
        XMLNameSpace: Text;
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
        OrderNr: Integer;
        NetMass: Integer;
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
        WindowTitleXML: Label 'Export';
        DefaultFilenameXML: Text;
        FileName: Text;
        CompoundField: Text[40];
        TempCompoundField: Text[40];
        TempType: Integer;
        IntraReferenceNo: Text[10];
        GroupTotal: Boolean;
        Text013: Label 'Export to XML is ready';

    local
    procedure UpdateFileName()
    begin
        if IntrastatJnlBatch.Get(Template, Batch) then begin
            if IntrastatJnlBatch."Statistics Period" = '' then
                Error(Text010, IntrastatJnlBatch.FieldCaption("Statistics Period"),
                              IntrastatJnlLine.FieldCaption("Journal Batch Name"),
                              IntrastatJnlBatch.Name);
            Year := CopyStr(IntrastatJnlBatch."Statistics Period", 1, 2);
            Month := CopyStr(IntrastatJnlBatch."Statistics Period", 3, 2);
            if Batch <> '' then begin
                if Month[1] = '0' then
                    MonthWzero := CopyStr(Month, 2, 1)
                else
                    MonthWzero := Month;

                case DocumentType of
                    DocumentType::Receipt:
                        DefaultFilenameXML := VATNr + '_A_20' + Year + MonthWzero + '.xml';
                    DocumentType::Shipment:
                        DefaultFilenameXML := VATNr + '_D_20' + Year + MonthWzero + '.xml';
                end
            end
        end else begin

            DefaultFilenameXML := '';
        end;
    end;

    procedure SetParam(TemplateName: Code[10]; BatchName: Code[10])
    begin
        TmpBatch := BatchName;
        TmpTemplate := TemplateName;
    end;

    local
    procedure CheckDateInStatisticPeriod(_IntrastatJnlLine: Record "Intrastat Jnl. Line"): Boolean
    var
        Century: Integer;
        PeriodYear: Integer;
        PeriodMonth: Integer;
        PeriodStartDate: Date;
        PeriodEndDate: Date;
    begin
        with _IntrastatJnlLine do begin

            IntrastatJnlBatch.Get("Journal Template Name", "Journal Batch Name");
            IntrastatJnlBatch.TestField("Statistics Period");

            Century := Date2DMY(WorkDate, 3) div 100;
            Evaluate(PeriodYear, CopyStr(IntrastatJnlBatch."Statistics Period", 1, 2));
            PeriodYear := PeriodYear + Century * 100;
            Evaluate(PeriodMonth, CopyStr(IntrastatJnlBatch."Statistics Period", 3, 2));
            PeriodStartDate := DMY2Date(1, PeriodMonth, PeriodYear);
            PeriodEndDate := CalcDate('<1M-1D>', PeriodStartDate);

            if (Date < PeriodStartDate) or (Date > PeriodEndDate) then
                exit(false);

            exit(true);
        end;
    end;
}

