tableextension 70007 "SSA G/L Account70007" extends "G/L Account"
{
    // SSA955 SSCAT 23.08.2019 21.Funct. Localizare inchidere lunara venituri si cheltuieli
    // SSA940 SSCAT 26.09.2019 6.Funct. corectii rulaje clasa 7-6
    // SSA948 SSCAT 08.10.2019 14.Funct. Functionalitatea deductibilitate cheltuieli 50% /100%
    // SSA978 SSCAT 08.10.2019 45.Rapoarte legale-Balanta de verificare solduri precedente
    fields
    {
        field(70000; "SSA Closing Account"; Code[20])
        {
            Caption = 'Closing Account';
            DataClassification = ToBeClassified;
            Description = 'SSA955';
            TableRelation = "G/L Account";
        }
        field(70001; "SSA Check Posting Debit/Credit"; Boolean)
        {
            Caption = 'Check Posting Debit/Credit';
            DataClassification = ToBeClassified;
            Description = 'SSA940';
        }
        field(70002; "SSA Distribute Non-Ded VAT"; Boolean)
        {
            Caption = 'Distribute Non-Deductible VAT';
            DataClassification = ToBeClassified;
            Description = 'SSA948';
        }
        field(70003; "SSA Non-Ded VAT Expense Acc 1"; Code[20])
        {
            Caption = 'Non-Ded VAT Expense Account 1';
            DataClassification = ToBeClassified;
            Description = 'SSA948';
            TableRelation = "G/L Account";
        }
        field(70004; "SSA Non-Ded VAT Expense Acc 2"; Code[20])
        {
            Caption = 'Non-Ded VAT Expense Account 2';
            DataClassification = ToBeClassified;
            Description = 'SSA948';
            TableRelation = "G/L Account";
        }
        field(70005; "SSA Analytic/Synth1/Synth2"; Option)
        {
            Caption = 'Analytic/Synthetic1/Synthetic2';
            DataClassification = ToBeClassified;
            Description = 'SSA978';
            OptionCaption = 'Analytic,Synthetic1,Synthetic2, ';
            OptionMembers = Analytic,Synthetic1,Synthetic2," ";
        }
    }
}

