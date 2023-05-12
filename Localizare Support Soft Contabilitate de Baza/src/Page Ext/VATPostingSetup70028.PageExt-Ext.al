pageextension 70028 "SSA VAT Posting Setup70028" extends "VAT Posting Setup"
{
    // SSA947 SSCAT 10.01.2019 13.Funct. “TVA la incasare”
    // SSA1002 SSCAT 08.10.2019 69.Rapoarte legale-Jurnal cumparari neexigibil
    // SSA974 SSCAT 11.10.2019 40.Rapoarte legale-Declaratia 390
    layout
    {
        addafter("Tax Category")
        {
            field("SSA Tip Operatie"; "SSA Tip Operatie")
            {
                ApplicationArea = All;
            }
            field("SSA VAT to pay"; "SSA VAT to pay")
            {
                ApplicationArea = All;
            }
            field("SSA Nu Apare in 390"; "SSA Nu Apare in 390")
            {
                ApplicationArea = All;
            }
            field("SSA Journals VAT %"; "SSA Journals VAT %")
            {
                ApplicationArea = All;
            }
            field("SSA Column Type"; "SSA Column Type")
            {
                ApplicationArea = All;
            }
        }
    }
}

