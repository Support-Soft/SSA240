page 70517 "SSA Payment Steps List"
{
    Caption = 'Payment Steps List';
    PageType = List;
    SourceTable = "SSA Payment Step";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field("Payment Class"; "Payment Class")
                {
                    ApplicationArea = All;
                }
                field(Line; Line)
                {
                    ApplicationArea = All;
                }
                field(Name; Name)
                {
                    ApplicationArea = All;
                }
                field("Previous Status"; "Previous Status")
                {
                    ApplicationArea = All;
                }
                field("Next Status"; "Next Status")
                {
                    ApplicationArea = All;
                }
                field("Action Type"; "Action Type")
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

