tableextension 70022 "SSA VATProductPstgGroup70022" extends "VAT Product Posting Group"
{
    // SSA948 SSCAT 08.10.2019 14.Funct. Functionalitatea deductibilitate cheltuieli 50% /100%
    fields
    {
        field(70000; "SSA Non-Deductible VAT"; Boolean)
        {
            Caption = 'Non-Deductible VAT';
            DataClassification = CustomerContent;
            Description = 'SSA948';
        }
    }
}
