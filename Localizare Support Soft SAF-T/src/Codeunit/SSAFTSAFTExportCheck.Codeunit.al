codeunit 71907 "SSAFTSAFT Export Check"
{
    // SSM2101 SSCAT 04.01.2023 SAF-T


    trigger OnRun()
    begin
    end;

    var
        FieldValueIsNotSpecifiedErr: Label '%1 is not specified', Comment = '%1 = field caption';
        w: Dialog;
        RecNo: Integer;
        TotalRecNo: Integer;


    procedure RunCheck(var TempErrorMessage: Record "Error Message" temporary; SAFTExportHeader: Record "SSAFTSAFT Export Header")
    var
        CompanyInformation: Record "Company Information";
        Employee: Record Employee;
        SAFTMappingHelper: Codeunit "SSAFTSAFT Mapping Helper";
        SAFTExportMgt: Codeunit "SSAFTSAFT Export Mgt.";
    begin
        if GuiAllowed then begin
            w.Open('Verificare Date \\#1##########\\@2@@@@@@@@@@');
            Clear(RecNo);
            Clear(TotalRecNo);
            w.Update(1, '');
            w.Update(2, 0);
        end;
        SAFTExportHeader.TestField(SAFTExportHeader."Mapping Range Code");
        SAFTExportHeader.TestField(SAFTExportHeader."Starting Date");
        SAFTExportHeader.TestField(SAFTExportHeader."Ending Date");
        SAFTExportHeader.TestField(SAFTExportHeader."Header Comment SAFT Type");
        SAFTExportHeader.TestField(SAFTExportHeader."Tax Accounting Basis");
        SAFTMappingHelper.VerifyMappingIsDone(TempErrorMessage, SAFTExportHeader."Mapping Range Code");
        SAFTMappingHelper.VerifyMappingIsDoneUOM(TempErrorMessage, SAFTExportHeader."Mapping Range Code");
        SAFTMappingHelper.VerifyMappingIsDonePaymentMethod(TempErrorMessage, SAFTExportHeader."Mapping Range Code");
        CheckCustomers(TempErrorMessage, SAFTExportHeader);
        CheckVendors(TempErrorMessage, SAFTExportHeader);
        SAFTMappingHelper.VerifyDimensionsHaveAnalysisCode(TempErrorMessage);
        CheckItems(TempErrorMessage, SAFTExportHeader);
        CheckCurrencies(TempErrorMessage, SAFTExportHeader);
        SAFTExportMgt.CheckNoFilesInFolder(SAFTExportHeader, TempErrorMessage);
        CompanyInformation.Get;
        if CompanyInformation."SSAFTSAFT Contact No." = '' then
            TempErrorMessage.LogMessage(
              CompanyInformation, CompanyInformation.FieldNo("SSAFTSAFT Contact No."), TempErrorMessage."Message Type"::Error,
              StrSubstNo(FieldValueIsNotSpecifiedErr, CompanyInformation.FieldCaption("SSAFTSAFT Contact No."), CompanyInformation.Name))
        else begin
            Employee.Get(CompanyInformation."SSAFTSAFT Contact No.");
            if Employee."Phone No." = '' then
                TempErrorMessage.LogMessage(
                  Employee, Employee.FieldNo("Phone No."), TempErrorMessage."Message Type"::Error,
                  StrSubstNo(FieldValueIsNotSpecifiedErr, Employee.FieldCaption("Phone No."), Employee."No."));
        end;

        if GuiAllowed then
            w.Close;
    end;

    local procedure CheckCustomers(var TempErrorMessage: Record "Error Message" temporary; SAFTExportHeader: Record "SSAFTSAFT Export Header")
    var
        Customer: Record Customer;
        CustomerPostingGroup: Record "Customer Posting Group";
        CLE: Record "Cust. Ledger Entry";
        GenerateSAFTFile: Codeunit "SSAFTSAFT Generate File";
        OpeningDebitBalance: Decimal;
        OpeningCreditBalance: Decimal;
        ClosingDebitBalance: Decimal;
        ClosingCreditBalance: Decimal;
    begin
        Customer.Reset;
        if GuiAllowed then begin
            w.Update(1, 'Client');
            Clear(RecNo);
            TotalRecNo := Customer.Count;
        end;
        if Customer.FindSet then
            repeat
                Clear(OpeningDebitBalance);
                Clear(OpeningCreditBalance);
                Clear(ClosingDebitBalance);
                Clear(ClosingCreditBalance);
                Customer.SetRange("Date Filter", 0D, ClosingDate(SAFTExportHeader."Starting Date" - 1));
                Customer.CalcFields("Net Change (LCY)");
                if Customer."Net Change (LCY)" > 0 then
                    OpeningDebitBalance := Customer."Net Change (LCY)"
                else
                    OpeningCreditBalance := -Customer."Net Change (LCY)";
                Customer.SetRange("Date Filter", 0D, ClosingDate(SAFTExportHeader."Ending Date"));
                Customer.CalcFields("Net Change (LCY)");
                if Customer."Net Change (LCY)" > 0 then
                    ClosingDebitBalance := Customer."Net Change (LCY)"
                else
                    ClosingCreditBalance := -Customer."Net Change (LCY)";

                CLE.Reset;
                CLE.SetCurrentKey("Customer No.");
                CLE.SetRange("Customer No.", Customer."No.");
                CLE.SetRange("Posting Date", SAFTExportHeader."Starting Date", ClosingDate(SAFTExportHeader."Ending Date"));
                if (ClosingDebitBalance <> 0) or (ClosingCreditBalance <> 0) or (OpeningDebitBalance <> 0) or (OpeningCreditBalance <> 0) or
                    (not CLE.IsEmpty)
                then begin
                    if not CustomerPostingGroup.Get(Customer."Customer Posting Group") then
                        TempErrorMessage.LogMessage(
                          Customer, Customer.FieldNo("Customer Posting Group"), TempErrorMessage."Message Type"::Error,
                          StrSubstNo(FieldValueIsNotSpecifiedErr, Customer.FieldCaption("Customer Posting Group"), Customer."No."));

                    if Customer.City = '' then
                        TempErrorMessage.LogMessage(
                          Customer, Customer.FieldNo(City), TempErrorMessage."Message Type"::Error,
                          StrSubstNo(FieldValueIsNotSpecifiedErr, Customer.FieldCaption(City)));

                    if GenerateSAFTFile.GetCustomerRegistrationNumber(Customer) = '' then
                        TempErrorMessage.LogMessage(
                          Customer, Customer.FieldNo("VAT Registration No."), TempErrorMessage."Message Type"::Error,
                          StrSubstNo(FieldValueIsNotSpecifiedErr, Customer.FieldCaption("VAT Registration No."), Customer."No."));

                end;

                if GuiAllowed then begin
                    RecNo += 1;
                    w.Update(2, Round(RecNo / TotalRecNo * 10000, 1));
                end;
            until Customer.Next = 0;
    end;

    local procedure CheckVendors(var TempErrorMessage: Record "Error Message" temporary; SAFTExportHeader: Record "SSAFTSAFT Export Header")
    var
        Vendor: Record Vendor;
        GenerateSAFTFile: Codeunit "SSAFTSAFT Generate File";
        VendorPostingGroup: Record "Vendor Posting Group";
        VLE: Record "Vendor Ledger Entry";
        OpeningDebitBalance: Decimal;
        OpeningCreditBalance: Decimal;
        ClosingDebitBalance: Decimal;
        ClosingCreditBalance: Decimal;
    begin
        Vendor.Reset;
        if GuiAllowed then begin
            w.Update(1, 'Furnizor');
            Clear(RecNo);
            TotalRecNo := Vendor.Count;
        end;
        if Vendor.FindSet then
            repeat
                Clear(OpeningDebitBalance);
                Clear(OpeningCreditBalance);
                Clear(ClosingDebitBalance);
                Clear(ClosingCreditBalance);
                Vendor.SetRange("Date Filter", 0D, ClosingDate(SAFTExportHeader."Starting Date" - 1));
                Vendor.CalcFields("Net Change (LCY)");
                if Vendor."Net Change (LCY)" > 0 then
                    OpeningDebitBalance := Vendor."Net Change (LCY)"
                else
                    OpeningCreditBalance := -Vendor."Net Change (LCY)";
                Vendor.SetRange("Date Filter", 0D, ClosingDate(SAFTExportHeader."Ending Date"));
                Vendor.CalcFields("Net Change (LCY)");
                if Vendor."Net Change (LCY)" > 0 then
                    ClosingDebitBalance := Vendor."Net Change (LCY)"
                else
                    ClosingCreditBalance := -Vendor."Net Change (LCY)";

                VLE.Reset;
                VLE.SetCurrentKey("Vendor No.");
                VLE.SetRange("Vendor No.", Vendor."No.");
                VLE.SetRange("Posting Date", SAFTExportHeader."Starting Date", ClosingDate(SAFTExportHeader."Ending Date"));
                if (ClosingDebitBalance <> 0) or (ClosingCreditBalance <> 0) or (OpeningDebitBalance <> 0) or (OpeningCreditBalance <> 0) or
                  (not VLE.IsEmpty)
                then begin
                    if not VendorPostingGroup.Get(Vendor."Vendor Posting Group") then
                        TempErrorMessage.LogMessage(
                          Vendor, Vendor.FieldNo("Vendor Posting Group"), TempErrorMessage."Message Type"::Error,
                          StrSubstNo(FieldValueIsNotSpecifiedErr, Vendor.FieldCaption("Vendor Posting Group"), Vendor."No."));

                    if Vendor.City = '' then
                        TempErrorMessage.LogMessage(
                          Vendor, Vendor.FieldNo(City), TempErrorMessage."Message Type"::Error,
                          StrSubstNo(FieldValueIsNotSpecifiedErr, Vendor.FieldCaption(City), Vendor."No."));

                    if GenerateSAFTFile.GetVendorRegistrationNumber(Vendor) = '' then
                        TempErrorMessage.LogMessage(
                          Vendor, Vendor.FieldNo("VAT Registration No."), TempErrorMessage."Message Type"::Error,
                          StrSubstNo(FieldValueIsNotSpecifiedErr, Vendor.FieldCaption("VAT Registration No."), Vendor."No."));

                end;

                if GuiAllowed then begin
                    RecNo += 1;
                    w.Update(2, Round(RecNo / TotalRecNo * 10000, 1));
                end;
            until Vendor.Next = 0;
    end;

    local procedure CheckItems(var TempErrorMessage: Record "Error Message" temporary; SAFTExportHeader: Record "SSAFTSAFT Export Header")
    var
        Item: Record Item;
        GenerateSAFTFile: Codeunit "SSAFTSAFT Generate File";
        OpeningBalance: Decimal;
        ClosingBalance: Decimal;
    begin
        Item.Reset;
        if GuiAllowed then begin
            w.Update(1, 'Produs');
            Clear(RecNo);
            TotalRecNo := Item.Count;
        end;
        if Item.FindSet then
            repeat
                Item.SetRange("Date Filter", 0D, ClosingDate(SAFTExportHeader."Starting Date" - 1));
                Item.CalcFields("Net Change");
                OpeningBalance := Item."Net Change";

                Item.SetRange("Date Filter", 0D, ClosingDate(SAFTExportHeader."Ending Date"));
                Item.CalcFields("Net Change");
                ClosingBalance := Item."Net Change";
                if (ClosingBalance <> 0) or (OpeningBalance <> 0) or (GenerateSAFTFile.ExistsItemLedgerEntryPeriod(Item."No.", '', SAFTExportHeader)) then begin
                    if Item."Base Unit of Measure" = '' then
                        TempErrorMessage.LogMessage(
                          Item, Item.FieldNo("Base Unit of Measure"), TempErrorMessage."Message Type"::Error,
                          StrSubstNo(FieldValueIsNotSpecifiedErr, Item.FieldCaption("Base Unit of Measure"), Item."No."));
                    if Item."Gen. Prod. Posting Group" = '' then
                        TempErrorMessage.LogMessage(
                          Item, Item.FieldNo("Gen. Prod. Posting Group"), TempErrorMessage."Message Type"::Error,
                          StrSubstNo(FieldValueIsNotSpecifiedErr, Item.FieldCaption("Gen. Prod. Posting Group"), Item."No."));
                end;

                if GuiAllowed then begin
                    RecNo += 1;
                    w.Update(2, Round(RecNo / TotalRecNo * 10000, 1));
                end;
            until Item.Next = 0;
    end;

    local procedure CheckCurrencies(var TempErrorMessage: Record "Error Message" temporary; SAFTExportHeader: Record "SSAFTSAFT Export Header")
    var
        Currency: Record Currency;
    begin
        Currency.Reset;
        Currency.SetFilter("ISO Code", '<>%1', '');
        if not Currency.FindFirst then
            TempErrorMessage.LogMessage(
              Currency, Currency.FieldNo("ISO Code"), TempErrorMessage."Message Type"::Error,
              StrSubstNo(FieldValueIsNotSpecifiedErr, Currency.FieldCaption("ISO Code"), ''));
    end;
}

