page 70007 "SSAInt. Consumption FactBox"
{
    // SSA937 SSCAT 16.06.2019 3.Funct. Bonuri de consum-consum intern

    Caption = 'Internal Consumption FactBox';
    Editable = false;
    PageType = CardPart;
    SourceTable = "SSAInternal Consumption Line";

    layout
    {
        area(content)
        {
            field("Item No."; "Item No.")
            {
                ApplicationArea = All;
            }
            field("Unit Cost (LCY)"; "Unit Cost (LCY)")
            {
                ApplicationArea = All;
            }
            field("Variant Code"; "Variant Code")
            {
                ApplicationArea = All;
            }
            field("Bin Code"; "Bin Code")
            {
                ApplicationArea = All;
            }
            field("Unit of Measure"; "Unit of Measure")
            {
                ApplicationArea = All;
            }
            field("Qty. per Unit of Measure"; "Qty. per Unit of Measure")
            {
                ApplicationArea = All;
            }
            field("Quantity (Base)"; "Quantity (Base)")
            {
                ApplicationArea = All;
            }
            field("Out-of-Stock Substitution"; "Out-of-Stock Substitution")
            {
                ApplicationArea = All;
            }
            field("Substitution Available"; "Substitution Available")
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
    }
}

