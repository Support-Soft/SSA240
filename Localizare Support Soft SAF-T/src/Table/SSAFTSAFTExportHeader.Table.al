table 71903 "SSAFTSAFT Export Header"
{
    // SSM2101 SSCAT 04.01.2023 SAF-T

    Caption = 'SAFT Export Header';

    fields
    {
        field(1; ID; Integer)
        {
            AutoIncrement = true;
            Caption = 'ID';
        }
        field(2; "Mapping Range Code"; Code[20])
        {
            Caption = 'Mapping Range Code';
            TableRelation = "SSAFTSAFT Mapping Range";

            trigger OnValidate()
            var
                SAFTMappingRange: Record "SSAFTSAFT Mapping Range";
            begin
                if "Mapping Range Code" = '' then begin
                    "Starting Date" := 0D;
                    "Ending Date" := 0D;
                end else begin
                    SAFTMappingRange.Get("Mapping Range Code");
                    "Starting Date" := SAFTMappingRange."Starting Date";
                    "Ending Date" := SAFTMappingRange."Ending Date";
                end;
            end;
        }
        field(3; "Starting Date"; Date)
        {
            Caption = 'Starting Date';
        }
        field(4; "Ending Date"; Date)
        {
            Caption = 'Ending Date';
        }
        field(5; "Parallel Processing"; Boolean)
        {
            Caption = 'Parallel Processing';
        }
        field(6; "Max No. Of Jobs"; Integer)
        {
            Caption = 'Max No. Of Jobs';
            InitValue = 3;
            MinValue = 1;
        }
        field(8; "Earliest Start Date/Time"; DateTime)
        {
            Caption = 'Earliest Start Date/Time';

            trigger OnLookup()
            var
                DateTimeDialog: Page "Date-Time Dialog";
            begin
                DateTimeDialog.SetDateTime(RoundDateTime("Earliest Start Date/Time", 1000));
                if DateTimeDialog.RunModal = ACTION::OK then
                    "Earliest Start Date/Time" := DateTimeDialog.GetDateTime;
            end;
        }
        field(9; "Folder Path"; Text[250])
        {
            Caption = 'Folder Path';
        }
        field(10; Status; Option)
        {
            Caption = 'Status';
            Editable = false;
            OptionCaption = 'Not Started,In Progress,Failed,Completed';
            OptionMembers = "Not Started","In Progress",Failed,Completed;
        }
        field(11; "Header Comment SAFT Type"; Option)
        {
            Caption = 'Header Comment SAFT Type';
            OptionCaption = ' ,L - pentru declaratii lunare,T - pentru declaratii trimestriale,A - pentru declaratii anuale,C - pentru declaratii la cerere,NL - nerezidenti lunar,NT - nerezidenti trimestrial';
            OptionMembers = " ","L - pentru declaratii lunare","T - pentru declaratii trimestriale","A - pentru declaratii anuale","C - pentru declaratii la cerere","NL - nerezidenti lunar","NT - nerezidenti trimestrial";
        }
        field(12; "Execution Start Date/Time"; DateTime)
        {
            Caption = 'Execution Start Date/Time';
            Editable = false;
        }
        field(13; "Execution End Date/Time"; DateTime)
        {
            Caption = 'Execution End Date/Time';
            Editable = false;
        }
        field(14; "SAF-T File"; BLOB)
        {
            Caption = 'SAF-T File';
        }
        field(20; "Tax Accounting Basis"; Option)
        {
            Caption = 'Tax Accounting Basis';
            DataClassification = ToBeClassified;
            InitValue = A;
            OptionMembers = " ",A,I,IFRS,BANK,INSURANCE,NORMA39,IFN;
        }
    }

    keys
    {
        key(Key1; ID)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    var
        SAFTExportMgt: Codeunit "SSAFTSAFT Export Mgt.";
    begin
        SAFTExportMgt.DeleteExport(Rec);
    end;


    procedure AllowedToExportIntoFolder(): Boolean
    begin
        exit("Folder Path" <> '');
    end;
}

