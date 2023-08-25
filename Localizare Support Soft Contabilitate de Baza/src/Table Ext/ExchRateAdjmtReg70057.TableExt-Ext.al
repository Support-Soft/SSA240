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
            TableRelation = if ("SSA Source Type" = const(Customer)) Customer
            else
            if ("SSA Source Type" = const(Vendor)) Vendor
            else
            if ("SSA Source Type" = const("Bank Account")) "Bank Account"
            else
            if ("SSA Source Type" = const("Fixed Asset")) "Fixed Asset"
            else
            if ("SSA Source Type" = const(Employee)) Employee;
        }
    }
}

