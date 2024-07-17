#pragma implicitwith disable
page 71905 "SSAFT Export Subpage"
{
    // SSM2101 SSCAT 04.01.2023 SAF-T

    Caption = 'Lines';
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = ListPart;
    SourceTable = "SSAFT Export Line";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Line No."; Rec."Line No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the line number of the selected SAF-T file.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the description of the selected SAF-T file.';
                }
                field(Progress; Rec.Progress)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the progress of the selected SAF-T file.';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the status of the selected SAF-T file.';
                }
                field("Created Date/Time"; Rec."Created Date/Time")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the date and time when the generation of the selected SAF-T file was completed.';
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(RestartTask)
            {
                ApplicationArea = All;
                Caption = 'Restart';
                Image = PostingEntries;
                ToolTip = 'Restart the generation of the selected SAF-T file.';

                trigger OnAction()
                var
                    SAFTExportLine: Record "SSAFT Export Line";
                    SAFTExportMgt: Codeunit "SSAFT Export Mgt.";
                begin
                    CurrPage.SetSelectionFilter(SAFTExportLine);
                    SAFTExportMgt.RestartTaskOnExportLine(SAFTExportLine);
                    CurrPage.Update;
                end;
            }
            action(ShowError)
            {
                ApplicationArea = All;
                Caption = 'Show Error';
                Image = Error;

                ToolTip = 'Show the error that occurred when generating the selected SAF-T file.';

                trigger OnAction()
                var
                    SAFTExportMgt: Codeunit "SSAFT Export Mgt.";
                begin
                    SAFTExportMgt.ShowErrorOnExportLine(Rec);
                    CurrPage.Update;
                end;
            }
            action(LogEntries)
            {
                ApplicationArea = All;
                Caption = 'Activity Log';
                Image = Log;

                ToolTip = 'Show the activity log for the generation of the selected SAF-T file.';

                trigger OnAction()
                var
                    SAFTExportMgt: Codeunit "SSAFT Export Mgt.";
                begin
                    SAFTExportMgt.ShowActivityLog(Rec);
                    CurrPage.Update;
                end;
            }
        }
    }
}

#pragma implicitwith restore

