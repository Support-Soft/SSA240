pageextension 70067 "SSA Vendor List" extends "Vendor List"
{
    layout
    {
        addlast(Control1)
        {
            field("SSA Commerce Trade No."; Rec."SSA Commerce Trade No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Commerce Trade No. field.';
            }
            field("SSA VAT to Pay"; Rec."SSA VAT to Pay")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the VAT to Pay field.';
            }
        }
    }
}
