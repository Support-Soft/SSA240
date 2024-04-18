table 72001 "SSAEDEDocuments Setup"
{
    Caption = 'E-Documents Setup';
    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            Caption = 'Primary Key';
            DataClassification = CustomerContent;
        }
        field(10; "Client ID"; Text[250])
        {
            Caption = 'Client ID';
            DataClassification = CustomerContent;
        }
        field(20; "Client Secret"; Text[250])
        {
            Caption = 'Client Secret';
            DataClassification = CustomerContent;
            ExtendedDatatype = Masked;
        }
        field(30; "Redirect URL"; Text[250])
        {
            Caption = 'Redirect URL';
            DataClassification = CustomerContent;
        }
        field(40; "Auth. URL Parms"; Text[250])
        {
            Caption = 'Auth. URL Parms';
            DataClassification = CustomerContent;
        }
        field(50; Scope; Text[250])
        {
            Caption = 'Scope';
            DataClassification = CustomerContent;
        }
        field(60; "Authorization URL"; Text[250])
        {
            Caption = 'Authorization URL';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                if "Authorization URL" <> '' then
                    WebRequestHelper.IsSecureHttpUrl("Authorization URL");
            end;
        }
        field(70; "Access Token URL"; Text[250])
        {
            Caption = 'Access Token URL';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                if "Access Token URL" <> '' then
                    WebRequestHelper.IsSecureHttpUrl("Access Token URL");
            end;
        }
        field(80; Status; Option)
        {
            Caption = 'Status';
            DataClassification = CustomerContent;
            OptionCaption = ' ,Enabled,Disabled,Connected,Error';
            OptionMembers = " ",Enabled,Disabled,Connected,Error;
        }
        field(90; "Access Token Opaque"; Text[250])
        {
            Caption = 'Access Token Opaque';
            DataClassification = CustomerContent;
            ExtendedDatatype = Masked;
            trigger OnValidate()
            begin
                TestField("Token Type", Rec."Token Type"::Opaque);
                Validate("Authorization Time", CurrentDateTime);
                if "Expires In" = 0 then
                    Validate("Expires In", 7776000);
            end;
        }
        field(100; "Refresh Token Opaque"; Text[250])
        {
            Caption = 'Refresh Token Opaque';
            DataClassification = CustomerContent;
            ExtendedDatatype = Masked;
            trigger OnValidate()
            begin
                TestField("Token Type", Rec."Token Type"::Opaque);
            end;
        }
        field(110; "Authorization Time"; DateTime)
        {
            Caption = 'Authorization Time';
            DataClassification = CustomerContent;
        }
        field(120; "Expires In"; Integer)
        {
            Caption = 'Expires In';
            DataClassification = CustomerContent;
        }
        field(130; "Ext. Expires In"; Integer)
        {
            Caption = 'Ext. Expires In';
            DataClassification = CustomerContent;
        }
        field(140; "Grant Type"; Option)
        {
            Caption = 'Grant Type';
            DataClassification = CustomerContent;
            OptionMembers = "Authorization Code","Password Credentials","Client Credentials";
        }
        field(150; "User Name"; Text[80])
        {
            Caption = 'User Name';
            DataClassification = CustomerContent;
        }
        field(160; Password; Text[20])
        {
            Caption = 'Password';
            DataClassification = CustomerContent;
            ExtendedDatatype = Masked;
        }
        field(170; "EFactura Stare Mesaj URL"; Text[250])
        {
            Caption = 'EFactura Stare Mesaj URL';
            DataClassification = CustomerContent;
        }
        field(180; "EFactura Upload URL"; Text[250])
        {
            Caption = 'EFactura Upload URL';
            DataClassification = CustomerContent;
        }
        field(190; "EFactura Descarcare URL"; Text[250])
        {
            Caption = 'EFactura Descarcare URL';
            DataClassification = CustomerContent;
        }
        field(200; "EFactura ListaMesaje URL"; Text[250])
        {
            Caption = 'EFactura ListaMesaje URL';
            DataClassification = CustomerContent;
        }
        field(210; "EFactura Test Stare Mesaj URL"; Text[250])
        {
            Caption = 'EFactura Test Stare Mesaj URL';
            DataClassification = CustomerContent;
        }
        field(220; "EFactura Test Upload URL"; Text[250])
        {
            Caption = 'EFactura Test Upload URL';
            DataClassification = CustomerContent;
        }
        field(230; "EFactura Test Descarcare URL"; Text[250])
        {
            Caption = 'EFactura Test Descarcare URL';
            DataClassification = CustomerContent;
        }
        field(240; "EFactura Test ListaMesaje URL"; Text[250])
        {
            Caption = 'EFactura Test ListaMesaje URL';
            DataClassification = CustomerContent;
        }
        field(250; "EFactura Mod Test"; Boolean)
        {
            Caption = 'EFactura Mod Test';
            DataClassification = CustomerContent;
        }
        field(260; "EFactura Enable API"; Boolean)
        {
            Caption = 'EFactura Enable API';
            DataClassification = CustomerContent;
        }
        field(270; "EFactura Email Address for JOB"; Text[250])
        {
            Caption = 'EFactura Email Address for JOB';
            DataClassification = CustomerContent;
        }
        field(280; "No. of StareMesaj Requests"; Integer)
        {
            Caption = 'No. of StareMesaj Requests';
            DataClassification = CustomerContent;
        }
        field(290; "Nr. Zile Preluare ListaMesaje"; Integer)
        {
            Caption = 'Nr. Zile Preluare ListaMesaje';
            DataClassification = CustomerContent;
        }
        field(300; "URL EFactura PDF"; Text[250])
        {
            Caption = 'URL EFactura PDF';
            DataClassification = CustomerContent;
        }
        field(310; "Block Posting Sales Doc Before"; Integer)
        {
            Caption = 'Block Posting Sales Doc Before';
            DataClassification = CustomerContent;
        }
        field(320; "Token Type"; Enum SSAEDTokenType)
        {
            Caption = 'Token Type';
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                Clear("Authorization Time");
                Clear("Expires In");
            end;
        }
        field(330; "Access Token JWT"; Blob)
        {
            Caption = 'Access Token JWT';
            DataClassification = CustomerContent;
        }
        field(340; "Refresh Token JWT"; Blob)
        {
            Caption = 'Refresh Token JWT';
            DataClassification = CustomerContent;
        }
        field(350; "Master Token Company"; Text[30])
        {
            Caption = 'Master Token Company';
            DataClassification = CustomerContent;
            TableRelation = Company.Name;
        }
    }

    keys
    {
        key(Key1; "Primary Key")
        {
        }
    }
    var
        WebRequestHelper: Codeunit "Web Request Helper";

    procedure SetTokenJWT(_Text: Text)
    var
        OutStr: OutStream;
    begin
        TestField("Token Type", Rec."Token Type"::JWT);
        Rec."Access Token JWT".CreateOutStream(OutStr);
        OutStr.WriteText(_Text);
        Validate("Authorization Time", CurrentDateTime);
        if "Expires In" = 0 then
            Validate("Expires In", 7776000);

    end;

    procedure SetRefreshTokenJWT(_Text: Text)
    var
        OutStr: OutStream;
    begin
        TestField("Token Type", Rec."Token Type"::JWT);
        Rec."Refresh Token JWT".CreateOutStream(OutStr);
        OutStr.WriteText(_Text);
    end;

    local procedure GetTokenJWT() TxtVar: Text
    var
        InStr: InStream;
    begin
        Clear(TxtVar);
        Rec.CalcFields("Access Token JWT");
        if Rec."Access Token JWT".HasValue then
            Rec."Access Token JWT".CreateInStream(InStr);

        InStr.ReadText(TxtVar);
    end;

    procedure GetRefreshTokenJWT() TxtVar: Text
    var
        InStr: InStream;
    begin
        Clear(TxtVar);
        Rec.CalcFields("Refresh Token JWT");
        if Rec."Refresh Token JWT".HasValue then
            Rec."Refresh Token JWT".CreateInStream(InStr);
        InStr.ReadText(TxtVar);
    end;

    procedure GetCurrentToken() TxtVar: Text
    begin
        case Rec."Token Type" of
            Rec."Token Type"::Opaque:
                TxtVar := Rec."Access Token Opaque";
            Rec."Token Type"::JWT:
                TxtVar := GetTokenJWT();
            else
                Error('Invalid Token Type %1', Rec."Token Type");
        end;
        exit(TxtVar);
    end;
}

