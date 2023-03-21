tableextension 50050 "Sales & Receivables Setup Ext." extends "Sales & Receivables Setup"
{
    fields
    {
        field(50000; "Gudfood Order Nos."; Code[20])
        {
            Caption = 'Gudfood Order Nos.';
            TableRelation = "No. Series";
        }
        field(50001; "Posted Gudfood Order Nos."; Code[20])
        {
            Caption = 'Posted Gudfood Order Nos.';
            TableRelation = "No. Series";
        }
        field(50003; "Gudfood Item Nos."; Code[20])
        {
            Caption = 'Gudfood Item Nos.';
            TableRelation = "No. Series";
        }
    }
}