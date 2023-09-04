page 72002 "SSAEDE-Documents Details List"
{
    Caption = 'E-Documents Details List';
    PageType = List;
    SourceTable = "SSAEDE-Documents Details";

    layout
    {
        area(Content)
        {
            repeater(Control1)
            {

                field("Line ID"; Rec."Line ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Line ID field.';
                }
                field(Note; Rec.Note)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Note field.';
                }
                field("Invoice Quantity"; Rec."Invoice Quantity")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Invoice Quantity field.';
                }
                field("Unit Code"; Rec."Unit Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Unit Code field.';
                }
                field("Line Amount"; Rec."Line Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Line Amount field.';
                }
                field("Currency ID"; Rec."Currency ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Currency ID field.';
                }
                field("Item Description"; Rec."Item Description")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Item Description field.';
                }
                field("Item Name"; Rec."Item Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Item Name field.';
                }
                field("ClassifiedTaxCategory ID"; Rec."ClassifiedTaxCategory ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the ClassifiedTaxCategory ID field.';
                }
                field("ClassifiedTaxCategory Percent"; Rec."ClassifiedTaxCategory Percent")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the ClassifiedTaxCategory Percent field.';
                }
                field("TaxScheme ID"; Rec."TaxScheme ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the ClassifiedTaxCategory TaxScheme ID field.';
                }
                field("Price Amount"; Rec."Price Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Price Amount field.';
                }
                field("Price Currency ID"; Rec."Price Currency ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Price Currency ID field.';
                }
                field("NAV Type"; Rec."NAV Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the NAV Type field.';
                }
                field("NAV No."; Rec."NAV No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the NAV No. field.';
                }
            }
        }
    }


    actions
    {
        area(Processing)
        {
            action(ProcessInvoice)
            {
                Caption = 'Process Invoice';
                Promoted = true;
                PromotedCategory = Process;
                ApplicationArea = All;
                Image = Invoice;
                trigger OnAction()
                var
                    EFTEntries: Record "SSAEDE-Documents Log Entry";
                    ProcessEFT: Codeunit "SSAEDProcess Import E-Doc";
                begin
                    EFTEntries.GET(Rec."Log Entry No.");
                    ProcessEFT.ProcessPurchInvoice(EFTEntries);
                end;
            }
        }
    }

}