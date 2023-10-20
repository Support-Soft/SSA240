pageextension 70025 "SSA No. Series70025" extends "No. Series"
{
    // SSA973 SSCAT 06.09.2019 39.Rapoarte legale- Localizare Declaratia 394
    layout
    {
        addafter("Date Order")
        {
            field("SSA Tip Serie"; Rec."SSA Tip Serie")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Tip Serie field.';
            }
            field("SSA Denumire Beneficiar/Tert"; Rec."SSA Denumire Beneficiar/Tert")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the SSA Denumire Beneficiar/Tert field.';
            }
            field("SSA CUI Beneficiar Tert"; Rec."SSA CUI Beneficiar Tert")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the SSA CUI Beneficiar Tert field.';
            }
            field("SSA Export D394"; Rec."SSA Export D394")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Export D394 field.';
            }
        }
    }
}
