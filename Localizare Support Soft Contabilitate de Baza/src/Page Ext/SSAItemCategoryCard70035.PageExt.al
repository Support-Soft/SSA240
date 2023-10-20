pageextension 70035 "SSA Item Category Card70035" extends "Item Category Card"
{
    layout
    {
        addafter("Parent Category")
        {
            field("SSA Inventory Posting Group"; Rec."SSA Inventory Posting Group")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Inventory Posting Group field.';
            }
            field("SSA Gen. Prod. Posting Group"; Rec."SSA Gen. Prod. Posting Group")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Gen. Prod. Posting Group field.';
            }
            field("SSA VAT Prod. Posting Group"; Rec."SSA VAT Prod. Posting Group")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the VAT Prod. Posting Group field.';
            }
            field("SSA Costing Method"; Rec."SSA Costing Method")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Costing Method field.';
            }
        }
    }
}
