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
                field("Code"; Code)
                {
                    ApplicationArea = All;
                }
                field(Name; Name)
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

