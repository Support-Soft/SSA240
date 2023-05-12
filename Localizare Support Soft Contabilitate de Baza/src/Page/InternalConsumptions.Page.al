page 70000 "SSA Internal Consumptions"
{
    // SSA937 SSCAT 16.06.2019 3.Funct. Bonuri de consum-consum intern
    // SSA1097 SSCAT 07.10.2019 Anulare bon consum
    Caption = 'Internal Consumptions';
    PageType = Document;
    SourceTable = "SSAInternal Consumption Header";

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("No."; "No.")
                {
                    ApplicationArea = All;

                    trigger OnAssistEdit()
                    begin
                        if AssistEdit(xRec) then
                            CurrPage.Update;
                    end;
                }
                field(Control1390028; Comment)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Responsibility Center"; "Responsibility Center")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Location Code"; "Location Code")
                {
                    ApplicationArea = All;
                }
                field("Your Reference"; "Your Reference")
                {
                    ApplicationArea = All;
                }
                field("Posting Date"; "Posting Date")
                {
                    ApplicationArea = All;
                }
                field("Document Date"; "Document Date")
                {
                    ApplicationArea = All;
                }
                field("External Document No."; "External Document No.")
                {
                    ApplicationArea = All;
                }
                field("Posting No."; "Posting No.")
                {
                    ApplicationArea = All;
                }
                field("Shortcut Dimension 1 Code"; "Shortcut Dimension 1 Code")
                {
                    ApplicationArea = All;
                }
                field("Shortcut Dimension 2 Code"; "Shortcut Dimension 2 Code")
                {
                    ApplicationArea = All;
                }
                field("Gen. Bus. Posting Group"; "Gen. Bus. Posting Group")
                {
                    ApplicationArea = All;
                }
                field(Cancelled; Cancelled)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Cancelled from No."; "Cancelled from No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
            }
            part(InternalConsumptionLine; "SSAInt. Consumption Subform")
            {
                ApplicationArea = All;
                Caption = 'Lines';
                SubPageLink = "Document No." = FIELD("No.");
            }
        }
        area(factboxes)
        {
            part("Int. Consumption FactBox"; "SSAInt. Consumption FactBox")
            {
                ApplicationArea = All;
                Caption = 'Int. Consumption FactBox';
                Provider = InternalConsumptionLine;
                SubPageLink = "Document No." = FIELD("Document No."),
                              "Line No." = FIELD("Line No.");
                Visible = true;
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Internal Consumption")
            {
                Caption = '&Internal Consumption';
                action("Co&mments")
                {
                    ApplicationArea = All;
                    Caption = 'Co&mments';
                    Image = ViewComments;
                    RunObject = Page "SSA Comment Sheet";
                    RunPageLink = "Document Type" = FILTER("Internal Consumption"),
                                  "No." = FIELD("No.");
                }
                action(Dimensions)
                {
                    ApplicationArea = All;
                    Caption = 'Dimensions';
                    Image = Dimensions;

                    trigger OnAction()
                    begin
                        ShowDocDim;
                        CurrPage.SaveRecord;
                    end;
                }
                action("Storno from...")
                {
                    ApplicationArea = All;
                    Caption = 'Storno from...';

                    trigger OnAction()
                    begin
                        StornoFrom; //SSA1097
                    end;
                }
            }
        }
        area(processing)
        {
            group("Po&sting")
            {
                Caption = 'Po&sting';
                action("P&ost")
                {
                    ApplicationArea = All;
                    Caption = 'P&ost';
                    Image = Post;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ShortCutKey = 'F9';
                    trigger OnAction()
                    begin
                        Post(CODEUNIT::"SSA Int. Cons-Post (Yes/No)", NavigateAfterPost::"Posted Document");
                    end;
                }
                action(PostAndNew)
                {
                    ApplicationArea = All;
                    Caption = 'Post and New';
                    Image = PostOrder;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = false;
                    ShortCutKey = 'Shift+F9';
                    Ellipsis = true;
                    trigger OnAction()
                    begin
                        Post(CODEUNIT::"SSA Int. Cons-Post (Yes/No)", NavigateAfterPost::"New Document");
                    end;
                }
                action("Post and &Print")
                {
                    ApplicationArea = All;
                    Caption = 'Post and &Print';
                    Image = PostPrint;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    trigger OnAction()
                    begin
                        Post(CODEUNIT::"SSA Int. Cons-Post + Print", NavigateAfterPost::Nowhere);
                    end;
                }
            }
            action(Comment)
            {
                ApplicationArea = All;
                Caption = 'Comment';
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page "SSA Comment Sheet";
                RunPageLink = "Document Type" = CONST("Internal Consumption"),
                              "No." = FIELD("No.");
                ToolTip = 'Comment';
            }
        }
    }
    var
        NavigateAfterPost: Option "","Posted Document","New Document",Nowhere;

    trigger OnDeleteRecord(): Boolean
    begin
        CurrPage.SaveRecord;
        exit(ConfirmDeletion);
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        "Responsibility Center" := SSAUserMgt.GetIntConsumptionFilter();
    end;

    trigger OnOpenPage()
    begin
        if SSAUserMgt.GetIntConsumptionFilter() <> '' then begin
            FilterGroup(2);
            SetRange("Responsibility Center", SSAUserMgt.GetIntConsumptionFilter());
            FilterGroup(0);
        end;
    end;

    var
        SalesSetup: Record "Sales & Receivables Setup";
        PostedIntConsHeader: Record "SSA Pstd. Int. Cons. Header";
        PostedIntConsLine: Record "SSAPstd. Int. Consumption Line";
        NewLine: Record "SSAInternal Consumption Line";
        UserSetup: Record "User Setup";
        IntConsHeader: Record "SSAInternal Consumption Header";
        ReportPrint: Codeunit "Test Report-Print";
        UserMgt: Codeunit "User Setup Management";
        SSAUserMgt: Codeunit "SSA User Setup Management";
        InstructionMgt: Codeunit "Instruction Mgt.";
        Text16100: Label 'Storno Consumption %1';
        OpenPostedSalesOrderQst: Label 'The order is posted as number %1 and moved to the Posted Internal Consumption window.\\Do you want to open the Posted Internal Consumption?';

    local procedure Post(_PostingCodeunitID: Integer; Navigate: Option)
    var
        DocumentIsPosted: Boolean;
    begin
        SendToPosting(_PostingCodeunitID);
        DocumentIsPosted := (NOT IntConsHeader.GET("No."));
        CurrPage.UPDATE(FALSE);

        IF _PostingCodeunitID <> CODEUNIT::"SSA Int. Cons-Post (Yes/No)" THEN
            EXIT;

        CASE Navigate OF
            NavigateAfterPost::"Posted Document":
                IF InstructionMgt.IsEnabled(InstructionMgt.ShowPostedConfirmationMessageCode) THEN
                    ShowPostedConfirmationMessage;
            NavigateAfterPost::"New Document":
                IF DocumentIsPosted THEN BEGIN
                    IntConsHeader.INIT;
                    IntConsHeader.INSERT(TRUE);
                    PAGE.RUN(PAGE::"SSA Internal Consumptions", IntConsHeader);
                END;
        END;
    end;

    LOCAL procedure ShowPostedConfirmationMessage()

    begin
        IF NOT IntConsHeader.GET("No.") THEN BEGIN
            PostedIntConsHeader.SETRANGE("No.", "Last Posting No.");
            IF PostedIntConsHeader.FINDFIRST THEN
                IF InstructionMgt.ShowConfirm(STRSUBSTNO(OpenPostedSalesOrderQst, PostedIntConsHeader."No."),
                     InstructionMgt.ShowPostedConfirmationMessageCode)
                THEN begin
                    PAGE.RUN(PAGE::"SSA Posted Int. Consumptions", PostedIntConsHeader);
                    CurrPage.Close();
                end;
        END;
    end;
}

