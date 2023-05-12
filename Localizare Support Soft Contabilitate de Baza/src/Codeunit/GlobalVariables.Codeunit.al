codeunit 70011 "SSA Global Variables"

{
    SingleInstance = true;
    trigger OnRun()
    begin

    end;

    var
        DeferralCorrection: Boolean;

    procedure SetDeferralCorrection(_DeferralCorrection: Boolean)

    begin
        DeferralCorrection := _DeferralCorrection;
    end;

    procedure GetDeferralCorrection(): Boolean;

    begin
        exit(DeferralCorrection);
    end;
}