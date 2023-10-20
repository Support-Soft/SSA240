pageextension 70028 "SSA VAT Posting Setup70028" extends "VAT Posting Setup"
{
    // SSA947 SSCAT 10.01.2019 13.Funct. “TVA la incasare”
    // SSA1002 SSCAT 08.10.2019 69.Rapoarte legale-Jurnal cumparari neexigibil
    // SSA974 SSCAT 11.10.2019 40.Rapoarte legale-Declaratia 390
    layout
    {
        addafter("Tax Category")
        {
            field("SSA Tip Operatie"; Rec."SSA Tip Operatie")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the SSA Tip Operatie field.';
            }
            field("SSA VAT to pay"; Rec."SSA VAT to pay")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the VAT to pay field.';
            }
            field("SSA Nu Apare in 390"; Rec."SSA Nu Apare in 390")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the SSA Nu Apare in 390 field.';
            }
            field("SSA Journals VAT %"; Rec."SSA Journals VAT %")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Journals VAT % field.';
            }
            field("SSA Column Type"; Rec."SSA Column Type")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Column Type field.';
            }
        }
    }
}
