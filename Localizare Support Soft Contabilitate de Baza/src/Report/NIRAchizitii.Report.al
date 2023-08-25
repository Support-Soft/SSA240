report 70005 "SSA NIR Achizitii"
{
    DefaultLayout = RDLC;
    RDLCLayout = './src/rdlc/SSANIRAchizitii.rdlc';
    Caption = 'NIR Achizitii';
    PreviewMode = PrintLayout;

    dataset
    {
        dataitem("Purch. Rcpt. Header"; "Purch. Rcpt. Header")
        {
            DataItemTableView = sorting("No.");
            RequestFilterFields = "No.", "Buy-from Vendor No.", "Posting Date";
            column(PaginaCaption; Pagelbl)
            {
            }
            column(FromCaption; Fromlbl)
            {
            }
            column(TitleCaption; Titlelbl)
            {
            }
            column(CompanyCaption; Companylbl)
            {
            }
            column(Company; CompanyInfo.Name)
            {
            }
            column(ComerceTradeNolbl; NrOrdRegComAnlbl)
            {
            }
            column(ComerceTradeNo; CompanyInfo."SSA Commerce Trade No.")
            {
            }
            column(VATRegistrationNolbl; VATRegistrationNolbl)
            {
            }
            column(VATRegistrationNo; CompanyInfo."VAT Registration No.")
            {
            }
            column(Addresslbl; AccountingAdministration.FieldCaption(Address))
            {
            }
            column(Address; AccountingAdministration.Address + AccountingAdministration."Address 2")
            {
            }
            column(AccountingAdministrationlbl; AccountingAdministrationlbl)
            {
            }
            column(AccountingAdministration; AccountingAdministration.Name)
            {
            }
            column(DocumentNoCaption; Documentlbl)
            {
            }
            column(DocumentNo; "No.")
            {
            }
            column(DateCaption; DateLbl)
            {
            }
            column(DayCaption; DayCaptionlbl)
            {
            }
            column(MonthCaption; MonthCaptionlbl)
            {
            }
            column(YearCaption; YearCaptionlbl)
            {
            }
            column(Day; Date2DMY("Posting Date", 1))
            {
            }
            column(Month; Date2DMY("Posting Date", 2))
            {
            }
            column(Year; Date2DMY("Posting Date", 3))
            {
            }
            column(VendorCaption; Vendorlbl)
            {
            }
            column(VendorName; "Buy-from Vendor Name")
            {
            }
            column(PurchaserCaption; Purchaserlbl)
            {
            }
            column(PurchaserCode; "Location Code")
            {
            }
            column(NrCaption; Nrlbl)
            {
            }
            column(ContractCaption; Contractlbl)
            {
            }
            column(OrderCaption; Orderlbl)
            {
            }
            column(OrderNo; "Order No.")
            {
            }
            column(InvoiceCaption; Invoicelbl)
            {
            }
            column(WaybillCaption; Waybilllbl)
            {
            }
            column(CreditorAccountCaption; CreditorAccountlbl)
            {
            }
            column(CreditorAccountNo; VendorPostingGroup."Payables Account")
            {
            }
            column(Paragraph1; Paragraph1)
            {
            }
            column(Paragraph2; Paragraph2)
            {
            }
            column(Paragraph3; Paragraph3)
            {
            }
            dataitem("Purch. Rcpt. Line"; "Purch. Rcpt. Line")
            {
                DataItemLink = "Document No." = field("No.");
                DataItemTableView = sorting("Document No.", "Line No.");
                column(NocrtCaption; Nocrtlbl)
                {
                }
                column(DescriptionCaption; FieldCaption("Purch. Rcpt. Line".Description))
                {
                }
                column(PayablesAccountCaption; PayablesAccountlbl)
                {
                }
                column(ItemNoCaption; ItemNolbl)
                {
                }
                column(UMCaption; UMlbl)
                {
                }
                column(QuantityReceivedCaption; QuantityReceivedlbl)
                {
                }
                column(ReceivedCaption; Receptionlbl)
                {
                }
                column(QuantityCaption; FieldCaption("Purch. Rcpt. Line".Quantity))
                {
                }
                column(UnitPriceCaption; UnitPricelbl)
                {
                }
                column(ValueCaption; Valuelbl)
                {
                }
                column(ValueNoTaxCaption; valuenotaxlbl)
                {
                }
                column(FreightValueCaption; FreightValuelbl)
                {
                }
                column(CustomsValueCaption; CustomsValuelbl)
                {
                }
                column(OtherTAXValueCaption; OtherTaxValuelbl)
                {
                }
                dataitem("Item Ledger Entry"; "Item Ledger Entry")
                {
                    CalcFields = "Cost Amount (Actual)", "Cost Amount (Expected)";
                    DataItemLink = "Document No." = field("Document No."), "Document Line No." = field("Line No.");
                    DataItemTableView = sorting("Document No.", "Document Type", "Document Line No.", "Item No.", "Lot No.", "Serial No.");
                    column(NrCrt; NrCrt)
                    {
                    }
                    column(Description; DescriereLinie)
                    {
                    }
                    column(PayablesAccount; InventoryPostingSetup."Inventory Account")
                    {
                    }
                    column(ItemNo; "Purch. Rcpt. Line"."No.")
                    {
                    }
                    column(UM; "Purch. Rcpt. Line"."Unit of Measure")
                    {
                    }
                    column(ReceivedQuantity; "Item Ledger Entry"."Invoiced Quantity")
                    {
                    }
                    column(Quantity; "Item Ledger Entry".Quantity)
                    {
                    }
                    column(Value; Value)
                    {
                    }
                    column(ValueNoTax; Valuenotax)
                    {
                    }
                    column(UnitPrice; UnitPrice)
                    {
                        DecimalPlaces = 7 : 7;
                    }
                    column(FreightValue; ArrTax[1])
                    {
                    }
                    column(CustomsValue; ArrTax[3])
                    {
                    }
                    column(OtherTaxValue; ArrTax[4])
                    {
                    }
                    column(InvoiceNo; WaybillNo)
                    {
                    }
                    column(ReceptionCommitteeCaption; ReceptionCommitteelbl)
                    {
                    }
                    column(ReceivedinAdministrationAccountCaption; ReceivedinAdministrationAccountlbl)
                    {
                    }
                    column(SignatureCaption; Signaturelbl)
                    {
                    }
                    column(NameandsurnameCaption; Namesurnamelbl)
                    {
                    }
                    column(DateTimeCaption; Datetimelbl)
                    {
                    }
                    column(MadebyCaption; Madebylbl)
                    {
                    }
                    column(TotalDocCaption; Totaldoclbl)
                    {
                    }
                    column(Currency; Format("Purch. Rcpt. Line"."Currency Code"))
                    {
                    }
                    column(CurrencyValue; Curs)
                    {
                        DecimalPlaces = 4 : 4;
                    }

                    trigger OnAfterGetRecord()
                    begin
                        NrCrt += 1;
                        DescriereLinie := "Purch. Rcpt. Line".Description;
                        Valuenotax := 0;
                        ValueEntry.Reset;
                        ValueEntry.SetCurrentKey("Item Ledger Entry No.");
                        //ValueEntry.SETFILTER("Item Charge No.", '<>%1', '');
                        ValueEntry.SetRange("Item Ledger Entry No.", "Entry No.");
                        Clear(ArrTax);
                        if ValueEntry.Find('-') then
                            repeat
                                if ValueEntry."Item Charge No." = '' then
                                    Valuenotax += ValueEntry."Cost Amount (Actual)" + ValueEntry."Cost Amount (Expected)"
                                else begin
                                    ItemCharges.Get(ValueEntry."Item Charge No.");
                                    case ItemCharges."SSA Type" of
                                        ItemCharges."SSA Type"::Freight:
                                            ArrTax[1] := ArrTax[1] + ValueEntry."Cost Amount (Actual)";
                                        //ItemCharges."SSA Type"::Excise:
                                        //    ArrTax[2] := ArrTax[2] + ValueEntry."Cost Amount (Actual)";
                                        ItemCharges."SSA Type"::"Custom Taxes":
                                            ArrTax[3] := ArrTax[3] + ValueEntry."Cost Amount (Actual)";
                                        else
                                            ArrTax[4] := ArrTax[4] + ValueEntry."Cost Amount (Actual)";
                                    end
                                end
                            until ValueEntry.Next = 0;
                        if "Item Ledger Entry"."Serial No." <> '' then
                            DescriereLinie := "Purch. Rcpt. Line".Description + "Purch. Rcpt. Line"."Description 2" + ' Nr. serie: ' + "Item Ledger Entry"."Serial No."
                        else
                            if "Item Ledger Entry"."Lot No." <> '' then
                                DescriereLinie := "Purch. Rcpt. Line".Description + "Purch. Rcpt. Line"."Description 2" + ' Nr. lot: ' + "Item Ledger Entry"."Lot No."
                            else
                                DescriereLinie := "Purch. Rcpt. Line".Description + "Purch. Rcpt. Line"."Description 2";
                        Value := "Cost Amount (Actual)" + "Cost Amount (Expected)";
                        if Quantity <> 0 then
                            UnitPrice := ("Cost Amount (Actual)" + "Cost Amount (Expected)") / "Item Ledger Entry".Quantity;
                        if "External Document No." = '' then
                            WaybillNo := "Purch. Rcpt. Header"."Vendor Shipment No."
                        else
                            WaybillNo := "External Document No."  //Factura daca nu aviz
                    end;
                }

                trigger OnAfterGetRecord()
                begin
                    InventoryPostingSetup.SetRange("Location Code", "Purch. Rcpt. Line"."Location Code");
                    InventoryPostingSetup.SetRange("Invt. Posting Group Code", "Purch. Rcpt. Line"."Posting Group");
                    if InventoryPostingSetup.Find('-') then; //Cont debitor
                    CalcFields("Purch. Rcpt. Line"."Currency Code");
                    if not (Type in [Type::Item, Type::"Fixed Asset"]) then
                        CurrReport.Skip;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                if AccountingAdministration.Get("Purch. Rcpt. Header"."Location Code") then; //Gestiune
                if UserS.Get(UserId) then;
                NrCrt := 0;
                if VendorPostingGroup.Get("Purch. Rcpt. Header"."Vendor Posting Group") then;  //Cont Creditor

                if "Purch. Rcpt. Header"."Currency Factor" <> 0 then
                    Curs := 1 / "Purch. Rcpt. Header"."Currency Factor"; //Curs
            end;

            trigger OnPreDataItem()
            begin
                CompanyInfo.Get;
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
        Clear(Curs);
    end;

    var
        CompanyInfo: Record "Company Information";
        AccountingAdministration: Record Location;
        InventoryPostingSetup: Record "Inventory Posting Setup";
        ValueEntry: Record "Value Entry";
        ItemCharges: Record "Item Charge";
        VendorPostingGroup: Record "Vendor Posting Group";
        InventoryPostingGroup: Record "Inventory Posting Group";
        WaybillNo: Code[35];
        ArrItemChargeName: array[10] of Code[20];
        ArrTax: array[4] of Decimal;
        ArrTaxTotal: array[4] of Decimal;
        ArrItemCharge: array[10] of Decimal;
        NrCrt: Integer;
        Pagelbl: Label 'Page';
        Fromlbl: Label 'of';
        Titlelbl: Label 'NOTE RECEPTION AND FINDING DIFFERENCES';
        Companylbl: Label 'Company: ';
        NrOrdRegComAnlbl: Label 'Comerce Trade No.:';
        VATRegistrationNolbl: Label 'VAT Registration No: ';
        AccountingAdministrationlbl: Label 'Accounting Administration: ';
        Documentlbl: Label 'Document No.';
        DateLbl: Label 'Date';
        DayCaptionlbl: Label 'Day';
        MonthCaptionlbl: Label 'Month';
        YearCaptionlbl: Label 'Year';
        Vendorlbl: Label 'Vendor';
        Purchaserlbl: Label 'Purchaser Code';
        Nrlbl: Label 'NO.';
        Contractlbl: Label 'Contract';
        Orderlbl: Label 'Order';
        Invoicelbl: Label 'Invoice';
        Waybilllbl: Label 'Waybill';
        CreditorAccountlbl: Label 'Creditor Account';
        Paragraph1: Label 'The undersigned, members of the committee reception, we proceeded to receiving material values provided by';
        Paragraph2: Label ' with coach/car nr.  . . . . . . . . . . . . . . . , accompanying documents . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . delegate . . . . . . . . . . . . . . . . . . . . .';
        Paragraph3: Label ' ascertaining these:';
        Nocrtlbl: Label 'No. crt.';
        PayablesAccountlbl: Label 'Debitor Account';
        ItemNolbl: Label 'Item No.';
        UMlbl: Label 'UM';
        QuantityReceivedlbl: Label 'Quantity Received';
        Receptionlbl: Label 'Received';
        UnitPricelbl: Label 'Unit Price';
        Valuelbl: Label 'Value';
        valuenotaxlbl: Label 'Value without tax';
        ReceptionCommitteelbl: Label 'Reception Committee';
        ReceivedinAdministrationAccountlbl: Label 'Received in Administration Account';
        Signaturelbl: Label 'Signature';
        Namesurnamelbl: Label 'Name and surname';
        Datetimelbl: Label 'Date and Time: ';
        Madebylbl: Label 'Made by: ';
        Value: Decimal;
        UnitPrice: Decimal;
        UserS: Record "User Setup";
        Curs: Decimal;
        Totaldoclbl: Label 'Total ';
        DescriereLinie: Text[250];
        Valuenotax: Decimal;
        FreightValuelbl: Label 'Freight Value';
        CustomsValuelbl: Label 'Duty Value';
        OtherTaxValuelbl: Label 'Other Taxes Value ';
}

