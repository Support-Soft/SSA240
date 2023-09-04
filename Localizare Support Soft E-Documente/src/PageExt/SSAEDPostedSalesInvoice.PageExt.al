pageextension 72002 "SSAEDPosted Sales Invoice" extends "Posted Sales Invoice"
{
    layout
    {
        addafter("Your Reference")
        {
            field("SSAEDNr. Inmatriculare"; Rec."SSAEDNr. Inmatriculare")
            {
                ApplicationArea = All;
                ToolTip = 'Nr. Inmatriculare';
            }
        }
        addafter("Ship-to City")
        {
            field("SSAEDShip-to Sector"; Rec."SSAEDShip-to Sector")
            {
                ApplicationArea = All;
                ToolTip = 'Ship-to Sector';
            }
        }
    }
    actions
    {
        addafter(ActivityLog)
        {
            action("SSAEDSend ETransport")
            {
                Caption = 'Send ETransport';
                Image = ElectronicDoc;
                ApplicationArea = All;
                ToolTip = 'Send ETransport';
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = Process;

                trigger OnAction()
                var
                    SalesInvoiceHeader: Record "Sales Invoice Header";
                    ExportETransport: Codeunit "SSAEDExport ETransport";
                begin
                    //SSM2002>>
                    SalesInvoiceHeader := Rec;
                    CurrPage.SetSelectionFilter(SalesInvoiceHeader);
                    Clear(ExportETransport);
                    ExportETransport.AddETransportLogEntry(SalesInvoiceHeader);
                    //SSM2002<<
                end;
            }
            action("SSAEDSend EFactura")
            {
                Caption = 'Send EFactura';
                Image = ElectronicDoc;
                ApplicationArea = All;
                ToolTip = 'Send EFactura';
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = Process;

                trigger OnAction()
                var
                    SalesInvoiceHeader: Record "Sales Invoice Header";
                    ExportEFactura: Codeunit "SSAEDExport EFactura";
                begin
                    //SSM1997>>
                    SalesInvoiceHeader := Rec;
                    CurrPage.SetSelectionFilter(SalesInvoiceHeader);
                    Clear(ExportEFactura);
                    ExportEFactura.AddEFacturaLogEntry(SalesInvoiceHeader);
                    //SSM1997<<
                end;
            }
        }
    }
}

