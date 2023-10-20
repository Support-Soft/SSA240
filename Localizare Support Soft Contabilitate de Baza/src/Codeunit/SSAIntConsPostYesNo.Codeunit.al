codeunit 70004 "SSA Int. Cons-Post (Yes/No)"
{
    // SSA937 SSCAT 16.06.2019 3.Funct. Bonuri de consum-consum intern

    TableNo = "SSAInternal Consumption Header";

    trigger OnRun()
    begin

        IntConsumptionHeader.Copy(Rec);
        Code();
        Rec := IntConsumptionHeader;
    end;

    var
        IntConsumptionHeader: Record "SSAInternal Consumption Header";
        IntConsumptionPost: Codeunit "SSA Internal Consumption Post";
        Text000: Label 'Do you want to post the %1?';

    local procedure "Code"()
    begin
        if not Confirm(Text000, false, IntConsumptionHeader."No.") then
            exit;
        IntConsumptionPost.Run(IntConsumptionHeader);
        Commit();
    end;
}
