codeunit 70016 "SSA Fixed Asset Mgt"
{
    var
        Text001: Label 'Type %1 not recognized.';

    [EventSubscriber(ObjectType::Table, 5600, 'OnBeforeInsertEvent', '', false, false)]
    local procedure FixedAssetOnBeforeInsert(var Rec: Record "Fixed Asset"; RunTrigger: Boolean)
    var
        SSASetup: Record "SSA Localization Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;
    begin
        //SSA957>>
        if not RunTrigger then
            exit;
        Rec.TestField("SSA Type");
        if Rec."No." = '' then
            case Rec."SSA Type" of
                Rec."SSA Type"::"Fixed Asset":
                    begin
                        SSASetup.Get();
                        SSASetup.TestField("Fixed Asset Nos.");
                        NoSeriesMgt.InitSeries(SSASetup."Fixed Asset Nos.", Rec."No. Series", 0D, Rec."No.", Rec."No. Series");
                    end;
                Rec."SSA Type"::Inventory:
                    begin
                        SSASetup.Get();
                        SSASetup.TestField("Fixed Asset Inventory Nos.");
                        NoSeriesMgt.InitSeries(SSASetup."Fixed Asset Inventory Nos.", Rec."No. Series", 0D, Rec."No.", Rec."No. Series");
                    end;
                else
                    Error(Text001, Rec."SSA Type");
            end;
        //SSA957<<
    end;
}
