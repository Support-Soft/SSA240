tableextension 72013 "SSAEDWarehouse Shipment Line" extends "Warehouse Shipment Line"
{
    fields
    {
        field(72000; "SSAEDProdus cu Risc"; Boolean)
        {
            Caption = 'Produs cu Risc';
            Description = 'SSM1997';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup("Sales Line"."SSAEDProdus cu Risc" where("Document Type" = field("Source Subtype"), "Document No." = field("Source No."), "Line No." = field("Source Line No.")));

        }
    }
}

