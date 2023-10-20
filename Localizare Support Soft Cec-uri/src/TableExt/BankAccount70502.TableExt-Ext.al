tableextension 70502 "SSA Bank Account70502" extends "Bank Account" //270
{
    fields
    {
        field(70500; "SSA Agency"; Text[50])
        {
            Caption = 'Agency';
        }
        field(70501; "SSA RIB Key"; Integer)
        {
            Caption = 'RIB Key';
        }
        field(70502; "SSA RIB Checked"; Boolean)
        {
            Caption = 'RIB Checked';
        }
        field(70503; "SSA From Payment No."; Code[10])
        {
            Caption = 'From Payment No.';
        }
    }
}