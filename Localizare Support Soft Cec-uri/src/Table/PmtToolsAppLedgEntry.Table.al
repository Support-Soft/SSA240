table 70500 "SSA Pmt. Tools AppLedg. Entry"
{
    // SSM729 SSCAT 21.06.2018 Nr.crt.76-Limita valorica pentru instrumente de plata neincasate- fin
    // SSM845 SSCAT 25.07.2018 meeting financiar 200718

    Caption = 'Payment Tools App-Ledg. Entry';
    DrillDownPageID = 70501;
    LookupPageID = 70501;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
        }
        field(10; "Document Type"; Option)
        {
            Caption = 'Document Type';
            OptionMembers = " ","Sales Invoice","Purchase Invoice";
        }
        field(20; "Document No."; Code[20])
        {
            Caption = 'Document No.';
            TableRelation = if ("Document Type" = const("Sales Invoice")) "Sales Invoice Header" else
            if ("Document Type" = const("Purchase Invoice")) "Purch. Inv. Header";
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
        field(30; Amount; Decimal)
        {
            Caption = 'Amount';
        }
        field(40; "Payment Document No."; Code[20])
        {
            Caption = 'Payment Document No.';
            TableRelation = "SSA Payment Header";
        }
        field(45; "Payment Document Line No."; Integer)
        {
            Caption = 'Payment Document Line No.';
            TableRelation = "SSA Payment Line"."Line No." where("No." = field("Payment Document No."));
        }
        field(50; "Payment Series"; Code[20])
        {
            Caption = 'Payment Series';
        }
        field(60; "Payment No."; Code[20])
        {
            Caption = 'Payment No.';
        }
        field(70; "Source Type"; Option)
        {
            Caption = 'Source Type';
            OptionMembers = " ",Customer,Vendor;
        }
        field(80; "Source No."; Code[20])
        {
            Caption = 'Source No.';
            TableRelation = if ("Source Type" = const(Customer)) Customer else
            if ("Source Type" = const(Vendor)) Vendor;
        }
        field(100; "Payment Class"; Text[30])
        {
            Caption = 'Payment Class';
            TableRelation = "SSA Payment Class";
        }
        field(110; "Status No."; Integer)
        {
            Caption = 'Status';
            TableRelation = "SSA Payment Status".Line where("Payment Class" = field("Payment Class"));

            trigger OnValidate()
            var
                PaymentStep: Record "SSA Payment Step";
                PaymentStatus: Record "SSA Payment Status";
            begin
            end;
        }
        field(120; "Status Name"; Text[50])
        {
            CalcFormula = lookup("SSA Payment Status".Name where("Payment Class" = field("Payment Class"), Line = field("Status No.")));
            Caption = 'Status Name';
            Editable = false;
            FieldClass = FlowField;
        }
        field(130; "Due Date"; Date)
        {
            Caption = 'Due Date';
            Description = 'SSM884';
        }
    }

    keys
    {
        key(Key1; "Entry No.")
        {
        }
    }

    fieldgroups
    {
    }
}
