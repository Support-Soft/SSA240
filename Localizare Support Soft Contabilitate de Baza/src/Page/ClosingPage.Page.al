page 70015 "SSA Closing Page"
{
    Caption = 'Closing Page';
    PageType = NavigatePage;
    PromotedActionCategories = 'Payroll,Currency valuation,Depreciation,Correction Procedures,Production Expenses,Monthly closing,Statements,Checking';
    SourceTable = "Company Information";
    ApplicationArea = All;
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            field(Picture; Picture)
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        area(navigation)
        {
            action("<Action1000000025>")
            {
                Caption = 'Recurring Journals';
                Promoted = true;
                PromotedIsBig = true;
                RunObject = Page "Recurring General Journal";
                ApplicationArea = All;
            }
            separator("2. Rulare reevaluare")
            {
                IsHeader = true;
            }
            action("<Action1000000011>")
            {
                Caption = 'Currencies';
                Image = Currency;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = Page Currencies;
                ApplicationArea = All;
            }
            action("Adjust Exchange Rates")
            {
                Caption = 'Adjust Exchange Rates';
                Image = AdjustExchangeRates;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = Report "SSA Adjust Exchange Rates";
                ApplicationArea = All;
            }
            separator("3. Rulare amortizare")
            {
                IsHeader = true;
            }
            action("<Action1000000012>")
            {
                Caption = 'Calculate Depreciation...';
                Image = CalculateDepreciation;
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;
                RunObject = Report "Calculate Depreciation";
                RunPageMode = Create;
                ApplicationArea = All;
            }
            action("<Action1000000026>")
            {
                Caption = 'FA G/L Journals';
                Image = Journal;
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;
                RunObject = Page "Fixed Asset G/L Journal";
                ApplicationArea = All;
            }
            separator("4. Correction Procedures")
            {
                Caption = '4. Correction Procedures';
                IsHeader = true;
            }

            action("<Action1000000013>")
            {
                Caption = 'General Journals';
                Image = Journal;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;
                RunObject = Page "General Journal";
                ApplicationArea = All;
            }
            separator("5. Cheltuieli Productie")
            {
                IsHeader = true;
            }
            action("<Action1000000015>")
            {
                Caption = 'Analysis by Dimensions';
                Image = AnalysisViewDimension;
                Promoted = true;
                PromotedCategory = Category5;
                PromotedIsBig = true;
                RunObject = Page "Analysis by Dimensions";
                ApplicationArea = All;
            }
            action("<Action1000000016>")
            {
                Caption = 'Account Schedules';
                Image = AnalysisView;
                Promoted = true;
                PromotedCategory = Category5;
                PromotedIsBig = true;
                RunObject = Page "Account Schedule";
                ApplicationArea = All;
            }
            action("<Action1000000017>")
            {
                Caption = 'General Journals';
                Image = Journal;
                Promoted = true;
                PromotedCategory = Category5;
                PromotedIsBig = true;
                RunObject = Page "General Journal";
                ApplicationArea = All;
            }
            separator("6. Inchidere lunara")
            {
                IsHeader = true;
            }
            action("<Action1000000019>")
            {
                Caption = 'Close Income Statement...';
                Image = ClosePeriod;
                Promoted = true;
                PromotedCategory = Category6;
                PromotedIsBig = true;
                RunObject = Report "SSA Close Income Statement";
                ApplicationArea = All;
            }
            action("<Action1000000020>")
            {
                Caption = 'General Journals';
                Image = Journal;
                Promoted = true;
                PromotedCategory = Category6;
                PromotedIsBig = true;
                RunObject = Page "General Journal";
                ApplicationArea = All;
            }
            action(CloseVAT)
            {
                Caption = 'Calculate and Post VAT Settlement';
                Image = ClosePeriod;
                Promoted = true;
                PromotedCategory = Category6;
                PromotedIsBig = true;
                RunObject = report "Calc. and Post VAT Settlement";
                ApplicationArea = All;
            }

            separator("7. Declaratii catre stat")
            {
                IsHeader = true;
            }

            action("<Action1000000024>")
            {
                Caption = 'VAT Statement';
                Image = VATStatement;
                Promoted = true;
                PromotedCategory = Category7;
                PromotedIsBig = true;
                RunObject = Page "VAT Statement";
                ApplicationArea = All;
            }
        }
        area(reporting)
        {
            separator(Reports)
            {
            }
            action("<Action1000000002>")
            {
                Caption = 'Inventory Valuation';
                Image = Report2;
                Promoted = true;
                PromotedCategory = Category8;
                PromotedIsBig = true;
                RunObject = Report "Inventory Valuation";
                ApplicationArea = All;
            }

        }
    }
}

