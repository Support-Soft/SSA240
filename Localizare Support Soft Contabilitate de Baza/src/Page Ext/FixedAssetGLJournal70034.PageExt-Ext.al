pageextension 70034 "SSA FixedAssetG/LJournal70034" extends "Fixed Asset G/L Journal"
{
    // SSA953 SSCAT 25.09.2019 19.Funct. intrastat
    // SSA946 SSCAT 26.09.2019 12.Funct. functionalitate DVI la achizitii
    layout
    {
        addafter(ShortcutDimCode8)
        {
            field("SSA Transaction Type"; "SSA Transaction Type")
            {
                ApplicationArea = All;
            }
            field("SSA Transport Method"; "SSA Transport Method")
            {
                ApplicationArea = All;
            }
            field("SSA Entry/Exit Point"; "SSA Entry/Exit Point")
            {
                ApplicationArea = All;
            }
            field("SSA Area"; "SSA Area")
            {
                ApplicationArea = All;
            }
            field("SSA Transaction Specification"; "SSA Transaction Specification")
            {
                ApplicationArea = All;
            }
            field("SSA Shpt. Method Code"; "SSA Shpt. Method Code")
            {
                ApplicationArea = All;
            }
            field("SSA Country/Region Code"; "Country/Region Code")
            {
                ApplicationArea = All;
            }
            field("SSA Custom Invoice No."; "SSA Custom Invoice No.")
            {
                ApplicationArea = All;
            }
        }
    }
}

