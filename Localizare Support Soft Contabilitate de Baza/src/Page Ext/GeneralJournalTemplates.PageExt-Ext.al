pageextension 70026 "SSA General Journal Templates" extends "General Journal Templates"
{
    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        "Copy VAT Setup to Jnl. Lines" := true; //SSA959 InitValue=No from Yes
    end;
}