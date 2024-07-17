tableextension 71909 "Purchases & Payables Setup" extends "Purchases & Payables Setup"
{
    fields
    {
        field(71900; "SSAFT Excl. Vendor Posting Grp"; Text[250])
        {
            Caption = 'SAFT Excl. Vendor Posting Grp', Comment = 'Filtru Gr. Inreg. Furnizor Exclus din SAFT';
            DataClassification = CustomerContent;
        }
    }

}