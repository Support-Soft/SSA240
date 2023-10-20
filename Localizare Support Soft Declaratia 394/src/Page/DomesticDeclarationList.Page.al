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
                field("Code"; Rec.Code)
                {
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
                field(Reported; Rec.Reported)
                {
                    ApplicationArea = All;
                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = All;
                }
                field(Period; Rec.Period)
                {
                    ApplicationArea = All;
                }
                field(Year; Rec.Year)
                {
                    ApplicationArea = All;
                }
                field("Starting Date"; Rec."Starting Date")
                {
                    ApplicationArea = All;
                }
                field("Ending Date"; Rec."Ending Date")
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
                    DomesticDeclarationLine.setrange("Domestic Declaration Code", Rec.Code);
                    DomesticDeclarationLine."Domestic Declaration Code" := Rec.Code;
                    DomesticDeclarationLine.SetRecFilter();
                    DomesticDeclPage.SetTableView(DomesticDeclarationLine);
                    DomesticDeclPage.SetCurrentDeclarationCode(Rec.Code);
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
            if Rec.GetFilter(Code) <> '' then
                if Rec.GetRangeMin(Code) = Rec.GetRangeMax(Code) then
                    if DomesticDecl.Get(Rec.GetRangeMin(Code)) then
                        exit(DomesticDecl.Code + ' ' + DomesticDecl.Description);
    end;
}

