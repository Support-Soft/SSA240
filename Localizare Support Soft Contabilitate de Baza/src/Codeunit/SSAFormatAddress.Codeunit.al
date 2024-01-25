codeunit 70022 "SSA Format Address"
{
    trigger OnRun()
    begin

    end;

    procedure InventoryShptSellTo(var AddrArray: array[8] of Text[100]; var InvtShptHeader: Record "Invt. Shipment Header")
    var
        FormatAddress: Codeunit "Format Address";
        IsHandled: Boolean;
    begin
        IsHandled := false;
        OnBeforeInvtShptSellTo(AddrArray, InvtShptHeader, IsHandled);
        if IsHandled then
            exit;

        FormatAddress.FormatAddr(
              AddrArray, InvtShptHeader."SSA Sell-to Customer Name", InvtShptHeader."SSA Sell-to Customer Name 2", InvtShptHeader."SSA Sell-to Contact", InvtShptHeader."SSA Sell-to Address", InvtShptHeader."SSA Sell-to Address 2",
              InvtShptHeader."SSA Sell-to City", InvtShptHeader."SSA Sell-to Post Code", InvtShptHeader."SSA Sell-to County", InvtShptHeader."SSA Sell-to Country/Reg Code");
    end;

    procedure InvtShptShipTo(var AddrArray: array[8] of Text[100]; var InvtShptHeader: Record "Invt. Shipment Header")
    var
        FormatAddress: Codeunit "Format Address";
        Handled: Boolean;
    begin
        OnBeforeInvtShptShipTo(AddrArray, InvtShptHeader, Handled);
        if Handled then
            exit;

        FormatAddress.FormatAddr(
              AddrArray, InvtShptHeader."SSA Ship-to Name", InvtShptHeader."SSA Ship-to Name 2", InvtShptHeader."SSA Ship-to Contact", InvtShptHeader."SSA Ship-to Address", InvtShptHeader."SSA Ship-to Address 2",
              InvtShptHeader."SSA Ship-to City", InvtShptHeader."SSA Ship-to Post Code", InvtShptHeader."SSA Ship-to County", InvtShptHeader."SSA Ship-to Country/Reg Code");
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeInvtShptSellTo(var AddrArray: array[8] of Text[100]; var InvtShipmentHeader: Record "Invt. Shipment Header"; var Handled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeInvtShptShipTo(var AddrArray: array[8] of Text[100]; var InvtShipmentHeader: Record "Invt. Shipment Header"; var Handled: Boolean)
    begin
    end;
}