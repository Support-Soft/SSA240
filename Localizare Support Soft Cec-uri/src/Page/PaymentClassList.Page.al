page 70504 "SSA Payment Class List"
{
    Caption = 'Payment Class List';
    Editable = false;
    PageType = List;
    SourceTable = "SSA Payment Class";
    SourceTableView = where(Enable = const(true));

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field("Code"; Rec.Code)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Code field.';
                }
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
    }
}
