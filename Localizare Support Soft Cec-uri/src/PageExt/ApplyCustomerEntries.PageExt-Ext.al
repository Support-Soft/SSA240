pageextension 70507 "SSA Apply Customer Entries" extends "Apply Customer Entries"
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