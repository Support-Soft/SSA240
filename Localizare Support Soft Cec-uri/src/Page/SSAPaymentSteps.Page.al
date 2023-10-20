page 70510 "SSA Payment Steps"
{
    AutoSplitKey = true;
    Caption = 'Payment Step';
    CardPageId = "SSA Payment Step Card";
    DataCaptionFields = "Payment Class";
    DelayedInsert = true;
    PageType = List;
    SourceTable = "SSA Payment Step";
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
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(Card)
            {
                ApplicationArea = All;
                Caption = '&Card';
                Image = EditLines;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = page "SSA Payment Step Card";
                RunPageLink = "Payment Class" = field("Payment Class"),
                              Line = field(Line);
                ToolTip = 'Executes the &Card action.';
            }
        }
    }
}
