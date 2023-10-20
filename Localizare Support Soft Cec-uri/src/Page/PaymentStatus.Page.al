page 70509 "SSA Payment Status"
{
    // SSM729 SSCAT 22.06.2018 Nr.crt.76-Limita valorica pentru instrumente de plata neincasate- fin

    AutoSplitKey = true;
    Caption = 'Payment Status';
    DelayedInsert = true;
    PageType = List;
    SourceTable = "SSA Payment Status";
    ApplicationArea = All;
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field(Name; Rec.Name)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Name field.';
                }
                field(RIB; Rec.RIB)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the RIB field.';
                }
                field(Look; Rec.Look)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Look field.';
                }
                field(ReportMenu; Rec.ReportMenu)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Report field.';
                }
                field("Acceptation Code"; Rec."Acceptation Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Acceptation Code field.';
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Amount field.';
                }
                field(Debit; Rec.Debit)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Debit field.';
                }
                field(Credit; Rec.Credit)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Credit field.';
                }
                field("Bank Account"; Rec."Bank Account")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Bank Account field.';
                }
                field("Payment in progress"; Rec."Payment in progress")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Payment in progress field.';
                }
                field("Archiving authorized"; Rec."Archiving authorized")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Archiving authorized field.';
                }
                field("Payment Finished"; Rec."Payment Finished")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Payment Finished field.';
                }
                field("Auto Archive"; Rec."Auto Archive")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Auto Archive field.';
                }
                field("Canceled/Refused"; Rec."Canceled/Refused")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Canceled/Refused field.';
                }
                field("Allow Edit Payment No."; Rec."Allow Edit Payment No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Allow Edit Payment No. field.';
                }
            }
        }
    }

    actions
    {
    }
}
