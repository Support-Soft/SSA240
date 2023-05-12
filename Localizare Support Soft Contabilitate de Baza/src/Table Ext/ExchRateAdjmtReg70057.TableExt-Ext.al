tableextension 70057 "SSA ExchRateAdjmtReg70057" extends "Exch. Rate Adjmt. Reg."
{
    fields
    {
        field(70000; "SSA Source Type"; Option)
        {
            Caption = 'Source Type';
            DataClassification = ToBeClassified;
            Description = 'SSA960';
            OptionCaption = ' ,Customer,Vendor,Bank Account,Fixed Asset,IC Partner,Employee';
            OptionMembers = " ",Customer,Vendor,"Bank Account","Fixed Asset","IC Partner",Employee;
        }
        field(70001; "SSA Source No."; Code[20])
        {
            Caption = 'Source No.';
            DataClassification = ToBeClassified;
            Description = 'SSA960';
            TableRelation = IF ("SSA Source Type" = CONST (Customer)) Customer
            ELSE
            IF ("SSA Source Type" = CONST (Vendor)) Vendor
            ELSE
            IF ("SSA Source Type" = CONST ("Bank Account")) "Bank Account"
            ELSE
            IF ("SSA Source Type" = CONST ("Fixed Asset")) "Fixed Asset"
            ELSE
            IF ("SSA Source Type" = CONST (Employee)) Employee;
        }
    }
}

