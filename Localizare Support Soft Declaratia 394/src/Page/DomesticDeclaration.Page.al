page 71700 "SSA Domestic Declaration"
{
    // SSA973 SSCAT 06.09.2019 39.Rapoarte legale- Localizare Declaratia 394

    AutoSplitKey = true;
    Caption = 'Domestic Declaration';
    DelayedInsert = true;
    PageType = Worksheet;
    SaveValues = false;
    SourceTable = "SSA Domestic Declaration Line";

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
                    exit(DomesticDeclarationLine.LookupName(GetRangeMax("Domestic Declaration Code"), Text));
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
                field("Posting Date"; "Posting Date")
                {
                    ApplicationArea = All;
                }
                field("Document Date"; "Document Date")
                {
                    ApplicationArea = All;
                }
                field("Document No."; "Document No.")
                {
                    ApplicationArea = All;
                }
                field("Document Type"; "Document Type")
                {
                    ApplicationArea = All;
                }
                field(Type; Type)
                {
                    ApplicationArea = All;
                }
                field(Base; Base)
                {
                    ApplicationArea = All;
                }
                field(Amount; Amount)
                {
                    ApplicationArea = All;
                }
                field("VAT Calculation Type"; "VAT Calculation Type")
                {
                    ApplicationArea = All;
                }
                field("Bill-to/Pay-to No."; "Bill-to/Pay-to No.")
                {
                    ApplicationArea = All;
                }
                field("Detailed 394 Decl."; "Detailed 394 Decl.")
                {
                    ApplicationArea = All;
                }
                field("Source Code"; "Source Code")
                {
                    ApplicationArea = All;
                }
                field("Transaction No."; "Transaction No.")
                {
                    ApplicationArea = All;
                }
                field("External Document No."; "External Document No.")
                {
                    ApplicationArea = All;
                }
                field("Record Document Number"; "Record Document Number")
                {
                    ApplicationArea = All;
                }
                field("VAT Bus. Posting Group"; "VAT Bus. Posting Group")
                {
                    ApplicationArea = All;
                }
                field("VAT Prod. Posting Group"; "VAT Prod. Posting Group")
                {
                    ApplicationArea = All;
                }
                field("VAT Registration No."; "VAT Registration No.")
                {
                    ApplicationArea = All;
                }
                field("Vendor/Customer Name"; "Vendor/Customer Name")
                {
                    ApplicationArea = All;
                }
                field("Source VAT Entry No."; "Source VAT Entry No.")
                {
                    ApplicationArea = All;
                }
                field("Postponed VAT Payment"; "Postponed VAT Payment")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field(Correction; Correction)
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Unrealized VAT Entry No."; "Unrealized VAT Entry No.")
                {
                    ApplicationArea = All;
                }
                field("Not Declaration 394"; "Not Declaration 394")
                {
                    ApplicationArea = All;
                }
                field("Tip Document D394"; "Tip Document D394")
                {
                    ApplicationArea = All;
                }
                field("Stare Factura"; "Stare Factura")
                {
                    ApplicationArea = All;
                }
                field("Tip Partener"; "Tip Partener")
                {
                    ApplicationArea = All;
                }
                field("Tip Operatie"; "Tip Operatie")
                {
                    ApplicationArea = All;
                }
                field("Cod Serie Factura"; "Cod Serie Factura")
                {
                    ApplicationArea = All;
                }
                field("Cod CAEN"; "Cod CAEN")
                {
                    ApplicationArea = All;
                }
                field("Tip Operatiune CAEN"; "Tip Operatiune CAEN")
                {
                    ApplicationArea = All;
                }
                field("Tax Group Code"; "Tax Group Code")
                {
                    ApplicationArea = All;
                }
                field("Organization type"; "Organization type")
                {
                    ApplicationArea = All;
                }
                field("VAT to pay"; "VAT to pay")
                {
                    ApplicationArea = All;
                }
                field(Cota; Cota)
                {
                    ApplicationArea = All;
                }
                field("Cod tara D394"; "Cod tara D394")
                {
                    ApplicationArea = All;
                }
                field("Cod Judet D394"; "Cod Judet D394")
                {
                    ApplicationArea = All;
                }
                field("Persoana Afiliata"; "Persoana Afiliata")
                {
                    ApplicationArea = All;
                }
            }
            group(Control1390001)
            {
                ShowCaption = false;
                field(TotalVATBase; TotalVATBase + Base - xRec.Base)
                {
                    AutoFormatType = 1;
                    Caption = 'Total VAT Base';
                    Editable = false;
                    ApplicationArea = All;
                }
                field(TotalVATAmount; TotalVATAmount + Amount - xRec.Amount)
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
        if GetFilter("Domestic Declaration Code") <> '' then
            CurrentDeclarationCode := GetRangeMax("Domestic Declaration Code");
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
            if "Line No." <> 0 then
                TotalVATBase := TempDeclarationLine.Base
            else
                TotalVATBase := TempDeclarationLine.Base + xRec.Base;
        end;

        if TempDeclarationLine.CalcSums(Amount) then begin
            if "Line No." <> 0 then
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

