page 70513 "SSA Payment Lines"
{
    // SSM872 SSCAT 06.09.2018 Minuta financiar 30.08.2018

    AutoSplitKey = true;
    Caption = 'Payment Lines';
    DelayedInsert = true;
    PageType = ListPart;
    SourceTable = "SSA Payment Line";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
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
                field("Customer Name"; Rec."Customer Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Customer Name field.';
                }
                field("Document ID"; Rec."Document ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Document ID field.';
                }
                field("External Document No."; Rec."External Document No.")
                {
                    Visible = false;
                    ToolTip = 'Specifies the value of the External Document No. field.';
                }
                field("Drawee Reference"; Rec."Drawee Reference")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Drawee Reference field.';
                }
                field("Posting Group"; Rec."Posting Group")
                {
                    Visible = false;
                    ToolTip = 'Specifies the value of the Posting Group field.';
                }
                field("Due Date"; Rec."Due Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Due Date field.';
                }
                field("Debit Amount"; Rec."Debit Amount")
                {
                    ApplicationArea = All;
                    Visible = "Debit AmountVisible";
                    ToolTip = 'Specifies the value of the Debit Amount field.';
                    trigger OnValidate()
                    begin
                        CurrPage.Update();
                    end;
                }
                field("Credit Amount"; Rec."Credit Amount")
                {
                    ApplicationArea = All;
                    Visible = "Credit AmountVisible";
                    ToolTip = 'Specifies the value of the Credit Amount field.';
                    trigger OnValidate()
                    begin
                        CurrPage.Update();
                    end;
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = All;
                    Visible = AmountVisible;
                    ToolTip = 'Specifies the value of the Amount field.';
                    trigger OnValidate()
                    begin
                        CurrPage.Update();
                    end;
                }
                field("Bank Account"; Rec."Bank Account")
                {
                    ApplicationArea = All;
                    Visible = "Bank AccountVisible";
                    ToolTip = 'Specifies the value of the Bank Account field.';
                }
                field("Bank Account Name"; Rec."Bank Account Name")
                {
                    ApplicationArea = All;
                    Visible = "Bank Account NameVisible";
                    ToolTip = 'Specifies the value of the Bank Account Name field.';
                }
                field("Bank Account No."; Rec."Bank Account No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Bank Account No. field.';
                }
                field("Nume Emitent (Girat)"; Rec."Nume Emitent (Girat)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Nume Emitent (Girat) field.';
                }
                field("Banca Emitent (Girat)"; Rec."Banca Emitent (Girat)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Banca Emitent (Girat) field.';
                }
                field("IBAN Emitent (Girat)"; Rec."IBAN Emitent (Girat)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the IBAN Emitent (Girat) field.';
                }
                field("Applies-to Doc. Type"; Rec."Applies-to Doc. Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Applies-to Doc. Type field.';
                }
                field("Applies-to Doc. No."; Rec."Applies-to Doc. No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Applies-to Doc. No. field.';
                }
                field("Salesperson/Purchaser Code"; Rec."Salesperson/Purchaser Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Salesperson/Purchaser Code field.';
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
                    ShortcutKey = 'Shift+Ctrl+D';
                    ToolTip = 'Executes the Dimensions action.';
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
                    ToolTip = 'Executes the Modify action.';
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
                    ToolTip = 'Executes the Remove action.';
                    trigger OnAction()
                    begin
                        //This functionality was copied from page #45007679. Unsupported part was commented. Please check it.
                        /*CurrPage.Lines.FORM.*/
                        Rec.Delete;
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
                        ShortcutKey = 'Shift+F7';
                        ToolTip = 'Executes the Card action.';
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
                        ShortcutKey = 'Ctrl+F7';
                        ToolTip = 'Executes the Ledger E&ntries action.';
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
        Rec.SetUpNewLine(xRec, BelowxRec);
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

        "Bank Branch No.Visible": Boolean;

        "Agency CodeVisible": Boolean;

        "Bank Account No.Visible": Boolean;

        "Bank Account NameVisible": Boolean;

        "RIB KeyVisible": Boolean;

        "RIB CheckedVisible": Boolean;

        "Acceptation CodeVisible": Boolean;

        AmountVisible: Boolean;

        "Debit AmountVisible": Boolean;

        "Credit AmountVisible": Boolean;

        "Bank AccountVisible": Boolean;

        "Account No.Emphasize": Boolean;

    procedure _ShowDimensions()
    begin
        Rec.ShowDimensions;
    end;

    procedure DisableFields()
    begin
        if Header.Get(Rec."No.") then begin
            if (Header."Status No." = 0) and (Rec."Copied To No." = '') then begin
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
        if Rec."Line No." = 0 then
            Message(Text001)
        else
            if not Rec.Posted then begin
                PaymentLine.Copy(Rec);
                PaymentLine.SetRange("No.", Rec."No.");
                PaymentLine.SetRange("Line No.", Rec."Line No.");
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
        if Confirm(Text000, false, Rec.FieldCaption("No.")) then begin
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
        GenJnlLine."Account Type" := Rec."Account Type";
        GenJnlLine."Account No." := Rec."Account No.";
        CODEUNIT.Run(CODEUNIT::"Gen. Jnl.-Show Card", GenJnlLine);
    end;

    procedure ShowEntries()
    var
        GenJnlLine: Record "Gen. Journal Line";
    begin
        GenJnlLine."Account Type" := Rec."Account Type";
        GenJnlLine."Account No." := Rec."Account No.";
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
        if Header.Get(Rec."No.") then begin
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
        if Rec."Copied To No." <> '' then
            "Account No.Emphasize" := true;
    end;
}
