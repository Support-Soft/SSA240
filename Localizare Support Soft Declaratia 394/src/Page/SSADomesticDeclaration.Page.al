page 71700 "SSA Domestic Declaration"
{
    // SSA973 SSCAT 06.09.2019 39.Rapoarte legale- Localizare Declaratia 394

    AutoSplitKey = true;
    Caption = 'Domestic Declaration';
    DelayedInsert = true;
    PageType = Worksheet;
    SaveValues = false;
    SourceTable = "SSA Domestic Declaration Line";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            field(CurrentDeclarationNo; CurrentDeclarationCode)
            {
                Caption = 'Domestic Declaration Code';
                Lookup = true;
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Domestic Declaration Code field.';
                trigger OnLookup(var Text: Text): Boolean
                begin
                    exit(DomesticDeclarationLine.LookupName(Rec.GetRangeMax("Domestic Declaration Code"), Text));
                end;

                trigger OnValidate()
                begin
                    DomesticDeclarationLine.CheckName(CurrentDeclarationCode, Rec);
                    CurrentDeclarationNoOnAfterVal;
                end;
            }
            repeater(Control1390000)
            {
                ShowCaption = false;
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Posting Date field.';
                }
                field("Document Date"; Rec."Document Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Document Date field.';
                }
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Document No. field.';
                }
                field("Document Type"; Rec."Document Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Document Type field.';
                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Type field.';
                }
                field(Base; Rec.Base)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Base field.';
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Amount field.';
                }
                field("VAT Calculation Type"; Rec."VAT Calculation Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the VAT Calculation Type field.';
                }
                field("Bill-to/Pay-to No."; Rec."Bill-to/Pay-to No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Bill-to/Pay-to No. field.';
                }
                field("Detailed 394 Decl."; Rec."Detailed 394 Decl.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Detailed 394 Decl. field.';
                }
                field("Source Code"; Rec."Source Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Source Code field.';
                }
                field("Transaction No."; Rec."Transaction No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Transaction No. field.';
                }
                field("External Document No."; Rec."External Document No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the External Document No. field.';
                }
                field("Record Document Number"; Rec."Record Document Number")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Record Document Number field.';
                }
                field("VAT Bus. Posting Group"; Rec."VAT Bus. Posting Group")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the VAT Bus. Posting Group field.';
                }
                field("VAT Prod. Posting Group"; Rec."VAT Prod. Posting Group")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the VAT Prod. Posting Group field.';
                }
                field("VAT Registration No."; Rec."VAT Registration No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the VAT Registration No. field.';
                }
                field("Vendor/Customer Name"; Rec."Vendor/Customer Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Vendor/Customer Name field.';
                }
                field("Source VAT Entry No."; Rec."Source VAT Entry No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Source VAT Entry No. field.';
                }
                field("Postponed VAT Payment"; Rec."Postponed VAT Payment")
                {
                    Editable = false;
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Postponed VAT Payment field.';
                }
                field(Correction; Rec.Correction)
                {
                    Visible = false;
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Correction field.';
                }
                field("Unrealized VAT Entry No."; Rec."Unrealized VAT Entry No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Unrealized VAT Entry No. field.';
                }
                field("Not Declaration 394"; Rec."Not Declaration 394")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Not Declaration 394 field.';
                }
                field("Tip Document D394"; Rec."Tip Document D394")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Tip Document D394 field.';
                }
                field("Stare Factura"; Rec."Stare Factura")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Stare Factura field.';
                }
                field("Tip Partener"; Rec."Tip Partener")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Tip Partener field.';
                }
                field("Tip Operatie"; Rec."Tip Operatie")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Tip Operatie field.';
                }
                field("Cod Serie Factura"; Rec."Cod Serie Factura")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the No. Series field.';
                }
                field("Cod CAEN"; Rec."Cod CAEN")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Cod CAEN field.';
                }
                field("Tip Operatiune CAEN"; Rec."Tip Operatiune CAEN")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Tip Operatiune CAEN field.';
                }
                field("Tax Group Code"; Rec."Tax Group Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Tax Group Code field.';
                }
                field("Organization type"; Rec."Organization type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Organization type field.';
                }
                field("VAT to pay"; Rec."VAT to pay")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the VAT to pay field.';
                }
                field(Cota; Rec.Cota)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Journals VAT % field.';
                }
                field("Cod tara D394"; Rec."Cod tara D394")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Cod tara D394 field.';
                }
                field("Cod Judet D394"; Rec."Cod Judet D394")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Cod Judet D394 field.';
                }
                field("Persoana Afiliata"; Rec."Persoana Afiliata")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Persoana Afiliata field.';
                }
            }
            group(Control1390001)
            {
                ShowCaption = false;
                field(TotalVATBase; TotalVATBase + Rec.Base - xRec.Base)
                {
                    AutoFormatType = 1;
                    Caption = 'Total VAT Base';
                    Editable = false;
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Total VAT Base field.';
                }
                field(TotalVATAmount; TotalVATAmount + Rec.Amount - xRec.Amount)
                {
                    ApplicationArea = All;
                    AutoFormatType = 1;
                    Caption = 'Total VAT Amount';
                    Editable = false;
                    ToolTip = 'Specifies the value of the Total VAT Amount field.';
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Export XML")
            {
                ApplicationArea = All;
                Caption = 'Export XML';
                Ellipsis = true;
                Image = Print;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Executes the Export XML action.';
                trigger OnAction()
                var
                    DomesticDeclaration: Record "SSA Domestic Declaration";
                    PrintDomesticDeclaration: Report "SSA Domestic Declaration 2016";
                begin
                    if DomesticDeclaration.Get(CurrentDeclarationCode) then begin
                        DomesticDeclaration.TestField(Reported, false);
                    end;

                    DomesticDeclaration.SetRange(Code, CurrentDeclarationCode);
                    PrintDomesticDeclaration.SetTableView(DomesticDeclaration);
                    PrintDomesticDeclaration.RunModal;
                    Clear(PrintDomesticDeclaration);
                end;
            }
            action("Get Entries")
            {
                ApplicationArea = All;
                Caption = 'Get Entries';
                Ellipsis = true;
                Image = GetEntries;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Executes the Get Entries action.';
                trigger OnAction()
                var
                    DomesticDeclarationLine: Record "SSA Domestic Declaration Line";
                    GetVATEntries: Report "SSA Get VAT Entries D394";
                begin
                    DomesticDeclaration.Get(CurrentDeclarationCode);
                    DomesticDeclaration.TestField(Reported, false);

                    GetVATEntries.SetCurrDeclarationNo(CurrentDeclarationCode);
                    GetVATEntries.RunModal;
                    Clear(GetVATEntries);
                end;
            }
            action("Anulare Serie")
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = report "SSA Anulare Serie D394";
                ToolTip = 'Executes the Anulare Serie action.';
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        OnAfterGetCurrRecordProcedure;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        OnAfterGetCurrRecordProcedure();
    end;

    trigger OnOpenPage()
    begin
        if Rec.GetFilter("Domestic Declaration Code") <> '' then
            CurrentDeclarationCode := Rec.GetRangeMax("Domestic Declaration Code");
        DomesticDeclarationLine.OpenJnl(CurrentDeclarationCode, Rec);
    end;

    var
        DomesticDeclaration: Record "SSA Domestic Declaration";
        DomesticDeclarationLine: Record "SSA Domestic Declaration Line";
        CurrentDeclarationCode: Code[10];
        TotalVATBase: Decimal;
        TotalVATAmount: Decimal;
        DomesticDeclaration1: Record "SSA Domestic Declaration";
        GetDomesticDeclaration: Report "SSA Get VAT Entries D394";

    local procedure CalcBalance()
    var
        TempDeclarationLine: Record "SSA Domestic Declaration Line";
    begin
        TempDeclarationLine.CopyFilters(Rec);

        if TempDeclarationLine.CalcSums(Base) then begin
            if Rec."Line No." <> 0 then
                TotalVATBase := TempDeclarationLine.Base
            else
                TotalVATBase := TempDeclarationLine.Base + xRec.Base;
        end;

        if TempDeclarationLine.CalcSums(Amount) then begin
            if Rec."Line No." <> 0 then
                TotalVATAmount := TempDeclarationLine.Amount
            else
                TotalVATAmount := TempDeclarationLine.Amount + xRec.Amount;
        end;
    end;

    local procedure CurrentDeclarationNoOnAfterVal()
    begin
        CurrPage.SaveRecord;
        DomesticDeclarationLine.SetName(CurrentDeclarationCode, Rec);
        CurrPage.Update(false);
    end;

    local procedure OnAfterGetCurrRecordProcedure()
    begin
        xRec := Rec;
        CalcBalance;

        DomesticDeclarationLine.Copy(Rec);
        if not DomesticDeclarationLine.FindFirst then begin
            TotalVATBase := TotalVATBase - xRec.Base;
            TotalVATAmount := TotalVATAmount - xRec.Amount;
        end;
    end;

    local procedure OnBeforePutRecord()
    begin
        CalcBalance;
    end;

    procedure SetCurrentDeclarationCode(_CurrentDeclarationCode: Code[10])
    begin
        CurrentDeclarationCode := _CurrentDeclarationCode;
    end;
}
