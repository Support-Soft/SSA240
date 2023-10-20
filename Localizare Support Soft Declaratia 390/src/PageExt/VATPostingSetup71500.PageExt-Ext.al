pageextension 71500 "SSA VAT Posting Setup 71500" extends "VAT Posting Setup"
{
    // SSA947 SSCAT 10.01.2019 13.Funct. “TVA la incasare”
    // SSA1002 SSCAT 08.10.2019 69.Rapoarte legale-Jurnal cumparari neexigibil
    // SSA974 SSCAT 11.10.2019 40.Rapoarte legale-Declaratia 390
    layout
    {
        addafter("Tax Category")
        {
            field("SSA VIES Purchases"; Rec."SSA VIES Purchases")
            {
                ApplicationArea = All;
            }
            field("SSA VIES Sales"; Rec."SSA VIES Sales")
            {
                ApplicationArea = All;
            }
        }
    }
}

