#pragma implicitwith disable
page 71901 "SSAFT Mapping"
{
    // SSM2101 SSCAT 04.01.2023 SAF-T

    Caption = 'SAFT Mapping';
    DelayedInsert = true;
    PageType = List;
    SaveValues = true;
    SourceTable = "SSAFT-NAV Mapping";
    ApplicationArea = All;
    UsageCategory = Tasks;
    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                Visible = not IsOnMobile;
                field(RangeCodeFilter; RangeCodeFilter)
                {
                    Caption = 'Range Code Filter';
                    ApplicationArea = All;
                    ToolTip = 'Filter the mapping range code.';

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        SAFTMappingRange: Page "SSAFT Mapping Range";
                    begin
                        SAFTMappingRange.LookupMode := true;
                        if SAFTMappingRange.RunModal = ACTION::LookupOK then
                            Text := SAFTMappingRange.GetSelectionFilter
                        else
                            exit(false);

                        exit(true);
                    end;

                    trigger OnValidate()
                    begin
                        RangeCodeFilterOnAfterValidate;
                    end;
                }
                field(NFTTypeFilter; NFTTypeFilter)
                {
                    ApplicationArea = All;
                    Caption = 'NFT Type Filter';
                    OptionCaption = 'TAX-IMP - Impozite,TAX-IMP - Bugete,Livrari,Achizitii ded 100%,Achizitii ded 50%_baserate,Achizitii ded 50%_not_known,Achizitii ded 50%,Achizitii neded,Achizitii baserate,Achizitii not known,WHT - nomenclator,WHT - D207,WHT - cote,IBAN-ISO13616-1997,ISO3166-1A2 - RO Dept Codes,ISO3166-2-CountryCodes,ISO4217CurrCodes,PlanConturiBalSocCom,PlanConturiIFRS,PlanConturiIFRS_Norma39,PlanConturiBanci,PlanConturiNebancare,PlanConturiSocAsigurari,Unitati_masura,NC8_2021_TARIC3,Nomenclator stocuri,Nomenclator imobilizari,Nomenclator_Regim_fiscal,SAFT_Nomenclator_StockChar,Nom_Tipuri_facturi,Nom_Mecanisme_plati,An fiscal-perioade de raportare,Nomenclator tari si valuta,IBAN Validation,None';
                    ToolTip = 'Filter the NFT Type.';
                    trigger OnValidate()
                    begin
                        NFTTypeFilterOnAfterValidate;
                    end;
                }
            }
            repeater(Control1)
            {
                ShowCaption = false;
                field("Mapping Range Code"; Rec."Mapping Range Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'The mapping range code.';
                }
                field("NFT Type"; Rec."NFT Type")
                {
                    Editable = false;
                    ApplicationArea = All;
                    ToolTip = 'The NFT Type.';
                }
                field("SAFT Code"; Rec."SAFT Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'The SAFT Code.';
                }
                field("Table ID"; Rec."Table ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'The Table ID.';
                }
                field("Field ID"; Rec."Field ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'The Field ID.';
                    trigger OnValidate()
                    begin
                        CurrPage.Update(true);
                    end;
                }
                field("Field Name"; Rec."Field Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'The Field Name.';
                }
                field("NAV Code"; Rec."NAV Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'The NAV Code.';
                    trigger OnValidate()
                    begin
                        CurrPage.Update(true);
                    end;
                }
                field("SAFT Description"; Rec."SAFT Description")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'The SAFT Description.';
                }
                field("NAV Description"; Rec."NAV Description")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'The NAV Description.';
                }
                field("G/L Entries Exists"; Rec."G/L Entries Exists")
                {
                    ApplicationArea = All;
                    ToolTip = 'The G/L Entries Exists.';
                }
                field("WHT Tax Percent"; Rec."WHT Tax Percent")
                {
                    ApplicationArea = All;
                    ToolTip = 'The WHT Tax Percent.';
                }
            }
        }
        area(factboxes)
        {
            systempart(Control1900383207; Links)
            {
                ApplicationArea = RecordLinks;
                Visible = false;
            }
            systempart(Control1905767507; Notes)
            {
                ApplicationArea = Notes;
                Visible = false;
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(ClearFilter)
            {
                ApplicationArea = All;
                Caption = 'Clear Filter';
                Image = ClearFilter;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Clear filter.';
                Visible = IsOnMobile;

                trigger OnAction()
                begin
                    Rec.Reset;
                    UpdateBasicRecFilters;
                end;
            }
            action(InitMappingSource)
            {
                ApplicationArea = All;
                Caption = 'Initialize Souce for Mapping';
                Image = GetSourceDoc;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Generate lines on the G/L Account Mapping page based on an existing chart of accounts.';

                trigger OnAction()
                var
                    SAFTMappingRange: Record "SSAFT Mapping Range";
                    SAFTMappingHelper: Codeunit "SSAFT Mapping Helper";
                begin
                    SAFTMappingRange.Get(RangeCodeFilter);
                    SAFTMappingHelper.Run(SAFTMappingRange);
                    CurrPage.Update;
                end;
            }
            action("Match Mapping")
            {
                ApplicationArea = All;
                Caption = 'Match Mapping';
                Image = GetSourceDoc;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Generate lines on the G/L Account Mapping page based on an existing chart of accounts.';

                trigger OnAction()
                var
                    SAFTMappingRange: Record "SSAFT Mapping Range";
                    SAFTMappingHelper: Codeunit "SSAFT Mapping Helper";
                begin
                    SAFTMappingRange.Get(RangeCodeFilter);
                    SAFTMappingHelper.MatchMapping(SAFTMappingRange);
                    CurrPage.Update;
                end;
            }
        }
    }
    trigger OnOpenPage()
    begin
        IsOnMobile := ClientTypeManagement.GetCurrentClientType = CLIENTTYPE::Phone;

        GetRecFilters;
        SetRecFilters;
    end;

    var
        ClientTypeManagement: Codeunit "Client Type Management";
        NFTTypeFilter: Option "TAX-IMP - Impozite","TAX-IMP - Bugete",Livrari,"Achizitii ded 100%","Achizitii ded 50%_baserate","Achizitii ded 50%_not_known","Achizitii ded 50%","Achizitii neded","Achizitii baserate","Achizitii not known","WHT - nomenclator","WHT - D207","WHT - cote","IBAN-ISO13616-1997","ISO3166-1A2 - RO Dept Codes","ISO3166-2-CountryCodes",ISO4217CurrCodes,PlanConturiBalSocCom,PlanConturiIFRS,PlanConturiIFRS_Norma39,PlanConturiBanci,PlanConturiNebancare,PlanConturiSocAsigurari,Unitati_masura,NC8_2021_TARIC3,"Nomenclator stocuri","Nomenclator imobilizari",Nomenclator_Regim_fiscal,SAFT_Nomenclator_StockChar,Nom_Tipuri_facturi,Nom_Mecanisme_plati,"An fiscal-perioade de raportare","Nomenclator tari si valuta","IBAN Validation","None";
        RangeCodeFilter: Text;
        IsOnMobile: Boolean;

    local procedure GetRecFilters()
    begin
        if Rec.GetFilters <> '' then
            UpdateBasicRecFilters;
    end;

    local procedure UpdateBasicRecFilters()
    begin
        if Rec.GetFilter("NFT Type") <> '' then
            NFTTypeFilter := GetNFTTypeFilter
        else
            NFTTypeFilter := NFTTypeFilter::None;

        RangeCodeFilter := Rec.GetFilter("Mapping Range Code");
    end;

    procedure SetRecFilters()
    begin
        if NFTTypeFilter <> NFTTypeFilter::None then
            Rec.SetRange("NFT Type", NFTTypeFilter)
        else
            Rec.SetRange("NFT Type");

        if RangeCodeFilter <> '' then
            Rec.SetFilter("Mapping Range Code", RangeCodeFilter)
        else
            Rec.SetRange("Mapping Range Code");

        CurrPage.Update(false);
    end;

    local procedure NFTTypeFilterOnAfterValidate()
    begin
        CurrPage.SaveRecord;
        SetRecFilters;
    end;

    local procedure GetNFTTypeFilter(): Integer
    begin
        case Rec.GetFilter("NFT Type") of
            Format(Rec."NFT Type"::"TAX-IMP - Impozite"):
                exit(0);
            Format(Rec."NFT Type"::"TAX-IMP - Bugete"):
                exit(1);
            Format(Rec."NFT Type"::Livrari):
                exit(2);
            Format(Rec."NFT Type"::"Achizitii ded 100%"):
                exit(3);
            Format(Rec."NFT Type"::"Achizitii ded 50%_baserate"):
                exit(4);
            Format(Rec."NFT Type"::"Achizitii ded 50%_not_known"):
                exit(5);
            Format(Rec."NFT Type"::"Achizitii ded 50%"):
                exit(6);
            Format(Rec."NFT Type"::"Achizitii neded"):
                exit(7);
            Format(Rec."NFT Type"::"Achizitii baserate"):
                exit(8);
            Format(Rec."NFT Type"::"Achizitii not known"):
                exit(9);
            Format(Rec."NFT Type"::"WHT - nomenclator"):
                exit(10);
            Format(Rec."NFT Type"::"WHT - D207"):
                exit(11);
            Format(Rec."NFT Type"::"WHT - cote"):
                exit(12);
            Format(Rec."NFT Type"::"IBAN-ISO13616-1997"):
                exit(12);
            Format(Rec."NFT Type"::"ISO3166-1A2 - RO Dept Codes"):
                exit(13);
            Format(Rec."NFT Type"::"ISO3166-2-CountryCodes"):
                exit(14);
            Format(Rec."NFT Type"::ISO4217CurrCodes):
                exit(15);
            Format(Rec."NFT Type"::PlanConturiBalSocCom):
                exit(16);
            Format(Rec."NFT Type"::PlanConturiIFRS):
                exit(17);
            Format(Rec."NFT Type"::PlanConturiIFRS_Norma39):
                exit(18);
            Format(Rec."NFT Type"::PlanConturiBanci):
                exit(19);
            Format(Rec."NFT Type"::PlanConturiNebancare):
                exit(20);
            Format(Rec."NFT Type"::PlanConturiSocAsigurari):
                exit(21);
            Format(Rec."NFT Type"::Unitati_masura):
                exit(22);
            Format(Rec."NFT Type"::NC8_2021_TARIC3):
                exit(23);
            Format(Rec."NFT Type"::"Nomenclator stocuri"):
                exit(24);
            Format(Rec."NFT Type"::"Nomenclator imobilizari"):
                exit(25);
            Format(Rec."NFT Type"::Nomenclator_Regim_fiscal):
                exit(26);
            Format(Rec."NFT Type"::SAFT_Nomenclator_StockChar):
                exit(27);
            Format(Rec."NFT Type"::Nom_Tipuri_facturi):
                exit(28);
            Format(Rec."NFT Type"::Nom_Mecanisme_plati):
                exit(29);
            Format(Rec."NFT Type"::"An fiscal-perioade de raportare"):
                exit(30);
            Format(Rec."NFT Type"::"Nomenclator tari si valuta"):
                exit(31);
            Format(Rec."NFT Type"::"IBAN Validation"):
                exit(32);
        end;
    end;

    local procedure RangeCodeFilterOnAfterValidate()
    begin
        CurrPage.SaveRecord;
        SetRecFilters;
    end;
}

#pragma implicitwith restore

