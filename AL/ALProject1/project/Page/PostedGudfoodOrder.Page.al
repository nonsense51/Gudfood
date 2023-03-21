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
                    ToolTip = 'Specifies the order number';
                }
                field("Sell- to Customer No."; Rec."Sell- to Customer No.")
                {
                    Caption = 'Customer Number';
                    ToolTip = 'Specifies customer number';
                }
                field("Sell-to Customer Name"; Rec."Sell-to Customer Name")
                {
                    Caption = 'Customer Name';
                    ToolTip = 'Specifies customer name';
                    Editable = false;
                }
                field("Order Date"; Rec."Order Date")
                {
                    ToolTip = 'Specifies the order date';
                }
                field("Posting No."; Rec."Posting No.")
                {
                    ToolTip = 'Specifies the posting number';
                }
                field("Date Created"; Rec."Date Created")
                {
                    ToolTip = 'Date of created document';
                }
                field("Total Qty"; Rec."Total Qty")
                {
                    ToolTip = 'Total quantity of ordered products';
                }
                field("Total Amount"; Rec."Total Amount")
                {
                    ToolTip = 'Total price of ordered products';
                }
            }

            part(PostedGudfoodOrderSubpage; "Posted Gudfood Order Subpage")
            {
                SubPageLink = "Order No." = field("No.");
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action("Print Document")
            {
                ToolTip = 'To print report';
                Image = PrintDocument;
                Promoted = true;
                PromotedIsBig = true;
                PromotedOnly = true;

                trigger OnAction()
                var
                    PostedGudfoodOrderReport: Report "Posted Gudfood Order";
                begin
                    CurrPage.SetSelectionFilter(Rec);
                    PostedGudfoodOrderReport.SetGlobalVar(Rec);
                    PostedGudfoodOrderReport.Run();
                end;
            }
        }
        area(navigation)
        {
            action(Dimensions)
            {
                ToolTip = 'To see the dimensions';
                Image = Dimensions;
                Promoted = true;
                ShortCutKey = 'Shift+Ctrl+D';

                trigger OnAction()
                begin
                    Rec.ShowDocDim();
                end;
            }

        }
    }
}

