page 70513 "SSA Payment Lines"
{
    // SSM872 SSCAT 06.09.2018 Minuta financiar 30.08.2018

    AutoSplitKey = true;
    Caption = 'Payment Lines';
    DelayedInsert = true;
    PageType = ListPart;
    SourceTable = "SSA Payment Line";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field("Account Type"; "Account Type")
                {
                    ApplicationArea = All;
                }
                field("Account No."; "Account No.")
                {
                    ApplicationArea = All;
                }
                field("Customer Name"; "Customer Name")
                {
                    ApplicationArea = All;
                }
                field("Document ID"; "Document ID")
                {
                    ApplicationArea = All;
                }
                field("External Document No."; "External Document No.")
                {
                    Visible = false;
                }
                field("Drawee Reference"; "Drawee Reference")
                {
                    ApplicationArea = All;
                }
                field("Posting Group"; "Posting Group")
                {
                    Visible = false;
                }
                field("Due Date"; "Due Date")
                {
                    ApplicationArea = All;
                }
                field("Debit Amount"; "Debit Amount")
                {
                    ApplicationArea = All;
                    Visible = "Debit AmountVisible";
                    trigger OnValidate()
                    begin
                        CurrPage.Update();
                    end;
                }
                field("Credit Amount"; "Credit Amount")
                {
                    ApplicationArea = All;
                    Visible = "Credit AmountVisible";
                    trigger OnValidate()
                    begin
                        CurrPage.Update();
                    end;
                }
                field(Amount; Amount)
                {
                    ApplicationArea = All;
                    Visible = AmountVisible;
                    trigger OnValidate()
                    begin
                        CurrPage.Update();
                    end;
                }
                field("Bank Account"; "Bank Account")
                {
                    ApplicationArea = All;
                    Visible = "Bank AccountVisible";
                }
                field("Bank Account Name"; "Bank Account Name")
                {
                    ApplicationArea = All;
                    Visible = "Bank Account NameVisible";
                }
                field("Bank Account No."; "Bank Account No.")
                {
                    ApplicationArea = All;
                }
                field("Nume Emitent (Girat)"; "Nume Emitent (Girat)")
                {
                    ApplicationArea = All;
                }
                field("Banca Emitent (Girat)"; "Banca Emitent (Girat)")
                {
                    ApplicationArea = All;
                }
                field("IBAN Emitent (Girat)"; "IBAN Emitent (Girat)")
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
                field("Salesperson/Purchaser Code"; "Salesperson/Purchaser Code")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            group("&Line")
            {
                Caption = '&Line';
                action(Dimensions)
                {
                    ApplicationArea = All;
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    ShortCutKey = 'Shift+Ctrl+D';

                    trigger OnAction()
                    begin
                        //This functionality was copied from page #45007679. Unsupported part was commented. Please check it.
                        /*CurrPage.Lines.FORM.*/
                        _ShowDimensions;

                    end;
                }
                action(ModifyAction)
                {
                    ApplicationArea = All;
                    Caption = 'Modify';
                    Image = EditFilter;

                    trigger OnAction()
                    begin
                        //This functionality was copied from page #45007679. Unsupported part was commented. Please check it.
                        /*CurrPage.Lines.FORM.*/
                        _Modify;

                    end;
                }
                action(Remove)
                {
                    ApplicationArea = All;
                    Caption = 'Remove';

                    trigger OnAction()
                    begin
                        //This functionality was copied from page #45007679. Unsupported part was commented. Please check it.
                        /*CurrPage.Lines.FORM.*/
                        Delete;

                    end;
                }
                group("A&ccount")
                {
                    Caption = 'A&ccount';
                    action(Card)
                    {
                        ApplicationArea = All;
                        Caption = 'Card';
                        Image = EditLines;
                        ShortCutKey = 'Shift+F7';

                        trigger OnAction()
                        begin
                            //This functionality was copied from page #45007679. Unsupported part was commented. Please check it.
                            /*CurrPage.Lines.FORM.*/
                            ShowAccount;

                        end;
                    }
                    action("Ledger E&ntries")
                    {
                        ApplicationArea = All;
                        Caption = 'Ledger E&ntries';
                        ShortCutKey = 'Ctrl+F7';

                        trigger OnAction()
                        begin
                            //This functionality was copied from page #45007679. Unsupported part was commented. Please check it.
                            /*CurrPage.Lines.FORM.*/
                            ShowEntries;

                        end;
                    }
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        DisableFields;
        OnAfterGetCurrRecordTrigger();
        AccountNoOnFormat;
    end;

    trigger OnInit()
    begin
        "Bank AccountVisible" := true;
        "Credit AmountVisible" := true;
        "Debit AmountVisible" := true;
        AmountVisible := true;
        "Acceptation CodeVisible" := true;
        "RIB CheckedVisible" := true;
        "RIB KeyVisible" := true;
        "Bank Account NameVisible" := true;
        "Bank Account No.Visible" := true;
        "Agency CodeVisible" := true;
        "Bank Branch No.Visible" := true;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        SetUpNewLine(xRec, BelowxRec);
        OnAfterGetCurrRecordTrigger();
    end;

    trigger OnOpenPage()
    begin
        OnActivateForm;
    end;

    var
        Text000: Label 'Do you want to assign %1?';
        Header: Record "SSA Payment Header";
        Status: Record "SSA Payment Status";
        Text001: Label 'There is no line to modify';
        Text002: Label 'A posted line cannot be modified.';
        [InDataSet]
        "Bank Branch No.Visible": Boolean;
        [InDataSet]
        "Agency CodeVisible": Boolean;
        [InDataSet]
        "Bank Account No.Visible": Boolean;
        [InDataSet]
        "Bank Account NameVisible": Boolean;
        [InDataSet]
        "RIB KeyVisible": Boolean;
        [InDataSet]
        "RIB CheckedVisible": Boolean;
        [InDataSet]
        "Acceptation CodeVisible": Boolean;
        [InDataSet]
        AmountVisible: Boolean;
        [InDataSet]
        "Debit AmountVisible": Boolean;
        [InDataSet]
        "Credit AmountVisible": Boolean;
        [InDataSet]
        "Bank AccountVisible": Boolean;
        [InDataSet]
        "Account No.Emphasize": Boolean;

    procedure _ShowDimensions()
    begin
        Rec.ShowDimensions;
    end;

    procedure DisableFields()
    begin
        if Header.Get("No.") then begin
            if (Header."Status No." = 0) and ("Copied To No." = '') then begin
                CurrPage.Editable(true);
            end else begin
                CurrPage.Editable(false);
            end;
        end;
    end;

    procedure _Modify()
    var
        PaymentLine: Record "SSA Payment Line";
        PaymentModification: Page "SSA Payment Line Modification";
    begin
        if "Line No." = 0 then
            Message(Text001)
        else
            if not Posted then begin
                PaymentLine.Copy(Rec);
                PaymentLine.SetRange("No.", "No.");
                PaymentLine.SetRange("Line No.", "Line No.");
                PaymentModification.SetTableView(PaymentLine);
                PaymentModification.RunModal;
            end else
                Message(Text002);
    end;

    procedure SetDocumentID()
    var
        StatementLine: Record "SSA Payment Line";
        PostingStatement: Codeunit "SSA Payment Management";
        No: Code[20];
    begin
        if Confirm(Text000, false, FieldCaption("No.")) then begin
            CurrPage.SetSelectionFilter(StatementLine);
            StatementLine.MarkedOnly(true);
            if not StatementLine.Find('-') then StatementLine.MarkedOnly(false);
            if StatementLine.Find('-') then begin
                No := StatementLine."Document ID";
                while StatementLine.Next <> 0 do begin
                    PostingStatement.IncrementNoText(No, 1);
                    StatementLine."Document ID" := No;
                    StatementLine.Modify;
                end;
            end;
        end;
    end;

    procedure ShowAccount()
    var
        GenJnlLine: Record "Gen. Journal Line";
    begin
        GenJnlLine."Account Type" := "Account Type";
        GenJnlLine."Account No." := "Account No.";
        CODEUNIT.Run(CODEUNIT::"Gen. Jnl.-Show Card", GenJnlLine);
    end;

    procedure ShowEntries()
    var
        GenJnlLine: Record "Gen. Journal Line";
    begin
        GenJnlLine."Account Type" := "Account Type";
        GenJnlLine."Account No." := "Account No.";
        CODEUNIT.Run(CODEUNIT::"Gen. Jnl.-Show Entries", GenJnlLine);
    end;


    procedure VisibleEditable()
    begin
        CurrPage.Editable(true);
        CurrPage.Editable(true);
    end;

    local procedure OnAfterGetCurrRecordTrigger()
    begin
        xRec := Rec;
        DisableFields;
    end;

    local procedure OnActivateForm()
    begin
        if Header.Get("No.") then begin
            Status.Get(Header."Payment Class", Header."Status No.");
            if Status.RIB then begin
                "Bank Branch No.Visible" := true;
                "Agency CodeVisible" := true;
                "Bank Account No.Visible" := true;
                "Bank Account NameVisible" := true;
                "RIB KeyVisible" := true;
                "RIB CheckedVisible" := true;
            end else begin
                "Bank Branch No.Visible" := false;
                "Agency CodeVisible" := false;
                "Bank Account No.Visible" := false;
                "Bank Account NameVisible" := false;
                "RIB KeyVisible" := false;
                "RIB CheckedVisible" := false;
            end;
            if Status."Acceptation Code" then begin
                "Acceptation CodeVisible" := true;
            end else begin
                "Acceptation CodeVisible" := false;
            end;
            AmountVisible := Status.Amount;
            "Debit AmountVisible" := Status.Debit;
            "Credit AmountVisible" := Status.Credit;
            "Bank AccountVisible" := Status."Bank Account";
            DisableFields;
        end;
    end;

    local procedure AccountNoOnFormat()
    begin
        if "Copied To No." <> '' then
            "Account No.Emphasize" := true;
    end;
}

