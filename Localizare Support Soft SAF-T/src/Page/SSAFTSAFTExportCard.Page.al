#pragma implicitwith disable
page 71904 "SSAFTSAFT Export Card"
{
    // SSM2101 SSCAT 04.01.2023 SAF-T

    Caption = 'SAF-T Export';
    PageType = Card;
    SourceTable = "SSAFTSAFT Export Header";

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("Mapping Range Code"; Rec."Mapping Range Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the mapping range code that represents the SAF-T reporting period.';
                }
                field("Starting Date"; Rec."Starting Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the starting date of the SAF-T reporting period.';
                }
                field("Ending Date"; Rec."Ending Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the ending date of the SAF-T reporting period.';
                }
                field("Parallel Processing"; Rec."Parallel Processing")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies if the change will be processed by parallel background jobs.';
                }
                field("Max No. Of Jobs"; Rec."Max No. Of Jobs")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the maximum number of background jobs that can be processed at the same time.';
                }
                field("Header Comment SAFT Type"; Rec."Header Comment SAFT Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the comment that is exported to the HeaderComment XML node of the SAF-T file';
                }
                field("Earliest Start Date/Time"; Rec."Earliest Start Date/Time")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the earliest date and time when the background job must be run.';
                }
                field("Folder Path"; Rec."Folder Path")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the complete path of the public folder that the SAF-T file is exported to.';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the overall status of one or more SAF-T files being generated.';
                }
                field("Execution Start Date/Time"; Rec."Execution Start Date/Time")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the date and time when the SAF-T file generation was started.';
                }
                field("Execution End Date/Time"; Rec."Execution End Date/Time")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the date and time when the SAF-T file generation was completed.';
                }
                field("Tax Accounting Basis"; Rec."Tax Accounting Basis")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the tax accounting basis that is exported to the TaxAccountingBasis XML node of the SAF-T file';
                }
            }
            part(ExportLines; "SSAFTSAFT Export Subpage")
            {
                Caption = 'Export Lines';
                ApplicationArea = All;
                SubPageLink = ID = field(ID);
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(Start)
            {
                ApplicationArea = All;
                Caption = 'Start';
                Image = Start;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Start the generation of the SAF-T file.';

                trigger OnAction()
                begin
                    CODEUNIT.Run(CODEUNIT::"SSAFTSAFT Export Mgt.", Rec);
                    CurrPage.Update;
                end;
            }
            action(DownloadFile)
            {
                ApplicationArea = All;
                Caption = 'Download File';
                Image = ExportFile;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Download the generated SAF-T file.';

                trigger OnAction()
                var
                    SAFTExportMgt: Codeunit "SSAFTSAFT Export Mgt.";
                begin
                    SAFTExportMgt.DownloadZipFileFromExportHeader(Rec);
                end;
            }
            action(ExportSingleFile)
            {
                Caption = 'Export Single File';
                ApplicationArea = All;
                ToolTip = 'Export a single SAF-T file.';

                trigger OnAction()
                var
                    SSASAFTExportMgt: Codeunit "SSAFTSAFT Export Mgt.";
                begin
                    //SSM1724>>
                    SSASAFTExportMgt.StartExportSingleFile(Rec);
                    CurrPage.Update;
                    //SSM1724<<
                end;
            }
        }
    }
}

#pragma implicitwith restore

