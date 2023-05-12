tableextension 70503 "SSA Cust. Ledger Entry 70503" extends "Cust. Ledger Entry" //21
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
            CalcFormula = Sum ("SSA Pmt. Tools AppLedg. Entry".Amount WHERE ("Document Type" = CONST ("Sales Invoice"), "Document No." = FIELD ("Document No.")));
        }
    }

}