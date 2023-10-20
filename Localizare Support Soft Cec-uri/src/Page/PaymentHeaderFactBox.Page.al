page 70503 "SSA Payment Header FactBox"
{
    Caption = 'Payment Header FactBox';
    PageType = CardPart;
    SourceTable = "SSA Payment Line";

    layout
    {
        area(content)
        {
            field("No."; Rec."No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the No. field.';
            }
            field("Line No."; Rec."Line No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Line No. field.';
            }
            field(BalanceLCY; BalanceLCY)
            {
                ApplicationArea = All;
                Caption = 'Balance (LCY)';
                ToolTip = 'Specifies the value of the Balance (LCY) field.';
            }
            field(OutstandingInvoice; OutstandingInvoice)
            {
                ApplicationArea = All;
                Caption = 'Outstanding invoices';
                ToolTip = 'Specifies the value of the Outstanding invoices field.';
            }
            field("Bank Account"; Rec."Bank Account")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Bank Account field.';
            }
            field("Bank Account No."; Rec."Bank Account No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Bank Account No. field.';
            }
            field("Applies-to Doc. Type"; Rec."Applies-to Doc. Type")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Applies-to Doc. Type field.';
            }
            field("Applies-to Doc. No."; Rec."Applies-to Doc. No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Applies-to Doc. No. field.';
            }
            field("External Document No."; Rec."External Document No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the External Document No. field.';
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        CalcBalance;
        OnAfterGetCurrRecordTrigger();
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        OnAfterGetCurrRecordTrigger();
    end;

    trigger OnOpenPage()
    begin
        CalcBalance;
    end;

    var
        BalanceLCY: Decimal;
        OutstandingInvoice: Decimal;

    procedure CalcBalance()
    var
        Customer: Record Customer;
        Vendor: Record Vendor;
    begin
        case Rec."Account Type" of
            Rec."Account Type"::Vendor:
                begin
                    if Vendor.Get(Rec."Account No.") then begin
                        Vendor.CalcFields("Balance (LCY)", "Outstanding Invoices");
                        BalanceLCY := Vendor."Balance (LCY)";
                        OutstandingInvoice := Vendor."Outstanding Invoices";
                    end;
                end;
            Rec."Account Type"::Customer:
                begin
                    if Customer.Get(Rec."Account No.") then begin
                        Customer.CalcFields("Balance (LCY)", "Outstanding Invoices");
                        BalanceLCY := Customer."Balance (LCY)";
                        OutstandingInvoice := Customer."Outstanding Invoices";
                    end;
                end;
        end;
    end;

    local procedure OnAfterGetCurrRecordTrigger()
    begin
        xRec := Rec;
        CalcBalance;
    end;
}
