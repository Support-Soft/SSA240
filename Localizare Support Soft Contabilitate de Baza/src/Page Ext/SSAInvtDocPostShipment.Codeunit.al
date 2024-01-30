codeunit 70024 "SSA Invt. Doc.-Post Shipment"
{
    trigger OnRun()
    begin

    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Invt. Doc.-Post Shipment", 'OnRunOnBeforeInvtShptHeaderInsert', '', false, false)]
    local procedure OnRunOnBeforeInvtShptHeaderInsert(InvtDocHeader: Record "Invt. Document Header"; var InvtShptHeader: Record "Invt. Shipment Header")
    begin
        InvtShptHeader."SSA Sell-to Customer No." := InvtDocHeader."SSA Sell-to Customer No.";
        InvtShptHeader."SSA Sell-to Customer Name" := InvtDocHeader."SSA Sell-to Customer Name";
        InvtShptHeader."SSA Sell-to Customer Name 2" := InvtDocHeader."SSA Sell-to Customer Name 2";
        InvtShptHeader."SSA Sell-to Address" := InvtDocHeader."SSA Sell-to Address";
        InvtShptHeader."SSA Sell-to Address 2" := InvtDocHeader."SSA Sell-to Address 2";
        InvtShptHeader."SSA Sell-to City" := InvtDocHeader."SSA Sell-to City";
        InvtShptHeader."SSA Sell-to Contact" := InvtDocHeader."SSA Sell-to Contact";
        InvtShptHeader."SSA Sell-to Post Code" := InvtDocHeader."SSA Sell-to Post Code";
        InvtShptHeader."SSA Sell-to County" := InvtDocHeader."SSA Sell-to County";
        InvtShptHeader."SSA Sell-to Country/Reg Code" := InvtDocHeader."SSA Sell-to Country/Reg Code";
        InvtShptHeader."SSA Sell-to Phone No." := InvtDocHeader."SSA Sell-to Phone No.";
        InvtShptHeader."SSA Sell-to E-Mail" := InvtDocHeader."SSA Sell-to E-Mail";
        InvtShptHeader."SSA Sell-to Contact No." := InvtDocHeader."SSA Sell-to Contact No.";
        InvtShptHeader."SSA Ship-to Code" := InvtDocHeader."SSA Ship-to Code";
        InvtShptHeader."SSA Ship-to Name" := InvtDocHeader."SSA Ship-to Name";
        InvtShptHeader."SSA Ship-to Name 2" := InvtDocHeader."SSA Ship-to Name 2";
        InvtShptHeader."SSA Ship-to Address" := InvtDocHeader."SSA Ship-to Address";
        InvtShptHeader."SSA Ship-to Address 2" := InvtDocHeader."SSA Ship-to Address 2";
        InvtShptHeader."SSA Ship-to City" := InvtDocHeader."SSA Ship-to City";
        InvtShptHeader."SSA Ship-to Contact" := InvtDocHeader."SSA Ship-to Contact";
        InvtShptHeader."SSA Ship-to Post Code" := InvtDocHeader."SSA Ship-to Post Code";
        InvtShptHeader."SSA Ship-to County" := InvtDocHeader."SSA Ship-to County";
        InvtShptHeader."SSA Ship-to Country/Reg Code" := InvtDocHeader."SSA Ship-to Country/Reg Code";

    end;
}