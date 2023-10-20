pageextension 70070 "SSA Phys. Inv. Journal 70070" extends "Phys. Inventory Journal"
{
    layout
    {
        addlast(Control1)
        {
            field("SSA Correction Cost"; Rec."SSA Correction Cost")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Correction Cost field.';
            }
            field("SSA Correction Cost Inv. Val."; Rec."SSA Correction Cost Inv. Val.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Correction Cost Inv. Valuation field.';
            }
        }
    }
}