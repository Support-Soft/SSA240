table 70004 "SSA Comment Line"
{
    // SSA937 SSCAT 16.06.2019 3.Funct. Bonuri de consum-consum intern

    Caption = 'Comment Line';
    DrillDownPageId = "SSA Comment List";
    LookupPageId = "SSA Comment List";
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Document Type"; Option)
        {
            Caption = 'Document Type';
            OptionCaption = 'Internal Consumption,Posted Internal Consumption';
            OptionMembers = "Internal Consumption","Posted Internal Consumption";
        }
        field(2; "No."; Code[20])
        {
            Caption = 'No.';
        }
        field(3; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(4; "Date"; Date)
        {
            Caption = 'Date';
        }
        field(5; "Code"; Code[10])
        {
            Caption = 'Code';
        }
        field(6; Comment; Text[80])
        {
            Caption = 'Comment';
        }
        field(7; "Document Line No."; Integer)
        {
            Caption = 'Document Line No.';
        }
    }

    keys
    {
        key(Key1; "Document Type", "No.", "Document Line No.", "Line No.")
        {
            Clustered = true;
        }
    }

    procedure SetUpNewLine()
    var
        SSACommentLine: Record "SSA Comment Line";
    begin
        SSACommentLine.SetRange("Document Type", "Document Type");
        SSACommentLine.SetRange("No.", "No.");
        SSACommentLine.SetRange("Document Line No.", "Document Line No.");
        SSACommentLine.SetRange(Date, WorkDate());
        if not SSACommentLine.FindFirst() then
            Date := WorkDate();
    end;

    procedure CopyComments(FromDocumentType: Integer; ToDocumentType: Integer; FromNumber: Code[20]; ToNumber: Code[20])
    var
        SSACommentLine: Record "SSA Comment Line";
        SSACommentLine2: Record "SSA Comment Line";
        IsHandled: Boolean;
    begin
        IsHandled := false;
        OnBeforeCopyComments(SSACommentLine, ToDocumentType, IsHandled);
        if IsHandled then
            exit;

        SSACommentLine.SetRange("Document Type", FromDocumentType);
        SSACommentLine.SetRange("No.", FromNumber);
        if SSACommentLine.FindSet() then
            repeat
                SSACommentLine2 := SSACommentLine;
                SSACommentLine2."Document Type" := ToDocumentType;
                SSACommentLine2."No." := ToNumber;
                SSACommentLine2.Insert();
            until SSACommentLine.Next() = 0;
    end;

    procedure DeleteComments(DocType: Option; DocNo: Code[20])
    begin
        SetRange("Document Type", DocType);
        SetRange("No.", DocNo);
        if not IsEmpty then
            DeleteAll();
    end;

    procedure ShowComments(DocType: Option; DocNo: Code[20]; DocLineNo: Integer)
    var
        SSACommentSheet: Page "SSA Comment Sheet";
    begin
        SetRange("Document Type", DocType);
        SetRange("No.", DocNo);
        SetRange("Document Line No.", DocLineNo);
        Clear(SSACommentSheet);
        SSACommentSheet.SetTableView(Rec);
        SSACommentSheet.RunModal();
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeCopyComments(var SSACommentLine: Record "SSA Comment Line"; ToDocumentType: Integer; var IsHandled: Boolean)
    begin
    end;
}
