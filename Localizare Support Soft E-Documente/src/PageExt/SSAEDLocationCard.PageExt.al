pageextension 72016 "SSAEDLocation Card" extends "Location Card"
{
    layout
    {
        addlast(AddressDetails)
        {
            field("SSAEDSector Bucuresti"; Rec."SSAEDSector Bucuresti")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the SSAEDSector Bucuresti field.';
            }
        }
    }
}