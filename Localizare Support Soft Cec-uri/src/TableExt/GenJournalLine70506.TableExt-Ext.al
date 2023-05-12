tableextension 70506 "SSA Gen. Journal Line 70506" extends "Gen. Journal Line" //81
{
    fields
    {
        field(70500; "SSA Entry No."; integer)
        {
            Caption = 'Entry No.';
        }
        field(70501; "SSA Applies-to CEC No."; code[20])
        {
            Caption = 'Applies-to CEC No.';
            TableRelation = IF ("Account Type" = CONST (Customer)) "SSA Payment Header"."No." WHERE ("Status Name" = FILTER ('@*Trimis la banca*|@*Emis*'), "Line Account No." = FIELD ("Account No.")) ELSE
            IF ("Account Type" = CONST (Vendor)) "SSA Payment Header"."No." WHERE ("Status Name" = FILTER ('@*Trimis la banca*|@*Emis*'), "Line Account No." = FIELD ("Account No."));
            trigger OnValidate()
            var
                PaymentHeader: Record "SSA Payment Header";
            begin
                IF "SSA Applies-to CEC No." <> '' THEN BEGIN
                    PaymentHeader.GET("SSA Applies-to CEC No.");
                    PaymentHeader.CALCFIELDS(Amount);
                    VALIDATE(Amount, PaymentHeader.Amount);
                END ELSE
                    VALIDATE(Amount, 0);
            end;
        }
    }

}