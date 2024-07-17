tableextension 71907 "SSAFTSales & Receivables Setup" extends "Sales & Receivables Setup"
{
    fields
    {
        field(71900; "SSAFT Autofact Cust. No."; Code[20])
        {
            Caption = 'SAFT Autofactura Customer No.';
            DataClassification = CustomerContent;
            TableRelation = "Customer"."No.";
        }

    }
}