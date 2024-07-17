report 70006 "SSA Invt. Shipment Int. Cons."
{
    Caption = 'Posted Inventory Movement';
    ApplicationArea = All;
    DefaultRenderingLayout = RDLCLandscape;
    dataset
    {
        dataitem(InvtShipmentHeader; "Invt. Shipment Header")
        {
            DataItemTableView = sorting("No.");
            RequestFilterFields = "No.";
            column(No_InvtShipmentHeader; InvtShipmentHeader."No.")
            {
            }
            dataitem(CopyLoop; "Integer")
            {
                DataItemTableView = sorting(Number);
                dataitem(PageLoop; "Integer")
                {
                    DataItemTableView = sorting(Number) where(Number = const(1));
                    column(PageCaptionCap; PageCaptionCap)
                    {
                    }
                    column(ReportNameCpt; ReportNameCpt)
                    {
                    }
                    column(NoCpt; NoCpt)
                    {
                    }
                    column(DateCpt; DateCpt)
                    {
                    }
                    column(CompanyInfoPicture; CompanyInfo.Picture)
                    {
                    }
                    column(CompanyAddr1; CompanyAddr[1])
                    {
                    }
                    column(CompanyAddr2; CompanyAddr[2])
                    {
                    }
                    column(CompanyAddr3; CompanyAddr[3])
                    {
                    }
                    column(CompanyAddr4; CompanyAddr[4])
                    {
                    }
                    column(CompanyAddr5; CompanyAddr[5])
                    {
                    }
                    column(CompanyAddr6; CompanyAddr[6])
                    {
                    }
                    column(CompanyInfoVATRegNo; CompanyInfo."VAT Registration No.")
                    {
                    }
                    column(OutputNo; OutputNo)
                    {
                    }
                    column(PostingDate_InvtShipmentHeader; Format(InvtShipmentHeader."Posting Date", 0, '<Day,2>.<Month,2>.<Year4>'))
                    {
                    }
                    column(CompanyName; CompanyName)
                    {
                    }
                    column(PageCaptionLbl; PageCaptionLbl)
                    {
                    }
                    column(Invt__Shipment_HeaderCaption; Posted_Internal_ConsumptionCaptionLbl)
                    {
                    }
                    column(LocationCode_InvtShipmentHeader; InvtShipmentHeader."Location Code")
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
                    column(MadebyCaption; MadebyCaption)
                    {
                    }
                    column(Text001; Text001)
                    {
                    }
                    column(Location_CodeCaption; Location_CodeCaptionLbl)
                    {
                    }
                    column(ReportFilters; ReportFilters)
                    {
                    }
                    dataitem(InvtShipmentLine; "Invt. Shipment Line")
                    {
                        DataItemLink = "Document No." = field("No.");
                        DataItemLinkReference = InvtShipmentHeader;
                        DataItemTableView = sorting("Document No.", "Line No.");
                        column(NrCrtCpt; NrCrtCpt)
                        {
                        }
                        column(UnitCostCpt; UnitCostCpt)
                        {
                        }
                        column(CostAmountCpt; CostAmountCpt)
                        {
                        }
                        column(NrCrt; NrCrt)
                        {
                        }
                        column(ItemNo_InvtShipmentLine; InvtShipmentLine."Item No.")
                        {
                            IncludeCaption = true;
                        }
                        column(LocationCode_InvtShipmentLine; InvtShipmentLine."Location Code")
                        {
                            IncludeCaption = true;
                        }
                        column(Description_InvtShipmentLine; InvtShipmentLine.Description)
                        {
                            IncludeCaption = true;
                        }
                        column(Quantity_InvtShipmentLine; InvtShipmentLine.Quantity)
                        {
                            IncludeCaption = true;
                        }
                        column(UnitofMeasure_InvtShipmentLine; InvtShipmentLine."Unit of Measure Code")
                        {
                            IncludeCaption = true;
                        }
                        column(UnitCost; UnitCost)
                        {
                        }
                        column(CostAmount; CostAmount)
                        {
                        }

                        column(CreditAccount; CreditAccount)
                        {
                        }
                        column(Gen__Prod__Posting_Group; "Gen. Prod. Posting Group")
                        {

                        }

                        trigger OnAfterGetRecord()
                        begin
                            NrCrt += 1;

                            InventoryPostingSetup.Get("Location Code", "Gen. Prod. Posting Group");
                            CreditAccount := InventoryPostingSetup."Inventory Account";

                            ItemLegdEntry.SetRange("Document No.", InvtShipmentLine."Document No.");
                            ItemLegdEntry.SetRange("Document Type", ItemLegdEntry."Document Type"::"Inventory Shipment");
                            ItemLegdEntry.SetRange("Document Line No.", InvtShipmentLine."Line No.");
                            if ItemLegdEntry.FindFirst() then begin
                                ItemLegdEntry.CalcFields("Cost Amount (Actual)");
                                CostAmount := ItemLegdEntry."Cost Amount (Actual)";
                            end else
                                Clear(CostAmount);
                            if CostAmount < 0 then
                                CostAmount := -CostAmount;

                            if Quantity <> 0 then
                                UnitCost := CostAmount / Quantity
                            else
                                UnitCost := CostAmount;
                        end;

                        trigger OnPreDataItem()
                        begin
                            Clear(NrCrt);
                        end;
                    }
                }

                trigger OnAfterGetRecord()
                begin
                    if Number > 1 then begin
                        CopyText := FormatDocument.GetCOPYText();
                        OutputNo += 1;
                    end;
                end;

                trigger OnPostDataItem()
                begin
                    if not IsReportInPreviewMode() then
                        Codeunit.Run(Codeunit::"SSA Invt. Shpt. Header-Printed", InvtShipmentHeader);
                end;

                trigger OnPreDataItem()
                begin
                    NoOfLoops := Abs(NoOfCopies) + 1;
                    if NoOfLoops <= 0 then
                        NoOfLoops := 1;
                    CopyText := '';
                    SetRange(Number, 1, NoOfLoops);
                    OutputNo := 1;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                FormatAddress.GetCompanyAddr('', ResponsibilityCenter, CompanyInfo, CompanyAddr);

                if not Location.Get("Location Code") then
                    Clear(Location);
            end;
        }
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(NoOfCopies; NoOfCopies)
                    {
                        ApplicationArea = All;
                        Caption = 'No. of Copies';
                        ToolTip = 'Specifies how many copies of the document to print.';
                    }
                }
            }
        }
    }
    rendering
    {
        layout(RDLCPortrait)
        {
            Type = RDLC;
            LayoutFile = './src/rdlc/InvtShipmentIntConsPortrait.rdlc';
        }
        layout(RDLCLandscape)
        {
            Type = RDLC;
            LayoutFile = './src/rdlc/InvtShipmentIntConsLandscape.rdlc';
        }

    }

    labels
    {
    }

    trigger OnPreReport()
    begin
        CompanyInfo.Get();
        CompanyInfo.CalcFields(Picture);

        ItemLegdEntry.Reset();
        ItemLegdEntry.SetCurrentKey("Document No.", "Document Type", "Document Line No.");

        ReportFilters := InvtShipmentHeader.GetFilters + ' ' + InvtShipmentLine.GetFilters;
    end;

    var
        CompanyInfo: Record "Company Information";
        Location: Record Location;
        InventoryPostingSetup: Record "Inventory Posting Setup";
        ItemLegdEntry: Record "Item Ledger Entry";
        ResponsibilityCenter: Record "Responsibility Center";
        FormatAddress: Codeunit "Format Address";
        FormatDocument: Codeunit "Format Document";
        NrCrt: Integer;
        NoOfLoops: Integer;
        OutputNo: Integer;
        NoOfCopies: Integer;
        CostAmount: Decimal;
        UnitCost: Decimal;
        ReportFilters: Text;
        CreditAccount: Code[20];
        CompanyAddr: array[8] of Text;
        CopyText: Text;
        PageCaptionCap: Label 'Page %1 of %2';
        ReportNameCpt: Label 'Internal Consumption';
        NoCpt: Label 'No.';
        DateCpt: Label 'Date:';
        NrCrtCpt: Label 'Curr. No.';
        CostAmountCpt: Label 'Cost Amount';
        UnitCostCpt: Label 'Unit Cost';
        PageCaptionLbl: Label 'Page';
        Posted_Internal_ConsumptionCaptionLbl: Label 'Posted Internal Consumption';
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
        AdministratorCaption_Control1390015Lbl: Label 'AdministratorId';
        ReceiverCaption_Control1390016Lbl: Label 'Receiver';
        MadebyCaption: Label 'Made by';
        Text001: Label 'Head of Financial Accounting Department';
        Location_CodeCaptionLbl: Label 'Location Code';

    local procedure IsReportInPreviewMode(): Boolean
    var
        MailManagement: Codeunit "Mail Management";
    begin
        exit(CurrReport.Preview or MailManagement.IsHandlingGetEmailBody());
    end;
}
