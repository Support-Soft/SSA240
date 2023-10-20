tableextension 70056 "SSA Item Journal Line 70056" extends "Item Journal Line"
{
    // SSA935 SSCAT 15.06.2019 1.Funct. anulare stocuri in rosu
    // SSA937 SSCAT 16.06.2019 3.Funct. Bonuri de consum-consum intern
    // SSA946 SSCAT 26.09.2019 12.Funct. functionalitate DVI la achizitii
    fields
    {
        field(70000; "SSA Correction Cost"; Boolean)
        {
            Caption = 'Correction Cost';
            DataClassification = CustomerContent;
            Description = 'SSA935';
        }
        field(70001; "SSA Correction Cost Inv. Val."; Boolean)
        {
            Caption = 'Correction Cost Inv. Valuation';
            DataClassification = CustomerContent;
        }
        field(70002; "SSA Custom Invoice No."; Code[20])
        {
            Caption = 'Custom Invoice No.';
            DataClassification = CustomerContent;
            Description = 'SSA946';
        }
        field(70003; "SSA Document Type"; Option)
        {
            Caption = 'Document Type';
            OptionMembers = ,"Internal Consumption";
            OptionCaption = ',Internal Consumption';
            DataClassification = CustomerContent;
        }
    }
}
