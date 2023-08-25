page 70013 "SSA Fixed Asset Inventory List"
{
    // SSA957 SSCAT 23.08.2019 23.Funct. Obiecte de inventar: lista si fisa obiecte de inventar, punere in functiune, full description

    AdditionalSearchTerms = 'fa list';
    ApplicationArea = All;
    Caption = 'Fixed Assets Inventory';
    CardPageID = "SSA Fixed Asset Inventory Card";
    Editable = false;
    PageType = List;
    SourceTable = "Fixed Asset";
    SourceTableView = sorting("No.")
                      where("SSA Type" = const(Inventory));
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field("No."; "No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the number of the involved entry or record, according to the specified number series.';
                }
                field(Description; Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies a description of the fixed asset.';
                }
                field("Vendor No."; "Vendor No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the number of the vendor from which you purchased this fixed asset.';
                    Visible = false;
                }
                field("Maintenance Vendor No."; "Maintenance Vendor No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the number of the vendor who performs repairs and maintenance on the fixed asset.';
                    Visible = false;
                }
                field("Responsible Employee"; "Responsible Employee")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies which employee is responsible for the fixed asset.';
                }
                field("FA Class Code"; "FA Class Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the class that the fixed asset belongs to.';
                }
                field("FA Subclass Code"; "FA Subclass Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the subclass of the class that the fixed asset belongs to.';
                }
                field("FA Location Code"; "FA Location Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the location, such as a building, where the fixed asset is located.';
                }
                field("Budgeted Asset"; "Budgeted Asset")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies if the asset is for budgeting purposes.';
                    Visible = false;
                }
                field("Search Description"; "Search Description")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies a search description for the fixed asset.';
                }
                field(Acquired; Acquired)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies that the fixed asset has been acquired.';
                }
            }
        }
        area(factboxes)
        {
            systempart(Control1900383207; Links)
            {
                ApplicationArea = All;
                Visible = false;
            }
            systempart(Control1905767507; Notes)
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("Fixed &Asset")
            {
                Caption = 'Fixed &Asset';
                Image = FixedAssets;
                action("Depreciation &Books")
                {
                    ApplicationArea = All;
                    Caption = 'Depreciation &Books';
                    Image = DepreciationBooks;
                    RunObject = Page "FA Depreciation Books";
                    RunPageLink = "FA No." = field("No.");
                    ToolTip = 'View or edit the depreciation book or books that must be used for each of the fixed assets. Here you also specify the way depreciation must be calculated.';
                }
                action(Statistics)
                {
                    ApplicationArea = All;
                    Caption = 'Statistics';
                    Image = Statistics;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Fixed Asset Statistics";
                    RunPageLink = "FA No." = field("No.");
                    ShortCutKey = 'F7';
                    ToolTip = 'View detailed historical information about the fixed asset.';
                }
                group(Dimensions)
                {
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    action("Dimensions-Single")
                    {
                        ApplicationArea = All;
                        Caption = 'Dimensions-Single';
                        Image = Dimensions;
                        Promoted = true;
                        PromotedCategory = Process;
                        RunObject = Page "Default Dimensions";
                        RunPageLink = "Table ID" = const(5600),
                                      "No." = field("No.");
                        ShortCutKey = 'Shift+Ctrl+D';
                        ToolTip = 'View or edit the single set of dimensions that are set up for the selected record.';
                    }
                    action("Dimensions-&Multiple")
                    {
                        AccessByPermission = TableData Dimension = R;
                        ApplicationArea = All;
                        Caption = 'Dimensions-&Multiple';
                        Image = DimensionSets;
                        Promoted = true;
                        PromotedCategory = Process;
                        ToolTip = 'View or edit dimensions for a group of records. You can assign dimension codes to transactions to distribute costs and analyze historical information.';

                        trigger OnAction()
                        var
                            FA: Record "Fixed Asset";
                            DefaultDimMultiple: Page "Default Dimensions-Multiple";
                        begin
                            CurrPage.SetSelectionFilter(FA);
                            DefaultDimMultiple.SetMultiRecord(FA, FieldNo("No."));
                            DefaultDimMultiple.RunModal;
                        end;
                    }
                }
                action("Main&tenance Ledger Entries")
                {
                    ApplicationArea = All;
                    Caption = 'Main&tenance Ledger Entries';
                    Image = MaintenanceLedgerEntries;
                    RunObject = Page "Maintenance Ledger Entries";
                    RunPageLink = "FA No." = field("No.");
                    RunPageView = sorting("FA No.");
                    ToolTip = 'View all the maintenance ledger entries for a fixed asset. ';
                }
                action(Picture)
                {
                    ApplicationArea = All;
                    Caption = 'Picture';
                    Image = Picture;
                    RunObject = Page "Fixed Asset Picture";
                    RunPageLink = "No." = field("No.");
                    ToolTip = 'Add or view a picture of the fixed asset.';
                }
                action("FA Posting Types Overview")
                {
                    ApplicationArea = All;
                    Caption = 'FA Posting Types Overview';
                    Image = ShowMatrix;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "FA Posting Types Overview";
                    ToolTip = 'View accumulated amounts for each field, such as book value, acquisition cost, and depreciation, and for each fixed asset. For every fixed asset, a separate line is shown for each depreciation book linked to the asset.';
                }
                action("Co&mments")
                {
                    ApplicationArea = All;
                    Caption = 'Co&mments';
                    Image = ViewComments;
                    RunObject = Page "Comment Sheet";
                    RunPageLink = "Table Name" = const("Fixed Asset"),
                                  "No." = field("No.");
                    ToolTip = 'View or add comments for the record.';
                }
            }
            group("Main Asset")
            {
                Caption = 'Main Asset';
                Image = Components;
                action("M&ain Asset Components")
                {
                    ApplicationArea = All;
                    Caption = 'M&ain Asset Components';
                    Image = Components;
                    RunObject = Page "Main Asset Components";
                    RunPageLink = "Main Asset No." = field("No.");
                    ToolTip = 'View or edit fixed asset components of the main fixed asset that is represented by the fixed asset card.';
                }
                action("Ma&in Asset Statistics")
                {
                    ApplicationArea = All;
                    Caption = 'Ma&in Asset Statistics';
                    Image = StatisticsDocument;
                    RunObject = Page "Main Asset Statistics";
                    RunPageLink = "FA No." = field("No.");
                    ToolTip = 'View detailed historical information about all the components that make up the main asset.';
                }
                separator(Separator45)
                {
                    Caption = '';
                }
            }
            group(History)
            {
                Caption = 'History';
                Image = History;
                action("Ledger E&ntries")
                {
                    ApplicationArea = All;
                    Caption = 'Ledger E&ntries';
                    Image = FixedAssetLedger;
                    RunObject = Page "FA Ledger Entries";
                    RunPageLink = "FA No." = field("No.");
                    RunPageView = sorting("FA No.")
                                  order(descending);
                    ShortCutKey = 'Ctrl+F7';
                    ToolTip = 'View the history of transactions that have been posted for the selected record.';
                }
                action("Error Ledger Entries")
                {
                    ApplicationArea = All;
                    Caption = 'Error Ledger Entries';
                    Image = ErrorFALedgerEntries;
                    RunObject = Page "FA Error Ledger Entries";
                    RunPageLink = "Canceled from FA No." = field("No.");
                    RunPageView = sorting("Canceled from FA No.")
                                  order(descending);
                    ToolTip = 'View the entries that have been posted as a result of you using the Cancel function to cancel an entry.';
                }
                action("Maintenance &Registration")
                {
                    ApplicationArea = All;
                    Caption = 'Maintenance &Registration';
                    Image = MaintenanceRegistrations;
                    RunObject = Page "Maintenance Registration";
                    RunPageLink = "FA No." = field("No.");
                    ToolTip = 'View or edit maintenance codes for the various types of maintenance, repairs, and services performed on your fixed assets. You can then enter the code in the Maintenance Code field on journals.';
                }
            }
        }
        area(processing)
        {
            action("Fixed Asset Journal")
            {
                ApplicationArea = All;
                Caption = 'Fixed Asset Journal';
                Image = Journal;
                RunObject = Page "Fixed Asset Journal";
                ToolTip = 'Post fixed asset transactions with a depreciation book that is not integrated with the general ledger, for internal management. Only fixed asset ledger entries are created. ';
            }
            action("Fixed Asset G/L Journal")
            {
                ApplicationArea = All;
                Caption = 'Fixed Asset G/L Journal';
                Image = Journal;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = Page "Fixed Asset G/L Journal";
                ToolTip = 'Post fixed asset transactions with a depreciation book that is integrated with the general ledger, for financial reporting. Both fixed asset ledger entries are general ledger entries are created. ';
            }
            action("Fixed Asset Reclassification Journal")
            {
                ApplicationArea = All;
                Caption = 'Fixed Asset Reclassification Journal';
                Image = Journal;
                RunObject = Page "FA Reclass. Journal";
                ToolTip = 'Transfer, split, or combine fixed assets.';
            }
            action("Recurring Fixed Asset Journal")
            {
                ApplicationArea = All;
                Caption = 'Recurring Fixed Asset Journal';
                Image = Journal;
                RunObject = Page "Recurring Fixed Asset Journal";
                ToolTip = 'Post recurring entries to a depreciation book without integration with general ledger.';
            }
            action(CalculateDepreciation)
            {
                ApplicationArea = All;
                Caption = 'Calculate Depreciation';
                Ellipsis = true;
                Image = CalculateDepreciation;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Calculate depreciation according to conditions that you specify. If the related depreciation book is set up to integrate with the general ledger, then the calculated entries are transferred to the fixed asset general ledger journal. Otherwise, the calculated entries are transferred to the fixed asset journal. You can then review the entries and post the journal.';

                trigger OnAction()
                begin
                    REPORT.RunModal(REPORT::"Calculate Depreciation", true, false, Rec);
                end;
            }
            action("C&opy Fixed Asset")
            {
                ApplicationArea = All;
                Caption = 'C&opy Fixed Asset';
                Ellipsis = true;
                Image = CopyFixedAssets;
                ToolTip = 'Create one or more new fixed assets by copying from an existing fixed asset that has similar information.';

                trigger OnAction()
                var
                    CopyFA: Report "Copy Fixed Asset";
                begin
                    CopyFA.SetFANo("No.");
                    CopyFA.RunModal;
                end;
            }
        }
        area(reporting)
        {
            action("Fixed Assets List")
            {
                ApplicationArea = All;
                Caption = 'Fixed Assets List';
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                RunObject = Report "Fixed Asset - List";
                ToolTip = 'View the list of fixed assets that exist in the system .';
            }
            action("Acquisition List")
            {
                ApplicationArea = All;
                Caption = 'Acquisition List';
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                RunObject = Report "Fixed Asset - Acquisition List";
                ToolTip = 'View the related acquisitions.';
            }
            action(Details)
            {
                ApplicationArea = All;
                Caption = 'Details';
                Image = View;
                Promoted = true;
                PromotedCategory = "Report";
                RunObject = Report "Fixed Asset - Details";
                ToolTip = 'View detailed information about the fixed asset ledger entries that have been posted to a specified depreciation book for each fixed asset.';
            }
            action("FA Book Value")
            {
                ApplicationArea = All;
                Caption = 'FA Book Value';
                Image = "Report";
                RunObject = Report "Fixed Asset - Book Value 01";
                ToolTip = 'View detailed information about acquisition cost, depreciation and book value for both individual assets and groups of assets. For each of these three amount types, amounts are calculated at the beginning and at the end of a specified period as well as for the period itself.';
            }
            action("FA Book Val. - Appr. & Write-D")
            {
                ApplicationArea = All;
                Caption = 'FA Book Val. - Appr. & Write-D';
                Image = "Report";
                RunObject = Report "Fixed Asset - Book Value 02";
                ToolTip = 'View detailed information about acquisition cost, depreciation, appreciation, write-down and book value for both individual assets and groups of assets. For each of these categories, amounts are calculated at the beginning and at the end of a specified period, as well as for the period itself.';
            }
            action(Analysis)
            {
                ApplicationArea = All;
                Caption = 'Analysis';
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                RunObject = Report "Fixed Asset - Analysis";
                ToolTip = 'View an analysis of your fixed assets with various types of data for both individual assets and groups of fixed assets.';
            }
            action("Projected Value")
            {
                ApplicationArea = All;
                Caption = 'Projected Value';
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                RunObject = Report "Fixed Asset - Projected Value";
                ToolTip = 'View the calculated future depreciation and book value. You can print the report for one depreciation book at a time.';
            }
            action("G/L Analysis")
            {
                ApplicationArea = All;
                Caption = 'G/L Analysis';
                Image = "Report";
                RunObject = Report "Fixed Asset - G/L Analysis";
                ToolTip = 'View an analysis of your fixed assets with various types of data for individual assets and/or groups of fixed assets.';
            }
            action(Register)
            {
                ApplicationArea = All;
                Caption = 'Register';
                Image = Confirm;
                RunObject = Report "Fixed Asset Register";
                ToolTip = 'View registers containing all the fixed asset entries that are created. Each register shows the first and last entry number of its entries.';
            }
        }
    }

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        "SSA Type" := "SSA Type"::Inventory;
    end;

    procedure GetSelectionFilter(): Text
    var
        FixedAsset: Record "Fixed Asset";
        SelectionFilterManagement: Codeunit SelectionFilterManagement;
    begin
        CurrPage.SetSelectionFilter(FixedAsset);
        exit(SelectionFilterManagement.GetSelectionFilterForFixedAsset(FixedAsset));
    end;
}

