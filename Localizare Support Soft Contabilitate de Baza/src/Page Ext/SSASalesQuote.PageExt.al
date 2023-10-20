pageextension 70058 "SSA Sales Quote" extends "Sales Quote" //41
{
    layout
    {
        addlast("Shipping and Billing")
        {
            field("SSA Delivery Contact No."; Rec."SSA Delivery Contact No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Delivery Contact No. field.';
            }
        }
    }
}