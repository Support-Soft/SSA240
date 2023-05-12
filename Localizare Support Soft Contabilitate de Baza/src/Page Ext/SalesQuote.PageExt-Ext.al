pageextension 70058 "SSA Sales Quote" extends "Sales Quote" //41
{
    layout
    {
        addlast("Shipping and Billing")
        {
            field("SSA Delivery Contact No."; "SSA Delivery Contact No.")
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
    }
}