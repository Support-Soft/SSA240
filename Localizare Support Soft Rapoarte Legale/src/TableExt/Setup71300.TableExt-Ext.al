tableextension 71300 "SSA Setup71300" extends "SSA Localization Setup"
{
    fields
    {
        field(71300; "SSA Accounting Depr. Book"; Code[10])
        {
            Caption = 'Accounting Depreciation Book';
            TableRelation = "Depreciation Book";
        }

    }

}