pageextension 70038 "SSA Work Center" extends "Work Center Card"
{
    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        "Calendar Rounding Precision" := 1;
    end;
}