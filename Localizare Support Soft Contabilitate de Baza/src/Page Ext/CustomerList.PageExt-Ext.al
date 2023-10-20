pageextension 70066 "SSA Customer List" extends "Customer List"
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
        }
    }

}
