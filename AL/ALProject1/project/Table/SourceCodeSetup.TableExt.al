tableextension 50051 "Source Code Setup Ext." extends "Source Code Setup"
{
    fields
    {
        field(50000; GudfoodOrder; Code[10])
        {
            Caption = 'GudfoodOrder';
            TableRelation = "Source Code";
        }
    }
}