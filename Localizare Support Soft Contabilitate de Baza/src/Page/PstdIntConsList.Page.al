page 70005 "SSA Pstd Int. Cons. List"
{
    // SSA937 SSCAT 16.06.2019 3.Funct. Bonuri de consum-consum intern

    ApplicationArea = All;
    Caption = 'Posted Int. Consumptions List';
    CardPageID = "SSA Posted Int. Consumptions";
    Editable = false;
    PageType = List;
    SourceTable = "SSA Pstd. Int. Cons. Header";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Control1390000)
            {
                ShowCaption = false;
                field("No."; "No.")
                {
                    ApplicationArea = All;
                }
                field("Posting Description"; "Posting Description")
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
                field("Shortcut Dimension 1 Code"; "Shortcut Dimension 1 Code")
                {
                    ApplicationArea = All;
                }
                field("Shortcut Dimension 2 Code"; "Shortcut Dimension 2 Code")
                {
                    ApplicationArea = All;
                }
                field("Location Code"; "Location Code")
                {
                    ApplicationArea = All;
                }
                field("Responsibility Center"; "Responsibility Center")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("&Print")
            {
                Caption = '&Print';
                Image = Print;
                Promoted = true;
                PromotedCategory = Process;
                ApplicationArea = All;

                trigger OnAction()
                var
                    SSAPstdIntConsHeader: Record "SSA Pstd. Int. Cons. Header";
                    SSAReportSelections: Record "SSA Report Selections";
                    IntConsPrint: Codeunit "SSA Int. Cons-Post + Print";
                begin
                    SSAPstdIntConsHeader.Get("No.");
                    SSAPstdIntConsHeader.SetRecFilter;
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

                trigger OnAction()
                begin
                    Navigate;
                end;
            }
        }
    }
}

