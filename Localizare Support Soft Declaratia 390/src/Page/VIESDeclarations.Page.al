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
                field("No."; "No.")
                {
                    ApplicationArea = All;
                }
                field("Document Date"; "Document Date")
                {
                    ApplicationArea = All;
                }
                field("Declaration Type"; "Declaration Type")
                {
                    ApplicationArea = All;
                }
                field("Corrected Declaration No."; "Corrected Declaration No.")
                {
                    ApplicationArea = All;
                }
                field("Declaration Period"; "Declaration Period")
                {
                    ApplicationArea = All;
                }
                field("Period No."; "Period No.")
                {
                    ApplicationArea = All;
                }
                field(Year; Year)
                {
                    ApplicationArea = All;
                }
                field(Status; Status)
                {
                    ApplicationArea = All;
                }
                field("VAT Registration No."; "VAT Registration No.")
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

