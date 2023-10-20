page 70003 "SSA Posted Int. Consumptions"
{
    // SSA937 SSCAT 16.06.2019 3.Funct. Bonuri de consum-consum intern

    Caption = 'Posted Int. Consumptions';
    Editable = false;
    PageType = Document;
    SourceTable = "SSA Pstd. Int. Cons. Header";
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
                }
                field("Responsibility Center"; Rec."Responsibility Center")
                {
                    ApplicationArea = All;
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
            }
            part(PostedIntConsumptionLines; "SSAPstd. Int. Cons. Subform")
            {
                Caption = 'Lines';
                SubPageLink = "Document No." = field("No.");
                ApplicationArea = All;
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
                    RunPageLink = "No." = field("No.");
                    RunPageView = sorting("Document Type", "No.", "Document Line No.", "Line No.")
                                  where("Document Type" = const("Internal Consumption"));
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
                        Rec.ShowDimensions();
                    end;
                }
            }
        }
        area(Processing)
        {
            action("&Print")
            {
                ApplicationArea = All;
                Caption = '&Print';
                Image = Print;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Executes the &Print action.';
                trigger OnAction()
                var
                    SSAPstdIntConsHeader: Record "SSA Pstd. Int. Cons. Header";
                    SSAReportSelections: Record "SSA Report Selections";
                    IntConsPrint: Codeunit "SSA Int. Cons-Post + Print";
                begin
                    SSAPstdIntConsHeader.Get(Rec."No.");
                    SSAPstdIntConsHeader.SetRecFilter();
                    IntConsPrint.PrintReport(SSAPstdIntConsHeader, SSAReportSelections.Usage::"P.I.Cons", true);
                end;
            }
            action("&Navigate")
            {
                ApplicationArea = All;
                Caption = '&Navigate';
                Image = Navigate;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Executes the &Navigate action.';
                trigger OnAction()
                begin
                    Rec.Navigate();
                end;
            }
        }
    }
}
