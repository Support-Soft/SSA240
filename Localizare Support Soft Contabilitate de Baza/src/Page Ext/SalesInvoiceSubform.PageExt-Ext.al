pageextension 70056 "SSA Sales Invoice Subform" extends "Sales Invoice Subform" //47
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