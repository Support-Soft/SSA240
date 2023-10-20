pageextension 70034 "SSA FixedAssetG/LJournal70034" extends "Fixed Asset G/L Journal"
{
    // SSA953 SSCAT 25.09.2019 19.Funct. intrastat
    // SSA946 SSCAT 26.09.2019 12.Funct. functionalitate DVI la achizitii
    layout
    {
        addafter(ShortcutDimCode8)
        {
            field("SSA Transaction Type"; Rec."SSA Transaction Type")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Transaction Type field.';
            }
            field("SSA Transport Method"; Rec."SSA Transport Method")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Transport Method field.';
            }
            field("SSA Entry/Exit Point"; Rec."SSA Entry/Exit Point")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Entry/Exit Point field.';
            }
            field("SSA Area"; Rec."SSA Area")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Area field.';
            }
            field("SSA Transaction Specification"; Rec."SSA Transaction Specification")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Transaction Specification field.';
            }
            field("SSA Shpt. Method Code"; Rec."SSA Shpt. Method Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Shpt. Method Code field.';
            }
            field("SSA Country/Region Code"; Rec."Country/Region Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Country/Region Code field.';
            }
            field("SSA Custom Invoice No."; Rec."SSA Custom Invoice No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Custom Invoice No. field.';
            }
        }
    }
}
