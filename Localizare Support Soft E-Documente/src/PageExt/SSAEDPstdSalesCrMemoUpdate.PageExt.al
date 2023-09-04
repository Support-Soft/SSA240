pageextension 72011 "Pstd. Sales Cr. Memo - Update" extends "Pstd. Sales Cr. Memo - Update"
{
    layout
    {
        addlast(General)
        {
            field("SSAEDShip-to Sector"; Rec."SSAEDShip-to Sector")
            {
                ApplicationArea = All;
                ToolTip = 'The Ship-to Sector of the customer';
            }
        }
    }

}

