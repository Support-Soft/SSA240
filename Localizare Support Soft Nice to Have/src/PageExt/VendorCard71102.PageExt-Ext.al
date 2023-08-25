pageextension 71102 "SSA Vendor Card 71102" extends "Vendor Card"
{
    // SSA966 SSCAT 03.10.2019 32.Funct. verificare TVA (ANAF, verificaretva.ro) - TVA la plata, split TVA
    actions
    {
        addlast("Ven&dor")
        {
            action("SSA Verificare CUI")
            {
                ApplicationArea = All;
                Caption = 'Verificare CUI';
                Visible = not ANAFVATVisible;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Ellipsis = false;
                trigger OnAction()
                var
                    VerificareTVA: Codeunit "SSA VerificareTVA.ro";
                begin
                    VerificareTVA.ValidateVendor(Rec);
                end;
            }
            action("SSA Verificare ANAF")
            {
                ApplicationArea = All;
                Caption = 'Verificare ANAF';
                Visible = ANAFVATVisible;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Ellipsis = false;
                trigger OnAction()
                var
                    InterogareTVAAnaf: Codeunit "SSA Interogare TVA Anaf";
                begin
                    InterogareTVAAnaf.ValidatePartner("No.", "VAT Registration No.", Database::Vendor);
                end;
            }
        }
    }


    trigger OnOpenPage()
    begin
        SSASetup.GET;
        ANAFVATVisible := SSASetup."SSA Enable ANAF VAT";
    end;

    var
        SSASetup: Record "SSA Localization Setup";
        [InDataSet]
        ANAFVATVisible: Boolean;
}

