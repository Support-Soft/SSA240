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
        area(content)
        {
            group(General)
            {
            }
            group("Sales & Receivables Setup")
            {
                field("Sales Negative Line Correction"; "Sales Negative Line Correction")
                {
                    ApplicationArea = All;
                }
                field("Allow Diff. Sell-to Bill-to"; "Allow Diff. Sell-to Bill-to")
                {
                    ApplicationArea = All;
                }
            }
            group("Purchase Setup")
            {
                field("Purch Negative Line Correction"; "Purch Negative Line Correction")
                {
                    ApplicationArea = All;
                }
                field("Allow Diff. Buy-from Pay-to"; "Allow Diff. Buy-from Pay-to")
                {
                    ApplicationArea = All;
                }
                field("Custom Invoice No. Mandatory"; "Custom Invoice No. Mandatory")
                {
                    ApplicationArea = All;
                }
            }
            group("Inventory Setup")
            {
                field("Internal Consumption Nos."; "Internal Consumption Nos.")
                {
                    ApplicationArea = All;
                }
                field("Posted Int. Consumption Nos."; "Posted Int. Consumption Nos.")
                {
                    ApplicationArea = All;
                }
                field("Outbound Whse. Handling Time"; "Outbound Whse. Handling Time")
                {
                    ApplicationArea = All;
                }
                field("Transfer Gen. Bus. Pstg. Group"; "Transfer Gen. Bus. Pstg. Group")
                {
                    ApplicationArea = All;
                }
                field("Assembly Gen. Bus. Pstg. Group"; "Assembly Gen. Bus. Pstg. Group")
                {
                    ApplicationArea = All;
                }
                field("Unit of Measure Mandatory"; "Unit of Measure Mandatory")
                {
                    ApplicationArea = All;
                }
                field("Rounding Dimension Set ID"; "Rounding Dimension Set ID")
                {
                    ApplicationArea = All;
                }
            }
            group(Intrastat)
            {
                Caption = 'Intrastat';
                field("Transaction Type Mandatory"; "Transaction Type Mandatory")
                {
                    ApplicationArea = All;
                }
                field("Transaction Spec. Mandatory"; "Transaction Spec. Mandatory")
                {
                    ApplicationArea = All;
                }
                field("Transport Method Mandatory"; "Transport Method Mandatory")
                {
                    ApplicationArea = All;
                }
                field("Shipment Method Mandatory"; "Shipment Method Mandatory")
                {
                    ApplicationArea = All;
                }
            }
            group("Fixed Asset")
            {
                Caption = 'Fixed Asset';
                field("Fixed Asset Nos."; "Fixed Asset Nos.")
                {
                    ApplicationArea = All;
                }
                field("Fixed Asset Inventory Nos."; "Fixed Asset Inventory Nos.")
                {
                    ApplicationArea = All;
                }
            }
            group(D394)
            {
                Caption = '394';
                field("Sistem TVA"; "Sistem TVA")
                {
                    ApplicationArea = All;
                }
                field("Skip Errors before date"; "Skip Errors before date")
                {
                    ApplicationArea = All;
                }
                field("CAEN Code"; "CAEN Code")
                {
                    ApplicationArea = All;
                }
            }
            group("General Ledger Setup")
            {
                Caption = 'General Ledger Setup';
                field("Vendor Neex. VAT Posting Group"; "Vendor Neex. VAT Posting Group")
                {
                    ApplicationArea = All;
                }
                field("Vendor Ex. VAT Posting Group"; "Vendor Ex. VAT Posting Group")
                {
                    ApplicationArea = All;
                }
                field("Cust. Neex. VAT Posting Group"; "Cust. Neex. VAT Posting Group")
                {
                    ApplicationArea = All;
                }
                field("Cust. Ex. VAT Posting Group"; "Cust. Ex. VAT Posting Group")
                {
                    ApplicationArea = All;
                }
                field("Leasing Journal Template"; "Leasing Journal Template")
                {
                    ApplicationArea = All;
                }
                field("Advance Journal Template"; "Advance Journal Template")
                {
                    ApplicationArea = All;
                }
                field("Vendor Nepl. VAT Posting Group"; "Vendor Nepl. VAT Posting Group")
                {
                    ApplicationArea = All;
                }
                field("Cust. Nepl. VAT Posting Group"; "Cust. Nepl. VAT Posting Group")
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

