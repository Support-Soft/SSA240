page 71100 "SSA Search Items"
{
    // SSA939 SSCAT 23.10.2019 5.Funct. cautare avansata articole

    Caption = 'Search Items';
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = Worksheet;
    SourceTable = Item;
    SourceTableTemporary = true;
    ApplicationArea = All;
    layout
    {
        area(content)
        {
            group(Control1000000013)
            {
                ShowCaption = false;
                field(SearchFullDescritpion; SearchFullDescritpion)
                {
                    ApplicationArea = All;
                    Caption = 'Item Description';
                    ToolTip = 'Specifies the value of the Item Description field.';
                    trigger OnValidate()
                    begin
                        if SearchFullDescritpion <> '' then
                            SearchItems(SearchFullDescritpion);
                    end;
                }
                field(VariantCode; VariantCode)
                {
                    ApplicationArea = All;
                    Caption = 'Variant Code';
                    Visible = false;
                    ToolTip = 'Specifies the value of the Variant Code field.';
                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        ItemVariant.SetRange("Item No.", Rec."No.");
                        if PAGE.RunModal(0, ItemVariant) = ACTION::LookupOK then begin
                            VariantCode := ItemVariant.Code;
                            Rec.FindFirst;
                            CurrPage.Update(false);
                        end;
                    end;

                    trigger OnValidate()
                    begin
                        Rec.FindFirst;
                        CurrPage.Update(false);
                    end;
                }
            }
            repeater(Control1000000003)
            {
                Editable = false;
                ShowCaption = false;
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    Caption = 'No.';
                    ToolTip = 'Specifies the number of the involved entry or record, according to the specified number series.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    StyleExpr = StyleExpr;
                    ToolTip = 'Specifies a description of the item.';
                }
                field("SSA Full Description"; Rec."SSA Full Description")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Full Description field.';
                }
                field("Base Unit of Measure"; Rec."Base Unit of Measure")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the base unit used to measure the item, such as piece, box, or pallet. The base unit of measure also serves as the conversion basis for alternate units of measure.';
                }
                field("Substitutes Exist"; Rec."Substitutes Exist")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies that a substitute exists for this item.';
                }
                field(Blocked; Rec.Blocked)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies that the related record is blocked from being posted in transactions, for example an item that is placed in quarantine.';
                }
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage()
    begin
        SalesSetup.Get;
        if UserSetupMgt.GetSalesFilter <> '' then
            ResponsibilityCenter.Get(UserSetupMgt.GetSalesFilter);
    end;

    var
        SalesSetup: Record "Sales & Receivables Setup";
        ResponsibilityCenter: Record "Responsibility Center";
        ItemVariant: Record "Item Variant";
        UserSetupMgt: Codeunit "User Setup Management";
        VariantCode: Code[20];
        SearchFullDescritpion: Text[250];

        StyleExpr: Text;

    local
    procedure SearchItems(SearchDescription: Text[250])
    var
        Item: Record Item;
        TempItem: Record Item temporary;
        TempItem2: Record Item temporary;
        IsFirst: Boolean;
        SearchDescription_lVar: Text[250];
        SearchTxt: Text[250];
    begin
        Rec.DeleteAll;
        IsFirst := true;

        SearchDescription_lVar := SearchDescription;
        TempItem2.SetCurrentKey("SSA Full Description");

        while SearchDescription_lVar <> '' do begin
            TempItem.DeleteAll;

            if StrPos(SearchDescription_lVar, ' ') <> 0 then begin
                SearchTxt := CopyStr(SearchDescription_lVar, 1, StrPos(SearchDescription_lVar, ' ') - 1);
                SearchDescription_lVar := CopyStr(SearchDescription_lVar, StrLen(SearchTxt) + 2, StrLen(SearchDescription_lVar));
            end else begin
                SearchTxt := SearchDescription_lVar;
                SearchDescription_lVar := '';
            end;

            SearchTxt := '@*' + SearchTxt + '*';
            if IsFirst then begin
                FillTemporaryTable(Item, TempItem, SearchTxt);
                IsFirst := false;
            end else
                FillTemporaryTable(TempItem2, TempItem, SearchTxt);

            //Delete previous entries
            TempItem2.Reset;
            TempItem2.DeleteAll;

            if TempItem.FindSet then
                repeat
                    CopyTempToTemp(TempItem, TempItem2);
                until TempItem.Next = 0;
        end;

        if TempItem2.FindSet then
            repeat
                CopyTempToTemp(TempItem2, Rec);
            until TempItem2.Next = 0;
    end;

    local
    procedure FillTemporaryTable(var SearchItems: Record Item; var TempFinalItem: Record Item temporary; FilterBy: Text[250])
    begin
        SearchItems.SetFilter("SSA Full Description", FilterBy);
        if SearchItems.FindSet then
            repeat
                CopyTempToTemp(SearchItems, TempFinalItem);
            until SearchItems.Next = 0;
    end;

    local
    procedure CopyTempToTemp(var FromTable: Record Item; var ToTable: Record Item)
    begin
        if not ToTable.Get(FromTable."No.") then begin
            ToTable.Init;
            ToTable.TransferFields(FromTable);
            ToTable.Insert;
        end;
    end;
}
