pageextension 70041 "SSA IC General Journal70041" extends "IC General Journal"
{
    // SSA946 SSCAT 26.09.2019 12.Funct. functionalitate DVI la achizitii
    layout
    {
        addafter(ShortcutDimCode8)
        {
            field("SSA Custom Invoice No."; Rec."SSA Custom Invoice No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Custom Invoice No. field.';
            }
        }
    }
}
