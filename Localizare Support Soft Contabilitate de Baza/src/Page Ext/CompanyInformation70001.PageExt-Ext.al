pageextension 70001 "SSA Company Information 70001" extends "Company Information"
{
    // SSA968 SSCAT 04.10.2019 34.Funct. Operatiuni triunghiulare, delivery, cod registru comertului, numar comanda client
    layout
    {
        addafter("VAT Registration No.")
        {
            field("SSA Commerce Trade No."; Rec."SSA Commerce Trade No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Commerce Trade No. field.';
            }
        }
        addlast(General)
        {
            field("SSA Capital Stock"; Rec."SSA Capital Stock")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Capital Stock field.';
            }
        }
        addlast(Payments)
        {
            field("SSA Bank Name 1"; Rec."SSA Bank Name 1")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Bank Name 1 field.';
            }
            field("SSA IBAN 1"; Rec."SSA IBAN 1")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the IBAN 1 field.';
            }
            field("SSA SWIFT Code 1"; Rec."SSA SWIFT Code 1")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Cod SWIFT 1 field.';
            }
            field("SSA Bank Name 2"; Rec."SSA Bank Name 2")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Bank Name 2 field.';
            }
            field("SSA IBAN 2"; Rec."SSA IBAN 2")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the IBAN 2 field.';
            }
            field("SSA SWIFT Code 2"; Rec."SSA SWIFT Code 2")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Cod SWIFT 2 field.';
            }
        }
    }
}
