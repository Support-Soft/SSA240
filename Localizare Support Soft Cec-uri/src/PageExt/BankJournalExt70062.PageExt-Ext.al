pageextension 70505 "SSA Bank Journal Ext.70062" extends "SSA Bank Journal"
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
}