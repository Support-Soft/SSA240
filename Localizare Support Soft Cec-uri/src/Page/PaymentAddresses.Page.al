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
                field("Code"; Rec.Code)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Code field.';
                }
                field("Default value"; Rec."Default value")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Default value field.';
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Name field.';
                }
                field("Search Name"; Rec."Search Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Search Name field.';
                }
                field("Name 2"; Rec."Name 2")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Name 2 field.';
                }
                field(Address; Rec.Address)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Address field.';
                }
                field("Address 2"; Rec."Address 2")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Address 2 field.';
                }
                field("Post Code"; Rec."Post Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Post Code field.';
                }
                field(City; Rec.City)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the City field.';
                }
                field(Contact; Rec.Contact)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Contact field.';
                }
                field("Country/Region Code"; Rec."Country/Region Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Country/Region Code field.';
                }
                field(County; Rec.County)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the County field.';
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
        if Rec."Account Type" = Rec."Account Type"::Customer then begin
            Cust.Get(Rec."Account No.");
            Legend := Text001 + ' ' + Format(Rec."Account No.") + ' ' + Cust.Name;
        end else begin
            Vend.Get(Rec."Account No.");
            Legend := Text002 + ' ' + Format(Rec."Account No.") + ' ' + Vend.Name;
        end;
    end;
}
