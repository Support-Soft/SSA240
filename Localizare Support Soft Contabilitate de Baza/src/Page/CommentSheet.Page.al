page 70008 "SSA Comment Sheet"
{
    // SSA937 SSCAT 16.06.2019 3.Funct. Bonuri de consum-consum intern

    AutoSplitKey = true;
    Caption = 'Comment Sheet';
    DataCaptionFields = "Document Type", "No.";
    DelayedInsert = true;
    LinksAllowed = false;
    MultipleNewLines = true;
    PageType = List;
    SourceTable = "SSA Comment Line";
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field("Date"; Rec.Date)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the date the comment was created.';
                }
                field(Comment; Rec.Comment)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the comment itself.';
                }
                field("Code"; Rec.Code)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies a code for the comment.';
                    Visible = false;
                }
            }
        }
    }


    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec.SetUpNewLine();
    end;
}
