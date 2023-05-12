pageextension 70032 "SSA PurchInvoiceSubform70032" extends "Purch. Invoice Subform"
{
    // SSA948 SSCAT 08.10.2019 14.Funct. Functionalitatea deductibilitate cheltuieli 50% /100%
    layout
    {
        addafter("Line No.")
        {
            field("SSA Distribute Non-Ded VAT"; "SSA Distribute Non-Ded VAT")
            {
                ApplicationArea = All;
            }
            field("SSA Non-Ded VAT Expense Acc 1"; "SSA Non-Ded VAT Expense Acc 1")
            {
                ApplicationArea = All;
            }
            field("SSA Non-Ded VAT Expense Acc 2"; "SSA Non-Ded VAT Expense Acc 2")
            {
                ApplicationArea = All;
            }
            field("SSA Tax Group Code"; "Tax Group Code")
            {
                ApplicationArea = All;
            }
        }
    }
}

