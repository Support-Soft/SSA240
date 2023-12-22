pageextension 72300 "SSAEDE-Documents Log Entries" extends "SSAEDE-Documents Log Entries"
{
    layout
    {
        addlast(Control1)
        {
            field("SSAEDNXML Exported"; Rec."SSAEDNXML Exported")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the XML Exported field.';
            }
        }
    }
}