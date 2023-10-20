pageextension 70000 "SSA Currency Ext" extends "Currency Card"
{
    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec."Invoice Rounding Precision" := 1;
        Rec."Amount Rounding Precision" := 1;
        Rec."Unit-Amount Rounding Precision" := 1;
    end;
}