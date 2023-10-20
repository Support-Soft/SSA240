codeunit 70014 "SSA CU80 Sales-Post"
{
    [EventSubscriber(ObjectType::Codeunit, 80, 'OnBeforePostSalesDoc', '', false, false)]
    local procedure OnBeforePostSalesDoc(var Sender: Codeunit "Sales-Post"; var SalesHeader: Record "Sales Header"; CommitIsSuppressed: Boolean; PreviewMode: Boolean)
    var
        SSASetup: Record "SSA Localization Setup";
        IntrastatTransaction: Boolean;
    begin
        //SSA954>>
        SSASetup.Get();
        IntrastatTransaction := IsIntrastatTransaction(SalesHeader);
        if IntrastatTransaction then begin
            if SSASetup."Transaction Type Mandatory" then
                SalesHeader.TestField("Transaction Type");
            if SSASetup."Transaction Spec. Mandatory" then
                SalesHeader.TestField("Transaction Specification");
            if SSASetup."Transport Method Mandatory" then
                SalesHeader.TestField("Transport Method");
            if SSASetup."Shipment Method Mandatory" then
                SalesHeader.TestField("Shipment Method Code");
        end;
        //SSA954<<

        //SSA958>>
        if not SSASetup."Allow Diff. Sell-to Bill-to" then
            SalesHeader.TestField("Sell-to Customer No.", SalesHeader."Bill-to Customer No.");
        //SSA958<<
    end;

    local procedure IsIntrastatTransaction(_SalesHeader: Record "Sales Header"): Boolean
    var
        SSAIntrastat: Codeunit "SSA Intrastat";
    begin
        //SSA954>>
        exit(SSAIntrastat.IsCountryRegionIntrastat(_SalesHeader."VAT Country/Region Code", false));
        //SSA954<<
    end;
}
