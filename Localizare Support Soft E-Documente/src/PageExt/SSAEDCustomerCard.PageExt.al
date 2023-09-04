pageextension 72004 "SSAEDCustomer Card" extends "Customer Card"
{
    layout
    {
        addlast(General)
        {
            field("SSAEDPrin EFactura"; Rec."SSAEDPrin EFactura")
            {
                ToolTip = 'Prin EFactura';
                ApplicationArea = All;
            }
        }
        addafter(City)
        {
            field("SSAEDSector Bucuresti"; Rec."SSAEDSector Bucuresti")
            {
                Editable = SectorBucurestiEditable;
                ApplicationArea = All;
                ToolTip = 'Sector Bucuresti';
            }
            field(SSAEDCounty; Rec.County)
            {
                ApplicationArea = All;
                ToolTip = 'Judet';
            }
        }
    }

    var
        SectorBucurestiEditable: Boolean;

    trigger OnAfterGetCurrRecord()
    begin
        if UpperCase(Rec.County) in ['BUCURESTI', 'MUNICIPIUL BUCUREŞTI'] then
            SectorBucurestiEditable := true
        else
            SectorBucurestiEditable := false;
        //SSM1997<<
    end;
}

