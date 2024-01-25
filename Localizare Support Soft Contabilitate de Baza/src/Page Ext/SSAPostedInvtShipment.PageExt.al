pageextension 70073 "SSA Posted Invt. Shipment" extends "Posted Invt. Shipment"
{
    layout
    {
        addafter("No.")
        {
            group("SSA Sell-to")
            {
                Caption = 'Sell-to';
                Editable = false;

                field("SSA Sell-to Customer No."; Rec."SSA Sell-to Customer No.")
                {
                    ApplicationArea = All;
                    Caption = 'Customer No.';
                    Importance = Additional;
                    NotBlank = true;
                    ToolTip = 'Specifies the number of the customer who will receive the products and be billed by default.';
                }
                field("SSA Sell-to Customer Name"; Rec."SSA Sell-to Customer Name")
                {
                    ApplicationArea = All;
                    Caption = 'Customer Name';
                    ShowMandatory = true;
                    ToolTip = 'Specifies the name of the customer who will receive the products and be billed by default.';
                    AboutTitle = 'Who are you selling to?';
                    AboutText = 'You can choose existing customers, or add new customers when you create orders. Orders can automatically choose special prices and discounts that you have set for each customer.';
                }
                field("SSA Sell-to Address"; Rec."SSA Sell-to Address")
                {
                    ApplicationArea = All;
                    Caption = 'Address';
                    Importance = Additional;
                    QuickEntry = false;
                    ToolTip = 'Specifies the address where the customer is located.';
                }
                field("SSA Sell-to Address 2"; Rec."SSA Sell-to Address 2")
                {
                    ApplicationArea = All;
                    Caption = 'Address 2';
                    Importance = Additional;
                    QuickEntry = false;
                    ToolTip = 'Specifies additional address information.';
                }
                field("SSA Sell-to City"; Rec."SSA Sell-to City")
                {
                    ApplicationArea = All;
                    Caption = 'City';
                    Importance = Additional;
                    QuickEntry = false;
                    ToolTip = 'Specifies the city of the customer on the sales document.';
                }
                group("SSA Control123")
                {
                    ShowCaption = false;
                    Visible = IsSellToCountyVisible;
                    field("SSA Sell-to County"; Rec."SSA Sell-to County")
                    {
                        ApplicationArea = All;
                        Caption = 'County';
                        Importance = Additional;
                        QuickEntry = false;
                        ToolTip = 'Specifies the state, province or county of the address.';
                    }
                }
                field("SSA Sell-to Post Code"; Rec."SSA Sell-to Post Code")
                {
                    ApplicationArea = All;
                    Caption = 'Post Code';
                    Importance = Additional;
                    QuickEntry = false;
                    ToolTip = 'Specifies the postal code.';
                }
                field("SSA Sell-to Country/Region Code"; Rec."SSA Sell-to Country/Reg Code")
                {
                    ApplicationArea = All;
                    Caption = 'Country/Region Code';
                    Importance = Additional;
                    QuickEntry = false;
                    ToolTip = 'Specifies the country or region of the address.';
                }
                field("SSA Sell-to Contact No."; Rec."SSA Sell-to Contact No.")
                {
                    ApplicationArea = All;
                    Caption = 'Contact No.';
                    Importance = Additional;
                    ToolTip = 'Specifies the number of the contact person that the sales document will be sent to.';
                }
                field("SSA Sell-to Phone No."; Rec."SSA Sell-to Phone No.")
                {
                    ApplicationArea = All;
                    Caption = 'Phone No.';
                    Importance = Additional;
                    ToolTip = 'Specifies the telephone number of the contact person that the sales document will be sent to.';
                }
                field("SSA Sell-to E-Mail"; Rec."SSA Sell-to E-Mail")
                {
                    ApplicationArea = All;
                    Caption = 'Email';
                    Importance = Additional;
                    ToolTip = 'Specifies the email address of the contact person that the sales document will be sent to.';
                }

                field("SSA Sell-to Contact"; Rec."SSA Sell-to Contact")
                {
                    ApplicationArea = All;
                    Caption = 'Contact';
                    Editable = Rec."SSA Sell-to Customer No." <> '';
                    ToolTip = 'Specifies the name of the person to contact at the customer.';
                }
            }
        }
        addafter(ShipmentLines)
        {
            group("SSA Shipping")
            {
                Editable = false;
                Caption = 'Shipping';

                field("SSA Ship-to Code"; Rec."SSA Ship-to Code")
                {
                    ApplicationArea = All;
                    Caption = 'Code';
                    Importance = Promoted;
                    ToolTip = 'Specifies the code for another shipment address than the customer''s own address, which is entered by default.';
                }
                field("SSA Ship-to Name"; Rec."SSA Ship-to Name")
                {
                    ApplicationArea = All;
                    Caption = 'Name';
                    ToolTip = 'Specifies the name that products on the sales document will be shipped to.';
                }
                field("SSA Ship-to Address"; Rec."SSA Ship-to Address")
                {
                    ApplicationArea = All;
                    Caption = 'Address';
                    QuickEntry = false;
                    ToolTip = 'Specifies the address that products on the sales document will be shipped to.';
                }
                field("SSA Ship-to Address 2"; Rec."SSA Ship-to Address 2")
                {
                    ApplicationArea = All;
                    Caption = 'Address 2';
                    QuickEntry = false;
                    ToolTip = 'Specifies additional address information.';
                }
                field("SSA Ship-to City"; Rec."SSA Ship-to City")
                {
                    ApplicationArea = All;
                    Caption = 'City';
                    QuickEntry = false;
                    ToolTip = 'Specifies the city of the customer on the sales document.';
                }
                group("SSA Control297")
                {
                    ShowCaption = false;
                    Visible = IsShipToCountyVisible;
                    field("SSA Ship-to County"; Rec."SSA Ship-to County")
                    {
                        ApplicationArea = All;
                        Caption = 'County';
                        QuickEntry = false;
                        ToolTip = 'Specifies the state, province or county of the address.';
                    }
                }
                field("SSA Ship-to Post Code"; Rec."SSA Ship-to Post Code")
                {
                    ApplicationArea = All;
                    Caption = 'Post Code';
                    QuickEntry = false;
                    ToolTip = 'Specifies the postal code.';
                }
                field("SSA Ship-to Country/Region Code"; Rec."SSA Ship-to Country/Reg Code")
                {
                    ApplicationArea = All;
                    Caption = 'Country/Region';
                    Importance = Additional;
                    QuickEntry = false;
                    ToolTip = 'Specifies the customer''s country/region.';

                }
                field("SSA Ship-to Contact"; Rec."SSA Ship-to Contact")
                {
                    ApplicationArea = All;
                    Caption = 'Contact';
                    ToolTip = 'Specifies the name of the contact person at the address that products on the sales document will be shipped to.';
                }
            }



        }
    }
    var
        FormatAddress: Codeunit "Format Address";
        IsSellToCountyVisible: Boolean;
        IsShipToCountyVisible: Boolean;

    trigger OnOpenPage()
    begin
        ActivateFields();
    end;

    local procedure ActivateFields()
    begin
        IsSellToCountyVisible := FormatAddress.UseCounty(Rec."SSA Sell-to Country/Reg Code");
        IsShipToCountyVisible := FormatAddress.UseCounty(Rec."SSA Ship-to Country/Reg Code");
    end;
}