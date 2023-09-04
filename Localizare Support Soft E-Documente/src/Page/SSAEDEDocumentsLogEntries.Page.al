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
            repeater(Group)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    ToolTip = 'Entry No.';
                }
                field("Export Type"; Rec."Export Type")
                {
                    ToolTip = 'Export Type';
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
            }
        }
    }

    actions
    {
        area(processing)
        {
            group(ActionGroup)
            {
                Caption = 'Process';
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
                action("Download XML File")
                {
                    Caption = 'Download XML File';
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ToolTip = 'Download XML File';

                    trigger OnAction()
                    var
                        ROFacturaTransportLogEntry: Record "SSAEDE-Documents Log Entry";
                        ExportEFactura: Codeunit "SSAEDExport EFactura";
                    begin
                        ROFacturaTransportLogEntry := Rec;
                        CurrPage.SetSelectionFilter(ROFacturaTransportLogEntry);
                        if ROFacturaTransportLogEntry."Export Type" = ROFacturaTransportLogEntry."Export Type"::"E-Transport" then
                            CODEUNIT.Run(CODEUNIT::"SSAEDExport ETransport", ROFacturaTransportLogEntry);
                        if ROFacturaTransportLogEntry."Export Type" = ROFacturaTransportLogEntry."Export Type"::"E-Factura" then
                            ExportEFactura.ExportXMLFile(ROFacturaTransportLogEntry);
                    end;
                }
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
                        if ROFacturaTransportLogEntry."Export Type" = ROFacturaTransportLogEntry."Export Type"::"E-Transport" then
                            CODEUNIT.Run(CODEUNIT::"SSAEDExport ETransport", ROFacturaTransportLogEntry);
                        if ROFacturaTransportLogEntry."Export Type" = ROFacturaTransportLogEntry."Export Type"::"E-Factura" then
                            CODEUNIT.Run(CODEUNIT::"SSAEDExport EFactura", ROFacturaTransportLogEntry);
                    end;
                }
                action("Download Zip File")
                {
                    Caption = 'Download Zip File';
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ToolTip = 'Download Zip File';
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
                        ROFacturaTransportLogEntry.TestField("ID Descarcare");
                        ANAFAPIMgt.DescarcareMesaj(ROFacturaTransportLogEntry."ID Descarcare", TempBlob);
                        TempBlob.CreateInStream(InStr, TEXTENCODING::UTF8);
                        DownloadFromStream(InStr, 'Save file', '', '', FileName);
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
}

