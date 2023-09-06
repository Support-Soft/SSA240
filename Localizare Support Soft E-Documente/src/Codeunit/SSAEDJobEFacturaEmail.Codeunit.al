codeunit 72005 "SSAEDJob EFactura Email"
{
    TableNo = "Job Queue Entry";
    trigger OnRun()
    begin
        Code();
    end;

    local procedure Code()
    var
        EmailMessage: Codeunit "Email Message";
        Email: Codeunit "Email";
        EFacturaSetup: Record "SSAEDEDocuments Setup";
        EFacturaLogEntry: Record "SSAEDE-Documents Log Entry";
        BodyLabel: Label 'Documentul %1 cu Nr. %2 are un status %3 cu eroarea %4, stare mesaj: %5';
        SubjectLabel: Label 'EFactura %1';
        BodyText: Text;
    begin
        EFacturaSetup.get;
        EFacturaSetup.TestField("EFactura Email Address for JOB");

        Clear(BodyText);
        EFacturaLogEntry.reset;
        EFacturaLogEntry.SetCurrentKey("Entry Type", Status, "Stare Mesaj");
        EFacturaLogEntry.SetRange("Entry Type", EFacturaLogEntry."Entry Type"::"Export E-Factura");
        EFacturaLogEntry.SetFilter(Status, '<>%1', EFacturaLogEntry.Status::Completed);
        if EFacturaLogEntry.FindSet() then
            repeat
                BodyText += '<BR>';
                BodyText += StrSubstNo(BodyLabel,
                    EFacturaLogEntry."Document Type", EFacturaLogEntry."Document No.", EFacturaLogEntry.Status, EFacturaLogEntry."Error Message", EFacturaLogEntry."Stare Mesaj");
            until EFacturaLogEntry.next = 0;

        EFacturaLogEntry.SetRange("Entry Type", EFacturaLogEntry."Entry Type"::"Export E-Factura");
        EFacturaLogEntry.SetRange(Status, EFacturaLogEntry.Status::Completed);
        EFacturaLogEntry.SetFilter("Stare Mesaj", StrSubstNo('@*%1*', 'nok'));
        if EFacturaLogEntry.FindSet() then
            repeat
                BodyText += '<BR>';
                BodyText += StrSubstNo(BodyLabel,
                    EFacturaLogEntry."Document Type", EFacturaLogEntry."Document No.", EFacturaLogEntry.Status, EFacturaLogEntry."Error Message", EFacturaLogEntry."Stare Mesaj");
            until EFacturaLogEntry.next = 0;

        if BodyText = '' then
            BodyText += 'Nu exista documente neprocesate in Coada.';

        EmailMessage.Create(EFacturaSetup."EFactura Email Address for JOB", StrSubstNo(SubjectLabel, Today), BodyText);
        Email.Send(EmailMessage);

    end;
}