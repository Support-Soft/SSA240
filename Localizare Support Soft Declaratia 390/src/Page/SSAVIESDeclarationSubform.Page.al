page 71503 "SSA VIES Declaration Subform"
{
    // SSA974 SSCAT 11.10.2019 40.Rapoarte legale-Declaratia 390

    AutoSplitKey = true;
    Caption = 'VIES Declaration Subform';
    DelayedInsert = true;
    MultipleNewLines = true;
    PageType = ListPart;
    SourceTable = "SSA VIES Line";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Control1470000)
            {
                ShowCaption = false;
                field("Trade Type"; Rec."Trade Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Trade Type field.';
                }
                field("Line Type"; Rec."Line Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Line Type field.';
                }
                field("Country/Region Code"; Rec."Country/Region Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Country/Region Code field.';
                }
                field("EU Service"; Rec."EU Service")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the EU Service field.';
                }
                field("VAT Registration No."; Rec."VAT Registration No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the VAT Registration No. field.';
                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        case Rec."Trade Type" of
                            Rec."Trade Type"::Sale:
                                begin
                                    Clear(CustList);
                                    CustList.LookupMode(true);
                                    Cust.SetCurrentKey("Country/Region Code");
                                    Cust.SetRange("Country/Region Code", Rec."Country/Region Code");
                                    CustList.SetTableView(Cust);
                                    if CustList.RunModal = ACTION::LookupOK then begin
                                        CustList.GetRecord(Cust);
                                        Cust.TestField("VAT Registration No.");
                                        Rec.Validate("Country/Region Code", Cust."Country/Region Code");
                                        Rec.Validate("VAT Registration No.", Cust."VAT Registration No.");
                                    end;
                                end;
                            Rec."Trade Type"::Purchase:
                                begin
                                    Clear(VendList);
                                    Vend.SetCurrentKey("Country/Region Code");
                                    Vend.SetRange("Country/Region Code", Rec."Country/Region Code");
                                    VendList.SetTableView(Vend);
                                    VendList.LookupMode(true);
                                    if VendList.RunModal = ACTION::LookupOK then begin
                                        VendList.GetRecord(Vend);
                                        Vend.TestField("VAT Registration No.");
                                        Rec.Validate("Country/Region Code", Vend."Country/Region Code");
                                        Rec.Validate("VAT Registration No.", Vend."VAT Registration No.");
                                    end;
                                end;
                        end;
                    end;
                }
                field("Number of Supplies"; Rec."Number of Supplies")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Number of Supplies field.';
                }
                field("Amount (LCY)"; Rec."Amount (LCY)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Amount (LCY) field.';
                    trigger OnDrillDown()
                    begin
                        Rec.DrillDownAmountLCY;
                    end;
                }
                field("Trade Role Type"; Rec."Trade Role Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Trade Role Type field.';
                }
                field("Cust/Vend Name"; Rec."Cust/Vend Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Customer/Vendor Name field.';
                }
                field("Tax Group Code"; Rec."Tax Group Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Tax Group Code field.';
                }
            }
        }
    }

    actions
    {
    }

    trigger OnNewRecord(BelowxRec: Boolean)
    var
        VIESDeclarationHeader: Record "SSA VIES Header";
    begin
        if VIESDeclarationHeader.Get(Rec."VIES Declaration No.") then
            Rec."Trade Type" := VIESDeclarationHeader."Trade Type";
    end;

    var
        Cust: Record Customer;
        Vend: Record Vendor;
        CustList: Page "Customer List";
        VendList: Page "Vendor List";
}