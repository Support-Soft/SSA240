pageextension 72005 "SSAEDItem Card" extends "Item Card"
{
    layout
    {
        addlast(Item)
        {
            field("SSAEDProdus cu Risc"; Rec."SSAEDProdus cu Risc")
            {
                ToolTip = 'Produsul este cu risc?';
                ApplicationArea = All;
            }
        }
    }
}

