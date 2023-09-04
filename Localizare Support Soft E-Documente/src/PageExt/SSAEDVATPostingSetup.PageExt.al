pageextension 72008 "SSAEDVAT Posting Setup" extends "VAT Posting Setup"
{
    layout
    {
        addafter("Tax Category")
        {
            field("SSAEDETransport codTipOperatiune"; Rec."SSAEDET codTipOperatiune")
            {
                ApplicationArea = All;
                ToolTip = 'Transport';
            }
        }
    }
}

