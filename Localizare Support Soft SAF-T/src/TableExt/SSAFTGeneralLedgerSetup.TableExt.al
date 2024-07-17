tableextension 71908 "SSAFTGeneral Ledger Setup" extends "General Ledger Setup"
{
    fields
    {
        field(71900; "SSAFTGrupa cu TVA UE Client"; Code[10])
        {
            Caption = 'Grupa cu TVA UE Client';
            DataClassification = CustomerContent;
            TableRelation = "VAT Business Posting Group";
        }
        field(71901; "SSAFTGrupa cu TVA NONUE Client"; Code[10])
        {
            Caption = 'Grupa cu TVA NONUE Client';
            DataClassification = CustomerContent;
            TableRelation = "VAT Business Posting Group";
        }
        field(71902; "SSAFTGrupa cu TVA UE Furnizor"; Code[10])
        {
            Caption = 'Grupa cu TVA UE Furnizor';
            DataClassification = CustomerContent;
            TableRelation = "VAT Business Posting Group";
        }
        field(71903; "SSAFTGrupa cu TVA NONUE Fz"; Code[10])
        {
            Caption = 'Grupa cu TVA NONUE Fz';
            DataClassification = CustomerContent;
            TableRelation = "VAT Business Posting Group";
        }
        field(71904; "SSAFTG/L Accounts Payments"; Text[100])
        {
            Caption = 'G/L Accounts Payments', Comment = 'Conturi Contabile de Raportat la Payments';
            DataClassification = CustomerContent;
            TableRelation = "G/L Account";
            ValidateTableRelation = false;
        }
    }

}