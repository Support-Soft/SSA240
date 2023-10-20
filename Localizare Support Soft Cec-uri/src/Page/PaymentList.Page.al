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
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the No. field.';
                }
                field("Currency Code"; Rec."Currency Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Currency Code field.';
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Posting Date field.';
                }
                field("Payment Class"; Rec."Payment Class")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Payment Class field.';
                }
                field("Amount (LCY)"; Rec."Amount (LCY)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Total Amount (LCY) field.';
                }
                field("Suma Aplicata"; Rec."Suma Aplicata")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Suma Aplicata field.';
                }
                field("Status Name"; Rec."Status Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Status Name field.';
                }
                field("Payment Series"; Rec."Payment Series")
                {
                    ApplicationArea = All;
                    Editable = PaymentEditable;
                    ToolTip = 'Specifies the value of the Payment Series field.';
                }
                field("Payment Number"; Rec."Payment Number")
                {
                    ApplicationArea = All;
                    Editable = PaymentEditable;
                    ToolTip = 'Specifies the value of the Payment Number field.';
                }
                field("Vendor Name"; Rec."Vendor Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Vendor Name field.';
                }
                field("Customer Name"; Rec."Customer Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Customer Name field.';
                }
                field("Due Date"; Rec."Due Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Due Date field.';
                }
            }
        }
        area(factboxes)
        {
            part(Control1907959307; "SSA Payment Header FactBox")
            {
                ApplicationArea = All;
                SubPageLink = "No." = field("No.");
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
                ToolTip = 'Executes the Payments Lists action.';
            }
            action(Borderou)
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = "Report";
                ToolTip = 'Executes the Borderou action.';
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
        if not PaymentStatus.Get(Rec."Payment Class", Rec."Status No.") then
            clear(PaymentStep);
        PaymentEditable := PaymentStatus."Allow Edit Payment No.";
    end;

    var
        PaymentHeader: Record "SSA Payment Header";
        PaymentStep: Record "SSA Payment Step";

        PaymentEditable: Boolean;
}
