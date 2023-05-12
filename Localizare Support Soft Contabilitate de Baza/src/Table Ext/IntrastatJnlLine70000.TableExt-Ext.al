tableextension 70000 "SSA Intrastat Jnl. Line 70000" extends "Intrastat Jnl. Line"
{
    fields
    {
        // Add changes to table fields here
        field(70000; "SSA Source Type"; Option)
        {
            Caption = 'SSA Source Type';
            OptionMembers = ,"FA Entry";
            OptionCaption = ',FA Entry';
        }
    }
}