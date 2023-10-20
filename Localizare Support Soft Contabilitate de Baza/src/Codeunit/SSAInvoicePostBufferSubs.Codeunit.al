codeunit 70031 "SSA Invoice Post. Buffer Subs"
{
    [EventSubscriber(ObjectType::Table, Database::"Invoice Post. Buffer", 'OnAfterInvPostBufferPrepareSales', '', true, false)]
    local procedure OnAfterInvPostBufferPrepareSales(var SalesLine: Record "Sales Line"; var InvoicePostBuffer: Record "Invoice Post. Buffer")
    begin
        InvoicePostBuffer."Tax Area Code" := SalesLine."Tax Area Code";
        InvoicePostBuffer."Tax Group Code" := SalesLine."Tax Group Code";
    end;

    [EventSubscriber(ObjectType::Table, Database::"Invoice Post. Buffer", 'OnAfterInvPostBufferPreparePurchase', '', true, false)]
    local procedure OnAfterInvPostBufferPreparePurchase(var PurchaseLine: Record "Purchase Line"; var InvoicePostBuffer: Record "Invoice Post. Buffer")
    begin
        InvoicePostBuffer."Tax Area Code" := PurchaseLine."Tax Area Code";
        InvoicePostBuffer."Tax Group Code" := PurchaseLine."Tax Group Code";
    end;
}