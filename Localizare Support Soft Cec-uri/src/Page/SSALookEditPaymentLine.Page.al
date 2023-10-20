page 70505 "SSA Look/Edit Payment Line"
{
    Caption = 'Look/Edit Payment Line';
    Editable = false;
    PageType = List;
    SourceTable = "SSA Payment Status";
    SourceTableView = where(Look = const(true));
    ApplicationArea = All;

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
            action(OK)
            {
                ApplicationArea = All;
                Caption = 'OK';
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Executes the OK action.';
                trigger OnAction()
                var
                    PaymentLine: Record "SSA Payment Line";
                    LinesList: Page "SSA Payment Lines List";
                begin
                    PaymentLine.SetRange("Payment Class", Rec."Payment Class");
                    PaymentLine.SetRange("Status No.", Rec.Line);
                    PaymentLine.SetFilter("Copied To No.", '=''''');
                    LinesList.SetTableView(PaymentLine);
                    /* PS12301 start deletion
                    LinesList.DeactivateOKButton;
                    PS12301 end deletion */
                    LinesList.RunModal;
                end;
            }
        }
    }
}
