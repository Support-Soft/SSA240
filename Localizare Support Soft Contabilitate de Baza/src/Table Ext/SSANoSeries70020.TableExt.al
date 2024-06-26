tableextension 70020 "SSA No. Series70020" extends "No. Series"
{
    // SSA973 SSCAT 06.09.2019 39.Rapoarte legale- Localizare Declaratia 394
    fields
    {
        field(70000; "SSA Tip Serie"; Option)
        {
            Caption = 'Tip Serie';
            DataClassification = CustomerContent;
            Description = 'SSA973';
            OptionMembers = " ",,,"Emise de Beneficiari","Emise de Terti",Autofactura;
        }
        field(70001; "SSA Denumire Beneficiar/Tert"; Text[100])
        {
            DataClassification = CustomerContent;
            Description = 'SSA973';
            Caption = 'Denumire Beneficiar/Tert';
        }
        field(70002; "SSA CUI Beneficiar Tert"; Code[10])
        {
            DataClassification = CustomerContent;
            Description = 'SSA973';
            Caption = 'CUI Beneficiar Tert';
        }
        field(70003; "SSA Export D394"; Boolean)
        {
            Caption = 'Export D394';
            DataClassification = CustomerContent;
            Description = 'SSA973';
        }
    }
}
