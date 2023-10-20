pageextension 71101 "SSA Customer Card 71101" extends "Customer Card"
{
    // SSA966 SSCAT 03.10.2019 32.Funct. verificare TVA (ANAF, verificaretva.ro) - TVA la plata, split TVA
    actions
    {
        addlast("&Customer")
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
                ToolTip = 'Executes the Verificare CUI action.';
                trigger OnAction()
                var
                    VerificareTVA: Codeunit "SSA VerificareTVA.ro";
                begin
                    VerificareTVA.ValidateCustomer(Rec);
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
                ToolTip = 'Executes the Verificare ANAF action.';
                trigger OnAction()
                var
                    InterogareTVAAnaf: Codeunit "SSA Interogare TVA Anaf";
                begin
                    InterogareTVAAnaf.ValidatePartner(Rec."No.", Rec."VAT Registration No.", Database::Customer);
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

        ANAFVATVisible: Boolean;
}
