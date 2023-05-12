table 70503 "SSA Payment Step"
{
    // SSM729 SSCAT 22.06.2018 Nr.crt.76-Limita valorica pentru instrumente de plata neincasate- fin

    Caption = 'Payment Step';

    fields
    {
        field(1; "Payment Class"; Text[30])
        {
            Caption = 'Payment Class';
            TableRelation = "SSA Payment Class";
        }
        field(2; Line; Integer)
        {
            Caption = 'Line';
        }
        field(3; Name; Text[50])
        {
            Caption = 'Name';
        }
        field(4; "Previous Status"; Integer)
        {
            Caption = 'Previous Status';
            TableRelation = "SSA Payment Status".Line WHERE("Payment Class" = FIELD("Payment Class"));
        }
        field(5; "Next Status"; Integer)
        {
            Caption = 'Next Status';
            TableRelation = "SSA Payment Status".Line WHERE("Payment Class" = FIELD("Payment Class"));
        }
        field(6; "Action Type"; Option)
        {
            Caption = 'Action Type';
            OptionCaption = 'None,Ledger,Report,File,Create new Document';
            OptionMembers = "None",Ledger,"Report",File,"Create new Document";
        }
        field(7; "Report No."; Integer)
        {
            Caption = 'Report No.';
            TableRelation = IF ("Action Type" = CONST(Report)) AllObj."Object ID" WHERE("Object Type" = CONST(Report));
        }
        field(8; "Dataport No."; Integer)
        {
            Caption = 'Dataport No.';
        }
        field(9; "Previous Status Name"; Text[50])
        {
            Caption = 'Previous Status Name';
            FieldClass = FlowField;
            CalcFormula = Lookup("SSA Payment Status".Name WHERE("Payment Class" = FIELD("Payment Class"), Line = FIELD("Previous Status")));
        }
        field(10; "Next Status Name"; Text[50])
        {
            CalcFormula = Lookup("SSA Payment Status".Name WHERE("Payment Class" = FIELD("Payment Class"), Line = FIELD("Next Status")));
            Caption = 'Next Status Name';
            FieldClass = FlowField;
        }
        field(11; "Verify Lines RIB"; Boolean)
        {
            Caption = 'Verify Lines RIB';
        }
        field(12; "Header Nos. Series"; Code[10])
        {
            Caption = 'Header Nos. Series';
            TableRelation = "No. Series";

            trigger OnValidate()
            var
                NoSeriesLine: Record "No. Series Line";
            begin
                IF "Header Nos. Series" <> '' THEN BEGIN
                    NoSeriesLine.SETRANGE("Series Code", "Header Nos. Series");
                    IF NoSeriesLine.FIND('+') THEN
                        IF (STRLEN(NoSeriesLine."Starting No.") > 10) OR (STRLEN(NoSeriesLine."Ending No.") > 10) THEN
                            ERROR(Text001);
                END;
            end;
        }
        field(13; "Reason Code"; Code[10])
        {
            Caption = 'Reason Code';
            TableRelation = "Reason Code";
        }
        field(14; "Source Code"; Code[10])
        {
            Caption = 'Source Code';
            Editable = true;
            TableRelation = "Source Code";
        }
        field(15; "Acceptation Code<>No"; Boolean)
        {
            Caption = 'Acceptation Code<>No';
        }
        field(16; Correction; Boolean)
        {
            Caption = 'Correction';
        }
        field(17; "Verify Header RIB"; Boolean)
        {
            Caption = 'Verify Header RIB';
        }
        field(18; "Verify Due Date"; Boolean)
        {
            Caption = 'Verify Due Date';
        }
        field(50000; "Tip Detalii Aplicari"; Option)
        {
            Description = 'SSM729';
            OptionMembers = " ","Suma Aplicata","Suma Dezaplicata";
        }
        field(50010; "Permite Reaplicari"; Boolean)
        {
            Description = 'SSM729';
        }
    }

    keys
    {
        key(Key1; "Payment Class", Line)
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        IF Line = 0 THEN ERROR(Text000);
    end;

    var
        Text000: Label 'Deleting default report not allowed';
        Text001: Label 'The series'' nos must not be greater than 10.';
}
