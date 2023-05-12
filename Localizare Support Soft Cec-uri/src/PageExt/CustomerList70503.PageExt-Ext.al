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
                RunPageView = SORTING("Entry No.") ORDER(Ascending) WHERE(Open = FILTER(true));
                RunPageLink = "Customer No." = FIELD("No."), "Document Type" = FILTER(Invoice);
            }
        }
    }
}