pageextension 71300 "SSA Fixed Asset Card 71300" extends "Fixed Asset Card"
{
    actions
    {
        addlast(Reporting)
        {
            action("SSA PVCassation")
            {
                Caption = 'Cassation Report';
                Promoted = true;
                trigger OnAction()
                var
                    FA: Record "Fixed Asset";
                begin
                    fa.Get("No.");
                    FA.SetRecFilter();
                    report.RunModal(report::"SSA FA Cassation Report", true, true, FA);
                end;
            }
        }
    }
}