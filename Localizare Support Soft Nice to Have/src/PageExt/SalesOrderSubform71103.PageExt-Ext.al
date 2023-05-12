pageextension 71103 "SSA Sales Order Subform 71103" extends "Sales Order Subform"
{
    // SSA939 SSCAT 23.10.2019 5.Funct. cautare avansata articole
    actions
    {
        addafter("O&rder")
        {
            action("SSA Search Item")
            {
                ApplicationArea = All;
                Caption = 'Search Items';

                trigger OnAction()
                var
                    TempItem: Record Item temporary;
                    SalesLine: Record "Sales Line";
                    LastLineNo: Integer;
                begin
                    //SSA939>>
                    if PAGE.RunModal(PAGE::"SSA Search Items", TempItem) = ACTION::LookupOK then begin
                        SalesLine.SetRange("Document Type", "Document Type");
                        SalesLine.SetRange("Document No.", "Document No.");
                        if SalesLine.FindLast then
                            LastLineNo := SalesLine."Line No.";

                        SalesLine.Init;
                        SalesLine.Validate("Document Type", "Document Type");
                        SalesLine.Validate("Document No.", "Document No.");
                        SalesLine.Validate("Line No.", LastLineNo + 10000);
                        SalesLine.Validate(Type, SalesLine.Type::Item);
                        SalesLine.Validate("No.", TempItem."No.");
                        SalesLine.Insert(true);
                    end;
                    //SSA939<<
                end;
            }
        }
    }
}

