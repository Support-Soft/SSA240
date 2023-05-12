pageextension 70013 "SSA Cash Receipt Journal70013" extends "Cash Receipt Journal"
{
    // SSA946 SSCAT 26.09.2019 12.Funct. functionalitate DVI la achizitii
    layout
    {
        addafter(ShortcutDimCode8)
        {
            field("SSA Custom Invoice No."; "SSA Custom Invoice No.")
            {
                ApplicationArea = All;
            }
        }
    }
}

