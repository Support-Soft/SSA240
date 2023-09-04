pageextension 72012 "Posted Sales Inv. - Update" extends "Posted Sales Inv. - Update"
{
    layout
    {
        addlast(General)
        {
            field("SSAEDShip-to Sector"; Rec."SSAEDShip-to Sector")
            {
                ApplicationArea = All;
                ToolTip = 'The Ship-to Sector of the customer. This field is used to determine the Ship-to Sector of the customer when the customer is not specified on the sales document line.';
            }
        }
    }

}

