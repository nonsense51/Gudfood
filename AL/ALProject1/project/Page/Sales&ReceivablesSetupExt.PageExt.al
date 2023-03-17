pageextension 50110 "Sales&ReceivablesSetupExt" extends "Sales & Receivables Setup"
{
    layout
    {
        addlast("Number Series")
        {
            field("Gudfood Item Nos."; Rec."Gudfood Item Nos.")
            {
                ApplicationArea = Basic, Suite;
                ToolTip = 'Specifies the code for the number series that will be used to assign numbers to Gudfood Items.';
            }

            field("Gudfood Order Nos."; Rec."Gudfood Order Nos.")
            {
                ApplicationArea = Basic, Suite;
                ToolTip = 'Specifies the code for the number series that will be used to assign numbers to Gudfood Orders.';
            }
            field("Posted Gudfood Order Nos."; Rec."Posted Gudfood Order Nos.")
            {
                ApplicationArea = Basic, Suite;
                ToolTip = 'Specifies the code for the number series that will be used to assign numbers to Posting Gudfood Orders.';
            }
        }

    }


}