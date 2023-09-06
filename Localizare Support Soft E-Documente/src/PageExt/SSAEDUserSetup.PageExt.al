pageextension 72009 "SSAEDUser Setup" extends "User Setup"
{
    layout
    {
        addlast(Control1)
        {
            field("SSAEDAllow Edit PostedSalesDoc"; Rec."SSAEDAllow Edit PostedSalesDoc")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Allow Edit Posted Sales Doc field.';
            }
        }

    }
}