tableextension 70018 "SSA FinChargeMemoHeader70018" extends "Finance Charge Memo Header"
{
    // SSA968 SSCAT 04.10.2019 34.Funct. Operatiuni triunghiulare, delivery, cod registru comertului, numar comanda client
    fields
    {
        field(70000; "SSA Commerce Trade No."; Code[20])
        {
            Caption = 'Commerce Trade No.';
            DataClassification = ToBeClassified;
            Description = 'SSA968';
        }
    }
}

