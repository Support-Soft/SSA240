pageextension 70002 "SSA Countries/Regions 70002" extends "Countries/Regions"
{
    // SSA971 SSCAT 07.10.2019 37.Funct. grupe contabilitate, grupe de tva exigibile si nexigibile pe fz. si client
    layout
    {
        addafter("VAT Scheme")
        {
            field("SSA Vendor Neex. VATPstgGroup"; "SSA Vendor Neex. VATPstgGroup")
            {
                ApplicationArea = All;
            }
            field("SSA Vendor Ex. VATPstgGroup"; "SSA Vendor Ex. VATPstgGroup")
            {
                ApplicationArea = All;
            }
            field("SSA Cust. Neex. VATPstgGroup"; "SSA Cust. Neex. VATPstgGroup")
            {
                ApplicationArea = All;
            }
            field("SSA Cust. Ex. VATPstgGroup"; "SSA Cust. Ex. VATPstgGroup")
            {
                ApplicationArea = All;
            }
            field("SSA Vendor Posting Group"; "SSA Vendor Posting Group")
            {
                ApplicationArea = All;
            }
            field("SSA Customer Posting Group"; "SSA Customer Posting Group")
            {
                ApplicationArea = All;
            }
            field("SSA Vendor GenBusPstgGroup"; "SSA Vendor GenBusPstgGroup")
            {
                ApplicationArea = All;
            }
            field("SSA Cust. GenBusPostingGroup"; "SSA Cust. GenBusPostingGroup")
            {
                ApplicationArea = All;
            }
        }
    }
}

