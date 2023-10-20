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
                field("Payment Class"; Rec."Payment Class")
                {
                    ApplicationArea = All;
                    Enabled = false;
                    ToolTip = 'Specifies the value of the Payment Class field.';
                }
                field(Line; Rec.Line)
                {
                    ApplicationArea = All;
                    Enabled = false;
                    ToolTip = 'Specifies the value of the Line field.';
                }
                field(Sign; Rec.Sign)
                {
                    ApplicationArea = All;
                    Enabled = SignEnable;
                    ToolTip = 'Specifies the value of the Sign field.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Description field.';
                }
                field("Accounting Type"; Rec."Accounting Type")
                {
                    ApplicationArea = All;
                    Enabled = "Accounting TypeEnable";
                    ToolTip = 'Specifies the value of the Accounting Type field.';
                    trigger OnValidate()
                    begin
                        DisableFields;
                    end;
                }
                field("Account Type"; Rec."Account Type")
                {
                    ApplicationArea = All;
                    Enabled = "Account TypeEnable";
                    ToolTip = 'Specifies the value of the Account Type field.';
                    trigger OnValidate()
                    begin
                        DisableFields;
                    end;
                }
                field("Account No."; Rec."Account No.")
                {
                    ApplicationArea = All;
                    Enabled = "Account No.Enable";
                    ToolTip = 'Specifies the value of the Account No. field.';
                    trigger OnValidate()
                    begin
                        DisableFields;
                    end;
                }
                field("Customer Posting Group"; Rec."Customer Posting Group")
                {
                    ApplicationArea = All;
                    Enabled = "Customer Posting GroupEnable";
                    ToolTip = 'Specifies the value of the Customer Posting Group field.';
                    trigger OnValidate()
                    begin
                        DisableFields;
                    end;
                }
                field("Vendor Posting Group"; Rec."Vendor Posting Group")
                {
                    ApplicationArea = All;
                    Enabled = "Vendor Posting GroupEnable";
                    ToolTip = 'Specifies the value of the Vendor Posting Group field.';
                    trigger OnValidate()
                    begin
                        DisableFields;
                    end;
                }
                field(Root; Rec.Root)
                {
                    ApplicationArea = All;
                    Enabled = RootEnable;
                    ToolTip = 'Specifies the value of the Root field.';
                    trigger OnValidate()
                    begin
                        DisableFields;
                    end;
                }
                field("Memorize Entry"; Rec."Memorize Entry")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Memorize Entry field.';
                    trigger OnValidate()
                    begin
                        DisableFields;
                    end;
                }
                field(Application; Rec.Application)
                {
                    ApplicationArea = All;
                    Enabled = ApplicationEnable;
                    ToolTip = 'Specifies the value of the Application field.';
                    trigger OnValidate()
                    begin
                        DisableFields;
                    end;
                }
                field("Detail Level"; Rec."Detail Level")
                {
                    ApplicationArea = All;
                    Enabled = "Detail LevelEnable";
                    ToolTip = 'Specifies the value of the Detail Level field.';
                    trigger OnValidate()
                    begin
                        DisableFields;
                    end;
                }
                field("Document Type"; Rec."Document Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Document Type field.';
                }
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Document No. field.';
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

        "Accounting TypeEnable": Boolean;

        SignEnable: Boolean;

        ApplicationEnable: Boolean;

        "Account TypeEnable": Boolean;

        "Account No.Enable": Boolean;

        "Customer Posting GroupEnable": Boolean;

        "Vendor Posting GroupEnable": Boolean;

        RootEnable: Boolean;

        "Detail LevelEnable": Boolean;

    procedure DisableFields()
    begin
        "Accounting TypeEnable" := true;
        SignEnable := true;
        ApplicationEnable := true;
        if Rec."Accounting Type" = Rec."Accounting Type"::"Below Account" then begin
            "Account TypeEnable" := true;
            "Account No.Enable" := true;
            if Rec."Account Type" = Rec."Account Type"::Customer then begin
                "Customer Posting GroupEnable" := true;
                "Vendor Posting GroupEnable" := false;
            end else
                if Rec."Account Type" = Rec."Account Type"::Vendor then begin
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
            if Rec."Accounting Type" in [Rec."Accounting Type"::"G/L Account / Month",
                                   Rec."Accounting Type"::"G/L Account / Week"] then begin
                RootEnable := true;
                "Customer Posting GroupEnable" := false;
                "Vendor Posting GroupEnable" := false;
            end else begin
                RootEnable := false;
                "Customer Posting GroupEnable" := true;
                "Vendor Posting GroupEnable" := true;
            end;
        end;
        if Rec."Accounting Type" = Rec."Accounting Type"::"Bal. Account Previous Entry" then begin
            "Customer Posting GroupEnable" := false;
            "Vendor Posting GroupEnable" := false;
        end;
        if (Rec."Memorize Entry") or (Rec.Application <> Rec.Application::None) then begin
            Rec."Detail Level" := Rec."Detail Level"::Line;
            "Detail LevelEnable" := false;
        end else begin
            "Detail LevelEnable" := true;
        end;
    end;
}
