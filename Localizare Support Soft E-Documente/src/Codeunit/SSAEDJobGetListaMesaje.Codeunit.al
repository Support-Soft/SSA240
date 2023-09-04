codeunit 72009 "SSAEDJob GetListaMesaje"
{
    trigger OnRun()
    begin
        Code;
    end;

    local procedure Code();
    var
        ANAFApiMgt: Codeunit "SSAEDANAF API Mgt";
    begin
        ANAFApiMgt.GetListaMesaje();
        Commit();
    end;
}