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
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
                field(Reported; Rec.Reported)
                {
                    ApplicationArea = All;
                }
                field("Starting Date"; Rec."Starting Date")
                {
                    ApplicationArea = All;
                    Editable = DatesEditable;
                }
                field("Ending Date"; Rec."Ending Date")
                {
                    ApplicationArea = All;
                    Editable = DatesEditable;
                }
                field(TipD394; Rec.TipD394)
                {
                    ApplicationArea = All;
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
                }
                field("Optiune verificare date"; Rec."Optiune verificare date")
                {
                    ApplicationArea = All;
                }
                field("Schimb Optiune verificare date"; Rec."Schimb Optiune verificare date")
                {
                    ApplicationArea = All;
                }
                field("Nr de AMEF"; Rec."Nr de AMEF")
                {
                    ApplicationArea = All;
                }
                field("Tranzactii Persoane Afiliate"; Rec."Tranzactii Persoane Afiliate")
                {
                    ApplicationArea = All;
                }
                field("Copy Declaration Info from"; Rec."Copy Declaration Info from")
                {
                    ApplicationArea = All;
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
                    }
                    field("Fax Companie"; Rec."Fax Companie")
                    {
                        ApplicationArea = All;
                    }
                    field("E-Mail Companie"; Rec."E-Mail Companie")
                    {
                        ApplicationArea = All;
                    }
                }
                group("Sectiunea B1")
                {
                    field("Nume Reprezentant"; Rec."Nume Reprezentant")
                    {
                        ApplicationArea = All;
                    }
                    field("CNP Reprezentant"; Rec."CNP Reprezentant")
                    {
                        ApplicationArea = All;
                    }
                    field("Functie Declaratie"; Rec."Functie Declaratie")
                    {
                        ApplicationArea = All;
                    }
                    field("Adresa Reprezentant"; Rec."Adresa Reprezentant")
                    {
                        ApplicationArea = All;
                    }
                    field("Tel. Reprezentant"; Rec."Tel. Reprezentant")
                    {
                        ApplicationArea = All;
                    }
                    field("E-mail Reprezentant"; Rec."E-mail Reprezentant")
                    {
                        ApplicationArea = All;
                    }
                    field("Fax Reprezentant"; Rec."Fax Reprezentant")
                    {
                        ApplicationArea = All;
                    }
                }
                group("Sectiunea B2")
                {
                    field("Tip Intocmit"; Rec."Tip Intocmit")
                    {
                        ApplicationArea = All;
                    }
                    field("Nume Intocmit"; Rec."Nume Intocmit")
                    {
                        ApplicationArea = All;
                    }
                    field("Functie Intocmit"; Rec."Functie Intocmit")
                    {
                        ApplicationArea = All;
                    }
                    field("Calitate Intocmit"; Rec."Calitate Intocmit")
                    {
                        ApplicationArea = All;
                    }
                    field("CIF Intocmit"; Rec."CIF Intocmit")
                    {
                        ApplicationArea = All;
                    }
                }
            }
            group(Request)
            {
                Caption = 'Request';
                field(Solicit; Rec.Solicit)
                {
                    ApplicationArea = All;
                }
                field(AchizitiiPE; Rec.AchizitiiPE)
                {
                    ApplicationArea = All;
                }
                field(AchizitiiCR; Rec.AchizitiiCR)
                {
                    ApplicationArea = All;
                }
                field(AchizitiiCB; Rec.AchizitiiCB)
                {
                    ApplicationArea = All;
                }
                field(AchizitiiCI; Rec.AchizitiiCI)
                {
                    ApplicationArea = All;
                }
                field(AchizitiiA; Rec.AchizitiiA)
                {
                    ApplicationArea = All;
                }
                field(AchizitiiB24; Rec.AchizitiiB24)
                {
                    ApplicationArea = All;
                }
                field(AchizitiiB20; Rec.AchizitiiB20)
                {
                    ApplicationArea = All;
                }
                field(AchizitiiB19; Rec.AchizitiiB19)
                {
                    ApplicationArea = All;
                }
                field(AchizitiiB9; Rec.AchizitiiB9)
                {
                    ApplicationArea = All;
                }
                field(AchizitiiB5; Rec.AchizitiiB5)
                {
                    ApplicationArea = All;
                }
                field(AchizitiiS24; Rec.AchizitiiS24)
                {
                    ApplicationArea = All;
                }
                field(AchizitiiS20; Rec.AchizitiiS20)
                {
                    ApplicationArea = All;
                }
                field(AchizitiiS19; Rec.AchizitiiS19)
                {
                    ApplicationArea = All;
                }
                field(AchizitiiS9; Rec.AchizitiiS9)
                {
                    ApplicationArea = All;
                }
                field(AchizitiiS5; Rec.AchizitiiS5)
                {
                    ApplicationArea = All;
                }
                field(ImportB; Rec.ImportB)
                {
                    ApplicationArea = All;
                }
                field(AcINecorp; Rec.AcINecorp)
                {
                    ApplicationArea = All;
                }
                field(LivrariBI; Rec.LivrariBI)
                {
                    ApplicationArea = All;
                }
                field(Bun24; Rec.Bun24)
                {
                    ApplicationArea = All;
                }
                field(Bun20; Rec.Bun20)
                {
                    ApplicationArea = All;
                }
                field(Bun19; Rec.Bun19)
                {
                    ApplicationArea = All;
                }
                field(Bun9; Rec.Bun9)
                {
                    ApplicationArea = All;
                }
                field(Bun5; Rec.Bun5)
                {
                    ApplicationArea = All;
                }
                field(ValoareScutit; Rec.ValoareScutit)
                {
                    ApplicationArea = All;
                }
                field(BunTI; Rec.BunTI)
                {
                    ApplicationArea = All;
                }
                field(Prest24; Rec.Prest24)
                {
                    ApplicationArea = All;
                }
                field(Prest20; Rec.Prest20)
                {
                    ApplicationArea = All;
                }
                field(Prest19; Rec.Prest19)
                {
                    ApplicationArea = All;
                }
                field(Prest9; Rec.Prest9)
                {
                    ApplicationArea = All;
                }
                field(Prest5; Rec.Prest5)
                {
                    ApplicationArea = All;
                }
                field(PrestScutit; Rec.PrestScutit)
                {
                    ApplicationArea = All;
                }
                field(LIntra; Rec.LIntra)
                {
                    ApplicationArea = All;
                }
                field(PrestIntra; Rec.PrestIntra)
                {
                    ApplicationArea = All;
                }
                field(Export; Rec.Export)
                {
                    ApplicationArea = All;
                }
                field(LivNecorp; Rec.LivNecorp)
                {
                    ApplicationArea = All;
                }
                field(Efectuat; Rec.Efectuat)
                {
                    ApplicationArea = All;
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

