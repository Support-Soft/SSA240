tableextension 72021 "SSAEDReturn Receipt Header" extends "Return Receipt Header"
{
    fields
    {
        field(72001; "SSAEDProdus cu Risc"; Boolean)
        {
            CalcFormula = exist("Return Receipt Line" where("Document No." = field("No."),
                                                             "SSAEDProdus cu Risc" = const(true)));
            Caption = 'Produs cu Risc';
            Description = 'SSM1997';
            Editable = false;
            FieldClass = FlowField;
        }
    }
}

