pageextension 70032 "SSA PurchInvoiceSubform70032" extends "Purch. Invoice Subform"
{
    // SSA948 SSCAT 08.10.2019 14.Funct. Functionalitatea deductibilitate cheltuieli 50% /100%
    layout
    {
        addafter("Line No.")
        {
            field("SSA Distribute Non-Ded VAT"; Rec."SSA Distribute Non-Ded VAT")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Distribute Non-Deductible VAT field.';
            }
            field("SSA Non-Ded VAT Expense Acc 1"; Rec."SSA Non-Ded VAT Expense Acc 1")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Non-Ded VAT Expense Account 1 field.';
            }
            field("SSA Non-Ded VAT Expense Acc 2"; Rec."SSA Non-Ded VAT Expense Acc 2")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Non-Ded VAT Expense Account 2 field.';
            }
            field("SSA Tax Group Code"; Rec."Tax Group Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the tax group code for the tax detail entry.';
            }
        }
    }
}
