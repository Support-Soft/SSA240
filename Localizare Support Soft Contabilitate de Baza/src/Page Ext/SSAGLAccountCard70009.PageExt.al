pageextension 70009 "SSA G/L Account Card70009" extends "G/L Account Card"
{
    // SSA955 SSCAT 23.08.2019 21.Funct. Localizare inchidere lunara venituri si cheltuieli
    // SSA940 SSCAT 27.09.2019 6.Funct. corectii rulaje clasa 7-6
    // SSA978 SSCAT 08.10.2019 45.Rapoarte legale-Balanta de verificare solduri precedente
    layout
    {
        addlast(Consolidation)
        {
            group("SSA SSALocalizare")
            {
                Caption = 'Localizare';

                field("SSA Check Posting Debit/Credit"; Rec."SSA Check Posting Debit/Credit")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Check Posting Debit/Credit field.';
                }
                field("SSA Analytic/Synth1/Synth2"; Rec."SSA Analytic/Synth1/Synth2")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Analytic/Synthetic1/Synthetic2 field.';
                }
                field("SSA Closing Account"; Rec."SSA Closing Account")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Closing Account field.';
                }
                field("SSA Distribute Non-Ded VAT"; Rec."SSA Distribute Non-Ded VAT")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Distribute Non-Deductible VAT field.';
                }
                field("SSA Non-Ded VAT Expense Acc 1"; Rec."SSA Non-Ded VAT Expense Acc 1")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Non-Ded VAT Expense Account 1 field.';
                }
                field("SSA Non-Ded VAT Expense Acc 2"; Rec."SSA Non-Ded VAT Expense Acc 2")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Non-Ded VAT Expense Account 2 field.';
                }
            }
        }
    }
}
