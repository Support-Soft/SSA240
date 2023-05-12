pageextension 70044 "SSA Posted ReturnShipment70044" extends "Posted Return Shipment"
{
    // SSA973 SSCAT 06.09.2019 39.Rapoarte legale- Localizare Declaratia 394
    layout
    {
        addafter("Applies-to Doc. No.")
        {
            field("SSA Tip Document D394"; "SSA Tip Document D394")
            {
                ApplicationArea = All;
                Editable = false;
            }
            field("SSA Stare Factura"; "SSA Stare Factura")
            {
                ApplicationArea = All;
                Editable = false;
            }
        }
    }
}

