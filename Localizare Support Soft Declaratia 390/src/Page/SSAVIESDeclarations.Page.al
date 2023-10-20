page 71502 "SSA VIES Declarations"
{
    // SSA974 SSCAT 11.10.2019 40.Rapoarte legale-Declaratia 390

    Caption = 'VIES Declarations';
    CardPageId = "SSA VIES Declaration";
    Editable = false;
    PageType = List;
    SourceTable = "SSA VIES Header";
    UsageCategory = Tasks;
    ApplicationArea = All;
    layout
    {
        area(content)
        {
            repeater(Control1470000)
            {
                ShowCaption = false;
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the No. field.';
                }
                field("Document Date"; Rec."Document Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Document Date field.';
                }
                field("Declaration Type"; Rec."Declaration Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Declaration Type field.';
                }
                field("Corrected Declaration No."; Rec."Corrected Declaration No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Corrected Declaration No. field.';
                }
                field("Declaration Period"; Rec."Declaration Period")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Declaration Period field.';
                }
                field("Period No."; Rec."Period No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Period No. field.';
                }
                field(Year; Rec.Year)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Year field.';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Status field.';
                }
                field("VAT Registration No."; Rec."VAT Registration No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the VAT Registration No. field.';
                }
            }
        }
    }

    actions
    {
    }
}
