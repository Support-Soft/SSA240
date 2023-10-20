pageextension 70039 "SSA Item Ledger Entries 70039" extends "Item Ledger Entries"
{
    layout
    {
        addlast(Control1)
        {
            field("SSA Document Type"; Rec."SSA Document Type")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the SSA Document Type field.';
            }
        }
    }

}