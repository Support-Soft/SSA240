pageextension 70500 "SSA Cust. Ledger Entry 70500" extends "Customer Ledger Entries" //25
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


    actions
    {
    }
}