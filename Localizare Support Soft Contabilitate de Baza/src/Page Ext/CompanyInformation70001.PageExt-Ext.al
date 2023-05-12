pageextension 70001 "SSA Company Information 70001" extends "Company Information"
{
    // SSA968 SSCAT 04.10.2019 34.Funct. Operatiuni triunghiulare, delivery, cod registru comertului, numar comanda client
    layout
    {
        addafter("VAT Registration No.")
        {
            field("SSA Commerce Trade No."; "SSA Commerce Trade No.")
            {
                ApplicationArea = All;
            }
        }
        addlast(General)
        {
            field("SSA Capital Stock"; "SSA Capital Stock")
            {
                ApplicationArea = All;
            }
        }
        addlast(Payments)
        {
            field("SSA Bank Name 1"; "SSA Bank Name 1")
            {
                ApplicationArea = All;
            }
            field("SSA IBAN 1"; "SSA IBAN 1")
            {
                ApplicationArea = All;
            }
            field("SSA SWIFT Code 1"; "SSA SWIFT Code 1")
            {
                ApplicationArea = All;
            }
            field("SSA Bank Name 2"; "SSA Bank Name 2")
            {
                ApplicationArea = All;
            }
            field("SSA IBAN 2"; "SSA IBAN 2")
            {
                ApplicationArea = All;
            }
            field("SSA SWIFT Code 2"; "SSA SWIFT Code 2")
            {
                ApplicationArea = All;
            }
        }
    }
}

