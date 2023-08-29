pageextension 71905 "SSAFTSales & Receivables Setup" extends "Sales & Receivables Setup"
{
    layout
    {
        addlast(content)
        {
            group(SSAFTSAFT)
            {
                Caption = 'SAFT';
                field("SSAFTSAFT Autofact Cust. No."; Rec."SSAFTSAFT Autofact Cust. No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the SAFT Autofactura Customer No. field.';
                }
            }
        }
    }
}