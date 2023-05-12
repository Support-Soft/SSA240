pageextension 70022 "SSA Shipping Agents70022" extends "Shipping Agents"
{
    // SSA968 SSCAT 07.10.2019 34.Funct. Operatiuni triunghiulare, delivery, cod registru comertului, numar comanda client
    layout
    {
        addafter("Account No.")
        {
            field("SSA Delivery Info Mandatory"; "SSA Delivery Info Mandatory")
            {
                ApplicationArea = All;
            }
        }
    }
}

