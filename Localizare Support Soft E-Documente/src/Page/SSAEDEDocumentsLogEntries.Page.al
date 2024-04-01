page 72000 "SSAEDE-Documents Log Entries"
{
    Caption = 'E-Documents Log Entries';
    PageType = List;
    SourceTable = "SSAEDE-Documents Log Entry";
    ApplicationArea = All;
    UsageCategory = Lists;
    InsertAllowed = false;
    DeleteAllowed = false;
    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    ToolTip = 'Entry No.';
                    Editable = false;
                }
                field("Entry Type"; Rec."Entry Type")
                {
                    ToolTip = 'Specifies the value of the Entry Type field.';
                    Editable = false;
                }

                field("Document Type"; Rec."Document Type")
                {
                    ToolTip = 'Document Type';
                    Editable = false;
                }
                field("Document No."; Rec."Document No.")
                {
                    ToolTip = 'Document No.';
                    Editable = false;
                }
                field("Customer No."; Rec."Customer No.")
                {
                    ToolTip = 'Customer No.';
                    Editable = false;
                }
                field(Status; Rec.Status)
                {
                    ToolTip = 'Status';
                    Editable = false;
                }
                field("Error Message"; Rec."Error Message")
                {
                    ToolTip = 'Error Message';
                    Editable = false;
                }
                field("Creation Date"; Rec."Creation Date")
                {
                    ToolTip = 'Creation Date';
                    Editable = false;
                }
                field("Creation Time"; Rec."Creation Time")
                {
                    ToolTip = 'Creation Time';
                    Editable = false;
                }
                field("Processing DateTime"; Rec."Processing DateTime")
                {
                    ToolTip = 'Processing DateTime';
                    Editable = false;
                }
                field(ClientFileName; Rec.ClientFileName)
                {
                    ToolTip = 'Client File Name';
                    Editable = false;
                }
                field(DateResponse; Rec.DateResponse)
                {
                    ToolTip = 'Date Response';
                    Editable = false;
                }
                field("Execution Status"; Rec."Execution Status")
                {
                    ToolTip = 'Execution Status';
                    Editable = false;
                }
                field("Index Incarcare"; Rec."Index Incarcare")
                {
                    ToolTip = 'Index Incarcare';
                    Editable = false;
                }
                field("Stare Mesaj"; Rec."Stare Mesaj")
                {
                    ToolTip = 'Stare Mesaj';
                    Editable = false;
                }
                field("ID Descarcare"; Rec."ID Descarcare")
                {
                    ToolTip = 'ID Descarcare';
                    Editable = false;
                }
                field("Created Purchase Invoice No."; Rec."Created Purchase Invoice No.")
                {
                    ToolTip = 'Specifies the value of the Created Purchase Invoice No. field.';
                    Editable = false;
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field.';
                    Editable = false;
                }
                field("Document Currency Code"; Rec."Document Currency Code")
                {
                    ToolTip = 'Specifies the value of the Document Currency Code field.';
                    Editable = false;
                }
                field("Issue Date"; Rec."Issue Date")
                {
                    ToolTip = 'Specifies the value of the Issue Date field.';
                    Editable = false;
                }
                field("NAV Vendor Name"; Rec."NAV Vendor Name")
                {
                    ToolTip = 'Specifies the value of the NAV Vendor Name field.';
                    Editable = false;
                }
                field("NAV Vendor No."; Rec."NAV Vendor No.")
                {
                    ToolTip = 'Specifies the value of the NAV Vendor No. field.';
                    Editable = false;
                }
                field("Posted Purch. Credit Memo No."; Rec."Posted Purch. Credit Memo No.")
                {
                    ToolTip = 'Specifies the value of the Posted Purch. Credit Memo No. field.';
                    Editable = false;
                }
                field("Posted Purchase Invoice No."; Rec."Posted Purchase Invoice No.")
                {
                    ToolTip = 'Specifies the value of the Posted Purchase Invoice No. field.';
                    Editable = false;
                }
                field("Purch.Inv Amount Including VAT"; Rec."Purch.Inv Amount Including VAT")
                {
                    ToolTip = 'Specifies the value of the Purch.Inv Amount Including VAT field.';
                    Editable = false;
                }
                field("Purchase Invoice Amount"; Rec."Purchase Invoice Amount")
                {
                    ToolTip = 'Specifies the value of the Purchase Invoice Amount field.';
                    Editable = false;
                }
                field("Supplier ID"; Rec."Supplier ID")
                {
                    ToolTip = 'Specifies the value of the Supplier ID field.';
                    Editable = false;
                }
                field("Supplier Name"; Rec."Supplier Name")
                {
                    ToolTip = 'Specifies the value of the Supplier Name field.';
                    Editable = false;
                }
                field("Total Tax Amount"; Rec."Total Tax Amount")
                {
                    ToolTip = 'Specifies the value of the Total Tax Amount field.';
                    Editable = false;
                }
                field("Total TaxExclusiveAmount"; Rec."Total TaxExclusiveAmount")
                {
                    ToolTip = 'Specifies the value of the Total TaxExclusiveAmount field.';
                    Editable = false;
                }
                field("Total TaxInclusiveAmount"; Rec."Total TaxInclusiveAmount")
                {
                    ToolTip = 'Specifies the value of the Total TaxInclusiveAmount field.';
                    Editable = false;
                }
                field("Due Date"; Rec."Due Date")
                {
                    ToolTip = 'Specifies the value of the Due Date field.';
                    Editable = false;
                }
                field("Payment Method Code"; Rec."Payment Method Code")
                {
                    ToolTip = 'Specifies the value of the Payment Method Code field.';
                    Editable = false;
                }
                field("Vendor Invoice No."; Rec."Vendor Invoice No.")
                {
                    ToolTip = 'Specifies the value of the Vendor Invoice No. field.';
                    Editable = false;
                }

                field("Import Document Type"; Rec."Import Document Type")
                {
                    ToolTip = 'Specifies the value of the Import Document Type field.';
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
                action("Download ZIP File")
                {
                    Caption = 'Download ZIP File';
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ToolTip = 'Download ZIP File';

                    trigger OnAction()
                    var
                        TempEFTLogEntry: Record "SSAEDE-Documents Log Entry" temporary;
                        ANAFAPIMgt: Codeunit "SSAEDANAF API Mgt";
                        InStr: InStream;
                        FileName: Text;
                    begin
                        TempEFTLogEntry.Reset();
                        TempEFTLogEntry.DeleteAll();
                        TempEFTLogEntry.TransferFields(Rec);
                        TempEFTLogEntry.Insert();
                        case TempEFTLogEntry."Entry Type" of
                            TempEFTLogEntry."Entry Type"::"Export E-Transport":
                                CODEUNIT.Run(CODEUNIT::"SSAEDExport ETransport", TempEFTLogEntry);
                            TempEFTLogEntry."Entry Type"::"Import E-Factura", TempEFTLogEntry."Entry Type"::"Export E-Factura":
                                begin
                                    TempEFTLogEntry.TestField("ID Descarcare");
                                    ANAFAPIMgt.DescarcareMesaj(TempEFTLogEntry);
                                    TempEFTLogEntry."ZIP Content".CREATEINSTREAM(InStr);
                                    FileName := TempEFTLogEntry."Index Incarcare" + '.zip';
                                    DownloadFromStream(InStr, 'Save file', '', 'Zip File (*.zip)|*.zip', FileName);
                                end;
                        end;

                    end;
                }
                action("Download PDF File")
                {
                    Caption = 'Download PDF File';
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ToolTip = 'Download PDF File';

                    trigger OnAction()
                    var
                        ROFacturaTransportLogEntry: Record "SSAEDE-Documents Log Entry";
                        ANAFAPIMgt: Codeunit "SSAEDANAF API Mgt";
                        TempBlob: Codeunit "Temp Blob";
                        InStr: InStream;
                        FileName: Text;
                    begin
                        ROFacturaTransportLogEntry := Rec;
                        CurrPage.SetSelectionFilter(ROFacturaTransportLogEntry);

                        if ROFacturaTransportLogEntry."Entry Type" = ROFacturaTransportLogEntry."Entry Type"::"Import E-Factura" then begin
                            ROFacturaTransportLogEntry := Rec;
                            CurrPage.SetSelectionFilter(ROFacturaTransportLogEntry);
                            ROFacturaTransportLogEntry.TestField("ID Descarcare");
                            ANAFAPIMgt.DescarcareMesajPDF(ROFacturaTransportLogEntry, TempBlob);
                            TempBlob.CreateInStream(InStr);
                            FileName := Rec."ID Descarcare" + '.pdf';
                            DownloadFromStream(InStr, 'Save file', '', 'PDF File (*.pdf)|*.pdf', FileName);

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
                action(GetZIPContent)
                {
                    Caption = 'Get ZIP Content';
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ToolTip = 'Get ZIP Content';
                    trigger OnAction()
                    begin
                        Rec.DownloadZIPContent();
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
                        ROFacturaTransportLogEntry.TestField(Status, ROFacturaTransportLogEntry.Status::new);
                        if ROFacturaTransportLogEntry."Entry Type" = ROFacturaTransportLogEntry."Entry Type"::"Export E-Transport" then
                            CODEUNIT.Run(CODEUNIT::"SSAEDExport ETransport", ROFacturaTransportLogEntry);
                        if ROFacturaTransportLogEntry."Entry Type" = ROFacturaTransportLogEntry."Entry Type"::"Export E-Factura" then
                            CODEUNIT.Run(CODEUNIT::"SSAEDExport EFactura", ROFacturaTransportLogEntry);
                    end;
                }
                action("Save XML File")
                {
                    Caption = 'Save XML File';
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ToolTip = 'Save XML File';
                    trigger OnAction()
                    var
                        ROFacturaTransportLogEntry: Record "SSAEDE-Documents Log Entry";
                        ExportEFactura: Codeunit "SSAEDExport EFactura";
                    begin
                        ROFacturaTransportLogEntry := Rec;
                        if ROFacturaTransportLogEntry."Entry Type" = ROFacturaTransportLogEntry."Entry Type"::"Export E-Factura" then
                            ExportEFactura.ExportXMLFile(ROFacturaTransportLogEntry);
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


