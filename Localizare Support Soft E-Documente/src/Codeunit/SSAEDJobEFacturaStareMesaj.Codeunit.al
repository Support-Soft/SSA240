codeunit 72006 "SSAEDJob EFactura StareMesaj"
{
    TableNo = "Job Queue Entry";
    trigger OnRun()
    begin
        Code();
    end;

    local procedure Code()
    var
        EFacturaSetup: Record "SSAEDEDocuments Setup";
        EFacturaLogEntry: Record "SSAEDE-Documents Log Entry";
        EFacturaLogEntry2: Record "SSAEDE-Documents Log Entry";
        ANAFAPIMgt: Codeunit "SSAEDANAF API Mgt";
        i: Integer;
        EndLoop: Boolean;

    begin

        EFacturaSetup.get;
        clear(EndLoop);
        Clear(i);

        EFacturaLogEntry.reset;
        EFacturaLogEntry.SetCurrentKey("Entry Type", Status, "Stare Mesaj");
        EFacturaLogEntry.SetRange("Entry Type", EFacturaLogEntry."Entry Type"::"Export E-Factura");
        EFacturaLogEntry.SetRange(Status, EFacturaLogEntry.Status::Completed);
        EFacturaLogEntry.SetFilter("Index Incarcare", '<>%1', '');
        EFacturaLogEntry.SetFilter("Stare Mesaj", StrSubstNo('<>@%1&<>%2', 'ok', 'nok'));
        if EFacturaLogEntry.FindSet() then
            repeat
                EFacturaLogEntry2.Get(EFacturaLogEntry."Entry No.");
                ANAFAPIMgt.GetStareMesaj(EFacturaLogEntry2);
                EFacturaLogEntry2.Modify();
                i += 1;
                if i >= EFacturaSetup."No. of StareMesaj Requests" then
                    EndLoop := true;
            until (EFacturaLogEntry.next = 0) or EndLoop;

    end;
}