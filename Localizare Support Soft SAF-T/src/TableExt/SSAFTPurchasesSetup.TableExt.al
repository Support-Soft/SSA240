tableextension 71904 "SSAFTPurchases Setup" extends "Purchases & Payables Setup"
{
    fields
    {
        field(71900; "SSAFTExcl. Vendor Posting Grp"; Text[250])
        {
            Caption = 'SAFT Excl. Vendor Posting Grp';
            DataClassification = CustomerContent;
            TableRelation = "Vendor Posting Group";
            ValidateTableRelation = false;
        }

    }

}