tableextension 72017 "SSAEDSales Header Archive" extends "Sales Header Archive"
{
    fields
    {
        field(72001; "SSAEDProdus cu Risc"; Boolean)
        {
            CalcFormula = exist("Sales Line Archive" where("Document Type" = field("Document Type"),
                                                            "Document No." = field("No."),
                                                            "Doc. No. Occurrence" = field("Doc. No. Occurrence"),
                                                            "Version No." = field("Version No."),
                                                            "SSAEDProdus cu Risc" = const(true)));
            Caption = 'Produs cu Risc';
            Description = 'SSM1997';
            Editable = false;
            FieldClass = FlowField;
        }
    }
}

