codeunit 70006 "SSA Int. Consumption-Printed"
{
    // SSA937 SSCAT 16.06.2019 3.Funct. Bonuri de consum-consum intern

    Permissions = TableData "SSA Pstd. Int. Cons. Header" = rm;
    TableNo = "SSA Pstd. Int. Cons. Header";

    trigger OnRun()
    begin
        rec.Find;
        "No. Printed" := "No. Printed" + 1;
        OnBeforeModify(Rec);
        Modify;
        Commit;
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeModify(var SSAPstdIntConsHeader: Record "SSA Pstd. Int. Cons. Header")
    begin
    end;
}

