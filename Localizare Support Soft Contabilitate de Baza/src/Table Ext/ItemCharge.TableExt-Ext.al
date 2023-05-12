tableextension 70025 "SSA Item Charge" extends "Item Charge" //5800
{
    fields
    {
        field(70000; "SSA Type"; Option)
        {
            Caption = 'Type';
            OptionMembers = "","Excise","Freight","Custom Taxes","Custom Commission";
            OptionCaption = '"","Excise","Freight","Custom Taxes","Custom Commission"';
        }
    }

}