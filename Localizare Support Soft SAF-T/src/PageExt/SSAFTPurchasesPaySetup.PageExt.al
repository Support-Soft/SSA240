pageextension 71904 "SSAFTPurchases & Pay Setup" extends "Purchases & Payables Setup"
{
    layout
    {
        addlast(content)
        {
            group(SSAFTSAFT)
            {
                Caption = 'SAFT';
                field("SSAFTExcl. Vendor Posting Grp"; Rec."SSAFTExcl. Vendor Posting Grp")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the SAFT Excl. Vendor Posting Grp field.';
                }
            }
        }
    }
}