table 70501 "SSA Payment Class"
{
    // SSM729 SSCAT 21.06.2018 Nr.crt.76-Limita valorica pentru instrumente de plata neincasate- fin

    Caption = 'Payment Class';
    DrillDownPageId = 70504;
    LookupPageId = 70504;
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Code"; Text[30])
        {
            Caption = 'Code';
            NotBlank = true;

            trigger OnValidate()
            begin
                if Name = '' then
                    Name := Code;
            end;
        }
        field(2; Name; Text[50])
        {
            Caption = 'Name';
        }
        field(3; "Header No. Series"; Code[10])
        {
            Caption = 'Header No. Series';
            TableRelation = "No. Series";

            trigger OnValidate()
            var
                NoSeriesLine: Record "No. Series Line";
            begin
                if "Header No. Series" <> '' then begin
                    NoSeriesLine.SETRANGE("Series Code", "Header No. Series");
                    if NoSeriesLine.FIND('+') then
                        if (STRLEN(NoSeriesLine."Starting No.") > 10) or (STRLEN(NoSeriesLine."Ending No.") > 10) then
                            ERROR(Text002);
                end;
            end;
        }
        field(4; Enable; Boolean)
        {
            Caption = 'Enable';
            InitValue = true;
        }
        field(5; "Line No. Series"; Code[10])
        {
            Caption = 'Line No. Series';
            TableRelation = "No. Series";

            trigger OnValidate()
            var
                NoSeriesLine: Record "No. Series Line";
            begin
                if "Line No. Series" <> '' then begin
                    NoSeriesLine.SETRANGE("Series Code", "Line No. Series");
                    if NoSeriesLine.FIND('+') then
                        if (STRLEN(NoSeriesLine."Starting No.") > 10) or (STRLEN(NoSeriesLine."Ending No.") > 10) then
                            ERROR(Text002);
                end;
            end;
        }
        field(6; Suggestions; Option)
        {
            Caption = 'Suggestions';
            OptionCaption = 'None,Customer,Vendor';
            OptionMembers = "None",Customer,Vendor;
        }
        field(10; "Is create document"; Boolean)
        {
            CalcFormula = exist("SSA Payment Step" where("Payment Class" = field(Code), "Action Type" = const("Create new Document")));
            Caption = 'Is create document';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50000; "Payment Tools"; Option)
        {
            Caption = 'Payment Tools Customer';
            Description = 'SSM729';
            OptionCaption = ' ,CEC,BO';
            OptionMembers = " ",CEC,BO;
        }
    }

    keys
    {
        key(Key1; "Code")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    var
        Status: Record "SSA Payment Status";
        Step: Record "SSA Payment Step";
        StepLedger: Record "SSA Payment Step Ledger";
        PaymentHeader: Record "SSA Payment Header";
        PaymentLine: Record "SSA Payment Line";
    begin
        PaymentHeader.SETRANGE("Payment Class", Code);
        PaymentLine.SETRANGE("Payment Class", Code);
        if PaymentHeader.FIND('-') then
            ERROR(Text001);
        if PaymentLine.FIND('-') then
            ERROR(Text001);
        Status.SETRANGE("Payment Class", Code);
        Status.DELETEALL;
        Step.SETRANGE("Payment Class", Code);
        Step.DELETEALL;
        StepLedger.SETRANGE("Payment Class", Code);
        StepLedger.DELETEALL;
    end;

    trigger OnInsert()
    var
        FirstStatus: Record "SSA Payment Status";
    begin
        // Création du statut initial
        FirstStatus."Payment Class" := Code;
        FirstStatus.Name := Text000;
        FirstStatus.INSERT;
    end;

    var
        Text000: Label 'XXXXXX';
        Text001: Label 'Deleting is not allowed because this Payment Class is already used.';
        TimeStep: Record "SSA Payment Step" temporary;
        Text002: Label 'The series'' nos must not be greater than 10.';
}
