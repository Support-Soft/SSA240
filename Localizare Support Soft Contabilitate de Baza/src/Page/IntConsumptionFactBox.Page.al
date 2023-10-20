page 70007 "SSAInt. Consumption FactBox"
{
    // SSA937 SSCAT 16.06.2019 3.Funct. Bonuri de consum-consum intern

    Caption = 'Internal Consumption FactBox';
    Editable = false;
    PageType = CardPart;
    SourceTable = "SSAInternal Consumption Line";
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            field("Item No."; Rec."Item No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Item No. field.';
            }
            field("Unit Cost (LCY)"; Rec."Unit Cost (LCY)")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Unit Cost (LCY) field.';
            }
            field("Variant Code"; Rec."Variant Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Variant Code field.';
            }
            field("Bin Code"; Rec."Bin Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Bin Code field.';
            }
            field("Unit of Measure"; Rec."Unit of Measure")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Unit of Measure field.';
            }
            field("Qty. per Unit of Measure"; Rec."Qty. per Unit of Measure")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Qty. per Unit of Measure field.';
            }
            field("Quantity (Base)"; Rec."Quantity (Base)")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Quantity (Base) field.';
            }
            field("Out-of-Stock Substitution"; Rec."Out-of-Stock Substitution")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Out-of-Stock Substitution field.';
            }
            field("Substitution Available"; Rec."Substitution Available")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Substitution Available field.';
            }
        }
    }

}
