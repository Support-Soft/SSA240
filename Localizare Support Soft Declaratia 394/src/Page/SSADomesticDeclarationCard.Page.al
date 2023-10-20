page 71701 "SSA Domestic Declaration Card"
{
    // SSA973 SSCAT 06.09.2019 39.Rapoarte legale- Localizare Declaratia 394

    PageType = Card;
    SourceTable = "SSA Domestic Declaration";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Code"; Rec.Code)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Code field.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Description field.';
                }
                field(Reported; Rec.Reported)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Reported field.';
                }
                field("Starting Date"; Rec."Starting Date")
                {
                    ApplicationArea = All;
                    Editable = DatesEditable;
                    ToolTip = 'Specifies the value of the Starting Date field.';
                }
                field("Ending Date"; Rec."Ending Date")
                {
                    ApplicationArea = All;
                    Editable = DatesEditable;
                    ToolTip = 'Specifies the value of the Ending Date field.';
                }
                field(TipD394; Rec.TipD394)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the TipD394 field.';
                    trigger OnValidate()
                    begin
                        if Rec.TipD394 = Rec.TipD394::L then
                            DatesEditable := false
                        else
                            DatesEditable := true;
                    end;
                }
                field(Perioada; Rec.Perioada)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Perioada field.';
                }
                field("Optiune verificare date"; Rec."Optiune verificare date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Optiune verificare date field.';
                }
                field("Schimb Optiune verificare date"; Rec."Schimb Optiune verificare date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Schimb Optiune verificare date field.';
                }
                field("Nr de AMEF"; Rec."Nr de AMEF")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Nr de AMEF field.';
                }
                field("Tranzactii Persoane Afiliate"; Rec."Tranzactii Persoane Afiliate")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Tranzactii Persoane Afiliate field.';
                }
                field("Copy Declaration Info from"; Rec."Copy Declaration Info from")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Copy Declaration Info from field.';
                }
            }
            group(Declarant)
            {
                Caption = 'Declarant';
                group("Sectiunea A")
                {
                    field("Telefon Companie"; Rec."Telefon Companie")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the Telefon Companie field.';
                    }
                    field("Fax Companie"; Rec."Fax Companie")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the Fax Companie field.';
                    }
                    field("E-Mail Companie"; Rec."E-Mail Companie")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the E-Mail Companie field.';
                    }
                }
                group("Sectiunea B1")
                {
                    field("Nume Reprezentant"; Rec."Nume Reprezentant")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the Nume Reprezentant field.';
                    }
                    field("CNP Reprezentant"; Rec."CNP Reprezentant")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the CNP Reprezentant field.';
                    }
                    field("Functie Declaratie"; Rec."Functie Declaratie")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the Functie Declaratie field.';
                    }
                    field("Adresa Reprezentant"; Rec."Adresa Reprezentant")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the Adresa Reperzentant field.';
                    }
                    field("Tel. Reprezentant"; Rec."Tel. Reprezentant")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the Tel. Reprezentant field.';
                    }
                    field("E-mail Reprezentant"; Rec."E-mail Reprezentant")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the E-mail Reprezentant field.';
                    }
                    field("Fax Reprezentant"; Rec."Fax Reprezentant")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the Fax Reprezentant field.';
                    }
                }
                group("Sectiunea B2")
                {
                    field("Tip Intocmit"; Rec."Tip Intocmit")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the Tip Intocmit field.';
                    }
                    field("Nume Intocmit"; Rec."Nume Intocmit")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the Nume Intocmit field.';
                    }
                    field("Functie Intocmit"; Rec."Functie Intocmit")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the Functie Intocmit field.';
                    }
                    field("Calitate Intocmit"; Rec."Calitate Intocmit")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the Calitate Intocmit field.';
                    }
                    field("CIF Intocmit"; Rec."CIF Intocmit")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the CIF Intocmit field.';
                    }
                }
            }
            group(Request)
            {
                Caption = 'Request';
                field(Solicit; Rec.Solicit)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Solicit field.';
                }
                field(AchizitiiPE; Rec.AchizitiiPE)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the AchizitiiPE field.';
                }
                field(AchizitiiCR; Rec.AchizitiiCR)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the AchizitiiCR field.';
                }
                field(AchizitiiCB; Rec.AchizitiiCB)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the AchizitiiCB field.';
                }
                field(AchizitiiCI; Rec.AchizitiiCI)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the AchizitiiCI field.';
                }
                field(AchizitiiA; Rec.AchizitiiA)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the AchizitiiA field.';
                }
                field(AchizitiiB24; Rec.AchizitiiB24)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the AchizitiiB24 field.';
                }
                field(AchizitiiB20; Rec.AchizitiiB20)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the AchizitiiB20 field.';
                }
                field(AchizitiiB19; Rec.AchizitiiB19)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the AchizitiiB19 field.';
                }
                field(AchizitiiB9; Rec.AchizitiiB9)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the AchizitiiB9 field.';
                }
                field(AchizitiiB5; Rec.AchizitiiB5)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the AchizitiiB5 field.';
                }
                field(AchizitiiS24; Rec.AchizitiiS24)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the AchizitiiS24 field.';
                }
                field(AchizitiiS20; Rec.AchizitiiS20)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the AchizitiiS20 field.';
                }
                field(AchizitiiS19; Rec.AchizitiiS19)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the AchizitiiS19 field.';
                }
                field(AchizitiiS9; Rec.AchizitiiS9)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the AchizitiiS9 field.';
                }
                field(AchizitiiS5; Rec.AchizitiiS5)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the AchizitiiS5 field.';
                }
                field(ImportB; Rec.ImportB)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the ImportB field.';
                }
                field(AcINecorp; Rec.AcINecorp)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the AcINecorp field.';
                }
                field(LivrariBI; Rec.LivrariBI)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the LivrariBI field.';
                }
                field(Bun24; Rec.Bun24)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Bun24 field.';
                }
                field(Bun20; Rec.Bun20)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Bun20 field.';
                }
                field(Bun19; Rec.Bun19)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Bun19 field.';
                }
                field(Bun9; Rec.Bun9)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Bun9 field.';
                }
                field(Bun5; Rec.Bun5)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Bun5 field.';
                }
                field(ValoareScutit; Rec.ValoareScutit)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the ValoareScutit field.';
                }
                field(BunTI; Rec.BunTI)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the BunTI field.';
                }
                field(Prest24; Rec.Prest24)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Prest24 field.';
                }
                field(Prest20; Rec.Prest20)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Prest20 field.';
                }
                field(Prest19; Rec.Prest19)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Prest19 field.';
                }
                field(Prest9; Rec.Prest9)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Prest9 field.';
                }
                field(Prest5; Rec.Prest5)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Prest5 field.';
                }
                field(PrestScutit; Rec.PrestScutit)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the PrestScutit field.';
                }
                field(LIntra; Rec.LIntra)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the LIntra field.';
                }
                field(PrestIntra; Rec.PrestIntra)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the PrestIntra field.';
                }
                field(Export; Rec.Export)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Export field.';
                }
                field(LivNecorp; Rec.LivNecorp)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the LivNecorp field.';
                }
                field(Efectuat; Rec.Efectuat)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Efectuat field.';
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        if Rec.TipD394 = Rec.TipD394::L then
            DatesEditable := false
        else
            DatesEditable := true;
    end;

    var

        DatesEditable: Boolean;
}
