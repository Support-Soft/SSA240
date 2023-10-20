pageextension 70501 "SSA Vend. Ledger Entry 70501" extends "Vendor Ledger Entries" //29
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

    actions
    {
    }
}