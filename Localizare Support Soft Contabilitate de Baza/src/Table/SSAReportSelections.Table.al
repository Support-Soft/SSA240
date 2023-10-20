table 70005 "SSA Report Selections"
{
    // SSA937 SSCAT 16.06.2019 3.Funct. Bonuri de consum-consum intern

    Caption = 'Report Selections';
    DataClassification = CustomerContent;

    fields
    {
        field(1; Usage; Option)
        {
            Caption = 'Usage';
            OptionCaption = ' ,P.I.Cons';
            OptionMembers = " ","P.I.Cons";
        }
        field(2; Sequence; Code[10])
        {
            Caption = 'Sequence';
            Numeric = true;
        }
        field(3; "Report ID"; Integer)
        {
            Caption = 'Report ID';
            TableRelation = AllObjWithCaption."Object ID" where("Object Type" = const(Report));

            trigger OnValidate()
            begin
                CalcFields("Report Caption");
                Validate("Use for Email Body", false);
            end;
        }
        field(4; "Report Caption"; Text[250])
        {
            CalcFormula = lookup(AllObjWithCaption."Object Caption" where("Object Type" = const(Report),
                                                                           "Object ID" = field("Report ID")));
            Caption = 'Report Caption';
            Editable = false;
            FieldClass = FlowField;
        }
        field(7; "Custom Report Layout Code"; Code[20])
        {
            Caption = 'Custom Report Layout Code';
            Editable = false;
            TableRelation = "Custom Report Layout".Code where(Code = field("Custom Report Layout Code"));
        }
        field(19; "Use for Email Attachment"; Boolean)
        {
            Caption = 'Use for Email Attachment';
            InitValue = true;

            trigger OnValidate()
            begin
                if not "Use for Email Body" then
                    Validate("Email Body Layout Code", '');
            end;
        }
        field(20; "Use for Email Body"; Boolean)
        {
            Caption = 'Use for Email Body';

            trigger OnValidate()
            begin
                if not "Use for Email Body" then
                    Validate("Email Body Layout Code", '');
            end;
        }
        field(21; "Email Body Layout Code"; Code[20])
        {
            Caption = 'Email Body Layout Code';
            TableRelation = if ("Email Body Layout Type" = const("Custom Report Layout")) "Custom Report Layout".Code where(Code = field("Email Body Layout Code"),
                                                                                                                           "Report ID" = field("Report ID"))
            else
            if ("Email Body Layout Type" = const("HTML Layout")) "O365 HTML Template".Code;

            trigger OnValidate()
            begin
                if "Email Body Layout Code" <> '' then
                    TestField("Use for Email Body", true);
                CalcFields("Email Body Layout Description");
            end;
        }
        field(22; "Email Body Layout Description"; Text[250])
        {
            CalcFormula = lookup("Custom Report Layout".Description where(Code = field("Email Body Layout Code")));
            Caption = 'Email Body Layout Description';
            Editable = false;
            FieldClass = FlowField;

            trigger OnLookup()
            var
                CustomReportLayout: Record "Custom Report Layout";
            begin
                if "Email Body Layout Type" = "Email Body Layout Type"::"Custom Report Layout" then
                    if CustomReportLayout.LookupLayoutOK("Report ID") then
                        Validate("Email Body Layout Code", CustomReportLayout.Code);
            end;
        }
        field(25; "Email Body Layout Type"; Option)
        {
            Caption = 'Email Body Layout Type';
            OptionCaption = 'Custom Report Layout,HTML Layout';
            OptionMembers = "Custom Report Layout","HTML Layout";
        }
    }

    keys
    {
        key(Key1; Usage, Sequence)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; Usage, Sequence)
        {
        }
    }

    trigger OnInsert()
    begin
        TestField("Report ID");
    end;

    trigger OnModify()
    begin
        TestField("Report ID");
    end;

    var
        SSAReportSelection2: Record "SSA Report Selections";

    procedure NewRecord()
    begin
        SSAReportSelection2.SetRange(Usage, Usage);
        if SSAReportSelection2.FindLast() and (SSAReportSelection2.Sequence <> '') then
            Sequence := IncStr(SSAReportSelection2.Sequence)
        else
            Sequence := '1';
    end;
}
