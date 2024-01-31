pageextension 71100 "SSA Localization Setup 71100" extends "SSA Localization Setup"
{
    layout
    {
        addlast(General)
        {
            group("SSA VAT API")
            {
                Caption = 'VAT API';

                field("SSA VAT API URL"; Rec."SSA VAT API URL")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the VAT API URL field.';
                }
                field("SSA VAT User Name"; Rec."SSA VAT User Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the VAT User Name field.';
                }
                field("SSA VAT Password"; Rec."SSA VAT Password")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the VAT Password field.';
                }
                field("SSA VAT API URL ANAF"; Rec."SSA VAT API URL ANAF")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the VAT API URL ANAF field.';
                }
                field("SSA Enable ANAF VAT"; Rec."SSA Enable ANAF VAT")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Enable ANAF VAT field.';
                }
                field("SSA Import BNR at LogIn"; Rec."SSA Import BNR at LogIn")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Import BNR at LogIn field.';
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
                ToolTip = 'Executes the Import BNR action.';
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