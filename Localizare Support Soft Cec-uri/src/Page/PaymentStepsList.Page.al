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
                field("Payment Class"; Rec."Payment Class")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Payment Class field.';
                }
                field(Line; Rec.Line)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Line field.';
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Name field.';
                }
                field("Previous Status"; Rec."Previous Status")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Previous Status field.';
                }
                field("Next Status"; Rec."Next Status")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Next Status field.';
                }
                field("Action Type"; Rec."Action Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Action Type field.';
                }
            }
        }
    }

    actions
    {
    }
}
