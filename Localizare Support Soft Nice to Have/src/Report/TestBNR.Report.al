report 71104 "SSA Test BNR"
{
    Caption = 'Test BNR';
    UsageCategory = Administration;
    ApplicationArea = All;
    ProcessingOnly = true;
    trigger OnPreReport()
    var
        ActualizareCursuriBNR: Codeunit "SSA Actualizare Cursuri BNR";
    begin
        ActualizareCursuriBNR.Run();
    end;


}