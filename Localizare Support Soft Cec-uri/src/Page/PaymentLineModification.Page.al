page 70515 "SSA Payment Line Modification"
{
    Caption = 'Payment Line Modification';
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = Card;
    RefreshOnActivate = true;
    SourceTable = "SSA Payment Line";

    layout
    {
        area(content)
        {
            group(Control1)
            {
                ShowCaption = false;
                field("External Document No."; "External Document No.")
                {
                    ApplicationArea = All;
                }
                field("Drawee Reference"; "Drawee Reference")
                {
                    ApplicationArea = All;
                }
                field("Due Date"; "Due Date")
                {
                    ApplicationArea = All;
                }
                field("Acceptation Code"; "Acceptation Code")
                {
                    ApplicationArea = All;
                }
                field("Bank Account"; "Bank Account")
                {
                    ApplicationArea = All;
                }
                field("Bank Branch No."; "Bank Branch No.")
                {
                    ApplicationArea = All;
                }
                field("Agency Code"; "Agency Code")
                {
                    ApplicationArea = All;
                }
                field("Bank Account No."; "Bank Account No.")
                {
                    ApplicationArea = All;
                }
                field("RIB Key"; "RIB Key")
                {
                    ApplicationArea = All;
                }
                field("RIB Checked"; "RIB Checked")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnInit()
    begin
        CurrPage.LookupMode := true;
    end;
}

