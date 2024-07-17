#pragma implicitwith disable
page 71902 "SSAFT Mapping Values"
{
    // SSM2101 SSCAT 04.01.2023 SAF-T
    Caption = 'SAFT Mapping Values';
    PageType = List;
    SourceTable = "SSAFT Mapping Values";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("NFT Type"; Rec."NFT Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'NFT Type';
                }
                field("SAFT Code"; Rec."SAFT Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'SAFT Code';
                }
                field("SAFT Description"; Rec."SAFT Description")
                {
                    ApplicationArea = All;
                    ToolTip = 'SAFT Description';
                }
            }
        }
    }

    actions
    {
    }
}

#pragma implicitwith restore

