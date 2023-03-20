page 50008 "Gudfood Order"
{
    Caption = 'Gudfood Order';
    PageType = Document;
    SourceTable = "Gudfood Order Header";

    layout
    {
        area(content)
        {
            // test
            group(General)
            {
                Caption = 'General';
                field("No."; Rec."No.")
                {
                    ToolTip = 'Specifies the order number';
                    TableRelation = "Gudfood Order Header"."No.";
                    Editable = false;
                }
                field("Sell- to Customer No."; Rec."Sell- to Customer No.")
                {
                    Caption = 'Customer Number';
                    ToolTip = 'To specify customer number';
                }
                field("Sell-to Customer Name"; Rec."Sell-to Customer Name")
                {
                    Caption = 'Customer Name';
                    ToolTip = 'Specifies customer name';
                }
                field("Order Date"; Rec."Order Date")
                {
                    ToolTip = 'To specify the order date';
                    Style = Attention;
                    StyleExpr = ChangeClr;
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
            part(GudfoodOrderSubpage; "Gudfood Order Subpage")
            {
                SubPageLink = "Order No." = field("No.");
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(Post)
            {
                ToolTip = 'To post order to the Posted Documents';
                Image = PostedOrder;
                Promoted = true;

                trigger OnAction()
                begin
                    GudfoodPost.Run(Rec);
                end;
            }
            action("Post and Print")
            {
                ToolTip = 'To post order to the Posted Documents and print report';
                Image = PrintReport;
                Promoted = true;

                trigger OnAction()
                begin
                    GudfoodPostPrint.Run(Rec);
                end;
            }
            group(PrintAndExportDocument)
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
                        GudfoodOrderPrint: Report "Gudfood Order";
                    begin
                        CurrPage.SetSelectionFilter(Rec);
                        GudfoodOrderPrint.SetGlobalVar(Rec);
                        GudfoodOrderPrint.Run();
                    end;
                }
                action("Export Order")
                {
                    ToolTip = 'To export order to Xml file';
                    Image = Export;
                    Promoted = true;
                    PromotedIsBig = true;
                    PromotedOnly = true;

                    trigger OnAction()
                    begin
                        CurrPage.SetSelectionFilter(Rec);
                        XMLPORT.Run(50000, false, false, Rec);
                    end;
                }
            }
        }
        area(navigation)
        {
            action(Dimensions)
            {
                ToolTip = 'To see the dimensions';
                Image = Dimensions;
                ShortCutKey = 'Shift+Ctrl+D';

                trigger OnAction()
                begin
                    Rec.ShowDocDim();
                    CurrPage.SaveRecord();
                end;
            }

        }
    }

    trigger OnAfterGetRecord()
    begin
        UpdateColor();
    end;

    var
        GudfoodPost: Codeunit "Gudfood Post";
        GudfoodPostPrint: Codeunit "Gudfood Post + Print";

        [InDataSet]
        ChangeClr: Boolean;


    local procedure UpdateColor()
    begin
        if Rec."Order Date" < Today then
            ChangeClr := true
        else
            ChangeClr := false;
    end;
}

