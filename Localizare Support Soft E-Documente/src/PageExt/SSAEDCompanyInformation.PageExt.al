pageextension 72000 "SSAEDCompany Information" extends "Company Information"
{
    layout
    {
        addafter(City)
        {
            field(SSAEDSector; Rec."SSAEDSector")
            {
                ToolTip = 'Sector';
                ApplicationArea = All;
            }
        }
    }
}