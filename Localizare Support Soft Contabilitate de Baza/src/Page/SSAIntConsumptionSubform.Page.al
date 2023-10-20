page 70001 "SSAInt. Consumption Subform"
{
    // SSA937 SSCAT 16.06.2019 3.Funct. Bonuri de consum-consum intern

    AutoSplitKey = true;
    Caption = 'Internal Consumption Subform';
    DelayedInsert = true;
    MultipleNewLines = true;
    PageType = ListPart;
    SourceTable = "SSAInternal Consumption Line";
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
                    ToolTip = 'Specifies the value of the Item No. field.';
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
                field("Item Category Code"; Rec."Item Category Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Item Category Code field.';
                }
                field("Location Code"; Rec."Location Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Location Code field.';
                }
                field(Quantity; Rec.Quantity)
                {
                    Caption = 'Quantity';
                    Editable = true;
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
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    Caption = 'Stornare';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Stornare field.';
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Shortcut Dimension 2 Code field.';
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
                group("Item Availability By")
                {
                    Caption = 'Item Availability By';
                    action(Period)
                    {
                        ApplicationArea = All;
                        Caption = 'Period';
                        ToolTip = 'Executes the Period action.';
                        trigger OnAction()
                        begin
                            //This functionality was copied from page #16100. Unsupported part was commented. Please check it.
                            /*CurrPage.InternalConsumptionLine.FORM.*/
                            _ItemAvailability(0);
                        end;
                    }
                    action("Variant")
                    {
                        ApplicationArea = All;
                        Caption = 'Variant';
                        ToolTip = 'Executes the Variant action.';
                        trigger OnAction()
                        begin
                            //This functionality was copied from page #16100. Unsupported part was commented. Please check it.
                            /*CurrPage.InternalConsumptionLine.FORM.*/
                            _ItemAvailability(1);
                        end;
                    }
                    action(Location)
                    {
                        Caption = 'Location';
                        ApplicationArea = All;
                        ToolTip = 'Executes the Location action.';
                        trigger OnAction()
                        begin
                            //This functionality was copied from page #16100. Unsupported part was commented. Please check it.
                            /*CurrPage.InternalConsumptionLine.FORM.*/
                            _ItemAvailability(2);
                        end;
                    }
                }
                action(Dimensions)
                {
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    ShortcutKey = 'Shift+Ctrl+D';
                    ApplicationArea = All;
                    ToolTip = 'Executes the Dimensions action.';
                    trigger OnAction()
                    begin
                        //This functionality was copied from page #16100. Unsupported part was commented. Please check it.
                        /*CurrPage.InternalConsumptionLine.FORM.*/
                        Rec.ShowDimensions();
                    end;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        Rec.ShowShortcutDimCode(ShortcutDimCode);
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Clear(ShortcutDimCode);
    end;

    var
        ShortcutDimCode: array[8] of Code[20];

    local
        procedure _ItemAvailability(AvailabilityType: Option Date,Variant,Location,Bin)
    begin
        Rec.ItemAvailability(AvailabilityType);
    end;

    local
    procedure ItemAvailability(AvailabilityType: Option Date,Variant,Location,Bin)
    begin
        Rec.ItemAvailability(AvailabilityType);
    end;

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

    local
    procedure UpdateForm(SetSaveRecord: Boolean)
    begin
        CurrPage.Update(SetSaveRecord);
    end;
}
