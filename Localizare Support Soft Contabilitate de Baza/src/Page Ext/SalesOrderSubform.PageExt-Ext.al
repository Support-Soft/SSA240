pageextension 70055 "SSA Sales Order Subform" extends "Sales Order Subform" //46
{
    layout
    {
        addlast(Control1)
        {
            field("SSA Tax Group Code"; "Tax Group Code")
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
    }
}