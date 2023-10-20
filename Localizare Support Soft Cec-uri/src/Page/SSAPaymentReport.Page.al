page 70507 "SSA Payment Report"
{
    Caption = 'Payment Report';
    Editable = false;
    PageType = List;
    SourceTable = "SSA Payment Status";
    SourceTableView = where(ReportMenu = const(true));
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
                Caption = '&Print';
                Image = Print;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Executes the &Print action.';
                trigger OnAction()
                var
                    PaymentLine: Record "SSA Payment Line";
                begin
                    PaymentLine.SetRange("Payment Class", Rec."Payment Class");
                    PaymentLine.SetRange("Status No.", Rec.Line);
                    //REPORT.RUNMODAL(REPORT::"Payments Lists",TRUE,TRUE,PaymentLine);
                end;
            }
        }
    }
}
