pageextension 70004 "SSA Posted Sales Shipment70004" extends "Posted Sales Shipment"
{
    // SSA968 SSCAT 04.10.2019 34.Funct. Operatiuni triunghiulare, delivery, cod registru comertului, numar comanda client
    layout
    {
        addafter("External Document No.")
        {
            field("SSA Customer Order No."; Rec."SSA Customer Order No.")
            {
                ApplicationArea = All;
                Editable = false;
                ToolTip = 'Specifies the value of the Customer Order No. field.';
            }
        }
    }
}
