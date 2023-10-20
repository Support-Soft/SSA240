pageextension 70055 "SSA Sales Order Subform" extends "Sales Order Subform" //46
{
    layout
    {
        addlast(Control1)
        {
            field("SSA Tax Group Code"; Rec."Tax Group Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the tax group that is used to calculate and post sales tax.';
            }
        }
    }
}