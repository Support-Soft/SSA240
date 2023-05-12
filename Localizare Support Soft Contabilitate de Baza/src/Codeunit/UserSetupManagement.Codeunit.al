codeunit 70021 "SSA User Setup Management"
{
    trigger OnRun()
    begin

    end;

    procedure GetIntConsumptionFilter(): Code[10]
    begin
        //SSA937>>
        IF NOT HasGotSalesUserSetup THEN BEGIN
            CompanyInfo.GET;
            UserRespCenter := CompanyInfo."Responsibility Center";
            UserLocation := CompanyInfo."Location Code";
            IF (UserSetup.GET(USERID)) AND (USERID <> '') THEN
                IF UserSetup."Sales Resp. Ctr. Filter" <> '' THEN
                    UserRespCenter := UserSetup."Sales Resp. Ctr. Filter";
            HasGotSalesUserSetup := TRUE;
        END;
        EXIT(UserRespCenter);
        //SSA937<<"
    end;

    var
        CompanyInfo: Record "Company Information";
        UserSetup: Record "User Setup";
        UserRespCenter: Code[10];
        UserLocation: Code[10];
        HasGotSalesUserSetup: Boolean;
}