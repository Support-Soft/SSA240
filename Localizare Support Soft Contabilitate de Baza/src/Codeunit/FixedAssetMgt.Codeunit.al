codeunit 70016 "SSA Fixed Asset Mgt"
{
    // SSA957 SSCAT 23.08.2019 23.Funct. Obiecte de inventar: lista si fisa obiecte de inventar, punere in functiune, full description


    trigger OnRun()
    begin
    end;

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
        with Rec do begin
            TestField("SSA Type");
            if "No." = '' then begin
                case "SSA Type" of
                    "SSA Type"::"Fixed Asset":
                        begin
                            SSASetup.Get;
                            SSASetup.TestField("Fixed Asset Nos.");
                            NoSeriesMgt.InitSeries(SSASetup."Fixed Asset Nos.", "No. Series", 0D, "No.", "No. Series");
                        end;
                    "SSA Type"::Inventory:
                        begin
                            SSASetup.Get;
                            SSASetup.TestField("Fixed Asset Inventory Nos.");
                            NoSeriesMgt.InitSeries(SSASetup."Fixed Asset Inventory Nos.", "No. Series", 0D, "No.", "No. Series");
                        end;
                    else
                        Error(Text001, "SSA Type");
                end;
            end;
        end;
        //SSA957<<
    end;
}

