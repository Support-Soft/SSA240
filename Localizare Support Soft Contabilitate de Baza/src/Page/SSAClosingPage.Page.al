page 70015 "SSA Closing Page"
{
    Caption = 'Closing Page';
    PageType = Card;
    PromotedActionCategories = 'Payroll,Currency valuation,Depreciation,Correction Procedures,Production Expenses,Monthly closing,Statements,Checking';
    SourceTable = "Company Information";
    ApplicationArea = All;
    UsageCategory = Administration;

    layout
    {
        area(Content)
        {
            field(Picture; Rec.Picture)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the picture that has been set up for the company, such as a company logo.';
            }
        }
    }

    actions
    {
        area(Navigation)
        {
            action("<Action1000000025>")
            {
                Caption = 'Recurring Journals';
                Promoted = true;
                PromotedIsBig = true;
                RunObject = page "Recurring General Journal";
                ApplicationArea = All;
                ToolTip = 'Executes the Recurring Journals action.';
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
                RunObject = page Currencies;
                ApplicationArea = All;
                ToolTip = 'Executes the Currencies action.';
            }
            action("Adjust Exchange Rates")
            {
                Caption = 'Adjust Exchange Rates';
                Image = AdjustExchangeRates;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = report "SSA Adjust Exchange Rates";
                ApplicationArea = All;
                ToolTip = 'Executes the Adjust Exchange Rates action.';
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
                RunObject = report "Calculate Depreciation";
                RunPageMode = Create;
                ApplicationArea = All;
                ToolTip = 'Executes the Calculate Depreciation... action.';
            }
            action("<Action1000000026>")
            {
                Caption = 'FA G/L Journals';
                Image = Journal;
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;
                RunObject = page "Fixed Asset G/L Journal";
                ApplicationArea = All;
                ToolTip = 'Executes the FA G/L Journals action.';
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
                RunObject = page "General Journal";
                ApplicationArea = All;
                ToolTip = 'Executes the General Journals action.';
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
                RunObject = page "Analysis by Dimensions";
                ApplicationArea = All;
                ToolTip = 'Executes the Analysis by Dimensions action.';
            }
            action("<Action1000000016>")
            {
                Caption = 'Account Schedules';
                Image = AnalysisView;
                Promoted = true;
                PromotedCategory = Category5;
                PromotedIsBig = true;
                RunObject = page "Account Schedule";
                ApplicationArea = All;
                ToolTip = 'Executes the Account Schedules action.';
            }
            action("<Action1000000017>")
            {
                Caption = 'General Journals';
                Image = Journal;
                Promoted = true;
                PromotedCategory = Category5;
                PromotedIsBig = true;
                RunObject = page "General Journal";
                ApplicationArea = All;
                ToolTip = 'Executes the General Journals action.';
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
                RunObject = report "SSA Close Income Statement";
                ApplicationArea = All;
                ToolTip = 'Executes the Close Income Statement... action.';
            }
            action("<Action1000000020>")
            {
                Caption = 'General Journals';
                Image = Journal;
                Promoted = true;
                PromotedCategory = Category6;
                PromotedIsBig = true;
                RunObject = page "General Journal";
                ApplicationArea = All;
                ToolTip = 'Executes the General Journals action.';
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
                ToolTip = 'Executes the Calculate and Post VAT Settlement action.';
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
                RunObject = page "VAT Statement";
                ApplicationArea = All;
                ToolTip = 'Executes the VAT Statement action.';
            }
        }
        area(Reporting)
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
                RunObject = report "Inventory Valuation";
                ApplicationArea = All;
                ToolTip = 'Executes the Inventory Valuation action.';
            }
        }
    }
}
