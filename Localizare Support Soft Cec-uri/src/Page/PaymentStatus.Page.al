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
                field(Name; Name)
                {
                    ApplicationArea = All;
                }
                field(RIB; RIB)
                {
                    ApplicationArea = All;
                }
                field(Look; Look)
                {
                    ApplicationArea = All;
                }
                field(ReportMenu; ReportMenu)
                {
                    ApplicationArea = All;
                }
                field("Acceptation Code"; "Acceptation Code")
                {
                    ApplicationArea = All;
                }
                field(Amount; Amount)
                {
                    ApplicationArea = All;
                }
                field(Debit; Debit)
                {
                    ApplicationArea = All;
                }
                field(Credit; Credit)
                {
                    ApplicationArea = All;
                }
                field("Bank Account"; "Bank Account")
                {
                    ApplicationArea = All;
                }
                field("Payment in progress"; "Payment in progress")
                {
                    ApplicationArea = All;
                }
                field("Archiving authorized"; "Archiving authorized")
                {
                    ApplicationArea = All;
                }
                field("Payment Finished"; "Payment Finished")
                {
                    ApplicationArea = All;
                }
                field("Auto Archive"; "Auto Archive")
                {
                    ApplicationArea = All;
                }
                field("Canceled/Refused"; "Canceled/Refused")
                {
                    ApplicationArea = All;
                }
                field("Allow Edit Payment No."; "Allow Edit Payment No.")
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

