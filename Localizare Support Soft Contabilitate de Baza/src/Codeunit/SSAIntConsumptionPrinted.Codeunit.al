codeunit 70006 "SSA Int. Consumption-Printed"
{
    // SSA937 SSCAT 16.06.2019 3.Funct. Bonuri de consum-consum intern

    Permissions = tabledata "SSA Pstd. Int. Cons. Header" = rm;
    TableNo = "SSA Pstd. Int. Cons. Header";

    trigger OnRun()
    begin
        Rec.Find();
        Rec."No. Printed" := Rec."No. Printed" + 1;
        OnBeforeModify(Rec);
        Rec.Modify();
        Commit();
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeModify(var SSAPstdIntConsHeader: Record "SSA Pstd. Int. Cons. Header")
    begin
    end;
}
