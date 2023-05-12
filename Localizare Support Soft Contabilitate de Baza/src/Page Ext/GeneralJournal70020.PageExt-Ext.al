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
            field("SSA Tip Document D394"; "SSA Tip Document D394")
            {
                ApplicationArea = All;
            }
            field("SSA Stare Factura"; "SSA Stare Factura")
            {
                ApplicationArea = All;
            }
            field("SSA Tip Partener"; "SSA Tip Partener")
            {
                ApplicationArea = All;
            }
            field("SSA Custom Invoice No."; "SSA Custom Invoice No.")
            {
                ApplicationArea = All;
            }
            field("SSA Posting Group"; "SSA Posting Group")
            {
                ApplicationArea = All;
            }
        }
    }
}

