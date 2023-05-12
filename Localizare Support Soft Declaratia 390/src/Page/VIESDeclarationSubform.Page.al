page 71503 "SSA VIES Declaration Subform"
{
    // SSA974 SSCAT 11.10.2019 40.Rapoarte legale-Declaratia 390

    AutoSplitKey = true;
    Caption = 'VIES Declaration Subform';
    DelayedInsert = true;
    MultipleNewLines = true;
    PageType = ListPart;
    SourceTable = "SSA VIES Line";

    layout
    {
        area(content)
        {
            repeater(Control1470000)
            {
                ShowCaption = false;
                field("Trade Type"; "Trade Type")
                {
                    ApplicationArea = All;
                }
                field("Line Type"; "Line Type")
                {
                    ApplicationArea = All;
                }
                field("Country/Region Code"; "Country/Region Code")
                {
                    ApplicationArea = All;
                }
                field("EU Service"; "EU Service")
                {
                    ApplicationArea = All;
                }
                field("VAT Registration No."; "VAT Registration No.")
                {
                    ApplicationArea = All;
                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        case "Trade Type" of
                            "Trade Type"::Sale:
                                begin
                                    Clear(CustList);
                                    CustList.LookupMode(true);
                                    Cust.SetCurrentKey("Country/Region Code");
                                    Cust.SetRange("Country/Region Code", "Country/Region Code");
                                    CustList.SetTableView(Cust);
                                    if CustList.RunModal = ACTION::LookupOK then begin
                                        CustList.GetRecord(Cust);
                                        Cust.TestField("VAT Registration No.");
                                        Validate("Country/Region Code", Cust."Country/Region Code");
                                        Validate("VAT Registration No.", Cust."VAT Registration No.");
                                    end;
                                end;
                            "Trade Type"::Purchase:
                                begin
                                    Clear(VendList);
                                    Vend.SetCurrentKey("Country/Region Code");
                                    Vend.SetRange("Country/Region Code", "Country/Region Code");
                                    VendList.SetTableView(Vend);
                                    VendList.LookupMode(true);
                                    if VendList.RunModal = ACTION::LookupOK then begin
                                        VendList.GetRecord(Vend);
                                        Vend.TestField("VAT Registration No.");
                                        Validate("Country/Region Code", Vend."Country/Region Code");
                                        Validate("VAT Registration No.", Vend."VAT Registration No.");
                                    end;
                                end;
                        end;
                    end;
                }
                field("Number of Supplies"; "Number of Supplies")
                {
                    ApplicationArea = All;
                }
                field("Amount (LCY)"; "Amount (LCY)")
                {
                    ApplicationArea = All;

                    trigger OnDrillDown()
                    begin
                        DrillDownAmountLCY;
                    end;
                }
                field("Trade Role Type"; "Trade Role Type")
                {
                    ApplicationArea = All;
                }
                field("Cust/Vend Name"; "Cust/Vend Name")
                {
                    ApplicationArea = All;
                }
                field("Tax Group Code"; "Tax Group Code")
                {
                    ApplicationArea = All;
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
        if VIESDeclarationHeader.Get("VIES Declaration No.") then
            "Trade Type" := VIESDeclarationHeader."Trade Type";
    end;

    var
        Cust: Record Customer;
        Vend: Record Vendor;
        CustList: Page "Customer List";
        VendList: Page "Vendor List";
}

