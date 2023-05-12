page 70514 "SSA Payment List"
{
    // SSM729 SSCAT 21.06.2018 Nr.crt.76-Limita valorica pentru instrumente de plata neincasate- fin

    Caption = 'Payment List';
    CardPageID = "SSA Payment Headers";
    Editable = false;
    PageType = List;
    SourceTable = "SSA Payment Header";
    UsageCategory = Lists;
    ApplicationArea = All;
    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field("No."; "No.")
                {
                    ApplicationArea = All;
                }
                field("Currency Code"; "Currency Code")
                {
                    ApplicationArea = All;
                }
                field("Posting Date"; "Posting Date")
                {
                    ApplicationArea = All;
                }
                field("Payment Class"; "Payment Class")
                {
                    ApplicationArea = All;
                }
                field("Amount (LCY)"; "Amount (LCY)")
                {
                    ApplicationArea = All;
                }
                field("Suma Aplicata"; "Suma Aplicata")
                {
                    ApplicationArea = All;
                }
                field("Status Name"; "Status Name")
                {
                    ApplicationArea = All;
                }
                field("Payment Series"; "Payment Series")
                {
                    ApplicationArea = All;
                    Editable = PaymentEditable;
                }
                field("Payment Number"; "Payment Number")
                {
                    ApplicationArea = All;
                    Editable = PaymentEditable;
                }
                field("Vendor Name"; "Vendor Name")
                {
                    ApplicationArea = All;
                }
                field("Customer Name"; "Customer Name")
                {
                    ApplicationArea = All;
                }
                field("Due Date"; "Due Date")
                {
                    ApplicationArea = All;
                }
            }
        }
        area(factboxes)
        {
            part(Control1907959307; "SSA Payment Header FactBox")
            {
                ApplicationArea = All;
                SubPageLink = "No." = FIELD("No.");
                Visible = true;
            }
        }
    }

    actions
    {
        area(reporting)
        {
            action("Payments Lists")
            {
                ApplicationArea = All;
                Caption = 'Payments Lists';
                Promoted = true;
                PromotedCategory = "Report";
                RunObject = Report "SSA Payment List";
            }
            action(Borderou)
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = "Report";

                trigger OnAction()
                begin

                    PaymentHeader.Reset;
                    REPORT.RunModal(45007702, true, false, PaymentHeader);
                end;
            }
        }
    }
    trigger OnAfterGetRecord()
    var
        PaymentStatus: Record "SSA Payment Status";
    begin
        if not PaymentStatus.Get("Payment Class", "Status No.") then
            clear(PaymentStep);
        PaymentEditable := PaymentStatus."Allow Edit Payment No.";
    end;

    var
        PaymentHeader: Record "SSA Payment Header";
        PaymentStep: Record "SSA Payment Step";
        [InDataSet]
        PaymentEditable: Boolean;

}

