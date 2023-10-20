page 70004 "SSAPstd. Int. Cons. Subform"
{
    // SSA937 SSCAT 16.06.2019 3.Funct. Bonuri de consum-consum intern

    Caption = 'Posted Int. Consumpt. Subform';
    Editable = false;
    PageType = ListPart;
    SourceTable = "SSAPstd. Int. Consumption Line";
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            repeater(Control1390000)
            {
                ShowCaption = false;
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the No. field.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Description field.';
                }
                field("Posting Group"; Rec."Posting Group")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Posting Group field.';
                }
                field("Gen. Prod. Posting Group"; Rec."Gen. Prod. Posting Group")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Gen. Prod. Posting Group field.';
                }
                field("Unit of Measure Code"; Rec."Unit of Measure Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Unit of Measure Code field.';
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Quantity field.';
                }
                field("Appl.-to Item Entry"; Rec."Appl.-to Item Entry")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Appl.-to Item Entry field.';
                }
                field("Appl.-from Item Entry"; Rec."Appl.-from Item Entry")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Appl.-from Item Entry field.';
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            group("&Line")
            {
                Caption = '&Line';
                action(Dimensions)
                {
                    ApplicationArea = All;
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    ShortcutKey = 'Shift+Ctrl+D';
                    ToolTip = 'Executes the Dimensions action.';
                    trigger OnAction()
                    begin
                        //This functionality was copied from page #16103. Unsupported part was commented. Please check it.
                        /*CurrPage.PostedIntConsumptionLines.FORM.*/
                        Rec.ShowDimensions();
                    end;
                }
            }
        }
    }

    local
    procedure _ShowDimensions()
    begin
        Rec.ShowDimensions();
    end;

    local
    procedure ShowDimensions()
    begin
        Rec.ShowDimensions();
    end;
}
