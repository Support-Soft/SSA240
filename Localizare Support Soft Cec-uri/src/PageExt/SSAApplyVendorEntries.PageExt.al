pageextension 70506 "SSA Apply Vendor Entries" extends "Apply Vendor Entries"
{
    layout
    {
        addlast(Control1)
        {
            field("SSA Applied Amount CEC/BO"; Rec."SSA Applied Amount CEC/BO")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Applied Amount CEC/BO field.';
            }
        }
    }
}