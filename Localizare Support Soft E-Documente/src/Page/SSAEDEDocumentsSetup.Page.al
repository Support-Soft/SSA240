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
                field("Token Type"; Rec."Token Type")
                {
                    ToolTip = 'Specifies the value of the Token Type field.';
                    trigger OnValidate()
                    begin
                        SetTokenVisibility();
                        CurrPage.Update(true);
                    end;
                }
                field("Access Token"; Rec."Access Token Opaque")
                {
                    Enabled = ShowOpaque;
                    ToolTip = 'Token-ul de acces';
                }
                field("Refresh Token"; Rec."Refresh Token Opaque")
                {
                    Enabled = ShowOpaque;
                    ToolTip = 'Specifies the value of the Refresh Token field.';
                }
                field(JWTTokenTextField; JWTTokenText)
                {
                    Caption = 'JWT Token';
                    Enabled = ShowJWT;
                    ToolTip = 'Token-ul de acces JWT';
                    ExtendedDatatype = Masked;
                    trigger OnValidate()
                    begin
                        Rec.SetTokenJWT(JWTTokenText);
                        Rec.Modify(true);
                    end;
                }
                field(JWTRefreshTokenTextField; JWTRefreshTokenText)
                {
                    Caption = 'JWT Refresh Token';
                    Enabled = ShowJWT;
                    ToolTip = 'Specifies the value of the JWT Refresh Token field.';
                    ExtendedDatatype = Masked;
                    trigger OnValidate()
                    begin
                        Rec.SetRefreshTokenJWT(JWTRefreshTokenText);
                        Rec.Modify(true);
                    end;
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
                field("URL EFactura PDF"; Rec."URL EFactura PDF")
                {
                    ToolTip = 'Specifies the value of the URL EFactura PDF field.';
                }
                field("Block Posting Sales Doc Before"; Rec."Block Posting Sales Doc Before")
                {
                    ToolTip = 'Specifies the value of the Block Posting Sales Doc Before field.';
                }
            }
            group(ETransport)
            {
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(RefreshToken)
            {
                Caption = 'Refresh Token';
                Promoted = true;
                Image = Refresh;
                ToolTip = 'Update Token using Refresh Token';
                ApplicationArea = All;
                trigger OnAction()
                var
                    ANAFAPIMgt: Codeunit "SSAEDANAF API Mgt";
                begin
                    if not CONFIRM('Update Token using Refresh Token?') then
                        exit;
                    ANAFAPIMgt.RefreshToken(Rec);
                    CurrPage.UPDATE;

                    MESSAGE('Token has been updated.');
                end;
            }

        }
    }
    var
        JWTTokenText: Text;
        JWTRefreshTokenText: Text;
        ShowOpaque: Boolean;
        ShowJWT: Boolean;

    trigger OnOpenPage()
    begin
        Rec.Reset;
        if not Rec.Get then begin
            Rec.Init;
            Rec.Insert;
        end;
        SetTokenVisibility;
    end;

    trigger OnAfterGetRecord()
    begin

    end;

    local procedure SetTokenVisibility()
    begin
        Clear(JWTTokenText);
        Clear(JWTRefreshTokenText);
        Clear(ShowOpaque);
        Clear(ShowJWT);
        Rec.CalcFields("Access Token JWT", "Refresh Token JWT");
        case Rec."Token Type" of
            Rec."Token Type"::Opaque:
                ShowOpaque := true;
            Rec."Token Type"::JWT:
                begin
                    ShowJWT := true;
                    if Rec."Access Token JWT".HasValue then
                        JWTTokenText := '***';
                    if Rec."Refresh Token JWT".HasValue then
                        JWTRefreshTokenText := '***';
                end;
        end;
    end;
}

