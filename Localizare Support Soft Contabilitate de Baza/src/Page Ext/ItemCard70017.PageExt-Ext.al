pageextension 70017 "SSA Item Card 70017" extends "Item Card"
{
    layout
    {
        addafter(Description)
        {
            field("SSA Full Description"; Rec."SSA Full Description")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Full Description field.';
            }
        }
        addlast(InventoryGrp)
        {
            field("SSA Tax Group Code"; Rec."Tax Group Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the tax group that is used to calculate and post sales tax.';
            }
        }
    }
}
