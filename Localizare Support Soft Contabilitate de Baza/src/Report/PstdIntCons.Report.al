report 70004 "SSA Pstd Int. Cons."
{
    DefaultLayout = RDLC;
    RDLCLayout = './src/rdlc/SSAPstdIntCons.rdlc';
    Caption = 'Posted Internal Consumption';

    dataset
    {
        dataitem("SSA Pstd. Int. Cons. Header"; "SSA Pstd. Int. Cons. Header")
        {
            DataItemTableView = sorting("No.");
            RequestFilterFields = "No.";
            column(CompanyName; CompanyName)
            {
            }
            column(FORMAT_TODAY_0_4_; Format(Today, 0, 4))
            {
            }
            column(USERID; UserId)
            {
            }
            column(Text000; Text000)
            {
            }
            column(Posted_Int__Consumption_Header__Location_Code_; "Location Code")
            {
            }
            column(Posted_Int__Consumption_Header__No__; "No.")
            {
            }
            column(Posted_Int__Consumption_Header__Posting_Date_; "Posting Date")
            {
            }
            column(Posted_Int__Consumption_Header__Your_Reference_; "Your Reference")
            {
            }
            column(Posted_Internal_ConsumptionCaption; Posted_Internal_ConsumptionCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Document_No_Caption; Document_No_CaptionLbl)
            {
            }
            column(Issue_DateCaption; Issue_DateCaptionLbl)
            {
            }
            column(Location_CodeCaption; Location_CodeCaptionLbl)
            {
            }
            column(Internal_Consumption_Description_Caption; Internal_Consumption_Description_CaptionLbl)
            {
            }
            column(ReportFilters; ReportFilters)
            {
            }
            column(PageCaptionLbl; PageCaptionLbl)
            {
            }
            column(Text001; Text001)
            {
            }
            column(MadeByCaption; MadebyCaption)
            {
            }
            dataitem("SSAPstd. Int. Consumption Line"; "SSAPstd. Int. Consumption Line")
            {
                DataItemLink = "Document No." = field("No.");
                DataItemTableView = sorting("Document No.", "Line No.") order(ascending);
                column(Posted_Int__Consumption_Line_Quantity; Quantity)
                {
                }
                column(Posted_Int__Consumption_Line__Unit_of_Measure_Code_; "Unit of Measure Code")
                {
                }
                column(Posted_Int__Consumption_Line__Unit_Cost__LCY__; "Unit Cost (LCY)")
                {
                }
                column(Unit_Cost__LCY_____Quantity; "Unit Cost (LCY)" * Quantity)
                {
                }
                column(Posted_Int__Consumption_Line__No__; "Line No.")
                {
                }
                column(Posted_Int__Consumption_Line_Description; Description)
                {
                }
                column(Posted_Int__Consumption_Line__Gen__Prod__Posting_Group_; "Gen. Prod. Posting Group")
                {
                }
                column(CreditAccount; CreditAccount)
                {
                }
                column(DescriptionCaption; DescriptionCaptionLbl)
                {
                }
                column(Item_No_Caption; Item_No_CaptionLbl)
                {
                }
                column(UMCaption; UMCaptionLbl)
                {
                }
                column(QuantityCaption; QuantityCaptionLbl)
                {
                }
                column(Unit_CostCaption; Unit_CostCaptionLbl)
                {
                }
                column(AmountCaption; AmountCaptionLbl)
                {
                }
                column(Gen__Prod__Posting_GroupCaption; Gen__Prod__Posting_GroupCaptionLbl)
                {
                }
                column(Credit_AccountCaption; Credit_AccountCaptionLbl)
                {
                }
                column(Necessary_QuantityCaption; Necessary_QuantityCaptionLbl)
                {
                }
                column(Date_and_SignatureCaption; Date_and_SignatureCaptionLbl)
                {
                }
                column(Chef_of_DepartmentCaption; Chef_of_DepartmentCaptionLbl)
                {
                }
                column(AdministratorCaption; AdministratorCaptionLbl)
                {
                }
                column(ReceiverCaption; ReceiverCaptionLbl)
                {
                }
                column(Date_and_SignatureCaption_Control1390013; Date_and_SignatureCaption_Control1390013Lbl)
                {
                }
                column(Chef_of_DepartmentCaption_Control1390014; Chef_of_DepartmentCaption_Control1390014Lbl)
                {
                }
                column(AdministratorCaption_Control1390015; AdministratorCaption_Control1390015Lbl)
                {
                }
                column(ReceiverCaption_Control1390016; ReceiverCaption_Control1390016Lbl)
                {
                }
                column(Posted_Int__Consumption_Line_Document_No_; "Document No.")
                {
                }
                column(Posted_Int__Consumption_Line_Line_No_; "Line No.")
                {
                }

                trigger OnAfterGetRecord()
                begin
                    InventoryPostingSetup.SetFilter(InventoryPostingSetup."Location Code", '=%1', "SSAPstd. Int. Consumption Line"."Location Code");
                    InventoryPostingSetup.SetFilter(InventoryPostingSetup."Invt. Posting Group Code", '=%1', "SSAPstd. Int. Consumption Line"."Gen. Prod. Posting Group");
                    if InventoryPostingSetup.FindFirst then
                        CreditAccount := InventoryPostingSetup."Inventory Account";
                end;
            }
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
        if not CurrReport.UseRequestPage then;

        ReportFilters := "SSA Pstd. Int. Cons. Header".GETFILTERS + ' ' + "SSAPstd. Int. Consumption Line".GETFILTERS;
    end;

    var
        Text000: Label 'Internal Consumption Document';
        CreditAccount: Code[10];
        InventoryPostingSetup: Record "Inventory Posting Setup";
        Posted_Internal_ConsumptionCaptionLbl: Label 'Posted Internal Consumption';
        CurrReport_PAGENOCaptionLbl: Label 'Page';
        Document_No_CaptionLbl: Label 'Document No.';
        Issue_DateCaptionLbl: Label 'Issue Date';
        Location_CodeCaptionLbl: Label 'Location Code';
        Internal_Consumption_Description_CaptionLbl: Label 'Internal Consumption Description:';
        DescriptionCaptionLbl: Label 'Description';
        Item_No_CaptionLbl: Label 'Item No.';
        UMCaptionLbl: Label 'UM';
        QuantityCaptionLbl: Label 'Quantity';
        Unit_CostCaptionLbl: Label 'Unit Cost';
        AmountCaptionLbl: Label 'Amount';
        Gen__Prod__Posting_GroupCaptionLbl: Label 'Gen. Prod. Posting Group';
        Credit_AccountCaptionLbl: Label 'Credit Account';
        Necessary_QuantityCaptionLbl: Label 'Necessary Quantity';
        Date_and_SignatureCaptionLbl: Label 'Date and Signature';
        Chef_of_DepartmentCaptionLbl: Label 'Chef of Department';
        AdministratorCaptionLbl: Label 'Administrator';
        ReceiverCaptionLbl: Label 'Receiver';
        Date_and_SignatureCaption_Control1390013Lbl: Label 'Date and Signature';
        Chef_of_DepartmentCaption_Control1390014Lbl: Label 'Chef of Department';
        AdministratorCaption_Control1390015Lbl: Label 'Administrator';
        ReceiverCaption_Control1390016Lbl: Label 'Receiver';
        ReportFilters: Text[250];
        PageCaptionLbl: Label 'Page';
        MadebyCaption: Label 'Made by';
        Text001: Label 'Head of Financial Accounting Department';
}

