report 71900 "SSAFTSAFT Copy Mapping"
{
    // SSM2101 SSCAT 04.01.2023 SAF-T

    Caption = 'SAFT Copy Mapping';
    ProcessingOnly = true;

    dataset
    {
        dataitem("Integer"; "Integer")
        {
            MaxIteration = 1;

            trigger OnAfterGetRecord()
            var
                SAFTMappingHelper: Codeunit "SSAFTSAFT Mapping Helper";
            begin
                SAFTMappingHelper.CopyMapping(FromMappingRangeCode, ToMappingRangeCode, Replace);
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group(Control1080003)
                {
                    ShowCaption = false;
                    field(MappingRangeID; FromMappingRangeCode)
                    {
                        ApplicationArea = All;
                        Caption = 'Copy From';
                        ToolTip = 'Specifies the mapping range code to copy mapping from';

                        trigger OnLookup(var Text: Text): Boolean
                        var
                            NewSAFTMappingRange: Record "SSAFTSAFT Mapping Range";
                        begin
                            NewSAFTMappingRange.SetFilter(Code, '<>%1', ToMappingRangeCode);
                            if PAGE.RunModal(0, NewSAFTMappingRange) = ACTION::LookupOK then
                                FromMappingRangeCode := NewSAFTMappingRange.Code;
                        end;
                    }
                    field(ToMappingRangeCodeField; ToMappingRangeCode)
                    {
                        Caption = 'Copy To';
                        ToolTip = 'Specifies the mapping range code to copy mapping to';
                        Editable = false;
                        ApplicationArea = All;
                    }
                    field(ReplaceField; Replace)
                    {
                        ApplicationArea = All;
                        Caption = 'Replace Existing Mapping';
                        ToolTip = 'Specifies that the existing mapping will be replaced by the mapping range to copy.';
                    }
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    var
        ToMappingRangeCode: Code[20];
        FromMappingRangeCode: Code[20];
        Replace: Boolean;


    procedure InitializeRequest(NewMappingRangeCode: Code[20])
    begin
        ToMappingRangeCode := NewMappingRangeCode;
    end;
}

