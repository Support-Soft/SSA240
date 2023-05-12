tableextension 70015 "SSA Shipping Agent70015" extends "Shipping Agent"
{
    // SSA968 SSCAT 07.10.2019 34.Funct. Operatiuni triunghiulare, delivery, cod registru comertului, numar comanda client
    fields
    {
        field(70000; "SSA Delivery Info Mandatory"; Boolean)
        {
            Caption = 'Delivery Info Mandatory';
            DataClassification = ToBeClassified;
            Description = 'SSA968';
        }
    }
}

