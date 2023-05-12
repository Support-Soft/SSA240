report 70501 "SSA Duplicate parameter"
{

    Caption = 'Duplicate parameter';
    ProcessingOnly = true;

    dataset
    {
        dataitem(PaymentClass; "SSA Payment Class")
        {
            DataItemTableView = SORTING(Code);

            trigger OnAfterGetRecord()
            var
                PaymtClass: Record "SSA Payment Class";
            begin
                PaymtClass.COPY(PaymentClass);
                PaymtClass.Name := '';
                PaymtClass.VALIDATE(Code, NewName);
                PaymtClass.INSERT;
            end;

            trigger OnPreDataItem()
            begin
                VerifyNewName;
            end;
        }
        dataitem("Payment Status"; "SSA Payment Status")
        {
            DataItemTableView = SORTING("Payment Class", Line);

            trigger OnAfterGetRecord()
            var
                PaymtStatus: Record "SSA Payment Status";
            begin
                PaymtStatus.COPY("Payment Status");
                PaymtStatus.VALIDATE("Payment Class", NewName);
                PaymtStatus.INSERT;
            end;

            trigger OnPreDataItem()
            begin
                SETRANGE("Payment Class", PaymentClass.Code);
            end;
        }
        dataitem("Payment Step"; "SSA Payment Step")
        {
            DataItemTableView = SORTING("Payment Class", Line);

            trigger OnAfterGetRecord()
            var
                PaymtStep: Record "SSA Payment Step";
            begin
                PaymtStep.COPY("Payment Step");
                PaymtStep.VALIDATE("Payment Class", NewName);
                PaymtStep.INSERT;
            end;

            trigger OnPreDataItem()
            begin
                SETRANGE("Payment Class", PaymentClass.Code);
            end;
        }
        dataitem("Payment Step Ledger"; "SSA Payment Step Ledger")
        {
            DataItemTableView = SORTING("Payment Class", Line, Sign);

            trigger OnAfterGetRecord()
            var
                PaymtStepLedger: Record "SSA Payment Step Ledger";
            begin
                PaymtStepLedger.COPY("Payment Step Ledger");
                PaymtStepLedger.VALIDATE("Payment Class", NewName);
                PaymtStepLedger.INSERT;
            end;

            trigger OnPreDataItem()
            begin
                SETRANGE("Payment Class", PaymentClass.Code);
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field("Ce nume atribuiţi noului parametru?"; '')
                {
                    ApplicationArea = All;
                }
                field("Numele vechi"; OldName)
                {
                    Caption = 'Old name';
                    Editable = false;
                }
                field("Numele nou"; NewName)
                {
                    Caption = 'New name';
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    var
        OldName: Text[30];
        NewName: Text[30];
        Text19061124: Label 'Which name do you want to attribute to the new parameter?';
        Text19034794: Label 'Old name :';
        Text19058282: Label 'New name :';

    procedure InitParameter("Code": Text[30])
    begin
        OldName := Code;
    end;

    procedure VerifyNewName()
    var
        PaymtClass: Record "SSA Payment Class";
        Text000: Label 'You must precise a new name.';
        Text001: Label 'The name you have put (';
        Text002: Label ') does already exist. Please put another name.';
    begin
        IF NewName = '' THEN
            ERROR(Text000);
        IF PaymtClass.GET(NewName) THEN
            ERROR(Text001 + NewName + Text002);
    end;
}
