table 70200 "SSA Adjust Exch. Rate Buffer"
{
    // SSA960 SSCAT 17.06.2019 26.Funct. reevaluare solduri valutare

    Caption = 'Adjust Exchange Rate Buffer';
    ReplicateData = false;
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
            DataClassification = SystemMetadata;
            TableRelation = Currency;
        }
        field(2; "Posting Group"; Code[20])
        {
            Caption = 'Posting Group';
            DataClassification = SystemMetadata;
        }
        field(3; AdjBase; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'AdjBase';
            DataClassification = SystemMetadata;
        }
        field(4; AdjBaseLCY; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'AdjBaseLCY';
            DataClassification = SystemMetadata;
        }
        field(5; AdjAmount; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'AdjAmount';
            DataClassification = SystemMetadata;
        }
        field(6; TotalGainsAmount; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'TotalGainsAmount';
            DataClassification = SystemMetadata;
        }
        field(7; TotalLossesAmount; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'TotalLossesAmount';
            DataClassification = SystemMetadata;
        }
        field(8; "Dimension Entry No."; Integer)
        {
            Caption = 'Dimension Entry No.';
            DataClassification = SystemMetadata;
        }
        field(9; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
            DataClassification = SystemMetadata;
        }
        field(10; "IC Partner Code"; Code[20])
        {
            Caption = 'IC Partner Code';
            DataClassification = SystemMetadata;
        }
        field(11; Index; Integer)
        {
            Caption = 'Index';
            DataClassification = SystemMetadata;
        }
        field(70000; "SSA Source Type"; Option)
        {
            Caption = 'Source Type';
            Description = 'SSA960';
            OptionCaption = ' ,Customer,Vendor,Bank Account,Fixed Asset';
            OptionMembers = " ",Customer,Vendor,"Bank Account","Fixed Asset";
        }
        field(70001; "SSA Source No."; Code[20])
        {
            Description = 'SSA960';
            Caption = 'Source No.';
        }
        field(70002; "Entry No."; Integer)
        {
            Description = 'SSA960';
            Caption = 'Entry No.';
        }
    }

    keys
    {
        key(Key1; "Currency Code", "Posting Group", "Dimension Entry No.", "Posting Date", "IC Partner Code", "Entry No.")
        {
            Clustered = true;
        }
    }
}
