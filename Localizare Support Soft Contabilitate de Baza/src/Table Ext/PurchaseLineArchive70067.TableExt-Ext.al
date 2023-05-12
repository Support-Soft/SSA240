tableextension 70067 "Purchase Line Archive 70067" extends "Purchase Line Archive"
{
    fields
    {
        field(70000; "SSA Distribute Non-Ded VAT"; Boolean)
        {
            Caption = 'Distribute Non-Deductible VAT';
            DataClassification = ToBeClassified;
            Description = 'SSA948';

            trigger OnValidate()
            begin
                TestField(Type, Type::"G/L Account");//SSA948
            end;
        }
        field(70001; "SSA Non-Ded VAT Expense Acc 1"; Code[20])
        {
            Caption = 'Non-Ded VAT Expense Account 1';
            DataClassification = ToBeClassified;
            Description = 'SSA948';
            TableRelation = "G/L Account";
        }
        field(70002; "SSA Non-Ded VAT Expense Acc 2"; Code[20])
        {
            Caption = 'Non-Ded VAT Expense Account 2';
            DataClassification = ToBeClassified;
            Description = 'SSA948';
            TableRelation = "G/L Account";
        }
    }
}