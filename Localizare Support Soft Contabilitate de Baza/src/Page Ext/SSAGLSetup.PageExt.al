pageextension 70037 "SSA GL Setup" extends "General Ledger Setup"
{
    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec."Amount Rounding Precision" := 1;
        Rec."Unit-Amount Rounding Precision" := 1;
    end;
}