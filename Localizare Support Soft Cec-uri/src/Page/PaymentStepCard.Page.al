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
                field("Payment Class"; "Payment Class")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field(Line; Line)
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field(Name; Name)
                {
                    ApplicationArea = All;
                }
                field("Previous Status"; "Previous Status")
                {
                    ApplicationArea = All;
                    trigger OnValidate()
                    begin
                        CalcFields("Previous Status Name");
                    end;
                }
                field("Previous Status Name"; "Previous Status Name")
                {
                    ApplicationArea = All;
                    DrillDown = false;
                    Editable = false;
                }
                field("Next Status"; "Next Status")
                {
                    ApplicationArea = All;
                    trigger OnValidate()
                    begin
                        CalcFields("Next Status Name");
                    end;
                }
                field("Next Status Name"; "Next Status Name")
                {
                    ApplicationArea = All;
                    DrillDown = false;
                    Editable = false;
                }
                field("Action Type"; "Action Type")
                {
                    ApplicationArea = All;
                    trigger OnValidate()
                    begin
                        DisableFields;
                    end;
                }
                field("Report No."; "Report No.")
                {
                    ApplicationArea = All;
                    Enabled = "Report No.Enable";
                }
                field("Dataport No."; "Dataport No.")
                {
                    ApplicationArea = All;
                    Enabled = "Dataport No.Enable";
                }
                field("Verify Lines RIB"; "Verify Lines RIB")
                {
                    ApplicationArea = All;
                }
                field("Verify Due Date"; "Verify Due Date")
                {
                    ApplicationArea = All;
                }
                field("Source Code"; "Source Code")
                {
                    ApplicationArea = All;
                    Enabled = "Source CodeEnable";
                }
                field("Reason Code"; "Reason Code")
                {
                    ApplicationArea = All;
                    Enabled = "Reason CodeEnable";
                }
                field("Header Nos. Series"; "Header Nos. Series")
                {
                    ApplicationArea = All;
                    Enabled = "Header Nos. SeriesEnable";
                }
                field(Correction; Correction)
                {
                    ApplicationArea = All;
                    Enabled = CorrectionEnable;
                }
                field("Verify Header RIB"; "Verify Header RIB")
                {
                    ApplicationArea = All;
                }
                field("Acceptation Code<>No"; "Acceptation Code<>No")
                {
                    ApplicationArea = All;
                }
                field("Tip Detalii Aplicari"; "Tip Detalii Aplicari")
                {
                    ApplicationArea = All;
                }
                field("Permite Reaplicari"; "Permite Reaplicari")
                {
                    ApplicationArea = All;
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
                RunObject = Page "SSA Payment Step Ledger";
                RunPageLink = "Payment Class" = FIELD("Payment Class"),
                              Line = FIELD(Line);
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
        [InDataSet]
        "Report No.Enable": Boolean;
        [InDataSet]
        "Dataport No.Enable": Boolean;
        [InDataSet]
        "Reason CodeEnable": Boolean;
        [InDataSet]
        "Source CodeEnable": Boolean;
        [InDataSet]
        "Header Nos. SeriesEnable": Boolean;
        [InDataSet]
        CorrectionEnable: Boolean;

    procedure DisableFields()
    begin

        if "Action Type" = "Action Type"::None then begin
            "Report No.Enable" := false;
            "Dataport No.Enable" := false;
            "Reason CodeEnable" := false;
            "Source CodeEnable" := false;
            "Header Nos. SeriesEnable" := false;
            CorrectionEnable := false;
        end else
            if "Action Type" = "Action Type"::Ledger then begin
                "Report No.Enable" := false;
                "Dataport No.Enable" := false;
                "Reason CodeEnable" := true;
                "Source CodeEnable" := true;
                "Header Nos. SeriesEnable" := false;
                CorrectionEnable := true;
            end else
                if "Action Type" = "Action Type"::Report then begin
                    "Report No.Enable" := true;
                    "Dataport No.Enable" := false;
                    "Reason CodeEnable" := false;
                    "Source CodeEnable" := false;
                    "Header Nos. SeriesEnable" := false;
                    CorrectionEnable := false;
                end else
                    if "Action Type" = "Action Type"::File then begin
                        "Report No.Enable" := false;
                        "Dataport No.Enable" := true;
                        "Reason CodeEnable" := false;
                        "Source CodeEnable" := false;
                        "Header Nos. SeriesEnable" := false;
                        CorrectionEnable := false;
                    end else
                        if "Action Type" = "Action Type"::"Create new Document" then begin
                            "Report No.Enable" := false;
                            "Dataport No.Enable" := false;
                            "Reason CodeEnable" := false;
                            "Source CodeEnable" := false;
                            "Header Nos. SeriesEnable" := true;
                            CorrectionEnable := false;
                        end;
    end;
}

