pageextension 70057 "SSA Purchase Order Subform" extends "Purchase Order Subform" //54
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