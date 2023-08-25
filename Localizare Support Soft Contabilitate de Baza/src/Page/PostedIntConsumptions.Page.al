page 70003 "SSA Posted Int. Consumptions"
{
    // SSA937 SSCAT 16.06.2019 3.Funct. Bonuri de consum-consum intern

    Caption = 'Posted Int. Consumptions';
    Editable = false;
    PageType = Document;
    SourceTable = "SSA Pstd. Int. Cons. Header";

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
                }
                field("Responsibility Center"; "Responsibility Center")
                {
                    ApplicationArea = All;
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
                field("Shortcut Dimension 1 Code"; "Shortcut Dimension 1 Code")
                {
                    ApplicationArea = All;
                }
                field("Shortcut Dimension 2 Code"; "Shortcut Dimension 2 Code")
                {
                    ApplicationArea = All;
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
                    RunPageLink = "No." = field("No.");
                    RunPageView = sorting("Document Type", "No.", "Document Line No.", "Line No.")
                                  where("Document Type" = const("Internal Consumption"));
                }
                action(Dimensions)
                {
                    ApplicationArea = All;
                    Caption = 'Dimensions';
                    Image = Dimensions;

                    trigger OnAction()
                    begin
                        ShowDimensions;
                    end;
                }
            }
        }
        area(processing)
        {
            action("&Print")
            {
                ApplicationArea = All;
                Caption = '&Print';
                Image = Print;
                Promoted = true;
                PromotedCategory = Process;

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
                ApplicationArea = All;
                Caption = '&Navigate';
                Image = Navigate;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    Navigate;
                end;
            }
        }
    }
}

