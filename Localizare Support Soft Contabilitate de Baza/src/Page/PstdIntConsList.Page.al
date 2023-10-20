page 70005 "SSA Pstd Int. Cons. List"
{
    // SSA937 SSCAT 16.06.2019 3.Funct. Bonuri de consum-consum intern

    ApplicationArea = All;
    Caption = 'Posted Int. Consumptions List';
    CardPageId = "SSA Posted Int. Consumptions";
    Editable = false;
    PageType = List;
    SourceTable = "SSA Pstd. Int. Cons. Header";
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(Control1390000)
            {
                ShowCaption = false;
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the No. field.';
                }
                field("Posting Description"; Rec."Posting Description")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Posting Description field.';
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
                field("Location Code"; Rec."Location Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Location Code field.';
                }
                field("Responsibility Center"; Rec."Responsibility Center")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Responsibility Center field.';
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action("&Print")
            {
                Caption = '&Print';
                Image = Print;
                Promoted = true;
                PromotedCategory = Process;
                ApplicationArea = All;
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
                Caption = '&Navigate';
                Image = Navigate;
                Promoted = true;
                PromotedCategory = Process;
                ApplicationArea = All;
                ToolTip = 'Executes the &Navigate action.';
                trigger OnAction()
                begin
                    Rec.Navigate();
                end;
            }
        }
    }
}
