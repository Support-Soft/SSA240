codeunit 72005 "SSAEDJob EFactura Email"
{
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
        BodyLabel: Label 'Documentul %1 cu Nr. %2 are un status %3 cu eroarea %4';
        SubjectLabel: Label 'EFactura %1';
        BodyText: Text;
    begin
        EFacturaSetup.get;
        EFacturaSetup.TestField("EFactura Email Address for JOB");

        /*
        TempEmailItem.init;
        TempEmailItem."Send to" := EFacturaSetup."EFactura Email Address for JOB";
        TempEmailItem.Subject := StrSubstNo('EFactura %1', Today);
        TempEmailItem."Message Type" := TempEmailItem."Message Type"::"Custom Message";
        TempEmailItem."Plaintext Formatted" := false;
        CLEAR(TempEmailItem.Body);
        */
        Clear(BodyText);
        EFacturaLogEntry.reset;
        EFacturaLogEntry.SetCurrentKey("Export Type", Status);
        EFacturaLogEntry.SetRange("Export Type", EFacturaLogEntry."Export Type"::"E-Factura");
        EFacturaLogEntry.SetFilter(Status, '<>%1', EFacturaLogEntry.Status::Completed);
        if EFacturaLogEntry.FindSet() then
            repeat
                BodyText += '<BR>';
                BodyText += StrSubstNo(BodyLabel,
                    EFacturaLogEntry."Document Type", EFacturaLogEntry."Document No.", EFacturaLogEntry.Status, EFacturaLogEntry."Error Message");
            until EFacturaLogEntry.next = 0
        else
            BodyText += 'Nu exista documente neprocesate in Coada.';

        /*
        TempEmailItem.Body.CREATEOUTSTREAM(DataStream, TEXTENCODING::UTF8);
        BodyText.WRITE(DataStream);
        TempEmailItem.Send(true);
        */
        EmailMessage.Create(EFacturaSetup."EFactura Email Address for JOB", StrSubstNo(SubjectLabel, Today), BodyText);
        Email.Send(EmailMessage);

    end;
}