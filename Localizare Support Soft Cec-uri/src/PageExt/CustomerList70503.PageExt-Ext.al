pageextension 70503 "SSA Customer List 70503" extends "Customer List" //22
{
    layout
    {
    }

    actions
    {
        addlast("&Customer")
        {
            action("SSA CEC/BO")
            {
                ApplicationArea = All;
                Caption = 'CEC/BO';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = page "SSA CEC & BO Customer";
                RunPageView = sorting("Entry No.") order(ascending) where(Open = filter(true));
                RunPageLink = "Customer No." = field("No."), "Document Type" = filter(Invoice);
                ToolTip = 'Executes the CEC/BO action.';
            }
        }
    }
}