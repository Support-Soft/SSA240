pageextension 70068 "SSA Purch. Cr. Memo Subform" extends "Purch. Cr. Memo Subform"
{
    layout
    {
        addlast(Control1)
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
        }
    }
}