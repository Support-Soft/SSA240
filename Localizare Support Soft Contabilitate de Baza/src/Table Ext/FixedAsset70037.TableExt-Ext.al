tableextension 70037 "SSA Fixed Asset70037" extends "Fixed Asset"
{
    // SSA957 SSCAT 23.08.2019 23.Funct. Obiecte de inventar: lista si fisa obiecte de inventar, punere in functiune, full description
    // SSA953 SSCAT 25.09.2019 19.Funct. intrastat
    fields
    {
        field(70000; "SSA Type"; Option)
        {
            Caption = 'Type';
            DataClassification = CustomerContent;
            Description = 'SSA953';
            OptionCaption = ' ,Fixed Asset,Inventory';
            OptionMembers = " ","Fixed Asset",Inventory;
        }
        field(70001; "SSA Full Description"; Text[250])
        {
            Caption = 'Full Description';
            DataClassification = CustomerContent;
            Description = 'SSA953';
        }
        field(70002; "SSA Net Weight"; Decimal)
        {
            Caption = 'Net Weight';
            DataClassification = CustomerContent;
            DecimalPlaces = 0 : 5;
            Description = 'SSA953';
            MinValue = 0;
        }
        field(70003; "SSA Tariff No."; Code[20])
        {
            Caption = 'Tariff No.';
            DataClassification = CustomerContent;
            Description = 'SSA953';
            TableRelation = "Tariff Number";
            ValidateTableRelation = false;

            trigger OnValidate()
            var
                TariffNumber: Record "Tariff Number";
            begin
                if "SSA Tariff No." = '' then
                    exit;

                if (not TariffNumber.WritePermission) or
                   (not TariffNumber.ReadPermission)
                then
                    exit;

                if TariffNumber.Get("SSA Tariff No.") then
                    exit;

                TariffNumber.Init();
                TariffNumber."No." := "SSA Tariff No.";
                TariffNumber.Insert();
            end;
        }
        field(70004; "SSA Country/Region of Origin"; Code[10])
        {
            Caption = 'Country/Region of Origin Code';
            DataClassification = CustomerContent;
            Description = 'SSA953';
            TableRelation = "Country/Region";
        }
    }
}
