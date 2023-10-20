codeunit 70013 "SSA Install Localizare SS"
{
    Subtype = Install;

    trigger OnInstallAppPerCompany()
    var
        EnableApplicationArea: Codeunit "SSA Enable Localizare SS";
    begin
        if (EnableApplicationArea.IsSSALocalizareApplicationAreaEnabled()) then
            exit;

        EnableApplicationArea.EnableSSALocalizareExtension();
    end;
}