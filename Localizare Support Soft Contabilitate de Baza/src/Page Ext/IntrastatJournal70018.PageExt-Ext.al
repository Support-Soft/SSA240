pageextension 70018 "SSA Intrastat Journal 70018" extends "Intrastat Journal"
{
    // SSA953 SSCAT 05.07.2019 19.Funct. intrastat
    layout
    {
        addlast(Control1)
        {
            field("SSA Country/Region of Origin Code"; "Country/Region of Origin Code")
            {
                ApplicationArea = All;
            }
            field("SSA Source Type"; "SSA Source Type")
            {
                ApplicationArea = All;
            }
        }
    }
    actions
    {
        modify(GetEntries)
        {
            Visible = false;
            ApplicationArea = All;
        }
        addafter(GetEntries)
        {
            action("SSA GetEntriesCustom")
            {
                ApplicationArea = All;
                Caption = 'Suggest Lines';
                Ellipsis = true;
                Image = SuggestLines;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                ToolTip = 'Suggests Intrastat transactions to be reported and fills in Intrastat journal.';

                trigger OnAction()
                var
                    SSAGetItemEntries: Report "SSA Get Item Ledger Entries";
                begin
                    //SSA953>>
                    SSAGetItemEntries.SetIntrastatJnlLine(Rec);
                    SSAGetItemEntries.RunModal;
                    Clear(SSAGetItemEntries);
                    //SSA953<<
                end;
            }
        }
        addafter(Form)
        {
            action("SSA Export to XML")
            {
                ApplicationArea = All;
                Caption = 'Export to XML';
                Ellipsis = true;
                Image = ExportFile;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    ExportIntrastatXML: Report "SSA Export XML Intrastat";
                begin
                    //SSA953>>
                    Clear(ExportIntrastatXML);
                    ExportIntrastatXML.SetParam("Journal Template Name", "Journal Batch Name");
                    ExportIntrastatXML.Run;
                    //SSA953<<
                end;
            }
        }
    }
}

