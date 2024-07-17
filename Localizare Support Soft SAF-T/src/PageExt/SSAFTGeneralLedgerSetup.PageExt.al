pageextension 71902 "SSAFTGeneral Ledger Setup" extends "General Ledger Setup"
{
    layout
    {
        addlast(content)
        {
            group(SSAFT)
            {
                Caption = 'SAFT';
                field("SSAFTGrupa cu TVA UE Client"; Rec."SSAFTGrupa cu TVA UE Client")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Grupa cu TVA UE Client field.';
                }
                field("SSAFTGrupa cu TVA NONUE Client"; Rec."SSAFTGrupa cu TVA NONUE Client")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Grupa cu TVA NONUE Client field.';
                }
                field("SSAFTGrupa cu TVA UE Furnizor"; Rec."SSAFTGrupa cu TVA UE Furnizor")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Grupa cu TVA UE Furnizor field.';
                }
                field("SSAFTGrupa cu TVA NONUE Fz"; Rec."SSAFTGrupa cu TVA NONUE Fz")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Grupa cu TVA NONUE Fz field.';
                }
                field("SSAFTG/L Accounts Payments"; Rec."SSAFTG/L Accounts Payments")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the G/L Accounts Payments field.', Comment = 'Conturi Contabile de Raportat la Payments';
                }
            }
        }
    }
}