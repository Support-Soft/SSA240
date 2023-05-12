page 70518 "SSA Payment Step Ledger"
{
    Caption = 'Payment Step Ledger';
    PageType = Card;
    SourceTable = "SSA Payment Step Ledger";
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
                    ApplicationArea = All;
                    Enabled = false;
                }
                field(Line; Line)
                {
                    ApplicationArea = All;
                    Enabled = false;
                }
                field(Sign; Sign)
                {
                    ApplicationArea = All;
                    Enabled = SignEnable;
                }
                field(Description; Description)
                {
                    ApplicationArea = All;
                }
                field("Accounting Type"; "Accounting Type")
                {
                    ApplicationArea = All;
                    Enabled = "Accounting TypeEnable";

                    trigger OnValidate()
                    begin
                        DisableFields;
                    end;
                }
                field("Account Type"; "Account Type")
                {
                    ApplicationArea = All;
                    Enabled = "Account TypeEnable";

                    trigger OnValidate()
                    begin
                        DisableFields;
                    end;
                }
                field("Account No."; "Account No.")
                {
                    ApplicationArea = All;
                    Enabled = "Account No.Enable";

                    trigger OnValidate()
                    begin
                        DisableFields;
                    end;
                }
                field("Customer Posting Group"; "Customer Posting Group")
                {
                    ApplicationArea = All;
                    Enabled = "Customer Posting GroupEnable";

                    trigger OnValidate()
                    begin
                        DisableFields;
                    end;
                }
                field("Vendor Posting Group"; "Vendor Posting Group")
                {
                    ApplicationArea = All;
                    Enabled = "Vendor Posting GroupEnable";

                    trigger OnValidate()
                    begin
                        DisableFields;
                    end;
                }
                field(Root; Root)
                {
                    ApplicationArea = All;
                    Enabled = RootEnable;

                    trigger OnValidate()
                    begin
                        DisableFields;
                    end;
                }
                field("Memorize Entry"; "Memorize Entry")
                {
                    ApplicationArea = All;
                    trigger OnValidate()
                    begin
                        DisableFields;
                    end;
                }
                field(Application; Application)
                {
                    ApplicationArea = All;
                    Enabled = ApplicationEnable;

                    trigger OnValidate()
                    begin
                        DisableFields;
                    end;
                }
                field("Detail Level"; "Detail Level")
                {
                    ApplicationArea = All;
                    Enabled = "Detail LevelEnable";

                    trigger OnValidate()
                    begin
                        DisableFields;
                    end;
                }
                field("Document Type"; "Document Type")
                {
                    ApplicationArea = All;
                }
                field("Document No."; "Document No.")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        DisableFields;
    end;

    trigger OnInit()
    begin
        "Detail LevelEnable" := true;
        RootEnable := true;
        "Vendor Posting GroupEnable" := true;
        "Customer Posting GroupEnable" := true;
        "Account No.Enable" := true;
        "Account TypeEnable" := true;
        ApplicationEnable := true;
        SignEnable := true;
        "Accounting TypeEnable" := true;
    end;

    var
        [InDataSet]
        "Accounting TypeEnable": Boolean;
        [InDataSet]
        SignEnable: Boolean;
        [InDataSet]
        ApplicationEnable: Boolean;
        [InDataSet]
        "Account TypeEnable": Boolean;
        [InDataSet]
        "Account No.Enable": Boolean;
        [InDataSet]
        "Customer Posting GroupEnable": Boolean;
        [InDataSet]
        "Vendor Posting GroupEnable": Boolean;
        [InDataSet]
        RootEnable: Boolean;
        [InDataSet]
        "Detail LevelEnable": Boolean;

    procedure DisableFields()
    begin
        "Accounting TypeEnable" := true;
        SignEnable := true;
        ApplicationEnable := true;
        if "Accounting Type" = "Accounting Type"::"Below Account" then begin
            "Account TypeEnable" := true;
            "Account No.Enable" := true;
            if "Account Type" = "Account Type"::Customer then begin
                "Customer Posting GroupEnable" := true;
                "Vendor Posting GroupEnable" := false;
            end else
                if "Account Type" = "Account Type"::Vendor then begin
                    "Customer Posting GroupEnable" := false;
                    "Vendor Posting GroupEnable" := true;
                end else begin
                    "Customer Posting GroupEnable" := false;
                    "Vendor Posting GroupEnable" := false;
                end;
            RootEnable := false;
        end else begin
            "Account TypeEnable" := false;
            "Account No.Enable" := false;
            if "Accounting Type" in ["Accounting Type"::"G/L Account / Month",
                                   "Accounting Type"::"G/L Account / Week"] then begin
                RootEnable := true;
                "Customer Posting GroupEnable" := false;
                "Vendor Posting GroupEnable" := false;
            end else begin
                RootEnable := false;
                "Customer Posting GroupEnable" := true;
                "Vendor Posting GroupEnable" := true;
            end;
        end;
        if "Accounting Type" = "Accounting Type"::"Bal. Account Previous Entry" then begin
            "Customer Posting GroupEnable" := false;
            "Vendor Posting GroupEnable" := false;
        end;
        if ("Memorize Entry") or (Application <> Application::None) then begin
            "Detail Level" := "Detail Level"::Line;
            "Detail LevelEnable" := false;
        end else begin
            "Detail LevelEnable" := true;
        end;
    end;
}

