page 70519 "SSA Payment Addresses"
{
    Caption = 'Payment Address';
    DataCaptionExpression = Legend;
    PageType = List;
    SourceTable = "SSA Payment Address";

    layout
    {
        area(content)
        {
            repeater(Control1120000)
            {
                ShowCaption = false;
                field("Code"; Code)
                {
                    ApplicationArea = All;
                }
                field("Default value"; "Default value")
                {
                    ApplicationArea = All;
                }
                field(Name; Name)
                {
                    ApplicationArea = All;
                }
                field("Search Name"; "Search Name")
                {
                    ApplicationArea = All;
                }
                field("Name 2"; "Name 2")
                {
                    ApplicationArea = All;
                }
                field(Address; Address)
                {
                    ApplicationArea = All;
                }
                field("Address 2"; "Address 2")
                {
                    ApplicationArea = All;
                }
                field("Post Code"; "Post Code")
                {
                    ApplicationArea = All;
                }
                field(City; City)
                {
                    ApplicationArea = All;
                }
                field(Contact; Contact)
                {
                    ApplicationArea = All;
                }
                field("Country/Region Code"; "Country/Region Code")
                {
                    ApplicationArea = All;
                }
                field(County; County)
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        OnAfterGetCurrRecordTrigger();
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        OnAfterGetCurrRecordTrigger();
    end;

    var
        Legend: Text[250];
        Text001: Label 'Customer';
        Text002: Label 'Vendor';
        Cust: Record Customer;
        Vend: Record Vendor;

    local procedure OnAfterGetCurrRecordTrigger()
    begin
        xRec := Rec;
        if "Account Type" = "Account Type"::Customer then begin
            Cust.Get("Account No.");
            Legend := Text001 + ' ' + Format("Account No.") + ' ' + Cust.Name;
        end else begin
            Vend.Get("Account No.");
            Legend := Text002 + ' ' + Format("Account No.") + ' ' + Vend.Name;
        end;
    end;
}

