pageextension 70067 "SSA Vendor List" extends "Vendor List"
{
    layout
    {
        addlast(Control1)
        {
            field("SSA Commerce Trade No."; "SSA Commerce Trade No.")
            {
                ApplicationArea = All;
            }
            field("SSA VAT to Pay"; "SSA VAT to Pay")
            {
                ApplicationArea = All;
            }
        }
    }
    actions
    {
    }

}

