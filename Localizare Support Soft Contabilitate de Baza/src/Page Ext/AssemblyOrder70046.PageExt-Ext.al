pageextension 70046 "SSA Assembly Order 70046" extends "Assembly Order"
{
    // SSA938 SSMCV 26.06.2019 4.Funct. business posting group obligatoriu la transferuri si asamblari
    layout
    {
        addafter(Status)
        {
            field("SSA Gen. Bus. Posting Group"; "SSA Gen. Bus. Posting Group")
            {
                ApplicationArea = All;
            }
        }
    }
}

