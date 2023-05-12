tableextension 70039 "SSA Responsibility Center70039" extends "Responsibility Center"
{
    // SSA970 SSCAT 07.10.2019 36.Funct. UOM Mandatory, dimensiuni pe rounding, intercompany, denumire, conturi bancare
    fields
    {
        field(70000; "SSA Bank No."; Code[20])
        {
            Caption = 'Bank No.';
            DataClassification = ToBeClassified;
            Description = 'SSA970';
            TableRelation = "Bank Account";

            trigger OnValidate()
            var
                CompanyInfo: Record "Company Information";
                BankAcc: Record "Bank Account";
            begin
                //SSA970>>
                if BankAcc.Get("SSA Bank No.") then begin
                    "SSA Bank Name" := BankAcc.Name;
                    "SSA Bank Account No." := BankAcc."Bank Account No.";
                    "SSA Bank Branch No." := BankAcc."Bank Branch No.";
                    "SSA IBAN" := BankAcc.IBAN;
                end else begin
                    CompanyInfo.Get;
                    "SSA Bank Name" := CompanyInfo."Bank Name";
                    "SSA Bank Account No." := CompanyInfo."Bank Account No.";
                    "SSA Bank Branch No." := CompanyInfo."Bank Branch No.";
                    "SSA IBAN" := CompanyInfo.IBAN;
                end;
                //SSA970<<
            end;
        }
        field(70001; "SSA Bank Name"; Text[50])
        {
            Caption = 'Bank Name';
            DataClassification = ToBeClassified;
            Description = 'SSA970';
        }
        field(70002; "SSA Bank Account No."; Text[30])
        {
            Caption = 'Bank Account No.';
            DataClassification = ToBeClassified;
            Description = 'SSA970';
        }
        field(70003; "SSA Bank Branch No."; Text[20])
        {
            Caption = 'Bank Branch No.';
            DataClassification = ToBeClassified;
            Description = 'SSA970';
        }
        field(70004; "SSA IBAN"; Code[50])
        {
            Caption = 'IBAN';
            DataClassification = ToBeClassified;
            Description = 'SSA970';

            trigger OnValidate()
            var
                CompanyInfo: Record "Company Information";
            begin
                CompanyInfo.CheckIBAN("SSA IBAN"); //SSA970
            end;
        }
    }
}

