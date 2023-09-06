page 72001 "SSAEDEDocuments Setup"
{
    Caption = 'E-Documents Setup';
    PageType = Card;
    SourceTable = "SSAEDEDocuments Setup";
    ApplicationArea = All;
    UsageCategory = Administration;
    layout
    {
        area(content)
        {
            group(General)
            {
            }
            group(Autorizare)
            {
                field("Authorization URL"; Rec."Authorization URL")
                {
                    ToolTip = 'URL-ul de autorizare';
                }
                field("Client ID"; Rec."Client ID")
                {
                    ToolTip = 'Client ID-ul';
                }
                field("Client Secret"; Rec."Client Secret")
                {
                    ToolTip = 'Client Secret-ul';
                }
                field("Redirect URL"; Rec."Redirect URL")
                {
                    ToolTip = 'Redirect URL-ul';
                }
                field("Auth. URL Parms"; Rec."Auth. URL Parms")
                {
                    ToolTip = 'Parametrii de autorizare';
                }
                field(Scope; Rec.Scope)
                {
                    ToolTip = 'Scope-ul';
                }
                field("Access Token URL"; Rec."Access Token URL")
                {
                    ToolTip = 'URL-ul de accesare a token-ului';
                }
                field("Authorization Time"; Rec."Authorization Time")
                {
                    ToolTip = 'Timpul de autorizare';
                }
                field("Expires In"; Rec."Expires In")
                {
                    ToolTip = 'Timpul de expirare';
                }
                field(Status; Rec.Status)
                {
                    ToolTip = 'Statusul';
                }
                field("Ext. Expires In"; Rec."Ext. Expires In")
                {
                    ToolTip = 'Timpul de expirare extins';
                }
                field("Grant Type"; Rec."Grant Type")
                {
                    ToolTip = 'Tipul de grant';
                }
                field("User Name"; Rec."User Name")
                {
                    ToolTip = 'Numele utilizatorului';
                }
                field(Password; Rec.Password)
                {
                    ToolTip = 'Parola';
                }
                field("Access Token"; Rec."Access Token")
                {
                    ToolTip = 'Token-ul de acces';
                }
            }
            group(EFactura)
            {
                field("EFactura Stare Mesaj URL"; Rec."EFactura Stare Mesaj URL")
                {
                    ToolTip = 'URL-ul de stare mesaj';
                }
                field("EFactura Upload URL"; Rec."EFactura Upload URL")
                {
                    ToolTip = 'URL-ul de upload';
                }
                field("EFactura Descarcare URL"; Rec."EFactura Descarcare URL")
                {
                    ToolTip = 'URL-ul de descarcare';
                }
                field("EFactura ListaMesaje URL"; Rec."EFactura ListaMesaje URL")
                {
                    ToolTip = 'URL-ul de lista mesaje';
                }
                field("EFactura Test Stare Mesaj URL"; Rec."EFactura Test Stare Mesaj URL")
                {
                    ToolTip = 'URL-ul de stare mesaj test';
                }
                field("EFactura Test Upload URL"; Rec."EFactura Test Upload URL")
                {
                    ToolTip = 'URL-ul de upload test';
                }
                field("EFactura Test Descarcare URL"; Rec."EFactura Test Descarcare URL")
                {
                    ToolTip = 'URL-ul de descarcare test';
                }
                field("EFactura Test ListaMesaje URL"; Rec."EFactura Test ListaMesaje URL")
                {
                    ToolTip = 'URL-ul de lista mesaje test';
                }
                field("EFactura Mod Test"; Rec."EFactura Mod Test")
                {
                    ToolTip = 'Modul de test';
                }
                field("EFactura Enable API"; Rec."EFactura Enable API")
                {
                    ToolTip = 'Activarea API-ului';
                }
                field("EFactura Email Address for JOB"; Rec."EFactura Email Address for JOB")
                {
                    ToolTip = 'Adresa de email pentru JOB';
                }
                field("No. of StareMesaj Requests"; Rec."No. of StareMesaj Requests")
                {
                    ToolTip = 'Numarul de cereri de stare mesaj';
                }
                field("Nr. Zile Preluare ListaMesaje"; Rec."Nr. Zile Preluare ListaMesaje")
                {
                    ToolTip = 'Specifies the value of the Nr. Zile Preluare ListaMesaje field.';
                }
            }
            group(ETransport)
            {
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage()
    begin
        Rec.Reset;
        if not Rec.Get then begin
            Rec.Init;
            Rec.Insert;
        end;
    end;
}

