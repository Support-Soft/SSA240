pageextension 72010 "SSAEDPosted Transfer Shipment" extends "Posted Transfer Shipment"
{
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
                    TransferShipmentHeader: Record "Transfer Shipment Header";
                    ExportETransport: Codeunit "SSAEDExport ETransport";
                begin
                    //SSM2002>>
                    TransferShipmentHeader := Rec;
                    CurrPage.SetSelectionFilter(TransferShipmentHeader);
                    Clear(ExportETransport);
                    ExportETransport.AddETransportLogEntry(TransferShipmentHeader);
                    //SSM2002<<
                end;
            }
        }
    }
}

