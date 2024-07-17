pageextension 71905 "SSAFTSales & Receivables Setup" extends "Sales & Receivables Setup"
{
    layout
    {
        addlast(content)
        {
            group(SSAFT)
            {
                Caption = 'SAFT';
                field("SSAFT Autofact Cust. No."; Rec."SSAFT Autofact Cust. No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the SAFT Autofactura Customer No. field.';
                }
            }
        }
    }
}