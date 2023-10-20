pageextension 70002 "SSA Countries/Regions 70002" extends "Countries/Regions"
{
    // SSA971 SSCAT 07.10.2019 37.Funct. grupe contabilitate, grupe de tva exigibile si nexigibile pe fz. si client
    layout
    {
        addafter("VAT Scheme")
        {
            field("SSA Vendor Neex. VATPstgGroup"; Rec."SSA Vendor Neex. VATPstgGroup")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Vendor Neex. VAT Posting Group field.';
            }
            field("SSA Vendor Ex. VATPstgGroup"; Rec."SSA Vendor Ex. VATPstgGroup")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Vendor Ex. VAT Posting Group field.';
            }
            field("SSA Cust. Neex. VATPstgGroup"; Rec."SSA Cust. Neex. VATPstgGroup")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Cust. Neex. VAT Posting Group field.';
            }
            field("SSA Cust. Ex. VATPstgGroup"; Rec."SSA Cust. Ex. VATPstgGroup")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Cust. Ex. VAT Posting Group field.';
            }
            field("SSA Vendor Posting Group"; Rec."SSA Vendor Posting Group")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Vendor Posting Group field.';
            }
            field("SSA Customer Posting Group"; Rec."SSA Customer Posting Group")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Customer Posting Group field.';
            }
            field("SSA Vendor GenBusPstgGroup"; Rec."SSA Vendor GenBusPstgGroup")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Vendor Gen. Bus. Posting Group field.';
            }
            field("SSA Cust. GenBusPostingGroup"; Rec."SSA Cust. GenBusPostingGroup")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Vendor Gen. Bus. Posting Group field.';
            }
        }
    }
}
