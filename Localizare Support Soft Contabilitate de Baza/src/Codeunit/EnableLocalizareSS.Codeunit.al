codeunit 70018 "SSA Enable Localizare SS"
{
    // Extend and modify Essential experience tier with "SSALocalizare App Area"
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Application Area Mgmt.", 'OnGetBasicExperienceAppAreas', '', false, false)]
    local procedure RegisterSSALocalizareExtensionOnGetBasicExperienceAppAreas(var TempApplicationAreaSetup: Record "Application Area Setup" temporary)
    begin
        TempApplicationAreaSetup."SSA Localizare" := true;
        // Modify other application areas here
    end;

    // Validate that application areas needed for the extension are enabled
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Application Area Mgmt.", 'OnValidateApplicationAreas', '', false, false)]
    local procedure VerifyApplicationAreasOnValidateApplicationAreas(ExperienceTierSetup: Record "Experience Tier Setup"; TempApplicationAreaSetup: Record "Application Area Setup" temporary)
    begin
        if not TempApplicationAreaSetup."SSA Localizare" then
            Error('SSALocalizare App Area should be part of Essential in order for the SSALocalizare Extension to work.');
    end;

    // Helpers ................................................................
    procedure IsSSALocalizareApplicationAreaEnabled(): Boolean
    var
        ApplicationAreaSetup: Record "Application Area Setup";
        ApplicationAreaMgmtFacade: Codeunit "Application Area Mgmt. Facade";
    begin
        if ApplicationAreaMgmtFacade.GetApplicationAreaSetupRecFromCompany(ApplicationAreaSetup, CompanyName()) then
            exit(ApplicationAreaSetup."SSA Localizare");
    end;

    procedure EnableSSALocalizareExtension()
    var
        ApplicationAreaMgmtFacade: Codeunit "Application Area Mgmt. Facade";
    begin
        ApplicationAreaMgmtFacade.RefreshExperienceTierCurrentCompany();
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Application Area Mgmt. Facade", 'OnGetEssentialExperienceAppAreas', '', false, false)]
    local procedure EnableAdvancedApplicationAreaOnGetEssentialExperienceAppAreas(var TempApplicationAreaSetup: Record 9178 temporary)
    begin
        TempApplicationAreaSetup.Advanced := true
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Application Area Mgmt. Facade", 'OnGetPremiumExperienceAppAreas', '', false, false)]
    local procedure EnableAdvancedApplicationAreaOnGetPremiumExperienceAppAreas(var TempApplicationAreaSetup: Record 9178 temporary)
    begin
        TempApplicationAreaSetup.Advanced := true
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Application Area Mgmt. Facade", 'OnSetExperienceTier', '', false, false)]
    local procedure EnableAdvancedApplicationAreaOnSetExperienceTier(ExperienceTierSetup: Record 9176; var TempApplicationAreaSetup: Record 9178 temporary; var ApplicationAreasSet: Boolean)
    begin
        TempApplicationAreaSetup.Advanced := true
    end;
}