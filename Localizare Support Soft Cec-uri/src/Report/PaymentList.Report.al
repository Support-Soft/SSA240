report 70500 "SSA Payment List"
{
    DefaultLayout = RDLC;
    RDLCLayout = './src/rdlc/Payment List.rdlc';
    Caption = 'Payments lists';

    dataset
    {
        dataitem("Payment Line"; "SSA Payment Line")
        {
            DataItemTableView = sorting("Account Type", "Account No.", "Copied To Line", "Payment in progress");
            RequestFilterFields = "No.", "Payment Class", "Status No.";
            column(Titlu; Titlu)
            {
            }
            column(NrCaption; NrCaption)
            {
            }
            column(SumaCaption; SumaCaption)
            {
            }
            column(TipContCaption; TipContCaption)
            {
            }
            column(NrContCaption; NrContCaption)
            {
            }
            column(NumeContCaption; NumeContCaption)
            {
            }
            column(DueDateCaption; DueDateCaption)
            {
            }
            column(NumeStareCaption; NumeStareCaption)
            {
            }
            column(ExtDocCaption; ExtDocCaption)
            {
            }
            column(No_PaymentLine; "Payment Line"."No.")
            {
            }
            column(Amount_PaymentLine; "Payment Line".Amount)
            {
            }
            column(AccountType_PaymentLine; "Payment Line"."Account Type")
            {
            }
            column(AccountNo_PaymentLine; "Payment Line"."Account No.")
            {
            }
            column(DueDate_PaymentLine; DueDate)
            {
            }
            column(StatusName_PaymentLine; "Payment Line"."Status Name")
            {
            }
            column(ExternalDocumentNo_PaymentLine; "Payment Line"."External Document No.")
            {
            }
            column(AccName; AccName)
            {
            }
            column(LineNo; "Payment Line"."Line No.")
            {
            }
            column(CompName; CompanyInfo.Name)
            {
            }
            column(pagCaption; pagCaption)
            {
            }

            trigger OnAfterGetRecord()
            begin
                CLEAR(AccName);
                if "Payment Line"."Account Type" = "Payment Line"."Account Type"::Customer then begin
                    if Customer.GET("Payment Line"."Account No.") then
                        AccName := Customer.Name;
                end;
                if "Payment Line"."Account Type" = "Payment Line"."Account Type"::Vendor then begin
                    if Vendor.GET("Payment Line"."Account No.") then
                        AccName := Vendor.Name;
                end;

                DueDate := FORMAT("Payment Line"."Due Date");
            end;

            trigger OnPreDataItem()
            begin
                CurrReport.CREATETOTALS("Payment Line".Amount);
            end;
        }
    }

    requestpage
    {
        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnPreReport()
    begin
        CompanyInfo.GET;
    end;

    var
        Customer: Record Customer;
        Vendor: Record Vendor;
        AccName: Text[50];
        CompanyInfo: Record "Company Information";
        Titlu: Label 'Payments Lines';
        NrCaption: Label 'No.';
        SumaCaption: Label 'Amount';
        TipContCaption: Label 'Acount Type';
        NrContCaption: Label 'Account No.';
        NumeContCaption: Label 'Account Name';
        DueDateCaption: Label 'Due date';
        NumeStareCaption: Label 'Status name';
        ExtDocCaption: Label 'External document no.';
        TotalCaption: Label 'Total';
        pagCaption: Label 'Page';
        DueDate: Text;
}
