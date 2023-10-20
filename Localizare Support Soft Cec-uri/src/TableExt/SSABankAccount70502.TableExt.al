tableextension 70502 "SSA Bank Account70502" extends "Bank Account" //270
{
    fields
    {
        field(70500; "SSA Agency"; Text[50])
        {
            Caption = 'Agency';
            DataClassification = CustomerContent;
        }
        field(70501; "SSA RIB Key"; Integer)
        {
            Caption = 'RIB Key';
            DataClassification = CustomerContent;
        }
        field(70502; "SSA RIB Checked"; Boolean)
        {
            Caption = 'RIB Checked';
            DataClassification = CustomerContent;
        }
        field(70503; "SSA From Payment No."; Code[10])
        {
            Caption = 'From Payment No.';
            DataClassification = CustomerContent;
        }
    }
}