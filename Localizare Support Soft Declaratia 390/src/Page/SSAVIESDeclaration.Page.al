page 71501 "SSA VIES Declaration"
{
    // SSA974 SSCAT 11.10.2019 40.Rapoarte legale-Declaratia 390

    Caption = 'VIES Declaration';
    PageType = Document;
    RefreshOnActivate = true;
    SourceTable = "SSA VIES Header";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                    ToolTip = 'Specifies the value of the No. field.';
                    trigger OnAssistEdit()
                    begin
                        if Rec.AssistEdit(xRec) then
                            CurrPage.Update;
                    end;
                }
                field("Declaration Period"; Rec."Declaration Period")
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                    ToolTip = 'Specifies the value of the Declaration Period field.';
                }
                field("Declaration Type"; Rec."Declaration Type")
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                    ToolTip = 'Specifies the value of the Declaration Type field.';
                    trigger OnValidate()
                    begin
                        if xRec."Declaration Type" <> Rec."Declaration Type" then
                            if Rec."Declaration Type" <> Rec."Declaration Type"::Corrective then
                                Rec."Corrected Declaration No." := '';
                        DeclarationTypeOnAfterValidate;
                    end;
                }
                field("Corrected Declaration No."; Rec."Corrected Declaration No.")
                {
                    ApplicationArea = All;
                    Editable = CorrectedDeclarationNoEditable;
                    ToolTip = 'Specifies the value of the Corrected Declaration No. field.';
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = All;
                    Editable = NameEditable;
                    ToolTip = 'Specifies the value of the Name field.';
                }
                field("VAT Registration No."; Rec."VAT Registration No.")
                {
                    ApplicationArea = All;
                    Editable = "VAT Registration No.Editable";
                    ToolTip = 'Specifies the value of the VAT Registration No. field.';
                }
                field("SSA Tax Office Number"; Rec."SSA Tax Office Number")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Tax Office Number field.';
                }
                field("Trade Type"; Rec."Trade Type")
                {
                    ApplicationArea = All;
                    Editable = "Trade TypeEditable";
                    ToolTip = 'Specifies the value of the Trade Type field.';
                }
                field("EU Goods/Services"; Rec."EU Goods/Services")
                {
                    ApplicationArea = All;
                    Editable = "EU Goods/ServicesEditable";
                    ToolTip = 'Specifies the value of the EU Goods/Services field.';
                }
                field("Document Date"; Rec."Document Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Document Date field.';
                }
                field("Period No."; Rec."Period No.")
                {
                    ApplicationArea = All;
                    Editable = "Period No.Editable";
                    Importance = Promoted;
                    ToolTip = 'Specifies the value of the Period No. field.';
                }
                field(Year; Rec.Year)
                {
                    ApplicationArea = All;
                    Editable = YearEditable;
                    Importance = Promoted;
                    ToolTip = 'Specifies the value of the Year field.';
                }
                field("Start Date"; Rec."Start Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Start Date field.';
                }
                field("End Date"; Rec."End Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the End Date field.';
                }
                field("Amount (LCY)"; Rec."Amount (LCY)")
                {
                    ApplicationArea = All;
                    DrillDown = false;
                    ToolTip = 'Specifies the value of the Amount (LCY) field.';
                }
                field("Number of Supplies"; Rec."Number of Supplies")
                {
                    ApplicationArea = All;
                    DrillDown = false;
                    ToolTip = 'Specifies the value of the Number of Supplies field.';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    Editable = false;
                    Importance = Promoted;
                    ToolTip = 'Specifies the value of the Status field.';
                }
            }
            part(Control1470001; "SSA VIES Declaration Subform")
            {
                ApplicationArea = All;
                SubPageLink = "VIES Declaration No." = field("No.");
            }
            group(Address)
            {
                Caption = 'Address';
                field("Country/Region Name"; Rec."Country/Region Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Country/Region Name field.';
                }
                field(County; Rec.County)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the County field.';
                }
                field("Post Code"; Rec."Post Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Post Code field.';
                }
                field(City; Rec.City)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the City field.';
                }
                field(Street; Rec.Street)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Street field.';
                }
                field("House No."; Rec."House No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the House No. field.';
                }
                field("Municipality No."; Rec."Municipality No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Municipality No. field.';
                }
                field("Apartment No."; Rec."Apartment No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Apartment No. field.';
                }
            }
            group(Persons)
            {
                Caption = 'Persons';
                field("Authorized Employee No."; Rec."Authorized Employee No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Authorized Employee No. field.';
                }
                field("Filled by Employee No."; Rec."Filled by Employee No.")
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                    ToolTip = 'Specifies the value of the Filled by Employee No. field.';
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            group("F&unctions")
            {
                Caption = 'F&unctions';
                action("&Suggest Lines")
                {
                    ApplicationArea = All;
                    Caption = '&Suggest Lines';
                    Ellipsis = true;
                    Image = SuggestLines;
                    Promoted = true;
                    PromotedCategory = Process;
                    ToolTip = 'Executes the &Suggest Lines action.';
                    trigger OnAction()
                    begin
                        Rec.TestField(Status, Rec.Status::Open);
                        VIESHeader.SetRange("No.", Rec."No.");
                        REPORT.RunModal(REPORT::"SSA Suggest VIES Lines", true, false, VIESHeader);
                    end;
                }
                action("&Get Lines for Correction")
                {
                    ApplicationArea = All;
                    Caption = '&Get Lines for Correction';
                    Ellipsis = true;
                    Image = GetLines;
                    Promoted = true;
                    PromotedCategory = Process;
                    ToolTip = 'Executes the &Get Lines for Correction action.';
                    trigger OnAction()
                    var
                        VIESDeclarationLine: Record "SSA VIES Line";
                        VIESDeclarationLines: Page "SSA VIES Lines";
                    begin
                        Rec.TestField(Status, Rec.Status::Open);
                        Rec.TestField("Corrected Declaration No.");
                        VIESDeclarationLines.SetToDeclaration(Rec);
                        VIESDeclarationLines.LookupMode := true;
                        if VIESDeclarationLines.RunModal = ACTION::LookupOK then
                            VIESDeclarationLines.CopyLineToDeclaration;

                        Clear(VIESDeclarationLines);
                    end;
                }
                separator(Separator1470060)
                {
                }
                action("Re&lease")
                {
                    ApplicationArea = All;
                    Caption = 'Re&lease';
                    Image = ReleaseDoc;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ShortcutKey = 'Ctrl+F9';
                    ToolTip = 'Executes the Re&lease action.';
                    trigger OnAction()
                    begin
                        Release.Run(Rec);
                    end;
                }
                action("Re&open")
                {
                    ApplicationArea = All;
                    Caption = 'Re&open';
                    Image = ReOpen;
                    Promoted = true;
                    PromotedCategory = Process;
                    ToolTip = 'Executes the Re&open action.';
                    trigger OnAction()
                    var
                        ReleaseSalesDoc: Codeunit "Release Sales Document";
                    begin
                        Release.Reopen(Rec);
                    end;
                }
            }
            group("&Print")
            {
                Caption = '&Print';
                separator(Separator1470059)
                {
                }
                action("&Declaration")
                {
                    ApplicationArea = All;
                    Caption = '&Declaration';
                    ToolTip = 'Executes the &Declaration action.';
                    trigger OnAction()
                    begin
                        Rec.Print;
                    end;
                }
            }
        }
        area(reporting)
        {
        }
    }

    trigger OnAfterGetRecord()
    begin
        SetControlsEditable;
    end;

    trigger OnInit()
    begin
        "EU Goods/ServicesEditable" := true;
        "Trade TypeEditable" := true;
        "VAT Registration No.Editable" := true;
        NameEditable := true;
        YearEditable := true;
        "Period No.Editable" := true;
        CorrectedDeclarationNoEditable := true;
    end;

    var
        Country: Record "Country/Region";
        VIESHeader: Record "SSA VIES Header";
        Countries: Page "Countries/Regions";
        Release: Codeunit "SSA Release VIES Declaration";

        CorrectedDeclarationNoEditable: Boolean;

        "Period No.Editable": Boolean;

        YearEditable: Boolean;

        NameEditable: Boolean;

        "VAT Registration No.Editable": Boolean;

        "Trade TypeEditable": Boolean;

        "EU Goods/ServicesEditable": Boolean;

    local
    procedure SetControlsEditable()
    var
        Corrective: Boolean;
    begin
        Corrective := Rec."Declaration Type" in [Rec."Declaration Type"::Corrective,
                                             Rec."Declaration Type"::"Corrective-Supplementary"];
        CorrectedDeclarationNoEditable := Corrective;
        "Period No.Editable" := not Corrective;
        YearEditable := not Corrective;
        NameEditable := not Corrective;
        "VAT Registration No.Editable" := not Corrective;
        "Trade TypeEditable" := not Corrective;
        "EU Goods/ServicesEditable" := not Corrective;
    end;

    local procedure DeclarationTypeOnAfterValidate()
    begin
        SetControlsEditable;
    end;
}
