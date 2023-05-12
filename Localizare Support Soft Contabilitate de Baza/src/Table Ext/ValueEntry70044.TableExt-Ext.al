tableextension 70044 "SSA Value Entry70044" extends "Value Entry"
{
    // SSA935 SSCAT 15.06.2019 1.Funct. anulare stocuri in rosu
    // SSA937 SSCAT 16.06.2019 3.Funct. Bonuri de consum-consum intern
    // SSA946 SSCAT 26.09.2019 12.Funct. functionalitate DVI la achizitii
    fields
    {
        field(70000; "SSA Correction Cost"; Boolean)
        {
            Caption = 'Correction Cost';
            DataClassification = ToBeClassified;
            Description = 'SSA935';
        }
        field(70001; "SSA Correction Cost Inv. Val."; Boolean)
        {
            Caption = 'Correction Cost Inv. Valuation';
            DataClassification = ToBeClassified;
            Description = 'SSA935';
        }
        field(70002; "SSA Custom Invoice No."; Code[20])
        {
            Caption = 'Custom Invoice No.';
            DataClassification = ToBeClassified;
            Description = 'SSA946';
        }
    }
}

