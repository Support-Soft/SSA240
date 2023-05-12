report 71304 "SSA FA Phys. Inventory List"
{
    // SSA1007 SSCAT 14.10.2019 74.Rapoarte legale-lista inventar fizic MF
    DefaultLayout = RDLC;
    RDLCLayout = './src/rdlc/SSAFAPhysInventoryList.rdlc';
    Caption = 'FA Phys. Inventory List';
    UsageCategory = ReportsAndAnalysis;
    dataset
    {
        dataitem("Fixed Asset"; "Fixed Asset")
        {
            DataItemTableView = SORTING("No.");
            RequestFilterFields = "No.";
            column(COMPANYNAME; CompInfo.Name)
            {
            }
            column(CompInfo_Address; CompInfo.Address + ' ' + CompInfo."Address 2")
            {
            }
            column(CompInfo_VAT_Registration_No_; CompInfo."VAT Registration No.")
            {
            }
            column(CompInfo_Registration_No_; CompInfo."Registration No.")
            {
            }
            column(CompInfo_Commerce_Trade_No_; CompInfo."SSA Commerce Trade No.")
            {
            }
            column(No_FA; "Fixed Asset"."No.")
            {
                IncludeCaption = true;
            }
            column(Description_FA; "Fixed Asset".Description)
            {
                IncludeCaption = true;
            }
            column(Description2_FA; "Fixed Asset"."Description 2")
            {
                IncludeCaption = true;
            }
            column(FAClassCode_FA; "Fixed Asset"."FA Class Code")
            {
                IncludeCaption = true;
            }
            column(FASubclassCode_FA; "Fixed Asset"."FA Subclass Code")
            {
                IncludeCaption = true;
            }
            column(FALocationCode_FA; "Fixed Asset"."FA Location Code")
            {
                IncludeCaption = true;
            }
            column(MainAssetComponent_FA; "Fixed Asset"."Main Asset/Component")
            {
                IncludeCaption = true;
            }
            column(ResponsibleEmployee_FA; "Fixed Asset"."Responsible Employee")
            {
                IncludeCaption = true;
            }
            column(SerialNo_FA; "Fixed Asset"."Serial No.")
            {
                IncludeCaption = true;
            }
            column(LineNo; LineNo)
            {
            }
            column(Qty; Qty)
            {
            }
            column(AcquisitionCost_FADB; FADeprBook."Acquisition Cost")
            {
                IncludeCaption = true;
            }
            column(Depreciation_FADB; FADeprBook.Depreciation)
            {
                IncludeCaption = true;
            }
            column(BookValue_FADB; FADeprBook."Book Value")
            {
                IncludeCaption = true;
            }
            column(GetGroupHeader; GetGroupHeader)
            {
            }
            column(GetGroupFooter; GetGroupFooter)
            {
            }
            column(Member_1_; Member[1])
            {
            }
            column(Member_2_; Member[2])
            {
            }
            column(Member_3_; Member[3])
            {
            }
            column(FA_GETFILTERS; "Fixed Asset".GetFilters)
            {
            }
            column(PrintFAValues; PrintFAValues)
            {
            }
            column(ReportFilters; ReportFilters)
            {
            }
            column(GroupByNo; GroupByNo)
            {
            }
            column(Format_DocumentDate; Format(DocumentDate))
            {
            }
            column(Format_TODAY; Format(Today))
            {
            }
            column(DocumentNo; DocumentNo)
            {
            }

            trigger OnAfterGetRecord()
            begin
                if not FADeprBook.Get("No.", DeprBookCode) then
                    CurrReport.Skip;
                FADeprBook.SetRange("FA Posting Date Filter", 0D, DocumentDate);
                FADeprBook.CalcFields("Acquisition Cost", Depreciation, "Book Value");
                if (FADeprBook."Disposal Date" > 0D) and (FADeprBook."Disposal Date" < DocumentDate) then CurrReport.Skip;
                if (FADeprBook."Book Value" = 0) and (not PrintZeroBookValue) then
                    CurrReport.Skip;

                Qty := 1;
                LineNo := LineNo + 1;
            end;

            trigger OnPreDataItem()
            begin
                Qty := 0;
                LineNo := 0;
                case GroupBy of
                    GroupBy::"FA Location Code Only",
                  GroupBy::"FA Location and Responsible":
                        SetCurrentKey("FA Location Code", "Responsible Employee");
                    GroupBy::"Responsible Employee Only",
                  GroupBy::"Responsible and Location":
                        SetCurrentKey("Responsible Employee", "FA Location Code");
                end;
            end;
        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(DeprBookCode; DeprBookCode)
                    {
                        Caption = 'Depreciation Book';
                        TableRelation = "Depreciation Book";
                    }
                    field(DocumentNo; DocumentNo)
                    {
                        Caption = 'Document No.';
                    }
                    field(DocumentDate; DocumentDate)
                    {
                        Caption = 'Document Date';
                    }
                    field(PrintFAValues; PrintFAValues)
                    {
                        Caption = 'Print FA Values';
                    }
                    field(PrintZeroBookValue; PrintZeroBookValue)
                    {
                        Caption = 'Print FA with Zero Book Value';
                    }
                    field(GroupBy; GroupBy)
                    {
                        Caption = 'Group By';
                        OptionCaption = 'None,FA Location Code Only,Responsible Employee Only,FA Location and Responsible,Responsible and Location';
                    }
                    field("Member[1]"; Member[1])
                    {
                        Caption = '1. Persona';
                    }
                    field("Member[2]"; Member[2])
                    {
                        Caption = '2. Persona';
                    }
                    field("Member[3]"; Member[3])
                    {
                        Caption = '3. Persona';
                    }
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
        lbl_CommitteeMembers = 'Committee members:';
        lbl_1 = '1';
        lbl_2 = '2';
        lbl_3 = '3';
        lbl_StartingDate = 'Stocktaking begin date/ time';
        lbl_EndingDate = 'Stocktaking end date/ time';
        lbl_Approved = 'Approved by committee members:';
        lbl_Signature = 'Date, Signature';
        lbl_Total = 'Total (Quantity, Amount):';
        lbl_LineNo = 'Line No.';
        lbl_Qty = 'QTY Calc.';
        lbl_Qty_stock = 'QTY Inv.';
        lbl_Page = 'Page:';
        lbl_FA1_No = 'FA No.';
        lbl_FA1_Description = 'FA Description';
        lbl_FA1_Serial_No = 'Serial No.';
        lbl_FA1_Acquisition_Cost = 'Acquisition Cost';
        lbl_FA1_Depreciation = 'Depreciation';
        lbl_FA1_Book_Value = 'Book Value';
        lbl_No = 'No.';
        lbl_Description = 'Description';
        lbl_FA_Class_Code = 'FA Class Code';
        lbl_FA_Subclass_Code = 'FA Subclass Code';
        lbl_FA_Location_Code = 'FA Location Code';
        lbl_Main_Asset_Component = 'Main Asset/Component';
        lbl_Responislbe_Employee = 'Responsible Employee';
        lbl_Serial_No = 'Serial No.';
        lbl_Quantity = 'Quantity';
        lbl_ReportTitle = 'LIST OF INVENTORY FIXED ASSETS';
        lbl_ReportDate = 'On';
        lbl_Company = 'Company:';
        lbl_CommTradeNo = 'Commerce Trade No.:';
        lbl_Address = 'Adress:';
        lbl_ReportDate1 = 'Report date:';
        lbl_User = 'User:';
        lbl_VATReg = 'VAT Registration No.:';
        lbl_DocumentNo = 'Document No.:';
    }

    trigger OnPreReport()
    begin
        if DocumentDate = 0D then
            Error(Text26504);

        if CompInfo.Get then;
        if DeprBookCode = '' then
            Error(Text26502);

        if DocumentNo <> '' then
            HeaderText := Text26501 + ' ' + DocumentNo
        else
            HeaderText := Text26500;

        ReportFilters := "Fixed Asset".GetFilters;
        GroupByNo := GroupBy;
    end;

    var
        Text26500: Label 'Phys. Fixed Assets List';
        Text26501: Label 'FIXED ASSET PHYSICAL INVENTORY DOCUMENT No.';
        Text26502: Label 'Depreciation Book Code must not be empty.';
        Text26503: Label 'Totals for';
        FASetup: Record "FA Setup";
        FADeprBook: Record "FA Depreciation Book";
        PrintFAValues: Boolean;
        DocumentNo: Code[10];
        LineNo: Integer;
        Qty: Decimal;
        HeaderText: Text[60];
        DeprBookCode: Code[10];
        GroupBy: Option "None","FA Location Code Only","Responsible Employee Only","FA Location and Responsible","Responsible and Location";
        ChangePage: Boolean;
        Member: array[3] of Text[100];
        DocumentDate: Date;
        PrintZeroBookValue: Boolean;
        CompInfo: Record "Company Information";
        ReportFilters: Text[250];
        GroupByNo: Integer;
        Text26504: Label 'You must fill in the Document Date.';

    [Scope('Internal')]
    procedure GetGroupHeader(): Text[100]
    begin
        case GroupBy of
            GroupBy::"FA Location Code Only":
                exit(
                  StrSubstNo('%1: %2',
                    "Fixed Asset".FieldCaption("FA Location Code"), "Fixed Asset"."FA Location Code"));
            GroupBy::"Responsible Employee Only":
                exit(
                  StrSubstNo('%1: %2',
                    "Fixed Asset".FieldCaption("Responsible Employee"), "Fixed Asset"."Responsible Employee"));
            GroupBy::"FA Location and Responsible":
                exit(
                  StrSubstNo('%1: %2, %3: %4',
                    "Fixed Asset".FieldCaption("FA Location Code"), "Fixed Asset"."FA Location Code",
                    "Fixed Asset".FieldCaption("Responsible Employee"), "Fixed Asset"."Responsible Employee"));
            GroupBy::"Responsible and Location":
                exit(
                  StrSubstNo('%1: %2, %3: %4',
                    "Fixed Asset".FieldCaption("Responsible Employee"), "Fixed Asset"."Responsible Employee",
                    "Fixed Asset".FieldCaption("FA Location Code"), "Fixed Asset"."FA Location Code"));
            else
                exit('');
        end;
    end;

    [Scope('Internal')]
    procedure GetGroupFooter(): Text[100]
    begin
        case GroupBy of
            GroupBy::"FA Location Code Only":
                exit(
                  StrSubstNo('%1 %2: %3',
                    Text26503,
                    "Fixed Asset".FieldCaption("FA Location Code"), "Fixed Asset"."FA Location Code"));
            GroupBy::"Responsible Employee Only":
                exit(
                  StrSubstNo('%1 %2: %3',
                    Text26503,
                    "Fixed Asset".FieldCaption("Responsible Employee"), "Fixed Asset"."Responsible Employee"));
            GroupBy::"FA Location and Responsible":
                exit(
                  StrSubstNo('%1 %2: %3, %4: %5',
                    Text26503,
                    "Fixed Asset".FieldCaption("FA Location Code"), "Fixed Asset"."FA Location Code",
                    "Fixed Asset".FieldCaption("Responsible Employee"), "Fixed Asset"."Responsible Employee"));
            GroupBy::"Responsible and Location":
                exit(
                  StrSubstNo('%1 %2: %3, %4: %5',
                    Text26503,
                    "Fixed Asset".FieldCaption("Responsible Employee"), "Fixed Asset"."Responsible Employee",
                    "Fixed Asset".FieldCaption("FA Location Code"), "Fixed Asset"."FA Location Code"));
            else
                exit('');
        end;
    end;
}

