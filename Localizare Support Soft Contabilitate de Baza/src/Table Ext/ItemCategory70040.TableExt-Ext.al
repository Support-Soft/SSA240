tableextension 70040 "SSA Item Category70040" extends "Item Category"
{
    fields
    {
        field(70000; "SSA Inventory Posting Group"; Code[20])
        {
            Caption = 'Inventory Posting Group';
            DataClassification = CustomerContent;
            Description = 'SSA962';
            TableRelation = "Inventory Posting Group";
        }
        field(70001; "SSA Gen. Prod. Posting Group"; Code[20])
        {
            Caption = 'Gen. Prod. Posting Group';
            DataClassification = CustomerContent;
            Description = 'SSA962';
            TableRelation = "Gen. Product Posting Group";
        }
        field(70002; "SSA VAT Prod. Posting Group"; Code[20])
        {
            Caption = 'VAT Prod. Posting Group';
            DataClassification = CustomerContent;
            Description = 'SSA962';
            TableRelation = "VAT Product Posting Group";
        }
        field(70003; "SSA Costing Method"; Option)
        {
            Caption = 'Costing Method';
            DataClassification = CustomerContent;
            Description = 'SSA962';
            OptionCaption = 'FIFO,LIFO,Specific,Average,Standard';
            OptionMembers = FIFO,LIFO,Specific,"Average",Standard;
        }
    }
}
