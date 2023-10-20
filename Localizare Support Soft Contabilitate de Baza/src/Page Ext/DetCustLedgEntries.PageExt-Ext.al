pageextension 70059 "SSA Det. Cust. Ledg. Entries" extends "Detailed Cust. Ledg. Entries"
{
    layout
    {
        addlast(Control1)
        {
            field("SSA Customer Posting Group"; Rec."SSA Customer Posting Group")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Customer Posting Group field.';
            }
        }
    }
}