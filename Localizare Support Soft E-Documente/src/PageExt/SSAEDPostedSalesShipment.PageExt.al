pageextension 72001 "SSAEDPosted Sales Shipment" extends "Posted Sales Shipment"
{
    layout
    {
        addafter("Responsibility Center")
        {
            field("SSAEDNr. Inmatriculare"; Rec."SSAEDNr. Inmatriculare")
            {
                ApplicationArea = All;
                ToolTip = 'Nr. Inmatriculare';
            }
        }
    }
    actions
    {
        addafter("&Navigate")
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
                    SalesShipmentHeader: Record "Sales Shipment Header";
                    ExportETransport: Codeunit "SSAEDExport ETransport";
                begin
                    //SSM2002>>
                    SalesShipmentHeader := Rec;
                    CurrPage.SetSelectionFilter(SalesShipmentHeader);
                    Clear(ExportETransport);
                    ExportETransport.AddETransportLogEntry(SalesShipmentHeader);
                    //SSM2002<<
                end;
            }
        }
    }
}

