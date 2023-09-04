tableextension 72012 "SSAEDVAT Posting Setup" extends "VAT Posting Setup"
{
    fields
    {
        field(72000; "SSAEDET codTipOperatiune"; Text[30])
        {
            Caption = 'ETransport codTipOperatiune';
            DataClassification = CustomerContent;
            Description = 'SSM2002';
        }
    }
}

