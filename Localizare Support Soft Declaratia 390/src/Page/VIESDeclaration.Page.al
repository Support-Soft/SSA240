page 71501 "SSA VIES Declaration"
{
    // SSA974 SSCAT 11.10.2019 40.Rapoarte legale-Declaratia 390

    Caption = 'VIES Declaration';
    PageType = Document;
    RefreshOnActivate = true;
    SourceTable = "SSA VIES Header";

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
                }
                field("Declaration Type"; Rec."Declaration Type")
                {
                    ApplicationArea = All;
                    Importance = Promoted;

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
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = All;
                    Editable = NameEditable;
                }
                field("VAT Registration No."; Rec."VAT Registration No.")
                {
                    ApplicationArea = All;
                    Editable = "VAT Registration No.Editable";
                }
                field("SSA Tax Office Number"; Rec."SSA Tax Office Number")
                {
                    ApplicationArea = All;
                }
                field("Trade Type"; Rec."Trade Type")
                {
                    ApplicationArea = All;
                    Editable = "Trade TypeEditable";
                }
                field("EU Goods/Services"; Rec."EU Goods/Services")
                {
                    ApplicationArea = All;
                    Editable = "EU Goods/ServicesEditable";
                }
                field("Document Date"; Rec."Document Date")
                {
                    ApplicationArea = All;
                }
                field("Period No."; Rec."Period No.")
                {
                    ApplicationArea = All;
                    Editable = "Period No.Editable";
                    Importance = Promoted;
                }
                field(Year; Rec.Year)
                {
                    ApplicationArea = All;
                    Editable = YearEditable;
                    Importance = Promoted;
                }
                field("Start Date"; Rec."Start Date")
                {
                    ApplicationArea = All;
                }
                field("End Date"; Rec."End Date")
                {
                    ApplicationArea = All;
                }
                field("Amount (LCY)"; Rec."Amount (LCY)")
                {
                    ApplicationArea = All;
                    DrillDown = false;
                }
                field("Number of Supplies"; Rec."Number of Supplies")
                {
                    ApplicationArea = All;
                    DrillDown = false;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    Editable = false;
                    Importance = Promoted;
                }
            }
            part(Control1470001; "SSA VIES Declaration Subform")
            {
                ApplicationArea = All;
                SubPageLink = "VIES Declaration No." = FIELD("No.");
            }
            group(Address)
            {
                Caption = 'Address';
                field("Country/Region Name"; Rec."Country/Region Name")
                {
                    ApplicationArea = All;
                }
                field(County; Rec.County)
                {
                    ApplicationArea = All;
                }
                field("Post Code"; Rec."Post Code")
                {
                    ApplicationArea = All;
                }
                field(City; Rec.City)
                {
                    ApplicationArea = All;
                }
                field(Street; Rec.Street)
                {
                    ApplicationArea = All;
                }
                field("House No."; Rec."House No.")
                {
                    ApplicationArea = All;
                }
                field("Municipality No."; Rec."Municipality No.")
                {
                    ApplicationArea = All;
                }
                field("Apartment No."; Rec."Apartment No.")
                {
                    ApplicationArea = All;
                }
            }
            group(Persons)
            {
                Caption = 'Persons';
                field("Authorized Employee No."; Rec."Authorized Employee No.")
                {
                    ApplicationArea = All;
                }
                field("Filled by Employee No."; Rec."Filled by Employee No.")
                {
                    ApplicationArea = All;
                    Importance = Promoted;
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
                    ShortCutKey = 'Ctrl+F9';

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

