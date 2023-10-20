page 70523 "SSA Payment Archive List"
{
    Caption = 'Payment List Archive';
    CardPageID = "SSA Payment Headers Archive";
    Editable = false;
    PageType = List;
    SourceTable = "SSA Payment Header Archive";
    UsageCategory = Lists;
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
                field("Status Name"; Rec."Status Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Status Name field.';
                }
                field("Document Date"; Rec."Document Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Document Date field.';
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Amount field.';
                }
                field("Payment Series"; Rec."Payment Series")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Payment Series field.';
                }
                field("Payment Number"; Rec."Payment Number")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Payment Number field.';
                }
                field("Suma Aplicata"; Rec."Suma Aplicata")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Suma Aplicata field.';
                }
            }
        }
    }

    actions
    {
    }
}
