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
                field("SSA Net Weight"; Rec."SSA Net Weight")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Net Weight field.';
                }
                field("SSA Tariff No."; Rec."SSA Tariff No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Tariff No. field.';
                }
                field("SSA Country/Region of Origin"; Rec."SSA Country/Region of Origin")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Country/Region of Origin Code field.';
                }
            }
        }
    }
}
