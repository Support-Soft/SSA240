tableextension 70038 "SSA FA Ledger Entry70038" extends "FA Ledger Entry"
{
    // SSA953 SSCAT 25.09.2019 19.Funct. intrastat
    fields
    {
        field(70000; "SSA Transaction Type"; Code[10])
        {
            Caption = 'Transaction Type';
            DataClassification = CustomerContent;
            Description = 'SSA953';
            TableRelation = "Transaction Type";
        }
        field(70001; "SSA Transport Method"; Code[10])
        {
            Caption = 'Transport Method';
            DataClassification = CustomerContent;
            Description = 'SSA953';
            TableRelation = "Transport Method";
        }
        field(70002; "SSA Country/Region Code"; Code[10])
        {
            Caption = 'Country/Region Code';
            DataClassification = CustomerContent;
            Description = 'SSA953';
            TableRelation = "Country/Region";
        }
        field(70003; "SSA Entry/Exit Point"; Code[10])
        {
            Caption = 'Entry/Exit Point';
            DataClassification = CustomerContent;
            Description = 'SSA953';
            TableRelation = "Entry/Exit Point";
        }
        field(70004; "SSA Area"; Code[10])
        {
            Caption = 'Area';
            DataClassification = CustomerContent;
            Description = 'SSA953';
            TableRelation = Area;
        }
        field(70005; "SSA Transaction Specification"; Code[10])
        {
            Caption = 'Transaction Specification';
            DataClassification = CustomerContent;
            Description = 'SSA953';
            TableRelation = "Transaction Specification";
        }
        field(70006; "SSA Shpt. Method Code"; Code[10])
        {
            Caption = 'Shpt. Method Code';
            DataClassification = CustomerContent;
            Description = 'SSA953';
            TableRelation = "Shipment Method";
        }
    }
}