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
                field("Status Name"; "Status Name")
                {
                    ApplicationArea = All;
                }
                field("Document Date"; "Document Date")
                {
                    ApplicationArea = All;
                }
                field(Amount; Amount)
                {
                    ApplicationArea = All;
                }
                field("Payment Series"; "Payment Series")
                {
                    ApplicationArea = All;
                }
                field("Payment Number"; "Payment Number")
                {
                    ApplicationArea = All;
                }
                field("Suma Aplicata"; "Suma Aplicata")
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

