page 70001 "SSAInt. Consumption Subform"
{
    // SSA937 SSCAT 16.06.2019 3.Funct. Bonuri de consum-consum intern

    AutoSplitKey = true;
    Caption = 'Internal Consumption Subform';
    DelayedInsert = true;
    MultipleNewLines = true;
    PageType = ListPart;
    SourceTable = "SSAInternal Consumption Line";

    layout
    {
        area(content)
        {
            repeater(Control1390000)
            {
                ShowCaption = false;
                field("Item No."; "Item No.")
                {
                    ApplicationArea = All;
                }
                field(Description; Description)
                {
                    ApplicationArea = All;
                }
                field("Posting Group"; "Posting Group")
                {
                    ApplicationArea = All;
                }
                field("Gen. Prod. Posting Group"; "Gen. Prod. Posting Group")
                {
                    ApplicationArea = All;
                }
                field("Item Category Code"; "Item Category Code")
                {
                    ApplicationArea = All;
                }
                field("Location Code"; "Location Code")
                {
                    ApplicationArea = All;
                }
                field(Quantity; Quantity)
                {
                    Caption = 'Quantity';
                    Editable = true;
                    ApplicationArea = All;
                }
                field("Appl.-to Item Entry"; "Appl.-to Item Entry")
                {
                    ApplicationArea = All;
                }
                field("Appl.-from Item Entry"; "Appl.-from Item Entry")
                {
                    ApplicationArea = All;
                }
                field("Shortcut Dimension 1 Code"; "Shortcut Dimension 1 Code")
                {
                    Caption = 'Stornare';
                    ApplicationArea = All;
                }
                field("Shortcut Dimension 2 Code"; "Shortcut Dimension 2 Code")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(processing)
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
                    ShortCutKey = 'Shift+Ctrl+D';
                    ApplicationArea = All;
                    trigger OnAction()
                    begin
                        //This functionality was copied from page #16100. Unsupported part was commented. Please check it.
                        /*CurrPage.InternalConsumptionLine.FORM.*/
                        Rec.ShowDimensions;

                    end;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        ShowShortcutDimCode(ShortcutDimCode);
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
        Rec.ShowDimensions;
    end;

    local
    procedure ShowDimensions()
    begin
        Rec.ShowDimensions;
    end;

    local
    procedure UpdateForm(SetSaveRecord: Boolean)
    begin
        CurrPage.Update(SetSaveRecord);
    end;
}

