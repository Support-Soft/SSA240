page 70507 "SSA Payment Report"
{
    Caption = 'Payment Report';
    Editable = false;
    PageType = List;
    SourceTable = "SSA Payment Status";
    SourceTableView = WHERE(ReportMenu = CONST(true));

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
                Caption = '&Print';
                Image = Print;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    PaymentLine: Record "SSA Payment Line";
                begin
                    PaymentLine.SetRange("Payment Class", "Payment Class");
                    PaymentLine.SetRange("Status No.", Line);
                    //REPORT.RUNMODAL(REPORT::"Payments Lists",TRUE,TRUE,PaymentLine);
                end;
            }
        }
    }
}

