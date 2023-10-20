pageextension 70018 "SSA Intrastat Journal 70018" extends "Intrastat Journal"
{
    // SSA953 SSCAT 05.07.2019 19.Funct. intrastat
    layout
    {
        addlast(Control1)
        {
            field("SSA Country/Region of Origin Code"; Rec."Country/Region of Origin Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies a code for the country/region where the item was produced or processed.';
            }
            field("SSA Source Type"; Rec."SSA Source Type")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the SSA Source Type field.';
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
                    SSAGetItemEntries.RunModal();
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
                ToolTip = 'Executes the Export to XML action.';
                trigger OnAction()
                var
                    ExportIntrastatXML: XmlPort "SSAExport Intrast Jnl to XML";
                begin
                    //SSA953>>
                    Clear(ExportIntrastatXML);
                    ExportIntrastatXML.SetParam(Rec."Journal Template Name", Rec."Journal Batch Name");
                    ExportIntrastatXML.Run();
                    //SSA953<<
                end;
            }
        }
    }
}
