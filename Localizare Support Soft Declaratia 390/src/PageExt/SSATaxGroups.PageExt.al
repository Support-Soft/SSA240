pageextension 71502 "SSA Tax Groups" extends "Tax Groups" //467
{
    layout
    {
        addlast(Control1)
        {
            field("SSA 390 Type"; Rec."SSA 390 Type")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the 390 Type field.';
            }
        }
    }

    actions
    {
    }
}