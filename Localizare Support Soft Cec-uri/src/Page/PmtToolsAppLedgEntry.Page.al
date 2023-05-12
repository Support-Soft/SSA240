page 70501 "SSA Pmt. Tools App-Ledg. Entry"
{
    // SSM729 SSCAT 21.06.2018 Nr.crt.76-Limita valorica pentru instrumente de plata neincasate- fin

    Caption = 'Payment Tools App-Ledg. Entry';
    Editable = true;
    PageType = List;
    SourceTable = "SSA Pmt. Tools AppLedg. Entry";
    ApplicationArea = All;
    UsageCategory = Administration;
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = true;
    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Entry No."; "Entry No.")
                {
                    ApplicationArea = All;
                }
                field("Document Type"; "Document Type")
                {
                    ApplicationArea = All;
                }
                field("Document No."; "Document No.")
                {
                    ApplicationArea = All;
                }
                field(Amount; Amount)
                {
                    ApplicationArea = All;
                }
                field("Payment Document No."; "Payment Document No.")
                {
                    ApplicationArea = All;
                }
                field("Payment Document Line No."; "Payment Document Line No.")
                {
                    ApplicationArea = All;
                }
                field("Payment Series"; "Payment Series")
                {
                    ApplicationArea = All;
                }
                field("Payment No."; "Payment No.")
                {
                    ApplicationArea = All;
                }
                field("Source Type"; "Source Type")
                {
                    ApplicationArea = All;
                }
                field("Source No."; "Source No.")
                {
                    ApplicationArea = All;
                }
                field("Payment Class"; "Payment Class")
                {
                    ApplicationArea = All;
                }
                field("Status No."; "Status No.")
                {
                    ApplicationArea = All;
                }
                field("Status Name"; "Status Name")
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

