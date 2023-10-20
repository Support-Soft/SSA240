pageextension 70026 "SSA General Journal Templates" extends "General Journal Templates"
{
    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec."Copy VAT Setup to Jnl. Lines" := true; //SSA959 InitValue=No from Yes
    end;
}