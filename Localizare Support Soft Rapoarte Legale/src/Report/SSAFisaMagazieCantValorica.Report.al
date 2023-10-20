report 71308 "SSA Fisa Magazie Cant-Valorica"
{
    // SSA1011 SSCAT 14.10.2019 77.Rapoarte legale-Fisa de magazie
    DefaultLayout = RDLC;
    RDLCLayout = './src/rdlc/SSAFisaMagazieCantValorica.rdlc';
    Caption = 'Fisa Magazie Cant-Valorica';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;

    dataset
    {
        dataitem("Item Ledger Entry"; "Item Ledger Entry")
        {
            CalcFields = "Cost Amount (Actual)";
            //The property 'DataItemTableView' shouldn't have an empty value.
            //DataItemTableView = '';
            RequestFilterFields = "Item No.", "Posting Date", "Location Code", "Lot No.";
            column(COMPANYNAME; CompanyInfo.Name)
            {
            }
            column(Cod_articol_caption; Cod_articol_lbl)
            {
            }
            column(Denumire_articol_caption; Denumire_articol_lbl)
            {
            }
            column(Gestiune_caption; Gestiunea_lbl)
            {
            }
            column(NrCrt_caption; NrCrt_lbl)
            {
            }
            column(Data_caption; Data_lbl)
            {
            }
            column(Tip_doc_caption; Tip_doc_lbl)
            {
            }
            column(Nr_doc_caption; "Nr.Doc_lbl")
            {
            }
            column(Nr_doc_extern_caption; Nr_Doc_ext_lbl)
            {
            }
            column(Furnizor_client_caption; "Fz/Cl_lbl")
            {
            }
            column(Intrari_caption; Intrati_lbl)
            {
            }
            column(IntrariVal_caption; IntrariVal_lbl)
            {
            }
            column(Iesiri_caption; Iesiri_lbl)
            {
            }
            column(IesiriVal_caption; IesiriVal_lbl)
            {
            }
            column(Stoc_caption; Stoc_lbl)
            {
            }
            column(StocVal_caption; StocVal_lbl)
            {
            }
            column(Total_caption; Total_lbl)
            {
            }
            column(Titlu_caption; Titlu_lbl)
            {
            }
            column(Stoc_Tot; StocTot)
            {
            }
            column(Filtru_Data; FiltruAux)
            {
            }
            column(Item_no_; "Item Ledger Entry"."Item No.")
            {
            }
            column(Loaction_no_; "Item Ledger Entry"."Location Code")
            {
            }
            column(Posting_date_; "Item Ledger Entry"."Posting Date")
            {
            }
            column(Document_no_; DocumentExt)
            {
            }
            column(External_Doc_No_; "Item Ledger Entry"."External Document No.")
            {
            }
            column(Lot_no_; "Item Ledger Entry"."Lot No.")
            {
            }
            column(Stoc_initial_caption; Stoc_i_lbl)
            {
            }
            column(Quantity_; "Item Ledger Entry".Quantity)
            {
            }
            column(Lot_Caption; Lot_lbl)
            {
            }
            column(Lcatie_caption; Locatie_lbl)
            {
            }
            column(FiltruItem; FiltruItem)
            {
            }
            column(FiltruItem_Nume; FiltruItem_Name)
            {
            }
            column(FiltruLocatie; FiltruLoc)
            {
            }
            column(Intrari_; intrari)
            {
            }
            column(iesiri_; -iesiri)
            {
            }
            column(tip_doc_; EntryType)
            {
            }
            column(Stoc_; Stoc)
            {
            }
            column(NumeVendor_Client; NumeVendorClient)
            {
            }
            column(Ile_SerialNo; "Item Ledger Entry"."Serial No.")
            {
            }
            column(SerieCPT; Serie_lbl)
            {
            }
            column(ValoareInceput; ValueTot)
            {
            }
            column(IntrariVal; IntrariValue)
            {
            }
            column(IesiriVal; -IesiriValue)
            {
            }
            column(StocVal; ValueStoc)
            {
            }
            column(CompanyInfo_VATRegistrationNumber; companyinfo.GetVATRegistrationNumber())
            {
            }

            trigger OnAfterGetRecord()
            begin
                intrari := 0;
                IntrariValue := 0;
                iesiri := 0;
                IesiriValue := 0;
                if "Item Ledger Entry".Quantity > 0 then begin
                    intrari += "Item Ledger Entry".Quantity;
                    VE.Reset;
                    VE.SetCurrentKey("Item Ledger Entry No.");
                    VE.SetRange(VE."Item Ledger Entry No.", "Item Ledger Entry"."Entry No.");
                    if VE.Find('-') then
                        repeat
                            IntrariValue += VE."Cost Amount (Actual)";
                        until VE.Next = 0;
                end else begin
                    iesiri += "Item Ledger Entry".Quantity;
                    VE.Reset;
                    VE.SetCurrentKey("Item Ledger Entry No.");
                    VE.SetRange(VE."Item Ledger Entry No.", "Item Ledger Entry"."Entry No.");
                    if VE.Find('-') then
                        repeat
                            IesiriValue += VE."Cost Amount (Actual)";
                        until VE.Next = 0;
                end;

                Stoc := Stoc + intrari + iesiri;
                ValueStoc := ValueStoc + IntrariValue + IesiriValue;
                NumeVendorClient := '';

                if "Entry Type" = "Entry Type"::Transfer then begin
                    if WLocation.Get("Item Ledger Entry"."Location Code") then
                        NumeVendorClient := WLocation.Name
                    else
                        NumeVendorClient := '';
                end;

                if "Entry Type" = "Entry Type"::"Positive Adjmt." then begin
                    if WLocation.Get("Item Ledger Entry"."Location Code") then
                        NumeVendorClient := WLocation.Name
                    else
                        NumeVendorClient := '';
                end;

                if "Entry Type" = "Entry Type"::"Negative Adjmt." then begin
                    if WLocation.Get("Item Ledger Entry"."Location Code") then
                        NumeVendorClient := WLocation.Name
                    else
                        NumeVendorClient := '';
                end;

                if "Entry Type" = "Entry Type"::Consumption then begin
                    if WLocation.Get("Item Ledger Entry"."Location Code") then
                        NumeVendorClient := WLocation.Name
                    else
                        NumeVendorClient := '';
                end;

                if "Entry Type" = "Entry Type"::Output then begin
                    if WLocation.Get("Item Ledger Entry"."Location Code") then
                        NumeVendorClient := WLocation.Name
                    else
                        NumeVendorClient := '';
                end;

                if "Source Type" = "Source Type"::Vendor then begin
                    if Vendor.Get("Source No.") then
                        NumeVendorClient := Vendor.Name
                    else
                        NumeVendorClient := '';
                end;
                if "Source Type" = "Source Type"::Customer then begin
                    if Customer.Get("Source No.") then
                        NumeVendorClient := Customer.Name
                    else
                        NumeVendorClient := '';
                end;

                DocumentExt := "Item Ledger Entry"."Document No.";
                VE.Reset;
                VE.SetCurrentKey("Item Ledger Entry No.");
                VE.SetRange(VE."Item Ledger Entry No.", "Item Ledger Entry"."Entry No.");
                VE.SetRange("Item Charge No.", '');
                VE.SetFilter("Cost Amount (Actual)", '<>0');
                if VE.FindFirst then begin
                    DocumentExt := VE."Document No.";
                    if VE."External Document No." <> '' then
                        DocumentExt := VE."External Document No.";
                end;
                if ("Item Ledger Entry"."Entry Type" = "Item Ledger Entry"."Entry Type"::Sale) and
                ("Item Ledger Entry"."SSA Document Type" = "Item Ledger Entry"."SSA Document Type"::"Internal Consumption") then
                    EntryType := 'Consum' else
                    EntryType := Format("Item Ledger Entry"."Entry Type");
            end;

            trigger OnPreDataItem()
            begin
                Stoc := StocTot;
                ValueStoc := ValueTot;
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
        nume_companie := '';
        companyinfo.Get();
        nume_companie := companyinfo.Name + ' ' + companyinfo."Name 2";

        FiltruAux := '';
        FiltruLoc := '';
        FiltruItem := '';
        FiltruItem_Name := '';

        FiltruAux := "Item Ledger Entry".GetFilter("Item Ledger Entry"."Posting Date");
        DataAux := "Item Ledger Entry".GetRangeMin("Posting Date") - 1;
        FiltruLoc := "Item Ledger Entry".GetFilter("Item Ledger Entry"."Location Code");
        FiltruItem := "Item Ledger Entry".GetFilter("Item Ledger Entry"."Item No.");
        Item.SetRange(Item."No.", Format(FiltruItem));
        if Item.FindFirst then
            FiltruItem_Name := Item."Search Description";
        "Item Ledger Entry".SetFilter("Posting Date", '<=%1', DataAux);
        "Item Ledger Entry".CalcSums("Item Ledger Entry".Quantity);
        StocTot := "Item Ledger Entry".Quantity;

        if "Item Ledger Entry".Find('-') then
            repeat
                VE.Reset;
                VE.SetCurrentKey("Item Ledger Entry No.");
                VE.SetRange(VE."Item Ledger Entry No.", "Item Ledger Entry"."Entry No.");
                if VE.Find('-') then
                    repeat
                        ValueTot += VE."Cost Amount (Actual)";
                    until VE.Next = 0;
            until "Item Ledger Entry".Next = 0;

        "Item Ledger Entry".SetFilter("Posting Date", FiltruAux);

        if (FiltruAux = '') or (FiltruLoc = '') or (FiltruItem = '') then
            Error('Trebuie sa completati toate filtrele necesare');
    end;

    var
        Titlu_lbl: Label 'Fisa Magazie';
        Cod_articol_lbl: Label 'Cod articol';
        Denumire_articol_lbl: Label 'Denumire articol';
        Gestiunea_lbl: Label 'Gestiunea';
        NrCrt_lbl: Label 'Nr. Crt.';
        Data_lbl: Label 'DAta';
        Tip_doc_lbl: Label 'Tip document';
        "Nr.Doc_lbl": Label 'Nr. Doc.';
        "Fz/Cl_lbl": Label 'Furnizor/Client';
        Intrati_lbl: Label 'Cant. Intrari';
        IntrariVal_lbl: Label 'Val. Intrari';
        IesiriVal_lbl: Label 'Val. Iesiri';
        Iesiri_lbl: Label 'Cant. Iesiri';
        StocVal_lbl: Label 'Stoc Valoric';
        Stoc_lbl: Label 'Stoc Cant.';
        Total_lbl: Label 'Total';
        companyinfo: Record "Company Information";
        nume_companie: Text[350];
        FiltruAux: Text[250];
        DataAux: Date;
        StocTot: Decimal;
        FiltruLoc: Text[250];
        Stoc_i_lbl: Label 'Stoc initial';
        Lot_lbl: Label 'Nr. lot';
        Locatie_lbl: Label 'Locatie';
        FiltruItem: Text[250];
        FiltruItem_Name: Text[250];
        intrari: Decimal;
        iesiri: Decimal;
        Item: Record Item;
        Stoc: Decimal;
        WLocation: Record Location;
        NumeVendorClient: Text[250];
        Vendor: Record Vendor;
        Customer: Record Customer;
        Serie_lbl: Label 'Serie';
        VE: Record "Value Entry";
        DocumentExt: Code[35];
        EntryType: Text[30];
        Nr_Doc_ext_lbl: Label 'External Doc No';
        ValueTot: Decimal;
        IntrariValue: Decimal;
        IesiriValue: Decimal;
        ValueStoc: Decimal;
}
