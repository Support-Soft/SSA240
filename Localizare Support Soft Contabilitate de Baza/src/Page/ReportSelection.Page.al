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
                field(Usage; Usage)
                {
                    ApplicationArea = All;
                }
                field(Sequence; Sequence)
                {
                    ApplicationArea = All;
                }
                field("Report ID"; "Report ID")
                {
                    ApplicationArea = All;
                }
                field("Report Caption"; "Report Caption")
                {
                    ApplicationArea = All;
                }
                field("Custom Report Layout Code"; "Custom Report Layout Code")
                {
                    ApplicationArea = All;
                }
                field("Email Body Layout Code"; "Email Body Layout Code")
                {
                    ApplicationArea = All;
                }
                field("Email Body Layout Description"; "Email Body Layout Description")
                {
                    ApplicationArea = All;
                }
            }

        }
        area(Factboxes)
        {

        }
    }
}