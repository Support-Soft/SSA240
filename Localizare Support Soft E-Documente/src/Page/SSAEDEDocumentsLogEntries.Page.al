page 72000 "SSAEDE-Documents Log Entries"
{
    Caption = 'E-Documents Log Entries';
    Editable = false;
    PageType = List;
    SourceTable = "SSAEDE-Documents Log Entry";
    ApplicationArea = All;
    UsageCategory = Lists;
    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    ToolTip = 'Entry No.';
                }
                field("Entry Type"; Rec."Entry Type")
                {
                    ToolTip = 'Specifies the value of the Entry Type field.';
                }

                field("Document Type"; Rec."Document Type")
                {
                    ToolTip = 'Document Type';
                }
                field("Document No."; Rec."Document No.")
                {
                    ToolTip = 'Document No.';
                }
                field("Customer No."; Rec."Customer No.")
                {
                    ToolTip = 'Customer No.';
                }
                field(Status; Rec.Status)
                {
                    ToolTip = 'Status';
                }
                field("Error Message"; Rec."Error Message")
                {
                    ToolTip = 'Error Message';
                }
                field("Creation Date"; Rec."Creation Date")
                {
                    ToolTip = 'Creation Date';
                }
                field("Creation Time"; Rec."Creation Time")
                {
                    ToolTip = 'Creation Time';
                }
                field("Processing DateTime"; Rec."Processing DateTime")
                {
                    ToolTip = 'Processing DateTime';
                }
                field(ClientFileName; Rec.ClientFileName)
                {
                    ToolTip = 'Client File Name';
                }
                field(DateResponse; Rec.DateResponse)
                {
                    ToolTip = 'Date Response';
                }
                field("Execution Status"; Rec."Execution Status")
                {
                    ToolTip = 'Execution Status';
                }
                field("Index Incarcare"; Rec."Index Incarcare")
                {
                    ToolTip = 'Index Incarcare';
                }
                field("Stare Mesaj"; Rec."Stare Mesaj")
                {
                    ToolTip = 'Stare Mesaj';
                }
                field("ID Descarcare"; Rec."ID Descarcare")
                {
                    ToolTip = 'ID Descarcare';
                }
                field("Created Purchase Invoice No."; Rec."Created Purchase Invoice No.")
                {
                    ToolTip = 'Specifies the value of the Created Purchase Invoice No. field.';
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field.';
                }
                field("Document Currency Code"; Rec."Document Currency Code")
                {
                    ToolTip = 'Specifies the value of the Document Currency Code field.';
                }
                field("Issue Date"; Rec."Issue Date")
                {
                    ToolTip = 'Specifies the value of the Issue Date field.';
                }
                field("NAV Vendor Name"; Rec."NAV Vendor Name")
                {
                    ToolTip = 'Specifies the value of the NAV Vendor Name field.';
                }
                field("NAV Vendor No."; Rec."NAV Vendor No.")
                {
                    ToolTip = 'Specifies the value of the NAV Vendor No. field.';
                }
                field("Posted Purch. Credit Memo No."; Rec."Posted Purch. Credit Memo No.")
                {
                    ToolTip = 'Specifies the value of the Posted Purch. Credit Memo No. field.';
                }
                field("Posted Purchase Invoice No."; Rec."Posted Purchase Invoice No.")
                {
                    ToolTip = 'Specifies the value of the Posted Purchase Invoice No. field.';
                }
                field("Purch.Inv Amount Including VAT"; Rec."Purch.Inv Amount Including VAT")
                {
                    ToolTip = 'Specifies the value of the Purch.Inv Amount Including VAT field.';
                }
                field("Purchase Invoice Amount"; Rec."Purchase Invoice Amount")
                {
                    ToolTip = 'Specifies the value of the Purchase Invoice Amount field.';
                }
                field("Supplier ID"; Rec."Supplier ID")
                {
                    ToolTip = 'Specifies the value of the Supplier ID field.';
                }
                field("Supplier Name"; Rec."Supplier Name")
                {
                    ToolTip = 'Specifies the value of the Supplier Name field.';
                }
                field("Total Tax Amount"; Rec."Total Tax Amount")
                {
                    ToolTip = 'Specifies the value of the Total Tax Amount field.';
                }
                field("Total TaxExclusiveAmount"; Rec."Total TaxExclusiveAmount")
                {
                    ToolTip = 'Specifies the value of the Total TaxExclusiveAmount field.';
                }
                field("Total TaxInclusiveAmount"; Rec."Total TaxInclusiveAmount")
                {
                    ToolTip = 'Specifies the value of the Total TaxInclusiveAmount field.';
                }
                field("Data Scadenta"; Rec."Data Scadenta")
                {
                    ToolTip = 'Specifies the value of the Data Scadenta field.';
                }
                field("Nr. Factura Furnizor"; Rec."Nr. Factura Furnizor")
                {
                    ToolTip = 'Specifies the value of the Nr. Factura Furnizor field.';
                }
                field("Metoda de Plata"; Rec."Metoda de Plata")
                {
                    ToolTip = 'Specifies the value of the Metoda de Plata field.';
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            group(General)
            {
                Caption = 'General';
                action("Reset Status")
                {
                    Caption = 'Reset Status';
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ToolTip = 'Reset Status';

                    trigger OnAction()
                    var
                        ROFacturaTransportLogEntry: Record "SSAEDE-Documents Log Entry";
                    begin
                        ROFacturaTransportLogEntry.Reset;
                        CurrPage.SetSelectionFilter(ROFacturaTransportLogEntry);
                        Rec.ResetStatus(ROFacturaTransportLogEntry);
                    end;
                }
                action("Download File")
                {
                    Caption = 'Download File';
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ToolTip = 'Download File';

                    trigger OnAction()
                    var
                        ROFacturaTransportLogEntry: Record "SSAEDE-Documents Log Entry";
                        ExportEFactura: Codeunit "SSAEDExport EFactura";
                        ANAFAPIMgt: Codeunit "SSAEDANAF API Mgt";
                        TempBlob: Codeunit "Temp Blob";
                        InStr: InStream;
                        FileName: Text;
                    begin
                        ROFacturaTransportLogEntry := Rec;
                        CurrPage.SetSelectionFilter(ROFacturaTransportLogEntry);
                        if ROFacturaTransportLogEntry."Entry Type" = ROFacturaTransportLogEntry."Entry Type"::"Export E-Transport" then
                            CODEUNIT.Run(CODEUNIT::"SSAEDExport ETransport", ROFacturaTransportLogEntry);
                        if ROFacturaTransportLogEntry."Entry Type" = ROFacturaTransportLogEntry."Entry Type"::"Export E-Factura" then
                            ExportEFactura.ExportXMLFile(ROFacturaTransportLogEntry);
                        if ROFacturaTransportLogEntry."Entry Type" = ROFacturaTransportLogEntry."Entry Type"::"Import E-Factura" then begin
                            ROFacturaTransportLogEntry := Rec;
                            CurrPage.SetSelectionFilter(ROFacturaTransportLogEntry);
                            ROFacturaTransportLogEntry.TestField("ID Descarcare");
                            ANAFAPIMgt.DescarcareMesaj(ROFacturaTransportLogEntry."ID Descarcare", TempBlob);
                            TempBlob.CreateInStream(InStr);
                            FileName := Rec."ID Descarcare" + '.zip';
                            DownloadFromStream(InStr, 'Save file', '', 'Zip File (*.zip)|*.zip', FileName);

                        end;
                    end;
                }
                action(GetXMLContent)
                {
                    Caption = 'Get XML Content';
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ToolTip = 'Get XML Content';
                    trigger OnAction()
                    begin
                        Rec.DownloadXMLContent();
                    end;
                }
            }
            group(Export)
            {
                Caption = 'Export';
                action("Upload ANAF XML File")
                {
                    Caption = 'Upload ANAF XML File';
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ToolTip = 'Upload ANAF XML File';

                    trigger OnAction()
                    var
                        ROFacturaTransportLogEntry: Record "SSAEDE-Documents Log Entry";
                    begin
                        ROFacturaTransportLogEntry := Rec;
                        CurrPage.SetSelectionFilter(ROFacturaTransportLogEntry);
                        if ROFacturaTransportLogEntry."Entry Type" = ROFacturaTransportLogEntry."Entry Type"::"Export E-Transport" then
                            CODEUNIT.Run(CODEUNIT::"SSAEDExport ETransport", ROFacturaTransportLogEntry);
                        if ROFacturaTransportLogEntry."Entry Type" = ROFacturaTransportLogEntry."Entry Type"::"Export E-Factura" then
                            CODEUNIT.Run(CODEUNIT::"SSAEDExport EFactura", ROFacturaTransportLogEntry);
                    end;
                }
            }
            group(Import)
            {
                Caption = 'Import';
                action(GetListaMesaje)
                {
                    Caption = 'Get Lista Mesaje';
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ToolTip = 'Get Lista Mesaje';
                    trigger OnAction()
                    var
                        ANAFApiMgt: Codeunit "SSAEDANAF API Mgt";
                    begin
                        ANAFApiMgt.GetListaMesaje();
                        CurrPage.Update();
                    end;
                }
                action(ProcessEntry)
                {
                    Caption = 'Process Entry';
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ToolTip = 'Process Entry';
                    trigger OnAction()
                    var
                        EFacturaLogEntry: Record "SSAEDE-Documents Log Entry";
                    begin
                        EFacturaLogEntry.Get(Rec."Entry No.");
                        EFacturaLogEntry.TestField("Entry Type", EFacturaLogEntry."Entry Type"::"Import E-Factura");
                        if CODEUNIT.Run(CODEUNIT::"SSAEDProcess Import E-Doc", EFacturaLogEntry) then begin
                            EFacturaLogEntry.Status := EFacturaLogEntry.Status::Completed;
                            EFacturaLogEntry."Error Message" := '';
                        end else begin
                            EFacturaLogEntry.Status := EFacturaLogEntry.Status::Error;
                            EFacturaLogEntry."Error Message" := CopyStr(GetLastErrorText, 1, MaxStrLen(EFacturaLogEntry."Error Message"));
                        end;
                        EFacturaLogEntry."Processing DateTime" := CurrentDateTime;
                        EFacturaLogEntry.Modify;
                        CurrPage.Update();
                    end;
                }

                action(ShowDetails)
                {
                    Caption = 'Show Details';
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ToolTip = 'Show Details';
                    RunObject = page "SSAEDE-Documents Details List";
                    RunPageView = sorting("Log Entry No.", "Line No.");
                    RunPageLink = "Log Entry No." = field("Entry No."), "Type of Line" = const("Invoice Line");
                }
            }
        }
    }
    trigger OnAfterGetRecord()
    begin

        if Rec."ID Descarcare" = '' then begin
            CLEAR(Rec."Created Purchase Invoice No.");
            CLEAR(Rec."Posted Purchase Invoice No.");
            CLEAR(Rec."Posted Purch. Credit Memo No.");
            CLEAR(Rec."Purchase Invoice Amount");
            CLEAR(Rec."Purch.Inv Amount Including VAT");
        end;
    end;
}


