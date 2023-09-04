pageextension 72006 "SSAEDShip-to Address" extends "Ship-to Address"
{
    layout
    {
        addafter(ShowMap)
        {
            field(SSAEDSector; Rec."SSAEDSector Bucuresti")
            {
                ApplicationArea = All;
                ToolTip = 'Sector';
            }
        }
    }
}

