tableextension 72011 "SSAEDSales Header" extends "Sales Header"
{
    fields
    {
        field(72000; "SSAEDShip-to Sector"; Option)
        {
            Caption = 'Ship-to Sector';
            DataClassification = CustomerContent;
            Description = 'SSM1997';
            OptionMembers = " ",SECTOR1,SECTOR2,SECTOR3,SECTOR4,SECTOR5,SECTOR6;
        }
        field(72001; "SSAEDProdus cu Risc"; Boolean)
        {
            CalcFormula = exist("Sales Line" where("Document Type" = field("Document Type"),
                                                    "Document No." = field("No."),
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

