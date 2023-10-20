page 70508 "SSA Payment Class"
{
    // SSM729 SSCAT 21.06.2018 Nr.crt.76-Limita valorica pentru instrumente de plata neincasate- fin

    Caption = 'Payment Class';
    PageType = List;
    SourceTable = "SSA Payment Class";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field(Enable; Rec.Enable)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Enable field.';
                }
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
                field("Header No. Series"; Rec."Header No. Series")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Header No. Series field.';
                }
                field("Line No. Series"; Rec."Line No. Series")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Line No. Series field.';
                }
                field(Suggestions; Rec.Suggestions)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Suggestions field.';
                }
                field("Payment Tools"; Rec."Payment Tools")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Payment Tools Customer field.';
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            group("F&unctions")
            {
                Caption = 'F&unctions';
                action("Duplicate parameter")
                {
                    ApplicationArea = All;
                    Caption = 'Duplicate parameter';
                    Promoted = true;
                    PromotedCategory = Process;
                    ToolTip = 'Executes the Duplicate parameter action.';
                    trigger OnAction()
                    var
                        PaymentClass: Record "SSA Payment Class";
                        DuplicateParameter: Report "SSA Duplicate parameter";
                    begin
                        if Rec.Code <> '' then begin
                            PaymentClass.SETRANGE(Code, Rec.Code);
                            DuplicateParameter.SETTABLEVIEW(PaymentClass);
                            DuplicateParameter.InitParameter(Rec.Code);
                            DuplicateParameter.RUNMODAL;
                        end;
                    end;
                }
            }
            action(Status)
            {
                ApplicationArea = All;
                Caption = 'St&atus';
                Promoted = true;
                PromotedCategory = Process;
                RunObject = page "SSA Payment Status";
                RunPageLink = "Payment Class" = field(Code);
                ToolTip = 'Executes the St&atus action.';
            }
            action(Steps)
            {
                ApplicationArea = All;
                Caption = 'Ste&ps';
                Promoted = true;
                PromotedCategory = Process;
                RunObject = page "SSA Payment Steps";
                RunPageLink = "Payment Class" = field(Code);
                ToolTip = 'Executes the Ste&ps action.';
            }
        }
    }
}
