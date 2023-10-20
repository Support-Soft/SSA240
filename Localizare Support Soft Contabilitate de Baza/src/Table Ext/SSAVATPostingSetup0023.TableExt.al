tableextension 70023 "SSA VAT Posting Setup0023" extends "VAT Posting Setup"
{
    // SSA973 SSCAT 06.09.2019 39.Rapoarte legale- Localizare Declaratia 394
    // SSA1002 SSCAT 08.10.2019 69.Rapoarte legale-Jurnal cumparari neexigibil
    // SSA974 SSCAT 11.10.2019 40.Rapoarte legale-Declaratia 390
    fields
    {
        field(70000; "SSA Tip Operatie"; Option)
        {
            DataClassification = CustomerContent;
            Description = 'SSA973';
            OptionMembers = " ",L,LS,A,AI,AS,ASI,V,C,N;
            Caption = 'Tip Operatie';
        }
        field(70001; "SSA VAT to pay"; Boolean)
        {
            Caption = 'VAT to pay';
            DataClassification = CustomerContent;
            Description = 'SSA973';
        }
        field(70002; "SSA Nu Apare in 390"; Boolean)
        {
            DataClassification = CustomerContent;
            Description = 'SSA973';
            Caption = 'Nu Apare in 390';
        }
        field(70003; "SSA Journals VAT %"; Decimal)
        {
            Caption = 'Journals VAT %';
            DataClassification = CustomerContent;
            DecimalPlaces = 0 : 2;
            Description = 'SSA973';
        }
        field(70004; "SSA Column Type"; Option)
        {
            Caption = 'Column Type';
            DataClassification = CustomerContent;
            Description = 'SSA1002';
            OptionCaption = 'VAT 24%,External Free of VAT Deductible,External Free of VAT Not Deductible,Internal Free of VAT Deductible,Internal Free of VAT Not Deductible,Unrealized VAT,Free of VAT,VAT 9%,Simplified VAT,Drop Ship Ded,Drop Ship Not Ded,ICS Free of VAT AD,ICS Free of VAT BC,Free of VAT Deductible,Free of VAT Not Deductible,Not Taxable,Capital 24%,Resale 24%,Needs 24%,Resale 9%,Needs 9%,ICA Resale,ICA Resale Free of VAT,ICA Resale Not Taxable,ICA Needs,ICA Needs Free of VAT,ICA Needs Not Taxable,Art 150 FC,Special Regime,VAT 5%,ICA Goods Not Registered,ICA Services,ICS Services';
            OptionMembers = "VAT 24%","External Free of VAT Deductible","External Free of VAT Not Deductible","Internal Free of VAT Deductible","Internal Free of VAT Not Deductible","Unrealized VAT","Free of VAT","VAT 9%","Simplified VAT","Drop Ship Ded","Drop Ship Not Ded","ICS Free of VAT AD","ICS Free of VAT BC","Free of VAT Deductible","Free of VAT Not Deductible","Not Taxable","Capital 24%","Resale 24%","Needs 24%","Resale 9%","Needs 9%","ICA Resale","ICA Resale Free of VAT","ICA Resale Not Taxable","ICA Needs","ICA Needs Free of VAT","ICA Needs Not Taxable","Art 150 FC","Special Regime","VAT 5%","ICA Goods Not Registered","ICA Services","ICS Services";
        }
        field(70005; "SSA VIES Purchases"; Boolean)
        {
            Caption = 'VIES Purchases';
            DataClassification = CustomerContent;
            Description = 'SSA974';
        }
        field(70006; "SSA VIES Sales"; Boolean)
        {
            Caption = 'VIES Sales';
            DataClassification = CustomerContent;
            Description = 'SSA974';
        }
        field(70007; "SSA Non-Deductible VAT Prod."; Boolean)
        {
            CalcFormula = lookup("VAT Product Posting Group"."SSA Non-Deductible VAT" where(Code = field("VAT Prod. Posting Group")));
            Caption = 'Non-Deductible VAT Prod.';
            Description = 'SSA948';
            Editable = false;
            FieldClass = FlowField;
        }
    }
}
