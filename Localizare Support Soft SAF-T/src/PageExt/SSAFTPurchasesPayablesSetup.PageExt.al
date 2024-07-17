pageextension 71908 "Purchases & Payables Setup" extends "Purchases & Payables Setup"
{
    layout
    {
        addlast(Content)
        {
            group(SSAFT)
            {
                Caption = 'SAFT';
                field("SSAFT Excl. Vendor Posting Grp"; Rec."SSAFT Excl. Vendor Posting Grp")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the SAFT Excl. Vendor Posting Grp field.';
                }
            }
        }
    }
}