page 70500 "SSA CEC & BO Customer"
{
    // SSM729 SSCAT 21.06.2018 Nr.crt.76-Limita valorica pentru instrumente de plata neincasate- fin

    Caption = 'CEC & BO';
    DataCaptionFields = "Customer No.";
    DelayedInsert = true;
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = List;
    Permissions = TableData "Cust. Ledger Entry" = rim;
    SaveValues = true;
    SourceTable = "Cust. Ledger Entry";
    SourceTableView = SORTING("Customer No.", "Due Date", "Entry No.") ORDER(Ascending);

    layout
    {
        area(content)
        {
            group(Optiuni)
            {
                field("Instrument de plata"; TipInstrPlata)
                {
                    ApplicationArea = All;
                    Caption = 'Instrument de plata';
                    ShowMandatory = true;
                }
                field(Seria; Serie)
                {
                    ApplicationArea = All;
                    Caption = 'Seria';
                    ShowMandatory = true;

                    trigger OnValidate()
                    begin
                        CurrPage.UPDATE(FALSE);
                    end;
                }
                field(Nr; Numar)
                {
                    ApplicationArea = All;
                    Caption = 'Numar';
                    ShowMandatory = true;

                    trigger OnValidate()
                    begin
                        CurrPage.UPDATE(FALSE);
                    end;
                }
                field(Suma; SumaCECBO)
                {
                    ApplicationArea = All;
                    Caption = 'Amount';
                    ShowMandatory = true;

                    trigger OnValidate()
                    begin
                        TempCLE.RESET;
                        TempCLE.DELETEALL;
                        CurrPage.UPDATE(FALSE);
                    end;
                }
                field("Data emiterii"; DocDate)
                {
                    ApplicationArea = All;
                    Caption = 'Doc. Date';
                    ShowMandatory = true;

                    trigger OnValidate()
                    begin
                        CurrPage.UPDATE(FALSE);
                    end;
                }
                field("Data scadentei"; DueDate)
                {
                    ApplicationArea = All;
                    Caption = 'Due Date';
                    ShowMandatory = true;

                    trigger OnValidate()
                    begin
                        CurrPage.UPDATE(FALSE);
                    end;
                }
                field("Exclude lines with remaining amount payment tool zero"; DontShowLinesWithZero)
                {
                    ApplicationArea = All;
                    Caption = 'Exclude lines with remaining amount zero';

                    trigger OnValidate()
                    begin
                        IF NOT DontShowLinesWithZero THEN
                            CLEARMARKS;
                        IF FINDFIRST THEN
                            REPEAT
                                CALCFIELDS("Remaining Amount", "SSA Applied Amount CEC/BO");
                                IF ("Remaining Amount" - "SSA Applied Amount CEC/BO") > 0 THEN
                                    MARK(TRUE);
                            UNTIL NEXT = 0;
                        IF DontShowLinesWithZero THEN
                            MARKEDONLY(TRUE)
                        ELSE
                            MARKEDONLY(FALSE);
                        IF FINDFIRST THEN;
                        CurrPage.UPDATE(FALSE);
                    end;
                }
            }
            repeater(Control1)
            {
                ShowCaption = false;
                field("Posting Date"; "Posting Date")
                {
                    ApplicationArea = All;
                    Caption = 'Document Date';
                    Editable = false;
                }
                field("Document No."; "Document No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ShowMandatory = true;
                }
                field("Original Amount"; "Original Amount")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Original Amt. (LCY)"; "Original Amt. (LCY)")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                }
                field(Amount; Amount)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Amount (LCY)"; "Amount (LCY)")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                }
                field("Remaining Amount"; "Remaining Amount")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Remaining Amt. (LCY)"; "Remaining Amt. (LCY)")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                }
                field("Due Date"; "Due Date")
                {
                    ApplicationArea = All;
                }
                field(Open; Open)
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                }
                field("On Hold"; "On Hold")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("User ID"; "User ID")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                }
                field("Entry No."; "Entry No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                }
                field(ZileDepasireScadenta; ZileDepasireScadenta)
                {
                    ApplicationArea = All;
                    Caption = 'Zile depasire scadenta';
                }
                field("Payment Tools Amount"; "SSA Payment Tools Amount")
                {
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        PaymentToolsAmountOnAfterValidate(Rec);
                    end;
                }
                field("SSA Applied Amount CEC/BO"; "SSA Applied Amount CEC/BO")
                {
                    ApplicationArea = All;
                }
            }
        }
        area(factboxes)
        {
            part(Control1903096107; "Customer Ledger Entry FactBox")
            {
                ApplicationArea = All;
                SubPageLink = "Entry No." = FIELD("Entry No.");
                Visible = true;
            }
            systempart(Control1900383207; Links)
            {
                Visible = false;
            }
            systempart(Control1905767507; Notes)
            {
                Visible = false;
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("Ent&ry")
            {
                Caption = 'Ent&ry';
                Image = Entry;
                action("Reminder/Fin. Charge Entries")
                {
                    ApplicationArea = All;
                    Caption = 'Reminder/Fin. Charge Entries';
                    Image = Reminder;
                    RunObject = Page "Reminder/Fin. Charge Entries";
                    RunPageLink = "Customer Entry No." = FIELD("Entry No.");
                    RunPageView = SORTING("Customer Entry No.");
                    Visible = false;
                }
                action("Applied E&ntries")
                {
                    ApplicationArea = All;
                    Caption = 'Applied E&ntries';
                    Image = Approve;
                    RunObject = Page "Applied Customer Entries";
                    RunPageOnRec = true;
                }
                action(Dimensions)
                {
                    ApplicationArea = All;
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    ShortCutKey = 'Shift+Ctrl+D';

                    trigger OnAction()
                    begin
                        ShowDimensions;
                    end;
                }
                action("Detailed &Ledger Entries")
                {
                    ApplicationArea = All;
                    Caption = 'Detailed &Ledger Entries';
                    Image = View;
                    RunObject = Page "Detailed Cust. Ledg. Entries";
                    RunPageLink = "Cust. Ledger Entry No." = FIELD("Entry No."), "Customer No." = FIELD("Customer No.");
                    RunPageView = SORTING("Cust. Ledger Entry No.", "Posting Date");
                    ShortCutKey = 'Ctrl+F7';
                }
            }
        }
        area(processing)
        {
            group(Custom)
            {
                Caption = 'F&unctions';
                Image = "Action";
                action("Apply Entries2")
                {
                    ApplicationArea = All;
                    Caption = 'Apply Entries';
                    Image = ApplyEntries;
                    ShortCutKey = 'Shift+F11';

                    trigger OnAction()
                    var
                        CustLedgEntry: Record "Cust. Ledger Entry";
                        CustEntryApplyPostEntries: Codeunit "CustEntry-Apply Posted Entries";
                    begin
                        CustLedgEntry.COPY(Rec);
                        CustEntryApplyPostEntries.ApplyCustEntryFormEntry(CustLedgEntry);
                        Rec := CustLedgEntry;
                        CurrPage.UPDATE;
                    end;
                }
                action("Creare CEC/BO")
                {
                    ApplicationArea = All;
                    trigger OnAction()
                    begin
                        CreareCEC(TipInstrPlata, Serie, Numar, DocDate, DueDate, "Customer No.");
                    end;
                }
                action("Distribuie suma")
                {
                    ApplicationArea = All;
                    Caption = 'Distribuie suma';
                    Image = Start;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    var
                        Text001_ES: Label 'You need to fill all the fields that are mandatory (*)!';
                    begin
                        DistribuieSuma(Rec, "Customer No.");
                    end;
                }
                separator(Separator45007657)
                {
                }
                action(UnapplyEntries2)
                {
                    ApplicationArea = All;
                    Caption = 'Unapply Entries';
                    Ellipsis = true;
                    Image = UnApply;

                    trigger OnAction()
                    var
                        CustEntryApplyPostedEntries: Codeunit "CustEntry-Apply Posted Entries";
                    begin
                        CustEntryApplyPostedEntries.UnApplyCustLedgEntry("Entry No.");
                    end;
                }
                separator(Separator45007655)
                {
                }
                action(ReverseTransaction2)
                {
                    ApplicationArea = All;
                    Caption = 'Reverse Transaction';
                    Ellipsis = true;
                    Image = ReverseRegister;
                    Visible = false;

                    trigger OnAction()
                    var
                        ReversalEntry: Record "Reversal Entry";
                    begin
                        CLEAR(ReversalEntry);
                        IF Reversed THEN
                            ReversalEntry.AlreadyReversedEntry(TABLECAPTION, "Entry No.");
                        IF "Journal Batch Name" = '' THEN
                            ReversalEntry.TestFieldError;
                        TESTFIELD("Transaction No.");
                        ReversalEntry.ReverseTransaction("Transaction No.");
                    end;
                }
            }
            action("&NavigateAction")
            {
                ApplicationArea = All;
                Caption = '&NavigateAction';
                Image = Navigate;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    NavigatePage: Page Navigate;
                begin
                    NavigatePage.SetDoc("Posting Date", "Document No.");
                    NavigatePage.RUN;
                end;
            }
            action("Incoming Document")
            {
                ApplicationArea = All;
                Caption = 'Incoming Document';
                Image = Document;
                Promoted = true;
                PromotedCategory = Process;
                Visible = false;

                trigger OnAction()
                var
                    IncomingDocument: Record "Incoming Document";
                begin
                    IncomingDocument.HyperlinkToDocument("Document No.", "Posting Date");
                end;
            }
        }
    }

    trigger OnModifyRecord(): Boolean
    begin
        CODEUNIT.RUN(CODEUNIT::"Cust. Entry-Edit", Rec);
        EXIT(FALSE);
    end;

    trigger OnOpenPage()
    begin
        TempCLE.RESET;
        TempCLE.DELETEALL;

        MODIFYALL("SSA Payment Tools Amount", 0);

        CLEAR(TipInstrPlata);
        CLEAR(Serie);
        CLEAR(Numar);
        CLEAR(SumaCECBO);
        CLEAR(DocDate);
        CLEAR(DueDate);
        CLEAR(DontShowLinesWithZero);
    end;

    var
        TempCLE: Record "Cust. Ledger Entry" temporary;
        TotalSumaAplicata: Decimal;
        TipInstrPlata: Option CEC,BO;
        SumaCECBO: Decimal;
        SumaAplicata: Decimal;
        SumaDeAplicat: Decimal;
        Serie: Code[20];
        Numar: Code[20];
        DocDate: Date;
        DueDate: Date;
        DontShowLinesWithZero: Boolean;
        ZileDepasireScadenta: Integer;

    local procedure PaymentToolsAmountOnAfterValidate(_CLE: Record "Cust. Ledger Entry")
    var
        Text001: Label 'Nu puteti aplica mai mult decat %1.Ati distribuit %2.';
    begin
        TempCLE.INIT;
        TempCLE.TRANSFERFIELDS(_CLE);
        TempCLE."Sales (LCY)" := _CLE."SSA Payment Tools Amount";
        IF NOT TempCLE.INSERT THEN
            TempCLE.MODIFY;

        TempCLE.RESET;
        TempCLE.SETCURRENTKEY("Customer No.", "Posting Date", "Currency Code");
        TempCLE.CALCSUMS("Sales (LCY)");
        TotalSumaAplicata := TempCLE."Sales (LCY)";
        IF TotalSumaAplicata > SumaCECBO THEN
            ERROR(Text001, SumaCECBO, TotalSumaAplicata);
    end;

    local procedure CreareCEC(_TipInstr: Option CEC,BO; _Serie: Code[20]; _Numar: Code[20]; _DocDate: Date; _DueDate: Date; _CustomerNo: Code[20])
    var
        PaymentHeader: Record "SSA Payment Header";
        PaymentClass: Record "SSA Payment Class";
        Cust: Record Customer;
        PaymentLine: Record "SSA Payment Line";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        LineNo: Integer;
    begin
        IF _Serie = '' THEN
            ERROR('Completati campurile obligatorii');
        IF _Numar = '' THEN
            ERROR('Completati campurile obligatorii');
        IF _DocDate = 0D THEN
            ERROR('Completati campurile obligatorii');
        IF _DueDate = 0D THEN
            ERROR('Completati campurile obligatorii');
        IF SumaCECBO = 0 THEN
            ERROR('Completati campurile obligatorii');

        PaymentClass.RESET;
        IF _TipInstr = _TipInstr::CEC THEN BEGIN
            PaymentClass.SETRANGE(Suggestions, PaymentClass.Suggestions::Customer);
            PaymentClass.SETRANGE("Payment Tools", PaymentClass."Payment Tools"::CEC);
        END;
        IF _TipInstr = _TipInstr::BO THEN BEGIN
            PaymentClass.SETRANGE(Suggestions, PaymentClass.Suggestions::Customer);
            PaymentClass.SETRANGE("Payment Tools", PaymentClass."Payment Tools"::BO);
        END;
        PaymentClass.FINDFIRST;

        Cust.GET(_CustomerNo);

        PaymentHeader.RESET;
        PaymentHeader.SETRANGE("Payment Series", _Serie);
        PaymentHeader.SETRANGE("Payment Number", _Numar);
        IF NOT PaymentHeader.ISEMPTY THEN
            ERROR('Exista deja seria %1 si numar %2', _Serie, _Numar);

        PaymentHeader.INIT;
        NoSeriesMgt.InitSeries(PaymentClass."Header No. Series", '', 0D, PaymentHeader."No.", PaymentClass."Header No. Series");
        PaymentHeader.INSERT(TRUE);
        PaymentHeader.VALIDATE("No. Series", PaymentClass."Header No. Series");
        PaymentHeader.VALIDATE("Payment Class", PaymentClass.Code);
        PaymentHeader."Payment Series" := _Serie;
        PaymentHeader."Payment Number" := _Numar;
        IF _DocDate <> 0D THEN
            PaymentHeader.VALIDATE("Document Date", _DocDate)
        ELSE
            PaymentHeader.VALIDATE("Document Date", TODAY);

        PaymentHeader.MODIFY(TRUE);

        //creare linii efect de plata
        LineNo := 0;
        TempCLE.RESET;
        TempCLE.SETFILTER("Sales (LCY)", '<>%1', 0);
        IF TempCLE.FINDSET THEN
            REPEAT
                LineNo += 10000;
                PaymentLine.INIT;
                PaymentLine.VALIDATE("No.", PaymentHeader."No.");
                PaymentLine."Line No." := LineNo;
                PaymentLine.INSERT(TRUE);
                PaymentLine.VALIDATE("Account Type", PaymentLine."Account Type"::Customer);
                PaymentLine.VALIDATE("Account No.", _CustomerNo);
                PaymentLine.VALIDATE("Document ID", PaymentHeader."No.");
                PaymentLine.VALIDATE("Posting Group", TempCLE."Customer Posting Group");
                PaymentLine."Due Date" := _DueDate;
                PaymentLine."Posting Date" := _DocDate;
                PaymentLine."Applies-to Doc. Type" := PaymentLine."Applies-to Doc. Type"::Invoice;
                PaymentLine.VALIDATE("Applies-to Doc. No.", TempCLE."Document No.");
                PaymentLine.VALIDATE("Credit Amount", TempCLE."Sales (LCY)");
                PaymentLine.VALIDATE("Salesperson/Purchaser Code", TempCLE."Salesperson Code");
                PaymentLine.MODIFY(TRUE);
            UNTIL TempCLE.NEXT = 0;

        PAGE.RUN(PAGE::"SSA Payment Headers", PaymentHeader);
    end;

    local procedure DistribuieSuma(var _CLE: Record "Cust. Ledger Entry"; _CustomerNo: Code[20])
    var
        CLE: Record "Cust. Ledger Entry";
        SumaNeacoperita: Decimal;
    begin
        TempCLE.RESET;
        TempCLE.DELETEALL;

        SumaAplicata := 0;
        SumaDeAplicat := 0;

        IF DontShowLinesWithZero THEN
            _CLE.MARKEDONLY(TRUE)
        ELSE
            _CLE.MARKEDONLY(FALSE);

        IF _CLE.FINDSET THEN BEGIN
            REPEAT
                _CLE.CALCFIELDS("Remaining Amount", "SSA Applied Amount CEC/BO");
                SumaNeacoperita := (_CLE."Remaining Amount" - _CLE."SSA Applied Amount CEC/BO");
                SumaDeAplicat := SumaCECBO - SumaAplicata;
                IF SumaNeacoperita <> 0 THEN BEGIN
                    IF SumaNeacoperita < SumaDeAplicat THEN
                        _CLE.VALIDATE("SSA Payment Tools Amount", SumaNeacoperita)
                    ELSE
                        _CLE.VALIDATE("SSA Payment Tools Amount", SumaDeAplicat);
                    _CLE.MODIFY(TRUE);
                    PaymentToolsAmountOnAfterValidate(_CLE);
                    SumaDeAplicat := SumaDeAplicat - _CLE."SSA Payment Tools Amount";
                    SumaAplicata += _CLE."SSA Payment Tools Amount";
                END;
            UNTIL (_CLE.NEXT = 0) OR (SumaDeAplicat = 0);
        END;

        IF SumaDeAplicat <> 0 THEN BEGIN
            CLE.RESET;
            CLE.INIT;
            CLE."Entry No." := 0;
            CLE."SSA Payment Tools Amount" := SumaDeAplicat;
            PaymentToolsAmountOnAfterValidate(CLE);
            MESSAGE('Suma distribuita %1 din total %2', SumaAplicata, SumaCECBO);
        END ELSE
            MESSAGE('Suma a fost distribuita in totalitate.');
    end;
}

