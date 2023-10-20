page 70000 "SSA Internal Consumptions"
{
    // SSA937 SSCAT 16.06.2019 3.Funct. Bonuri de consum-consum intern
    // SSA1097 SSCAT 07.10.2019 Anulare bon consum
    Caption = 'Internal Consumptions';
    PageType = Document;
    SourceTable = "SSAInternal Consumption Header";
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the No. field.';
                    trigger OnAssistEdit()
                    begin
                        if Rec.AssistEdit(xRec) then
                            CurrPage.Update();
                    end;
                }
                field(Control1390028; Rec.Comment)
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Comment field.';
                }
                field("Responsibility Center"; Rec."Responsibility Center")
                {
                    ApplicationArea = All;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Responsibility Center field.';
                }
                field("Location Code"; Rec."Location Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Location Code field.';
                }
                field("Your Reference"; Rec."Your Reference")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Your Reference field.';
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Posting Date field.';
                }
                field("Document Date"; Rec."Document Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Document Date field.';
                }
                field("External Document No."; Rec."External Document No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the External Document No. field.';
                }
                field("Posting No."; Rec."Posting No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Posting No. field.';
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Shortcut Dimension 1 Code field.';
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Shortcut Dimension 2 Code field.';
                }
                field("Gen. Bus. Posting Group"; Rec."Gen. Bus. Posting Group")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Gen. Bus. Posting Group field.';
                }
                field(Cancelled; Rec.Cancelled)
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Cancelled field.';
                }
                field("Cancelled from No."; Rec."Cancelled from No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Cancelled from No. field.';
                }
            }
            part(InternalConsumptionLine; "SSAInt. Consumption Subform")
            {
                ApplicationArea = All;
                Caption = 'Lines';
                SubPageLink = "Document No." = field("No.");
            }
        }
        area(FactBoxes)
        {
            part("Int. Consumption FactBox"; "SSAInt. Consumption FactBox")
            {
                ApplicationArea = All;
                Caption = 'Int. Consumption FactBox';
                Provider = InternalConsumptionLine;
                SubPageLink = "Document No." = field("Document No."),
                              "Line No." = field("Line No.");
                Visible = true;
            }
        }
    }

    actions
    {
        area(Navigation)
        {
            group("&Internal Consumption")
            {
                Caption = '&Internal Consumption';
                action("Co&mments")
                {
                    ApplicationArea = All;
                    Caption = 'Co&mments';
                    Image = ViewComments;
                    RunObject = page "SSA Comment Sheet";
                    RunPageLink = "Document Type" = filter("Internal Consumption"),
                                  "No." = field("No.");
                    ToolTip = 'Executes the Co&mments action.';
                }
                action(Dimensions)
                {
                    ApplicationArea = All;
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    ToolTip = 'Executes the Dimensions action.';
                    trigger OnAction()
                    begin
                        Rec.ShowDocDim();
                        CurrPage.SaveRecord();
                    end;
                }
                action("Storno from...")
                {
                    ApplicationArea = All;
                    Caption = 'Storno from...';
                    ToolTip = 'Executes the Storno from... action.';
                    trigger OnAction()
                    begin
                        Rec.StornoFrom(); //SSA1097
                    end;
                }
            }
        }
        area(Processing)
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
                    ShortcutKey = 'F9';
                    ToolTip = 'Executes the P&ost action.';
                    trigger OnAction()
                    begin
                        Post(Codeunit::"SSA Int. Cons-Post (Yes/No)", NavigateAfterPost::"Posted Document");
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
                    ShortcutKey = 'Shift+F9';
                    Ellipsis = true;
                    ToolTip = 'Executes the Post and New action.';
                    trigger OnAction()
                    begin
                        Post(Codeunit::"SSA Int. Cons-Post (Yes/No)", NavigateAfterPost::"New Document");
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
                    ToolTip = 'Executes the Post and &Print action.';
                    trigger OnAction()
                    begin
                        Post(Codeunit::"SSA Int. Cons-Post + Print", NavigateAfterPost::Nowhere);
                    end;
                }
            }
            action(Comment)
            {
                ApplicationArea = All;
                Caption = 'Comment';
                Promoted = true;
                PromotedCategory = Process;
                RunObject = page "SSA Comment Sheet";
                RunPageLink = "Document Type" = const("Internal Consumption"),
                              "No." = field("No.");
                ToolTip = 'Comment';
            }
        }
    }
    var
        NavigateAfterPost: Option "","Posted Document","New Document",Nowhere;

    trigger OnDeleteRecord(): Boolean
    begin
        CurrPage.SaveRecord();
        exit(Rec.ConfirmDeletion());
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec."Responsibility Center" := SSAUserMgt.GetIntConsumptionFilter();
    end;

    trigger OnOpenPage()
    begin
        if SSAUserMgt.GetIntConsumptionFilter() <> '' then begin
            Rec.FilterGroup(2);
            Rec.SetRange("Responsibility Center", SSAUserMgt.GetIntConsumptionFilter());
            Rec.FilterGroup(0);
        end;
    end;

    var
        PostedIntConsHeader: Record "SSA Pstd. Int. Cons. Header";
        IntConsHeader: Record "SSAInternal Consumption Header";
        SSAUserMgt: Codeunit "SSA User Setup Management";
        InstructionMgt: Codeunit "Instruction Mgt.";
        OpenPostedSalesOrderQst: Label 'The order is posted as number %1 and moved to the Posted Internal Consumption window.\\Do you want to open the Posted Internal Consumption?';

    local procedure Post(_PostingCodeunitID: Integer; Navigate: Option)
    var
        DocumentIsPosted: Boolean;
    begin
        Rec.SendToPosting(_PostingCodeunitID);
        DocumentIsPosted := (not IntConsHeader.Get(Rec."No."));
        CurrPage.Update(false);

        if _PostingCodeunitID <> Codeunit::"SSA Int. Cons-Post (Yes/No)" then
            exit;

        case Navigate of
            NavigateAfterPost::"Posted Document":
                if InstructionMgt.IsEnabled(InstructionMgt.ShowPostedConfirmationMessageCode()) then
                    ShowPostedConfirmationMessage();
            NavigateAfterPost::"New Document":
                if DocumentIsPosted then begin
                    IntConsHeader.Init();
                    IntConsHeader.Insert(true);
                    Page.Run(Page::"SSA Internal Consumptions", IntConsHeader);
                end;
        end;
    end;

    local procedure ShowPostedConfirmationMessage()

    begin
        if not IntConsHeader.Get(Rec."No.") then begin
            PostedIntConsHeader.SetRange("No.", Rec."Last Posting No.");
            if PostedIntConsHeader.FindFirst() then
                if InstructionMgt.ShowConfirm(StrSubstNo(OpenPostedSalesOrderQst, PostedIntConsHeader."No."),
                     InstructionMgt.ShowPostedConfirmationMessageCode())
                then begin
                    Page.Run(Page::"SSA Posted Int. Consumptions", PostedIntConsHeader);
                    CurrPage.Close();
                end;
        end;
    end;
}
