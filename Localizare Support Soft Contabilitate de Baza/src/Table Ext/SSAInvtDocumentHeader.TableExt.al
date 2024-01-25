tableextension 70073 "SSA Invt. Document Header" extends "Invt. Document Header"
{
    fields
    {
        field(70000; "SSA Sell-to Customer No."; Code[20])
        {
            Caption = 'Sell-to Customer No.';
            TableRelation = Customer;

            trigger OnValidate()
            var
                LocationCode: Code[10];
                ShouldSkipConfirmSellToCustomerDialog: Boolean;
            begin

                if "No." = '' then
                    InitRecord();
                TestStatusOpen();

                if ("SSA Sell-to Customer No." <> xRec."SSA Sell-to Customer No.") and
                   (xRec."SSA Sell-to Customer No." <> '')
                then begin
                    ShouldSkipConfirmSellToCustomerDialog := GetHideValidationDialog() or not GuiAllowed();
                    if ShouldSkipConfirmSellToCustomerDialog then
                        Confirmed := true
                    else
                        Confirmed := Confirm(ConfirmChangeQst, false, SellToCustomerTxt);
                    if Confirmed then begin
                        InvtDocumentLine.SetRange("Document Type", "Document Type");
                        InvtDocumentLine.SetRange("Document No.", "No.");
                        if "SSA Sell-to Customer No." = '' then begin
                            if InvtDocumentLine.FindFirst() then
                                Error(
                                  Text005,
                                  FieldCaption("SSA Sell-to Customer No."));
                            Init();
                            InventorySetup.Get();
                            "No. Series" := xRec."No. Series";
                            InitRecord();
                            exit;
                        end;
                        InvtDocumentLine.Reset();
                    end else begin
                        Rec := xRec;
                        exit;
                    end;
                end;

                GetCust("SSA Sell-to Customer No.");
                Customer.CheckBlockedCustOnDocs(Customer, SalesDocType::Order, false, false);

                CopySellToCustomerAddressFieldsFromCustomer(Customer);

                UpdateShipToCodeFromCust();

                LocationCode := "Location Code";

                if LocationCode <> '' then
                    Validate("Location Code", LocationCode);

                if (xRec."SSA Sell-to Customer No." <> '') and (xRec."SSA Sell-to Customer No." <> "SSA Sell-to Customer No.") then
                    Rec.RecallModifyAddressNotification(GetModifyCustomerAddressNotificationId());

            end;
        }


        field(70001; "SSA Sell-to Customer Name"; Text[100])
        {
            Caption = 'Sell-to Customer Name';
            TableRelation = Customer.Name;
            ValidateTableRelation = false;
        }
        field(70002; "SSA Sell-to Customer Name 2"; Text[50])
        {
            Caption = 'Sell-to Customer Name 2';
        }
        field(70003; "SSA Sell-to Address"; Text[100])
        {
            Caption = 'Sell-to Address';

            trigger OnValidate()
            begin
                UpdateShipToAddressFromSellToAddress(FieldNo("SSA Ship-to Address"));
                ModifyCustomerAddress();
            end;
        }
        field(70004; "SSA Sell-to Address 2"; Text[50])
        {
            Caption = 'Sell-to Address 2';

            trigger OnValidate()
            begin
                UpdateShipToAddressFromSellToAddress(FieldNo("SSA Ship-to Address 2"));
                ModifyCustomerAddress();
            end;
        }
        field(70005; "SSA Sell-to City"; Text[30])
        {
            Caption = 'Sell-to City';
            TableRelation = if ("SSA Sell-to Country/Reg Code" = const('')) "Post Code".City
            else
            if ("SSA Sell-to Country/Reg Code" = filter(<> '')) "Post Code".City where("Country/Region Code" = field("SSA Sell-to Country/Reg Code"));
            ValidateTableRelation = false;

            trigger OnLookup()
            begin

                PostCode.LookupPostCode("SSA Sell-to City", "SSA Sell-to Post Code", "SSA Sell-to County", "SSA Sell-to Country/Reg Code");

            end;

            trigger OnValidate()
            begin
                PostCode.ValidateCity(
                    "SSA Sell-to City", "SSA Sell-to Post Code", "SSA Sell-to County", "SSA Sell-to Country/Reg Code", (CurrFieldNo <> 0) and GuiAllowed);
                UpdateShipToAddressFromSellToAddress(FieldNo("SSA Ship-to City"));
                ModifyCustomerAddress();
            end;
        }
        field(70006; "SSA Sell-to Contact"; Text[100])
        {
            Caption = 'Sell-to Contact';

            trigger OnLookup()
            var
                Contact: Record Contact;
            begin
                if "Document Type" <> "Document Type"::Shipment then
                    if "SSA Sell-to Customer No." = '' then
                        exit;

                Contact.FilterGroup(2);
                LookupContact("SSA Sell-to Customer No.", "SSA Sell-to Contact No.", Contact);
                if PAGE.RunModal(0, Contact) = ACTION::LookupOK then
                    Validate("SSA Sell-to Contact No.", Contact."No.");
                Contact.FilterGroup(0);
            end;

            trigger OnValidate()
            begin
                if "SSA Sell-to Contact" = '' then
                    Validate("SSA Sell-to Contact No.", '');
                ModifyCustomerAddress();
            end;
        }
        field(70007; "SSA Sell-to Post Code"; Code[20])
        {
            Caption = 'Sell-to Post Code';
            TableRelation = if ("SSA Sell-to Country/Reg Code" = const('')) "Post Code"
            else
            if ("SSA Sell-to Country/Reg Code" = filter(<> '')) "Post Code" where("Country/Region Code" = field("SSA Sell-to Country/Reg Code"));
            ValidateTableRelation = false;

            trigger OnLookup()
            begin

                PostCode.LookupPostCode("SSA Sell-to City", "SSA Sell-to Post Code", "SSA Sell-to County", "SSA Sell-to Country/Reg Code");

            end;

            trigger OnValidate()
            begin
                PostCode.ValidatePostCode(
                    "SSA Sell-to City", "SSA Sell-to Post Code", "SSA Sell-to County", "SSA Sell-to Country/Reg Code", (CurrFieldNo <> 0) and GuiAllowed);
                UpdateShipToAddressFromSellToAddress(FieldNo("SSA Ship-to Post Code"));
                ModifyCustomerAddress();
            end;
        }
        field(70008; "SSA Sell-to County"; Text[30])
        {
            CaptionClass = '5,1,' + "SSA Sell-to Country/Reg Code";
            Caption = 'Sell-to County';

            trigger OnValidate()
            begin
                UpdateShipToAddressFromSellToAddress(FieldNo("SSA Ship-to County"));
                ModifyCustomerAddress();
            end;
        }
        field(70009; "SSA Sell-to Country/Reg Code"; Code[10])
        {
            Caption = 'Sell-to Country/Region Code';
            TableRelation = "Country/Region";

            trigger OnValidate()
            var
                FormatAddress: Codeunit "Format Address";
            begin
                if not FormatAddress.UseCounty(Rec."SSA Sell-to Country/Reg Code") then
                    "SSA Sell-to County" := '';
                UpdateShipToAddressFromSellToAddress(FieldNo("SSA Ship-to Country/Reg Code"));
                ModifyCustomerAddress();
                Validate("SSA Ship-to Country/Reg Code");
            end;
        }
        field(70010; "SSA Sell-to Phone No."; Text[30])
        {
            Caption = 'Sell-to Phone No.';
            ExtendedDatatype = PhoneNo;

            trigger OnValidate()
            var
                i: Integer;
                IntVar: Integer;
            begin
                for i := 1 to StrLen("SSA Sell-to Phone No.") do
                    if not Evaluate(IntVar, "SSA Sell-to Phone No."[i]) then
                        Error(PhoneNoCannotContainLettersErr);
            end;
        }

        field(70011; "SSA Sell-to E-Mail"; Text[80])
        {
            Caption = 'Email';
            ExtendedDatatype = EMail;

            trigger OnValidate()
            var
                MailManagement: Codeunit "Mail Management";
            begin
                if "SSA Sell-to E-Mail" = '' then
                    exit;
                MailManagement.CheckValidEmailAddresses("SSA Sell-to E-Mail");
            end;
        }
        field(70012; "SSA Sell-to Contact No."; Code[20])
        {
            Caption = 'Sell-to Contact No.';
            TableRelation = Contact;
        }

        field(70013; "SSA Ship-to Code"; Code[10])
        {
            Caption = 'Ship-to Code';
            TableRelation = "Ship-to Address".Code where("Customer No." = field("SSA Sell-to Customer No."));

            trigger OnValidate()
            var
                ShipToAddr: Record "Ship-to Address";
            begin
                InvtDocumentLine.Reset();
                if "SSA Ship-to Code" <> '' then begin
                    if xRec."SSA Ship-to Code" <> '' then begin
                        GetCust("SSA Sell-to Customer No.");
                        SetCustomerLocationCode(Customer);
                    end;
                    ShipToAddr.Get("SSA Sell-to Customer No.", "SSA Ship-to Code");
                    SetShipToCustomerAddressFieldsFromShipToAddr(ShipToAddr);
                end else
                    if "SSA Sell-to Customer No." <> '' then begin
                        GetCust("SSA Sell-to Customer No.");
                        CopyShipToCustomerAddressFieldsFromCust(Customer);
                    end;
            end;
        }
        field(70014; "SSA Ship-to Name"; Text[100])
        {
            Caption = 'Ship-to Name';
        }
        field(70015; "SSA Ship-to Name 2"; Text[50])
        {
            Caption = 'Ship-to Name 2';
        }
        field(70016; "SSA Ship-to Address"; Text[100])
        {
            Caption = 'Ship-to Address';
        }
        field(70017; "SSA Ship-to Address 2"; Text[50])
        {
            Caption = 'Ship-to Address 2';
        }
        field(70018; "SSA Ship-to City"; Text[30])
        {
            Caption = 'Ship-to City';
            TableRelation = if ("SSA Ship-to Country/Reg Code" = const('')) "Post Code".City
            else
            if ("SSA Ship-to Country/Reg Code" = filter(<> '')) "Post Code".City where("Country/Region Code" = field("SSA Ship-to Country/Reg Code"));
            ValidateTableRelation = false;

            trigger OnLookup()
            begin
                PostCode.LookupPostCode("SSA Ship-to City", "SSA Ship-to Post Code", "SSA Ship-to County", "SSA Ship-to Country/Reg Code");
            end;

            trigger OnValidate()
            begin
                PostCode.ValidateCity(
                    "SSA Ship-to City", "SSA Ship-to Post Code", "SSA Ship-to County", "SSA Ship-to Country/Reg Code", (CurrFieldNo <> 0) and GuiAllowed);
            end;
        }
        field(70019; "SSA Ship-to Contact"; Text[100])
        {
            Caption = 'Ship-to Contact';
        }
        field(70020; "SSA Ship-to Post Code"; Code[20])
        {
            Caption = 'Ship-to Post Code';
            TableRelation = if ("SSA Ship-to Country/Reg Code" = const('')) "Post Code"
            else
            if ("SSA Ship-to Country/Reg Code" = filter(<> '')) "Post Code" where("Country/Region Code" = field("SSA Ship-to Country/Reg Code"));
            ValidateTableRelation = false;

            trigger OnLookup()
            begin
                PostCode.LookupPostCode("SSA Ship-to City", "SSA Ship-to Post Code", "SSA Ship-to County", "SSA Ship-to Country/Reg Code");
            end;

            trigger OnValidate()
            begin
                PostCode.ValidatePostCode(
                    "SSA Ship-to City", "SSA Ship-to Post Code", "SSA Ship-to County", "SSA Ship-to Country/Reg Code", (CurrFieldNo <> 0) and GuiAllowed);
            end;
        }
        field(70021; "SSA Ship-to County"; Text[30])
        {
            CaptionClass = '5,1,' + "SSA Ship-to Country/Reg Code";
            Caption = 'Ship-to County';
        }
        field(70022; "SSA Ship-to Country/Reg Code"; Code[10])
        {
            Caption = 'Ship-to Country/Region Code';
            TableRelation = "Country/Region";
        }
    }
    var
        Customer: Record Customer;
        InvtDocumentLine: Record "Invt. Document Line";
        InventorySetup: Record "Inventory Setup";
        SalesSetup: Record "Sales & Receivables Setup";

        PostCode: Record "Post Code";
        UserSetupMgt: Codeunit "User Setup Management";
        Confirmed: Boolean;
        StatusCheckSuspended: Boolean;
        PhoneNoCannotContainLettersErr: Label 'You cannot enter letters in this field.';
        SalesDocType: Enum "Sales Document Type";
        ConfirmChangeQst: Label 'Do you want to change %1?', Comment = '%1 = a Field Caption like Currency Code';
        SellToCustomerTxt: Label 'Sell-to Customer';
        Text005: Label 'You cannot reset %1 because the document still has one or more lines.';
        ModifyCustomerAddressNotificationMsg: Label 'The address you entered for %1 is different from the customer''s existing address.', Comment = '%1=customer name';
        ModifyCustomerAddressNotificationLbl: Label 'Update the address';
        DontShowAgainActionLbl: Label 'Don''t show again';

    procedure TestStatusOpen()
    begin
        if StatusCheckSuspended then
            exit;

        TestField(Status, Status::Open);

    end;

    procedure SuspendStatusCheck(Suspend: Boolean)
    begin
        StatusCheckSuspended := Suspend;
    end;



    procedure GetCust(CustNo: Code[20]): Record Customer
    begin

        if (CustNo <> '') then begin
            if CustNo <> Customer."No." then
                Customer.Get(CustNo);
        end else
            Clear(Customer);

        exit(Customer);
    end;

    local procedure CopySellToCustomerAddressFieldsFromCustomer(var SellToCustomer: Record Customer)
    begin
        "SSA Sell-to Customer Name" := Customer.Name;
        "SSA Sell-to Customer Name 2" := Customer."Name 2";
        "SSA Sell-to Phone No." := Customer."Phone No.";
        "SSA Sell-to E-Mail" := Customer."E-Mail";
        if SellToCustomerIsReplaced() or
            ShouldCopyAddressFromSellToCustomer(SellToCustomer) or
            (HasDifferentSellToAddress(SellToCustomer) and SellToCustomer.HasAddress())
        then begin
            "SSA Sell-to Address" := SellToCustomer.Address;
            "SSA Sell-to Address 2" := SellToCustomer."Address 2";
            "SSA Sell-to City" := SellToCustomer.City;
            "SSA Sell-to Post Code" := SellToCustomer."Post Code";
            "SSA Sell-to County" := SellToCustomer.County;
            "SSA Sell-to Country/Reg Code" := SellToCustomer."Country/Region Code";
        end;
        "SSA Sell-to Contact" := SellToCustomer.Contact;
        "Gen. Bus. Posting Group" := SellToCustomer."Gen. Bus. Posting Group";

        UpdateLocationCode(SellToCustomer."Location Code");

    end;

    local procedure SellToCustomerIsReplaced(): Boolean
    begin
        exit((xRec."SSA Sell-to Customer No." <> '') and (xRec."SSA Sell-to Customer No." <> "SSA Sell-to Customer No."));
    end;

    local procedure UpdateShipToCodeFromCust()
    begin
        Rec.Validate("SSA Ship-to Code", Customer."Ship-to Code");
    end;

    procedure RecallModifyAddressNotification(NotificationID: Guid)
    var
        MyNotifications: Record "My Notifications";
        ModifyCustomerAddressNotification: Notification;
    begin
        if (not MyNotifications.IsEnabled(NotificationID)) then
            exit;

        ModifyCustomerAddressNotification.Id := NotificationID;
        ModifyCustomerAddressNotification.Recall();
    end;

    procedure GetModifyCustomerAddressNotificationId(): Guid
    begin
        exit('00000000-0000-0000-0000-00000070000');
    end;

    local procedure UpdateShipToAddressFromSellToAddress(FieldNumber: Integer)
    begin

        if ("SSA Ship-to Code" = '') and ShipToAddressEqualsOldSellToAddress() then begin
            case FieldNumber of
                FieldNo("SSA Ship-to Address"):
                    "SSA Ship-to Address" := "SSA Sell-to Address";
                FieldNo("SSA Ship-to Address 2"):
                    "SSA Ship-to Address 2" := "SSA Sell-to Address 2";
                FieldNo("SSA Ship-to City"), FieldNo("SSA Ship-to Post Code"):
                    begin
                        "SSA Ship-to City" := "SSA Sell-to City";
                        "SSA Ship-to Post Code" := "SSA Sell-to Post Code";
                        "SSA Ship-to County" := "SSA Sell-to County";
                        "SSA Ship-to Country/Reg Code" := "SSA Sell-to Country/Reg Code";
                    end;
                FieldNo("SSA Ship-to County"):
                    "SSA Ship-to County" := "SSA Sell-to County";
                FieldNo("SSA Ship-to Country/Reg Code"):
                    "SSA Ship-to Country/Reg Code" := "SSA Sell-to Country/Reg Code";
            end;
        end;
    end;

    local procedure ModifyCustomerAddress()
    var
        Customer: Record Customer;
    begin
        GetSalesSetup();
        if SalesSetup."Ignore Updated Addresses" then
            exit;

        if Customer.Get("SSA Sell-to Customer No.") and HasSellToAddress() and HasDifferentSellToAddress(Customer) then
            ShowModifyAddressNotification(GetModifyCustomerAddressNotificationId(),
              ModifyCustomerAddressNotificationLbl, ModifyCustomerAddressNotificationMsg,
              'CopySellToCustomerAddressFieldsFromSalesDocument', "SSA Sell-to Customer No.",
              "SSA Sell-to Customer Name", FieldName("SSA Sell-to Customer No."));
    end;

    procedure LookupContact(CustomerNo: Code[20]; ContactNo: Code[20]; var Contact: Record Contact)
    var
        ContactBusinessRelation: Record "Contact Business Relation";
        FilterByContactCompany: Boolean;
    begin
        if ContactBusinessRelation.FindByRelation(ContactBusinessRelation."Link to Table"::Customer, CustomerNo) then
            Contact.SetRange("Company No.", ContactBusinessRelation."Contact No.")
        else
            Contact.SetRange("Company No.", '');
        if ContactNo <> '' then
            if Contact.Get(ContactNo) then
                if FilterByContactCompany then
                    Contact.SetRange("Company No.", Contact."Company No.");
    end;

    local procedure SetCustomerLocationCode(SellToCustomer: Record Customer)
    begin
        if SellToCustomer."Location Code" <> '' then
            Validate("Location Code", SellToCustomer."Location Code");
    end;

    procedure SetShipToCustomerAddressFieldsFromShipToAddr(ShipToAddr: Record "Ship-to Address")
    var
        ShouldCopyLocationCode: Boolean;
    begin

        "SSA Ship-to Name" := ShipToAddr.Name;
        "SSA Ship-to Name 2" := ShipToAddr."Name 2";
        "SSA Ship-to Address" := ShipToAddr.Address;
        "SSA Ship-to Address 2" := ShipToAddr."Address 2";
        "SSA Ship-to City" := ShipToAddr.City;
        "SSA Ship-to Post Code" := ShipToAddr."Post Code";
        "SSA Ship-to County" := ShipToAddr.County;
        Validate("SSA Ship-to Country/Reg Code", ShipToAddr."Country/Region Code");
        "SSA Ship-to Contact" := ShipToAddr.Contact;
        ShouldCopyLocationCode := ShipToAddr."Location Code" <> '';
        if ShouldCopyLocationCode then
            Validate("Location Code", ShipToAddr."Location Code");

    end;

    procedure CopyShipToCustomerAddressFieldsFromCust(var SellToCustomer: Record Customer)
    begin

        "SSA Ship-to Name" := SellToCustomer.Name;
        "SSA Ship-to Name 2" := SellToCustomer."Name 2";
        if SellToCustomerIsReplaced() or
            ShipToAddressEqualsOldSellToAddress() or
            (HasDifferentShipToAddress(SellToCustomer) and SellToCustomer.HasAddress())
        then begin
            "SSA Ship-to Address" := SellToCustomer.Address;
            "SSA Ship-to Address 2" := SellToCustomer."Address 2";
            "SSA Ship-to City" := SellToCustomer.City;
            "SSA Ship-to Post Code" := SellToCustomer."Post Code";
            "SSA Ship-to County" := SellToCustomer.County;
            Validate("SSA Ship-to Country/Reg Code", SellToCustomer."Country/Region Code");
        end;
        "SSA Ship-to Contact" := SellToCustomer.Contact;

        SetCustomerLocationCode(SellToCustomer);

    end;

    local procedure ShouldCopyAddressFromSellToCustomer(SellToCustomer: Record Customer): Boolean
    begin
        exit((not HasSellToAddress()) and SellToCustomer.HasAddress());
    end;

    procedure HasSellToAddress(): Boolean
    begin
        case true of
            "SSA Sell-to Address" <> '':
                exit(true);
            "SSA Sell-to Address 2" <> '':
                exit(true);
            "SSA Sell-to City" <> '':
                exit(true);
            "SSA Sell-to Country/Reg Code" <> '':
                exit(true);
            "SSA Sell-to County" <> '':
                exit(true);
            "SSA Sell-to Post Code" <> '':
                exit(true);
            "SSA Sell-to Contact" <> '':
                exit(true);
        end;

        exit(false);
    end;

    procedure HasDifferentSellToAddress(Customer: Record Customer) Result: Boolean
    begin
        Result := ("SSA Sell-to Address" <> Customer.Address) or
          ("SSA Sell-to Address 2" <> Customer."Address 2") or
          ("SSA Sell-to City" <> Customer.City) or
          ("SSA Sell-to Country/Reg Code" <> Customer."Country/Region Code") or
          ("SSA Sell-to County" <> Customer.County) or
          ("SSA Sell-to Post Code" <> Customer."Post Code") or
          ("SSA Sell-to Contact" <> Customer.Contact);
    end;

    procedure UpdateLocationCode(LocationCode: Code[10])
    begin
        if UserSetupMgt.GetLocation(0, LocationCode, '') <> '' then
            Validate("Location Code", UserSetupMgt.GetLocation(0, LocationCode, ''));
    end;

    local procedure ShipToAddressEqualsOldSellToAddress(): Boolean
    begin
        exit(IsShipToAddressEqualToSellToAddress(xRec, Rec));
    end;

    local procedure IsShipToAddressEqualToSellToAddress(InvtHeaderWithSellTo: Record "Invt. Document Header"; InvtHeaderWithShipTo: Record "Invt. Document Header"): Boolean
    var
        Result: Boolean;
    begin
        begin
            Result :=
              (InvtHeaderWithSellTo."SSA Sell-to Address" = InvtHeaderWithShipTo."SSA Ship-to Address") and
              (InvtHeaderWithSellTo."SSA Sell-to Address 2" = InvtHeaderWithShipTo."SSA Ship-to Address 2") and
              (InvtHeaderWithSellTo."SSA Sell-to City" = InvtHeaderWithShipTo."SSA Ship-to City") and
              (InvtHeaderWithSellTo."SSA Sell-to County" = InvtHeaderWithShipTo."SSA Ship-to County") and
              (InvtHeaderWithSellTo."SSA Sell-to Post Code" = InvtHeaderWithShipTo."SSA Ship-to Post Code") and
              (InvtHeaderWithSellTo."SSA Sell-to Country/Reg Code" = InvtHeaderWithShipTo."SSA Ship-to Country/Reg Code") and
              (InvtHeaderWithSellTo."SSA Sell-to Contact" = InvtHeaderWithShipTo."SSA Ship-to Contact");
            exit(Result);
        end;
    end;

    local procedure GetSalesSetup()
    begin
        SalesSetup.Get();
    end;

    local procedure ShowModifyAddressNotification(NotificationID: Guid; NotificationLbl: Text; NotificationMsg: Text; NotificationFunctionTok: Text; CustomerNumber: Code[20]; CustomerName: Text[100]; CustomerNumberFieldName: Text)
    var
        MyNotifications: Record "My Notifications";
        NotificationLifecycleMgt: Codeunit "Notification Lifecycle Mgt.";
        PageMyNotifications: Page "My Notifications";
        ModifyCustomerAddressNotification: Notification;
    begin

        if not MyNotifications.Get(UserId, NotificationID) then
            PageMyNotifications.InitializeNotificationsWithDefaultState();

        if not MyNotifications.IsEnabled(NotificationID) then
            exit;

        ModifyCustomerAddressNotification.Id := NotificationID;
        ModifyCustomerAddressNotification.Message := StrSubstNo(NotificationMsg, CustomerName);
        ModifyCustomerAddressNotification.AddAction(NotificationLbl, CODEUNIT::"Document Notifications", NotificationFunctionTok);
        ModifyCustomerAddressNotification.AddAction(
          DontShowAgainActionLbl, CODEUNIT::"Document Notifications", 'HideNotificationForCurrentUser');
        ModifyCustomerAddressNotification.Scope := NOTIFICATIONSCOPE::LocalScope;
        ModifyCustomerAddressNotification.SetData(FieldName("Document Type"), Format("Document Type"));
        ModifyCustomerAddressNotification.SetData(FieldName("No."), "No.");
        ModifyCustomerAddressNotification.SetData(CustomerNumberFieldName, CustomerNumber);
        NotificationLifecycleMgt.SendNotification(ModifyCustomerAddressNotification, RecordId);
    end;

    procedure HasDifferentShipToAddress(Customer: Record Customer) Result: Boolean
    begin
        Result := ("SSA Ship-to Address" <> Customer.Address) or
                ("SSA Ship-to Address 2" <> Customer."Address 2") or
                ("SSA Ship-to City" <> Customer.City) or
                ("SSA Ship-to Country/Reg Code" <> Customer."Country/Region Code") or
                ("SSA Ship-to County" <> Customer.County) or
                ("SSA Ship-to Post Code" <> Customer."Post Code") or
                ("SSA Ship-to Contact" <> Customer.Contact);
    end;

    procedure SalesLinesEditable() IsEditable: Boolean;
    begin
        if "Document Type" = "Document Type"::Shipment then
            IsEditable := (Rec."SSA Sell-to Customer No." <> '') or (Rec."SSA Sell-to Contact No." <> '') or (Rec.GetFilter("SSA Sell-to Contact No.") <> '')

    end;

    procedure SelltoCustomerNoOnAfterValidate(var InvtDocumentHeader: Record "Invt. Document Header"; var xInvtDocumentHeader: Record "Invt. Document Header")
    begin
        if InvtDocumentHeader.GetFilter("SSA Sell-to Customer No.") = xInvtDocumentHeader."SSA Sell-to Customer No." then
            if InvtDocumentHeader."SSA Sell-to Customer No." <> xInvtDocumentHeader."SSA Sell-to Customer No." then
                InvtDocumentHeader.SetRange("SSA Sell-to Customer No.");
    end;

    procedure CopySellToAddressToShipToAddress()
    begin
        "SSA Ship-to Address" := "SSA Sell-to Address";
        "SSA Ship-to Address 2" := "SSA Sell-to Address 2";
        "SSA Ship-to City" := "SSA Sell-to City";
        "SSA Ship-to Contact" := "SSA Sell-to Contact";
        "SSA Ship-to Country/Reg Code" := "SSA Sell-to Country/Reg Code";
        "SSA Ship-to County" := "SSA Sell-to County";
        "SSA Ship-to Post Code" := "SSA Sell-to Post Code";
    end;
}