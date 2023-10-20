tableextension 70500 "SSA Customer Bank Account70500" extends "Customer Bank Account" //287
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