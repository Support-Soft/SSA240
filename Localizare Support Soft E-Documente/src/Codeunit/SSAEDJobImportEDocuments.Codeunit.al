codeunit 72010 "SSAEDJob Import E-Documents"
{
    TableNo = "Job Queue Entry";
    trigger OnRun()
    begin
        HandleRequest;
    end;

    local procedure HandleRequest()
    var
        EFacturaLogEntry: Record "SSAEDE-Documents Log Entry";
        MoreRequests: Boolean;
    begin
        MoreRequests := GetNextRequest(EFacturaLogEntry);  // locks table
        while MoreRequests do begin
            Commit;
            ClearLastError;
            if CODEUNIT.Run(CODEUNIT::"SSAEDProcess Import E-Doc", EFacturaLogEntry) then begin
                EFacturaLogEntry.Status := EFacturaLogEntry.Status::Completed;
                EFacturaLogEntry."Error Message" := '';
            end else begin
                EFacturaLogEntry.Status := EFacturaLogEntry.Status::Error;
                EFacturaLogEntry."Error Message" := CopyStr(GetLastErrorText, 1, MaxStrLen(EFacturaLogEntry."Error Message"));
            end;
            EFacturaLogEntry."Processing DateTime" := CurrentDateTime;
            EFacturaLogEntry.Modify;
            Commit;
            MoreRequests := GetNextRequest(EFacturaLogEntry)  // locks table
        end;
    end;

    local procedure GetNextRequest(var _EFacturaLogEntry: Record "SSAEDE-Documents Log Entry") Found: Boolean
    begin
        _EFacturaLogEntry.LockTable;
        _EFacturaLogEntry.SetCurrentKey("Entry Type", Status, "Stare Mesaj");
        _EFacturaLogEntry.SetRange("Entry Type", _EFacturaLogEntry."Entry Type"::"Import E-Factura");
        _EFacturaLogEntry.SetRange(Status, _EFacturaLogEntry.Status::New);
        Found := _EFacturaLogEntry.FindFirst;
        if Found then begin
            _EFacturaLogEntry.Status := _EFacturaLogEntry.Status::"In Progress";
            _EFacturaLogEntry.Modify;
        end;
    end;
}

