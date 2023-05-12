pageextension 70039 "SSA Item Ledger Entries 70039" extends "Item Ledger Entries"
{
    layout
    {
        addlast(Control1)
        {
            field("SSA Document Type"; "SSA Document Type")
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        // Add changes to page actions here
    }

}