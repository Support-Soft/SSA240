page 71504 "SSA VIES Lines"
{
    // SSA974 SSCAT 11.10.2019 40.Rapoarte legale-Declaratia 390

    Caption = 'VIES Lines';
    Editable = false;
    PageType = List;
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
                field("Country/Region Code"; Rec."Country/Region Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Country/Region Code field.';
                }
                field("VAT Registration No."; Rec."VAT Registration No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the VAT Registration No. field.';
                }
                field("EU Service"; Rec."EU Service")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the EU Service field.';
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
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage()
    begin
        Rec.SetRange("VIES Declaration No.", VIESHeader."Corrected Declaration No.");
        Rec.SetRange("Line Type", Rec."Line Type"::New);
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
                VIESLine2.Reset;
                VIESLine2."VIES Declaration No." := VIESHeader."No.";
                VIESLine2."Line No." := LastLineNo + 10000;
                LastLineNo += 10000;
                VIESLine2."Trade Type" := VIESLine."Trade Type";
                VIESLine2."Line Type" := VIESLine."Line Type"::Cancellation;
                VIESLine2."Related Line No." := VIESLine."Line No.";
                VIESLine2."Country/Region Code" := VIESLine."Country/Region Code";
                VIESLine2."VAT Registration No." := VIESLine."VAT Registration No.";
                VIESLine2."Cust/Vend Name" := VIESLine."Cust/Vend Name";
                VIESLine2."Amount (LCY)" := VIESLine."Amount (LCY)";
                VIESLine2."EU 3-Party Trade" := VIESLine."EU 3-Party Trade";
                VIESLine2."EU Service" := VIESLine."EU Service";
                VIESLine2."EU 3-Party Intermediate Role" := VIESLine."EU 3-Party Intermediate Role";
                VIESLine2."Trade Role Type" := VIESLine."Trade Role Type";
                VIESLine2."Number of Supplies" := VIESLine."Number of Supplies";
                VIESLine2."System-Created" := true;
                VIESLine2.Insert;
                VIESLine2."Line No." := LastLineNo + 10000;
                LastLineNo += 10000;
                VIESLine2."Line Type" := VIESLine."Line Type"::Correction;
                VIESLine2."System-Created" := false;
                VIESLine2.Insert;
            until VIESLine.Next = 0;
    end;
}
