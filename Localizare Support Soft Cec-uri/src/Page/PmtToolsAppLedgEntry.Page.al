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
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Entry No. field.';
                }
                field("Document Type"; Rec."Document Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Document Type field.';
                }
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Document No. field.';
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Amount field.';
                }
                field("Payment Document No."; Rec."Payment Document No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Payment Document No. field.';
                }
                field("Payment Document Line No."; Rec."Payment Document Line No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Payment Document Line No. field.';
                }
                field("Payment Series"; Rec."Payment Series")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Payment Series field.';
                }
                field("Payment No."; Rec."Payment No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Payment No. field.';
                }
                field("Source Type"; Rec."Source Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Source Type field.';
                }
                field("Source No."; Rec."Source No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Source No. field.';
                }
                field("Payment Class"; Rec."Payment Class")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Payment Class field.';
                }
                field("Status No."; Rec."Status No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Status field.';
                }
                field("Status Name"; Rec."Status Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Status Name field.';
                }
            }
        }
    }

    actions
    {
    }
}
