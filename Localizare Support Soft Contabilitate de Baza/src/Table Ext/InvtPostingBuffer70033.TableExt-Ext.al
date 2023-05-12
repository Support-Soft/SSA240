tableextension 70033 "SSA Invt. Posting Buffer70033" extends "Invt. Posting Buffer"
{
    // SSA935 SSCAT 15.06.2019 1.Funct. anulare stocuri in rosu
    fields
    {
        field(70000; "SSA Correction Cost"; Boolean)
        {
            Caption = 'Correction Cost';
            DataClassification = ToBeClassified;
            Description = 'SSA935';
        }
    }
}

