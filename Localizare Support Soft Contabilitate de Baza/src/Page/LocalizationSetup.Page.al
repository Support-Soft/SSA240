page 70006 "SSA Localization Setup"
{
    // SSA937 SSCAT 16.06.2019 3.Funct. Bonuri de consum-consum intern
    // SSA951 SSCAT 05.07.2019 17.Funct. Inreg. in rosu la cantitati negative
    // SSA957 SSCAT 23.08.2019 23.Funct. Obiecte de inventar: lista si fisa obiecte de inventar, punere in functiune, full description
    // SSA958 SSCAT 23.08.2019 24.Funct. verificare sa nu posteze sell to diferit de bill to
    // SSA973 SSCAT 06.09.2019 39.Rapoarte legale- Localizare Declaratia 394
    // SSA946 SSCAT 26.09.2019 12.Funct. functionalitate DVI la achizitii
    // SSA947 SSCAT 10.01.2019 13.Funct. “TVA la incasare”
    // SSA970 SSCAT 07.10.2019 36.Funct. UOM Mandatory, dimensiuni pe rounding, intercompany, denumire, conturi bancare
    // SSA1196 SSCAT 04.11.2019 Leasing

    Caption = 'Localization Setup';
    PageType = Card;
    SourceTable = "SSA Localization Setup";
    UsageCategory = Administration;
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';
            }
            group("Sales & Receivables Setup")
            {
                Caption = 'Sales & Receivables Setup';
                field("Sales Negative Line Correction"; Rec."Sales Negative Line Correction")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Sales Negative Line Correction field.';
                }
                field("Allow Diff. Sell-to Bill-to"; Rec."Allow Diff. Sell-to Bill-to")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Allow Diff. Sell-to Bill-to field.';
                }
            }
            group("Purchase Setup")
            {
                Caption = 'Purchase Setup';
                field("Purch Negative Line Correction"; Rec."Purch Negative Line Correction")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Purch Negative Line Correction field.';
                }
                field("Allow Diff. Buy-from Pay-to"; Rec."Allow Diff. Buy-from Pay-to")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Allow Diff. Buy-from Pay-to field.';
                }
                field("Custom Invoice No. Mandatory"; Rec."Custom Invoice No. Mandatory")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Custom Invoice No. Mandatory field.';
                }
            }
            group("Inventory Setup")
            {
                Caption = 'Inventory Setup';
                field("Internal Consumption Nos."; Rec."Internal Consumption Nos.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Internal Consumption Nos. field.';
                }
                field("Posted Int. Consumption Nos."; Rec."Posted Int. Consumption Nos.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Posted Int. Consumption Nos. field.';
                }
                field("Outbound Whse. Handling Time"; Rec."Outbound Whse. Handling Time")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Outbound Whse. Handling Time field.';
                }
                field("Transfer Gen. Bus. Pstg. Group"; Rec."Transfer Gen. Bus. Pstg. Group")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Transfer Gen. Bus. Pstg. Group field.';
                }
                field("Assembly Gen. Bus. Pstg. Group"; Rec."Assembly Gen. Bus. Pstg. Group")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Assembly Gen. Bus. Pstg. Group field.';
                }
                field("Unit of Measure Mandatory"; Rec."Unit of Measure Mandatory")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Unit of Measure Mandatory field.';
                }
                field("Rounding Dimension Set ID"; Rec."Rounding Dimension Set ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Rounding Dimension Set ID field.';
                }
            }
            group(Intrastat)
            {
                Caption = 'Intrastat';
                field("Transaction Type Mandatory"; Rec."Transaction Type Mandatory")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Transaction Type Mandatory field.';
                }
                field("Transaction Spec. Mandatory"; Rec."Transaction Spec. Mandatory")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Transaction Spec. Mandatory field.';
                }
                field("Transport Method Mandatory"; Rec."Transport Method Mandatory")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Transport Method Mandatory field.';
                }
                field("Shipment Method Mandatory"; Rec."Shipment Method Mandatory")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Shipment Method Mandatory field.';
                }
            }
            group("Fixed Asset")
            {
                Caption = 'Fixed Asset';
                field("Fixed Asset Nos."; Rec."Fixed Asset Nos.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Fixed Asset Nos. field.';
                }
                field("Fixed Asset Inventory Nos."; Rec."Fixed Asset Inventory Nos.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Fixed Asset Inventory Nos. field.';
                }
            }
            group(D394)
            {
                Caption = '394';
                field("Sistem TVA"; Rec."Sistem TVA")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the VAT System field.';
                }
                field("Skip Errors before date"; Rec."Skip Errors before date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Skip Errors before date field.';
                }
                field("CAEN Code"; Rec."CAEN Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the CAEN Code field.';
                }
            }
            group("General Ledger Setup")
            {
                Caption = 'General Ledger Setup';
                field("Vendor Neex. VAT Posting Group"; Rec."Vendor Neex. VAT Posting Group")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Vendor Neex. VAT Posting Group field.';
                }
                field("Vendor Ex. VAT Posting Group"; Rec."Vendor Ex. VAT Posting Group")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Vendor Ex. VAT Posting Group field.';
                }
                field("Cust. Neex. VAT Posting Group"; Rec."Cust. Neex. VAT Posting Group")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Cust. Neex. VAT Posting Group field.';
                }
                field("Cust. Ex. VAT Posting Group"; Rec."Cust. Ex. VAT Posting Group")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Cust. Ex. VAT Posting Group field.';
                }
                field("Leasing Journal Template"; Rec."Leasing Journal Template")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Leasing Journal Template 2 field.';
                }
                field("Advance Journal Template"; Rec."Advance Journal Template")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Advance Journal Template field.';
                }
                field("Vendor Nepl. VAT Posting Group"; Rec."Vendor Nepl. VAT Posting Group")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Vendor Nepl. VAT Posting Group field.';
                }
                field("Cust. Nepl. VAT Posting Group"; Rec."Cust. Nepl. VAT Posting Group")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Cust. Nepl. VAT Posting Group field.';
                }
            }
        }
    }

}
