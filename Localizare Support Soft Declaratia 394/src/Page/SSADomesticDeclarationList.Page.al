page 71702 "SSA Domestic Declaration List"
{
    // SSA973 SSCAT 06.09.2019 39.Rapoarte legale- Localizare Declaratia 394

    Caption = 'Domestic Declarations';
    CardPageId = "SSA Domestic Declaration Card";
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
                    ToolTip = 'Specifies the value of the Code field.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Description field.';
                }
                field(Reported; Rec.Reported)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Reported field.';
                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Type field.';
                }
                field(Period; Rec.Period)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Period field.';
                }
                field(Year; Rec.Year)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Year field.';
                }
                field("Starting Date"; Rec."Starting Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Starting Date field.';
                }
                field("Ending Date"; Rec."Ending Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Ending Date field.';
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
                ShortcutKey = 'Return';
                ToolTip = 'Executes the Edit Declaration action.';
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
