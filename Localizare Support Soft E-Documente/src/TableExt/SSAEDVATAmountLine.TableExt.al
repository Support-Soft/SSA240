tableextension 72016 "SSAEDVAT Amount Line" extends "VAT Amount Line"
{
    procedure InsertLineEfactura(): Boolean
    var
        VATAmountLine: Record "VAT Amount Line";
    begin
        if not (("VAT Base" <> 0) or ("Amount Including VAT" <> 0)) then
            exit(false);

        //Cumulate Negative and Positive Lines Efactura Requests Positive := "Line Amount" >= 0;
        VATAmountLine := Rec;
        if FIND then begin
            "Line Amount" += VATAmountLine."Line Amount";
            "Inv. Disc. Base Amount" += VATAmountLine."Inv. Disc. Base Amount";
            "Invoice Discount Amount" += VATAmountLine."Invoice Discount Amount";
            Quantity += VATAmountLine.Quantity;
            "VAT Base" += VATAmountLine."VAT Base";
            "Amount Including VAT" += VATAmountLine."Amount Including VAT";
            "VAT Difference" += VATAmountLine."VAT Difference";
            "VAT Amount" := "Amount Including VAT" - "VAT Base";
            "Calculated VAT Amount" += VATAmountLine."Calculated VAT Amount";
            MODIFY;
        end else begin
            "VAT Amount" := "Amount Including VAT" - "VAT Base";
            INSERT;
        end;

        exit(true);
    end;

}