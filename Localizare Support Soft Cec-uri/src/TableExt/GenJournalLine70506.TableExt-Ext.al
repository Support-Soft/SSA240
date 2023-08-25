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
            TableRelation = if ("Account Type" = const(Customer)) "SSA Payment Header"."No." where("Status Name" = filter('@*Trimis la banca*|@*Emis*'), "Line Account No." = field("Account No.")) else
            if ("Account Type" = const(Vendor)) "SSA Payment Header"."No." where("Status Name" = filter('@*Trimis la banca*|@*Emis*'), "Line Account No." = field("Account No."));
            trigger OnValidate()
            var
                PaymentHeader: Record "SSA Payment Header";
            begin
                if "SSA Applies-to CEC No." <> '' then begin
                    PaymentHeader.GET("SSA Applies-to CEC No.");
                    PaymentHeader.CALCFIELDS(Amount);
                    VALIDATE(Amount, PaymentHeader.Amount);
                end else
                    VALIDATE(Amount, 0);
            end;
        }
    }

}