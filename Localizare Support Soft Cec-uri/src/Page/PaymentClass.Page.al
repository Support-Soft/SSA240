page 70508 "SSA Payment Class"
{
    // SSM729 SSCAT 21.06.2018 Nr.crt.76-Limita valorica pentru instrumente de plata neincasate- fin

    Caption = 'Payment Class';
    PageType = List;
    SourceTable = "SSA Payment Class";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field(Enable; Enable)
                {
                    ApplicationArea = All;
                }
                field("Code"; Code)
                {
                    ApplicationArea = All;
                }
                field(Name; Name)
                {
                    ApplicationArea = All;
                }
                field("Header No. Series"; "Header No. Series")
                {
                    ApplicationArea = All;
                }
                field("Line No. Series"; "Line No. Series")
                {
                    ApplicationArea = All;
                }
                field(Suggestions; Suggestions)
                {
                    ApplicationArea = All;
                }
                field("Payment Tools"; "Payment Tools")
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
            group("F&unctions")
            {
                Caption = 'F&unctions';
                action("Duplicate parameter")
                {
                    ApplicationArea = All;
                    Caption = 'Duplicate parameter';
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    var
                        PaymentClass: Record "SSA Payment Class";
                        DuplicateParameter: Report "SSA Duplicate parameter";
                    begin
                        if Code <> '' then begin
                            PaymentClass.SETRANGE(Code, Code);
                            DuplicateParameter.SETTABLEVIEW(PaymentClass);
                            DuplicateParameter.InitParameter(Code);
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
                RunObject = Page "SSA Payment Status";
                RunPageLink = "Payment Class" = field(Code);
            }
            action(Steps)
            {
                ApplicationArea = All;
                Caption = 'Ste&ps';
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page "SSA Payment Steps";
                RunPageLink = "Payment Class" = field(Code);
            }
        }
    }
}

