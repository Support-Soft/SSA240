pageextension 70074 "SSA Posted Invt. Shipments" extends "Posted Invt. Shipments"
{
    layout
    {
        addlast(Control1)
        {
            field("SSA Sell-to Customer No."; Rec."SSA Sell-to Customer No.")
            {
                ApplicationArea = All;
                ToolTip = 'The Sell-to Customer No. field is used to specify the customer number of the customer who is to receive the shipment.';
            }
            field("SSA Sell-to Customer Name"; Rec."SSA Sell-to Customer Name")
            {
                ApplicationArea = All;
                ToolTip = 'The Sell-to Customer Name field is used to specify the name of the customer who is to receive the shipment.';
            }
        }
    }
    actions
    {
        addlast(processing)
        {
            action("SSA Print Int. Cons.")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Print Int. Cons.';
                Ellipsis = true;
                Image = Print;
                ToolTip = 'Prepare to print the document. A report request window for the document opens where you can specify what to include on the print-out.';

                trigger OnAction()
                var
                    InvtShptHeader: Record "Invt. Shipment Header";
                begin
                    InvtShptHeader := Rec;
                    CurrPage.SetSelectionFilter(InvtShptHeader);
                    Report.RunModal(Report::"SSA Invt. Shipment Int. Cons.", true, true, InvtShptHeader);
                end;
            }
        }
    }
}