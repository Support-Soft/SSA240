page 70023 "SSA Bank Journal"
{
    // // This page has two view modes based on global variable 'IsSimplePage' as :-
    // // Classic mode (Show more columns action) - When IsSimplePage is set to false. This view supports showing all the traditional columns. All the lines for all
    // // document numbers are shown in this view.
    // // Simple mode (Show less columns actions) - When IsSimplePage is set to True. This view supports limitted columns and pulls document number, posting date,
    // // currency code as global variables. This mode is intented to do fast data entry so only ONE document number is shown at a time. User can
    // // use next / previous buttons to navigate between different document numbers.
    // // By default this page opens up in Simple mode; if users chooses to switch to classic mode (show more columns) then we remember their selection in Journal User Preferences table
    //
    // SSA973 SSCAT 06.09.2019 39.Rapoarte legale- Localizare Declaratia 394
    // SSA946 SSCAT 26.09.2019 12.Funct. functionalitate DVI la achizitii
    // SSA1199 SSCAT 03.11.2019 1199: Jurnal de casa si de banca

    ApplicationArea = All;
    AutoSplitKey = true;
    Caption = 'Bank Journal';
    DataCaptionExpression = Rec.DataCaption();
    DelayedInsert = true;
    PageType = Worksheet;
    PromotedActionCategories = 'New,Process,Report,Bank,Application,Payroll,Approve,Page,Post/Print,Line,Account';
    SaveValues = true;
    SourceTable = "Gen. Journal Line";
    UsageCategory = Tasks;

    layout
    {
        area(Content)
        {
            group(Control120)
            {
                ShowCaption = false;
                field(CurrentJnlBatchName; CurrentJnlBatchName)
                {
                    ApplicationArea = All;
                    Caption = 'Batch Name';
                    Lookup = true;
                    ToolTip = 'Specifies the name of the journal batch.';

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        CurrPage.SaveRecord();
                        GenJnlManagement.LookupName(CurrentJnlBatchName, Rec);
                        // Set simple view when batch is changed
                        SetDataForSimpleModeOnBatchChange();
                        CurrPage.Update(false);
                    end;

                    trigger OnValidate()
                    begin
                        GenJnlManagement.CheckName(CurrentJnlBatchName, Rec);
                        CurrentJnlBatchNameOnAfterVali();
                        SetDataForSimpleModeOnBatchChange();
                    end;
                }
                field("<Document No. Simple Page>"; CurrentDocNo)
                {
                    ApplicationArea = All;
                    Caption = 'Document No.';
                    ToolTip = 'Specifies a document number for the journal line.';
                    Visible = IsSimplePage;

                    trigger OnValidate()
                    begin
                        if not IsSimplePage then
                            exit;
                        if CurrentDocNo = '' then
                            CurrentDocNo := Rec."Document No.";
                        if CurrentDocNo = Rec."Document No." then
                            exit;

                        if Rec.Count = 0 then
                            Rec."Document No." := CurrentDocNo;

                        IsChangingDocNo := true;
                        SetDocumentNumberFilter(CurrentDocNo);
                        CurrPage.Update(false);
                    end;
                }
                field("<CurrentPostingDate>"; CurrentPostingDate)
                {
                    ApplicationArea = All;
                    Caption = 'Posting Date';
                    ToolTip = 'Specifies the entry''s posting date.';
                    Visible = IsSimplePage;

                    trigger OnValidate()
                    begin
                        UpdateCurrencyFactor(Rec.FieldNo("Posting Date"));
                    end;
                }
                field("<CurrentCurrencyCode>"; CurrentCurrencyCode)
                {
                    ApplicationArea = All;
                    Caption = 'Currency Code';
                    TableRelation = Currency.Code;
                    ToolTip = 'Specifies the code of the currency for the amounts on the journal line.';
                    Visible = IsSimplePage;

                    trigger OnValidate()
                    var
                        Currency: Record Currency;
                    begin
                        Currency.Get(CurrentCurrencyCode);
                        UpdateCurrencyFactor(Rec.FieldNo("Currency Code"));
                    end;
                }
            }
            repeater(Control1)
            {
                ShowCaption = false;
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = All;
                    StyleExpr = StyleTxt;
                    ToolTip = 'Specifies the entry''s posting date.';
                    Visible = not IsSimplePage;
                }
                field("Document Date"; Rec."Document Date")
                {
                    ApplicationArea = All;
                    StyleExpr = StyleTxt;
                    ToolTip = 'Specifies the date on the document that provides the basis for the entry on the journal line.';
                    Visible = false;
                }
                field("Document Type"; Rec."Document Type")
                {
                    ApplicationArea = All;
                    StyleExpr = StyleTxt;
                    ToolTip = 'Specifies the type of document that the entry on the journal line is.';
                    Visible = true;
                }
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies a document number for the journal line.';
                    Visible = not IsSimplePage;
                }
                field("Incoming Document Entry No."; Rec."Incoming Document Entry No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the number of the incoming document that this general journal line is created for.';
                    Visible = false;

                    trigger OnAssistEdit()
                    begin
                        if Rec."Incoming Document Entry No." > 0 then
                            Hyperlink(Rec.GetIncomingDocumentURL());
                    end;
                }
                field("External Document No."; Rec."External Document No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies a document number that refers to the customer''s or vendor''s numbering system.';
                    Visible = false;
                }
                field("Applies-to Ext. Doc. No."; Rec."Applies-to Ext. Doc. No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the external document number that will be exported in the payment file.';
                    Visible = false;
                }
                field("Account Type"; Rec."Account Type")
                {
                    ApplicationArea = All;
                    StyleExpr = StyleTxt;
                    ToolTip = 'Specifies the type of account that the entry on the journal line will be posted to.';
                    Visible = true;

                    trigger OnValidate()
                    begin
                        GenJnlManagement.GetAccounts(Rec, AccName, BalAccName);
                        SetUserInteractions();
                        EnableApplyEntriesAction();
                        CurrPage.SaveRecord();
                    end;
                }
                field("Account No."; Rec."Account No.")
                {
                    ApplicationArea = All;
                    StyleExpr = StyleTxt;
                    ToolTip = 'Specifies the account number that the entry on the journal line will be posted to.';

                    trigger OnValidate()
                    begin
                        GenJnlManagement.GetAccounts(Rec, AccName, BalAccName);
                        Rec.ShowShortcutDimCode(ShortcutDimCode);
                        SetUserInteractions();
                        // On TAB81 Account No. - OnValidate() will reset currency code to empty if
                        // there is no balancing account for this G/L line. This happens under GetGLAccount
                        // function. So, we need to validate current curency code again.
                        if IsSimplePage then
                            Rec.Validate("Currency Code", CurrentCurrencyCode);
                        CurrPage.SaveRecord();
                    end;
                }
                field(AccountName; AccName)
                {
                    ApplicationArea = All;
                    Caption = 'Account Name';
                    Editable = false;
                    ToolTip = 'Specifies the account name that the entry on the journal line will be posted to.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    StyleExpr = StyleTxt;
                    ToolTip = 'Specifies a description of the entry.';
                }
                field("Payer Information"; Rec."Payer Information")
                {
                    ApplicationArea = All;
                    StyleExpr = StyleTxt;
                    ToolTip = 'Specifies payer information that is imported with the bank statement file.';
                    Visible = false;
                }
                field("Transaction Information"; Rec."Transaction Information")
                {
                    ApplicationArea = All;
                    StyleExpr = StyleTxt;
                    ToolTip = 'Specifies transaction information that is imported with the bank statement file.';
                    Visible = false;
                }
                field("Business Unit Code"; Rec."Business Unit Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the code of the business unit that the entry derives from in a consolidated company.';
                    Visible = false;
                }
                field("Salespers./Purch. Code"; Rec."Salespers./Purch. Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the salesperson or purchaser who is linked to the journal line.';
                    Visible = false;
                }
                field("Campaign No."; Rec."Campaign No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the number of the campaign the journal line is linked to.';
                    Visible = false;
                }
                field("Currency Code"; Rec."Currency Code")
                {
                    ApplicationArea = All;
                    AssistEdit = true;
                    ToolTip = 'Specifies the code of the currency for the amounts on the journal line.';
                    Visible = not IsSimplePage;

                    trigger OnAssistEdit()
                    begin
                        ChangeExchangeRate.SetParameter(Rec."Currency Code", Rec."Currency Factor", Rec."Posting Date");
                        if ChangeExchangeRate.RunModal() = Action::OK then
                            Rec.Validate("Currency Factor", ChangeExchangeRate.GetParameter());

                        Clear(ChangeExchangeRate);
                    end;
                }
                field("EU 3-Party Trade"; Rec."EU 3-Party Trade")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies whether the entry was part of a 3-party trade. If it was, there is a check mark in the field.';
                    Visible = not IsSimplePage;
                }
                field("Gen. Posting Type"; Rec."Gen. Posting Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the general posting type that will be used when you post the entry on this journal line.';
                    Visible = not IsSimplePage;
                }
                field("Gen. Bus. Posting Group"; Rec."Gen. Bus. Posting Group")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the vendor''s or customer''s trade type to link transactions made for this business partner with the appropriate general ledger account according to the general posting setup.';
                    Visible = not IsSimplePage;
                }
                field("Gen. Prod. Posting Group"; Rec."Gen. Prod. Posting Group")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the item''s product type to link transactions made for this item with the appropriate general ledger account according to the general posting setup.';
                    Visible = not IsSimplePage;
                }
                field("VAT Bus. Posting Group"; Rec."VAT Bus. Posting Group")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the VAT business posting group code that will be used when you post the entry on the journal line.';
                    Visible = false;
                }
                field("VAT Prod. Posting Group"; Rec."VAT Prod. Posting Group")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the VAT product posting group. Links business transactions made for the item, resource, or G/L account with the general ledger, to account for VAT amounts resulting from trade with that record.';
                    Visible = false;
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the quantity of items to be included on the journal line.';
                    Visible = false;
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = All;
                    StyleExpr = StyleTxt;
                    ToolTip = 'Specifies the total amount (including VAT) that the journal line consists of.';
                    Visible = AmountVisible;
                }
                field("Amount (LCY)"; Rec."Amount (LCY)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the total amount in local currency (including VAT) that the journal line consists of.';
                    Visible = AmountVisible;
                }
                field("Debit Amount"; Rec."Debit Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the total amount (including VAT) that the journal line consists of, if it is a debit amount.';
                    Visible = DebitCreditVisible;
                }
                field("Credit Amount"; Rec."Credit Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the total amount (including VAT) that the journal line consists of, if it is a credit amount.';
                    Visible = DebitCreditVisible;
                }
                field("VAT Amount"; Rec."VAT Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the amount of VAT included in the total amount.';
                    Visible = false;
                }
                field("VAT Difference"; Rec."VAT Difference")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the difference between the calculate VAT amount and the VAT amount that you have entered manually.';
                    Visible = false;
                }
                field("Bal. VAT Amount"; Rec."Bal. VAT Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the amount of Bal. VAT included in the total amount.';
                    Visible = false;
                }
                field("Bal. VAT Difference"; Rec."Bal. VAT Difference")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the difference between the calculate VAT amount and the VAT amount that you have entered manually.';
                    Visible = false;
                }
                field("Bal. Account Type"; Rec."Bal. Account Type")
                {
                    ApplicationArea = All;
                    StyleExpr = StyleTxt;
                    ToolTip = 'Specifies the code for the balancing account type that should be used in this journal line.';
                    Visible = not IsSimplePage;

                    trigger OnValidate()
                    begin
                        EnableApplyEntriesAction();
                    end;
                }
                field("Bal. Account No."; Rec."Bal. Account No.")
                {
                    ApplicationArea = All;
                    StyleExpr = StyleTxt;
                    ToolTip = 'Specifies the number of the general ledger, customer, vendor, or bank account to which a balancing entry for the journal line will posted (for example, a cash account for cash purchases).';
                    Visible = not IsSimplePage;

                    trigger OnValidate()
                    begin
                        GenJnlManagement.GetAccounts(Rec, AccName, BalAccName);
                        Rec.ShowShortcutDimCode(ShortcutDimCode);
                    end;
                }
                field("Bal. Gen. Posting Type"; Rec."Bal. Gen. Posting Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the general posting type associated with the balancing account that will be used when you post the entry on the journal line.';
                    Visible = not IsSimplePage;
                }
                field("Bal. Gen. Bus. Posting Group"; Rec."Bal. Gen. Bus. Posting Group")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the general business posting group code associated with the balancing account that will be used when you post the entry.';
                    Visible = not IsSimplePage;
                }
                field("Bal. Gen. Prod. Posting Group"; Rec."Bal. Gen. Prod. Posting Group")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the general product posting group code associated with the balancing account that will be used when you post the entry.';
                    Visible = not IsSimplePage;
                }
                field("Deferral Code"; Rec."Deferral Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the deferral template that governs how expenses or revenue are deferred to the different accounting periods when the expenses or revenue were incurred.';
                    Visible = not IsSimplePage;

                    trigger OnAssistEdit()
                    begin
                        Rec.ShowDeferralSchedule();
                    end;
                }
                field("Bal. VAT Bus. Posting Group"; Rec."Bal. VAT Bus. Posting Group")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the code of the VAT business posting group that will be used when you post the entry on the journal line.';
                    Visible = false;
                }
                field("Bal. VAT Prod. Posting Group"; Rec."Bal. VAT Prod. Posting Group")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the code of the VAT product posting group that will be used when you post the entry on the journal line.';
                    Visible = false;
                }
                field("Bill-to/Pay-to No."; Rec."Bill-to/Pay-to No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the number of the bill-to customer or pay-to vendor that the entry is linked to.';
                    Visible = false;
                }
                field("Ship-to/Order Address Code"; Rec."Ship-to/Order Address Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the address code of the ship-to customer or order-from vendor that the entry is linked to.';
                    Visible = false;
                }
                field("Payment Terms Code"; Rec."Payment Terms Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the code that represents the payments terms that apply to the entry on the journal line.';
                    Visible = false;
                }
                field("Applied Automatically"; Rec."Applied Automatically")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies that the general journal line has been automatically applied with a matching payment using the Apply Automatically function.';
                    Visible = false;
                }
                field(Applied; Rec.IsApplied())
                {
                    ApplicationArea = All;
                    Caption = 'Applied';
                    ToolTip = 'Specifies if the record on the line has been applied.';
                    Visible = false;
                }
                field("Applies-to Doc. Type"; Rec."Applies-to Doc. Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the type of the posted document that this document or journal line will be applied to when you post, for example to register payment.';
                    Visible = false;
                }
                field("Applies-to Doc. No."; Rec."Applies-to Doc. No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the number of the posted document that this document or journal line will be applied to when you post, for example to register payment.';
                    Visible = false;
                }
                field("Applies-to ID"; Rec."Applies-to ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the ID of entries that will be applied to when you choose the Apply Entries action.';
                    Visible = false;
                }
                field("On Hold"; Rec."On Hold")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies if the journal line has been invoiced, and you execute the payment suggestions batch job, or you create a finance charge memo or reminder.';
                    Visible = false;
                }
                field("Bank Payment Type"; Rec."Bank Payment Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the code for the payment type to be used for the entry on the payment journal line.';
                    Visible = false;
                }
                field("Reason Code"; Rec."Reason Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the reason code that has been entered on the journal lines.';
                    Visible = false;
                }
                field(Correction; Rec.Correction)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the entry as a corrective entry. You can use the field if you need to post a corrective entry to an account.';
                    Visible = not IsSimplePage;
                }
                field(Control7; Rec.Comment)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies a comment about the activity on the journal line. Note that the comment is not carried forward to posted entries.';
                    Visible = not IsSimplePage;
                }
                field("Direct Debit Mandate ID"; Rec."Direct Debit Mandate ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the identification of the direct-debit mandate that is being used on the journal lines to process a direct debit collection.';
                    Visible = false;
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the code for Shortcut Dimension 1, which is one of two global dimension codes that you set up in the General Ledger Setup window.';
                    Visible = DimVisible1;
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the code for Shortcut Dimension 2, which is one of two global dimension codes that you set up in the General Ledger Setup window.';
                    Visible = DimVisible2;
                }
                field(ShortcutDimCode3; ShortcutDimCode[3])
                {
                    ApplicationArea = All;
                    CaptionClass = '1,2,3';
                    TableRelation = "Dimension Value".Code where("Global Dimension No." = const(3),
                                                                  "Dimension Value Type" = const(Standard),
                                                                  Blocked = const(false));
                    Visible = DimVisible3;
                    ToolTip = 'Specifies the value of the ShortcutDimCode[3] field.';
                    trigger OnValidate()
                    begin
                        Rec.ValidateShortcutDimCode(3, ShortcutDimCode[3]);
                    end;
                }
                field(ShortcutDimCode4; ShortcutDimCode[4])
                {
                    ApplicationArea = All;
                    CaptionClass = '1,2,4';
                    TableRelation = "Dimension Value".Code where("Global Dimension No." = const(4),
                                                                  "Dimension Value Type" = const(Standard),
                                                                  Blocked = const(false));
                    Visible = DimVisible4;
                    ToolTip = 'Specifies the value of the ShortcutDimCode[4] field.';
                    trigger OnValidate()
                    begin
                        Rec.ValidateShortcutDimCode(4, ShortcutDimCode[4]);
                    end;
                }
                field(ShortcutDimCode5; ShortcutDimCode[5])
                {
                    ApplicationArea = All;
                    CaptionClass = '1,2,5';
                    TableRelation = "Dimension Value".Code where("Global Dimension No." = const(5),
                                                                  "Dimension Value Type" = const(Standard),
                                                                  Blocked = const(false));
                    Visible = DimVisible5;
                    ToolTip = 'Specifies the value of the ShortcutDimCode[5] field.';
                    trigger OnValidate()
                    begin
                        Rec.ValidateShortcutDimCode(5, ShortcutDimCode[5]);
                    end;
                }
                field(ShortcutDimCode6; ShortcutDimCode[6])
                {
                    ApplicationArea = All;
                    CaptionClass = '1,2,6';
                    TableRelation = "Dimension Value".Code where("Global Dimension No." = const(6),
                                                                  "Dimension Value Type" = const(Standard),
                                                                  Blocked = const(false));
                    Visible = DimVisible6;
                    ToolTip = 'Specifies the value of the ShortcutDimCode[6] field.';
                    trigger OnValidate()
                    begin
                        Rec.ValidateShortcutDimCode(6, ShortcutDimCode[6]);
                    end;
                }
                field(ShortcutDimCode7; ShortcutDimCode[7])
                {
                    ApplicationArea = All;
                    CaptionClass = '1,2,7';
                    TableRelation = "Dimension Value".Code where("Global Dimension No." = const(7),
                                                                  "Dimension Value Type" = const(Standard),
                                                                  Blocked = const(false));
                    Visible = DimVisible7;
                    ToolTip = 'Specifies the value of the ShortcutDimCode[7] field.';
                    trigger OnValidate()
                    begin
                        Rec.ValidateShortcutDimCode(7, ShortcutDimCode[7]);
                    end;
                }
                field(ShortcutDimCode8; ShortcutDimCode[8])
                {
                    ApplicationArea = All;
                    CaptionClass = '1,2,8';
                    TableRelation = "Dimension Value".Code where("Global Dimension No." = const(8),
                                                                  "Dimension Value Type" = const(Standard),
                                                                  Blocked = const(false));
                    Visible = DimVisible8;
                    ToolTip = 'Specifies the value of the ShortcutDimCode[8] field.';
                    trigger OnValidate()
                    begin
                        Rec.ValidateShortcutDimCode(8, ShortcutDimCode[8]);
                    end;
                }
                field("SSA Tip Document D394"; Rec."SSA Tip Document D394")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Tip Document D394 field.';
                }
                field("SSA Stare Factura"; Rec."SSA Stare Factura")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Stare Factura field.';
                }
                field("SSA Tip Partener"; Rec."SSA Tip Partener")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Tip Partener field.';
                }
                field("SSA Custom Invoice No."; Rec."SSA Custom Invoice No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Custom Invoice No. field.';
                }
                field("SSA Posting Group"; Rec."SSA Posting Group")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Custom Posting Group field.';
                }
            }
            group(Control30)
            {
                ShowCaption = false;
                Visible = true;
                fixed(Control1901776101)
                {
                    Caption = 'Details';
                    group("Account Name")
                    {
                        Caption = 'Account Name';
                        field(AccName; AccName)
                        {
                            ApplicationArea = All;
                            Editable = false;
                            ShowCaption = false;
                            ToolTip = 'Specifies the name of the account.';
                        }
                    }
                    group("Bal. Account Name")
                    {
                        Caption = 'Bal. Account Name';
                        field(BalAccName; BalAccName)
                        {
                            ApplicationArea = All;
                            Caption = 'Bal. Account Name';
                            Editable = false;
                            ToolTip = 'Specifies the name of the balancing account that has been entered on the journal line.';
                        }
                    }
                    group("Total Debit")
                    {
                        Caption = 'Total Debit';
                        field(FieldDisplayTotalDebit; DisplayTotalDebit())
                        {
                            ApplicationArea = All;
                            Caption = 'Total Debit';
                            Editable = false;
                            ToolTip = 'Specifies the total debit amount in the general journal.';
                        }
                    }
                    group("Total Credit")
                    {
                        Caption = 'Total Credit';
                        field(FieldDisplayTotalCredit; DisplayTotalCredit())
                        {
                            ApplicationArea = All;
                            Caption = 'Total Credit';
                            Editable = false;
                            ToolTip = 'Specifies the total credit amount in the general journal.';
                        }
                    }
                    group(Control1902759701)
                    {
                        Caption = 'Balance';
                        field(Balance; Balance + Rec."Balance (LCY)" - xRec."Balance (LCY)")
                        {
                            ApplicationArea = All;
                            AutoFormatType = 1;
                            Caption = 'Balance';
                            Editable = false;
                            ToolTip = 'Specifies the balance that has accumulated in the general journal on the line where the cursor is.';
                            Visible = BalanceVisible;
                        }
                    }
                    group("Total Balance")
                    {
                        Caption = 'Total Balance';
                        field(TotalBalance; TotalBalance + Rec."Balance (LCY)" - xRec."Balance (LCY)")
                        {
                            ApplicationArea = All;
                            AutoFormatType = 1;
                            Caption = 'Total Balance';
                            Editable = false;
                            ToolTip = 'Specifies the total balance in the general journal.';
                            Visible = TotalBalanceVisible;
                        }
                    }
                }
                group("Balance Account Amount")
                {
                    Caption = 'Balance Account Amount';
                    field(DateOfBalance; DateOfBalance)
                    {
                        Caption = 'Date of Balance';
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the Date of Balance field.';
                        trigger OnValidate()
                        begin
                            //SSA1199>>
                            Rec.SetRange("SSA Date Filter", 0D, DateOfBalance);
                            Rec.SetRange("SSA Date Filter -1D", 0D, CalcDate('<-1D>', DateOfBalance));

                            Rec.CalcFields("SSA Total Amount (LCY)", "SSA Bal Acc Balance (LCY)",
                                "SSA Bal Acc Balance -1D (LCY)", "SSA Credit Amount -1D (LCY)",
                                "SSA Credit Amount (LCY)", "SSA Debit Amount -1D (LCY)", "SSA Debit Amount (LCY)");
                            //SSA1199<<
                            Rec.CalcFields("SSA Debit Amount -1D",
                                "SSA Credit Amount -1D",
                                "SSA Debit Amount",
                                "SSA Credit Amount",
                                "SSA Total Amount");
                        end;
                    }
                    field(BalAccBalance1DLCY; Rec."SSA Debit Amount -1D (LCY)" - Rec."SSA Credit Amount -1D (LCY)")
                    {
                        Caption = 'Bal Acc Balance -1D (LCY)';
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the Bal Acc Balance -1D (LCY) field.';
                    }
                    field(BalAccBalanceLCY; Rec."SSA Debit Amount (LCY)" - Rec."SSA Credit Amount (LCY)" - Rec."SSA Total Amount (LCY)")
                    {
                        Caption = 'Bal Acc Balance (LCY)';
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the Bal Acc Balance (LCY) field.';
                    }
                    field(BalAccBalance1D; Rec."SSA Debit Amount -1D" - Rec."SSA Credit Amount -1D")
                    {
                        Caption = 'Bal Acc Balance -1D';
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the Bal Acc Balance -1D field.';
                    }
                    field(BalAccBalance; Rec."SSA Debit Amount" - Rec."SSA Credit Amount" - Rec."SSA Total Amount")
                    {
                        Caption = 'Bal Acc Balance';
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the Bal Acc Balance field.';
                    }
                }
            }
        }
        area(FactBoxes)
        {
            part(Control1900919607; "Dimension Set Entries FactBox")
            {
                ApplicationArea = All;
                SubPageLink = "Dimension Set ID" = field("Dimension Set ID");
            }
            part(IncomingDocAttachFactBox; "Incoming Doc. Attach. FactBox")
            {
                ApplicationArea = All;
                ShowFilter = false;
            }
            part(WorkflowStatusBatch; "Workflow Status FactBox")
            {
                ApplicationArea = All;
                Caption = 'Batch Workflows';
                Editable = false;
                Enabled = false;
                ShowFilter = false;
                Visible = ShowWorkflowStatusOnBatch;
            }
            part(WorkflowStatusLine; "Workflow Status FactBox")
            {
                ApplicationArea = All;
                Caption = 'Line Workflows';
                Editable = false;
                Enabled = false;
                ShowFilter = false;
                Visible = ShowWorkflowStatusOnLine;
            }
            systempart(Control1900383207; Links)
            {
                ApplicationArea = All;
                Visible = false;
            }
            systempart(Control1905767507; Notes)
            {
                ApplicationArea = All;
                Visible = false;
            }
        }
    }

    actions
    {
        area(Navigation)
        {
            group("&Line")
            {
                Caption = '&Line';
                Image = Line;
                action(Dimensions)
                {
                    AccessByPermission = tabledata Dimension = R;
                    ApplicationArea = All;
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    Promoted = true;
                    PromotedCategory = Category10;
                    ShortcutKey = 'Shift+Ctrl+D';
                    ToolTip = 'View or edit dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyze transaction history.';

                    trigger OnAction()
                    begin
                        Rec.ShowDimensions();
                        CurrPage.SaveRecord();
                    end;
                }
            }
            group("A&ccount")
            {
                Caption = 'A&ccount';
                Image = ChartOfAccounts;
                action(Card)
                {
                    ApplicationArea = All;
                    Caption = 'Card';
                    Image = EditLines;
                    Promoted = true;
                    PromotedCategory = Category11;
                    RunObject = codeunit "Gen. Jnl.-Show Card";
                    ShortcutKey = 'Shift+F7';
                    ToolTip = 'View or change detailed information about the record on the document or journal line.';
                }
                action("Ledger E&ntries")
                {
                    ApplicationArea = All;
                    Caption = 'Ledger E&ntries';
                    Image = GLRegisters;
                    Promoted = true;
                    PromotedCategory = Category11;
                    RunObject = codeunit "Gen. Jnl.-Show Entries";
                    ShortcutKey = 'Ctrl+F7';
                    ToolTip = 'View the history of transactions that have been posted for the selected record.';
                }
            }
            action(Approvals)
            {
                AccessByPermission = tabledata "Approval Entry" = R;
                ApplicationArea = All;
                Caption = 'Approvals';
                Image = Approvals;
                Promoted = true;
                PromotedCategory = Category10;
                ToolTip = 'View a list of the records that are waiting to be approved. For example, you can see who requested the record to be approved, when it was sent, and when it is due to be approved.';

                trigger OnAction()
                var
                    GenJournalLine: Record "Gen. Journal Line";
                    ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                begin
                    GetCurrentlySelectedLines(GenJournalLine);
                    ApprovalsMgmt.ShowJournalApprovalEntries(GenJournalLine);
                end;
            }
        }
        area(Processing)
        {
            group("F&unctions")
            {
                Caption = 'F&unctions';
                Image = "Action";
                action("Renumber Document Numbers")
                {
                    ApplicationArea = All;
                    Caption = 'Renumber Document Numbers';
                    Image = EditLines;
                    ToolTip = 'Resort the numbers in the Document No. column to avoid posting errors because the document numbers are not in sequence. Entry applications and line groupings are preserved.';
                    Visible = not IsSimplePage;

                    trigger OnAction()
                    begin
                        Rec.RenumberDocumentNo()
                    end;
                }
                action("Insert Conv. LCY Rndg. Lines")
                {
                    ApplicationArea = All;
                    Caption = 'Insert Conv. LCY Rndg. Lines';
                    Image = InsertCurrency;
                    RunObject = codeunit "Adjust Gen. Journal Balance";
                    ToolTip = 'Insert a rounding correction line in the journal. This rounding correction line will balance in LCY when amounts in the foreign currency also balance. You can then post the journal.';
                }
                action(GetStandardJournals)
                {
                    ApplicationArea = All;
                    Caption = '&Get Standard Journals';
                    Ellipsis = true;
                    Image = GetStandardJournal;
                    Promoted = true;
                    PromotedCategory = Process;
                    ToolTip = 'Select a standard general journal to be inserted.';

                    trigger OnAction()
                    var
                        StdGenJnl: Record "Standard General Journal";
                    begin
                        StdGenJnl.FilterGroup := 2;
                        StdGenJnl.SetRange("Journal Template Name", Rec."Journal Template Name");
                        StdGenJnl.FilterGroup := 0;

                        if Page.RunModal(Page::"Standard General Journals", StdGenJnl) = Action::LookupOK then begin
                            if IsSimplePage then
                                // If this page is opend in simple mode then use the current doc no. for every G/L lines that are created
                                // from standard journal.
                                StdGenJnl.CreateGenJnlFromStdJnlWithDocNo(StdGenJnl, CurrentJnlBatchName, CurrentDocNo, Rec."Posting Date")
                            else
                                StdGenJnl.CreateGenJnlFromStdJnl(StdGenJnl, CurrentJnlBatchName);
                            Message(Text000, StdGenJnl.Code);
                        end;

                        CurrPage.Update(true);
                    end;
                }
                action(SaveAsStandardJournal)
                {
                    ApplicationArea = All;
                    Caption = '&Save as Standard Journal';
                    Ellipsis = true;
                    Image = SaveasStandardJournal;
                    ToolTip = 'Define the journal lines that you want to use later as a standard journal before you post the journal.';

                    trigger OnAction()
                    var
                        GenJnlBatch: Record "Gen. Journal Batch";
                        GeneralJnlLines: Record "Gen. Journal Line";
                        StdGenJnl: Record "Standard General Journal";
                        SaveAsStdGenJnl: Report "Save as Standard Gen. Journal";
                    begin
                        GeneralJnlLines.SetFilter("Journal Template Name", Rec."Journal Template Name");
                        GeneralJnlLines.SetFilter("Journal Batch Name", CurrentJnlBatchName);
                        CurrPage.SetSelectionFilter(GeneralJnlLines);
                        GeneralJnlLines.CopyFilters(Rec);

                        GenJnlBatch.Get(Rec."Journal Template Name", CurrentJnlBatchName);
                        SaveAsStdGenJnl.Initialise(GeneralJnlLines, GenJnlBatch);
                        SaveAsStdGenJnl.RunModal();
                        if not SaveAsStdGenJnl.GetStdGeneralJournal(StdGenJnl) then
                            exit;

                        Message(Text001, StdGenJnl.Code);
                    end;
                }
                action("Test Report")
                {
                    ApplicationArea = All;
                    Caption = 'Test Report';
                    Ellipsis = true;
                    Image = TestReport;
                    ToolTip = 'View a test report so that you can find and correct any errors before you perform the actual posting of the journal or document.';

                    trigger OnAction()
                    begin
                        ReportPrint.PrintGenJnlLine(Rec);
                    end;
                }
                action(Post)
                {
                    ApplicationArea = All;
                    Caption = 'P&ost';
                    Image = PostOrder;
                    Promoted = true;
                    PromotedCategory = Category9;
                    PromotedIsBig = true;
                    ShortcutKey = 'F9';
                    ToolTip = 'Finalize the document or journal by posting the amounts and quantities to the related accounts in your company books.';

                    trigger OnAction()
                    begin
                        Codeunit.Run(Codeunit::"Gen. Jnl.-Post", Rec);
                        CurrentJnlBatchName := Rec.GetRangeMax("Journal Batch Name");
                        if IsSimplePage then
                            SetDataForSimpleModeOnPost();
                        CurrPage.Update(false);
                    end;
                }
                action("Preview")
                {
                    ApplicationArea = All;
                    Caption = 'Preview Posting';
                    Image = ViewPostedOrder;
                    Promoted = true;
                    PromotedCategory = Category9;
                    ToolTip = 'Review the different types of entries that will be created when you post the document or journal.';

                    trigger OnAction()
                    var
                        GenJnlPost: Codeunit "Gen. Jnl.-Post";
                    begin
                        GenJnlPost.Preview(Rec);
                    end;
                }
                action(PostAndPrint)
                {
                    ApplicationArea = All;
                    Caption = 'Post and &Print';
                    Image = PostPrint;
                    Promoted = true;
                    PromotedCategory = Category9;
                    PromotedIsBig = true;
                    ShortcutKey = 'Shift+F9';
                    ToolTip = 'Finalize and prepare to print the document or journal. The values and quantities are posted to the related accounts. A report request window where you can specify what to include on the print-out.';

                    trigger OnAction()
                    begin
                        Codeunit.Run(Codeunit::"Gen. Jnl.-Post+Print", Rec);
                        CurrentJnlBatchName := Rec.GetRangeMax("Journal Batch Name");
                        if IsSimplePage then
                            SetDataForSimpleModeOnPost();
                        CurrPage.Update(false);
                    end;
                }
                action(DeferralSchedule)
                {
                    ApplicationArea = All;
                    Caption = 'Deferral Schedule';
                    Image = PaymentPeriod;
                    ToolTip = 'View or edit the deferral schedule that governs how expenses or revenue are deferred to different accounting periods when the journal line is posted.';

                    trigger OnAction()
                    begin
                        Rec.ShowDeferralSchedule();
                    end;
                }
                group(IncomingDocument)
                {
                    Caption = 'Incoming Document';
                    Image = Documents;
                    action(IncomingDocCard)
                    {
                        ApplicationArea = All;
                        Caption = 'View Incoming Document';
                        Enabled = HasIncomingDocument;
                        Image = ViewOrder;
                        ToolTip = 'View any incoming document records and file attachments that exist for the entry or document.';

                        trigger OnAction()
                        var
                            IncomingDocument: Record "Incoming Document";
                        begin
                            IncomingDocument.ShowCardFromEntryNo(Rec."Incoming Document Entry No.");
                        end;
                    }
                    action(SelectIncomingDoc)
                    {
                        AccessByPermission = tabledata "Incoming Document" = R;
                        ApplicationArea = All;
                        Caption = 'Select Incoming Document';
                        Image = SelectLineToApply;
                        ToolTip = 'Select an incoming document record and file attachment that you want to link to the entry or document.';

                        trigger OnAction()
                        var
                            IncomingDocument: Record "Incoming Document";
                        begin
                            Rec.Validate("Incoming Document Entry No.", IncomingDocument.SelectIncomingDocument(Rec."Incoming Document Entry No.", Rec.RecordId));
                        end;
                    }
                    action(IncomingDocAttachFile)
                    {
                        ApplicationArea = All;
                        Caption = 'Create Incoming Document from File';
                        Ellipsis = true;
                        Enabled = not HasIncomingDocument;
                        Image = Attach;
                        ToolTip = 'Create an incoming document record by selecting a file to attach, and then link the incoming document record to the entry or document.';

                        trigger OnAction()
                        var
                            IncomingDocumentAttachment: Record "Incoming Document Attachment";
                        begin
                            IncomingDocumentAttachment.NewAttachmentFromGenJnlLine(Rec);
                        end;
                    }
                    action(RemoveIncomingDoc)
                    {
                        ApplicationArea = All;
                        Caption = 'Remove Incoming Document';
                        Enabled = HasIncomingDocument;
                        Image = RemoveLine;
                        ToolTip = 'Remove any incoming document records and file attachments.';

                        trigger OnAction()
                        var
                            IncomingDocument: Record "Incoming Document";
                        begin
                            if IncomingDocument.Get(Rec."Incoming Document Entry No.") then
                                IncomingDocument.RemoveLinkToRelatedRecord();
                            Rec."Incoming Document Entry No." := 0;
                            Rec.Modify(true);
                        end;
                    }
                }
            }
            group("B&ank")
            {
                Caption = 'B&ank';
                action(ImportBankStatement)
                {
                    ApplicationArea = All;
                    Caption = 'Import Bank Statement';
                    Image = Import;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    ToolTip = 'Import electronic bank statements from your bank to populate with data about actual bank transactions.';
                    Visible = false;

                    trigger OnAction()
                    begin
                        if Rec.FindLast() then;
                        Rec.ImportBankStatement();
                    end;
                }
                action(ShowStatementLineDetails)
                {
                    ApplicationArea = All;
                    Caption = 'Bank Statement Details';
                    Image = ExternalDocument;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    RunObject = page "Bank Statement Line Details";
                    RunPageLink = "Data Exch. No." = field("Data Exch. Entry No."),
                                  "Line No." = field("Data Exch. Line No.");
                    ToolTip = 'View the content of the imported bank statement file, such as account number, posting date, and amounts.';
                    Visible = false;
                }
                action(Reconcile)
                {
                    ApplicationArea = All;
                    Caption = 'Reconcile';
                    Image = Reconcile;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ShortcutKey = 'Ctrl+F11';
                    ToolTip = 'View the balances on bank accounts that are marked for reconciliation, usually liquid accounts.';

                    trigger OnAction()
                    begin
                        GLReconcile.SetGenJnlLine(Rec);
                        GLReconcile.Run();
                    end;
                }
            }
            group(Application)
            {
                Caption = 'Application';
                action("Apply Entries")
                {
                    ApplicationArea = All;
                    Caption = 'Apply Entries';
                    Ellipsis = true;
                    Enabled = ApplyEntriesActionEnabled;
                    Image = ApplyEntries;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = codeunit "Gen. Jnl.-Apply";
                    ShortcutKey = 'Shift+F11';
                    ToolTip = 'Apply the payment amount on a journal line to a sales or purchase document that was already posted for a customer or vendor. This updates the amount on the posted document, and the document can either be partially paid, or closed as paid or refunded.';
                }
                action(Match)
                {
                    ApplicationArea = All;
                    Caption = 'Apply Automatically';
                    Image = MapAccounts;
                    Promoted = true;
                    PromotedCategory = Category5;
                    PromotedIsBig = true;
                    RunObject = codeunit "Match General Journal Lines";
                    ToolTip = 'Apply payments to their related open entries based on data matches between bank transaction text and entry information.';
                    Visible = false;
                }
                action(AddMappingRule)
                {
                    ApplicationArea = All;
                    Caption = 'Map Text to Account';
                    Image = CheckRulesSyntax;
                    Promoted = true;
                    PromotedCategory = Category5;
                    PromotedIsBig = true;
                    ToolTip = 'Associate text on payments with debit, credit, and balancing accounts, so payments are posted to the accounts when you post payments. The payments are not applied to invoices or credit memos, and are suited for recurring cash receipts or expenses.';
                    Visible = false;

                    trigger OnAction()
                    var
                        TextToAccMapping: Record "Text-to-Account Mapping";
                    begin
                        TextToAccMapping.InsertRec(Rec);
                    end;
                }
            }
            group("Payro&ll")
            {
                Caption = 'Payro&ll';
                action(ImportPayrollFile)
                {
                    ApplicationArea = All;
                    Caption = 'Import Payroll File';
                    Image = Import;
                    Promoted = true;
                    PromotedCategory = Category6;
                    PromotedIsBig = true;
                    ToolTip = 'Import a payroll file that you select.';
                    Visible = false;

                    trigger OnAction()
                    var
                        GeneralLedgerSetup: Record "General Ledger Setup";
                        ImportPayrollTransaction: Codeunit "Import Payroll Transaction";
                    begin
                        GeneralLedgerSetup.Get();
                        GeneralLedgerSetup.TestField("Payroll Trans. Import Format");
                        if Rec.FindLast() then;
                        ImportPayrollTransaction.SelectAndImportPayrollDataToGL(Rec, GeneralLedgerSetup."Payroll Trans. Import Format");
                    end;
                }
                action(ImportPayrollTransactions)
                {
                    ApplicationArea = All;
                    Caption = 'Import Payroll Transactions';
                    Image = ImportChartOfAccounts;
                    Promoted = true;
                    PromotedCategory = Category6;
                    PromotedIsBig = true;
                    ToolTip = 'Add journal lines based on transactions from your payroll service provider.';
                    Visible = ImportPayrollTransactionsAvailable;

                    trigger OnAction()
                    begin
                        if Rec.FindLast() then;
                        PayrollManagement.ImportPayroll(Rec);
                    end;
                }
            }
            group("Request Approval")
            {
                Caption = 'Request Approval';
                group(SendApprovalRequest)
                {
                    Caption = 'Send Approval Request';
                    Image = SendApprovalRequest;
                    action(SendApprovalRequestJournalBatch)
                    {
                        ApplicationArea = All;
                        Caption = 'Journal Batch';
                        Enabled = not OpenApprovalEntriesOnBatchOrAnyJnlLineExist and CanRequestFlowApprovalForBatchAndAllLines;
                        Image = SendApprovalRequest;
                        ToolTip = 'Send all journal lines for approval, also those that you may not see because of filters.';

                        trigger OnAction()
                        var
                            ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                        begin
                            ApprovalsMgmt.TrySendJournalBatchApprovalRequest(Rec);
                            SetControlAppearanceFromBatch();
                            SetControlAppearance();
                        end;
                    }
                    action(SendApprovalRequestJournalLine)
                    {
                        ApplicationArea = All;
                        Caption = 'Selected Journal Lines';
                        Enabled = not OpenApprovalEntriesOnBatchOrCurrJnlLineExist and CanRequestFlowApprovalForBatchAndCurrentLine;
                        Image = SendApprovalRequest;
                        ToolTip = 'Send selected journal lines for approval.';

                        trigger OnAction()
                        var
                            GenJournalLine: Record "Gen. Journal Line";
                            ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                        begin
                            GetCurrentlySelectedLines(GenJournalLine);
                            ApprovalsMgmt.TrySendJournalLineApprovalRequests(GenJournalLine);
                            SetControlAppearanceFromBatch();
                        end;
                    }
                }
                group(CancelApprovalRequest)
                {
                    Caption = 'Cancel Approval Request';
                    Image = Cancel;
                    action(CancelApprovalRequestJournalBatch)
                    {
                        ApplicationArea = All;
                        Caption = 'Journal Batch';
                        Enabled = CanCancelApprovalForJnlBatch or CanCancelFlowApprovalForBatch;
                        Image = CancelApprovalRequest;
                        ToolTip = 'Cancel sending all journal lines for approval, also those that you may not see because of filters.';

                        trigger OnAction()
                        var
                            ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                        begin
                            ApprovalsMgmt.TryCancelJournalBatchApprovalRequest(Rec);
                            SetControlAppearance();
                            SetControlAppearanceFromBatch();
                        end;
                    }
                    action(CancelApprovalRequestJournalLine)
                    {
                        ApplicationArea = All;
                        Caption = 'Selected Journal Lines';
                        Enabled = CanCancelApprovalForJnlLine or CanCancelFlowApprovalForLine;
                        Image = CancelApprovalRequest;
                        ToolTip = 'Cancel sending selected journal lines for approval.';

                        trigger OnAction()
                        var
                            GenJournalLine: Record "Gen. Journal Line";
                            ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                        begin
                            GetCurrentlySelectedLines(GenJournalLine);
                            ApprovalsMgmt.TryCancelJournalLineApprovalRequests(GenJournalLine);
                        end;
                    }
                }
            }
            group(Approval)
            {
                Caption = 'Approval';
                action(Approve)
                {
                    ApplicationArea = All;
                    Caption = 'Approve';
                    Image = Approve;
                    Promoted = true;
                    PromotedCategory = Category7;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    ToolTip = 'Approve the requested changes.';
                    Visible = OpenApprovalEntriesExistForCurrUser;

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        ApprovalsMgmt.ApproveGenJournalLineRequest(Rec);
                    end;
                }
                action(Reject)
                {
                    ApplicationArea = All;
                    Caption = 'Reject';
                    Image = Reject;
                    Promoted = true;
                    PromotedCategory = Category7;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    ToolTip = 'Reject the approval request.';
                    Visible = OpenApprovalEntriesExistForCurrUser;

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        ApprovalsMgmt.RejectGenJournalLineRequest(Rec);
                    end;
                }
                action(Delegate)
                {
                    ApplicationArea = All;
                    Caption = 'Delegate';
                    Image = Delegate;
                    Promoted = true;
                    PromotedCategory = Category7;
                    PromotedOnly = true;
                    ToolTip = 'Delegate the approval to a substitute approver.';
                    Visible = OpenApprovalEntriesExistForCurrUser;

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        ApprovalsMgmt.DelegateGenJournalLineRequest(Rec);
                    end;
                }
                action(Comment)
                {
                    ApplicationArea = All;
                    Caption = 'Comments';
                    Image = ViewComments;
                    Promoted = true;
                    PromotedCategory = Category7;
                    PromotedOnly = true;
                    ToolTip = 'View or add comments for the record.';
                    Visible = OpenApprovalEntriesExistForCurrUser;

                    trigger OnAction()
                    var
                        GenJournalBatch: Record "Gen. Journal Batch";
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        if OpenApprovalEntriesOnJnlLineExist then
                            ApprovalsMgmt.GetApprovalComment(Rec)
                        else
                            if OpenApprovalEntriesOnJnlBatchExist then
                                if GenJournalBatch.Get(Rec."Journal Template Name", Rec."Journal Batch Name") then
                                    ApprovalsMgmt.GetApprovalComment(GenJournalBatch);
                    end;
                }
            }
            group("Opening Balance")
            {
                Caption = 'Opening Balance';
                group("Prepare journal")
                {
                    Caption = 'Prepare journal';
                    Image = Journals;
                    action("G/L Accounts Opening balance ")
                    {
                        ApplicationArea = All;
                        Caption = 'G/L Accounts Opening balance';
                        Image = TransferToGeneralJournal;
                        ToolTip = 'Creates general journal line per G/L account to enable manual entry of G/L account open balances during the setup of a new company';

                        trigger OnAction()
                        var
                            GLAccount: Record "G/L Account";
                            CreateGLAccJournalLines: Report "Create G/L Acc. Journal Lines";
                            DocumentTypes: Option;
                        begin
                            GLAccount.SetRange("Account Type", GLAccount."Account Type"::Posting);
                            GLAccount.SetRange("Income/Balance", GLAccount."Income/Balance"::"Balance Sheet");
                            GLAccount.SetRange("Direct Posting", true);
                            GLAccount.SetRange(Blocked, false);
                            CreateGLAccJournalLines.SetTableView(GLAccount);
                            CreateGLAccJournalLines.InitializeRequest(DocumentTypes, Today, Rec."Journal Template Name", Rec."Journal Batch Name", '');
                            CreateGLAccJournalLines.UseRequestPage(false);
                            Commit();  // Commit is required for Create Lines.
                            CreateGLAccJournalLines.Run();
                        end;
                    }
                    action("Customers Opening balance")
                    {
                        ApplicationArea = All;
                        Caption = 'Customers Opening balance';
                        Image = TransferToGeneralJournal;
                        ToolTip = 'Creates general journal line per Customer to enable manual entry of Customer open balances during the setup of a new company';

                        trigger OnAction()
                        var
                            Customer: Record Customer;
                            CreateCustomerJournalLines: Report "Create Customer Journal Lines";
                            DocumentTypes: Option;
                        begin
                            Customer.SetRange(Blocked, Customer.Blocked::" ");
                            CreateCustomerJournalLines.SetTableView(Customer);
                            CreateCustomerJournalLines.InitializeRequest(DocumentTypes, Today, Today);
                            CreateCustomerJournalLines.InitializeRequestTemplate(Rec."Journal Template Name", Rec."Journal Batch Name", '');
                            CreateCustomerJournalLines.UseRequestPage(false);
                            Commit();  // Commit is required for Create Lines.
                            CreateCustomerJournalLines.Run();
                        end;
                    }
                    action("Vendors Opening balance")
                    {
                        ApplicationArea = All;
                        Caption = 'Vendors Opening balance';
                        Image = TransferToGeneralJournal;
                        ToolTip = 'Creates a general journal line for each vendor. This lets you manually enter open balances for vendors when you set up a new company.';

                        trigger OnAction()
                        var
                            Vendor: Record Vendor;
                            CreateVendorJournalLines: Report "Create Vendor Journal Lines";
                            DocumentTypes: Option;
                        begin
                            Vendor.SetRange(Blocked, Vendor.Blocked::" ");
                            CreateVendorJournalLines.SetTableView(Vendor);
                            CreateVendorJournalLines.InitializeRequest(DocumentTypes, Today, Today);
                            CreateVendorJournalLines.InitializeRequestTemplate(Rec."Journal Template Name", Rec."Journal Batch Name", '');
                            CreateVendorJournalLines.UseRequestPage(false);
                            Commit();  // Commit is required for Create Lines.
                            CreateVendorJournalLines.Run();
                        end;
                    }
                }
            }
            group("Page")
            {
                Caption = 'Page';
                action(EditInExcel)
                {
                    ApplicationArea = All;
                    Caption = 'Edit in Excel';
                    Image = Excel;
                    Promoted = true;
                    PromotedCategory = Category8;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    ToolTip = 'Send the data in the journal to an Excel file for analysis or editing.';
                    Visible = IsSaasExcelAddinEnabled;

                    trigger OnAction()
                    var
                        ODataUtility: Codeunit ODataUtility;
                    begin
                        ODataUtility.EditJournalWorksheetInExcel(CurrPage.Caption, CurrPage.ObjectId(false), Rec."Journal Batch Name", Rec."Journal Template Name");
                    end;
                }
                action(PreviousDocNumberTrx)
                {
                    ApplicationArea = All;
                    Caption = 'Previous Doc No.';
                    Image = PreviousRecord;
                    Promoted = true;
                    PromotedCategory = Category8;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    ToolTip = 'Navigate to previous document number for current batch.';
                    Visible = IsSimplePage;

                    trigger OnAction()
                    begin
                        IterateDocNumbers('+', -1);
                    end;
                }
                action(NextDocNumberTrx)
                {
                    ApplicationArea = All;
                    Caption = 'Next Doc No.';
                    Image = NextRecord;
                    Promoted = true;
                    PromotedCategory = Category8;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    ToolTip = 'Navigate to next document number for current batch.';
                    Visible = IsSimplePage;

                    trigger OnAction()
                    begin
                        IterateDocNumbers('-', 1);
                    end;
                }
                action(ClassicView)
                {
                    ApplicationArea = All;
                    Caption = 'Show More Columns';
                    Image = SetupColumns;
                    Promoted = true;
                    PromotedCategory = Category8;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    ToolTip = 'View all available fields. Fields not frequently used are currently hidden.';
                    Visible = IsSimplePage;

                    trigger OnAction()
                    begin
                        // set journal preference for this page to be NOT simple mode (classic mode)
                        CurrPage.Close();
                        GenJnlManagement.SetJournalSimplePageModePreference(false, Page::"SSA Bank Journal");
                        GenJnlManagement.SetLastViewedJournalBatchName(Page::"SSA Bank Journal", CurrentJnlBatchName);
                        Page.Run(Page::"SSA Bank Journal");
                    end;
                }
                action(SimpleView)
                {
                    ApplicationArea = All;
                    Caption = 'Show Fewer Columns';
                    Image = SetupList;
                    Promoted = true;
                    PromotedCategory = Category8;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    ToolTip = 'Hide fields that are not frequently used.';
                    Visible = not IsSimplePage;

                    trigger OnAction()
                    begin
                        // set journal preference for this page to be simple mode
                        CurrPage.Close();
                        GenJnlManagement.SetJournalSimplePageModePreference(true, Page::"SSA Bank Journal");
                        GenJnlManagement.SetLastViewedJournalBatchName(Page::"SSA Bank Journal", CurrentJnlBatchName);
                        Page.Run(Page::"SSA Bank Journal");
                    end;
                }
                action("New Doc No.")
                {
                    ApplicationArea = All;
                    Caption = 'New Document Number';
                    Image = New;
                    Promoted = true;
                    PromotedCategory = Category8;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    ToolTip = 'Creates a new document number.';
                    Visible = IsSimplePage;

                    trigger OnAction()
                    var
                        GenJournalLine: Record "Gen. Journal Line";
                        GenJnlBatch: Record "Gen. Journal Batch";
                        LastDocNo: Code[20];
                    begin
                        if Rec.Count = 0 then
                            exit;
                        GenJnlBatch.Get(Rec."Journal Template Name", CurrentJnlBatchName);
                        GenJournalLine.Reset();
                        GenJournalLine.SetCurrentKey("Document No.");
                        GenJournalLine.SetRange("Journal Template Name", Rec."Journal Template Name");
                        GenJournalLine.SetRange("Journal Batch Name", Rec."Journal Batch Name");
                        if GenJournalLine.FindLast() then begin
                            LastDocNo := GenJournalLine."Document No.";
                            Rec.IncrementDocumentNo(GenJnlBatch, LastDocNo);
                        end
                        else
                            LastDocNo := NoSeriesMgt.TryGetNextNo(GenJnlBatch."No. Series", Rec."Posting Date");

                        CurrentDocNo := LastDocNo;
                        SetDocumentNumberFilter(CurrentDocNo);
                    end;
                }
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        GenJnlManagement.GetAccounts(Rec, AccName, BalAccName);
        if ClientTypeManagement.GetCurrentClientType() <> ClientType::ODataV4 then
            UpdateBalance();
        EnableApplyEntriesAction();
        SetControlAppearance();
        // PostedFromSimplePage is set to TRUE when 'POST' / 'POST+PRINT' action is executed in simple page mode.
        // It gets set to FALSE when OnNewRecord is called in the simple mode.
        // After posting we try to find the first record and filter on its document number
        // Executing LoaddataFromRecord for incomingDocAttachFactbox is also forcing this (PAG39) page to update
        // and for some reason after posting this page doesn't refresh with the filter set by POST / POST-PRINT action in simple mode.
        // To resolve this only call LoaddataFromRecord if PostedFromSimplePage is FALSE.
        if not PostedFromSimplePage then
            CurrPage.IncomingDocAttachFactBox.Page.LoadDataFromRecord(Rec);

        Rec.CalcFields("SSA Total Amount (LCY)",
            "SSA Bal Acc Balance (LCY)",
            "SSA Bal Acc Balance -1D (LCY)",
            "SSA Credit Amount -1D (LCY)",
            "SSA Credit Amount (LCY)",
            "SSA Debit Amount -1D (LCY)",
            "SSA Debit Amount (LCY)");
        Rec.CalcFields("SSA Debit Amount -1D",
            "SSA Credit Amount -1D",
            "SSA Debit Amount",
            "SSA Credit Amount",
            "SSA Total Amount");
    end;

    trigger OnAfterGetRecord()
    begin
        Rec.CalcFields("SSA Bal Acc Balance -1D (LCY)",
            "SSA Debit Amount -1D (LCY)",
            "SSA Credit Amount -1D (LCY)",
            "SSA Bal Acc Balance (LCY)",
            "SSA Debit Amount (LCY)",
            "SSA Credit Amount (LCY)",
            "SSA Total Amount (LCY)");
        Rec.CalcFields("SSA Debit Amount -1D",
            "SSA Credit Amount -1D",
            "SSA Debit Amount",
            "SSA Credit Amount",
            "SSA Total Amount");
        GenJnlManagement.GetAccounts(Rec, AccName, BalAccName);
        Rec.ShowShortcutDimCode(ShortcutDimCode);
        HasIncomingDocument := Rec."Incoming Document Entry No." <> 0;
        SetUserInteractions();

        //SSA1199>>
        Rec.SetRange("SSA Date Filter", 0D, DateOfBalance);
        Rec.SetRange("SSA Date Filter -1D", 0D, CalcDate('<-1D>', DateOfBalance));
        //SSA1199<<
    end;

    trigger OnInit()
    var
        ClientTypeManagement: Codeunit "Client Type Management";
    begin
        TotalBalanceVisible := true;
        BalanceVisible := true;
        AmountVisible := true;
        // Get simple / classic mode for this page except when called from a webservices (SOAP or ODATA)
        if ClientTypeManagement.GetCurrentClientType() in [ClientType::SOAP, ClientType::OData, ClientType::ODataV4]
        then
            IsSimplePage := false
        else
            IsSimplePage := GenJnlManagement.GetJournalSimplePageModePreference(Page::"SSA Bank Journal");
    end;

    trigger OnModifyRecord(): Boolean
    begin
        SetUserInteractions();
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        UpdateBalance();
        EnableApplyEntriesAction();
        Rec.SetUpNewLine(xRec, Balance, BelowxRec);
        // set values from header for currency code, doc no. and posting date
        // for show less columns or simple page mode
        if IsSimplePage then begin
            PostedFromSimplePage := false;
            SetDataForSimpleModeOnNewRecord();
        end;
        Clear(ShortcutDimCode);
        Clear(AccName);
        SetUserInteractions();
    end;

    trigger OnOpenPage()
    var
        ServerSetting: Codeunit "Server Setting";
        EnvironmentInfo: Codeunit "Environment Information";
        JnlSelected: Boolean;
        LastGenJnlBatch: Code[10];
    begin
        IsSaasExcelAddinEnabled := ServerSetting.GetIsSaasExcelAddinEnabled();
        if ClientTypeManagement.GetCurrentClientType() = ClientType::ODataV4 then
            exit;

        BalAccName := '';
        SetControlVisibility();
        SetDimensionVisibility();
        if Rec.IsOpenedFromBatch() then begin
            CurrentJnlBatchName := Rec."Journal Batch Name";
            GenJnlManagement.OpenJnl(CurrentJnlBatchName, Rec);
            SetControlAppearanceFromBatch();
            SetDataForSimpleModeOnOpen();
            exit;
        end;
        GenJnlManagement.TemplateSelection(Page::"SSA Bank Journal", 0, false, Rec, JnlSelected);
        if not JnlSelected then
            Error('');

        LastGenJnlBatch := GenJnlManagement.GetLastViewedJournalBatchName(Page::"SSA Bank Journal");
        if LastGenJnlBatch <> '' then
            CurrentJnlBatchName := LastGenJnlBatch;
        GenJnlManagement.OpenJnl(CurrentJnlBatchName, Rec);
        SetControlAppearanceFromBatch();

        IsSaaS := EnvironmentInfo.IsSaaS();
        SetDataForSimpleModeOnOpen();

        //SSA1199>>
        DateOfBalance := WorkDate();
        Rec.SetRange("SSA Date Filter", 0D, DateOfBalance);
        Rec.SetRange("SSA Date Filter -1D", 0D, CalcDate('<-1D>', DateOfBalance));
        //SSA1199<<
    end;

    var
        GenJnlManagement: Codeunit GenJnlManagement;
        ReportPrint: Codeunit "Test Report-Print";
        PayrollManagement: Codeunit "Payroll Management";
        ClientTypeManagement: Codeunit "Client Type Management";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        ChangeExchangeRate: Page "Change Exchange Rate";
        GLReconcile: Page Reconciliation;
        CurrentJnlBatchName: Code[10];
        AccName: Text[100];
        BalAccName: Text[100];
        Balance: Decimal;
        TotalBalance: Decimal;
        ShowBalance: Boolean;
        ShowTotalBalance: Boolean;
        ShortcutDimCode: array[8] of Code[20];
        Text000: Label 'General Journal lines have been successfully inserted from Standard General Journal %1.';
        Text001: Label 'Standard General Journal %1 has been successfully created.';
        HasIncomingDocument: Boolean;
        ApplyEntriesActionEnabled: Boolean;

        BalanceVisible: Boolean;

        TotalBalanceVisible: Boolean;
        StyleTxt: Text;
        OpenApprovalEntriesExistForCurrUser: Boolean;
        OpenApprovalEntriesOnJnlBatchExist: Boolean;
        OpenApprovalEntriesOnJnlLineExist: Boolean;
        OpenApprovalEntriesOnBatchOrCurrJnlLineExist: Boolean;
        OpenApprovalEntriesOnBatchOrAnyJnlLineExist: Boolean;
        ShowWorkflowStatusOnBatch: Boolean;
        ShowWorkflowStatusOnLine: Boolean;
        CanCancelApprovalForJnlBatch: Boolean;
        CanCancelApprovalForJnlLine: Boolean;
        ImportPayrollTransactionsAvailable: Boolean;
        IsSaasExcelAddinEnabled: Boolean;
        CanRequestFlowApprovalForBatch: Boolean;
        CanRequestFlowApprovalForBatchAndAllLines: Boolean;
        CanRequestFlowApprovalForBatchAndCurrentLine: Boolean;
        CanCancelFlowApprovalForBatch: Boolean;
        CanCancelFlowApprovalForLine: Boolean;
        AmountVisible: Boolean;
        DebitCreditVisible: Boolean;
        IsSaaS: Boolean;
        IsSimplePage: Boolean;
        CurrentDocNo: Code[20];
        CurrentPostingDate: Date;
        CurrentCurrencyCode: Code[10];
        IsChangingDocNo: Boolean;
        MissingExchangeRatesQst: Label 'There are no exchange rates for currency %1 and date %2. Do you want to add them now? Otherwise, the last change you made will be reverted.', Comment = '%1 - currency code, %2 - posting date';
        DimVisible1: Boolean;
        DimVisible2: Boolean;
        DimVisible3: Boolean;
        DimVisible4: Boolean;
        DimVisible5: Boolean;
        DimVisible6: Boolean;
        DimVisible7: Boolean;
        DimVisible8: Boolean;
        PostedFromSimplePage: Boolean;
        DateOfBalance: Date;

    local procedure UpdateBalance()
    begin
        GenJnlManagement.CalcBalance(Rec, xRec, Balance, TotalBalance, ShowBalance, ShowTotalBalance);
        BalanceVisible := ShowBalance;
        TotalBalanceVisible := ShowTotalBalance;
    end;

    local procedure EnableApplyEntriesAction()
    begin
        ApplyEntriesActionEnabled :=
          (Rec."Account Type" in [Rec."Account Type"::Customer, Rec."Account Type"::Vendor, Rec."Account Type"::Employee]) or
          (Rec."Bal. Account Type" in [Rec."Bal. Account Type"::Customer, Rec."Bal. Account Type"::Vendor, Rec."Bal. Account Type"::Employee]);
    end;

    local procedure CurrentJnlBatchNameOnAfterVali()
    begin
        CurrPage.SaveRecord();
        GenJnlManagement.SetName(CurrentJnlBatchName, Rec);
        SetControlAppearanceFromBatch();
        CurrPage.Update(false);
    end;

    procedure SetUserInteractions()
    begin
        StyleTxt := Rec.GetStyle();
    end;

    local procedure GetCurrentlySelectedLines(var GenJournalLine: Record "Gen. Journal Line"): Boolean
    begin
        CurrPage.SetSelectionFilter(GenJournalLine);
        exit(GenJournalLine.FindSet());
    end;

    local procedure SetControlAppearance()
    var
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
        WorkflowWebhookManagement: Codeunit "Workflow Webhook Management";
        CanRequestFlowApprovalForLine: Boolean;
    begin
        OpenApprovalEntriesExistForCurrUser :=
          OpenApprovalEntriesExistForCurrUser or
          ApprovalsMgmt.HasOpenApprovalEntriesForCurrentUser(Rec.RecordId);

        OpenApprovalEntriesOnJnlLineExist := ApprovalsMgmt.HasOpenApprovalEntries(Rec.RecordId);
        OpenApprovalEntriesOnBatchOrCurrJnlLineExist := OpenApprovalEntriesOnJnlBatchExist or OpenApprovalEntriesOnJnlLineExist;

        ShowWorkflowStatusOnLine := CurrPage.WorkflowStatusLine.Page.SetFilterOnWorkflowRecord(Rec.RecordId);

        CanCancelApprovalForJnlLine := ApprovalsMgmt.CanCancelApprovalForRecord(Rec.RecordId);

        SetPayrollAppearance();

        WorkflowWebhookManagement.GetCanRequestAndCanCancel(Rec.RecordId, CanRequestFlowApprovalForLine, CanCancelFlowApprovalForLine);
        CanRequestFlowApprovalForBatchAndCurrentLine := CanRequestFlowApprovalForBatch and CanRequestFlowApprovalForLine;
    end;

    local procedure IterateDocNumbers(FindTxt: Text; NextNum: Integer)
    var
        GenJournalLine: Record "Gen. Journal Line";
        CurrentDocNoWasFound: Boolean;
        NoLines: Boolean;
    begin
        if Rec.Count = 0 then
            NoLines := true;
        GenJournalLine.Reset();
        GenJournalLine.SetCurrentKey("Document No.", "Line No.");
        GenJournalLine.SetRange("Journal Template Name", Rec."Journal Template Name");
        GenJournalLine.SetRange("Journal Batch Name", Rec."Journal Batch Name");
        // IF GenJournalLine.FIND('+') THEN
        if GenJournalLine.Find(FindTxt) then
            repeat
                if NoLines then begin
                    SetDataForSimpleMode(GenJournalLine);
                    exit;
                end;
                // Find the rec for current doc no.
                if not CurrentDocNoWasFound and (GenJournalLine."Document No." = CurrentDocNo) then
                    CurrentDocNoWasFound := true;
                if CurrentDocNoWasFound and (GenJournalLine."Document No." <> CurrentDocNo) then begin
                    SetDataForSimpleMode(GenJournalLine);
                    exit;
                end;
            until GenJournalLine.Next(NextNum) = 0;
    end;

    local procedure SetPayrollAppearance()
    var
        TempPayrollServiceConnection: Record "Service Connection" temporary;
    begin
        PayrollManagement.OnRegisterPayrollService(TempPayrollServiceConnection);
        ImportPayrollTransactionsAvailable := not TempPayrollServiceConnection.IsEmpty;
    end;

    local procedure SetControlAppearanceFromBatch()
    var
        GenJournalBatch: Record "Gen. Journal Batch";
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
        WorkflowWebhookManagement: Codeunit "Workflow Webhook Management";
        CanRequestFlowApprovalForAllLines: Boolean;
    begin
        if (Rec."Journal Template Name" <> '') and (Rec."Journal Batch Name" <> '') then
            GenJournalBatch.Get(Rec."Journal Template Name", Rec."Journal Batch Name")
        else
            if not GenJournalBatch.Get(Rec.GetRangeMax("Journal Template Name"), CurrentJnlBatchName) then
                exit;

        ShowWorkflowStatusOnBatch := CurrPage.WorkflowStatusBatch.Page.SetFilterOnWorkflowRecord(GenJournalBatch.RecordId);
        OpenApprovalEntriesExistForCurrUser := ApprovalsMgmt.HasOpenApprovalEntriesForCurrentUser(GenJournalBatch.RecordId);
        OpenApprovalEntriesOnJnlBatchExist := ApprovalsMgmt.HasOpenApprovalEntries(GenJournalBatch.RecordId);

        OpenApprovalEntriesOnBatchOrAnyJnlLineExist :=
          OpenApprovalEntriesOnJnlBatchExist or
          ApprovalsMgmt.HasAnyOpenJournalLineApprovalEntries(Rec."Journal Template Name", Rec."Journal Batch Name");

        CanCancelApprovalForJnlBatch := ApprovalsMgmt.CanCancelApprovalForRecord(GenJournalBatch.RecordId);

        WorkflowWebhookManagement.GetCanRequestAndCanCancelJournalBatch(
          GenJournalBatch, CanRequestFlowApprovalForBatch, CanCancelFlowApprovalForBatch, CanRequestFlowApprovalForAllLines);
        CanRequestFlowApprovalForBatchAndAllLines := CanRequestFlowApprovalForBatch and CanRequestFlowApprovalForAllLines;
    end;

    local procedure SetControlVisibility()
    var
        GLSetup: Record "General Ledger Setup";
    begin
        GLSetup.Get();
        if IsSimplePage then begin
            AmountVisible := false;
            DebitCreditVisible := true;
        end
        else begin
            AmountVisible := not (GLSetup."Show Amounts" = GLSetup."Show Amounts"::"Debit/Credit Only");
            DebitCreditVisible := not (GLSetup."Show Amounts" = GLSetup."Show Amounts"::"Amount Only");
        end;
    end;

    local procedure SetDocumentNumberFilter(DocNoToSet: Code[20])
    var
        OriginalFilterGroup: Integer;
    begin
        OriginalFilterGroup := Rec.FilterGroup;
        Rec.FilterGroup := 25;
        Rec.SetFilter("Document No.", DocNoToSet);
        Rec.FilterGroup := OriginalFilterGroup;
    end;

    local procedure SetDimensionVisibility()
    var
        DimMgt: Codeunit DimensionManagement;
    begin
        DimVisible1 := false;
        DimVisible2 := false;
        DimVisible3 := false;
        DimVisible4 := false;
        DimVisible5 := false;
        DimVisible6 := false;
        DimVisible7 := false;
        DimVisible8 := false;

        if not IsSimplePage then
            DimMgt.UseShortcutDims(
              DimVisible1, DimVisible2, DimVisible3, DimVisible4, DimVisible5, DimVisible6, DimVisible7, DimVisible8);

        Clear(DimMgt);
    end;

    local procedure DisplayTotalDebit(): Decimal
    var
        GenJournalLine: Record "Gen. Journal Line";
        TotalDebitAmt: Decimal;
    begin
        Clear(TotalDebitAmt);
        GenJournalLine.Reset();
        GenJournalLine.SetRange("Journal Template Name", Rec."Journal Template Name");
        GenJournalLine.SetRange("Journal Batch Name", Rec."Journal Batch Name");
        if IsSimplePage then
            GenJournalLine.SetRange("Document No.", CurrentDocNo);
        if GenJournalLine.Find('-') then
            repeat
                TotalDebitAmt := TotalDebitAmt + GenJournalLine."Debit Amount";
            until GenJournalLine.Next() = 0;
        exit(TotalDebitAmt);
    end;

    local procedure DisplayTotalCredit(): Decimal
    var
        GenJournalLine: Record "Gen. Journal Line";
        TotalCreditAmt: Decimal;
    begin
        Clear(TotalCreditAmt);
        GenJournalLine.Reset();
        GenJournalLine.SetRange("Journal Template Name", Rec."Journal Template Name");
        GenJournalLine.SetRange("Journal Batch Name", Rec."Journal Batch Name");
        if IsSimplePage then
            GenJournalLine.SetRange("Document No.", CurrentDocNo);
        if GenJournalLine.Find('-') then
            repeat
                TotalCreditAmt := TotalCreditAmt + GenJournalLine."Credit Amount";
            until GenJournalLine.Next() = 0;
        exit(TotalCreditAmt);
    end;

    local procedure SetDataForSimpleMode(GenJournalLine1: Record "Gen. Journal Line")
    begin
        CurrentDocNo := GenJournalLine1."Document No.";
        CurrentPostingDate := GenJournalLine1."Posting Date";
        CurrentCurrencyCode := GenJournalLine1."Currency Code";
        SetDocumentNumberFilter(CurrentDocNo);
    end;

    local procedure SetDataForSimpleModeOnOpen()
    begin
        if IsSimplePage then begin
            // Filter on the first record
            Rec.SetCurrentKey("Document No.", "Line No.");
            if Rec.FindFirst() then
                SetDataForSimpleMode(Rec)
            else begin
                // if no rec is found reset the currentposting date to workdate and currency code to empty
                CurrentPostingDate := WorkDate();
                Clear(CurrentCurrencyCode);
            end;
        end;
    end;

    local procedure SetDataForSimpleModeOnBatchChange()
    var
        GenJournalLine: Record "Gen. Journal Line";
    begin
        GenJnlManagement.SetLastViewedJournalBatchName(Page::"SSA Bank Journal", CurrentJnlBatchName);
        // Need to set up simple page mode properties on batch change
        if IsSimplePage then begin
            GenJournalLine.Reset();
            GenJournalLine.SetRange("Journal Template Name", Rec."Journal Template Name");
            GenJournalLine.SetRange("Journal Batch Name", CurrentJnlBatchName);
            if GenJournalLine.FindFirst() then
                SetDataForSimpleMode(GenJournalLine);
        end;
    end;

    local procedure SetDataForSimpleModeOnNewRecord()
    begin
        // No lines shown
        if Rec.Count = 0 then
            // If xrec."Document No." is empty that means this is the first entry for a batch
            // In this case we want to assign current doc no. to the document no. of the record
            // But if user changes the doc no. then we want to use whatever value they enter for
            // current doc no.
            if (xRec."Document No." = '') and (not IsChangingDocNo) then
                CurrentDocNo := Rec."Document No."
            else begin
                Rec."Document No." := CurrentDocNo;
                // Clear out credit / debit for empty page since these
                // might have been set if suggest balance amount is checked on the batch
                Rec.Validate("Credit Amount", 0);
                Rec.Validate("Debit Amount", 0);
            end
        else
            Rec."Document No." := CurrentDocNo;

        //SSA1199 "Currency Code" := CurrentCurrencyCode;
        if CurrentPostingDate <> 0D then
            Rec.Validate("Posting Date", CurrentPostingDate);
    end;

    local procedure SetDataForSimpleModeOnPropValidation(FiledNumber: Integer)
    var
        GenJournalLine: Record "Gen. Journal Line";
    begin
        if IsSimplePage and (Rec.Count > 0) then begin
            GenJournalLine.Reset();
            GenJournalLine.SetRange("Journal Template Name", Rec."Journal Template Name");
            GenJournalLine.SetRange("Journal Batch Name", Rec."Journal Batch Name");
            GenJournalLine.SetRange("Document No.", CurrentDocNo);
            if GenJournalLine.Find('-') then
                repeat
                    case FiledNumber of
                        GenJournalLine.FieldNo("Currency Code"):
                            GenJournalLine.Validate("Currency Code", CurrentCurrencyCode);
                        GenJournalLine.FieldNo("Posting Date"):
                            GenJournalLine.Validate("Posting Date", CurrentPostingDate);
                    end;
                    GenJournalLine.Modify();
                until GenJournalLine.Next() = 0;
        end;
        CurrPage.Update(false);
    end;

    local procedure SetDataForSimpleModeOnPost()
    begin
        PostedFromSimplePage := true;
        Rec.SetCurrentKey("Document No.", "Line No.");
        if Rec.FindFirst() then
            SetDataForSimpleMode(Rec)
    end;

    local procedure UpdateCurrencyFactor(FieldNo: Integer)
    var
        UpdateCurrencyExchangeRates: Codeunit "Update Currency Exchange Rates";
        ConfirmManagement: Codeunit "Confirm Management";
    begin
        if CurrentCurrencyCode <> '' then
            if UpdateCurrencyExchangeRates.ExchangeRatesForCurrencyExist(CurrentPostingDate, CurrentCurrencyCode) then
                SetDataForSimpleModeOnPropValidation(FieldNo)
            else
                if ConfirmManagement.GetResponseOrDefault(
                     StrSubstNo(MissingExchangeRatesQst, CurrentCurrencyCode, CurrentPostingDate), true)
                then begin
                    UpdateCurrencyExchangeRates.OpenExchangeRatesPage(CurrentCurrencyCode);
                    UpdateCurrencyFactor(FieldNo);
                end
                else begin
                    CurrentCurrencyCode := Rec."Currency Code";
                    CurrentPostingDate := Rec."Posting Date";
                end
        else
            SetDataForSimpleModeOnPropValidation(FieldNo);
    end;
}
