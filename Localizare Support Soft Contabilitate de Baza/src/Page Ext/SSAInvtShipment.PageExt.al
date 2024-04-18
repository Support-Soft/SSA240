pageextension 70072 "SSA Invt. Shipment" extends "Invt. Shipment"
{
    layout
    {
        addafter("No.")
        {
            group("SSA Sell-to")
            {
                Caption = 'Sell-to';

                field("SSA Sell-to Customer No."; Rec."SSA Sell-to Customer No.")
                {
                    ApplicationArea = All;
                    Caption = 'Customer No.';
                    ShowMandatory = true;
                    ToolTip = 'Specifies the number of the customer who will receive the products and be billed by default.';

                    trigger OnValidate()
                    begin
                        IsSalesLinesEditable := Rec.SalesLinesEditable();
                        Rec.SelltoCustomerNoOnAfterValidate(Rec, xRec);
                        CurrPage.Update();
                    end;
                }
                field("SSA Sell-to Customer Name"; Rec."SSA Sell-to Customer Name")
                {
                    ApplicationArea = All;
                    Caption = 'Customer Name';
                    Importance = Additional;
                    ToolTip = 'Specifies the name of the customer who will receive the products and be billed by default.';

                    AboutTitle = 'Who are you selling to?';
                    AboutText = 'You can choose existing customers, or add new customers when you create orders. Orders can automatically choose special prices and discounts that you have set for each customer.';

                    trigger OnValidate()
                    begin
                        Rec.SelltoCustomerNoOnAfterValidate(Rec, xRec);
                        CurrPage.Update();
                    end;
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

                    trigger OnValidate()
                    begin
                        IsSellToCountyVisible := FormatAddress.UseCounty(Rec."SSA Sell-to Country/Reg Code");
                    end;
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
                Caption = 'Shipping';
                group("SSA Control91")
                {
                    ShowCaption = false;
                    group("SSA Control90")
                    {
                        ShowCaption = false;
                        field("SSA ShippingOptions"; ShipToOptions)
                        {
                            ApplicationArea = All;
                            Caption = 'Ship-to';
                            ToolTip = 'Specifies the address that the products on the sales document are shipped to. Default (Sell-to Address): The same as the customer''s sell-to address. Alternate Ship-to Address: One of the customer''s alternate ship-to addresses. Custom Address: Any ship-to address that you specify in the fields below.';

                            trigger OnValidate()
                            var
                                ShipToAddress: Record "Ship-to Address";
                                ShipToAddressList: Page "Ship-to Address List";
                            begin

                                case ShipToOptions of
                                    ShipToOptions::"Default (Sell-to Address)":
                                        begin
                                            Rec.Validate("SSA Ship-to Code", '');
                                            Rec.CopySellToAddressToShipToAddress();
                                        end;
                                    ShipToOptions::"Alternate Shipping Address":
                                        begin
                                            ShipToAddress.SetRange("Customer No.", Rec."SSA Sell-to Customer No.");
                                            ShipToAddressList.LookupMode := true;
                                            ShipToAddressList.SetTableView(ShipToAddress);

                                            if ShipToAddressList.RunModal() = ACTION::LookupOK then begin
                                                ShipToAddressList.GetRecord(ShipToAddress);
                                                Rec.Validate("SSA Ship-to Code", ShipToAddress.Code);
                                            end else
                                                ShipToOptions := ShipToOptions::"Custom Address";
                                        end;
                                    ShipToOptions::"Custom Address":
                                        begin
                                            Rec.Validate("SSA Ship-to Code", '');
                                            IsShipToCountyVisible := FormatAddress.UseCounty(Rec."SSA Ship-to Country/Reg Code");
                                        end;
                                end;
                            end;
                        }
                        group("SSA Control4")
                        {
                            ShowCaption = false;
                            Visible = not (ShipToOptions = ShipToOptions::"Default (Sell-to Address)");
                            field("SSA Ship-to Code"; Rec."SSA Ship-to Code")
                            {
                                ApplicationArea = All;
                                Caption = 'Code';
                                Editable = ShipToOptions = ShipToOptions::"Alternate Shipping Address";
                                Importance = Promoted;
                                ToolTip = 'Specifies the code for another shipment address than the customer''s own address, which is entered by default.';

                                trigger OnValidate()
                                var
                                    ShipToAddress: Record "Ship-to Address";
                                begin
                                    if (xRec."SSA Ship-to Code" <> '') and (Rec."SSA Ship-to Code" = '') then
                                        Error(EmptyShipToCodeErr);
                                    if Rec."SSA Ship-to Code" <> '' then begin
                                        ShipToAddress.Get(Rec."SSA Sell-to Customer No.", Rec."SSA Ship-to Code");
                                        IsShipToCountyVisible := FormatAddress.UseCounty(ShipToAddress."Country/Region Code");
                                    end else
                                        IsShipToCountyVisible := false;
                                end;
                            }
                            field("SSA Ship-to Name"; Rec."SSA Ship-to Name")
                            {
                                ApplicationArea = All;
                                Caption = 'Name';
                                Editable = ShipToOptions = ShipToOptions::"Custom Address";
                                ToolTip = 'Specifies the name that products on the sales document will be shipped to.';
                            }
                            field("SSA Ship-to Address"; Rec."SSA Ship-to Address")
                            {
                                ApplicationArea = All;
                                Caption = 'Address';
                                Editable = ShipToOptions = ShipToOptions::"Custom Address";
                                QuickEntry = false;
                                ToolTip = 'Specifies the address that products on the sales document will be shipped to.';
                            }
                            field("SSA Ship-to Address 2"; Rec."SSA Ship-to Address 2")
                            {
                                ApplicationArea = All;
                                Caption = 'Address 2';
                                Editable = ShipToOptions = ShipToOptions::"Custom Address";
                                QuickEntry = false;
                                ToolTip = 'Specifies additional address information.';
                            }
                            field("SSA Ship-to City"; Rec."SSA Ship-to City")
                            {
                                ApplicationArea = All;
                                Caption = 'City';
                                Editable = ShipToOptions = ShipToOptions::"Custom Address";
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
                                    Editable = ShipToOptions = ShipToOptions::"Custom Address";
                                    QuickEntry = false;
                                    ToolTip = 'Specifies the state, province or county of the address.';
                                }
                            }
                            field("SSA Ship-to Post Code"; Rec."SSA Ship-to Post Code")
                            {
                                ApplicationArea = All;
                                Caption = 'Post Code';
                                Editable = ShipToOptions = ShipToOptions::"Custom Address";
                                QuickEntry = false;
                                ToolTip = 'Specifies the postal code.';
                            }
                            field("SSA Ship-to Country/Region Code"; Rec."SSA Ship-to Country/Reg Code")
                            {
                                ApplicationArea = All;
                                Caption = 'Country/Region';
                                Editable = ShipToOptions = ShipToOptions::"Custom Address";
                                Importance = Additional;
                                QuickEntry = false;
                                ToolTip = 'Specifies the customer''s country/region.';

                                trigger OnValidate()
                                begin
                                    IsShipToCountyVisible := FormatAddress.UseCounty(Rec."SSA Ship-to Country/Reg Code");
                                end;
                            }
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
        }
    }
    var
        FormatAddress: Codeunit "Format Address";
        IsSalesLinesEditable: Boolean;
        IsSellToCountyVisible: Boolean;
        IsShipToCountyVisible: Boolean;
        ShipToOptions: Enum "Sales Ship-to Options";
        EmptyShipToCodeErr: Label 'The Code field can only be empty if you select Custom Address in the Ship-to field.';

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