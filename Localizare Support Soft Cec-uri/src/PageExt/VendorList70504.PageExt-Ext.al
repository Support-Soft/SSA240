pageextension 70504 "SSA Vendor List 70504" extends "Vendor List" //27
{
    layout
    {

    }

    actions
    {
        addlast("Ven&dor")
        {
            action("SSA CEC/BO")
            {
                ApplicationArea = All;
                Caption = 'CEC/BO';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = page "SSA CEC & BO Vendor";
                RunPageView = SORTING("Entry No.") ORDER(Ascending) WHERE(Open = FILTER(true));
                RunPageLink = "Vendor No." = FIELD("No."), "Document Type" = FILTER(Invoice);
            }
        }
    }
}