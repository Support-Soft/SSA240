tableextension 70507 "SSA Vendor Ledger Entry 70507" extends "Vendor Ledger Entry" //25
{
    fields
    {
        field(70500; "SSA Payment Tools Amount"; Decimal)
        {
            Caption = 'Payment Tools Amount';
        }
        field(70501; "SSA Applied Amount CEC/BO"; Decimal)
        {
            Caption = 'Applied Amount CEC/BO';
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = Sum ("SSA Pmt. Tools AppLedg. Entry".Amount WHERE ("Document Type" = CONST ("Purchase Invoice"), "Document No." = FIELD ("Document No.")));
        }
    }

}