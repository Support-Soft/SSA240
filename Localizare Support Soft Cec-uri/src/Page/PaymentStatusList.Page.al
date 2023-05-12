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
                field(Name; Name)
                {
                    ApplicationArea = All;
                }
                field(Look; Look)
                {
                    ApplicationArea = All;
                }
                field(ReportMenu; ReportMenu)
                {
                    ApplicationArea = All;
                }
                field(RIB; RIB)
                {
                    ApplicationArea = All;
                }
                field("Acceptation Code"; "Acceptation Code")
                {
                    ApplicationArea = All;
                }
                field(Amount; Amount)
                {
                    ApplicationArea = All;
                }
                field(Debit; Debit)
                {
                    ApplicationArea = All;
                }
                field(Credit; Credit)
                {
                    ApplicationArea = All;
                }
                field("Payment in progress"; "Payment in progress")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
    }
}

