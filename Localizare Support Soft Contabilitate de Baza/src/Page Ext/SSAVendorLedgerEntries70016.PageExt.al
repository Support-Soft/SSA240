pageextension 70016 "SSA VendorLedgerEntries70016" extends "Vendor Ledger Entries"
{
    // SSA946 SSCAT 26.09.2019 12.Funct. functionalitate DVI la achizitii
    layout
    {
        addlast(Control1)
        {
            field("SSA Custom Invoice No."; Rec."SSA Custom Invoice No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Custom Invoice No. field.';
            }
            field("SSA Stare Factura"; Rec."SSA Stare Factura")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Stare Factura field.';
            }
        }
    }
}
