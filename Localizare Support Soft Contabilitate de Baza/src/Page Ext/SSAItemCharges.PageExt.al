pageextension 70054 "SSA Item Charges" extends "Item Charges" //5800
{
    layout
    {
        addlast(Control1)
        {
            field("SSA Type"; Rec."SSA Type")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Type field.';
            }
        }
    }
}