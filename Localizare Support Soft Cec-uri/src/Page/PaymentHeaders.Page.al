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
                field("No."; "No.")
                {
                    ApplicationArea = All;
                    AssistEdit = false;

                    trigger OnAssistEdit()
                    begin
                        IF AssistEdit(xRec) THEN
                            CurrPage.UPDATE;
                    end;
                }
                field("Payment Class"; "Payment Class")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Lookup = false;
                }
                field("Payment Class Name"; "Payment Class Name")
                {
                    ApplicationArea = All;
                    DrillDown = false;
                    Editable = false;
                }
                field("Status Name"; "Status Name")
                {
                    ApplicationArea = All;
                    DrillDown = false;
                    Editable = false;
                }
                field("Currency Code"; "Currency Code")
                {
                    ApplicationArea = All;
                    trigger OnAssistEdit()
                    begin
                        ChangeExchangeRate.SetParameter("Currency Code", "Currency Factor", "Posting Date");
                        IF ChangeExchangeRate.RUNMODAL = ACTION::OK THEN BEGIN
                            VALIDATE("Currency Factor", ChangeExchangeRate.GetParameter);
                            CurrPage.UPDATE;
                        END;
                        CLEAR(ChangeExchangeRate);
                    end;
                }
                field("Posting Date"; "Posting Date")
                {
                    ApplicationArea = All;
                }
                field("Document Date"; "Document Date")
                {
                    ApplicationArea = All;
                    trigger OnValidate()
                    begin
                        DocumentDateOnAfterValidate;
                    end;
                }
                field("Amount (LCY)"; "Amount (LCY)")
                {
                    ApplicationArea = All;
                }
                field("Suma Aplicata"; "Suma Aplicata")
                {
                    ApplicationArea = All;
                }
                field("Account Type"; "Account Type")
                {
                    ApplicationArea = All;
                }
                field("Account No."; "Account No.")
                {
                    ApplicationArea = All;
                }
                field(Girat; Girat)
                {
                    ApplicationArea = All;
                }
                field("Payment Series"; "Payment Series")
                {
                    ApplicationArea = All;
                    Editable = PaymentEditable;
                }
                field("Payment Number"; "Payment Number")
                {
                    ApplicationArea = All;
                    Editable = PaymentEditable;
                }

            }
            part(Lines; "SSA Payment Lines")
            {
                ApplicationArea = All;
                SubPageLink = "No." = FIELD("No.");
                UpdatePropagation = Both;
            }
            group(Posting)
            {
                Caption = 'Posting';
                Visible = false;
                field("Source Code"; "Source Code")
                {
                    ApplicationArea = All;
                }
                field("Shortcut Dimension 1 Code"; "Shortcut Dimension 1 Code")
                {
                    ApplicationArea = All;
                }
                field("Shortcut Dimension 2 Code"; "Shortcut Dimension 2 Code")
                {
                    ApplicationArea = All;
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
                    Enabled = "No." <> '';
                    Image = Dimensions;
                    ShortCutKey = 'Shift+Ctrl+D';
                    ToolTip = 'View or edits dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyze transaction history.';

                    trigger OnAction()
                    begin
                        //SSM729>>
                        ShowDocDim;
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
                    RunPageLink = "No." = FIELD("No.");
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

                    trigger OnAction()
                    var
                        PaymentManagement: Codeunit "SSA Payment Management";
                    begin
                        PaymentManagement.LinesInsert("No.");
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

                    trigger OnAction()
                    begin
                        Navigate.SetDoc("Posting Date", "No.");
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

                    trigger OnAction()
                    var
                        PaymentClass: Record "SSA Payment Class";
                        CreateVendorPmtSuggestion: Report "SSA Suggest Vendor Payments";
                    begin
                        IF "Status No." <> 0 THEN
                            MESSAGE(Text003)
                        ELSE
                            IF PaymentClass.GET("Payment Class") THEN
                                IF PaymentClass.Suggestions = PaymentClass.Suggestions::Vendor THEN BEGIN
                                    CreateVendorPmtSuggestion.SetGenPayLine(Rec);
                                    CreateVendorPmtSuggestion.RUNMODAL;
                                    CLEAR(CreateVendorPmtSuggestion);
                                END ELSE
                                    MESSAGE(Text001);
                    end;
                }
                action("Propose &customer payments")
                {
                    ApplicationArea = All;
                    Caption = 'Propose &customer payments';
                    Image = SuggestCustomerPayments;

                    trigger OnAction()
                    var
                        PaymentClass: Record "SSA Payment Class";
                        CreateCustomerPmtSuggestion: Report "SSA Suggest Customer Payments";
                    begin
                        IF "Status No." <> 0 THEN
                            MESSAGE(Text003)
                        ELSE
                            IF PaymentClass.GET("Payment Class") THEN
                                IF PaymentClass.Suggestions = PaymentClass.Suggestions::Customer THEN BEGIN
                                    CreateCustomerPmtSuggestion.SetGenPayLine(Rec);
                                    CreateCustomerPmtSuggestion.RUNMODAL;
                                    CLEAR(CreateCustomerPmtSuggestion);
                                END ELSE
                                    MESSAGE(Text002);
                    end;
                }
                action("Set Document ID")
                {
                    ApplicationArea = All;
                    Caption = 'Set Document ID';
                    Image = Document;

                    trigger OnAction()
                    begin
                        IF "Status No." <> 0 THEN
                            MESSAGE(Text004)
                        ELSE
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

                    trigger OnAction()
                    var
                        Archive: Boolean;
                        PaymtManagt: Codeunit "SSA Payment Management";
                    begin
                        IF "No." = '' THEN
                            EXIT;
                        IF NOT CONFIRM(Text009) THEN
                            EXIT;
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

                    trigger OnAction()
                    begin
                        //SSM729>>
                        Steps.SETRANGE("Payment Class", "Payment Class");
                        Steps.SETRANGE("Previous Status", "Status No.");
                        Steps.FINDFIRST;
                        Steps.TESTFIELD("Permite Reaplicari");

                        CALCFIELDS("Suma Aplicata");
                        IF "Suma Aplicata" <> 0 THEN
                            ERROR('Trebuie dezaplicare pentru a fi reaplicat');

                        PaymentManagement.CreazaLiniiAplicare(Rec, TRUE, 0);
                        MESSAGE('Aplicat');
                        //SSM729<<
                    end;
                }
                action(Dezaplicare)
                {
                    ApplicationArea = All;
                    Caption = 'UnApply';
                    Image = UnApply;

                    trigger OnAction()
                    var
                        PaymentLine: Record "SSA Payment Line";
                    begin
                        //SSM729>>
                        Steps.SETRANGE("Payment Class", "Payment Class");
                        Steps.SETRANGE("Previous Status", "Status No.");
                        Steps.FINDFIRST;
                        Steps.TESTFIELD("Permite Reaplicari");

                        PaymentLine.RESET;
                        PaymentLine.SETRANGE("No.", "No.");
                        IF PaymentLine.FINDSET THEN
                            REPEAT
                                PaymentLine.CALCFIELDS("Suma Aplicata");
                                IF PaymentLine."Suma Aplicata" <> 0 THEN
                                    PaymentManagement.CreazaLiniiAplicare(Rec, FALSE, PaymentLine."Line No.");

                            UNTIL PaymentLine.NEXT = 0;
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

                    trigger OnAction()
                    begin
                        TestNbOfLines;
                        Steps.SETRANGE("Payment Class", "Payment Class");
                        Steps.SETRANGE("Previous Status", "Status No.");
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

                    trigger OnAction()
                    var
                        Steps2: Record "SSA Payment Step";
                    begin
                        TestNbOfLines;
                        Steps.SETRANGE("Payment Class", "Payment Class");
                        Steps.SETRANGE("Previous Status", "Status No.");
                        Steps.SETFILTER("Action Type", '<>%1&<>%2&<>%3', Steps."Action Type"::Report, Steps."Action Type"::File, Steps."Action Type"::
                          "Create new Document");

                        //SSM729>>
                        Steps.FINDFIRST;

                        Steps2.RESET;
                        Steps2.SETRANGE("Payment Class", "Payment Class");
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
            }
        }
    }

    trigger OnAfterGetRecord()
    var
        PaymentStatus: Record "SSA Payment Status";
    begin
        if not PaymentStatus.Get("Payment Class", "Status No.") then
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
        [indataset]
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
        Ok := FALSE;
        IF I = 1 THEN BEGIN
            Steps.FIND('-');
            Ok := CONFIRM(Steps.Name, TRUE);
        END ELSE
            IF I > 1 THEN BEGIN
                IF Steps.FIND('-') THEN BEGIN
                    REPEAT
                        IF Options = '' THEN
                            Options := Steps.Name
                        ELSE
                            Options := Options + ',' + Steps.Name;
                    UNTIL Steps.NEXT = 0;

                    Choice := STRMENU(Options, 1);

                    I := 1;
                    IF Choice > 0 THEN BEGIN
                        Ok := TRUE;
                        Steps.FIND('-');
                        WHILE Choice > I DO BEGIN
                            I += 1;
                            Steps.NEXT;
                        END;
                    END;
                END;
            END;
        IF Ok THEN
            PostingStatement.Valbord(Rec, Steps)
        ELSE
            IF I = 0 THEN
                ERROR(Text010);
    end;

    local procedure DocumentDateOnAfterValidate()
    begin
        CurrPage.UPDATE;
    end;
}
