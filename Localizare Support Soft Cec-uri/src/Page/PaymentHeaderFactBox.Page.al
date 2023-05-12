page 70503 "SSA Payment Header FactBox"
{
    Caption = 'Payment Header FactBox';
    PageType = CardPart;
    SourceTable = "SSA Payment Line";

    layout
    {
        area(content)
        {
            field("No."; "No.")
            {
                ApplicationArea = All;
            }
            field("Line No."; "Line No.")
            {
                ApplicationArea = All;
            }
            field(BalanceLCY; BalanceLCY)
            {
                ApplicationArea = All;
                Caption = 'Balance (LCY)';
            }
            field(OutstandingInvoice; OutstandingInvoice)
            {
                ApplicationArea = All;
                Caption = 'Outstanding invoices';
            }
            field("Bank Account"; "Bank Account")
            {
                ApplicationArea = All;
            }
            field("Bank Account No."; "Bank Account No.")
            {
                ApplicationArea = All;
            }
            field("Applies-to Doc. Type"; "Applies-to Doc. Type")
            {
                ApplicationArea = All;
            }
            field("Applies-to Doc. No."; "Applies-to Doc. No.")
            {
                ApplicationArea = All;
            }
            field("External Document No."; "External Document No.")
            {
                ApplicationArea = All;
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
        case "Account Type" of
            "Account Type"::Vendor:
                begin
                    if Vendor.Get("Account No.") then begin
                        Vendor.CalcFields("Balance (LCY)", "Outstanding Invoices");
                        BalanceLCY := Vendor."Balance (LCY)";
                        OutstandingInvoice := Vendor."Outstanding Invoices";
                    end;
                end;
            "Account Type"::Customer:
                begin
                    if Customer.Get("Account No.") then begin
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

