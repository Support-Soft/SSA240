pageextension 70035 "SSA Item Category Card70035" extends "Item Category Card"
{
    layout
    {
        addafter("Parent Category")
        {
            field("SSA Inventory Posting Group"; "SSA Inventory Posting Group")
            {
                ApplicationArea = All;
            }
            field("SSA Gen. Prod. Posting Group"; "SSA Gen. Prod. Posting Group")
            {
                ApplicationArea = All;
            }
            field("SSA VAT Prod. Posting Group"; "SSA VAT Prod. Posting Group")
            {
                ApplicationArea = All;
            }
            field("SSA Costing Method"; "SSA Costing Method")
            {
                ApplicationArea = All;
            }
        }
    }
}

