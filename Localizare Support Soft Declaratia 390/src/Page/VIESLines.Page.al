page 71504 "SSA VIES Lines"
{
    // SSA974 SSCAT 11.10.2019 40.Rapoarte legale-Declaratia 390

    Caption = 'SSA VIES Lines';
    Editable = false;
    PageType = List;
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
                field("Country/Region Code"; "Country/Region Code")
                {
                    ApplicationArea = All;
                }
                field("VAT Registration No."; "VAT Registration No.")
                {
                    ApplicationArea = All;
                }
                field("EU Service"; "EU Service")
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
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage()
    begin
        SetRange("VIES Declaration No.", VIESHeader."Corrected Declaration No.");
        SetRange("Line Type", "Line Type"::New);
    end;

    var
        VIESHeader: Record "SSA VIES Header";
        VIESLine: Record "SSA VIES Line";
        VIESLine2: Record "SSA VIES Line";
        LastLineNo: Integer;

    procedure SetToDeclaration(NewVIESHeader: Record "SSA VIES Header")
    begin
        VIESHeader := NewVIESHeader;
        VIESLine.SetRange("VIES Declaration No.", VIESHeader."No.");
        if VIESLine.FindLast then
            LastLineNo := VIESLine."Line No."
        else
            LastLineNo := 0;
    end;

    procedure CopyLineToDeclaration()
    begin
        CurrPage.SetSelectionFilter(VIESLine);
        if VIESLine.FindSet then
            repeat
                with VIESLine2 do begin
                    Reset;
                    "VIES Declaration No." := VIESHeader."No.";
                    "Line No." := LastLineNo + 10000;
                    LastLineNo += 10000;
                    "Trade Type" := VIESLine."Trade Type";
                    "Line Type" := VIESLine."Line Type"::Cancellation;
                    "Related Line No." := VIESLine."Line No.";
                    "Country/Region Code" := VIESLine."Country/Region Code";
                    "VAT Registration No." := VIESLine."VAT Registration No.";
                    "Cust/Vend Name" := VIESLine."Cust/Vend Name";
                    "Amount (LCY)" := VIESLine."Amount (LCY)";
                    "EU 3-Party Trade" := VIESLine."EU 3-Party Trade";
                    "EU Service" := VIESLine."EU Service";
                    "EU 3-Party Intermediate Role" := VIESLine."EU 3-Party Intermediate Role";
                    "Trade Role Type" := VIESLine."Trade Role Type";
                    "Number of Supplies" := VIESLine."Number of Supplies";
                    "System-Created" := true;
                    Insert;
                    "Line No." := LastLineNo + 10000;
                    LastLineNo += 10000;
                    "Line Type" := VIESLine."Line Type"::Correction;
                    "System-Created" := false;
                    Insert;
                end;
            until VIESLine.Next = 0;
    end;
}

