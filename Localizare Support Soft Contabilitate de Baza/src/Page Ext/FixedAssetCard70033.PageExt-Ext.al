pageextension 70033 "SSA Fixed Asset Card70033" extends "Fixed Asset Card"
{
    // SSA953 SSCAT 25.09.2019 19.Funct. intrastat
    layout
    {
        addafter(Maintenance)
        {
            group("SSA Intrastat")
            {
                Caption = 'Intrastat';
                field("SSA Net Weight"; "SSA Net Weight")
                {
                    ApplicationArea = All;
                }
                field("SSA Tariff No."; "SSA Tariff No.")
                {
                    ApplicationArea = All;
                }
                field("SSA Country/Region of Origin"; "SSA Country/Region of Origin")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}

