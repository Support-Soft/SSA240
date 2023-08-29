#pragma implicitwith disable
page 71900 "SSAFTSAFT Mapping Range"
{
    // SSM2101 SSCAT 04.01.2023 SAF-T
    Caption = 'SAFT Mapping Range';
    PageType = List;
    SourceTable = "SSAFTSAFT Mapping Range";
    ApplicationArea = All;
    UsageCategory = Tasks;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Code"; Rec.Code)
                {
                    ApplicationArea = All;
                    ToolTip = 'Code of the mapping range.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Description of the mapping range.';
                }
                field("Starting Date"; Rec."Starting Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Starting date of the mapping range.';
                }
                field("Ending Date"; Rec."Ending Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Ending date of the mapping range.';
                }
                field("Range Type"; Rec."Range Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Type of the mapping range.';
                }
                field("Accounting Period"; Rec."Accounting Period")
                {
                    ApplicationArea = All;
                    ToolTip = 'Accounting period of the mapping range.';
                }
                field("Chart of Account NFT"; Rec."Chart of Account NFT")
                {
                    ApplicationArea = All;
                    ToolTip = 'Chart of account NFT of the mapping range.';
                }
                field("Source Code Inchidere TVA"; Rec."Source Code Inchidere TVA")
                {
                    ApplicationArea = All;
                    ToolTip = 'Source code for closing VAT.';
                }
                field("Inchidere TVA Tax Code"; Rec."Inchidere TVA Tax Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Tax code for closing VAT.';
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(InitMappingSource)
            {
                ApplicationArea = All;
                Caption = 'Initialize Souce for Mapping';
                Image = GetSourceDoc;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Generate lines on the G/L Account Mapping page based on an existing chart of accounts.';

                trigger OnAction()
                var
                    SAFTMappingHelper: Codeunit "SSAFTSAFT Mapping Helper";
                begin
                    SAFTMappingHelper.Run(Rec);
                    CurrPage.Update;
                end;
            }
            action(CopyMapping)
            {
                ApplicationArea = All;
                Caption = 'Copy Mapping from Another Range';
                Image = Copy;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Copy the G/L account mapping from another mapping code.';

                trigger OnAction()
                var
                    SAFTCopyMapping: Report "SSAFTSAFT Copy Mapping";
                begin
                    Clear(SAFTCopyMapping);
                    SAFTCopyMapping.InitializeRequest(Rec.Code);
                    SAFTCopyMapping.Run;
                    CurrPage.Update;
                end;
            }
        }
    }

    procedure GetSelectionFilter(): Text
    var
        SAFTMappingRange: Record "SSAFTSAFT Mapping Range";
    begin
        CurrPage.SetSelectionFilter(SAFTMappingRange);
        SAFTMappingRange.FindLast;
        exit(SAFTMappingRange.Code);
    end;
}

#pragma implicitwith restore

