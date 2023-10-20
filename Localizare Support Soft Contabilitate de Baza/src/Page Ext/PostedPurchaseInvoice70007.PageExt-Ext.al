pageextension 70007 "SSA PostedPurchaseInvoice70007" extends "Posted Purchase Invoice"
{
    // SSA973 SSCAT 06.09.2019 39.Rapoarte legale- Localizare Declaratia 394
    // SSA946 SSCAT 26.09.2019 12.Funct. functionalitate DVI la achizitii
    layout
    {
        addafter("Vendor Order No.")
        {
            field("SSA Custom Invoice No."; Rec."SSA Custom Invoice No.")
            {
                Editable = false;
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Custom Invoice No. field.';
            }
        }
        addafter("Creditor No.")
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
        modify(CancelInvoice)
        {
            ApplicationArea = All;
            Visible = true;
        }
        modify(CorrectInvoice)
        {
            ApplicationArea = All;
            Visible = true;
        }
    }
}
