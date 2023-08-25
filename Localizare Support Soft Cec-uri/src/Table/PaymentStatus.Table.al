table 70502 "SSA Payment Status"
{
    // SSM729 SSCAT 22.06.2018 Nr.crt.76-Limita valorica pentru instrumente de plata neincasate- fin

    Caption = 'Payment Status';

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
        field(4; RIB; Boolean)
        {
            Caption = 'RIB';
        }
        field(5; Look; Boolean)
        {
            Caption = 'Look';
        }
        field(6; ReportMenu; Boolean)
        {
            Caption = 'Report';
        }
        field(7; "Acceptation Code"; Boolean)
        {
            Caption = 'Acceptation Code';
        }
        field(8; Amount; Boolean)
        {
            Caption = 'Amount';
        }
        field(9; Debit; Boolean)
        {
            Caption = 'Debit';
        }
        field(10; Credit; Boolean)
        {
            Caption = 'Credit';
        }
        field(11; "Bank Account"; Boolean)
        {
            Caption = 'Bank Account';
        }
        field(20; "Payment in progress"; Boolean)
        {
            Caption = 'Payment in progress';
        }
        field(21; "Archiving authorized"; Boolean)
        {
            Caption = 'Archiving authorized';
        }
        field(50000; "Payment Finished"; Boolean)
        {
            Description = 'SSM729';
        }
        field(50010; "Auto Archive"; Boolean)
        {
            Caption = 'Auto Archive';
            Description = 'SSM729';
        }
        field(50020; "Canceled/Refused"; Boolean)
        {
            Caption = 'Canceled/Refused';
            Description = 'SSM729';
        }
        field(50030; "Allow Edit Payment No."; Boolean)
        {
            Caption = 'Allow Edit Payment No.';
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
    var
        PaymentStep: Record "SSA Payment Step";
        PaymentHeader: Record "SSA Payment Header";
        PaymentLine: Record "SSA Payment Line";
    begin
        if Line = 0 then
            ERROR(Text000);
        PaymentStep.SETRANGE("Payment Class", "Payment Class");
        PaymentStep.SETRANGE("Previous Status", Line);
        if PaymentStep.FIND('-') then
            ERROR(Text001);
        PaymentStep.SETRANGE("Previous Status");
        PaymentStep.SETRANGE("Next Status", Line);
        if PaymentStep.FIND('-') then
            ERROR(Text001);
        PaymentHeader.SETRANGE("Payment Class", "Payment Class");
        PaymentHeader.SETRANGE("Status No.", Line);
        if PaymentHeader.FIND('-') then
            ERROR(Text001);
        PaymentLine.SETRANGE("Payment Class", "Payment Class");
        PaymentLine.SETRANGE("Status No.", Line);
        if PaymentLine.FIND('-') then
            ERROR(Text001);
    end;

    var
        Text000: Label 'Deleting the first report not allowed';
        Text001: Label 'Deleting is not allowed because this Payment Status is already used.';
}

