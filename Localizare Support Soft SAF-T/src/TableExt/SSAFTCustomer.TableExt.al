tableextension 71902 "SSAFTCustomer" extends Customer
{
    fields
    {
        field(71900; "SSAFTDebit Amount (LCY) CPG"; Decimal)
        {
            Caption = 'Debit Amount (LCY) CPG';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = sum("Detailed Cust. Ledg. Entry"."Debit Amount (LCY)" where("Customer No." = field("No."), "Entry Type" = filter('<>Application'), "Initial Entry Global Dim. 1" = field("Global Dimension 1 Filter"), "Initial Entry Global Dim. 2" = field("Global Dimension 2 Filter"), "Posting Date" = field("Date Filter"), "Currency Code" = field("Currency Filter"), "SSA Customer Posting Group" = field("SSA Customer Pstg. Grp. Filter")));
        }
        field(71910; "SSAFTCredit Amount (LCY) CPG"; Decimal)
        {
            Caption = 'Credit Amount (LCY) CPG';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = sum("Detailed Cust. Ledg. Entry"."Credit Amount (LCY)" where("Customer No." = field("No."), "Entry Type" = filter('<>Application'), "Initial Entry Global Dim. 1" = field("Global Dimension 1 Filter"), "Initial Entry Global Dim. 2" = field("Global Dimension 2 Filter"), "Posting Date" = field("Date Filter"), "Currency Code" = field("Currency Filter"), "SSA Customer Posting Group" = field("SSA Customer Pstg. Grp. Filter")));
        }
    }
}