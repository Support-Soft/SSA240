pageextension 70008 "SSA PostedPurchCreditMemo70008" extends "Posted Purchase Credit Memo"
{
    // SSA973 SSCAT 06.09.2019 39.Rapoarte legale- Localizare Declaratia 394
    // SSA936 SSCAT 26.09.2019 2.Funct. anulare/stornare automata de documente (vanzare, cumparare)
    // SSA946 SSCAT 26.09.2019 12.Funct. functionalitate DVI la achizitii
    layout
    {
        addafter("Vendor Cr. Memo No.")
        {
            field("SSA Custom Invoice No."; Rec."SSA Custom Invoice No.")
            {
                ApplicationArea = All;
                Editable = false;
                ToolTip = 'Specifies the value of the Custom Invoice No. field.';
            }
        }
        addafter("Applies-to Doc. No.")
        {
            field("SSA Tip Document D394"; Rec."SSA Tip Document D394")
            {
                ApplicationArea = All;
                Editable = false;
                ToolTip = 'Specifies the value of the Tip Document D394 field.';
            }
            field("SSA Stare Factura"; Rec."SSA Stare Factura")
            {
                ApplicationArea = All;
                Editable = false;
                ToolTip = 'Specifies the value of the Stare Factura field.';
            }
        }
    }
    actions
    {
        modify(CancelCrMemo)
        {
            ApplicationArea = All;
            Visible = true;
            Enabled = true;
        }
    }
}
