pageextension 72003 "SSAEDPosted Sales Credit Memo" extends "Posted Sales Credit Memo"
{
    layout
    {
        addafter("Ship-to City")
        {
            field("SSAEDShip-to Sector"; Rec."SSAEDShip-to Sector")
            {
                ApplicationArea = All;
                ToolTip = 'Sector';
            }
        }
    }
    actions
    {
        addafter(ActivityLog)
        {
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
                    SalesCrMemoHeader: Record "Sales Cr.Memo Header";
                    ExportEFactura: Codeunit "SSAEDExport EFactura";
                begin
                    //SSM1997>>
                    SalesCrMemoHeader := Rec;
                    CurrPage.SetSelectionFilter(SalesCrMemoHeader);
                    Clear(ExportEFactura);
                    ExportEFactura.AddEFacturaLogEntry(SalesCrMemoHeader);
                    //SSM1997<<
                end;
            }
        }
    }
}

