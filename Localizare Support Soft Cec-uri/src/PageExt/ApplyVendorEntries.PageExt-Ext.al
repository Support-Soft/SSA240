pageextension 70506 "SSA Apply Vendor Entries" extends "Apply Vendor Entries"
{
    layout
    {
        addlast(Control1)
        {
            field("SSA Applied Amount CEC/BO"; "SSA Applied Amount CEC/BO")
            {
                ApplicationArea = All;
            }
        }
    }

}