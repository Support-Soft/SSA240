page 70506 "SSA Payment Status List"
{
    AutoSplitKey = true;
    Caption = 'Payment Status List';
    PageType = List;
    SourceTable = "SSA Payment Status";
    ApplicationArea = All;
    UsageCategory = Administration;
    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field(Name; Rec.Name)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Name field.';
                }
                field(Look; Rec.Look)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Look field.';
                }
                field(ReportMenu; Rec.ReportMenu)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Report field.';
                }
                field(RIB; Rec.RIB)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the RIB field.';
                }
                field("Acceptation Code"; Rec."Acceptation Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Acceptation Code field.';
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Amount field.';
                }
                field(Debit; Rec.Debit)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Debit field.';
                }
                field(Credit; Rec.Credit)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Credit field.';
                }
                field("Payment in progress"; Rec."Payment in progress")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Payment in progress field.';
                }
            }
        }
    }

    actions
    {
    }
}
