pageextension 70049 "SSA Posted Trans. Rcpt. Lines" extends "Posted Transfer Receipt Lines" //5759
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
        }
    }
}