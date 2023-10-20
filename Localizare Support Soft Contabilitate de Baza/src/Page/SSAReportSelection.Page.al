page 70014 "SSA Report Selection"
{
    Caption = 'Custom Report Selection';
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = "SSA Report Selections";

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field(Usage; Rec.Usage)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Usage field.';
                }
                field(Sequence; Rec.Sequence)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Sequence field.';
                }
                field("Report ID"; Rec."Report ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Report ID field.';
                }
                field("Report Caption"; Rec."Report Caption")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Report Caption field.';
                }
                field("Custom Report Layout Code"; Rec."Custom Report Layout Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Custom Report Layout Code field.';
                }
                field("Email Body Layout Code"; Rec."Email Body Layout Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Email Body Layout Code field.';
                }
                field("Email Body Layout Description"; Rec."Email Body Layout Description")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Email Body Layout Description field.';
                }
            }
        }
    }
}