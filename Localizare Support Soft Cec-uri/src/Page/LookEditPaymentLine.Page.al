page 70505 "SSA Look/Edit Payment Line"
{
    Caption = 'Look/Edit Payment Line';
    Editable = false;
    PageType = List;
    SourceTable = "SSA Payment Status";
    SourceTableView = WHERE(Look = CONST(true));

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
            action(OK)
            {
                ApplicationArea = All;
                Caption = 'OK';
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    PaymentLine: Record "SSA Payment Line";
                    LinesList: Page "SSA Payment Lines List";
                begin
                    PaymentLine.SetRange("Payment Class", "Payment Class");
                    PaymentLine.SetRange("Status No.", Line);
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

