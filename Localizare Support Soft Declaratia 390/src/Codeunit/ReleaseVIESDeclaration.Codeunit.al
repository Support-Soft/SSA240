codeunit 71500 "SSA Release VIES Declaration"
{
    // SSA974 SSCAT 11.10.2019 40.Rapoarte legale-Declaratia 390

    TableNo = "SSA VIES Header";

    trigger OnRun()
    var
        VIESLine: Record "SSA VIES Line";
    begin
        if Rec.Status = Rec.Status::Released then
            exit;

        SSASetup.Get;

        Rec.TestField("VAT Registration No.");
        Rec.TestField("Document Date");
        if Rec."Declaration Type" <> Rec."Declaration Type"::Normal then
            Rec.TestField("Corrected Declaration No.");

        VIESLine.SetRange("VIES Declaration No.", Rec."No.");
        if VIESLine.IsEmpty then
            Error(Text001, Rec."No.");
        VIESLine.FindSet;
        repeat
            VIESLine.TestField("Country/Region Code");
            VIESLine.TestField("VAT Registration No.");
            VIESLine.TestField("Amount (LCY)");
        until VIESLine.Next = 0;

        Rec.Status := Rec.Status::Released;

        Rec.Modify(true);
    end;

    var
        Text001: Label 'There is nothing to release for declaration No. %1.';
        SSASetup: Record "SSA Localization Setup";

    procedure Reopen(var VIESHeader: Record "SSA VIES Header")
    begin
        if VIESHeader.Status = VIESHeader.Status::Open then
            exit;
        VIESHeader.Status := VIESHeader.Status::Open;
        VIESHeader.Modify(true);
    end;
}

