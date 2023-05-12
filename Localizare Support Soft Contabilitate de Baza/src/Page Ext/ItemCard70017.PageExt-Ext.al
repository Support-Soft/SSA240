pageextension 70017 "SSA Item Card 70017" extends "Item Card"
{
    layout
    {
        addafter(Description)
        {
            field("SSA Full Description"; "SSA Full Description")
            {
                ApplicationArea = All;
            }
        }
        addlast(InventoryGrp)
        {
            field("SSA Tax Group Code"; "Tax Group Code")
            {
                ApplicationArea = All;
            }
        }
    }
}

