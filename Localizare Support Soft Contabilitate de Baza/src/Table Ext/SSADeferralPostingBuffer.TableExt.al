tableextension 70070 "SSA Deferral Posting Buffer" extends "Deferral Posting Buffer"
{
    fields
    {
        field(70000; "SSA Correction"; Boolean)
        {
            Caption = 'Correction';
            DataClassification = CustomerContent;
        }
    }
}