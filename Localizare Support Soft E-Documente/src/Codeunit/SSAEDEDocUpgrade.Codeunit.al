codeunit 72011 "SSAEDE-Doc Upgrade"
{
    Subtype = Upgrade;

    trigger OnUpgradePerCompany()
    begin
        InvoiceLineLineIDUpgrade();
    end;

    local procedure InvoiceLineLineIDUpgrade()
    var
        UpgradeTag: Codeunit "Upgrade Tag";
        DocumentsDetails: Record "SSAEDE-Documents Details";
    begin
        if UpgradeTag.HasUpgradeTag(InvoiceLineLineIDUpgradeLbl) then exit;

        DocumentsDetails.Reset();
        if DocumentsDetails.FindSet() then
            repeat
                DocumentsDetails."Line ID Decimal" := DocumentsDetails."Line ID";
                DocumentsDetails.Modify();
            until DocumentsDetails.Next() = 0;

        UpgradeTag.SetUpgradeTag(InvoiceLineLineIDUpgradeLbl);
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Upgrade Tag", 'OnGetPerCompanyUpgradeTags', '', false, false)]
    local procedure OnGetPerCompanyUpgradeTags(var PerCompanyUpgradeTags: List of [Code[250]])
    begin
        PerCompanyUpgradeTags.Add(InvoiceLineLineIDUpgradeLbl);
    end;


    var
        InvoiceLineLineIDUpgradeLbl: Label 'SSAED-InvoiceLineLineIDUpgrade-ID-20240116', Locked = true;
}