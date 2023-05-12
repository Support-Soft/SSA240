pageextension 70037 "SSA GL Setup" extends "General Ledger Setup"
{
    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        "Amount Rounding Precision" := 1;
        "Unit-Amount Rounding Precision" := 1;
    end;
}