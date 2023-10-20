page 70511 "SSA Payment Step Card"
{
    // SSM729 SSCAT 22.06.2018 Nr.crt.76-Limita valorica pentru instrumente de plata neincasate- fin

    Caption = 'Payment Step Card';
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = Card;
    RefreshOnActivate = true;
    SourceTable = "SSA Payment Step";
    ApplicationArea = All;
    UsageCategory = Administration;
    layout
    {
        area(content)
        {
            group(Control1)
            {
                ShowCaption = false;
                field("Payment Class"; Rec."Payment Class")
                {
                    Editable = false;
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Payment Class field.';
                }
                field(Line; Rec.Line)
                {
                    Editable = false;
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Line field.';
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Name field.';
                }
                field("Previous Status"; Rec."Previous Status")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Previous Status field.';
                    trigger OnValidate()
                    begin
                        Rec.CalcFields("Previous Status Name");
                    end;
                }
                field("Previous Status Name"; Rec."Previous Status Name")
                {
                    ApplicationArea = All;
                    DrillDown = false;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Previous Status Name field.';
                }
                field("Next Status"; Rec."Next Status")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Next Status field.';
                    trigger OnValidate()
                    begin
                        Rec.CalcFields("Next Status Name");
                    end;
                }
                field("Next Status Name"; Rec."Next Status Name")
                {
                    ApplicationArea = All;
                    DrillDown = false;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Next Status Name field.';
                }
                field("Action Type"; Rec."Action Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Action Type field.';
                    trigger OnValidate()
                    begin
                        DisableFields;
                    end;
                }
                field("Report No."; Rec."Report No.")
                {
                    ApplicationArea = All;
                    Enabled = "Report No.Enable";
                    ToolTip = 'Specifies the value of the Report No. field.';
                }
                field("Dataport No."; Rec."Dataport No.")
                {
                    ApplicationArea = All;
                    Enabled = "Dataport No.Enable";
                    ToolTip = 'Specifies the value of the Dataport No. field.';
                }
                field("Verify Lines RIB"; Rec."Verify Lines RIB")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Verify Lines RIB field.';
                }
                field("Verify Due Date"; Rec."Verify Due Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Verify Due Date field.';
                }
                field("Source Code"; Rec."Source Code")
                {
                    ApplicationArea = All;
                    Enabled = "Source CodeEnable";
                    ToolTip = 'Specifies the value of the Source Code field.';
                }
                field("Reason Code"; Rec."Reason Code")
                {
                    ApplicationArea = All;
                    Enabled = "Reason CodeEnable";
                    ToolTip = 'Specifies the value of the Reason Code field.';
                }
                field("Header Nos. Series"; Rec."Header Nos. Series")
                {
                    ApplicationArea = All;
                    Enabled = "Header Nos. SeriesEnable";
                    ToolTip = 'Specifies the value of the Header Nos. Series field.';
                }
                field(Correction; Rec.Correction)
                {
                    ApplicationArea = All;
                    Enabled = CorrectionEnable;
                    ToolTip = 'Specifies the value of the Correction field.';
                }
                field("Verify Header RIB"; Rec."Verify Header RIB")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Verify Header RIB field.';
                }
                field("Acceptation Code<>No"; Rec."Acceptation Code<>No")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Acceptation Code<>No field.';
                }
                field("Tip Detalii Aplicari"; Rec."Tip Detalii Aplicari")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Tip Detalii Aplicari field.';
                }
                field("Permite Reaplicari"; Rec."Permite Reaplicari")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Permite Reaplicari field.';
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(Ledger)
            {
                Caption = '&Ledger';
                Promoted = true;
                PromotedCategory = Process;
                RunObject = page "SSA Payment Step Ledger";
                RunPageLink = "Payment Class" = field("Payment Class"),
                              Line = field(Line);
                ToolTip = 'Executes the &Ledger action.';
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        DisableFields;
    end;

    trigger OnInit()
    begin
        CorrectionEnable := true;
        "Header Nos. SeriesEnable" := true;
        "Source CodeEnable" := true;
        "Reason CodeEnable" := true;
        "Dataport No.Enable" := true;
        "Report No.Enable" := true;
    end;

    var

        "Report No.Enable": Boolean;

        "Dataport No.Enable": Boolean;

        "Reason CodeEnable": Boolean;

        "Source CodeEnable": Boolean;

        "Header Nos. SeriesEnable": Boolean;

        CorrectionEnable: Boolean;

    procedure DisableFields()
    begin

        if Rec."Action Type" = Rec."Action Type"::None then begin
            "Report No.Enable" := false;
            "Dataport No.Enable" := false;
            "Reason CodeEnable" := false;
            "Source CodeEnable" := false;
            "Header Nos. SeriesEnable" := false;
            CorrectionEnable := false;
        end else
            if Rec."Action Type" = Rec."Action Type"::Ledger then begin
                "Report No.Enable" := false;
                "Dataport No.Enable" := false;
                "Reason CodeEnable" := true;
                "Source CodeEnable" := true;
                "Header Nos. SeriesEnable" := false;
                CorrectionEnable := true;
            end else
                if Rec."Action Type" = Rec."Action Type"::Report then begin
                    "Report No.Enable" := true;
                    "Dataport No.Enable" := false;
                    "Reason CodeEnable" := false;
                    "Source CodeEnable" := false;
                    "Header Nos. SeriesEnable" := false;
                    CorrectionEnable := false;
                end else
                    if Rec."Action Type" = Rec."Action Type"::File then begin
                        "Report No.Enable" := false;
                        "Dataport No.Enable" := true;
                        "Reason CodeEnable" := false;
                        "Source CodeEnable" := false;
                        "Header Nos. SeriesEnable" := false;
                        CorrectionEnable := false;
                    end else
                        if Rec."Action Type" = Rec."Action Type"::"Create new Document" then begin
                            "Report No.Enable" := false;
                            "Dataport No.Enable" := false;
                            "Reason CodeEnable" := false;
                            "Source CodeEnable" := false;
                            "Header Nos. SeriesEnable" := true;
                            CorrectionEnable := false;
                        end;
    end;
}
