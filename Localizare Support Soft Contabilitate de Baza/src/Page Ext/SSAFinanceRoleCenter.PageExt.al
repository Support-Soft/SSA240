pageextension 70071 "SSA Finance Role Center" extends "Finance Manager Role Center"
{
    actions
    {
        addlast(Sections)
        {
            group("SSA LocalizationSS")
            {
                Caption = 'Localization Support-Soft';
                action("SSA Currencies")
                {
                    Caption = 'Currencies';
                    Image = Currency;
                    RunObject = page Currencies;
                    ApplicationArea = All;
                    ToolTip = 'Executes the Currencies action.';
                }
                action("SSA Adjust Exchange Rates")
                {
                    Caption = 'Adjust Exchange Rates';
                    Image = AdjustExchangeRates;
                    RunObject = report "SSA Adjust Exchange Rates";
                    ApplicationArea = All;
                    ToolTip = 'Executes the Adjust Exchange Rates action.';
                }
                group("SSA Payroll")
                {
                    Caption = 'Payroll';
                    action("SSA RecurringJournals")
                    {
                        Caption = 'Recurring Journals';
                        RunObject = page "Recurring General Journal";
                        ApplicationArea = All;
                        ToolTip = 'Executes the Recurring Journals action.';
                    }
                }
                group(Depreciation)
                {
                    Caption = 'Depreciation';
                    action("SSA CalculateDepreciation")
                    {
                        Caption = 'Calculate Depreciation...';
                        Image = CalculateDepreciation;
                        RunObject = report "Calculate Depreciation";
                        RunPageMode = Create;
                        ApplicationArea = All;
                        ToolTip = 'Executes the Calculate Depreciation... action.';
                    }
                    action("SSA FA G/L Journals")
                    {
                        Caption = 'FA G/L Journals';
                        Image = Journal;
                        RunObject = page "Fixed Asset G/L Journal";
                        ApplicationArea = All;
                        ToolTip = 'Executes the FA G/L Journals action.';
                    }
                }
                group(CorrectionProcedures)
                {
                    Caption = 'Correction Procedures';

                    action("<Action1000000013>")
                    {
                        Caption = 'General Journals';
                        Image = Journal;
                        RunObject = page "General Journal";
                        ApplicationArea = All;
                        ToolTip = 'Executes the General Journals action.';
                    }
                }
                group(ProductionExpenses)
                {
                    Caption = 'Production Expenses';
                    action("SSA AnalysisbyDimensions")
                    {
                        Caption = 'Analysis by Dimensions';
                        Image = AnalysisViewDimension;
                        RunObject = page "Analysis by Dimensions";
                        ApplicationArea = All;
                        ToolTip = 'Executes the Analysis by Dimensions action.';
                    }
                    action("<Action1000000016>")
                    {
                        Caption = 'Account Schedules';
                        Image = AnalysisView;
                        RunObject = page "Account Schedule";
                        ApplicationArea = All;
                        ToolTip = 'Executes the Account Schedules action.';
                    }
                    action("<Action1000000017>")
                    {
                        Caption = 'General Journals';
                        Image = Journal;
                        RunObject = page "General Journal";
                        ApplicationArea = All;
                        ToolTip = 'Executes the General Journals action.';
                    }
                }
                group("SSA MonthlyClosing")
                {
                    Caption = 'Monthly Closing';

                    action("<Action1000000019>")
                    {
                        Caption = 'Close Income Statement...';
                        Image = ClosePeriod;
                        RunObject = report "SSA Close Income Statement";
                        ApplicationArea = All;
                        ToolTip = 'Executes the Close Income Statement... action.';
                    }
                    action("SSA GeneralJournals")
                    {
                        Caption = 'General Journals';
                        Image = Journal;
                        RunObject = page "General Journal";
                        ApplicationArea = All;
                        ToolTip = 'Executes the General Journals action.';
                    }
                    action("SSA CloseVAT")
                    {
                        Caption = 'Calculate and Post VAT Settlement';
                        Image = ClosePeriod;
                        RunObject = report "Calc. and Post VAT Settlement";
                        ApplicationArea = All;
                        ToolTip = 'Executes the Calculate and Post VAT Settlement action.';
                    }
                    group("SSA Statements")
                    {
                        Caption = 'Statements';
                        action("SSA VATStatement")
                        {
                            Caption = 'VAT Statement';
                            Image = VATStatement;
                            RunObject = page "VAT Statement";
                            ApplicationArea = All;
                            ToolTip = 'Executes the VAT Statement action.';
                        }
                    }
                }
                group("SSA Checking")
                {
                    Caption = 'Checking';
                    action("SSA InventoryValuation")
                    {
                        Caption = 'Inventory Valuation';
                        Image = Report2;
                        RunObject = report "Inventory Valuation";
                        ApplicationArea = All;
                        ToolTip = 'Executes the Inventory Valuation action.';
                    }
                }
            }
        }
    }
}
