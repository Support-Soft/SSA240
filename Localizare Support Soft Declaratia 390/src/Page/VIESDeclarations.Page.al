page 71502 "SSA VIES Declarations"
{
    // SSA974 SSCAT 11.10.2019 40.Rapoarte legale-Declaratia 390

    Caption = 'VIES Declarations';
    CardPageID = "SSA VIES Declaration";
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
                }
                field("Document Date"; Rec."Document Date")
                {
                    ApplicationArea = All;
                }
                field("Declaration Type"; Rec."Declaration Type")
                {
                    ApplicationArea = All;
                }
                field("Corrected Declaration No."; Rec."Corrected Declaration No.")
                {
                    ApplicationArea = All;
                }
                field("Declaration Period"; Rec."Declaration Period")
                {
                    ApplicationArea = All;
                }
                field("Period No."; Rec."Period No.")
                {
                    ApplicationArea = All;
                }
                field(Year; Rec.Year)
                {
                    ApplicationArea = All;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                }
                field("VAT Registration No."; Rec."VAT Registration No.")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
    }
}

