pageextension 70070 "SSA Phys. Inv. Journal 70070" extends "Phys. Inventory Journal"
{
    layout
    {
        addlast(Control1)
        {
            field("SSA Correction Cost"; "SSA Correction Cost")
            {
                ApplicationArea = All;
            }
            field("SSA Correction Cost Inv. Val."; "SSA Correction Cost Inv. Val.")
            {
                ApplicationArea = All;
            }
        }
    }
}