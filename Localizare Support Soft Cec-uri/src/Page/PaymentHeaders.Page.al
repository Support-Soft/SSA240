page 70512 "SSA Payment Headers"
{
    // SSM729 SSCAT 22.06.2018 Nr.crt.76-Limita valorica pentru instrumente de plata neincasate- fin
    // SSM872 SSCAT 06.09.2018 Minuta financiar 30.08.2018

    Caption = 'Payment Headers';
    PageType = Document;
    RefreshOnActivate = true;
    SourceTable = "SSA Payment Header";

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    AssistEdit = false;
                    ToolTip = 'Specifies the value of the No. field.';
                    trigger OnAssistEdit()
                    begin
                        if Rec.AssistEdit(xRec) then
                            CurrPage.UPDATE;
                    end;
                }
                field("Payment Class"; Rec."Payment Class")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Lookup = false;
                    ToolTip = 'Specifies the value of the Payment Class field.';
                }
                field("Payment Class Name"; Rec."Payment Class Name")
                {
                    ApplicationArea = All;
                    DrillDown = false;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Payment Class Name field.';
                }
                field("Status Name"; Rec."Status Name")
                {
                    ApplicationArea = All;
                    DrillDown = false;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Status Name field.';
                }
                field("Currency Code"; Rec."Currency Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Currency Code field.';
                    trigger OnAssistEdit()
                    begin
                        ChangeExchangeRate.SetParameter(Rec."Currency Code", Rec."Currency Factor", Rec."Posting Date");
                        if ChangeExchangeRate.RUNMODAL = ACTION::OK then begin
                            Rec.VALIDATE("Currency Factor", ChangeExchangeRate.GetParameter);
                            CurrPage.UPDATE;
                        end;
                        CLEAR(ChangeExchangeRate);
                    end;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Posting Date field.';
                }
                field("Document Date"; Rec."Document Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Document Date field.';
                    trigger OnValidate()
                    begin
                        DocumentDateOnAfterValidate;
                    end;
                }
                field("Amount (LCY)"; Rec."Amount (LCY)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Total Amount (LCY) field.';
                }
                field("Suma Aplicata"; Rec."Suma Aplicata")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Suma Aplicata field.';
                }
                field("Account Type"; Rec."Account Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Account Type field.';
                }
                field("Account No."; Rec."Account No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Account No. field.';
                }
                field(Girat; Rec.Girat)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Endorsed field.';
                }
                field("Payment Series"; Rec."Payment Series")
                {
                    ApplicationArea = All;
                    Editable = PaymentEditable;
                    ToolTip = 'Specifies the value of the Payment Series field.';
                }
                field("Payment Number"; Rec."Payment Number")
                {
                    ApplicationArea = All;
                    Editable = PaymentEditable;
                    ToolTip = 'Specifies the value of the Payment Number field.';
                }
            }
            part(Lines; "SSA Payment Lines")
            {
                ApplicationArea = All;
                SubPageLink = "No." = field("No.");
                UpdatePropagation = Both;
            }
            group(Posting)
            {
                Caption = 'Posting';
                Visible = false;
                field("Source Code"; Rec."Source Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Source Code field.';
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Shortcut Dimension 1 Code field.';
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Shortcut Dimension 2 Code field.';
                }
            }
        }
        area(factboxes)
        {
            part(Control1907959307; "SSA Payment Header FactBox")
            {
                ApplicationArea = All;
                Visible = true;
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Header")
            {
                Caption = '&Header';
                action(Dimensions)
                {
                    AccessByPermission = TableData Dimension = R;
                    ApplicationArea = All;
                    Caption = 'Dimensions';
                    Enabled = Rec."No." <> '';
                    Image = Dimensions;
                    ShortCutKey = 'Shift+Ctrl+D';
                    ToolTip = 'View or edits dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyze transaction history.';

                    trigger OnAction()
                    begin
                        //SSM729>>
                        Rec.ShowDocDim;
                        CurrPage.SAVERECORD;
                        //SSM729<<
                    end;
                }
                action("Header RIB")
                {
                    ApplicationArea = All;
                    Caption = 'Header RIB';
                    Image = CopyBOMHeader;
                    RunObject = Page "SSA Payment Bank";
                    RunPageLink = "No." = field("No.");
                    ToolTip = 'Executes the Header RIB action.';
                }
            }
            group("&Line")
            {
                Caption = '&Line';
                action("Insert")
                {
                    ApplicationArea = All;
                    Caption = 'Insert';
                    Image = Insert;
                    ToolTip = 'Executes the Insert action.';
                    trigger OnAction()
                    var
                        PaymentManagement: Codeunit "SSA Payment Management";
                    begin
                        PaymentManagement.LinesInsert(Rec."No.");
                    end;
                }
                separator(Separator1120028)
                {
                }
            }
            group("&Navigate")
            {
                Caption = '&Navigate';
                action(Header)
                {
                    ApplicationArea = All;
                    Caption = 'Header';
                    Image = Filed;
                    ToolTip = 'Executes the Header action.';
                    trigger OnAction()
                    begin
                        Navigate.SetDoc(Rec."Posting Date", Rec."No.");
                        Navigate.RUN;
                    end;
                }
            }
        }
        area(processing)
        {
            group("F&unctions")
            {
                Caption = 'F&unctions';
                action("Propose &vendor payments")
                {
                    ApplicationArea = All;
                    Caption = 'Propose &vendor payments';
                    Image = SuggestVendorPayments;
                    ToolTip = 'Executes the Propose &vendor payments action.';
                    trigger OnAction()
                    var
                        PaymentClass: Record "SSA Payment Class";
                        CreateVendorPmtSuggestion: Report "SSA Suggest Vendor Payments";
                    begin
                        if Rec."Status No." <> 0 then
                            MESSAGE(Text003)
                        else
                            if PaymentClass.GET(Rec."Payment Class") then
                                if PaymentClass.Suggestions = PaymentClass.Suggestions::Vendor then begin
                                    CreateVendorPmtSuggestion.SetGenPayLine(Rec);
                                    CreateVendorPmtSuggestion.RUNMODAL;
                                    CLEAR(CreateVendorPmtSuggestion);
                                end else
                                    MESSAGE(Text001);
                    end;
                }
                action("Propose &customer payments")
                {
                    ApplicationArea = All;
                    Caption = 'Propose &customer payments';
                    Image = SuggestCustomerPayments;
                    ToolTip = 'Executes the Propose &customer payments action.';
                    trigger OnAction()
                    var
                        PaymentClass: Record "SSA Payment Class";
                        CreateCustomerPmtSuggestion: Report "SSA Suggest Customer Payments";
                    begin
                        if Rec."Status No." <> 0 then
                            MESSAGE(Text003)
                        else
                            if PaymentClass.GET(Rec."Payment Class") then
                                if PaymentClass.Suggestions = PaymentClass.Suggestions::Customer then begin
                                    CreateCustomerPmtSuggestion.SetGenPayLine(Rec);
                                    CreateCustomerPmtSuggestion.RUNMODAL;
                                    CLEAR(CreateCustomerPmtSuggestion);
                                end else
                                    MESSAGE(Text002);
                    end;
                }
                action("Set Document ID")
                {
                    ApplicationArea = All;
                    Caption = 'Set Document ID';
                    Image = Document;
                    ToolTip = 'Executes the Set Document ID action.';
                    trigger OnAction()
                    begin
                        if Rec."Status No." <> 0 then
                            MESSAGE(Text004)
                        else
                            CurrPage.Lines.PAGE.SetDocumentID;
                    end;
                }
                separator(Separator1120052)
                {
                }
                action(Archive)
                {
                    ApplicationArea = All;
                    Caption = 'Archive';
                    Image = Archive;
                    ToolTip = 'Executes the Archive action.';
                    trigger OnAction()
                    var
                        Archive: Boolean;
                        PaymtManagt: Codeunit "SSA Payment Management";
                    begin
                        if Rec."No." = '' then
                            exit;
                        if not CONFIRM(Text009) then
                            exit;
                        /*
                        CALCFIELDS("Nb of lines");
                        IF "Nb of lines" = 0 THEN
                          ERROR(Text005);
                        CALCFIELDS("Lines not Posted");
                        IF "Lines not Posted" = 0 THEN
                          Archive := CONFIRM(Text008);
                        IF "Lines not Posted" = 1 THEN
                          Archive := CONFIRM(Text006);
                        IF "Lines not Posted" > 1 THEN
                          Archive := CONFIRM(Text007);
                        IF Archive THEN
                        */
                        PaymtManagt.ArchiveDocument(Rec);
                    end;
                }
                action(Aplicare)
                {
                    ApplicationArea = All;
                    Caption = 'Apply';
                    Image = Apply;
                    ToolTip = 'Executes the Apply action.';
                    trigger OnAction()
                    begin
                        //SSM729>>
                        Steps.SETRANGE("Payment Class", Rec."Payment Class");
                        Steps.SETRANGE("Previous Status", Rec."Status No.");
                        Steps.FINDFIRST;
                        Steps.TESTFIELD("Permite Reaplicari");

                        Rec.CALCFIELDS("Suma Aplicata");
                        if Rec."Suma Aplicata" <> 0 then
                            ERROR('Trebuie dezaplicare pentru a fi reaplicat');

                        PaymentManagement.CreazaLiniiAplicare(Rec, true, 0);
                        MESSAGE('Aplicat');
                        //SSM729<<
                    end;
                }
                action(Dezaplicare)
                {
                    ApplicationArea = All;
                    Caption = 'UnApply';
                    Image = UnApply;
                    ToolTip = 'Executes the UnApply action.';
                    trigger OnAction()
                    var
                        PaymentLine: Record "SSA Payment Line";
                    begin
                        //SSM729>>
                        Steps.SETRANGE("Payment Class", Rec."Payment Class");
                        Steps.SETRANGE("Previous Status", Rec."Status No.");
                        Steps.FINDFIRST;
                        Steps.TESTFIELD("Permite Reaplicari");

                        PaymentLine.RESET;
                        PaymentLine.SETRANGE("No.", Rec."No.");
                        if PaymentLine.FINDSET then
                            repeat
                                PaymentLine.CALCFIELDS("Suma Aplicata");
                                if PaymentLine."Suma Aplicata" <> 0 then
                                    PaymentManagement.CreazaLiniiAplicare(Rec, false, PaymentLine."Line No.");
                            until PaymentLine.NEXT = 0;
                        MESSAGE('Dezaplicat');
                        //SSM729<<
                    end;
                }
            }
            group("P&osting")
            {
                Caption = 'P&osting';
                action("Generate file")
                {
                    ApplicationArea = All;
                    Caption = 'Generate file';
                    Image = ExportFile;
                    ToolTip = 'Executes the Generate file action.';
                    trigger OnAction()
                    begin
                        Rec.TestNbOfLines;
                        Steps.SETRANGE("Payment Class", Rec."Payment Class");
                        Steps.SETRANGE("Previous Status", Rec."Status No.");
                        Steps.SETRANGE("Action Type", Steps."Action Type"::File);
                        ValidatePayment;
                    end;
                }
                action("Validate")
                {
                    ApplicationArea = All;
                    Caption = 'Validate';
                    Image = Approval;
                    Promoted = true;
                    PromotedCategory = New;
                    ToolTip = 'Executes the Validate action.';
                    trigger OnAction()
                    var
                        Steps2: Record "SSA Payment Step";
                    begin
                        Rec.TestNbOfLines;
                        Steps.SETRANGE("Payment Class", Rec."Payment Class");
                        Steps.SETRANGE("Previous Status", Rec."Status No.");
                        Steps.SETFILTER("Action Type", '<>%1&<>%2&<>%3', Steps."Action Type"::Report, Steps."Action Type"::File, Steps."Action Type"::
                          "Create new Document");

                        //SSM729>>
                        Steps.FINDFIRST;

                        Steps2.RESET;
                        Steps2.SETRANGE("Payment Class", Rec."Payment Class");
                        Steps2.FINDFIRST;

                        //IF Steps.Line = Steps2.Line THEN
                        //    CustCheckCrLimit.PaymentHeaderCheck(Rec);
                        //SSM729<<

                        ValidatePayment;
                    end;
                }
            }
            action("Payments Lists")
            {
                ApplicationArea = All;
                Caption = 'Payments Lists';
                Image = Payment;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Report "SSA Payment List";
                ToolTip = 'Executes the Payments Lists action.';
            }
        }
    }

    trigger OnAfterGetRecord()
    var
        PaymentStatus: Record "SSA Payment Status";
    begin
        if not PaymentStatus.Get(Rec."Payment Class", Rec."Status No.") then
            clear(PaymentStep);
        PaymentEditable := PaymentStatus."Allow Edit Payment No.";
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        CurrPage.Lines.PAGE.VisibleEditable;
    end;

    var
        ChangeExchangeRate: Page "Change Exchange Rate";
        Navigate: Page Navigate;
        Steps: Record "SSA Payment Step";
        PaymentStep: Record "SSA Payment Step";
        UserMgt: Codeunit "User Setup Management";
        PaymentManagement: Codeunit "SSA Payment Management";

        PaymentEditable: Boolean;
        Text001: Label 'This payment class doesn''t authorize vendor suggestions';
        Text002: Label 'This payment class doesn''t authorize customer suggestions';
        Text003: Label 'We cannot do suggestion on a validated header';
        Text004: Label 'We cannot do attribution no. on a validated header';
        Text005: Label 'This document has no line. You cannot archive it. You must delete it.';
        Text006: Label 'One line is not posted. Are you sure you wants to archive this document?';
        Text007: Label 'Some lines are not posted. Are you sure you wants to archive this document?';
        Text008: Label 'Are you sure you want to archive this document?';
        Text009: Label 'Do you wish to archive this document?';
        Text010: Label 'You cannot perform this action for this step. Please choose a valid option.';

    procedure ValidatePayment()
    var
        Ok: Boolean;
        PostingStatement: Codeunit "SSA Payment Management";
        Options: Text[250];
        Choice: Integer;
        I: Integer;
    begin
        I := Steps.COUNT;
        Ok := false;
        if I = 1 then begin
            Steps.FIND('-');
            Ok := CONFIRM(Steps.Name, true);
        end else
            if I > 1 then begin
                if Steps.FIND('-') then begin
                    repeat
                        if Options = '' then
                            Options := Steps.Name
                        else
                            Options := Options + ',' + Steps.Name;
                    until Steps.NEXT = 0;

                    Choice := STRMENU(Options, 1);

                    I := 1;
                    if Choice > 0 then begin
                        Ok := true;
                        Steps.FIND('-');
                        while Choice > I do begin
                            I += 1;
                            Steps.NEXT;
                        end;
                    end;
                end;
            end;
        if Ok then
            PostingStatement.Valbord(Rec, Steps)
        else
            if I = 0 then
                ERROR(Text010);
    end;

    local procedure DocumentDateOnAfterValidate()
    begin
        CurrPage.UPDATE;
    end;
}
