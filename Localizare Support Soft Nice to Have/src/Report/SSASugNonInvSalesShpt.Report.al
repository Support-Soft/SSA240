report 71103 "SSA Sug. Non-Inv Sales Shpt."
{
    Caption = 'Sug. Non-Invoiced Sales Shpt.';
    ProcessingOnly = true;
    ApplicationArea = All;

    dataset
    {
        dataitem("Sales Shipment Header"; "Sales Shipment Header")
        {
            RequestFilterFields = "Posting Date";

            trigger OnAfterGetRecord()
            begin
                if Cust.Get("Sales Shipment Header"."Bill-to Customer No.") then
                    Country.Get(Cust."Country/Region Code");
                if Country."EU Country/Region Code" <> '' then begin
                    SalesShipmentLine.SetRange("Document No.", "No.");
                    if SalesShipmentLine.Find('-') then
                        repeat
                            if SalesShipmentLine."Qty. Shipped Not Invoiced" > 0 then
                                if not (SalesShipment.Get("No.")) then begin
                                    SalesShipment.TransferFields("Sales Shipment Header");
                                    SalesShipment.Insert
                                end
                        until SalesShipmentLine.Next = 0;
                end;
            end;
        }
    }

    requestpage
    {
        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnPreReport()
    begin
        SalesShipment.DeleteAll;
    end;

    var
        SalesShipmentLine: Record "Sales Shipment Line";
        SalesShipment: Record "SSA Non-Invoiced Sales Ship";
        Cust: Record Customer;
        Country: Record "Country/Region";
}
