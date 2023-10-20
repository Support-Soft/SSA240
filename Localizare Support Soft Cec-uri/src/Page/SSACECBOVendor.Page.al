page 70502 "SSA CEC & BO Vendor"
{
    // SSM845 SSCAT 25.07.2018 meeting financiar 200718

    Caption = 'CEC & BO Furnizor';
    DataCaptionFields = "Vendor No.";
    DelayedInsert = true;
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = List;
    Permissions = tabledata "Vendor Ledger Entry" = rm;
    SaveValues = true;
    SourceTable = "Vendor Ledger Entry";
    SourceTableView = sorting("Vendor No.", "Due Date", "Entry No.") order(ascending);
    ApplicationArea = All;

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
                    ToolTip = 'Specifies the value of the Instrument de plata field.';
                }
                field(Seria; Serie)
                {
                    ApplicationArea = All;
                    Caption = 'Seria';
                    ShowMandatory = true;
                    ToolTip = 'Specifies the value of the Seria field.';
                    trigger OnValidate()
                    begin
                        CurrPage.UPDATE(false);
                    end;
                }
                field(Nr; Numar)
                {
                    ApplicationArea = All;
                    Caption = 'Numar';
                    ShowMandatory = true;
                    ToolTip = 'Specifies the value of the Numar field.';
                    trigger OnValidate()
                    begin
                        CurrPage.UPDATE(false);
                    end;
                }
                field(Suma; SumaCECBO)
                {
                    ApplicationArea = All;
                    Caption = 'Amount';
                    ShowMandatory = true;
                    ToolTip = 'Specifies the value of the Amount field.';
                    trigger OnValidate()
                    begin
                        TempVLE.RESET;
                        TempVLE.DELETEALL;
                        CurrPage.UPDATE(false);
                    end;
                }
                field("Data emiterii"; DocDate)
                {
                    ApplicationArea = All;
                    Caption = 'Doc. Date';
                    ShowMandatory = true;
                    ToolTip = 'Specifies the value of the Doc. Date field.';
                    trigger OnValidate()
                    begin
                        CurrPage.UPDATE(false);
                    end;
                }
                field("Data scadentei"; DueDate)
                {
                    ApplicationArea = All;
                    Caption = 'Due Date';
                    ShowMandatory = true;
                    ToolTip = 'Specifies the value of the Due Date field.';
                    trigger OnValidate()
                    begin
                        CurrPage.UPDATE(false);
                    end;
                }
                field("Exclude lines with remaining amount payment tool zero"; DontShowLinesWithZero)
                {
                    ApplicationArea = All;
                    Caption = 'Exclude lines with remaining amount zero';
                    ToolTip = 'Specifies the value of the Exclude lines with remaining amount zero field.';
                    trigger OnValidate()
                    begin
                        if not DontShowLinesWithZero then
                            Rec.CLEARMARKS;
                        if Rec.FINDFIRST then
                            repeat
                                Rec.CALCFIELDS("Remaining Amount", "SSA Applied Amount CEC/BO");
                                if (-Rec."Remaining Amount" + Rec."SSA Applied Amount CEC/BO") > 0 then
                                    Rec.MARK(true);
                            until Rec.NEXT = 0;
                        if DontShowLinesWithZero then
                            Rec.MARKEDONLY(true)
                        else
                            Rec.MARKEDONLY(false);
                        if Rec.FINDFIRST then;
                        CurrPage.UPDATE(false);
                    end;
                }
            }
            repeater(Control1)
            {
                ShowCaption = false;
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = All;
                    Caption = 'Document Date';
                    Editable = false;
                    ToolTip = 'Specifies the vendor entry''s posting date.';
                }
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ShowMandatory = true;
                    ToolTip = 'Specifies the vendor entry''s document number.';
                }
                field("External Document No."; Rec."External Document No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies a document number that refers to the customer''s or vendor''s numbering system.';
                }
                field("Original Amount"; Rec."Original Amount")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the amount of the original entry.';
                }
                field("Original Amt. (LCY)"; Rec."Original Amt. (LCY)")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                    ToolTip = 'Specifies the amount that the entry originally consisted of, in LCY.';
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the amount of the entry.';
                }
                field("Amount (LCY)"; Rec."Amount (LCY)")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                    ToolTip = 'Specifies the amount of the entry in LCY.';
                }
                field("Remaining Amount"; Rec."Remaining Amount")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the amount that remains to be applied to before the entry is totally applied to.';
                }
                field("Remaining Amt. (LCY)"; Rec."Remaining Amt. (LCY)")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                    ToolTip = 'Specifies the net amount of in the local currency. The amount is calculated using the Remaining Quantity, Line Discount %, and Unit Price (LCY) fields. ';
                }
                field("Due Date"; Rec."Due Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the due date on the entry.';
                }
                field(Open; Rec.Open)
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                    ToolTip = 'Specifies whether the amount on the entry has been fully paid or there is still a remaining amount that must be applied to.';
                }
                field("On Hold"; Rec."On Hold")
                {
                    ApplicationArea = All;
                    Visible = false;
                    ToolTip = 'Specifies that the related entry represents an unpaid invoice for which either a payment suggestion, a reminder, or a finance charge memo exists.';
                }
                field("User ID"; Rec."User ID")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                    ToolTip = 'Specifies the ID of the user who posted the entry, to be used, for example, in the change log.';
                }
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                    ToolTip = 'Specifies the number of the entry, as assigned from the specified number series when the entry was created.';
                }
                field(ZileDepasireScadenta; ZileDepasireScadenta)
                {
                    ApplicationArea = All;
                    Caption = 'Zile depasire scadenta';
                    ToolTip = 'Specifies the value of the Zile depasire scadenta field.';
                }
                field("SSA Payment Tools Amount"; Rec."SSA Payment Tools Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Payment Tools Amount field.';
                    trigger OnValidate()
                    begin
                        PaymentToolsAmountOnAfterValidate(Rec);
                    end;
                }
                field("SSA Applied Amount CEC/BO"; Rec."SSA Applied Amount CEC/BO")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Applied Amount CEC/BO field.';
                }
            }
        }
        area(factboxes)
        {
            part(Control1903096107; "Customer Ledger Entry FactBox")
            {
                ApplicationArea = All;
                SubPageLink = "Entry No." = field("Entry No.");
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

                action("Applied E&ntries")
                {
                    ApplicationArea = All;
                    Caption = 'Applied E&ntries';
                    Image = Approve;
                    RunObject = page "Applied Vendor Entries";
                    RunPageOnRec = true;
                    ToolTip = 'Executes the Applied E&ntries action.';
                }
                action(Dimensions)
                {
                    ApplicationArea = All;
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    ShortcutKey = 'Shift+Ctrl+D';
                    ToolTip = 'Executes the Dimensions action.';
                    trigger OnAction()
                    begin
                        Rec.ShowDimensions;
                    end;
                }
                action("Detailed &Ledger Entries")
                {
                    ApplicationArea = All;
                    Caption = 'Detailed &Ledger Entries';
                    Image = View;
                    RunObject = page "Detailed Vendor Ledg. Entries";
                    RunPageLink = "Vendor Ledger Entry No." = field("Entry No."), "Vendor No." = field("Vendor No.");
                    RunPageView = sorting("Vendor Ledger Entry No.", "Posting Date");
                    ShortcutKey = 'Ctrl+F7';
                    ToolTip = 'Executes the Detailed &Ledger Entries action.';
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
                    ShortcutKey = 'Shift+F11';
                    ToolTip = 'Executes the Apply Entries action.';
                    trigger OnAction()
                    var
                        VendorLedgerEntry: Record "Vendor Ledger Entry";
                        VendEntryApplyPostedEntries: Codeunit "VendEntry-Apply Posted Entries";
                    begin
                        VendorLedgerEntry.COPY(Rec);
                        VendEntryApplyPostedEntries.ApplyVendEntryFormEntry(VendorLedgerEntry);
                        Rec := VendorLedgerEntry;
                        CurrPage.UPDATE;
                    end;
                }
                action("Creare CEC/BO")
                {
                    ApplicationArea = All;
                    ToolTip = 'Executes the Creare CEC/BO action.';
                    trigger OnAction()
                    begin
                        CreareCEC(TipInstrPlata, Serie, Numar, DocDate, DueDate, Rec."Vendor No.");
                    end;
                }
                action("Distribuie suma")
                {
                    ApplicationArea = All;
                    Caption = 'Distribuie suma';
                    Image = Start;
                    Promoted = true;
                    PromotedCategory = Process;
                    ToolTip = 'Executes the Distribuie suma action.';
                    trigger OnAction()
                    var
                        Text001_ES: Label 'You need to fill all the fields that are mandatory (*)!';
                    begin
                        DistribuieSuma(Rec, Rec."Vendor No.");
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
                    ToolTip = 'Executes the Unapply Entries action.';
                    trigger OnAction()
                    var
                        VendEntryApplyPostedEntries: Codeunit "VendEntry-Apply Posted Entries";
                    begin
                        VendEntryApplyPostedEntries.UnApplyVendLedgEntry(Rec."Entry No.");
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
                    ToolTip = 'Executes the Reverse Transaction action.';
                    trigger OnAction()
                    var
                        ReversalEntry: Record "Reversal Entry";
                    begin
                        CLEAR(ReversalEntry);
                        if Rec.Reversed then
                            ReversalEntry.AlreadyReversedEntry(Rec.TABLECAPTION, Rec."Entry No.");
                        if Rec."Journal Batch Name" = '' then
                            ReversalEntry.TestFieldError;
                        Rec.TESTFIELD("Transaction No.");
                        ReversalEntry.ReverseTransaction(Rec."Transaction No.");
                    end;
                }
            }
            action("&Navigate")
            {
                ApplicationArea = All;
                Caption = '&Navigate';
                Image = Navigate;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Executes the &Navigate action.';
                trigger OnAction()
                begin
                    Navigate.SetDoc(Rec."Posting Date", Rec."Document No.");
                    Navigate.RUN;
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
                ToolTip = 'Executes the Incoming Document action.';
                trigger OnAction()
                var
                    IncomingDocument: Record "Incoming Document";
                begin
                    IncomingDocument.HyperlinkToDocument(Rec."Document No.", Rec."Posting Date");
                end;
            }
        }
    }

    trigger OnModifyRecord(): Boolean
    begin
        CODEUNIT.RUN(CODEUNIT::"Vend. Entry-Edit", Rec);
        exit(false);
    end;

    trigger OnOpenPage()
    begin
        TempVLE.RESET;
        TempVLE.DELETEALL;

        Rec.MODIFYALL("SSA Payment Tools Amount", 0);

        CLEAR(TipInstrPlata);
        CLEAR(Serie);
        CLEAR(Numar);
        CLEAR(SumaCECBO);
        CLEAR(DocDate);
        CLEAR(DueDate);
        CLEAR(DontShowLinesWithZero);
    end;

    var
        TempVLE: Record "Vendor Ledger Entry" temporary;
        TotalSumaAplicata: Decimal;
        TipInstrPlata: Option CEC,BO;
        SumaCECBO: Decimal;
        SumaAplicata: Decimal;
        SumaDeAplicat: Decimal;
        Serie: Code[20];
        Numar: Code[20];
        DocDate: Date;
        DueDate: Date;
        Navigate: Page Navigate;
        DontShowLinesWithZero: Boolean;
        ZileDepasireScadenta: Integer;

    local procedure PaymentToolsAmountOnAfterValidate(_VLE: Record "Vendor Ledger Entry")
    var
        Text001: Label 'Nu puteti aplica mai mult decat %1.Ati distribuit %2.';
    begin
        TempVLE.INIT;
        TempVLE.TRANSFERFIELDS(_VLE);
        TempVLE."Purchase (LCY)" := _VLE."SSA Payment Tools Amount";
        if not TempVLE.INSERT then
            TempVLE.MODIFY;

        TempVLE.RESET;
        TempVLE.SETCURRENTKEY("Vendor No.", "Posting Date", "Currency Code");
        TempVLE.CALCSUMS("Purchase (LCY)");
        TotalSumaAplicata := TempVLE."Purchase (LCY)";
        if TotalSumaAplicata > SumaCECBO then
            ERROR(Text001, SumaCECBO, TotalSumaAplicata);
    end;

    local procedure CreareCEC(_TipInstr: Option CEC,BO; _Serie: Code[20]; _Numar: Code[20]; _DocDate: Date; _DueDate: Date; _VendorNo: Code[20])
    var
        PaymentHeader: Record "SSA Payment Header";
        PaymentClass: Record "SSA Payment Class";
        Vend: Record Vendor;
        PaymentLine: Record "SSA Payment Line";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        LineNo: Integer;
    begin
        if _Serie = '' then
            ERROR('Completati campurile obligatorii');
        if _Numar = '' then
            ERROR('Completati campurile obligatorii');
        if _DocDate = 0D then
            ERROR('Completati campurile obligatorii');
        if _DueDate = 0D then
            ERROR('Completati campurile obligatorii');
        if SumaCECBO = 0 then
            ERROR('Completati campurile obligatorii');

        PaymentClass.RESET;
        if _TipInstr = _TipInstr::CEC then begin
            PaymentClass.SETRANGE(Suggestions, PaymentClass.Suggestions::Vendor);
            PaymentClass.SETRANGE("Payment Tools", PaymentClass."Payment Tools"::CEC);
        end;
        if _TipInstr = _TipInstr::BO then begin
            PaymentClass.SETRANGE(Suggestions, PaymentClass.Suggestions::Vendor);
            PaymentClass.SETRANGE("Payment Tools", PaymentClass."Payment Tools"::BO);
        end;
        PaymentClass.FINDFIRST;

        Vend.GET(_VendorNo);
        //Vend.TESTFIELD("Responsibility Center");

        PaymentHeader.RESET;
        PaymentHeader.SETRANGE("Payment Series", _Serie);
        PaymentHeader.SETRANGE("Payment Number", _Numar);
        if not PaymentHeader.ISEMPTY then
            ERROR('Exista deja seria %1 si numar %2', _Serie, _Numar);

        PaymentHeader.INIT;
        NoSeriesMgt.InitSeries(PaymentClass."Header No. Series", '', 0D, PaymentHeader."No.", PaymentClass."Header No. Series");
        PaymentHeader.INSERT(true);
        PaymentHeader.VALIDATE("No. Series", PaymentClass."Header No. Series");
        PaymentHeader.VALIDATE("Payment Class", PaymentClass.Code);
        PaymentHeader."Payment Series" := _Serie;
        PaymentHeader."Payment Number" := _Numar;
        //PaymentHeader.VALIDATE("Responsibility Center",Vend."Responsibility Center");
        if _DocDate <> 0D then
            PaymentHeader.VALIDATE("Document Date", _DocDate)
        else
            PaymentHeader.VALIDATE("Document Date", TODAY);

        PaymentHeader.MODIFY(true);

        //creare linii efect de plata
        LineNo := 0;
        TempVLE.RESET;
        TempVLE.SETFILTER("Purchase (LCY)", '<>%1', 0);
        if TempVLE.FINDSET then
            repeat
                LineNo += 10000;
                PaymentLine.INIT;
                PaymentLine.VALIDATE("No.", PaymentHeader."No.");
                PaymentLine."Line No." := LineNo;
                PaymentLine.INSERT(true);
                PaymentLine.VALIDATE("Account Type", PaymentLine."Account Type"::Vendor);
                PaymentLine.VALIDATE("Account No.", _VendorNo);
                PaymentLine.VALIDATE("Document ID", PaymentHeader."No.");
                PaymentLine.VALIDATE("Posting Group", TempVLE."Vendor Posting Group");
                PaymentLine."Due Date" := _DueDate;
                PaymentLine."Posting Date" := _DocDate;
                PaymentLine."Applies-to Doc. Type" := PaymentLine."Applies-to Doc. Type"::Invoice;
                PaymentLine.VALIDATE("Applies-to Doc. No.", TempVLE."Document No.");
                PaymentLine.VALIDATE("Debit Amount", TempVLE."Purchase (LCY)");
                PaymentLine.VALIDATE("Salesperson/Purchaser Code", TempVLE."Purchaser Code");
                PaymentLine.MODIFY(true);
            until TempVLE.NEXT = 0;

        PAGE.RUN(PAGE::"SSA Payment Headers", PaymentHeader);
    end;

    local procedure DistribuieSuma(var _VLE: Record "Vendor Ledger Entry"; _VendorNo: Code[20])
    var
        VLE: Record "Vendor Ledger Entry";
        SumaNeacoperita: Decimal;
    begin
        TempVLE.RESET;
        TempVLE.DELETEALL;

        SumaAplicata := 0;
        SumaDeAplicat := 0;

        if DontShowLinesWithZero then
            _VLE.MARKEDONLY(true)
        else
            _VLE.MARKEDONLY(false);

        if _VLE.FINDSET then begin
            repeat
                _VLE.CALCFIELDS("Remaining Amount", "SSA Applied Amount CEC/BO");
                SumaNeacoperita := (-_VLE."Remaining Amount" + _VLE."SSA Applied Amount CEC/BO");
                SumaDeAplicat := SumaCECBO - SumaAplicata;
                if SumaNeacoperita <> 0 then begin
                    if SumaNeacoperita < SumaDeAplicat then
                        _VLE.VALIDATE("SSA Payment Tools Amount", SumaNeacoperita)
                    else
                        _VLE.VALIDATE("SSA Payment Tools Amount", SumaDeAplicat);
                    _VLE.MODIFY(true);
                    PaymentToolsAmountOnAfterValidate(_VLE);
                    SumaDeAplicat := SumaDeAplicat - _VLE."SSA Payment Tools Amount";
                    SumaAplicata += _VLE."SSA Payment Tools Amount";
                end;
            until (_VLE.NEXT = 0) or (SumaDeAplicat = 0);
        end;

        if SumaDeAplicat <> 0 then begin
            VLE.RESET;
            VLE.INIT;
            VLE."Entry No." := 0;
            VLE."SSA Payment Tools Amount" := SumaDeAplicat;
            PaymentToolsAmountOnAfterValidate(VLE);
            MESSAGE('Suma distribuita %1 din total %2', SumaAplicata, SumaCECBO);
        end else
            MESSAGE('Suma a fost distribuita in totalitate.');
    end;
}
