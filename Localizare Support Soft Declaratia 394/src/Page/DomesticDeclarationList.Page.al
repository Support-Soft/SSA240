page 71702 "SSA Domestic Declaration List"
{
    // SSA973 SSCAT 06.09.2019 39.Rapoarte legale- Localizare Declaratia 394

    Caption = 'Domestic Declarations';
    CardPageID = "SSA Domestic Declaration Card";
    DataCaptionExpression = DataCaption;
    DelayedInsert = true;
    PageType = List;
    SourceTable = "SSA Domestic Declaration";
    UsageCategory = Tasks;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Control1390000)
            {
                ShowCaption = false;
                field("Code"; Code)
                {
                    ApplicationArea = All;
                }
                field(Description; Description)
                {
                    ApplicationArea = All;
                }
                field(Reported; Reported)
                {
                    ApplicationArea = All;
                }
                field(Type; Type)
                {
                    ApplicationArea = All;
                }
                field(Period; Period)
                {
                    ApplicationArea = All;
                }
                field(Year; Year)
                {
                    ApplicationArea = All;
                }
                field("Starting Date"; "Starting Date")
                {
                    ApplicationArea = All;
                }
                field("Ending Date"; "Ending Date")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Edit Declaration")
            {
                ApplicationArea = All;
                Caption = 'Edit Declaration';
                Image = SetupList;
                Promoted = true;
                PromotedCategory = Process;
                ShortCutKey = 'Return';

                trigger OnAction()
                var
                    DomesticDeclarationLine: Record "SSA Domestic Declaration Line";
                    DomesticDeclPage: Page "SSA Domestic Declaration";
                begin
                    clear(DomesticDeclPage);
                    DomesticDeclarationLine.reset;
                    DomesticDeclarationLine.setrange("Domestic Declaration Code", Code);
                    DomesticDeclarationLine."Domestic Declaration Code" := Code;
                    DomesticDeclarationLine.SetRecFilter();
                    DomesticDeclPage.SetTableView(DomesticDeclarationLine);
                    DomesticDeclPage.SetCurrentDeclarationCode(Code);
                    DomesticDeclPage.Run();
                end;
            }
        }
    }

    local procedure DataCaption(): Text[250]
    var
        DomesticDecl: Record "SSA Domestic Declaration";
    begin
        if not CurrPage.LookupMode then
            if GetFilter(Code) <> '' then
                if GetRangeMin(Code) = GetRangeMax(Code) then
                    if DomesticDecl.Get(GetRangeMin(Code)) then
                        exit(DomesticDecl.Code + ' ' + DomesticDecl.Description);
    end;
}

