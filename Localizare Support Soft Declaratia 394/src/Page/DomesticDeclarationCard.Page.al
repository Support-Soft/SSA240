page 71701 "SSA Domestic Declaration Card"
{
    // SSA973 SSCAT 06.09.2019 39.Rapoarte legale- Localizare Declaratia 394

    PageType = Card;
    SourceTable = "SSA Domestic Declaration";

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Code"; Code)
                {
                    ApplicationArea = All;
                }
                field(Description; Description)
                {
                    ApplicationArea = All;
                }
                field(Reported; Reported)
                {
                    ApplicationArea = All;
                }
                field("Starting Date"; "Starting Date")
                {
                    ApplicationArea = All;
                    Editable = DatesEditable;
                }
                field("Ending Date"; "Ending Date")
                {
                    ApplicationArea = All;
                    Editable = DatesEditable;
                }
                field(TipD394; TipD394)
                {
                    ApplicationArea = All;
                    trigger OnValidate()
                    begin
                        if TipD394 = TipD394::L then
                            DatesEditable := false
                        else
                            DatesEditable := true;
                    end;
                }
                field(Perioada; Perioada)
                {
                    ApplicationArea = All;
                }
                field("Optiune verificare date"; "Optiune verificare date")
                {
                    ApplicationArea = All;
                }
                field("Schimb Optiune verificare date"; "Schimb Optiune verificare date")
                {
                    ApplicationArea = All;
                }
                field("Nr de AMEF"; "Nr de AMEF")
                {
                    ApplicationArea = All;
                }
                field("Tranzactii Persoane Afiliate"; "Tranzactii Persoane Afiliate")
                {
                    ApplicationArea = All;
                }
                field("Copy Declaration Info from"; "Copy Declaration Info from")
                {
                    ApplicationArea = All;
                }
            }
            group(Declarant)
            {
                Caption = 'Declarant';
                group("Sectiunea A")
                {
                    field("Telefon Companie"; "Telefon Companie")
                    {
                        ApplicationArea = All;
                    }
                    field("Fax Companie"; "Fax Companie")
                    {
                        ApplicationArea = All;
                    }
                    field("E-Mail Companie"; "E-Mail Companie")
                    {
                        ApplicationArea = All;
                    }
                }
                group("Sectiunea B1")
                {
                    field("Nume Reprezentant"; "Nume Reprezentant")
                    {
                        ApplicationArea = All;
                    }
                    field("CNP Reprezentant"; "CNP Reprezentant")
                    {
                        ApplicationArea = All;
                    }
                    field("Functie Declaratie"; "Functie Declaratie")
                    {
                        ApplicationArea = All;
                    }
                    field("Adresa Reprezentant"; "Adresa Reprezentant")
                    {
                        ApplicationArea = All;
                    }
                    field("Tel. Reprezentant"; "Tel. Reprezentant")
                    {
                        ApplicationArea = All;
                    }
                    field("E-mail Reprezentant"; "E-mail Reprezentant")
                    {
                        ApplicationArea = All;
                    }
                    field("Fax Reprezentant"; "Fax Reprezentant")
                    {
                        ApplicationArea = All;
                    }
                }
                group("Sectiunea B2")
                {
                    field("Tip Intocmit"; "Tip Intocmit")
                    {
                        ApplicationArea = All;
                    }
                    field("Nume Intocmit"; "Nume Intocmit")
                    {
                        ApplicationArea = All;
                    }
                    field("Functie Intocmit"; "Functie Intocmit")
                    {
                        ApplicationArea = All;
                    }
                    field("Calitate Intocmit"; "Calitate Intocmit")
                    {
                        ApplicationArea = All;
                    }
                    field("CIF Intocmit"; "CIF Intocmit")
                    {
                        ApplicationArea = All;
                    }
                }
            }
            group(Request)
            {
                Caption = 'Request';
                field(Solicit; Solicit)
                {
                    ApplicationArea = All;
                }
                field(AchizitiiPE; AchizitiiPE)
                {
                    ApplicationArea = All;
                }
                field(AchizitiiCR; AchizitiiCR)
                {
                    ApplicationArea = All;
                }
                field(AchizitiiCB; AchizitiiCB)
                {
                    ApplicationArea = All;
                }
                field(AchizitiiCI; AchizitiiCI)
                {
                    ApplicationArea = All;
                }
                field(AchizitiiA; AchizitiiA)
                {
                    ApplicationArea = All;
                }
                field(AchizitiiB24; AchizitiiB24)
                {
                    ApplicationArea = All;
                }
                field(AchizitiiB20; AchizitiiB20)
                {
                    ApplicationArea = All;
                }
                field(AchizitiiB19; AchizitiiB19)
                {
                    ApplicationArea = All;
                }
                field(AchizitiiB9; AchizitiiB9)
                {
                    ApplicationArea = All;
                }
                field(AchizitiiB5; AchizitiiB5)
                {
                    ApplicationArea = All;
                }
                field(AchizitiiS24; AchizitiiS24)
                {
                    ApplicationArea = All;
                }
                field(AchizitiiS20; AchizitiiS20)
                {
                    ApplicationArea = All;
                }
                field(AchizitiiS19; AchizitiiS19)
                {
                    ApplicationArea = All;
                }
                field(AchizitiiS9; AchizitiiS9)
                {
                    ApplicationArea = All;
                }
                field(AchizitiiS5; AchizitiiS5)
                {
                    ApplicationArea = All;
                }
                field(ImportB; ImportB)
                {
                    ApplicationArea = All;
                }
                field(AcINecorp; AcINecorp)
                {
                    ApplicationArea = All;
                }
                field(LivrariBI; LivrariBI)
                {
                    ApplicationArea = All;
                }
                field(Bun24; Bun24)
                {
                    ApplicationArea = All;
                }
                field(Bun20; Bun20)
                {
                    ApplicationArea = All;
                }
                field(Bun19; Bun19)
                {
                    ApplicationArea = All;
                }
                field(Bun9; Bun9)
                {
                    ApplicationArea = All;
                }
                field(Bun5; Bun5)
                {
                    ApplicationArea = All;
                }
                field(ValoareScutit; ValoareScutit)
                {
                    ApplicationArea = All;
                }
                field(BunTI; BunTI)
                {
                    ApplicationArea = All;
                }
                field(Prest24; Prest24)
                {
                    ApplicationArea = All;
                }
                field(Prest20; Prest20)
                {
                    ApplicationArea = All;
                }
                field(Prest19; Prest19)
                {
                    ApplicationArea = All;
                }
                field(Prest9; Prest9)
                {
                    ApplicationArea = All;
                }
                field(Prest5; Prest5)
                {
                    ApplicationArea = All;
                }
                field(PrestScutit; PrestScutit)
                {
                    ApplicationArea = All;
                }
                field(LIntra; LIntra)
                {
                    ApplicationArea = All;
                }
                field(PrestIntra; PrestIntra)
                {
                    ApplicationArea = All;
                }
                field(Export; Export)
                {
                    ApplicationArea = All;
                }
                field(LivNecorp; LivNecorp)
                {
                    ApplicationArea = All;
                }
                field(Efectuat; Efectuat)
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
        if TipD394 = TipD394::L then
            DatesEditable := false
        else
            DatesEditable := true;
    end;

    var
        [InDataSet]
        DatesEditable: Boolean;
}

