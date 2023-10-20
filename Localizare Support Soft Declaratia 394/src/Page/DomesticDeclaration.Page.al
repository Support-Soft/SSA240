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
                }
                field("Document Date"; Rec."Document Date")
                {
                    ApplicationArea = All;
                }
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = All;
                }
                field("Document Type"; Rec."Document Type")
                {
                    ApplicationArea = All;
                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = All;
                }
                field(Base; Rec.Base)
                {
                    ApplicationArea = All;
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = All;
                }
                field("VAT Calculation Type"; Rec."VAT Calculation Type")
                {
                    ApplicationArea = All;
                }
                field("Bill-to/Pay-to No."; Rec."Bill-to/Pay-to No.")
                {
                    ApplicationArea = All;
                }
                field("Detailed 394 Decl."; Rec."Detailed 394 Decl.")
                {
                    ApplicationArea = All;
                }
                field("Source Code"; Rec."Source Code")
                {
                    ApplicationArea = All;
                }
                field("Transaction No."; Rec."Transaction No.")
                {
                    ApplicationArea = All;
                }
                field("External Document No."; Rec."External Document No.")
                {
                    ApplicationArea = All;
                }
                field("Record Document Number"; Rec."Record Document Number")
                {
                    ApplicationArea = All;
                }
                field("VAT Bus. Posting Group"; Rec."VAT Bus. Posting Group")
                {
                    ApplicationArea = All;
                }
                field("VAT Prod. Posting Group"; Rec."VAT Prod. Posting Group")
                {
                    ApplicationArea = All;
                }
                field("VAT Registration No."; Rec."VAT Registration No.")
                {
                    ApplicationArea = All;
                }
                field("Vendor/Customer Name"; Rec."Vendor/Customer Name")
                {
                    ApplicationArea = All;
                }
                field("Source VAT Entry No."; Rec."Source VAT Entry No.")
                {
                    ApplicationArea = All;
                }
                field("Postponed VAT Payment"; Rec."Postponed VAT Payment")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field(Correction; Rec.Correction)
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Unrealized VAT Entry No."; Rec."Unrealized VAT Entry No.")
                {
                    ApplicationArea = All;
                }
                field("Not Declaration 394"; Rec."Not Declaration 394")
                {
                    ApplicationArea = All;
                }
                field("Tip Document D394"; Rec."Tip Document D394")
                {
                    ApplicationArea = All;
                }
                field("Stare Factura"; Rec."Stare Factura")
                {
                    ApplicationArea = All;
                }
                field("Tip Partener"; Rec."Tip Partener")
                {
                    ApplicationArea = All;
                }
                field("Tip Operatie"; Rec."Tip Operatie")
                {
                    ApplicationArea = All;
                }
                field("Cod Serie Factura"; Rec."Cod Serie Factura")
                {
                    ApplicationArea = All;
                }
                field("Cod CAEN"; Rec."Cod CAEN")
                {
                    ApplicationArea = All;
                }
                field("Tip Operatiune CAEN"; Rec."Tip Operatiune CAEN")
                {
                    ApplicationArea = All;
                }
                field("Tax Group Code"; Rec."Tax Group Code")
                {
                    ApplicationArea = All;
                }
                field("Organization type"; Rec."Organization type")
                {
                    ApplicationArea = All;
                }
                field("VAT to pay"; Rec."VAT to pay")
                {
                    ApplicationArea = All;
                }
                field(Cota; Rec.Cota)
                {
                    ApplicationArea = All;
                }
                field("Cod tara D394"; Rec."Cod tara D394")
                {
                    ApplicationArea = All;
                }
                field("Cod Judet D394"; Rec."Cod Judet D394")
                {
                    ApplicationArea = All;
                }
                field("Persoana Afiliata"; Rec."Persoana Afiliata")
                {
                    ApplicationArea = All;
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
                }
                field(TotalVATAmount; TotalVATAmount + Rec.Amount - xRec.Amount)
                {
                    ApplicationArea = All;
                    AutoFormatType = 1;
                    Caption = 'Total VAT Amount';
                    Editable = false;
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
                RunObject = Report "SSA Anulare Serie D394";
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

