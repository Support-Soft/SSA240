pageextension 70056 "SSA Sales Invoice Subform" extends "Sales Invoice Subform" //47
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