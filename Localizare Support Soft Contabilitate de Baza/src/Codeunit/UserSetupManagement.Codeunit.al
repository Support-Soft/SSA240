codeunit 70021 "SSA User Setup Management"
{
    trigger OnRun()
    begin

    end;

    procedure GetIntConsumptionFilter(): Code[10]
    begin
        //SSA937>>
        if not HasGotSalesUserSetup then begin
            CompanyInfo.GET;
            UserRespCenter := CompanyInfo."Responsibility Center";
            UserLocation := CompanyInfo."Location Code";
            if (UserSetup.GET(USERID)) and (USERID <> '') then
                if UserSetup."Sales Resp. Ctr. Filter" <> '' then
                    UserRespCenter := UserSetup."Sales Resp. Ctr. Filter";
            HasGotSalesUserSetup := true;
        end;
        exit(UserRespCenter);
        //SSA937<<"
    end;

    var
        CompanyInfo: Record "Company Information";
        UserSetup: Record "User Setup";
        UserRespCenter: Code[10];
        UserLocation: Code[10];
        HasGotSalesUserSetup: Boolean;
}