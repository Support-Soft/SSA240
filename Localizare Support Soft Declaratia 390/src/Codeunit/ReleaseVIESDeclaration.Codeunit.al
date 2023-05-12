codeunit 71500 "SSA Release VIES Declaration"
{
    // SSA974 SSCAT 11.10.2019 40.Rapoarte legale-Declaratia 390

    TableNo = "SSA VIES Header";

    trigger OnRun()
    var
        VIESLine: Record "SSA VIES Line";
    begin
        if Status = Status::Released then
            exit;

        SSASetup.Get;

        TestField("VAT Registration No.");
        TestField("Document Date");
        if "Declaration Type" <> "Declaration Type"::Normal then
            TestField("Corrected Declaration No.");

        VIESLine.SetRange("VIES Declaration No.", "No.");
        if VIESLine.IsEmpty then
            Error(Text001, "No.");
        VIESLine.FindSet;
        repeat
            VIESLine.TestField("Country/Region Code");
            VIESLine.TestField("VAT Registration No.");
            VIESLine.TestField("Amount (LCY)");
        until VIESLine.Next = 0;

        Status := Status::Released;

        Modify(true);
    end;

    var
        Text001: Label 'There is nothing to release for declaration No. %1.';
        SSASetup: Record "SSA Localization Setup";

    procedure Reopen(var VIESHeader: Record "SSA VIES Header")
    begin
        with VIESHeader do begin
            if Status = Status::Open then
                exit;
            Status := Status::Open;
            Modify(true);
        end;
    end;
}

