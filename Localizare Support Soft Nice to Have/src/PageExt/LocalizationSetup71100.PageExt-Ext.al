
pageextension 71100 "SSA Localization Setup 71100" extends "SSA Localization Setup"
{

    layout
    {
        addlast(General)
        {
            group("SSA VAT API")
            {
                Caption = 'VAT API';

                field("SSA VAT API URL"; "SSA VAT API URL")
                {
                    ApplicationArea = All;
                }
                field("SSA VAT User Name"; "SSA VAT User Name")
                {
                    ApplicationArea = All;
                }
                field("SSA VAT Password"; "SSA VAT Password")
                {
                    ApplicationArea = All;
                }
                field("SSA VAT API URL ANAF"; "SSA VAT API URL ANAF")
                {
                    ApplicationArea = All;
                }
                field("SSA Enable ANAF VAT"; "SSA Enable ANAF VAT")
                {
                    ApplicationArea = All;
                }
            }

        }
    }
    actions
    {
        addlast(Processing)
        {
            action("SSA ImportBNR")
            {
                Caption = 'Import BNR';
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Report;
                ApplicationArea = All;
                trigger OnAction()
                var
                    ImportBNR: Codeunit "SSA Actualizare Cursuri BNR";
                begin
                    ImportBNR.Run();
                end;
            }
        }
    }
}