pageextension 70020 "SSA General Journal70020" extends "General Journal"
{
    // #1..7
    //
    // SSA973 SSCAT 06.09.2019 39.Rapoarte legale- Localizare Declaratia 394
    // SSA946 SSCAT 26.09.2019 12.Funct. functionalitate DVI la achizitii
    layout
    {
        addafter(ShortcutDimCode8)
        {
            field("SSA Tip Document D394"; Rec."SSA Tip Document D394")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Tip Document D394 field.';
            }
            field("SSA Stare Factura"; Rec."SSA Stare Factura")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Stare Factura field.';
            }
            field("SSA Tip Partener"; Rec."SSA Tip Partener")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Tip Partener field.';
            }
            field("SSA Custom Invoice No."; Rec."SSA Custom Invoice No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Custom Invoice No. field.';
            }
            field("SSA Posting Group"; Rec."SSA Posting Group")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Custom Posting Group field.';
            }
        }
    }
}
