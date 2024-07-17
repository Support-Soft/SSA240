pageextension 71904 "SSAFTFixed Asset Setup" extends "Fixed Asset Setup"
{
    layout
    {
        addlast(content)
        {
            group(SSAFT)
            {
                Caption = 'SAFT';


                field("SSAFT Posting Group Filter"; Rec."SSAFT Posting Group Filter")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the SAFT FA Posting Group Filter field.', Comment = 'SAFT Filtru Grupa inreg. MF';
                }
            }
        }
    }
}