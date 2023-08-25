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
            CalcFormula = sum("SSA Pmt. Tools AppLedg. Entry".Amount where("Document Type" = const("Sales Invoice"), "Document No." = field("Document No.")));
        }
    }

}