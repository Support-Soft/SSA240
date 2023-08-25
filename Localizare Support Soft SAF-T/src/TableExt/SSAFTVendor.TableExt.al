tableextension 71903 "SSAFTVendor" extends Vendor
{
    fields
    {
        field(71900; "SSAFTDebit Amount (LCY) VPG"; Decimal)
        {
            Caption = 'Debit Amount (LCY) VPG';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = sum("Detailed Vendor Ledg. Entry"."Debit Amount (LCY)" where("Vendor No." = field("No."), "Entry Type" = filter('<>Application'), "Initial Entry Global Dim. 1" = field("Global Dimension 1 Filter"), "Initial Entry Global Dim. 2" = field("Global Dimension 2 Filter"), "Posting Date" = field("Date Filter"), "Currency Code" = field("Currency Filter"), "SSA Vendor Posting Group" = field("SSA Vendor Pstg. Grp. Filter")));
        }
        field(71910; "SSAFTCredit Amount (LCY) VPG"; Decimal)
        {
            Caption = 'Credit Amount (LCY) VPG';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = sum("Detailed Vendor Ledg. Entry"."Credit Amount (LCY)" where("Vendor No." = field("No."), "Entry Type" = filter('<>Application'), "Initial Entry Global Dim. 1" = field("Global Dimension 1 Filter"), "Initial Entry Global Dim. 2" = field("Global Dimension 2 Filter"), "Posting Date" = field("Date Filter"), "Currency Code" = field("Currency Filter"), "SSA Vendor Posting Group" = field("SSA Vendor Pstg. Grp. Filter")));
        }
    }
}