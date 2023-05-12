tableextension 70028 "SSA Purchase Header70028" extends "Purchase Header"
{
    // SSA973 SSCAT 06.09.2019 39.Rapoarte legale- Localizare Declaratia 394
    // SSA946 SSCAT 26.09.2019 12.Funct. functionalitate DVI la achizitii
    // SSA947 SSCAT 10.01.2019 13.Funct. “TVA la incasare”
    // SSA968 SSCAT 04.10.2019 34.Funct. Operatiuni triunghiulare, delivery, cod registru comertului, numar comanda client
    fields
    {
        field(70000; "SSA Tip Document D394"; Option)
        {
            Caption = 'Tip Document D394';
            DataClassification = ToBeClassified;
            Description = 'SSA973';
            OptionCaption = ' ,Factura Fiscala,Bon Fiscal,Factura Simplificata,Borderou,File Carnet,Contract,Alte Documente';
            OptionMembers = " ","Factura Fiscala","Bon Fiscal","Factura Simplificata",Borderou,"File Carnet",Contract,"Alte Documente";
        }
        field(70001; "SSA Stare Factura"; Option)
        {
            Caption = 'Stare Factura';
            DataClassification = ToBeClassified;
            Description = 'SSA973';
            OptionCaption = ' ,0-Factura Emisa,1-Factura Stornata,2-Factura Anulata,3-Autofactura,4-In calidate de beneficiar in numele furnizorului';
            OptionMembers = " ","0-Factura Emisa","1-Factura Stornata","2-Factura Anulata","3-Autofactura","4-In calidate de beneficiar in numele furnizorului";
        }
        field(70002; "SSA Custom Invoice No."; Code[20])
        {
            Caption = 'Custom Invoice No.';
            DataClassification = ToBeClassified;
            Description = 'SSA946';
        }
        field(70003; "SSA VAT to Pay"; Boolean)
        {
            Caption = 'VAT to pay';
            DataClassification = ToBeClassified;
            Description = 'SSA947';

            trigger OnValidate()
            var
                SSASetup: Record "SSA Localization Setup";
                CompanyInformation: Record "Company Information";
            begin
                //SSA947>>
                CompanyInformation.Get;
                if "Buy-from Country/Region Code" <> CompanyInformation."Country/Region Code" then
                    exit;

                if xRec."SSA VAT to Pay" = "SSA VAT to Pay" then
                    exit;
                SSASetup.Get;
                SSASetup.TestField("Vendor Neex. VAT Posting Group");
                SSASetup.TestField("Vendor Ex. VAT Posting Group");
                if "SSA VAT to Pay" then
                    "VAT Bus. Posting Group" := SSASetup."Vendor Neex. VAT Posting Group"
                else
                    "VAT Bus. Posting Group" := SSASetup."Vendor Ex. VAT Posting Group";
                UpdatePurchLinesByFieldNo(FieldNo("VAT Bus. Posting Group"), false);
                //SSA947<<
            end;
        }
        field(70004; "SSA Commerce Trade No."; Code[20])
        {
            Caption = 'Commerce Trade No.';
            DataClassification = ToBeClassified;
            Description = 'SSA968';
        }
    }
}

