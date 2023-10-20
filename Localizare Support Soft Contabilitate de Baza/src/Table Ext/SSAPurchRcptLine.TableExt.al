tableextension 70013 "SSA Purch. Rcpt. Line" extends "Purch. Rcpt. Line" //121
{
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
        field(70100; "SSA Vendor Shipment No."; Code[35])
        {
            Caption = 'Vendor Shipment  No.';
            FieldClass = FlowField;
            CalcFormula = lookup("Purch. Rcpt. Header"."Vendor Shipment No." where("No." = field("Document No.")));
            Editable = false;
        }
        field(70101; "SSA Vendor Invoice No."; Code[35])
        {
            Caption = 'Vendor Invoice  No.';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup("Purch. Rcpt. Header"."SSA Vendor Invoice No." where("No." = field("Document No.")));
        }
        field(70102; "SSA Custom Invoice No."; Code[35])
        {
            Caption = 'Custom Invoice No.';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup("Purch. Rcpt. Header"."SSA Custom Invoice No." where("No." = field("Document No.")));
        }
    }
}