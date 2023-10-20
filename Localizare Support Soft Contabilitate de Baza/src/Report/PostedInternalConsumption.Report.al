report 70000 "SSAPosted Internal Consumption"
{
    // SSA937 SSCAT 16.06.2019 3.Funct. Bonuri de consum-consum intern
    DefaultLayout = RDLC;
    RDLCLayout = './src/rdlc/SSAPostedInternalConsumption.rdlc';
    Caption = 'Posted Internal Consumption';
    ApplicationArea = All;

    dataset
    {
        dataitem(PstdIntConsHeader; "SSA Pstd. Int. Cons. Header")
        {
            DataItemTableView = sorting("No.");
            RequestFilterFields = "No.";
            column(No_PstdIntConsHeader; PstdIntConsHeader."No.")
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
                    column(PostingDate_PstdIntConsHeader; Format(PstdIntConsHeader."Posting Date", 0, '<Day,2>.<Month,2>.<Year4>'))
                    {
                    }
                    dataitem(PstdIntConsumptionLine; "SSAPstd. Int. Consumption Line")
                    {
                        DataItemLink = "Document No." = field("No.");
                        DataItemLinkReference = PstdIntConsHeader;
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
                        column(ItemNo_PstdIntConsumptionLine; PstdIntConsumptionLine."Item No.")
                        {
                            IncludeCaption = true;
                        }
                        column(LocationCode_PstdIntConsumptionLine; PstdIntConsumptionLine."Location Code")
                        {
                            IncludeCaption = true;
                        }
                        column(Description_PstdIntConsumptionLine; PstdIntConsumptionLine.Description)
                        {
                            IncludeCaption = true;
                        }
                        column(Quantity_PstdIntConsumptionLine; PstdIntConsumptionLine.Quantity)
                        {
                            IncludeCaption = true;
                        }
                        column(UnitofMeasure_PstdIntConsumptionLine; PstdIntConsumptionLine."Unit of Measure")
                        {
                            IncludeCaption = true;
                        }
                        column(UnitCost; UnitCost)
                        {
                        }
                        column(CostAmount; CostAmount)
                        {
                        }

                        trigger OnAfterGetRecord()
                        begin
                            NrCrt += 1;

                            InventoryPostingSetup.Get("Location Code", "Gen. Prod. Posting Group");
                            CreditAccount := InventoryPostingSetup."Inventory Account";

                            ILE.Get("Item Shpt. Entry No.");
                            ILE.CalcFields("Cost Amount (Actual)");
                            CostAmount := ILE."Cost Amount (Actual)";
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
                        Codeunit.Run(Codeunit::"SSA Int. Consumption-Printed", PstdIntConsHeader);
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
                FormatAddress.GetCompanyAddr(PstdIntConsHeader."Responsibility Center", ResponsibilityCenter, CompanyInfo, CompanyAddr);

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

    labels
    {
    }

    trigger OnPreReport()
    begin
        CompanyInfo.Get();
        CompanyInfo.CalcFields(Picture);
    end;

    var
        CompanyInfo: Record "Company Information";
        Location: Record Location;
        InventoryPostingSetup: Record "Inventory Posting Setup";
        ILE: Record "Item Ledger Entry";
        ResponsibilityCenter: Record "Responsibility Center";
        FormatAddress: Codeunit "Format Address";
        FormatDocument: Codeunit "Format Document";
        NrCrt: Integer;
        NoOfLoops: Integer;
        OutputNo: Integer;
        NoOfCopies: Integer;
        CostAmount: Decimal;
        UnitCost: Decimal;
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

    local procedure IsReportInPreviewMode(): Boolean
    var
        MailManagement: Codeunit "Mail Management";
    begin
        exit(CurrReport.Preview or MailManagement.IsHandlingGetEmailBody());
    end;
}
