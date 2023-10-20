pageextension 70047 "SSA Purch. Receipt Lines" extends "Purch. Receipt Lines" //5806
{
    layout
    {
        addlast(Control1)
        {
            field("SSA Gen. Prod. Posting Group"; Rec."Gen. Prod. Posting Group")
            {
                ApplicationArea = All;
                Editable = false;
                Style = Strong;
                ToolTip = 'Specifies the value of the Gen. Prod. Posting Group field.';
            }
            field("SSA Vendor Invoice No."; Rec."SSA Vendor Invoice No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Vendor Invoice  No. field.';
            }
            field("SSA Vendor Shipment No."; Rec."SSA Vendor Shipment No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Vendor Shipment  No. field.';
            }
            field("SSA Custom Invoice No."; Rec."SSA Custom Invoice No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Custom Invoice No. field.';
            }
        }
    }
}