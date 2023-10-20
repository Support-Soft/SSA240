pageextension 70027 "SSA VATProductPstgGroups70027" extends "VAT Product Posting Groups"
{
    // SSA948 SSCAT 08.10.2019 14.Funct. Functionalitatea deductibilitate cheltuieli 50% /100%
    layout
    {
        addafter(Description)
        {
            field("SSA Non-Deductible VAT"; Rec."SSA Non-Deductible VAT")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Non-Deductible VAT field.';
            }
        }
    }
}
