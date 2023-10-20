pageextension 70057 "SSA Purchase Order Subform" extends "Purchase Order Subform" //54
{
    layout
    {
        addlast(Control1)
        {
            field("SSA Tax Group Code"; Rec."Tax Group Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the tax group code for the tax detail entry.';
            }
        }
    }
}