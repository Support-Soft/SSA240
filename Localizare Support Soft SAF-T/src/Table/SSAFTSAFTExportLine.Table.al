table 71904 "SSAFTSAFT Export Line"
{
    // SSM2101 SSCAT 04.01.2023 SAF-T

    Caption = 'SAFT Export Line';

    fields
    {
        field(1; ID; Integer)
        {
            Caption = 'ID';
            TableRelation = "SSAFTSAFT Export Header";
        }
        field(2; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(3; "Task ID"; Guid)
        {
            Caption = 'Task ID';
        }
        field(4; Progress; Integer)
        {
            Caption = 'Progress';
            ExtendedDatatype = Ratio;
        }
        field(5; Status; Option)
        {
            Caption = 'Status';
            OptionCaption = 'Not Started,In Progress,Failed,Completed';
            OptionMembers = "Not Started","In Progress",Failed,Completed;
        }
        field(7; Description; Text[250])
        {
            Caption = 'Description';
        }
        field(8; "No. Of Retries"; Integer)
        {
            Caption = 'No. Of Retries';
            InitValue = 3;
        }
        field(10; "Starting Date"; Date)
        {
            Caption = 'Starting Date';
        }
        field(11; "Ending Date"; Date)
        {
            Caption = 'Ending Date';
        }
        field(20; "SAF-T File"; BLOB)
        {
            Caption = 'SAF-T File';
        }
        field(21; "Server Instance ID"; Integer)
        {
            Caption = 'Server Instance ID';
        }
        field(22; "Session ID"; Integer)
        {
            Caption = 'Session ID';
        }
        field(23; "Created Date/Time"; DateTime)
        {
            Caption = 'Created Date/Time';
        }
        field(50000; "Type of Line"; Option)
        {
            Caption = 'Type of Line';
            DataClassification = ToBeClassified;
            OptionCaption = ' ,G/L Accounts,Taxonomies,Customers,Suppliers,Tax Table,UoM Table,Analysis Type Table,Movement Type Table,Products,Physical Stock,Owners,Assets,G/L Entries,Sales Invoices,Purchase Invoices,Payments,Movement of Goods,Asset Transactions,Structures,Simple Types';
            OptionMembers = " ","G/L Accounts",Taxonomies,Customers,Suppliers,"Tax Table","UoM Table","Analysis Type Table","Movement Type Table",Products,"Physical Stock",Owners,Assets,"G/L Entries","Sales Invoices","Purchase Invoices",Payments,"Movement of Goods","Asset Transactions",Structures,"Simple Types";
        }
        field(50010; "Export File"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50020; "Segment Index"; Integer)
        {
            Caption = 'Segment Index';
            DataClassification = ToBeClassified;
            Description = 'SSM1724';
        }
    }

    keys
    {
        key(Key1; ID, "Line No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    var
        ActivityLog: Record "Activity Log";
    begin
        ActivityLog.SetRange("Record ID", RecordId);
        ActivityLog.DeleteAll;
    end;
}

