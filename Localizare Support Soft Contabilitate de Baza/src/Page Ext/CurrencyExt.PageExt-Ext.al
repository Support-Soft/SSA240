pageextension 70000 "SSA Currency Ext" extends "Currency Card"
{
    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        "Invoice Rounding Precision" := 1;
        "Amount Rounding Precision" := 1;
        "Unit-Amount Rounding Precision" := 1;
    end;

}