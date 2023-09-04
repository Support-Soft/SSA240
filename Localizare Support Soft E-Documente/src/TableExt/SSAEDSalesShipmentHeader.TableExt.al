tableextension 72001 "SSAEDSales Shipment Header" extends "Sales Shipment Header"
{
    fields
    {
        field(72001; "SSAEDProdus cu Risc"; Boolean)
        {
            CalcFormula = exist("Sales Shipment Line" where("Document No." = field("No."),
                                                             "SSAEDProdus cu Risc" = const(true)));
            Caption = 'Produs cu Risc';
            Description = 'SSM1997';
            Editable = false;
            FieldClass = FlowField;
        }
        field(72002; "SSAEDNr. Inmatriculare"; Text[30])
        {
            Caption = 'Nr. Inmatriculare';
            DataClassification = CustomerContent;
            Description = 'SSM2002';
        }
    }
}

