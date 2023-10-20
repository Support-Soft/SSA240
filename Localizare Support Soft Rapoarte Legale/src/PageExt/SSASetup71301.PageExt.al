pageextension 71301 "SSA Setup 71301" extends "SSA Localization Setup"
{
    layout
    {
        addlast("General Ledger Setup")
        {
            field("SSA Accounting Depr. Book"; Rec."SSA Accounting Depr. Book")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Accounting Depreciation Book field.';
            }
        }
    }
}