tableextension 72016 "SSAEDVAT Amount Line" extends "VAT Amount Line"
{
    fields
    {
        field(72000; "SSAEDColumn Type"; Option)
        {
            Caption = 'Column Type';
            DataClassification = ToBeClassified;
            Description = 'SSA1002';
            OptionCaption = 'VAT 24%,External Free of VAT Deductible,External Free of VAT Not Deductible,Internal Free of VAT Deductible,Internal Free of VAT Not Deductible,Unrealized VAT,Free of VAT,VAT 9%,Simplified VAT,Drop Ship Ded,Drop Ship Not Ded,ICS Free of VAT AD,ICS Free of VAT BC,Free of VAT Deductible,Free of VAT Not Deductible,Not Taxable,Capital 24%,Resale 24%,Needs 24%,Resale 9%,Needs 9%,ICA Resale,ICA Resale Free of VAT,ICA Resale Not Taxable,ICA Needs,ICA Needs Free of VAT,ICA Needs Not Taxable,Art 150 FC,Special Regime,VAT 5%,ICA Goods Not Registered,ICA Services,ICS Services';
            OptionMembers = "VAT 24%","External Free of VAT Deductible","External Free of VAT Not Deductible","Internal Free of VAT Deductible","Internal Free of VAT Not Deductible","Unrealized VAT","Free of VAT","VAT 9%","Simplified VAT","Drop Ship Ded","Drop Ship Not Ded","ICS Free of VAT AD","ICS Free of VAT BC","Free of VAT Deductible","Free of VAT Not Deductible","Not Taxable","Capital 24%","Resale 24%","Needs 24%","Resale 9%","Needs 9%","ICA Resale","ICA Resale Free of VAT","ICA Resale Not Taxable","ICA Needs","ICA Needs Free of VAT","ICA Needs Not Taxable","Art 150 FC","Special Regime","VAT 5%","ICA Goods Not Registered","ICA Services","ICS Services";
        }
    }
    procedure InsertLineEfactura(): Boolean
    var
        VATAmountLine: Record "VAT Amount Line";
    begin
        //if not (("VAT Base" <> 0) or ("Amount Including VAT" <> 0)) then
        //    exit(false);

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