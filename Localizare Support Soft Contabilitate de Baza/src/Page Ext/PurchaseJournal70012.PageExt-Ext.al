pageextension 70012 "SSA Purchase Journal70012" extends "Purchase Journal"
{
    // #1..7
    //
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
