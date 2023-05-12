pageextension 70036 "SSA Value Entries70036" extends "Value Entries"
{
    // SSA946 SSCAT 26.09.2019 12.Funct. functionalitate DVI la achizitii
    layout
    {
        addafter("Dimension Set ID")
        {
            field("SSA Custom Invoice No."; "SSA Custom Invoice No.")
            {
                ApplicationArea = All;
            }
        }
    }
}

