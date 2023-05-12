page 70510 "SSA Payment Steps"
{
    AutoSplitKey = true;
    Caption = 'Payment Step';
    CardPageID = "SSA Payment Step Card";
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
                field(Name; Name)
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
            action(Card)
            {
                ApplicationArea = All;
                Caption = '&Card';
                Image = EditLines;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page "SSA Payment Step Card";
                RunPageLink = "Payment Class" = FIELD("Payment Class"),
                              Line = FIELD(Line);
            }
        }
    }
}
