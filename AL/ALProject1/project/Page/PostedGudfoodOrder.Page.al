page 50009 "Posted Gudfood Order"
{
    Caption = 'Posted Gudfood Order';
    Editable = false;
    PageType = Document;
    SourceTable = "Posted Gudfood Order Header";

    layout
    {
        area(content)
        {
            group(General)
            {
                field("No."; "No.")
                {
                }
                field("Sell- to Customer No."; "Sell- to Customer No.")
                {
                }
                field("Sell-to Customer Name"; "Sell-to Customer Name")
                {
                    Editable = false;
                }
                field("Order Date"; "Order Date")
                {
                }
                field("Posting No."; "Posting No.")
                {
                }
                field("Date Created"; "Date Created")
                {
                }
                field("Total Qty"; "Total Qty")
                {
                }
                field("Total Amount"; "Total Amount")
                {
                }
                field("No. Series"; "No. Series")
                {
                }
            }

            part(PostedGudfoodOrderSubpage; "Posted Gudfood Order Subpage")
            {
                SubPageLink = "Order No." = FIELD("No.");
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group(Navigation)
            {
                action(Dimensions)
                {
                    Image = Dimensions;
                    Promoted = true;
                    ShortCutKey = 'Shift+Ctrl+D';

                    trigger OnAction()
                    begin
                        ShowDocDim;
                    end;
                }
            }
        }
    }
}

