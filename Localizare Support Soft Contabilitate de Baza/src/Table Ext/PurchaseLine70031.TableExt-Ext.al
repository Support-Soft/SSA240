tableextension 70031 "SSA Purchase Line70031" extends "Purchase Line"
{
    // SSA942 SSCAT 17.06.2019 8.Funct. De analizat asociere taxe articol la vanzari si cump. Filtrare pe posting group-ului articolului
    // SSA948 SSCAT 08.10.2019 14.Funct. Functionalitatea deductibilitate cheltuieli 50% /100%
    fields
    {
        field(70000; "SSA Distribute Non-Ded VAT"; Boolean)
        {
            Caption = 'Distribute Non-Deductible VAT';
            DataClassification = CustomerContent;
            Description = 'SSA948';

            trigger OnValidate()
            begin
                TestField(Type, Type::"G/L Account");//SSA948
            end;
        }
        field(70001; "SSA Non-Ded VAT Expense Acc 1"; Code[20])
        {
            Caption = 'Non-Ded VAT Expense Account 1';
            DataClassification = CustomerContent;
            Description = 'SSA948';
            TableRelation = "G/L Account";
        }
        field(70002; "SSA Non-Ded VAT Expense Acc 2"; Code[20])
        {
            Caption = 'Non-Ded VAT Expense Account 2';
            DataClassification = CustomerContent;
            Description = 'SSA948';
            TableRelation = "G/L Account";
        }
    }
}
