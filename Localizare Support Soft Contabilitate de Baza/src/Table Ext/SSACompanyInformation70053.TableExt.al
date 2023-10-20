tableextension 70053 "SSA Company Information70053" extends "Company Information"
{
    // SSA968 SSCAT 04.10.2019 34.Funct. Operatiuni triunghiulare, delivery, cod registru comertului, numar comanda client
    fields
    {
        field(70000; "SSA Commerce Trade No."; Code[20])
        {
            Caption = 'Commerce Trade No.';
            DataClassification = CustomerContent;
            Description = 'SSA968';
        }
        field(70001; "SSA Capital Stock"; Decimal)
        {
            Caption = 'Capital Stock';
            DataClassification = CustomerContent;
        }
        field(70002; "SSA Bank Name 1"; Text[100])
        {
            Caption = 'Bank Name 1';
            DataClassification = CustomerContent;
        }
        field(70003; "SSA IBAN 1"; Code[50])
        {
            Caption = 'IBAN 1';
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                CheckIBAN("SSA IBAN 1");
            end;
        }
        field(70004; "SSA SWIFT Code 1"; Code[20])
        {
            Caption = 'Cod SWIFT 1';
            TableRelation = "SWIFT Code";
            DataClassification = CustomerContent;
        }
        field(70005; "SSA Bank Name 2"; Text[100])
        {
            Caption = 'Bank Name 2';
            DataClassification = CustomerContent;
        }
        field(70006; "SSA IBAN 2"; Code[50])
        {
            Caption = 'IBAN 2';
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                CheckIBAN("SSA IBAN 2");
            end;
        }
        field(70007; "SSA SWIFT Code 2"; Code[20])
        {
            Caption = 'Cod SWIFT 2';
            TableRelation = "SWIFT Code";
            DataClassification = CustomerContent;
        }
    }
}
