tableextension 70021 "SSA Item Ledger Entry 70021" extends "Item Ledger Entry"
{
    // SSA937 SSCAT 16.06.2019 3.Funct. Bonuri de consum-consum intern
    // SSA946 SSCAT 26.09.2019 12.Funct. functionalitate DVI la achizitii
    fields
    {
        field(70000; "SSA Custom Invoice No."; Code[20])
        {
            Caption = 'Custom Invoice No.';
            DataClassification = CustomerContent;
            Description = 'SSA946';
        }
        field(70001; "SSA Document Type"; Option)
        {
            Caption = 'Document Type';
            OptionMembers = ,"Internal Consumption";
            OptionCaption = ',Internal Consumption';
            DataClassification = CustomerContent;
        }
    }
}
