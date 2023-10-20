pageextension 70502 "SSA General Journal 70502" extends "General Journal" //39
{
    layout
    {
        addlast(Control1)
        {
            field("SSA Applies-to CEC No."; Rec."SSA Applies-to CEC No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Applies-to CEC No. field.';
            }
        }
    }

    actions
    {
    }
}