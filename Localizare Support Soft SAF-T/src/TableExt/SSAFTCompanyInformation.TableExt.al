tableextension 71901 "SSAFTCompany Information" extends "Company Information"
{
    fields
    {
        field(71900; "SSAFT Contact No."; Code[20])
        {
            Caption = 'SAFT Contact No.';
            DataClassification = CustomerContent;
            TableRelation = Employee;
        }
    }

}